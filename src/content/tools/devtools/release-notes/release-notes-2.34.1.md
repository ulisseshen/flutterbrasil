---
ia-translate: true
title: Notas de versão do DevTools 2.34.1
shortTitle: Notas de versão 2.34.1
breadcrumb: 2.34.1
description: Notas de versão para o Dart e Flutter DevTools versão 2.34.1.
showToc: false
---

A versão 2.34.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Corrigido um problema impedindo DevTools de se conectar a apps Flutter que
  não são lançados do Flutter Tools. - [#6848](https://github.com/flutter/devtools/issues/6848)
* Melhorada performance do FlatTable. -
  [#7391](https://github.com/flutter/devtools/pull/7391)

## Atualizações do Inspector

- Corrige um caso extremo onde widgets de outros pacotes poderiam
  aparecer na árvore do inspector. - [#7353](https://github.com/flutter/devtools/pull/7353)

## Atualizações de Performance
* Adicionada uma configuração para incluir amostras de CPU na Timeline. -
  [#7333](https://github.com/flutter/devtools/pull/7333), [#7369](https://github.com/flutter/devtools/pull/7369)

  ![Timeline settings](/assets/images/docs/tools/devtools/release-notes/images-2.34.1/7369-timeline-settings.png "Timeline settings")

* Removido o visualizador de trace legado.
  O visualizador de trace legado foi substituído pelo
  visualizador de trace Perfetto incorporado na versão 2.21.1 do DevTools, mas estava
  disponível por trás de uma configuração para garantir uma implantação suave.
  Esta versão do DevTools remove o visualizador de trace legado completamente. - [#7316](https://github.com/flutter/devtools/pull/7316)
* Atualizado o build do visualizador de trace Perfetto. -
  [#7445](https://github.com/flutter/devtools/pull/7445),
  [#7456](https://github.com/flutter/devtools/pull/7456),
  [#7480](https://github.com/flutter/devtools/pull/7480)
* Adicionada uma mensagem de carregamento para mostrar ao atualizar a timeline. - [#7463](https://github.com/flutter/devtools/pull/7463)

  ![Loading message](/assets/images/docs/tools/devtools/release-notes/images-2.34.1/7463-overlay.png "Loading message")

## Atualizações de Memory

* Habilitada exportação de snapshots e melhorada performance de snapshotting. -
  [#7197](https://github.com/flutter/devtools/pull/7197),
  [#7439](https://github.com/flutter/devtools/pull/7439),
  [#7449](https://github.com/flutter/devtools/pull/7449)

  ![Export snapshot](/assets/images/docs/tools/devtools/release-notes/images-2.34.1/7197-export.png "Export snapshot")

* Corrigidas falhas durante desconexão no tracing. - [#7440](https://github.com/flutter/devtools/pull/7440)

* Tornado filtro de classe compartilhado entre
  os painéis `Profile Memory` e `Diff Snapshots`. - [#7462](https://github.com/flutter/devtools/pull/7462)

## Atualizações do Network profiler

* Melhorada performance do Network profiler. - [#7266](https://github.com/flutter/devtools/pull/7266)
* Corrigido um bug onde requisições pendentes selecionadas não estavam
  atualizando a aba uma vez atualizadas. - [#7266](https://github.com/flutter/devtools/pull/7266)
* Corrigido o visualizador JSON para que strings multilinha sejam visíveis em sua linha, e
  através de um tooltip. - [#7389](https://github.com/flutter/devtools/pull/7389)
* Corrigido JsonViewer onde todas as
  seções expandidas se fechariam de repente. [#7367](https://github.com/flutter/devtools/pull/7367)

## Atualizações da ferramenta Deep Links

* Preenchida automaticamente uma lista de projetos Flutter do
  IDE conectado. - [#7415](https://github.com/flutter/devtools/pull/7415), [#7431](https://github.com/flutter/devtools/pull/7431)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.34.1).
