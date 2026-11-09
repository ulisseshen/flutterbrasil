---
ia-translate: true
title: Notas de versão do DevTools 2.10.0
shortTitle: Notas de versão 2.10.0
breadcrumb: 2.10.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.10.0.
showToc: false
---

A versão 2.10.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações do Flutter inspector

* Adicionado suporte de busca à Widget Tree, e
  adicionado um navegador breadcrumb à Widget Details Tree para
  permitir navegar rapidamente pela hierarquia da árvore -
  [#3525](https://github.com/flutter/devtools/pull/3525)

  ![inspector search](/assets/images/docs/tools/devtools/release-notes/images-2.10.0/image1.png "inspector_search")

## Atualizações do CPU profiler

* Corrigida uma referência nula no CPU profiler
  ao carregar um snapshot offline -
  [#3596](https://github.com/flutter/devtools/pull/3596)

## Atualizações do Debugger

* Adicionado suporte para busca de arquivo multi-token, e
  melhorada a priorização de correspondência de busca para
  classificar correspondências de nome de arquivo acima de correspondências de caminho completo -
  [#3582](https://github.com/flutter/devtools/pull/3582)
* Corrigidos alguns problemas relacionados a foco -
  [#3602](https://github.com/flutter/devtools/pull/3602)

## Atualizações da visualização de Logging

* Corrigido um erro fatal que ocorria ao
  filtrar logs mais de uma vez -
  [#3588](https://github.com/flutter/devtools/pull/3588)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.9.2...v2.10.0).
