# Notas de lançamento do DevTools 2.26.1

A versão 2.26.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

- Adicionado a new "Home" screen in DevTools that either shows the "Connect" dialog
  or a summary of your connected app, depending on
  the connection status in DevTools.
  Fique de olho em this screen para novos recursos interessantes no futuro.
  Esta alteração também habilita support for static tooling
  (tools that don't require a connected app) in DevTools -
  [#6010](https://github.com/flutter/devtools/pull/6010)

  ![home screen](/tools/devtools/release-notes/images-2.26.1/home_screen.png "DevTools home screen")

- Corrigido overlay notifications so that they
  cover the area that their background blocks -
  [#5975](https://github.com/flutter/devtools/pull/5975)

## Atualizações do Memory

- Adicionado a context menu to rename or delete a heap snapshot from the list -
  [#5997](https://github.com/flutter/devtools/pull/5997)
- Avisar users when HTTP logging may be affecting their app's memory consumption -
  [#5998](https://github.com/flutter/devtools/pull/5998)

## Atualizações do Debugger

- Improvements to text selection and copy behavior in
  the code view, console, and variables windows -
  [#6020](https://github.com/flutter/devtools/pull/6020)

## Atualizações do Network profiler

- Adicionado a selector to customize the display type
  of text and json responses (thanks to @hhacker1999!) -
  [#5816](https://github.com/flutter/devtools/pull/5816)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.25.0...v2.26.1).
