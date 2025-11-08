# Notas de lançamento do DevTools 2.29.0

A versão 2.29.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* Fix a bug with service extension states not
  being cleared on app disconnect. - [#6547](https://github.com/flutter/devtools/pull/6547)

* Improved styling of bottom status bar when connected to an app. - [#6525](https://github.com/flutter/devtools/pull/6525)

* Added a workaround to fix copy button functionality in VSCode. - [#6598](https://github.com/flutter/devtools/pull/6598)

## Atualizações de Performance

* Added an option in the "Enhance Tracing" menu for tracking platform channel
  activity. This is useful for apps with plugins. - [#6515](https://github.com/flutter/devtools/pull/6515)

  ![Track platform channels setting](/tools/devtools/release-notes/images-2.29.0/track_platform_channels.png "Track platform channels setting")

* Made the Performance screen available when there is no connected app.
  Performance data that was previously saved from DevTools can be
  reloaded for viewing from this screen. - [#6567](https://github.com/flutter/devtools/pull/6567)

* Added an "Open" button to the Performance controls for
  loading data that was previously saved from DevTools. - [#6567](https://github.com/flutter/devtools/pull/6567)

  ![Open file button on the performance screen](/tools/devtools/release-notes/images-2.29.0/open_file_performance_screen.png "Open file button on the performance screen")

## Atualizações do CPU profiler

* Tree guidelines are now always enabled for the
  "Bottom Up" and "Call Tree" tabs. - [#6534](https://github.com/flutter/devtools/pull/6534)

* Made the CPU profiler screen available when there is no connected app.
  CPU profiles that were previously saved from DevTools can be
  reloaded for viewing from this screen. - [#6567](https://github.com/flutter/devtools/pull/6567)

* Added an "Open" button to the CPU profiler controls for loading data that
  was previously saved from DevTools. - [#6567](https://github.com/flutter/devtools/pull/6567)

## Atualizações do Network profiler

* Network statuses now show with an error color when the request failed. - [#6527](https://github.com/flutter/devtools/pull/6527)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira
[o log do git do DevTools](https://github.com/flutter/devtools/tree/v2.29.0).
