---
ia-translate: true
title: Notas de versão do DevTools 2.37.2
shortTitle: Notas de versão 2.37.2
breadcrumb: 2.37.2
description: Notas de versão para o Dart e Flutter DevTools versão 2.37.2.
showToc: false
---

A versão 2.37.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Melhoradas mensagens quando uma tela não está disponível para a
  plataforma do app conectado. - [#7958](https://github.com/flutter/devtools/pull/7958)
* Corrigido um bug onde um spinner infinito era mostrado após
  desconexão do app. - [#7992](https://github.com/flutter/devtools/pull/7992)
* Corrigido um bug onde tentar reutilizar uma instância DevTools desconectada
  falharia. - [#8009](https://github.com/flutter/devtools/pull/8009)

## Atualizações de Performance

* Removida a funcionalidade "Raster Stats".
  Esta ferramenta não funcionava para o motor de renderização Impeller, e
  a informação que dava para o motor de renderização SKIA era
  frequentemente enganosa e não acionável. Os usuários devem seguir a
  orientação oficial do Flutter para [Performance e otimização](/perf) ao
  debugar a performance de renderização de seus apps Flutter. - [#7981](https://github.com/flutter/devtools/pull/7981).

## Atualizações do Network profiler

* Corrigido um problema onde estatísticas de socket estavam sendo reportadas como web sockets. - [#8061](https://github.com/flutter/devtools/pull/8061)

  ![Network profiler correctly displaying socket statistics](/assets/images/docs/tools/devtools/release-notes/images-2.37.2/socket-profiling.png "Network profiler correctly displaying socket statistics")

* Adicionados parâmetros de query à visualização de detalhes da requisição. - [#7825](https://github.com/flutter/devtools/pull/7825)

## Atualizações do VS Code Sidebar

* Adicionados botões para todas as ferramentas DevTools na sidebar por padrão, mesmo quando
  não há sessões de debug disponíveis. - [#7947](https://github.com/flutter/devtools/pull/7947)

  ![DevTools tools in the sidebar](/assets/images/docs/tools/devtools/release-notes/images-2.37.2/devtools_in_sidebar.png)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.37.0).
