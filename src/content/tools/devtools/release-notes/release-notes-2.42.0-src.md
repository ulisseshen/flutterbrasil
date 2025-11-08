# Notas de lançamento do DevTools 2.42.0

A versão 2.42.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionado atalho "View licenses" ao diálogo About. - [#8610](https://github.com/flutter/devtools/pull/8610)

## Atualizações do Inspector

* Habilitado o novo inspector por padrão. Isso pode ser desabilitado nas configurações do inspector. - [#8650](https://github.com/flutter/devtools/pull/8650)
    ![Legacy inspector setting](/tools/devtools/release-notes/images-2.42.0/legacy_inspector_setting.png "Legacy inspector setting")
* Corrigido um problema onde selecionar um widget de implementação no dispositivo enquanto widgets de implementação estavam ocultos no [novo inspector](https://docs.flutterbrasil.dev/tools/devtools/release-notes/release-notes-2.40.1#inspector-updates) mostrava um erro. - [#8625](https://github.com/flutter/devtools/pull/8625)
* Habilitadas atualizações automáticas da árvore de widgets em hot-reloads e eventos de navegação por padrão. Isso pode ser desabilitado nas configurações do inspector. - [#8646](https://github.com/flutter/devtools/pull/8646)
    ![Auto-refresh setting](/tools/devtools/release-notes/images-2.42.0/inspector_auto_refresh_setting.png "Inspector auto-refresh setting")

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira
[o log do git do DevTools](https://github.com/flutter/devtools/tree/v2.42.0).
