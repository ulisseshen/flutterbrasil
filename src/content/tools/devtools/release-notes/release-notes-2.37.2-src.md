# Notas de lançamento do DevTools 2.37.2

A versão 2.37.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Melhorado messaging when a screen is unavailable for the
  platform of the connected app. - [#7958](https://github.com/flutter/devtools/pull/7958)
* Corrigido a bug where an infinite spinner was shown upon
  app disconnect. - [#7992](https://github.com/flutter/devtools/pull/7992)
* Corrigido a bug where trying to reuse a disconnected DevTools instance would
  fail. - [#8009](https://github.com/flutter/devtools/pull/8009)

## Atualizações do Performance

* Removido the "Raster Stats" feature.
  This tool did not work for the Impeller rendering engine, and
  the information it gave for the SKIA rendering engine was 
  often misleading and unactionable. Users should follow the
  official Flutter guidance for [Performance and optimization](/perf) when
  debugging the rendering performance of their Flutter apps. - [#7981](https://github.com/flutter/devtools/pull/7981).

## Atualizações do Network profiler

* Corrigido an issue where socket statistics were being reported as web sockets. - [#8061](https://github.com/flutter/devtools/pull/8061)

    ![Network profiler correctly displaying socket statistics](/tools/devtools/release-notes/images-2.37.2/socket-profiling.png "Network profiler correctly displaying socket statistics")

* Adicionado query parameters to the request details view. - [#7825](https://github.com/flutter/devtools/pull/7825)

## VS Code Sidebar updates

* Adicionado buttons for all DevTools tools in the sidebar by default, even when
  there are no debug sessions available. - [#7947](https://github.com/flutter/devtools/pull/7947)

    ![DevTools tools in the sidebar](/tools/devtools/release-notes/images-2.37.2/devtools_in_sidebar.png)

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.37.0).
