---
ia-translate: true
title: Notas de versão do DevTools 2.23.1
shortTitle: Notas de versão 2.23.1
breadcrumb: 2.23.1
description: Notas de versão para o Dart e Flutter DevTools versão 2.23.1.
showToc: false
---

A versão 2.23.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* Atualizado DevTools para o novo design Material 3 -
  [#5429](https://github.com/flutter/devtools/pull/5429)
* Usado o service worker padrão do Flutter -
  [#5331](https://github.com/flutter/devtools/pull/5331)
* Adicionada a nova funcionalidade de logging verboso para nos ajudar a debugar problemas de usuários -
  [#5404](https://github.com/flutter/devtools/pull/5404)

  ![verbose logging](/assets/images/docs/tools/devtools/release-notes/images-2.23.1/verbose-logging.png "verbose_logging")

* Corrigido um bug onde alguns erros assíncronos não estavam sendo reportados -
  [#5456](https://github.com/flutter/devtools/pull/5456)
* Adicionado suporte para visualizar dados após um app desconectar para
  telas que suportam visualização offline
  (atualmente apenas as páginas Performance e CPU profiler) -
  [#5509](https://github.com/flutter/devtools/pull/5509)
* Incluído botão de settings no rodapé da visualização incorporada -
  [#5528](https://github.com/flutter/devtools/pull/5528)

## Atualizações de Performance

* Corrigida uma regressão de performance no processamento de eventos de timeline -
  [#5460](https://github.com/flutter/devtools/pull/5460)
* Persistida a preferência do usuário sobre se o
  gráfico Flutter Frames deve ser mostrado por padrão -
  [#5339](https://github.com/flutter/devtools/pull/5339)
* Direcionados usuários para [Impeller](https://docs.flutterbrasil.dev/perf/impeller) quando
  jank de compilação de shader é detectado em um dispositivo iOS -
  [#5455](https://github.com/flutter/devtools/pull/5455)
* Removido o CPU profiler do visualizador de trace legado -
  [#5539](https://github.com/flutter/devtools/pull/5539)

## Atualizações do CPU profiler

* Adicionada uma Method Table ao CPU profiler -
  [#5366](https://github.com/flutter/devtools/pull/5366)

  ![Method table](/assets/images/docs/tools/devtools/release-notes/images-2.23.1/cpu-method-table.png "method_table")

* Melhorada a performance do processamento de dados no CPU profiler -
  [#5468](https://github.com/flutter/devtools/pull/5468),
  [#5533](https://github.com/flutter/devtools/pull/5533),
  [#5535](https://github.com/flutter/devtools/pull/5535)
* Refinamento e melhorias de performance para o flame chart do CPU profile -
  [#5529](https://github.com/flutter/devtools/pull/5529)
* Adicionada capacidade de inspecionar estatísticas para um CPU profile -
  [#5340](https://github.com/flutter/devtools/pull/5340)
* Corrigido um bug onde frames de stack Native estavam faltando seu nome -
  [#5344](https://github.com/flutter/devtools/pull/5344)
* Corrigido um erro nos cálculos de tempo total e self time para a árvore bottom up -
  [#5348](https://github.com/flutter/devtools/pull/5348)
* Adicionado suporte para zoom e navegação no flame chart
  com teclas ,AOE (útil para usuários Dvorak) -
  [#5545](https://github.com/flutter/devtools/pull/5545)

## Atualizações de Memory

* Corrigido bug de filtragem na visualização "Trace Instances" -
  [#5406](https://github.com/flutter/devtools/pull/5406)
* Habilitada avaliação e navegação para instâncias em heap snapshot -
  [#5542](https://github.com/flutter/devtools/pull/5542)
* Corrigida falha no heap snapshot -
  [#5520](https://github.com/flutter/devtools/pull/5520)
* Parada a exibição de tamanhos externos no allocation profile -
  [#5555](https://github.com/flutter/devtools/pull/5555)
* Expostos totais para memória no heap snapshot -
  [#5593](https://github.com/flutter/devtools/pull/5593)

## Atualizações do Debugger

* Corrigido um bug onde inspeção de variável
  para instâncias às vezes não mostrava filhos -
  [#5356](https://github.com/flutter/devtools/pull/5356)
* Escondido diálogo "search in file" se o diálogo "file search" estiver aberto -
  [#5393](https://github.com/flutter/devtools/pull/5393)
* Corrigido bug de busca de arquivo onde a última letra desaparecia ao
  buscar no final do nome do arquivo -
  [#5397](https://github.com/flutter/devtools/pull/5397)
* Adicionado ícone de busca na barra de arquivo para tornar a busca de arquivo mais descobrível -
  [#5351](https://github.com/flutter/devtools/issues/5351)
* Permitida avaliação de expressão ao pausar em JS para apps web -
  [#5427](https://github.com/flutter/devtools/pull/5427)
* Atualizado syntax highlighting para
  [dart-lang/dart-syntax-highlight v1.2.0](https://github.com/dart-lang/dart-syntax-highlight/blob/master/CHANGELOG.md#120-2023-01-30) -
  [#5477](https://github.com/flutter/devtools/pull/5477)
* Painel do debugger respeita "dense mode" -
  [#5517](https://github.com/flutter/devtools/pull/5517)

## Atualizações do Network profiler

* Corrigido um bug ao visualizar respostas JSON com valores null -
  [#5424](https://github.com/flutter/devtools/pull/5424)
* Corrigido um bug onde requisições JSON eram mostradas em texto simples,
  ao invés do visualizador JSON formatado -
  [#5463](https://github.com/flutter/devtools/pull/5463)
* Corrigido um problema de UI onde o botão de copiar na aba de resposta ou requisição
  permitia copiar enquanto ainda estava carregando os dados -
  [#5476](https://github.com/flutter/devtools/pull/5476)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.22.2...v2.23.1).
