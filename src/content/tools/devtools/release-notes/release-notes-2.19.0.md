---
ia-translate: true
title: Notas de versão do DevTools 2.19.0
shortTitle: Notas de versão 2.19.0
breadcrumb: 2.19.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.19.0.
showToc: false
---

A versão 2.19.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações de Performance

* Adicionado um botão para alternar a visibilidade do gráfico Flutter Frames -
  [#4577](https://github.com/flutter/devtools/pull/4577)

  ![diff](/assets/images/docs/tools/devtools/release-notes/images-2.19.0/4577.png "Flutter Frames")

* Refinado o aviso de modo debug para descrever melhor quais dados são
  precisos no modo debug e quais dados podem ser enganosos -
  [#3537](https://github.com/flutter/devtools/pull/3537)
* Reordenadas as abas da ferramenta de performance e mostrado o CPU profiler
  somente para a aba "Timeline Events" -
  [#4629](https://github.com/flutter/devtools/pull/4629)

## Atualizações de Memory

* Melhorias na aba Profile de memory -
  [#4583](https://github.com/flutter/devtools/pull/4583)

## Atualizações do Debugger

* Corrigido um problema com cards de hover onde eles apareciam
  mas nunca desapareciam -
  [#4627](https://github.com/flutter/devtools/pull/4627)
* Corrigido um bug com o diálogo de autocomplete da busca de arquivo -
  [#4409](https://github.com/flutter/devtools/pull/4409)

## Atualizações do Network profiler

* Adicionado um botão "Copy" na visualização Network Request
  (obrigado a @netos23) -
  [#4509](https://github.com/flutter/devtools/pull/4509)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.18.0...v2.19.0).
