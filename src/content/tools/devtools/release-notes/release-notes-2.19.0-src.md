# Notas de lançamento do DevTools 2.19.0

A versão 2.19.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações de Performance

* Added a button to toggle the visibility of the Flutter Frames chart -
  [#4577](https://github.com/flutter/devtools/pull/4577)

  ![diff](/tools/devtools/release-notes/images-2.19.0/4577.png "Flutter Frames")

* Polish the debug mode warning to better describe which data is
  accurate in debug mode and which data may be misleading -
  [#3537](https://github.com/flutter/devtools/pull/3537) 
* Reorder performance tool tabs and only show the CPU profiler
  for the "Timeline Events" tab -
  [#4629](https://github.com/flutter/devtools/pull/4629) 

## Atualizações de Memory

* Improvements to the memory Profile tab -
  [#4583](https://github.com/flutter/devtools/pull/4583)

## Atualizações do Debugger

* Fix an issue with hover cards where they were appearing
  but never disappearing -
  [#4627](https://github.com/flutter/devtools/pull/4627) 
* Fix a bug with the file search autocomplete dialog -
  [#4409](https://github.com/flutter/devtools/pull/4409) 

## Atualizações do Network profiler

* Added a "Copy" button in the Network Request view
  (thanks to @netos23) -
  [#4509](https://github.com/flutter/devtools/pull/4509) 

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.18.0...v2.19.0).

