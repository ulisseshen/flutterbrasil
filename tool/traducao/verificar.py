#!/usr/bin/env python3
"""Checagens determinísticas das traduções do Flutter Brasil.

    python3 tool/traducao/verificar.py [--ref upstream/main] [--estrito] [arquivos...]

Sem arquivos, confere todas as páginas e parciais marcados com ia-translate
(e as checagens globais). Erros fazem o script sair com código 1 (o CI falha);
avisos só são listados, a menos que se passe --estrito.

Checagens:

ERROS
- conflito:     marcadores de merge (<<<<<<<, |||||||, >>>>>>>) no arquivo.
- frontmatter:  YAML inválido, `ia-translate` que não é o booleano `true` de
                primeiro nível (ex.: colado dentro de um `description: >`) ou
                campo que tem valor no inglês e ficou vazio na tradução.
- flag:         `ia-translate` fora do frontmatter, ou o comentário
                `<!-- ia-translate: true -->` fora da primeira linha de um parcial.
- placeholder:  avisos de "tradução pendente" deixados no texto
                (ex.: "Note for translators", "To be translated").
- ingles:       página marcada como traduzida cuja prosa está em inglês
                (proporção de palavras-função em inglês >= 0.7).
- estrutura:    número de cercas de código, code-excerpts, tags Liquid,
                admonitions ou âncoras {:#} diferente do original em inglês;
                rótulo de link `[texto][rótulo]` sem definição.
- release-notes: página de release/release-notes/ diferente do que
                tool/traducao/traduzir_release_notes.py gera.
- defasada:     o inglês da página mudou no upstream desde o último sync
                (tool/traducao/ultimo-sync-upstream.txt): rode
                sincronizar_upstream.py.
- pendente:     .traducao-pendente/ ainda tem arquivos para resolver.
- ancora:       título traduzido cujo id automático difere do slug em inglês e
                que não tem `{:#id}` explícito (links #ancora quebrariam).
                Corrija com tool/traducao/ancorar_titulos.py <arquivo>.
- link-interno: link para âncora da própria página (`](#id)` ou `[x]: #id`)
                que não existe (títulos, `id="..."` e parciais incluídos).
- dominio:      uso de domínios que não existem (ex.: api.flutterbrasil.dev; a
                documentação de API não é traduzida e fica em api.flutter.dev).
                Conferido em todo o site, não só nas páginas marcadas.

AVISOS
- parcial:      proporção de inglês entre 0.3 e 0.7 (tradução incompleta).
- defs-link:    número de definições de link diferente do original
                (ex.: rótulos antigos sem crase convivendo com os novos).

O que não fica aqui: a sincronia dos code-excerpts com examples/, conferida
por `dart run dash_site --site=docs refresh-excerpts --fail-on-update --dry-run`
(rodado junto no workflow .github/workflows/traducao.yml).
"""
import argparse
import importlib.util
import re

try:
    import yaml
except ImportError:  # pragma: no cover
    yaml = None
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
CONTENT = 'sites/docs/src/content/'
SYNC = ROOT / 'tool' / 'traducao' / 'ultimo-sync-upstream.txt'
PEND = ROOT / '.traducao-pendente'
RELEASE_NOTES = CONTENT + 'release/release-notes/'

FLAG_FM = re.compile(r'^ia-translate:\s*true\s*$', re.M)
FLAG_COMENTARIO = '<!-- ia-translate: true -->'
CONFLITO = re.compile(r'^(<{7} |\|{7} |>{7} )', re.M)
PLACEHOLDER = re.compile(
    r'note for translators|to be translated|requires a dedicated session'
    r'|marked for translation|tradu[çc][ãa]o pendente|todo:? traduzir',
    re.I)
ESTRUTURA = {
    'cercas ```': re.compile(r'^\s*```', re.M),
    'code-excerpt': re.compile(r'<\?code-excerpt'),
    'tags {% %}': re.compile(r'\{%'),
    'admonitions :::': re.compile(r'^\s*:::', re.M),
    'âncoras {:#}': re.compile(r'\{:\s*#'),
}
DEFS_LINK = re.compile(r'^\s*\[[^\]]+\]:\s', re.M)
# Domínios que NÃO existem. Os links de API devem apontar para os oficiais
# (api.flutter.dev, main-api.flutter.dev, api.dart.dev).
DOMINIOS_INEXISTENTES = re.compile(
    r'(?<![\w.-])(?:main-)?api\.flutterbrasil\.dev|(?<![\w.-])api\.dartbrasil\.dev')
PASTAS_DOMINIO = ['sites/docs', 'packages/site_shared/lib', 'tool/config',
                  '.github', 'README.md']

# Palavras-função para estimar o idioma da prosa.
EN = set('the and of to is are you your this that with for in it be can when '
         'which by an or as from have will not these use using'.split())
PT = set('os de do da dos das que é são um uma para com no na nos nas em por '
         'você seu sua ao como mais pode isso este esta'.split())
LIMITE_ERRO, LIMITE_AVISO, MINIMO_PALAVRAS = 0.7, 0.3, 20


def git(*args):
    r = subprocess.run(['git', '-C', str(ROOT), *args], capture_output=True, text=True)
    return r.stdout if r.returncode == 0 else None


def frontmatter(texto):
    m = re.match(r'^---\n(.*?)\n---\n', texto, re.S)
    return (m.group(1), texto[m.end():]) if m else (None, texto)


def sem_codigo(texto):
    return re.sub(r'```.*?```', '', texto, flags=re.S)


def proporcao_ingles(texto):
    _, corpo = frontmatter(texto)
    # Tags HTML/componentes (inclusive multilinha), comentários e Liquid não
    # são prosa: o texto entre tags continua sendo contado.
    corpo = re.sub(r'<!--.*?-->|\{%.*?%\}|<[^<>]*>', ' ', sem_codigo(corpo), flags=re.S)
    linhas = []
    for linha in corpo.split('\n'):
        s = linha.strip()
        if (not s or s.startswith(('<', '{%', '[', '|'))
                or re.match(r'^[*-] .*(by @|\]\(https://github\.com)', s)
                or re.match(r'^\[\d+\]\(', s)):
            continue
        linhas.append(re.sub(r'`[^`]*`|\[[^\]]*\]\[[^\]]*\]|\([^)]*\)|\{[^}]*\}', '', s))
    palavras = re.findall(r"[a-záéíóúãõçê']+", ' '.join(linhas).lower())
    e = sum(p in EN for p in palavras)
    p = sum(p in PT for p in palavras)
    return (e / (e + p), e + p) if e + p else (0.0, 0)


def rotulos_sem_definicao(texto):
    t = sem_codigo(texto)
    defs = {m.lower() for m in re.findall(r'^\s*\[([^\]]+)\]:\s', t, re.M)}
    usados = {(lab or txt).lower()
              for txt, lab in re.findall(r'\[([^\]]+)\]\[([^\]]*)\]', t)}
    # Ignora o que está dentro de código inline (ex.: `map['key'][0]`).
    inline = ' '.join(re.findall(r'`[^`]*`', t)).lower()
    return {r for r in usados - defs if f'[{r}]' not in inline}


def checar_frontmatter(fm, en_fm):
    try:
        dados = yaml.safe_load(fm) or {}
    except yaml.YAMLError as e:
        return [('frontmatter', f'YAML inválido: {str(e).splitlines()[0]}')]
    erros = []
    if dados.get('ia-translate') is not True:
        erros.append(('frontmatter', f'ia-translate não é `true` de primeiro nível '
                                     f'(valor: {str(dados.get("ia-translate"))[:40]!r})'))
    try:
        en = yaml.safe_load(en_fm or '') or {}
    except yaml.YAMLError:
        en = {}
    for chave, valor in en.items():
        if isinstance(valor, str) and valor.strip() and \
                not str(dados.get(chave) or '').strip():
            erros.append(('frontmatter', f'campo `{chave}` vazio (o inglês tem valor)'))
    return erros


def marcados():
    saida = git('grep', '-lE', r'^(ia-translate: true|<!-- ia-translate: true -->)',
                '--', 'sites/docs/src') or ''
    return saida.split()


def carregar_ancorador():
    global ANC_MOD
    caminho = ROOT / 'tool' / 'traducao' / 'ancorar_titulos.py'
    spec = importlib.util.spec_from_file_location('anc', caminho)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    ANC_MOD = mod
    return mod.ancorar


ANCORAR = None
ANC_MOD = None
INCLUDES = ROOT / 'sites' / 'docs' / 'src' / '_includes'
RENDER = re.compile(r'\{%-?\s*(?:render|include)\s+["\']([^"\']+)["\']')


def ids_da_pagina(texto, profundidade=0):
    ids = set(re.findall(r'\bid=["\']([^"\']+)["\']', texto))
    for _, _, txt in ANC_MOD.titulos(texto):
        sem, tokens = ANC_MOD.separar_atributos(txt)
        explicitos = [t[1:] for t in tokens if t.startswith('#')]
        # O id explícito substitui o automático (slug do texto).
        ids.update(explicitos or [ANC_MOD.slug(sem)])
        # O site deduplica ids repetidos com sufixos -1, -2...
    base = set(ids)
    for i in base:
        ids.update(f'{i}-{n}' for n in range(1, 6))
    if profundidade < 3:
        for inc in RENDER.findall(texto):
            arq = INCLUDES / inc
            if arq.exists():
                ids |= ids_da_pagina(arq.read_text(encoding='utf-8'), profundidade + 1)
    return ids


def links_internos_quebrados(texto):
    t = sem_codigo(texto)
    alvos = re.findall(r'\]\(#([^)\s]+)\)', t)
    alvos += re.findall(r'^\s*\[[^\]]+\]:\s*#(\S+)', t, re.M)
    alvos += re.findall(r'href=["\']#([^"\']+)["\']', t)
    ids = ids_da_pagina(texto)
    return sorted({a for a in alvos if a not in ids and '{{' not in a})


def carregar_gerador_release_notes():
    caminho = ROOT / 'tool' / 'traducao' / 'traduzir_release_notes.py'
    spec = importlib.util.spec_from_file_location('trn', caminho)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def checar_arquivo(caminho, ref, sync, gerador):
    erros, avisos = [], []
    texto = (ROOT / caminho).read_text(encoding='utf-8')
    fm, corpo = frontmatter(texto)
    eh_parcial = '/_includes/' in caminho or Path(caminho).name.startswith('_')

    if CONFLITO.search(texto):
        erros.append(('conflito', 'marcadores de merge no arquivo'))

    if fm is not None and yaml is not None:
        erros += checar_frontmatter(fm, en_fm=frontmatter(git('show', f'{ref}:{caminho}') or '')[0])

    if fm is not None and FLAG_FM.search(fm) is None and 'ia-translate' in corpo:
        erros.append(('flag', '`ia-translate` fora do frontmatter'))
    if fm is None and FLAG_COMENTARIO in texto and \
            not texto.lstrip().startswith(FLAG_COMENTARIO):
        erros.append(('flag', 'comentário ia-translate fora da primeira linha'))

    for linha in texto.split('\n'):
        if PLACEHOLDER.search(linha):
            erros.append(('placeholder', linha.strip()[:90]))
            break

    en = git('show', f'{ref}:{caminho}')
    if en is None:
        erros.append(('estrutura', f'sem original em {ref}'))
        return erros, avisos

    if caminho.startswith(RELEASE_NOTES) and gerador:
        gerado, sobra = gerador.traduzir(en)
        if not sobra and gerado != texto:
            erros.append(('release-notes', 'difere da saída de traduzir_release_notes.py'))
    elif not eh_parcial:
        prop, n = proporcao_ingles(texto)
        if n >= MINIMO_PALAVRAS and prop >= LIMITE_ERRO:
            erros.append(('ingles', f'marcada como traduzida, mas {prop:.0%} da prosa está em inglês'))
        elif n >= MINIMO_PALAVRAS and prop >= LIMITE_AVISO:
            avisos.append(('parcial', f'{prop:.0%} da prosa ainda em inglês'))

    if ANC_MOD is not None:
        quebrados = set(links_internos_quebrados(texto)) - set(links_internos_quebrados(en))
        if quebrados:
            erros.append(('link-interno', 'âncoras inexistentes: ' + ', '.join(sorted(quebrados))))

    if ANCORAR is not None:
        _, n_ancoras = ANCORAR(en, texto)
        if n_ancoras:
            erros.append(('ancora', f'{n_ancoras} título(s) sem `{{:#id}}` em inglês; '
                                    'rode tool/traducao/ancorar_titulos.py'))

    for nome, rx in ESTRUTURA.items():
        ne, np_ = len(rx.findall(en)), len(rx.findall(texto))
        # Âncoras a mais são permitidas (mantêm o id em inglês de títulos traduzidos).
        if ne != np_ and not (nome == 'âncoras {:#}' and np_ > ne):
            erros.append(('estrutura', f'{nome}: en={ne} pt={np_}'))
    faltando = rotulos_sem_definicao(texto) - rotulos_sem_definicao(en)
    if faltando:
        erros.append(('estrutura', 'rótulos sem definição: ' + ', '.join(sorted(faltando))))
    ne, np_ = len(DEFS_LINK.findall(en)), len(DEFS_LINK.findall(texto))
    if ne != np_:
        avisos.append(('defs-link', f'en={ne} pt={np_}'))

    if sync and sync != ref:
        en_sync = git('show', f'{sync}:{caminho}')
        if en_sync is not None and en_sync != en:
            erros.append(('defasada', f'o inglês mudou entre {sync[:9]} e {ref[:9]}; '
                                      'rode sincronizar_upstream.py'))
    return erros, avisos


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--ref', default='upstream/main')
    ap.add_argument('--estrito', action='store_true', help='avisos também falham')
    ap.add_argument('arquivos', nargs='*')
    a = ap.parse_args()

    ref = git('rev-parse', a.ref)
    if ref is None:
        sys.exit(f'Ref {a.ref} não encontrada. Rode: git fetch upstream main')
    ref = ref.strip()
    sync = SYNC.read_text().strip() if SYNC.exists() else None
    if sync and git('cat-file', '-e', sync) is None:
        sync = None  # histórico raso: pula a checagem de defasagem
    gerador = carregar_gerador_release_notes()
    global ANCORAR
    ANCORAR = carregar_ancorador()

    arquivos = a.arquivos or marcados()
    total_erros = total_avisos = 0
    for arq in arquivos:
        p = Path(arq)
        caminho = p.resolve().relative_to(ROOT).as_posix() if p.exists() else arq
        erros, avisos = checar_arquivo(caminho, ref, sync, gerador)
        if erros or avisos:
            print(f'{"✗" if erros else "!"} {caminho}')
            for tipo, msg in erros:
                print(f'    erro  [{tipo}] {msg}')
            for tipo, msg in avisos:
                print(f'    aviso [{tipo}] {msg}')
        total_erros += bool(erros)
        total_avisos += bool(avisos) and not erros

    if not a.arquivos and PEND.exists() and any(
            f.name != 'RELATORIO.md' for f in PEND.rglob('*') if f.is_file()):
        print('✗ .traducao-pendente/\n    erro  [pendente] ainda há conflitos para resolver')
        total_erros += 1

    if not a.arquivos:
        saida = git('grep', '-nE', r'api\.flutterbrasil\.dev|api\.dartbrasil\.dev',
                    '--', *PASTAS_DOMINIO) or ''
        achados = [l for l in saida.splitlines()
                   if DOMINIOS_INEXISTENTES.search(l.split(':', 2)[-1])]
        if achados:
            print('✗ domínios inexistentes')
            for l in achados[:20]:
                print(f'    erro  [dominio] {l[:140]}')
            total_erros += 1

    print(f'{len(arquivos)} arquivo(s) conferido(s): {total_erros} com erro, '
          f'{total_avisos} só com aviso.')
    sys.exit(1 if total_erros or (a.estrito and total_avisos) else 0)


if __name__ == '__main__':
    main()
