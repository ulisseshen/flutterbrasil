---
ia-translate: true
title: Notas de versão do DevTools 2.15.0
shortTitle: Notas de versão 2.15.0
breadcrumb: 2.15.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.15.0.
showToc: false
---

A versão 2.15.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* A versão 2.15 do DevTools inclui melhorias em todas as tabelas no
  DevTools (visualização de logging, network profiler, CPU profiler, e assim por diante) -
  [#4175](https://github.com/flutter/devtools/pull/4175)

## Atualizações de Performance

* Adicionados contornos a cada camada exibida na ferramenta Raster Metrics -
  [#4192](https://github.com/flutter/devtools/pull/4192)

  ![raster-metrics-layer-outlines](/assets/images/docs/tools/devtools/release-notes/images-2.15.0/image1.png "raster metrics layer outlines")

* Corrigido um bug com carregamento de dados offline -
  [#4189](https://github.com/flutter/devtools/pull/4189)

## Atualizações de Network

* Adicionado um visualizador Json com destaque de sintaxe para respostas de rede -
  [#4167](https://github.com/flutter/devtools/pull/4167)

  ![network-response-json-viewer](/assets/images/docs/tools/devtools/release-notes/images-2.15.0/image2.png "network response json viewer")

* Adicionada a capacidade de copiar respostas de rede -
  [#4190](https://github.com/flutter/devtools/pull/4190)

## Atualizações de Memory

* Adicionada a capacidade de selecionar um isolate diferente a partir do rodapé do DevTools -
  [#4173](https://github.com/flutter/devtools/pull/4173)
* Transformado o recurso de snapshotting automático em uma configuração configurável -
  [#4200](https://github.com/flutter/devtools/pull/4200)

## CPU profiler

* Parado de truncar manualmente URIs de origem nas tabelas do profiler -
  [#4166](https://github.com/flutter/devtools/pull/4166)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.14.0...v2.15.0).
