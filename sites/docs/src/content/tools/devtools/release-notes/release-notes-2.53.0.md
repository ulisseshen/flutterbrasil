---
ia-translate: true
title: Notas de lançamento do DevTools 2.53.0
shortTitle: Notas de lançamento 2.53.0
breadcrumb: 2.53.0
showToc: false
---

# Notas de lançamento do DevTools 2.53.0

A versão 2.53.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

- Alterado o compilador padrão do DevTools para `dart2wasm`. -
  [#9530](https://github.com/flutter/devtools/pull/9530)

## Atualizações de desempenho

- Aumentado o limite de dados de perfil de 64MB para 2GB, corrigindo o problema em que
  o painel não carregava perfis grandes. -
  [#9540](https://github.com/flutter/devtools/pull/9540)

## Atualizações do modo avançado para desenvolvedores

- Corrigido um problema que impedia que perfis de CPU fossem carregados quando o
  "modo avançado para desenvolvedores" estava ativado. - [#9528](https://github.com/flutter/devtools/pull/9528)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.53.0).
