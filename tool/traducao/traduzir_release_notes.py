#!/usr/bin/env python3
"""Gera a versão pt-BR das notas de lançamento do Flutter.

As páginas de `release/release-notes/` são geradas no upstream a partir dos
PRs do GitHub (`dash_site generate-release-notes`). Por convenção do Flutter
Brasil, a lista de PRs fica em inglês (são títulos de PR) e só o frontmatter,
a introdução e os títulos são traduzidos. Isso é mecânico, então este script
faz o trabalho a partir do inglês em `upstream/main`, sem precisar de agente.

    python3 tool/traducao/traduzir_release_notes.py [--ref upstream/main] [--todas]

Sem `--todas`, processa só as páginas sem `ia-translate: true`. Com `--todas`,
regenera também as já marcadas (útil quando o upstream muda a página).

Páginas antigas com prosa (ex.: 1.x) têm parágrafos que o dicionário não
cobre: o script lista essas linhas e NÃO grava a página, para que ela seja
traduzida pelo agente translate-pt-br.
"""
import argparse
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
DIR = 'sites/docs/src/content/release/release-notes'
FLAG = re.compile(r'^ia-translate:\s*true\s*$', re.M)

FRONTMATTER = [
    (r'^title: Flutter (\S+) release notes$', r'title: Notas de lançamento do Flutter \1'),
    (r'^shortTitle: (\S+) release notes$', r'shortTitle: Notas de lançamento \1'),
    (r'^description: Release notes for Flutter (\S+?)\.$',
     r'description: Notas de lançamento do Flutter \1.'),
    (r'^title: Change log for Flutter (\S+)$', r'title: Registro de mudanças do Flutter \1'),
    (r'^shortTitle: (\S+) change log$', r'shortTitle: Registro de mudanças \1'),
    (r'^description: Change log for Flutter (\S+) containing a list of all PRs merged for this release\.$',
     r'description: Registro de mudanças do Flutter \1 com a lista de todos os PRs incluídos nesta versão.'),
]

CORPO = [
    (r'^This page has release notes for Flutter (\S+?)\.$',
     r'Esta página contém as notas de lançamento do Flutter \1.'),
    (r'^This page has release notes for (\S+?)\.$',
     r'Esta página contém as notas de lançamento da versão \1.'),
    (r'^For information about subsequent bug-fix releases,$',
     'Para informações sobre lançamentos de correção de bugs subsequentes,'),
    (r'^(?:see our|check out the Flutter) \[CHANGELOG\]\[\]\.?$',
     'consulte o [CHANGELOG][] do Flutter.'),
    (r'^For information about subsequent bug-fix releases, see our \[CHANGELOG\]\[\]\.?$',
     'Para informações sobre lançamentos de correção de bugs subsequentes, '
     'consulte o [CHANGELOG][] do Flutter.'),
    (r'^The following changes happened in this release:$',
     'As seguintes mudanças aconteceram neste lançamento:'),
    (r'^(#{2,3}) Merged PRs by labels for (`[^`]+`)$', r'\1 PRs incluídos por label em \2'),
    (r'^## PRs closed in this release of (\S+)$', r'## PRs fechados nesta versão de \1'),
    (r'^(#{2,3}) Merged PRs in (`[^`]+`) from (\S+) to (\S+)$', r'\1 PRs incluídos em \2 de \3 até \4'),
    (r'^### Merged PRs in (`[^`]+`)$', r'### PRs incluídos em \1'),
    (r'^There were (\d+) pull requests\.$', r'Foram \1 pull requests.'),
    (r'^(#{3,4} .+) - (\d+) pull request\(s\)$', r'\1 - \2 pull request(s)'),
    (r'^## What\'s changed$', '## O que mudou'),
    (r'^## New [Cc]ontributors$', '## Novos contribuidores'),
    (r'^### Other changes$', '### Outras mudanças'),
    (r'^## Flutter framework$', '## Framework do Flutter'),
    (r'^## Flutter engine$', '## Engine do Flutter'),
    (r'^### Documentation$', '### Documentação'),
    (r'^\*\*Full Changelog\*\*: ', '**Changelog completo**: '),
    (r'^From (.+) to (.+)$', r'De \1 até \2'),
]

# Linhas que não precisam de tradução: listas de PRs, títulos de área
# (Framework, Engine, iOS...), definições de link, HTML e linhas em branco.
NEUTRA = re.compile(
    r'^(\s*$|\s*[*-] |\s{2,}\S|\[[^\]]+\]:|<|#{2,4} [A-Za-z0-9 ./&()-]{1,30}$'
    r'|#{3,4} .+ - \d+ pull request\(s\)$'
    r'|\*\*Changelog completo\*\*|\[\d+\]\(|---$)')
JA_PT = re.compile(r'[áéíóúãõçÁÉÍÓÚÃÕÇ]|^(Esta página|Para informações|consulte o|De .+ até|Foram \d+)')


def traduzir(en):
    m = re.match(r'^---\n(.*?)\n---\n', en, re.S)
    if not m:
        return None, ['sem frontmatter']
    fm, corpo = m.group(1), en[m.end():]
    for a, b in FRONTMATTER:
        fm = re.sub(a, b, fm, flags=re.M)
    fm += '\nia-translate: true'
    linhas, sobra = [], []
    for linha in corpo.split('\n'):
        for a, b in CORPO:
            nova = re.sub(a, b, linha)
            if nova != linha:
                linha = nova
                break
        if not NEUTRA.match(linha) and not JA_PT.search(linha):
            sobra.append(linha)
        linhas.append(linha)
    return f'---\n{fm}\n---\n' + '\n'.join(linhas), sobra


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--ref', default='upstream/main')
    ap.add_argument('--todas', action='store_true')
    a = ap.parse_args()
    nomes = subprocess.run(['git', '-C', str(ROOT), 'ls-tree', '-r', '--name-only',
                            a.ref, DIR], capture_output=True, text=True,
                           check=True).stdout.split()
    gravadas, pendentes = [], {}
    for caminho in nomes:
        if not caminho.endswith('.md') or caminho.endswith('/index.md'):
            continue
        local = ROOT / caminho
        if not a.todas and local.exists() and FLAG.search(local.read_text()):
            continue
        en = subprocess.run(['git', '-C', str(ROOT), 'show', f'{a.ref}:{caminho}'],
                            capture_output=True, text=True, check=True).stdout
        pt, sobra = traduzir(en)
        if sobra:
            pendentes[caminho] = sobra
            continue
        local.write_text(pt)
        gravadas.append(caminho)
    for c in gravadas:
        print('✓', c)
    for c, sobra in pendentes.items():
        print(f'✗ {c}: {len(sobra)} linha(s) de prosa sem tradução (use o agente translate-pt-br)')
        for s in sobra[:3]:
            print('    ', s[:100])
    sys.exit(0)


if __name__ == '__main__':
    main()
