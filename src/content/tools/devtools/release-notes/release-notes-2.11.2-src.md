# Notas de lançamento do DevTools 2.11.2

A versão 2.11.2 do Dart e Flutter DevTools inclui as seguintes alterações,
entre outras melhorias gerais. Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Esta versão incluiu muita limpeza e redução de dívida técnica.

## Atualizações do profiler de CPU

* Adicionado o número da linha de origem aos URIs de arquivo em perfis de CPU -
  [#3718](https://github.com/flutter/devtools/pull/3718)

  ![números de linha do frame de pilha da cpu](/tools/devtools/release-notes/images-2.11.2/image1.png "números de linha do frame de pilha da cpu")

## Atualizações do Debugger

* Melhorias na UX do abridor de arquivos, incluindo suporte para clicar
  no nome do arquivo de origem para abrir a janela de pesquisa de arquivos -
  [#3612](https://github.com/flutter/devtools/pull/3612),
  [#3758](https://github.com/flutter/devtools/pull/3758)
* Adicionado suporte para rolagem automática do Explorador de Arquivos para o
  arquivo selecionado -
  [#3786](https://github.com/flutter/devtools/pull/3786),
  [#3794](https://github.com/flutter/devtools/pull/3794)

  ![rolagem do explorador de arquivos do debugger](/tools/devtools/release-notes/images-2.11.2/image2.gif "rolagem do explorador de arquivos do debugger")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.10.0...v2.11.2).
