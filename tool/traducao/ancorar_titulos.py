#!/usr/bin/env python3
"""Adiciona âncoras explícitas `{:#slug}` aos títulos traduzidos, usando o
slug gerado a partir do título correspondente em inglês (mesma posição).

Assim os links `#ancora` vindos de outras páginas (e do próprio upstream)
continuam funcionando depois da tradução.

    python3 tool/traducao/ancorar_titulos.py [--ref upstream/main] arquivos...
"""
import argparse
import re
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
TITULO = re.compile(r'^(#{2,6})\s+(.*?)\s*$')
ANCORA = re.compile(r'\{:\s*#[^}]*\}\s*$')


def titulos(texto):
    """Retorna [(índice_da_linha, nível, texto)] fora de blocos de código."""
    res, em_codigo = [], False
    for i, linha in enumerate(texto.split('\n')):
        if re.match(r'^\s*```', linha):
            em_codigo = not em_codigo
            continue
        if not em_codigo:
            m = TITULO.match(linha)
            if m:
                res.append((i, len(m.group(1)), m.group(2)))
    return res


def slug(texto):
    """Mesmo algoritmo de packages/site_shared/lib/src/utils/slugify.dart,
    aplicado ao texto visível do título (sem markdown/HTML)."""
    t = re.sub(r'<[^>]+>', '', texto)
    t = re.sub(r'\[([^\]]*)\]\[[^\]]*\]|\[([^\]]*)\]\([^)]*\)',
               lambda m: m.group(1) or m.group(2) or '', t)
    t = re.sub(r'[*`]', '', t)
    t = t.lower().strip()
    t = re.sub(r'[:._]', '-', t)
    t = ''.join(c for c in t if c.isalnum() or c.isspace() or c in ':.-')
    t = re.sub(r'[\s-]+', '-', t)
    return t.strip('-')


ATRIBUTOS = re.compile(r'\s*\{:([^}]*)\}\s*$')


def separar_atributos(texto):
    """Separa os blocos `{: ...}` do fim de um título. Retorna
    (texto_sem_blocos, tokens), em que tokens são as classes/atributos
    (ex.: ['.no_toc', '#id'])."""
    tokens = []
    while True:
        m = ATRIBUTOS.search(texto)
        if not m:
            break
        tokens = m.group(1).split() + tokens
        texto = texto[:m.start()]
    return texto.rstrip(), tokens


def ancorar(en, pt):
    """Retorna (texto_pt_com_ancoras, n_ajustes), ou (None, 0) se os títulos
    de en e pt não correspondem em quantidade e nível.

    Os atributos kramdown do fim do título são juntados num bloco só
    (`{:.no_toc #id}`); o id em inglês é acrescentado quando o slug do título
    traduzido difere do slug do original."""
    te, tp = titulos(en), titulos(pt)
    if [n for _, n, _ in te] != [n for _, n, _ in tp]:
        return None, 0
    linhas = pt.split('\n')
    n = 0
    for (_, nivel, txt_en), (i, _, txt_pt) in zip(te, tp):
        texto_en, tokens_en = separar_atributos(txt_en)
        if any(t.startswith('#') for t in tokens_en):
            continue  # o inglês já tem id explícito; a tradução copia o bloco
        s_en = slug(texto_en)
        texto_pt, tokens_pt = separar_atributos(txt_pt)
        tokens = [t for t in tokens_pt if not t.startswith('#')]
        if s_en and s_en != slug(texto_pt):
            tokens.append(f'#{s_en}')
        bloco = (' {:' + ' '.join(tokens) + '}') if tokens else ''
        novo = f'{"#" * nivel} {texto_pt}{bloco}'
        if novo != linhas[i]:
            linhas[i] = novo
            n += 1
    return '\n'.join(linhas), n


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--ref', default='upstream/main')
    ap.add_argument('arquivos', nargs='+')
    a = ap.parse_args()
    for arq in a.arquivos:
        caminho = Path(arq).resolve().relative_to(ROOT).as_posix()
        en = subprocess.run(['git', '-C', str(ROOT), 'show', f'{a.ref}:{caminho}'],
                            capture_output=True, text=True, check=True).stdout
        pt = (ROOT / caminho).read_text(encoding='utf-8')
        novo, n = ancorar(en, pt)
        if novo is None:
            print(f'✗ {caminho}: títulos não correspondem; ignorado')
            continue
        if n:
            (ROOT / caminho).write_text(novo, encoding='utf-8')
        print(f'✓ {caminho}: {n} título(s) ajustado(s)')


if __name__ == '__main__':
    main()
