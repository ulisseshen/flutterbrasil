---
ia-translate: true
title: Notas de versão do DevTools 2.40.2
shortTitle: Notas de versão 2.40.2
breadcrumb: 2.40.2
description: Notas de versão para o Dart e Flutter DevTools versão 2.40.2.
showToc: false
---

A versão 2.40.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionada uma configuração que permite aos usuários optar por carregar DevTools
  com WebAssembly. - [#8270](https://github.com/flutter/devtools/pull/8270)

  ![Wasm opt-in setting](/assets/images/docs/tools/devtools/release-notes/images-2.40.2/wasm_setting.png "DevTools setting to opt into wasm.")

* Removida a tela Provider legada do DevTools.
  A ferramenta `package:provider` agora é distribuída como uma
  extensão DevTools do `package:provider`.
  Atualize sua dependência `package:provider` para
  usar a extensão. - [#8364](https://github.com/flutter/devtools/pull/8364)

* Corrigido um bug que estava causando as notas de versão do DevTools sempre
  serem mostradas. - [#8277](https://github.com/flutter/devtools/pull/8277)

* Adicionado suporte para carregar extensões em workspaces pub
  [8347](https://github.com/flutter/devtools/pull/8347).

* Mapeados traces de stack de erro para usar as localizações de código-fonte Dart para que
  sejam legíveis para humanos. - [#8385](https://github.com/flutter/devtools/pull/8385)

* Adicionado tratamento para eventos de mudança de tema da IDE para
  atualizar UI DevTools incorporada. - [#8336](https://github.com/flutter/devtools/pull/8336)

* Corrigido um bug que estava causando filtros de dados serem limpos ao limpar dados
  nas telas Network e Logging. - [#8407](https://github.com/flutter/devtools/pull/8407)

* Corrigido um bug que estava causando o navegador perder estado ao abrir o
  diálogo VM Flags. - [#8413](https://github.com/flutter/devtools/pull/8413)

* Tabelas correspondem ao tema da IDE quando incorporadas em uma IDE. - [#8498](https://github.com/flutter/devtools/pull/8498)

## Atualizações do Inspector

- Adicionada uma configuração aos controles do Flutter Inspector que
  permite aos usuários optar pelo Flutter Inspector recém-redesenhado. - [#8342](https://github.com/flutter/devtools/pull/8342)

  ![New inspector opt-in setting](/assets/images/docs/tools/devtools/release-notes/images-2.40.2/new_inspector.png "DevTools setting to opt into the new Flutter Inspector.")

## Atualizações de Performance

* Corrigido um problema com o overlay "Refreshing timeline" que estava sendo mostrado
  quando não deveria. - [#8318](https://github.com/flutter/devtools/pull/8318)

## Atualizações do Network profiler

* Resolvido um problema na exportação `.har` onde
  conteúdo de resposta às vezes estava faltando nos dados. - [#8333](https://github.com/flutter/devtools/pull/8333)

## Atualizações da ferramenta Deep links

- Adicionado suporte para validar configurações de deep link do iOS. - [#8394](https://github.com/flutter/devtools/pull/8394)

  ![Deep link validator for iOS](/assets/images/docs/tools/devtools/release-notes/images-2.40.2/deep_link_ios.png "DevTools Deep link validator Page")

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.40.2).
