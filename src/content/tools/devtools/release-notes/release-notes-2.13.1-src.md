# Notas de lançamento do DevTools 2.13.1

A versão 2.13.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* This release included a lot of cleanup and reduction in technical debt.
  The most notable is the completion of our migration to sound null safety.
* Show release notes in IDE embedded versions of DevTools -
  [#4053](https://github.com/flutter/devtools/pull/4053)
* Polish to the DevTools footer -
  [#3989](https://github.com/flutter/devtools/pull/3989),
  [#4026](https://github.com/flutter/devtools/pull/4026),
  [#4041](https://github.com/flutter/devtools/pull/4041),
  [#4076](https://github.com/flutter/devtools/pull/4076)

## Atualizações de Performance

* Added a new feature to help you debug raster jank in your Flutter app.
  This feature allows you to take a snapshot of the
  current screen shown in your app, and then
  break down rendering time for that scene by layer.
  This can help you identify parts of a scene that are expensive to rasterize -
  [#4046](https://github.com/flutter/devtools/pull/4046)

  ![raster-metrics-feature](/tools/devtools/release-notes/images-2.13.1/image1.png "raster metrics feature")

* Added a scope setting for "Track Widget Builds", allowing
  you to specify whether widget builds should be tracked in
  your code only or in all code -
  [#4010](https://github.com/flutter/devtools/pull/4010)

  ![track-widget-builds-scope-setting](/tools/devtools/release-notes/images-2.13.1/image2.png "track widget builds scope setting")

## Atualizações do CPU profiler

* Use package uris instead of file uris in the CPU profiler "Source" column -
  [#3932](https://github.com/flutter/devtools/pull/3932)

## Atualizações do Debugger

* Fix scrolling bug with debugger breakpoints -
  [#4074](https://github.com/flutter/devtools/pull/4074)

## Flutter inspector updates

* Add support for displaying flex values larger than 5 in the Layout Explorer -
  [#4055](https://github.com/flutter/devtools/pull/4055)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.12.2...v2.13.1).
