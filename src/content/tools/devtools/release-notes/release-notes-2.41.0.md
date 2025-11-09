---
ia-translate: true
title: Notas de versão do DevTools 2.41.0
shortTitle: Notas de versão 2.41.0
breadcrumb: 2.41.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.41.0.
showToc: false
---

A versão 2.41.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Persistidas configurações de filtro entre sessões. - [#8447](https://github.com/flutter/devtools/pull/8447),
  [#8456](https://github.com/flutter/devtools/pull/8456)
  [#8470](https://github.com/flutter/devtools/pull/8470)

## Atualizações do Inspector

* Adicionada uma opção às configurações do [novo Inspector](https://docs.flutterbrasil.dev/tools/devtools/release-notes/release-notes-2.40.2#inspector-updates)
  para permitir atualização automática da árvore de widgets após um hot-reload. - [#8483](https://github.com/flutter/devtools/pull/8483)

## Atualizações do Network profiler

* Adicionado um campo de texto de filtro aos controles de nível superior do Network profiler. -
  [#8469](https://github.com/flutter/devtools/pull/8469)
  ![Network filter field](/assets/images/docs/tools/devtools/release-notes/images-2.41.0/network_filter.png "Network filter field")

## Atualizações de Logging

* Buscar detalhes de log imediatamente ao receber logs para que dados de log não sejam perdidos
  devido ao carregamento preguiçoso. - [#8421](https://github.com/flutter/devtools/pull/8421)
* Reduzido tempo de carregamento inicial da página. - [#8500](https://github.com/flutter/devtools/pull/8500)
* Adicionado suporte para exibir metadados, como
  gravidade do log, categoria, zone e isolate -
  [#8419](https://github.com/flutter/devtools/pull/8419),
  [#8439](https://github.com/flutter/devtools/pull/8439),
  [#8441](https://github.com/flutter/devtools/pull/8441). Agora também é possível
  buscar e filtrar por esses valores de metadados. - [#8473](https://github.com/flutter/devtools/pull/8473)
  ![Logging metadata display](/assets/images/docs/tools/devtools/release-notes/images-2.41.0/log_metadata.png "Logging metadata display")
* Adicionado um campo de texto de filtro aos controles de nível superior do Logging. -
  [#8427](https://github.com/flutter/devtools/pull/8427)
  ![Logging filter](/assets/images/docs/tools/devtools/release-notes/images-2.41.0/log_filter.png "Logging filter")
* Adicionado suporte para filtrar por gravidade/níveis de log. -
  [#8433](https://github.com/flutter/devtools/pull/8433)
  ![Log level filter](/assets/images/docs/tools/devtools/release-notes/images-2.41.0/log_level_filter.png "Log level filter")
* Adicionada uma configuração para definir o limite de retenção de log. - [#8493](https://github.com/flutter/devtools/pull/8493)
* Adicionado um botão para alternar a exibição de detalhes do log entre texto bruto e JSON. -
  [#8445](https://github.com/flutter/devtools/pull/8445)
* Corrigido um bug onde logs ficariam fora de ordem após meia-noite. -
  [#8420](https://github.com/flutter/devtools/pull/8420)
* Rolagem automática da tabela de logs para o final no carregamento inicial. -
  [#8437](https://github.com/flutter/devtools/pull/8437)

## Atualizações do VS Code Sidebar

* A versão `postMessage` legada da sidebar do VS Code foi removida em
  favor da versão alimentada por DTD. Tentar acessar a sidebar legada
  mostrará uma mensagem aconselhando atualizar sua extensão Dart VS Code. A extensão Dart VS
  Code era a única usuária da sidebar legada e migrou na
  v3.96.

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.41.0).
