---
ia-translate: true
title: Notas de versão do DevTools 2.29.0
shortTitle: Notas de versão 2.29.0
breadcrumb: 2.29.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.29.0.
showToc: false
---

A versão 2.29.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Corrigido um bug com estados de service extension não
  sendo limpos na desconexão do app. - [#6547](https://github.com/flutter/devtools/pull/6547)

* Melhorado estilo da barra de status inferior quando conectado a um app. - [#6525](https://github.com/flutter/devtools/pull/6525)

* Adicionado um workaround para corrigir funcionalidade do botão copiar no VSCode. - [#6598](https://github.com/flutter/devtools/pull/6598)

## Atualizações de Performance

* Adicionada uma opção no menu "Enhance Tracing" para rastrear atividade de
  platform channel. Isso é útil para apps com plugins. - [#6515](https://github.com/flutter/devtools/pull/6515)

  ![Track platform channels setting](/assets/images/docs/tools/devtools/release-notes/images-2.29.0/track_platform_channels.png "Track platform channels setting")

* Tornado a tela Performance disponível quando não há app conectado.
  Dados de performance salvos anteriormente do DevTools podem ser
  recarregados para visualização nesta tela. - [#6567](https://github.com/flutter/devtools/pull/6567)

* Adicionado um botão "Open" aos controles de Performance para
  carregar dados salvos anteriormente do DevTools. - [#6567](https://github.com/flutter/devtools/pull/6567)

  ![Open file button on the performance screen](/assets/images/docs/tools/devtools/release-notes/images-2.29.0/open_file_performance_screen.png "Open file button on the performance screen")

## Atualizações do CPU profiler

* Linhas guia de árvore agora sempre habilitadas para as
  abas "Bottom Up" e "Call Tree". - [#6534](https://github.com/flutter/devtools/pull/6534)

* Tornado a tela do CPU profiler disponível quando não há app conectado.
  Perfis de CPU salvos anteriormente do DevTools podem ser
  recarregados para visualização nesta tela. - [#6567](https://github.com/flutter/devtools/pull/6567)

* Adicionado um botão "Open" aos controles do CPU profiler para carregar dados
  salvos anteriormente do DevTools. - [#6567](https://github.com/flutter/devtools/pull/6567)

## Atualizações do Network profiler

* Status de rede agora são mostrados com uma cor de erro quando a requisição falhou. - [#6527](https://github.com/flutter/devtools/pull/6527)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.29.0).
