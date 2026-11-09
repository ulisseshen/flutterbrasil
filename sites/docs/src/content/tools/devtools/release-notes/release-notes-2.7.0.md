---
ia-translate: true
title: Notas de lançamento do DevTools 2.7.0
shortTitle: Notas de lançamento 2.7.0
breadcrumb: 2.7.0
description: Notas de lançamento da versão 2.7.0 do Dart e Flutter DevTools.
showToc: false
---

A versão 2.7.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Melhorias no tempo de carregamento inicial da página -
  [#3309](https://github.com/flutter/devtools/pull/3309)
* Corrigidos alguns problemas relacionados à barra de rolagem -
  [#3393](https://github.com/flutter/devtools/pull/3393),
  [#3401](https://github.com/flutter/devtools/pull/3401)

## Atualizações do Debugger

* Adicionado um diálogo de abrir arquivo (ctrl / cmd + p) -
  [#3342](https://github.com/flutter/devtools/pull/3342),
  [#3354](https://github.com/flutter/devtools/pull/3354),
  [#3371](https://github.com/flutter/devtools/pull/3371),
  [#3384](https://github.com/flutter/devtools/pull/3384)

  ![Open file dialog](/assets/images/docs/tools/devtools/release-notes/images-2.7.0/image1.gif "Open file dialog")

* Adicionado um botão de copiar à visualização de pilha de chamadas -
  [#3334](https://github.com/flutter/devtools/pull/3334)

  ![Call stack view](/assets/images/docs/tools/devtools/release-notes/images-2.7.0/image2.png "Call stack view")

## Atualizações do CPU profiler

* Adicionada funcionalidade para carregar um perfil de inicialização de app para apps Flutter.
  Este perfil conterá amostras de CPU desde a inicialização
  da Dart VM até que o primeiro frame Flutter tenha sido renderizado -
  [#3357](https://github.com/flutter/devtools/pull/3357)

  ![Profile button](/assets/images/docs/tools/devtools/release-notes/images-2.7.0/image3.png "Profile button")

  Quando o perfil de inicialização do app for carregado,
  você verá que a user tag "AppStartUp" está selecionada para o perfil.
  Você também pode carregar o perfil de inicialização do app
  selecionando este filtro de user tag, quando presente,
  na lista de user tags disponíveis.

  ![User tag example](/assets/images/docs/tools/devtools/release-notes/images-2.7.0/image4.png "User tag example")

* Adicionado suporte para múltiplos isolates.
  Selecione qual isolate você quer perfilar
  do seletor de isolate na parte inferior da página -
  [#3362](https://github.com/flutter/devtools/pull/3362)

  ![isolate selector](/assets/images/docs/tools/devtools/release-notes/images-2.7.0/image5.png "isolate selector")

* Adicionados nomes de classe aos stack frames de CPU no profiler -
  [#3385](https://github.com/flutter/devtools/pull/3385)

  ![Class names](/assets/images/docs/tools/devtools/release-notes/images-2.7.0/image6.png "Class names")

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde o lançamento anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.6.0...v2.7.0).
