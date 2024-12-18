# Notas de lançamento do DevTools 2.23.1

O lançamento 2.23.1 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Atualização do DevTools para o novo design do Material 3 -
  [#5429](https://github.com/flutter/devtools/pull/5429)
* Usar o service worker padrão do Flutter -
  [#5331](https://github.com/flutter/devtools/pull/5331)
* Adicionada a nova funcionalidade de registro detalhado para nos ajudar a depurar problemas dos usuários -
  [#5404](https://github.com/flutter/devtools/pull/5404)

  ![registro detalhado](/tools/devtools/release-notes/images-2.23.1/verbose-logging.png "verbose_logging")

* Corrigido um bug em que alguns erros assíncronos não estavam sendo relatados -
  [#5456](https://github.com/flutter/devtools/pull/5456)
* Adicionado suporte para visualização de dados após um aplicativo se desconectar para
  telas que suportam visualização offline
  (atualmente apenas as páginas Performance e CPU profiler) -
  [#5509](https://github.com/flutter/devtools/pull/5509)
* Incluir botão de configurações no rodapé da visualização incorporada -
  [#5528](https://github.com/flutter/devtools/pull/5528)

## Atualizações de desempenho

* Corrigida uma regressão de desempenho no processamento de eventos da linha do tempo -
  [#5460](https://github.com/flutter/devtools/pull/5460)
* Persistir a preferência do usuário sobre se o
  gráfico de Frames do Flutter deve ser mostrado por padrão -
  [#5339](https://github.com/flutter/devtools/pull/5339)
* Direcionar os usuários para o [Impeller](https://docs.flutter.dev/perf/impeller) quando
  jank de compilação de shader é detectado em um dispositivo iOS -
  [#5455](https://github.com/flutter/devtools/pull/5455)
* Remover o CPU profiler do visualizador de rastreamento legado -
  [#5539](https://github.com/flutter/devtools/pull/5539)

## Atualizações do CPU profiler

* Adicionar uma Tabela de Métodos ao CPU profiler -
  [#5366](https://github.com/flutter/devtools/pull/5366)

  ![Tabela de Métodos](/tools/devtools/release-notes/images-2.23.1/cpu-method-table.png "method_table")

* Melhorar o desempenho do processamento de dados no CPU profiler -
  [#5468](https://github.com/flutter/devtools/pull/5468),
  [#5533](https://github.com/flutter/devtools/pull/5533),
  [#5535](https://github.com/flutter/devtools/pull/5535)
* Melhorias de polimento e desempenho para o gráfico de chamas do perfil da CPU -
  [#5529](https://github.com/flutter/devtools/pull/5529)
* Adicionar a capacidade de inspecionar estatísticas para um perfil de CPU -
  [#5340](https://github.com/flutter/devtools/pull/5340)
* Corrigido um bug onde os frames da stack Nativa estavam sem seus nomes -
  [#5344](https://github.com/flutter/devtools/pull/5344)
* Corrigido um erro no cálculo do tempo total e próprio para a árvore bottom up -
  [#5348](https://github.com/flutter/devtools/pull/5348)
* Adicionado suporte para zoom e navegação no gráfico de chamas
  com as teclas ,AOE (útil para usuários de Dvorak) -
  [#5545](https://github.com/flutter/devtools/pull/5545)

## Atualizações de memória

* Corrigido um bug de filtragem na visualização "Rastrear Instâncias" -
  [#5406](https://github.com/flutter/devtools/pull/5406)
* Habilitada a avaliação e navegação para instâncias no heap snapshot -
  [#5542](https://github.com/flutter/devtools/pull/5542)
* Corrigida a falha do heap snapshot -
  [#5520](https://github.com/flutter/devtools/pull/5520)
* Parar de exibir tamanhos externos no perfil de alocação -
  [#5555](https://github.com/flutter/devtools/pull/5555)
* Expor totais para memória no heap snapshot -
  [#5593](https://github.com/flutter/devtools/pull/5593)

## Atualizações do Depurador

* Corrigido um bug onde a inspeção de variáveis
  para instâncias às vezes não mostrava filhos -
  [#5356](https://github.com/flutter/devtools/pull/5356)
* Ocultar o diálogo "pesquisar no arquivo" se o diálogo "pesquisa de arquivo" estiver aberto -
  [#5393](https://github.com/flutter/devtools/pull/5393)
* Corrigido um bug de pesquisa de arquivo onde a última letra desaparecia ao
  pesquisar no final do nome do arquivo -
  [#5397](https://github.com/flutter/devtools/pull/5397)
* Adicionar ícone de pesquisa na barra de arquivo para tornar a pesquisa de arquivo mais detectável -
  [#5351](https://github.com/flutter/devtools/issues/5351)
* Permitir a avaliação de expressões ao pausar em JS para aplicativos da web -
  [#5427](https://github.com/flutter/devtools/pull/5427)
* Atualizar o destaque de sintaxe para
  [dart-lang/dart-syntax-highlight v1.2.0](https://github.com/dart-lang/dart-syntax-highlight/blob/master/CHANGELOG.md#120-2023-01-30) -
  [#5477](https://github.com/flutter/devtools/pull/5477)
* O painel do depurador respeita o "modo denso" -
  [#5517](https://github.com/flutter/devtools/pull/5517)

## Atualizações do Network profiler

* Corrigido um bug ao visualizar respostas JSON com valores nulos -
  [#5424](https://github.com/flutter/devtools/pull/5424)
* Corrigido um bug onde as solicitações JSON eram mostradas em texto simples,
  em vez do visualizador JSON formatado -
  [#5463](https://github.com/flutter/devtools/pull/5463)
* Corrigido um problema de UI onde o botão de cópia na guia de resposta ou solicitação
  permitiria copiar enquanto ainda carregava os dados -
  [#5476](https://github.com/flutter/devtools/pull/5476)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.22.2...v2.23.1).
