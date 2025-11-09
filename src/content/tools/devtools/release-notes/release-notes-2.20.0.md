---
ia-translate: true
title: Notas de versão do DevTools 2.20.0
shortTitle: Notas de versão 2.20.0
breadcrumb: 2.20.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.20.0.
showToc: false
---

A versão 2.20.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do CPU profiler

* Adicionado suporte para agrupar amostras por tag -
  [#4693](https://github.com/flutter/devtools/pull/4693)

  ![samples by tag](/assets/images/docs/tools/devtools/release-notes/images-2.20.0/4693.png "samples by tag")

* Habilitadas linhas guia para visualização em árvore -
  [#4722](https://github.com/flutter/devtools/pull/4722)

  ![guidelines](/assets/images/docs/tools/devtools/release-notes/images-2.20.0/4722.png "guidelines")

* Renomeado "Profile granularity" para "CPU sampling rate"
  e movido para a área a que se refere -
  [#4803](https://github.com/flutter/devtools/pull/4722)

  ![sampling rate](/assets/images/docs/tools/devtools/release-notes/images-2.20.0/4803.png "sampling rate")


## Atualizações de Memory

* Desativada a aba **Analysis** -
  [#4714](https://github.com/flutter/devtools/pull/4714)

* Adicionada uma nova aba, **Diff**, para habilitar detecção de vazamentos de memória
  e solução de problemas através da comparação de snapshots de heap,
  fornecendo insights sobre o número de instâncias,
  shallow size, retained size e retaining paths -
  [#4714](https://github.com/flutter/devtools/pull/4714)

  ![diff](/assets/images/docs/tools/devtools/release-notes/images-2.20.0/4714.png "Diff in Memory tab")

## Atualizações do Debugger

* Suporte para inspecionar mais tipos de instâncias no visualizador de variáveis
  (Expandos, Types, TypeArguments, Parameters, Closures + closure Contexts,
  WeakProperty, Function, FunctionType, ReceivePort, Closure, RegExp) -
  [#4760](https://github.com/flutter/devtools/pull/4760)

* Adicionado suporte para exibir cobertura no CodeView -
  [#4700](https://github.com/flutter/devtools/pull/4700)

  ![coverage](/assets/images/docs/tools/devtools/release-notes/images-2.20.0/4700.png "coverage in CodeView")

## Atualizações de Network

* Exibidos dados da requisição se o tipo de conteúdo não for json
  (obrigado a @leungpuikuen!) -
  [#4602](https://github.com/flutter/devtools/pull/4602)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.19.0...v2.20.0).
