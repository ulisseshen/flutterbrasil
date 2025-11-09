---
ia-translate: true
title: Notas de versão do DevTools 2.36.0
shortTitle: Notas de versão 2.36.0
breadcrumb: 2.36.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.36.0.
showToc: false
---

A versão 2.36.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações de Performance

* Adicionada uma funcionalidade para mostrar contagens de build de widget.
  Habilite esta configuração para ver contagens de build de widget para
  cada frame Flutter na ferramenta "Frame Analysis", ou para ver
  um resumo agregado dessas contagens na nova ferramenta "Rebuild Stats". -
  [#7838](https://github.com/flutter/devtools/pull/7838), [#7847](https://github.com/flutter/devtools/pull/7847)

  ![Track widget build counts setting](/assets/images/docs/tools/devtools/release-notes/images-2.36.0/track_build_counts_setting.png "Track widget build counts setting")

  ![Widget rebuild counts in the Frame Analysis view](/assets/images/docs/tools/devtools/release-notes/images-2.36.0/rebuild_counts_frame_analysis.png "Widget rebuilds counts for a flutter frame")

  ![Widget rebuild counts in the Rebuild Stats view](/assets/images/docs/tools/devtools/release-notes/images-2.36.0/rebuild_stats.png "Widget rebuilds counts aggregate stats")

## Atualizações do Network profiler

* Adicionado melhor suporte para janelas de visualização estreitas, como quando
  esta tela está incorporada em uma IDE. - [#7726](https://github.com/flutter/devtools/pull/7726)

## Atualizações da ferramenta Deep links

* Adiciona uma página de erro para explicar o problema quando
  a ferramenta falha ao analisar o projeto. - [#7767](https://github.com/flutter/devtools/pull/7767)

## Atualizações de DevTools Extension

* Corrigido um problema com detecção de extensões para
  testes Dart ou Flutter. - [#7717](https://github.com/flutter/devtools/pull/7717)
* Corrigido um problema com detecção de extensões para
  projetos Dart ou Flutter aninhados. - [#7742](https://github.com/flutter/devtools/pull/7742)
* Adicionado um exemplo ao `package:devtools_extensions` que mostra
  como interagir com o Dart Tooling Daemon de
  uma extensão DevTools. - [#7752](https://github.com/flutter/devtools/pull/7752)
* Corrigido um bug de roteamento do DevTools relacionado a
  desabilitar uma extensão. - [#7791](https://github.com/flutter/devtools/pull/7791)
* Corrigido um bug causando um erro "Page Not Found" ao
  atualizar DevTools de uma tela de extensão. - [#7822](https://github.com/flutter/devtools/pull/7822)
* Corrigido um problema de tema quando extensões estão
  incorporadas em uma IDE - [#7824](https://github.com/flutter/devtools/pull/7824)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.36.0).
