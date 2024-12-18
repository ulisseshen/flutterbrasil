# Notas de lançamento do DevTools 2.10.0

A versão 2.10.0 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, confira a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do inspetor Flutter

* Adicionado suporte à pesquisa na Árvore de Widgets e adicionado um navegador breadcrumb à Árvore de Detalhes do Widget para permitir a navegação rápida pela hierarquia da árvore - [#3525](https://github.com/flutter/devtools/pull/3525)

  ![inspector search](/tools/devtools/release-notes/images-2.10.0/image1.png "inspector_search")

## Atualizações do profiler de CPU

* Corrigida uma referência nula no profiler de CPU ao carregar um snapshot offline - [#3596](https://github.com/flutter/devtools/pull/3596)

## Atualizações do debugger

* Adicionado suporte para pesquisa de arquivos com vários tokens e melhorada a priorização de correspondência de pesquisa para classificar as correspondências de nome de arquivo em relação às correspondências de caminho completo - [#3582](https://github.com/flutter/devtools/pull/3582)
* Corrigidos alguns problemas relacionados ao foco - [#3602](https://github.com/flutter/devtools/pull/3602)

## Atualizações da view de logs

* Corrigido um erro fatal que ocorria ao filtrar logs mais de uma vez - [#3588](https://github.com/flutter/devtools/pull/3588)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.9.2...v2.10.0).
