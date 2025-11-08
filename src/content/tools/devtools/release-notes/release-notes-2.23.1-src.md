# Notas de lançamento do DevTools 2.23.1

A versão 2.23.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Atualização do DevTools para o novo design Material 3 -
  [#5429](https://github.com/flutter/devtools/pull/5429)
* Uso do service worker padrão do Flutter -
  [#5331](https://github.com/flutter/devtools/pull/5331)
* Adicionada nova funcionalidade de logging verboso para nos ajudar a depurar problemas de usuários -
  [#5404](https://github.com/flutter/devtools/pull/5404)

  ![verbose logging](/tools/devtools/release-notes/images-2.23.1/verbose-logging.png "verbose_logging")

* Corrigido bug onde alguns erros assíncronos não estavam sendo reportados -
  [#5456](https://github.com/flutter/devtools/pull/5456)
* Adicionado suporte para visualizar dados após um app desconectar para
  telas que suportam visualização offline
  (atualmente apenas as páginas Performance e CPU profiler) -
  [#5509](https://github.com/flutter/devtools/pull/5509)
* Incluído botão de configurações no rodapé da visualização incorporada -
  [#5528](https://github.com/flutter/devtools/pull/5528)

## Atualizações do Performance

* Corrigida regressão de desempenho no processamento de eventos da timeline -
  [#5460](https://github.com/flutter/devtools/pull/5460)
* Persistência da preferência do usuário sobre se o
  gráfico Flutter Frames deve ser exibido por padrão -
  [#5339](https://github.com/flutter/devtools/pull/5339)
* Direcionamento de usuários para [Impeller](https://docs.flutter.dev/perf/impeller) quando
  jank de compilação de shader é detectado em um dispositivo iOS -
  [#5455](https://github.com/flutter/devtools/pull/5455)
* Removido o CPU profiler do visualizador de trace legado -
  [#5539](https://github.com/flutter/devtools/pull/5539)

## Atualizações do CPU profiler

* Adicionada Tabela de Métodos ao CPU profiler -
  [#5366](https://github.com/flutter/devtools/pull/5366)

  ![Method table](/tools/devtools/release-notes/images-2.23.1/cpu-method-table.png "method_table")

* Melhorado o desempenho do processamento de dados no CPU profiler -
  [#5468](https://github.com/flutter/devtools/pull/5468),
  [#5533](https://github.com/flutter/devtools/pull/5533),
  [#5535](https://github.com/flutter/devtools/pull/5535)
* Polimento e melhorias de desempenho para o gráfico flame do perfil de CPU -
  [#5529](https://github.com/flutter/devtools/pull/5529)
* Adicionada capacidade de inspecionar estatísticas para um perfil de CPU -
  [#5340](https://github.com/flutter/devtools/pull/5340)
* Corrigido bug onde stack frames nativos estavam faltando seu nome -
  [#5344](https://github.com/flutter/devtools/pull/5344)
* Corrigido erro nos cálculos de tempo total e tempo próprio para a árvore bottom up -
  [#5348](https://github.com/flutter/devtools/pull/5348)
* Adicionado suporte para zoom e navegação no gráfico flame
  com teclas ,AOE (útil para usuários de Dvorak) -
  [#5545](https://github.com/flutter/devtools/pull/5545)

## Atualizações do Memory

* Corrigido bug de filtragem na visualização "Trace Instances" -
  [#5406](https://github.com/flutter/devtools/pull/5406)
* Habilitada avaliação e navegação para instâncias em snapshot do heap -
  [#5542](https://github.com/flutter/devtools/pull/5542)
* Corrigida falha no snapshot do heap -
  [#5520](https://github.com/flutter/devtools/pull/5520)
* Parada de exibição de tamanhos externos no perfil de alocação -
  [#5555](https://github.com/flutter/devtools/pull/5555)
* Expostos totais para memória em snapshot do heap -
  [#5593](https://github.com/flutter/devtools/pull/5593)

## Atualizações do Debugger

* Corrigido bug onde inspeção de variáveis
  para instâncias às vezes não mostrava filhos -
  [#5356](https://github.com/flutter/devtools/pull/5356)
* Ocultação do diálogo "search in file" se o diálogo "file search" estiver aberto -
  [#5393](https://github.com/flutter/devtools/pull/5393)
* Corrigido bug de busca de arquivo onde a última letra desaparecia ao
  buscar no final do nome do arquivo -
  [#5397](https://github.com/flutter/devtools/pull/5397)
* Adicionado ícone de busca na barra de arquivo para tornar a busca de arquivo mais descobrível -
  [#5351](https://github.com/flutter/devtools/issues/5351)
* Permitida avaliação de expressões ao pausar em JS para apps web -
  [#5427](https://github.com/flutter/devtools/pull/5427)
* Atualização do destaque de sintaxe para
  [dart-lang/dart-syntax-highlight v1.2.0](https://github.com/dart-lang/dart-syntax-highlight/blob/master/CHANGELOG.md#120-2023-01-30) -
  [#5477](https://github.com/flutter/devtools/pull/5477)
* Painel do debugger respeita "dense mode" -
  [#5517](https://github.com/flutter/devtools/pull/5517)

## Atualizações do Network profiler

* Corrigido bug ao visualizar respostas JSON com valores nulos -
  [#5424](https://github.com/flutter/devtools/pull/5424)
* Corrigido bug onde requisições JSON eram mostradas em texto simples,
  em vez do visualizador JSON formatado -
  [#5463](https://github.com/flutter/devtools/pull/5463)
* Corrigido problema de UI onde o botão de copiar na aba de resposta ou requisição
  permitia copiar enquanto ainda carregando os dados -
  [#5476](https://github.com/flutter/devtools/pull/5476)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.22.2...v2.23.1).
