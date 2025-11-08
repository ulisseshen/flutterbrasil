# Notas de lançamento do DevTools 2.18.0

A versão 2.18.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações do Inspector

- Auto scrolling behavior improved when snapping a widget into focus -
  [#4283](https://github.com/flutter/devtools/pull/4283)
- Fix issue where widget inspector wouldn't load when
  connecting to a paused app -
  [#4527](https://github.com/flutter/devtools/pull/4527)
- Improve widget inspector hover cards to show progress while waiting for data -
  [#4488](https://github.com/flutter/devtools/pull/4488)

## Atualizações de Performance

- Fix issue where scrollbar would go out of sync with the frame content -
  [#4503](https://github.com/flutter/devtools/pull/4503)
- Add offline support for raster stats -
  [#4491](https://github.com/flutter/devtools/pull/4491)
- Add 'Rendering time' column to Raster Metrics tab -
  [#4474](https://github.com/flutter/devtools/pull/4474)

  ![render-time-column](/tools/devtools/release-notes/images-2.18.0/render-time-column.png "Rendering time column in the Raster Metrics tab")

## Atualizações do CPU profiler

- Fix crash when an empty frame is filtered -
  [#4502](https://github.com/flutter/devtools/pull/4502)
- Fix bugs in CPU profile trees -
  [#4413](https://github.com/flutter/devtools/pull/4413)
- UI Cleanup - [#4404](https://github.com/flutter/devtools/pull/4404)

## Atualizações de Memory

- Add Profile and Allocation Tracing sub-tabs -
  [#4523](https://github.com/flutter/devtools/pull/4523)

  ![profile](/tools/devtools/release-notes/images-2.18.0/profile.png "Profile in Memory tab")

  ![allocation-tracing](/tools/devtools/release-notes/images-2.18.0/allocation-tracing.png "Allocation Tracing in Memory tab")

- Implement snapshot visualization -
  [#4473](https://github.com/flutter/devtools/pull/4473)

## Atualizações do Debugger

- Fix bug for file opener and search -
  [#4525](https://github.com/flutter/devtools/pull/4525)
- Fix the code view's scrollable area -
  [#4448](https://github.com/flutter/devtools/pull/4448)
- Allow syntax highlighting on nested captures in parser -
  [#4427](https://github.com/flutter/devtools/pull/4427)

## Atualizações do Network profiler

- When on the Network tab, network recordings now continue working
  after the app hot restarts -
  [#4438](https://github.com/flutter/devtools/pull/4438)

## Atualizações de Logging

- Log messages from non-stdout sources are now shown -
  [#4487](https://github.com/flutter/devtools/pull/4487)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.17.0...v2.18.0).
