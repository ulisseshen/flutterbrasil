---
ia-translate: true
title: Notas de versão do DevTools 2.32.0
shortTitle: Notas de versão 2.32.0
breadcrumb: 2.32.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.32.0.
showToc: false
---

A versão 2.32.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* Melhorada usabilidade geral tornando a UI do DevTools mais densa.
  Isso melhora significativamente a experiência do usuário ao usar
  DevTools incorporado em uma IDE. - [#7030](https://github.com/flutter/devtools/pull/7030)
* Removida a configuração "Dense mode". - [#7086](https://github.com/flutter/devtools/pull/7086)
* Adicionado suporte para filtragem com expressões regulares nas
  páginas Logging, Network e CPU profiler - [#7027](https://github.com/flutter/devtools/pull/7027)
* Adicionada uma interação de servidor DevTools para obter a URI DTD. - [#7054](https://github.com/flutter/devtools/pull/7054)

## Atualizações de Memory

* Suportado rastreamento de alocação para builds de profile Flutter e
  aplicações compiladas Dart AOT. - [#7058](https://github.com/flutter/devtools/pull/7058)
* Suportada importação de snapshots de memória. - [#6974](https://github.com/flutter/devtools/pull/6974)

## Atualizações do Debugger

* Destacado `extension type` como uma palavra-chave de declaração,
  destacado o `$` em interpolação de identificador como parte da interpolação,
  e destacados corretamente comentários dentro de argumentos de tipo. - [#6837](https://github.com/flutter/devtools/pull/6837)

## Atualizações de Logging

* Adicionados filtros toggle para filtrar logs ruidosos de Flutter e Dart - [#7026](https://github.com/flutter/devtools/pull/7026)

  ![Logging view filters](/assets/images/docs/tools/devtools/release-notes/images-2.32.0/logging_toggle_filters.png "Toggle filters for logging screen")

* Adicionada uma barra de rolagem ao painel de detalhes. - [#6917](https://github.com/flutter/devtools/pull/6917)

## Atualizações de DevTools extension

* Adicionada uma descrição e link de documentação ao arquivo `devtools_options.yaml`
  que é criado no projeto do usuário. - [#7052](https://github.com/flutter/devtools/pull/7052)
* Atualizado o Simulated DevTools Environment Panel para ser recolhível
  (obrigado a @victoreronmosele!) - [#7062](https://github.com/flutter/devtools/pull/7062)
* Integradas extensões do DevTools com o novo Dart Tooling Daemon.
  Isso permitirá que extensões do DevTools acessem métodos públicos registrados por
  outros clientes DTD, como uma IDE, além de acessar uma API mínima de sistema de arquivos
  para interagir com o projeto de desenvolvimento. - [#7108](https://github.com/flutter/devtools/pull/7108)

## Atualizações do VS Code sidebar

* Corrigido um problema que impedia a sidebar do VS code de
  carregar em builds recentes `beta` e `main`. - [#6984](https://github.com/flutter/devtools/pull/6984)
* Mostradas extensões do DevTools como uma opção do
  dropdown DevTools de sessões de debug, quando disponível. [#6709](https://github.com/flutter/devtools/pull/6709)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.32.0).
