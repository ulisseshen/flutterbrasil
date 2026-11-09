---
ia-translate: true
title: Notas de lançamento do DevTools 2.59.0
shortTitle: Notas de lançamento 2.59.0
breadcrumb: 2.59.0
description: Notas de lançamento do Dart e Flutter DevTools versão 2.59.0.
showToc: false
---

A versão 2.59.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

- Corrigido um `RangeError` lançado pelo `SplitPane` quando o pai
  reconstruía o widget com um número diferente de filhos.
  Por exemplo, ao alternar um painel para dentro ou para fora do layout. -
  [#9822](https://github.com/flutter/devtools/pull/9822)

## Atualizações do Inspector

- Corrigido um problema em que as dicas de ferramenta (tooltips) ao passar o mouse na árvore de widgets
  eram cortadas pelos limites da janela. -
  [#9823](https://github.com/flutter/devtools/pull/9823)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.59.0).
