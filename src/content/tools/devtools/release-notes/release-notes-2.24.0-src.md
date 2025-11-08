# Notas de lançamento do DevTools 2.24.0

A versão 2.24.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Melhorar the overall performance of DevTools tables -
  [#5664](https://github.com/flutter/devtools/pull/5664),
  [#5696](https://github.com/flutter/devtools/pull/5696)

## Atualizações do CPU profiler

* Corrigir bug with CPU flame chart selection and tooltips -
  [#5676](https://github.com/flutter/devtools/pull/5676)

## Atualizações do Debugger

* Melhorar support for inspecting
  `UserTag` and `MirrorReferent` instances -
  [#5490](https://github.com/flutter/devtools/pull/5490)
* Corrigir expression evaluation bug where
  selecting an autocomplete result for a field would clear the current input -
  [#5717](https://github.com/flutter/devtools/pull/5717)
* Make selection of a stack frame 
  scroll to the frame location in the source code -
  [#5722](https://github.com/flutter/devtools/pull/5722)
* Melhorar performance of searching for a file and searching in a file -
  [#5733](https://github.com/flutter/devtools/pull/5733)
* Desabilitar syntax highlighting for files with more than 100,000 characters
  devido a restrições de desempenho -
  [#5743](https://github.com/flutter/devtools/pull/5743)
* Corrigir bug where source code wasn't visible if
  syntax highlighting for a file was disabled -
  [#5743](https://github.com/flutter/devtools/pull/5743)
* Prevenir file names and source code from getting out of sync -
  [#5827](https://github.com/flutter/devtools/pull/5827)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.23.1...v2.24.0).
