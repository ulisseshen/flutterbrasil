# Notas de lançamento do DevTools 2.13.1

A versão 2.13.1 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, confira a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Esta versão incluiu muita limpeza e redução de dívida técnica. A mais notável é a conclusão da nossa migração para *sound null safety*.
* Mostrar notas de lançamento em versões embarcadas do DevTools em IDEs -
  [#4053](https://github.com/flutter/devtools/pull/4053)
* Melhorias no rodapé do DevTools -
  [#3989](https://github.com/flutter/devtools/pull/3989),
  [#4026](https://github.com/flutter/devtools/pull/4026),
  [#4041](https://github.com/flutter/devtools/pull/4041),
  [#4076](https://github.com/flutter/devtools/pull/4076)

## Atualizações de desempenho

* Adicionada uma nova funcionalidade para ajudá-lo a depurar *raster jank* em seu aplicativo Flutter. Esta funcionalidade permite que você tire um *snapshot* da tela atual mostrada em seu aplicativo e, em seguida, detalhe o tempo de renderização dessa cena por camada. Isso pode ajudá-lo a identificar partes de uma cena que são caras para rasterizar -
  [#4046](https://github.com/flutter/devtools/pull/4046)

  ![raster-metrics-feature](/tools/devtools/release-notes/images-2.13.1/image1.png "Funcionalidade de métricas de raster")

* Adicionada uma configuração de escopo para "Track Widget Builds", permitindo que você especifique se as construções de widgets devem ser rastreadas apenas em seu código ou em todo o código -
  [#4010](https://github.com/flutter/devtools/pull/4010)

  ![track-widget-builds-scope-setting](/tools/devtools/release-notes/images-2.13.1/image2.png "Configuração de escopo de rastreamento de construções de widgets")

## Atualizações do *CPU profiler*

* Use *package uris* em vez de *file uris* na coluna "Source" do *CPU profiler* -
  [#3932](https://github.com/flutter/devtools/pull/3932)

## Atualizações do *debugger*

* Correção de um bug de rolagem com *breakpoints* do *debugger* -
  [#4074](https://github.com/flutter/devtools/pull/4074)

## Atualizações do inspetor do Flutter

* Adicionado suporte para exibir valores flex maiores que 5 no Layout Explorer -
  [#4055](https://github.com/flutter/devtools/pull/4055)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.12.2...v2.13.1).
