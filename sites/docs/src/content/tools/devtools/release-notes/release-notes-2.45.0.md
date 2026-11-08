---
ia-translate: true
title: Notas de lançamento do DevTools 2.45.0
shortTitle: Notas de lançamento 2.45.0
breadcrumb: 2.45.0
description: Notas de lançamento da versão 2.45.0 do Dart e Flutter DevTools.
showToc: false
---

A versão 2.45.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionado um aviso de pressão de memória que permite reduzir o uso de memória do
  DevTools para evitar uma falha OOM. -
  [#8989](https://github.com/flutter/devtools/pull/8989),
  [#8997](https://github.com/flutter/devtools/pull/8997),
  [#8998](https://github.com/flutter/devtools/pull/8998)

* Corrigido um bug com o histórico de revisão na experiência de desconexão. -
  [#8985](https://github.com/flutter/devtools/pull/8985)

* Corrigido bug onde o DevTools retomava automaticamente em vez de
  pausar no breakpoint na conexão. -
  [#8991](https://github.com/flutter/devtools/pull/8991)

* Impedido que campos de texto roubassem o foco da IDE. -
  [#9091](https://github.com/flutter/devtools/pull/9091)

## Atualizações do Inspector

* Corrigido bug onde erros na árvore do inspector (por exemplo, erros de overflow do RenderFlex)
  não eram removidos após um hot-reload. -
  [#9106](https://github.com/flutter/devtools/pull/9106)

## Atualizações do Debugger

* Combinados os botões Pause e Resume em um único botão. -
  [#9095](https://github.com/flutter/devtools/pull/9095)

## Atualizações da ferramenta Deep links

* Corrigido um problema com caminhos de arquivo do Windows sendo exibidos incorretamente na página
  Deep Links [#9027](https://github.com/flutter/devtools/pull/9027).

* Corrigido um problema com a página Deep Links falhando quando nenhuma configuração do iOS está
  presente [#9027](https://github.com/flutter/devtools/pull/9027).

## Histórico completo de commits

Para encontrar uma lista completa de mudanças neste lançamento, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.45.0).
