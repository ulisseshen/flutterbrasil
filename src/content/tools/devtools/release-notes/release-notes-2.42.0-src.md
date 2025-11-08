# Notas de lançamento do DevTools 2.42.0

A versão 2.42.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionado "View licenses" shortcut to the About dialog. - [#8610](https://github.com/flutter/devtools/pull/8610)

## Atualizações do Inspector

* Habilitado the new inspector by default. This can be disabled in the inspector settings. - [#8650](https://github.com/flutter/devtools/pull/8650)
    ![Legacy inspector setting](/tools/devtools/release-notes/images-2.42.0/legacy_inspector_setting.png "Legacy inspector setting")
* Corrigido an issue where selecting an implementation widget on the device while implementation widgets were hidden in the [new inspector](https://docs.flutter.dev/tools/devtools/release-notes/release-notes-2.40.1#inspector-updates) showed an error. - [#8625](https://github.com/flutter/devtools/pull/8625)
* Habilitado auto-refreshes of the widget tree on hot-reloads and navigation events by default. This can be disabled in the inspector settings. - [#8646](https://github.com/flutter/devtools/pull/8646)
    ![Auto-refresh setting](/tools/devtools/release-notes/images-2.42.0/inspector_auto_refresh_setting.png "Inspector auto-refresh setting")

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.42.0).
