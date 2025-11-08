# Notas de lançamento do DevTools 2.11.2

A versão 2.11.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* This release included a lot of cleanup and reduction in technical debt.

## Atualizações do CPU profiler

* Added the source line number to file uris in CPU profiles -
  [#3718](https://github.com/flutter/devtools/pull/3718)

  ![cpu stack frame line numbers](/tools/devtools/release-notes/images-2.11.2/image1.png "cpu stack frame line numbers")

## Atualizações do Debugger

* File opener UX improvements, including support for clicking
  the source file name to open the file search window -
  [#3612](https://github.com/flutter/devtools/pull/3612),
  [#3758](https://github.com/flutter/devtools/pull/3758)
* Added support for auto-scrolling the File Explorer to the selected file -
  [#3786](https://github.com/flutter/devtools/pull/3786),
  [#3794](https://github.com/flutter/devtools/pull/3794)

  ![debugger file explorer scrolling](/tools/devtools/release-notes/images-2.11.2/image2.gif "debugger file explorer scrolling")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.10.0...v2.11.2).
