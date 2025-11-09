---
ia-translate: true
title: Notas de versão do DevTools 2.42.3
shortTitle: Notas de versão 2.42.3
breadcrumb: 2.42.3
description: Notas de versão para o Dart e Flutter DevTools versão 2.42.3.
showToc: false
---

A versão 2.42.3 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionado atalho "View licenses" ao diálogo About. - [#8610](https://github.com/flutter/devtools/pull/8610)

* Reduzido o nível de otimização wasm para resolver crashes no build dart2wasm. - [#8814](https://github.com/flutter/devtools/pull/8814)

## Atualizações do Inspector

* Habilitado o novo inspector por padrão. Isso pode ser desabilitado nas configurações do inspector. - [#8650](https://github.com/flutter/devtools/pull/8650)
  ![Legacy inspector setting](/assets/images/docs/tools/devtools/release-notes/images-2.42.3/legacy_inspector_setting.png "Legacy inspector setting")
* Corrigido um problema onde selecionar um widget de implementação no dispositivo enquanto widgets de implementação estavam ocultos no [novo inspector](https://docs.flutterbrasil.dev/tools/devtools/release-notes/release-notes-2.40.1#inspector-updates) mostrava um erro. - [#8625](https://github.com/flutter/devtools/pull/8625)
* Habilitadas atualizações automáticas da árvore de widgets em hot-reloads e eventos de navegação por padrão. Isso pode ser desabilitado nas configurações do inspector. - [#8646](https://github.com/flutter/devtools/pull/8646)
  ![Auto-refresh setting](/assets/images/docs/tools/devtools/release-notes/images-2.42.3/inspector_auto_refresh_setting.png "Inspector auto-refresh setting")

## Atualizações do Network profiler

* Corrigido um problema onde as requisições HTTP às vezes não eram exibidas corretamente, particularmente quando DevTools está se comunicando
  com uma aplicação por uma conexão de rede lenta. - [#8860](https://github.com/flutter/devtools/pull/8860)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.42.3).
