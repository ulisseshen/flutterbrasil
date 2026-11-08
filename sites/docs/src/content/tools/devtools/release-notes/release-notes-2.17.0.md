---
ia-translate: true
title: Notas de versão do DevTools 2.17.0
shortTitle: Notas de versão 2.17.0
breadcrumb: 2.17.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.17.0.
showToc: false
---

A versão 2.17.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações do Inspector

* Adicionado suporte para definir manualmente os diretórios de pacotes para seu app.
  Se você já carregou o Inspector e notou que
  alguns de seus widgets não estão presentes na árvore de widgets, isso pode
  indicar que os diretórios de pacotes para seu app
  não foram definidos ou detectados corretamente.
  Seus diretórios de pacotes determinam quais widgets
  o Inspector considera ser do _seu_ aplicativo.
  Se você vê uma árvore de widgets vazia no Inspector,
  ou se você desenvolve widgets em múltiplos pacotes,
  e quer que widgets de todos esses locais apareçam na sua árvore,
  verifique o diálogo **Inspector Settings** para garantir que seus diretórios de pacotes
  estejam configurados corretamente -
  [#4306](https://github.com/flutter/devtools/pull/4306)

  ![frame_analysis](/assets/images/docs/tools/devtools/release-notes/images-2.17.0/package_directories.png "package directories")

## Atualizações de Performance

* Adicionada uma aba **Frame Analysis** à página Performance.
  Ao analisar um frame Flutter com jank,
  esta visualização fornece dicas de como diagnosticar o jank e
  detecta operações custosas que podem ter
  contribuído para o tempo lento do frame.
  Esta visualização também mostra uma divisão do tempo do seu frame Flutter
  por fase (**Build**, **Layout**, **Paint** e **Raster**)
  para tentar guiá-lo na direção certa -
  [#4339](https://github.com/flutter/devtools/pull/4339)

  ![frame_analysis](/assets/images/docs/tools/devtools/release-notes/images-2.17.0/frame_analysis.png "frame analysis")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.16.0...v2.17.0).
