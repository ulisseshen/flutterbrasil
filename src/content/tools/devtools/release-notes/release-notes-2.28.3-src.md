# Notas de lançamento do DevTools 2.28.3

A versão 2.28.3 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

This was a cherry-pick release on top of DevTools 2.28.2.
To learn about the improvements included in DevTools 2.28.2, please read the
[release notes](/tools/devtools/release-notes/release-notes-2.28.2).

## Atualizações gerais

* Added a link to the new "Dive in to DevTools" YouTube
  [video](https://www.youtube.com/watch?v=_EYk-E29edo) in the bottom status bar. 
  This video provides a brief tutorial for each DevTools screen.
  [#6554](https://github.com/flutter/devtools/pull/6554)

  ![Link to watch a DevTools tutorial video](/tools/devtools/release-notes/images-2.28.3/watch_tutorial_link.png "Link to watch a DevTools tutorial video")

* Added a workaround to fix copy button functionality in VSCode. - [#6598](https://github.com/flutter/devtools/pull/6598)

## Atualizações de Performance

* Disable the Raster Stats tool for the Impeller backend
  since it is not supported. - [#6616](https://github.com/flutter/devtools/pull/6616)

## Atualizações do VS Code Sidebar

* When using VS Code with a light theme, the embedded sidebar provided by
  DevTools will now also show in the light theme. - [#6581](https://github.com/flutter/devtools/pull/6581)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira
[o log do git do DevTools](https://github.com/flutter/devtools/tree/v2.28.3).
