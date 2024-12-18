# Notas da versão do DevTools 2.18.0

A versão 2.18.0 do Dart e Flutter DevTools inclui as seguintes
mudanças, entre outras melhorias gerais. Para saber mais sobre o
DevTools, confira a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do Inspector

- Comportamento de rolagem automática aprimorado ao focalizar um
  widget - [#4283](https://github.com/flutter/devtools/pull/4283)
- Correção do problema em que o inspetor de widget não carregava ao
  conectar a um aplicativo pausado -
  [#4527](https://github.com/flutter/devtools/pull/4527)
- Melhoria dos cards de foco do inspetor de widget para mostrar o
  progresso enquanto aguarda os dados -
  [#4488](https://github.com/flutter/devtools/pull/4488)

## Atualizações de Performance

- Correção do problema em que a barra de rolagem ficava dessincronizada
  com o conteúdo do frame -
  [#4503](https://github.com/flutter/devtools/pull/4503)
- Adição de suporte offline para estatísticas raster -
  [#4491](https://github.com/flutter/devtools/pull/4491)
- Adição da coluna 'Tempo de Renderização' na aba Raster Metrics -
  [#4474](https://github.com/flutter/devtools/pull/4474)

  ![render-time-column](/tools/devtools/release-notes/images-2.18.0/render-time-column.png "Coluna tempo de renderização na aba Raster Metrics")

## Atualizações do CPU profiler

- Correção da falha quando um frame vazio é filtrado -
  [#4502](https://github.com/flutter/devtools/pull/4502)
- Correção de bugs nas árvores de perfil de CPU -
  [#4413](https://github.com/flutter/devtools/pull/4413)
- Limpeza da interface do usuário -
  [#4404](https://github.com/flutter/devtools/pull/4404)

## Atualizações de Memória

- Adição das sub-abas Profile e Allocation Tracing -
  [#4523](https://github.com/flutter/devtools/pull/4523)

  ![profile](/tools/devtools/release-notes/images-2.18.0/profile.png "Profile na aba Memory")

  ![allocation-tracing](/tools/devtools/release-notes/images-2.18.0/allocation-tracing.png "Allocation Tracing na aba Memory")

- Implementação da visualização de snapshots -
  [#4473](https://github.com/flutter/devtools/pull/4473)

## Atualizações do Debugger

- Correção de bug para abridor de arquivos e pesquisa -
  [#4525](https://github.com/flutter/devtools/pull/4525)
- Correção da área de rolagem da visualização de código -
  [#4448](https://github.com/flutter/devtools/pull/4448)
- Permitir destaque de sintaxe em capturas aninhadas no parser -
  [#4427](https://github.com/flutter/devtools/pull/4427)

## Atualizações do Network profiler

- Na aba Network, as gravações de rede agora continuam funcionando
  após o hot restart do aplicativo -
  [#4438](https://github.com/flutter/devtools/pull/4438)

## Atualizações de Logging

- Mensagens de log de fontes não-stdout agora são exibidas -
  [#4487](https://github.com/flutter/devtools/pull/4487)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde a versão
anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.17.0...v2.18.0).
