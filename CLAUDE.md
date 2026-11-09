# CLAUDE.md — Flutter Brasil

Este repositório é a tradução para português do Brasil da documentação do
Flutter (docs.flutter.dev), publicada em <https://docs.flutterbrasil.dev>.
É um fork do [flutter/website](https://github.com/flutter/website) (remote
`upstream`). O contexto técnico do site (Jaspr, estrutura de pastas, comandos)
está no `AGENTS.md` do upstream:

@AGENTS.md

## Começando do zero (sessão nova)

Em uma máquina ou sessão de nuvem nova, a partir da raiz do repositório:

```console
bash tool/traducao/setup.sh
export PATH="$HOME/.dart-sdk/bin:$HOME/.pub-cache/bin:$PATH"
```

O script instala o Dart SDK na mesma versão do CI do upstream (lida de
`.github/workflows/docs.yml`), adiciona o remote `upstream`
(flutter/website), busca histórico suficiente e roda `dart pub get`.

Comandos úteis depois disso:

- `dart run dash_site --site=docs build`: build completo do site (gera
  `sites/docs/build/jaspr`, leva vários minutos). Rode antes de abrir PR.
- `dart run dash_site --site=docs serve`: servidor local.
- `dart analyze sites/docs/lib packages/site_shared/lib tool/dash_site`:
  rode depois de mexer em código Dart.
- `python3 tool/traducao/verificar.py`: valida a estrutura das traduções.

## Agentes e paralelismo

- **No máximo 5 agentes em paralelo.** Divida o trabalho em lotes
  equilibrados por tamanho (linhas ou blocos de conflito), sem dois agentes no
  mesmo arquivo. Agentes não fazem commit nem push: quem orquestra confere com
  `verificar.py`, faz o commit por lote e o push.
- **Traduzir páginas novas:** agente `translate-pt-br`
  (`.claude/agents/translate-pt-br.md`, modelo **Haiku**). É rápido e barato
  para tradução direta. O portão de qualidade é o `verificar.py`; se um arquivo
  falhar duas vezes, refaça-o com um modelo maior.
- **Atualizar páginas já traduzidas** (arquivos diff3 de
  `.traducao-pendente/`): agente `atualizar-traducao`
  (`.claude/agents/atualizar-traducao.md`, modelo **Sonnet**). Comparar
  inglês antigo, inglês novo e português exige mais cuidado para não perder
  texto, por isso não use Haiku nessa etapa.
- Código Dart, workflows e dados de configuração: resolva diretamente, sem
  agente, e valide com `dart analyze` e com o build.

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
6. Rode `python3 tool/traducao/ancorar_titulos.py` nas páginas resolvidas e
   `python3 tool/traducao/verificar.py` (sem argumentos ele confere todas as
   páginas traduzidas) e corrija o que aparecer.
7. Rode `python3 tool/traducao/traduzir_release_notes.py --todas` para
   regenerar as notas de lançamento (inclusive as novas).
8. Quando `.traducao-pendente/` estiver vazio, apague a pasta, rode
   `python3 tool/traducao/gerar_todo.py` e faça o commit.
9. Só depois disso siga para as páginas novas que ainda não foram traduzidas
   (`TODO-TRADUCAO.md`).

Nunca resolva um conflito trocando a página pela versão em inglês e mantendo
`ia-translate: true`, nem descartando o texto novo do upstream.

## Scripts de `tool/traducao/`

| Script | Para quê |
|---|---|
| `sincronizar_upstream.py` | Merge com o upstream preservando traduções (acima). |
| `verificar.py [--estrito] [arquivos]` | **Checagens determinísticas** (roda no CI, ver abaixo). Sem argumentos confere todas as páginas marcadas. |
| `ancorar_titulos.py <arquivos>` | Acrescenta `{:#id}` em inglês aos títulos traduzidos (mesma regra de slug do site; junta atributos como `{:.no_toc #id}`). Rode em toda página traduzida. |
| `gerar_todo.py` | Regenera `TODO-TRADUCAO.md` (status por seção a partir de `ia-translate`). |
| `traduzir_release_notes.py [--todas]` | **Gera** a versão pt-BR das notas de lançamento do Flutter (`release/release-notes/`) a partir do inglês do upstream: traduz frontmatter, introdução e títulos e mantém a lista de PRs em inglês. Não use agente para essas páginas. Páginas antigas com prosa são listadas para tradução manual. |

## Checagens determinísticas (CI)

O workflow `.github/workflows/traducao.yml` roda em todo PR e push na `main`
e falha se qualquer checagem der erro. O preview do PR
(`firebase-preview.yml`) também roda `check-link-references` e `check-links`,
os mesmos checks que barram o deploy de produção. Rode localmente antes do
commit:

```console
python3 tool/traducao/verificar.py
dart run dash_site --site=docs refresh-excerpts --fail-on-update --dry-run
```

Para o `check-links` local é preciso o firebase-tools na versão fixada pelo
upstream (`curl -sSfLo firebase https://firebase.tools/bin/linux/v15.30.2`,
no `PATH`), depois do build: `dart run dash_site --site=docs check-links`.
Ele falha também com avisos (âncora inexistente).

O `verificar.py` acusa como **erro**:

- `conflito`: marcadores de merge (`<<<<<<<`, `|||||||`, `>>>>>>>`) esquecidos;
- `flag`: `ia-translate` fora do frontmatter (ou o comentário fora da 1ª linha
  de um parcial);
- `placeholder`: avisos de tradução pendente no texto ("Note for
  translators", "To be translated"...);
- `ingles`: página marcada como traduzida com 70% ou mais da prosa em inglês
  (contagem de palavras-função; código, listas de PRs e links não entram);
- `estrutura`: cercas de código, code-excerpts, tags Liquid, admonitions ou
  âncoras diferentes do inglês, e rótulo de link sem definição;
- `release-notes`: página de `release/release-notes/` diferente da saída de
  `traduzir_release_notes.py`;
- `defasada`: o inglês da página mudou no upstream depois do último sync
  (`ultimo-sync-upstream.txt`). É a regra principal acima virando checagem;
- `pendente`: `.traducao-pendente/` com arquivos não resolvidos.
- `ancora`: título traduzido sem `{:#id}` com o slug do inglês. Os links
  `#ancora` (de outras páginas e do upstream) usam o id em inglês; corrija com
  `python3 tool/traducao/ancorar_titulos.py <arquivos>`;
- `link-interno`: link para âncora da própria página que não existe (ex.:
  `(#exemplo-2)` quando o id é `example-2`);
- `dominio`: domínios que não existem, como `api.flutterbrasil.dev`,
  `main-api.flutterbrasil.dev` e `api.dartbrasil.dev`. A documentação de API
  não é traduzida: use `api.flutter.dev`, `main-api.flutter.dev` e
  `api.dart.dev` (o `dartbrasil.dev` existe e pode ser usado).

E como **aviso** (não falha, a menos que use `--estrito`): `parcial` (30% a
70% da prosa em inglês) e `defs-link` (número de definições de link diferente
do inglês).

Quando uma checagem nova pegar um caso que escapou, acrescente-a ao
`verificar.py` em vez de corrigir só o arquivo.

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
