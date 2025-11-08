# Notas de lançamento do DevTools 2.22.2

A versão 2.22.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

- Prevent crashes if there is no main isolate -
  [#5232](https://github.com/flutter/devtools/pull/5232)

## Atualizações do CPU profiler

- Display stack frame URI inline with method name to
  ensure the URI is always visible in deeply nested trees -
  [#5181](https://github.com/flutter/devtools/pull/5181)

  ![inline uri](/tools/devtools/release-notes/images-2.22.2/5181.png "inline uri")

- Add the ability to filter by method name or source URI -
  [#5204](https://github.com/flutter/devtools/pull/5204)

## Atualizações de Memory

- Change filter default to show only project and 3rd party dependencies -
  [#5201](https://github.com/flutter/devtools/pull/5201).

  ![filter default](/tools/devtools/release-notes/images-2.22.2/5201.png "filter default")

- Support expression evaluation in console for running application -
  [#5248](https://github.com/flutter/devtools/pull/5248).

  ![evaluation](/tools/devtools/release-notes/images-2.22.2/5248.png "evaluation")

- Add column `Persisted` for memory diffing -
  [#5290](https://github.com/flutter/devtools/pull/5290)

  ![persisted](/tools/devtools/release-notes/images-2.22.2/5290.png "persisted")

## Atualizações do Debugger

- Add support for browser navigation history when
  navigating using the File Explorer -
  [#4906](https://github.com/flutter/devtools/pull/4906)
- Designate positional fields for `Record` types
  with the getter syntax beginning at `$1` -
  [#5272](https://github.com/flutter/devtools/pull/5272)
- Fix variable inspection for `Map` and `List` instances -
  [#5320](https://github.com/flutter/devtools/pull/5320)

  ![map and list](/tools/devtools/release-notes/images-2.22.2/5320.png "map and list")

- Fix variable inspection for `Set` instances -
  [#5323](https://github.com/flutter/devtools/pull/5323)

  ![set](/tools/devtools/release-notes/images-2.22.2/5323.png "set")


## Atualizações do Network profiler

- Improve reliability and performance of the Network tab -
  [#5056](https://github.com/flutter/devtools/pull/5056)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.21.1...v2.22.2).
