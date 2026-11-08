# CLAUDE.md — Flutter Brasil

Este repositório é a tradução para português do Brasil da documentação do
Flutter (docs.flutter.dev), publicada em <https://docs.flutterbrasil.dev>.
É um fork do [flutter/website](https://github.com/flutter/website) (remote
`upstream`). O contexto técnico do site (Jaspr, estrutura de pastas, comandos)
está no `AGENTS.md` do upstream:

@AGENTS.md

## Onde fica o quê

- `sites/docs/src/content/`: páginas em Markdown (o que se traduz).
- `sites/docs/src/_includes/`: parciais Markdown incluídos nas páginas.
- `sites/docs/src/data/`: menu lateral (`sidenav/default.yml`), glossário,
  catálogo de widgets etc. Os textos visíveis também são traduzidos.
- `sites/docs/lib/`: componentes Jaspr (header, footer e outras
  personalizações do Flutter Brasil).
- `.claude/agents/translate-pt-br.md`: **convenções de tradução** (termos,
  links, âncoras, código). Siga sempre.
- `tool/traducao/`: scripts de tradução e de sincronização (descritos abaixo).

## Regras de tradução (resumo)

As regras completas estão em `.claude/agents/translate-pt-br.md`. As mais
importantes:

- Página traduzida tem `ia-translate: true` no frontmatter; parcial sem
  frontmatter tem `<!-- ia-translate: true -->` na primeira linha.
- Não traduza código, comandos, URLs, chaves de frontmatter, variáveis
  `{{site.*}}`, rótulos de link de referência nem âncoras `{:#id}`.
  Use `[texto traduzido][rótulo original em inglês]`.
- Mantenha a estrutura idêntica ao inglês: títulos, listas, cercas de código,
  componentes e tags Liquid.
- Termos técnicos consagrados ficam em inglês (widget, hot reload, package,
  plugin, build, stateful/stateless etc.).

## Regra principal: manter as traduções em dia com o upstream

**Traduzir páginas novas não basta: toda página já traduzida precisa ser
atualizada sempre que o inglês dela mudar no upstream.** Uma página com
`ia-translate: true` cujo conteúdo esteja defasado em relação ao inglês atual
é um bug.

Em toda sincronização com o upstream:

1. `git fetch upstream main` e crie uma branch.
2. Rode `python3 tool/traducao/sincronizar_upstream.py`. Ele:
   - faz o merge adotando a árvore do upstream (a estrutura nova do upstream
     sempre vence);
   - leva cada arquivo traduzido para o caminho novo (mesmo caminho, redirect
     do `firebase.json` ou renomeação);
   - copia a tradução quando o inglês não mudou;
   - faz merge de 3 vias quando mudou. Sem conflito, grava o resultado. Com
     conflito, grava em `.traducao-pendente/<caminho>` com marcadores diff3
     e deixa o inglês novo no repositório;
   - grava `.traducao-pendente/RELATORIO.md` e atualiza
     `tool/traducao/ultimo-sync-upstream.txt`.
3. Faça o commit do merge **incluindo** `.traducao-pendente/`, para nada se
   perder entre sessões.
4. Resolva **todos** os arquivos de `.traducao-pendente/`, que são as páginas
   já traduzidas cujo texto mudou:
   - em cada bloco `<<<<<<< pt` / `||||||| base_en` / `=======` / `>>>>>>> new_en`,
     escreva o português do `new_en`, reaproveitando a tradução do lado `pt`
     e mudando só o que o inglês mudou;
   - grave o resultado no caminho real em `sites/docs/src/content/`, com
     `ia-translate: true`;
   - apague o arquivo resolvido de `.traducao-pendente/` e marque-o no
     `RELATORIO.md`.
5. Revise também os "removidos ou consolidados" do relatório: se a página que
   os substituiu ainda não está traduzida, traduza-a usando a tradução antiga
   como referência.
6. Rode `python3 tool/traducao/verificar.py` (sem argumentos ele confere
   todas as páginas traduzidas) e corrija o que aparecer.
7. Quando `.traducao-pendente/` estiver vazio, apague a pasta, rode
   `python3 tool/traducao/gerar_todo.py` e faça o commit.
8. Só depois disso siga para as páginas novas que ainda não foram traduzidas
   (`TODO-TRADUCAO.md`).

Nunca resolva um conflito trocando a página pela versão em inglês e mantendo
`ia-translate: true`, nem descartando o texto novo do upstream.

## Scripts de `tool/traducao/`

| Script | Para quê |
|---|---|
| `sincronizar_upstream.py` | Merge com o upstream preservando traduções (acima). |
| `verificar.py [arquivos]` | Compara a estrutura com o inglês em `upstream/main`: cercas de código, code-excerpts, tags Liquid, admonitions, definições de link, âncoras e rótulos sem definição. |
| `gerar_todo.py` | Regenera `TODO-TRADUCAO.md` (status por seção a partir de `ia-translate`). |

## Personalizações do Flutter Brasil fora do conteúdo

Ao sincronizar, confira se continuam funcionando:

- domínio `docs.flutterbrasil.dev` e textos em `sites/docs/src/data/site.yml`;
- header, footer, aviso de cookies, feedback e conteúdo lateral em
  `sites/docs/lib/src/components/` (e `packages/site_shared/`);
- deploy: `.github/workflows/firebase-deploy.yml`,
  `.github/workflows/firebase-preview.yml`, `sites/docs/firebase.json` e
  `sites/docs/.firebaserc`;
- os exemplos em `examples/` podem ter strings traduzidas: os code-excerpts
  das páginas devem continuar batendo com eles.

## Git

- Trabalhe em branch e abra PR para a `main`.
- Commits de tradução: `translate: <caminho>`; sincronização:
  `Merge upstream flutter/website main`.
