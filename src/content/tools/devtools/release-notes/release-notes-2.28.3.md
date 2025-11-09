---
ia-translate: true
title: Notas de versão do DevTools 2.28.3
shortTitle: Notas de versão 2.28.3
breadcrumb: 2.28.3
description: Notas de versão para o Dart e Flutter DevTools versão 2.28.3.
showToc: false
---

A versão 2.28.3 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

Esta foi uma versão cherry-pick em cima do DevTools 2.28.2.
Para saber sobre as melhorias incluídas no DevTools 2.28.2, por favor leia as
[notas de versão](/tools/devtools/release-notes/release-notes-2.28.2).

## Atualizações gerais

* Adicionado um link para o novo [vídeo](https://www.youtube.com/watch?v=_EYk-E29edo)
  "Dive in to DevTools" no YouTube na barra de status inferior.
  Este vídeo fornece um tutorial breve para cada tela do DevTools.
  [#6554](https://github.com/flutter/devtools/pull/6554)

  ![Link to watch a DevTools tutorial video](/assets/images/docs/tools/devtools/release-notes/images-2.28.3/watch_tutorial_link.png "Link to watch a DevTools tutorial video")

* Adicionado um workaround para corrigir funcionalidade do botão copiar no VSCode. - [#6598](https://github.com/flutter/devtools/pull/6598)

## Atualizações de Performance

* Desabilitada a ferramenta Raster Stats para o backend Impeller
  já que não é suportado. - [#6616](https://github.com/flutter/devtools/pull/6616)

## Atualizações do VS Code Sidebar

* Ao usar VS Code com um tema claro, a sidebar incorporada fornecida pelo
  DevTools agora também será mostrada no tema claro. - [#6581](https://github.com/flutter/devtools/pull/6581)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.28.3).
