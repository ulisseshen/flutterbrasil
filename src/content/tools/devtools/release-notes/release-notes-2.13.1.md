---
ia-translate: true
title: Notas de versão do DevTools 2.13.1
shortTitle: Notas de versão 2.13.1
breadcrumb: 2.13.1
description: Notas de versão para o Dart e Flutter DevTools versão 2.13.1.
showToc: false
---

A versão 2.13.1 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Esta versão incluiu muita limpeza e redução de débito técnico.
  O mais notável é a conclusão de nossa migração para null safety sólido.
* Mostrar notas de versão em versões embutidas do DevTools na IDE -
  [#4053](https://github.com/flutter/devtools/pull/4053)
* Polimento no rodapé do DevTools -
  [#3989](https://github.com/flutter/devtools/pull/3989),
  [#4026](https://github.com/flutter/devtools/pull/4026),
  [#4041](https://github.com/flutter/devtools/pull/4041),
  [#4076](https://github.com/flutter/devtools/pull/4076)

## Atualizações de Performance

* Adicionado um novo recurso para ajudá-lo a depurar jank de raster em seu app Flutter.
  Este recurso permite que você tire um snapshot da
  tela atual mostrada em seu app, e então
  divida o tempo de renderização para essa cena por camada.
  Isso pode ajudá-lo a identificar partes de uma cena que são caras para rasterizar -
  [#4046](https://github.com/flutter/devtools/pull/4046)

  ![raster-metrics-feature](/assets/images/docs/tools/devtools/release-notes/images-2.13.1/image1.png "raster metrics feature")

* Adicionada uma configuração de escopo para "Track Widget Builds", permitindo
  que você especifique se builds de widgets devem ser rastreados em
  seu código apenas ou em todo o código -
  [#4010](https://github.com/flutter/devtools/pull/4010)

  ![track-widget-builds-scope-setting](/assets/images/docs/tools/devtools/release-notes/images-2.13.1/image2.png "track widget builds scope setting")

## Atualizações do CPU profiler

* Usar uris de pacote em vez de uris de arquivo na coluna "Source" do CPU profiler -
  [#3932](https://github.com/flutter/devtools/pull/3932)

## Atualizações do Debugger

* Corrigido bug de rolagem com breakpoints do debugger -
  [#4074](https://github.com/flutter/devtools/pull/4074)

## Atualizações do Flutter inspector

* Adicionado suporte para exibir valores flex maiores que 5 no Layout Explorer -
  [#4055](https://github.com/flutter/devtools/pull/4055)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.12.2...v2.13.1).
