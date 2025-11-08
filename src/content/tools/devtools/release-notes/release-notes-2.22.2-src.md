# Notas de lançamento do DevTools 2.22.2

A versão 2.22.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

- Prevenção de crashes se não houver isolate principal -
  [#5232](https://github.com/flutter/devtools/pull/5232)

## Atualizações do CPU profiler

- Exibição de URI do stack frame inline com nome do método para
  garantir que a URI esteja sempre visível em árvores profundamente aninhadas -
  [#5181](https://github.com/flutter/devtools/pull/5181)

  ![inline uri](/tools/devtools/release-notes/images-2.22.2/5181.png "inline uri")

- Adicionada capacidade de filtrar por nome do método ou URI de origem -
  [#5204](https://github.com/flutter/devtools/pull/5204)

## Atualizações do Memory

- Alterado padrão do filtro para mostrar apenas projeto e dependências de terceiros -
  [#5201](https://github.com/flutter/devtools/pull/5201).

  ![filter default](/tools/devtools/release-notes/images-2.22.2/5201.png "filter default")

- Suporte para avaliação de expressões no console para aplicação em execução -
  [#5248](https://github.com/flutter/devtools/pull/5248).

  ![evaluation](/tools/devtools/release-notes/images-2.22.2/5248.png "evaluation")

- Adicionada coluna `Persisted` para comparação de memória -
  [#5290](https://github.com/flutter/devtools/pull/5290)

  ![persisted](/tools/devtools/release-notes/images-2.22.2/5290.png "persisted")

## Atualizações do Debugger

- Adicionado suporte para histórico de navegação do navegador ao
  navegar usando o File Explorer -
  [#4906](https://github.com/flutter/devtools/pull/4906)
- Designados campos posicionais para tipos `Record`
  com a sintaxe getter começando em `$1` -
  [#5272](https://github.com/flutter/devtools/pull/5272)
- Corrigida inspeção de variáveis para instâncias de `Map` e `List` -
  [#5320](https://github.com/flutter/devtools/pull/5320)

  ![map and list](/tools/devtools/release-notes/images-2.22.2/5320.png "map and list")

- Corrigida inspeção de variáveis para instâncias de `Set` -
  [#5323](https://github.com/flutter/devtools/pull/5323)

  ![set](/tools/devtools/release-notes/images-2.22.2/5323.png "set")


## Atualizações do Network profiler

- Melhorada confiabilidade e desempenho da aba Network -
  [#5056](https://github.com/flutter/devtools/pull/5056)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.21.1...v2.22.2).
