---
ia-translate: true
title: Notas de versão do DevTools 2.31.0
shortTitle: Notas de versão 2.31.0
breadcrumb: 2.31.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.31.0.
showToc: false
---

A versão 2.31.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionada uma nova funcionalidade para validação de deep link,
  suportando verificações web de deep link no Android. - [#6935](https://github.com/flutter/devtools/pull/6935)
* Adicionada a estrutura básica para permitir conexões a um Dart Tooling Daemon. - [#7009](https://github.com/flutter/devtools/pull/7009)
* Tornado texto de tabela selecionável [#6919](https://github.com/flutter/devtools/pull/6919)

## Atualizações do Inspector

* Quando terminar de digitar no campo de busca,
  a próxima seleção agora é automaticamente selecionada - [#6677](https://github.com/flutter/devtools/pull/6677)
* Adicionado link para documentação do diretório de pacotes,
  do diálogo de configurações de inspeção - [#6825](https://github.com/flutter/devtools/pull/6825)

  ![Link to documentation](/assets/images/docs/tools/devtools/release-notes/images-2.31.0/link-to-doc.png "Link to documentation")

* Corrigido bug onde widgets de propriedade do framework Flutter estavam
  aparecendo na visualização da árvore de widgets - [#6857](https://github.com/flutter/devtools/pull/6857)
* Cachear apenas diretórios raiz pub adicionados pelo usuário - [#6897](https://github.com/flutter/devtools/pull/6897)
* Remover raiz pub do Flutter se foi acidentalmente cacheada - [#6911](https://github.com/flutter/devtools/pull/6911)

## Atualizações de Performance

* Alterado fundo de preview da camada raster para um tabuleiro de xadrez. - [#6827](https://github.com/flutter/devtools/pull/6827)

## Atualizações do CPU profiler

* Adicionados cards de hover para mostrar taxa de amostragem para o item no dropdown. - [#7010](https://github.com/flutter/devtools/pull/7010)

  ![Sampling rate for dropdown](/assets/images/docs/tools/devtools/release-notes/images-2.31.0/hover-for-dropdown.png "Sampling rate for dropdown")

## Atualizações do Debugger

* Destacado `extension type` como uma palavra-chave de declaração,
  destacado o `$` em interpolação de identificador como parte da interpolação,
  e destacados corretamente comentários dentro de argumentos de tipo. - [6837](https://github.com/flutter/devtools/pull/6837)

## Atualizações de Logging

* Adicionada barra de rolagem ao painel de detalhes. - [#6917](https://github.com/flutter/devtools/pull/6917)

## Atualizações do VS Code Sidebar

* Corrigido um problema que impedia a sidebar do VS code de
  carregar em builds recentes beta/master. - [#6984](https://github.com/flutter/devtools/pull/6984)

## Atualizações de DevTools Extension

* Corrigidos alguns bugs que impediam apps de servidor Dart de
  se conectarem às extensões do DevTools. - [#6982](https://github.com/flutter/devtools/pull/6982), [#6993](https://github.com/flutter/devtools/pull/6993)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.31.0).
