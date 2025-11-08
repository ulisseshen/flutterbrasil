# Notas de lançamento do DevTools 2.40.2

A versão 2.40.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionar a setting that allows users to opt in to loading DevTools
  with WebAssembly. - [#8270](https://github.com/flutter/devtools/pull/8270)

  ![Wasm opt-in setting](/tools/devtools/release-notes/images-2.40.2/wasm_setting.png "DevTools setting to opt into wasm.")

* Removido the legacy Provider screen from DevTools.
  The `package:provider` tool is now distributed as a
  DevTools extension from `package:provider`.
  Upgrade your `package:provider` dependency to
  use the extension. - [#8364](https://github.com/flutter/devtools/pull/8364)

* Corrigido a bug that was causing the DevTools release notes to
  always show. - [#8277](https://github.com/flutter/devtools/pull/8277)

* Adicionado support for loading extensions in pub workspaces
  [8347](https://github.com/flutter/devtools/pull/8347).

* Mapped error stack traces to use the Dart source code locations so
  that they are human-readable. - [#8385](https://github.com/flutter/devtools/pull/8385)

* Adicionado handling for IDE theme change events to
  update embedded DevTools UI. - [#8336](https://github.com/flutter/devtools/pull/8336)

* Corrigido a bug that was causing data filters to be cleared when clearing data
on the Network and Logging screens. - [#8407](https://github.com/flutter/devtools/pull/8407)

* Corrigido a bug that was causing the navigator to lose state when opening the VM
Flags dialog. - [#8413](https://github.com/flutter/devtools/pull/8413)

* Tables match IDE theme when embedded in an IDE. - [#8498](https://github.com/flutter/devtools/pull/8498)

## Atualizações do Inspector

- Adicionado a setting to the Flutter Inspector controls that
  allows users to opt in to the newly redesigned Flutter Inspector. - [#8342](https://github.com/flutter/devtools/pull/8342)

  ![New inspector opt-in setting](/tools/devtools/release-notes/images-2.40.2/new_inspector.png "DevTools setting to opt into the new Flutter Inspector.")

## Atualizações do Performance

* Corrigido an issue with the "Refreshing timeline" overlay that was getting shown
  when it should not have been. - [#8318](https://github.com/flutter/devtools/pull/8318)

## Atualizações do Network profiler

* Resolved an issue in `.har` export where
  response content was sometimes missing in the data. - [#8333](https://github.com/flutter/devtools/pull/8333)

## Deep links tool updates

- Adicionado support for validating iOS deep link settings. - [#8394](https://github.com/flutter/devtools/pull/8394)

  ![Deep link validator for iOS](/tools/devtools/release-notes/images-2.40.2/deep_link_ios.png "DevTools Deep link validator Page")

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.40.2).
