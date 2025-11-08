# Notas de lançamento do DevTools 2.15.0

A versão 2.15.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* A versão 2.15 do DevTools inclui melhorias em todas as tabelas do
  DevTools (visualização de logging, network profiler, CPU profiler e assim por diante) -
  [#4175](https://github.com/flutter/devtools/pull/4175)

## Atualizações do Performance

* Adicionados contornos a cada camada exibida na ferramenta Raster Metrics -
  [#4192](https://github.com/flutter/devtools/pull/4192)

  ![raster-metrics-layer-outlines](/tools/devtools/release-notes/images-2.15.0/image1.png "raster metrics layer outlines")

* Corrigido um bug com carregamento de dados offline -
  [#4189](https://github.com/flutter/devtools/pull/4189)

## Atualizações do Network

* Adicionado visualizador Json com destaque de sintaxe para respostas de rede -
  [#4167](https://github.com/flutter/devtools/pull/4167)

  ![network-response-json-viewer](/tools/devtools/release-notes/images-2.15.0/image2.png "network response json viewer")

* Adicionada capacidade de copiar respostas de rede -
  [#4190](https://github.com/flutter/devtools/pull/4190)

## Atualizações do Memory

* Adicionada capacidade de selecionar um isolate diferente no rodapé do DevTools -
  [#4173](https://github.com/flutter/devtools/pull/4173)
* Tornada a funcionalidade de snapshot automático uma configuração ajustável -
  [#4200](https://github.com/flutter/devtools/pull/4200)

## CPU profiler

* Parada de truncar manualmente URIs de origem nas tabelas do profiler -
  [#4166](https://github.com/flutter/devtools/pull/4166)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.14.0...v2.15.0).
