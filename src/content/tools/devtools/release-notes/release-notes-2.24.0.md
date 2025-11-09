---
ia-translate: true
title: Notas de versão do DevTools 2.24.0
shortTitle: Notas de versão 2.24.0
breadcrumb: 2.24.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.24.0.
showToc: false
---

A versão 2.24.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Melhorada a performance geral das tabelas do DevTools -
  [#5664](https://github.com/flutter/devtools/pull/5664),
  [#5696](https://github.com/flutter/devtools/pull/5696)

## Atualizações do CPU profiler

* Corrigido bug com seleção e tooltips do flame chart do CPU -
  [#5676](https://github.com/flutter/devtools/pull/5676)

## Atualizações do Debugger

* Melhorado suporte para inspecionar
  instâncias `UserTag` e `MirrorReferent` -
  [#5490](https://github.com/flutter/devtools/pull/5490)
* Corrigido bug de avaliação de expressão onde
  selecionar um resultado de autocomplete para um campo limparia a entrada atual -
  [#5717](https://github.com/flutter/devtools/pull/5717)
* Feita seleção de um stack frame
  rolar para a localização do frame no código-fonte -
  [#5722](https://github.com/flutter/devtools/pull/5722)
* Melhorada performance da busca por um arquivo e busca em um arquivo -
  [#5733](https://github.com/flutter/devtools/pull/5733)
* Desabilitado syntax highlighting para arquivos com mais de 100.000 caracteres
  devido a restrições de performance -
  [#5743](https://github.com/flutter/devtools/pull/5743)
* Corrigido bug onde código-fonte não era visível se
  syntax highlighting para um arquivo estava desabilitado -
  [#5743](https://github.com/flutter/devtools/pull/5743)
* Prevenção de nomes de arquivo e código-fonte ficarem fora de sincronia -
  [#5827](https://github.com/flutter/devtools/pull/5827)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.23.1...v2.24.0).
