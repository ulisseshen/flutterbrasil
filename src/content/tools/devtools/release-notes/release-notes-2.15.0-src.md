# Notas da versão DevTools 2.15.0

A versão 2.15.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* A versão 2.15 do DevTools inclui melhorias em todas as tabelas no
  DevTools (visualização de logging, profiler de rede, profiler de CPU, e assim
  por diante) - [#4175](https://github.com/flutter/devtools/pull/4175)

## Atualizações de desempenho

* Adicionadas contornos para cada camada exibida na ferramenta Raster Metrics -
  [#4192](https://github.com/flutter/devtools/pull/4192)

  ![contornos-da-camada-raster-metrics](/tools/devtools/release-notes/images-2.15.0/image1.png "contornos da camada raster metrics")

* Corrigido um bug com o carregamento de dados offline -
  [#4189](https://github.com/flutter/devtools/pull/4189)

## Atualizações de rede

* Adicionado um visualizador JSON com destaque de sintaxe para respostas de rede -
  [#4167](https://github.com/flutter/devtools/pull/4167)

  ![visualizador-json-de-resposta-de-rede](/tools/devtools/release-notes/images-2.15.0/image2.png "visualizador json de resposta de rede")

* Adicionada a capacidade de copiar respostas de rede -
  [#4190](https://github.com/flutter/devtools/pull/4190)

## Atualizações de memória

* Adicionada a capacidade de selecionar um isolate diferente do rodapé do DevTools -
  [#4173](https://github.com/flutter/devtools/pull/4173)
* Tornou o recurso de snapshot automático uma configuração configurável -
  [#4200](https://github.com/flutter/devtools/pull/4200)

## Profiler de CPU

* Parar de truncar manualmente os URIs de origem nas tabelas do profiler -
  [#4166](https://github.com/flutter/devtools/pull/4166)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.14.0...v2.15.0).
