# Notas de lançamento do DevTools 2.18.0

A versão 2.18.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do Inspector

- Comportamento de rolagem automática melhorado ao encaixar um widget em foco -
  [#4283](https://github.com/flutter/devtools/pull/4283)
- Corrigido problema onde o widget inspector não carregava ao
  conectar a um app pausado -
  [#4527](https://github.com/flutter/devtools/pull/4527)
- Melhorados cartões de hover do widget inspector para mostrar progresso enquanto aguarda dados -
  [#4488](https://github.com/flutter/devtools/pull/4488)

## Atualizações do Performance

- Corrigido problema onde a barra de rolagem saía de sincronia com o conteúdo do frame -
  [#4503](https://github.com/flutter/devtools/pull/4503)
- Adicionado suporte offline para estatísticas de raster -
  [#4491](https://github.com/flutter/devtools/pull/4491)
- Adicionada coluna 'Rendering time' à aba Raster Metrics -
  [#4474](https://github.com/flutter/devtools/pull/4474)

  ![render-time-column](/tools/devtools/release-notes/images-2.18.0/render-time-column.png "Rendering time column in the Raster Metrics tab")

## Atualizações do CPU profiler

- Corrigido crash quando um frame vazio é filtrado -
  [#4502](https://github.com/flutter/devtools/pull/4502)
- Corrigidos bugs nas árvores de perfil de CPU -
  [#4413](https://github.com/flutter/devtools/pull/4413)
- Limpeza de UI - [#4404](https://github.com/flutter/devtools/pull/4404)

## Atualizações do Memory

- Adicionadas sub-abas Profile e Allocation Tracing -
  [#4523](https://github.com/flutter/devtools/pull/4523)

  ![profile](/tools/devtools/release-notes/images-2.18.0/profile.png "Profile in Memory tab")

  ![allocation-tracing](/tools/devtools/release-notes/images-2.18.0/allocation-tracing.png "Allocation Tracing in Memory tab")

- Implementada visualização de snapshot -
  [#4473](https://github.com/flutter/devtools/pull/4473)

## Atualizações do Debugger

- Corrigido bug para abridor de arquivo e busca -
  [#4525](https://github.com/flutter/devtools/pull/4525)
- Corrigida área rolável da visualização de código -
  [#4448](https://github.com/flutter/devtools/pull/4448)
- Permitido destaque de sintaxe em capturas aninhadas no parser -
  [#4427](https://github.com/flutter/devtools/pull/4427)

## Atualizações do Network profiler

- Quando na aba Network, gravações de rede agora continuam funcionando
  após o app fazer hot restart -
  [#4438](https://github.com/flutter/devtools/pull/4438)

## Atualizações do Logging

- Mensagens de log de fontes não-stdout agora são mostradas -
  [#4487](https://github.com/flutter/devtools/pull/4487)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.17.0...v2.18.0).
