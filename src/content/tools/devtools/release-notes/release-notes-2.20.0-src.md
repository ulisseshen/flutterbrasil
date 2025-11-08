# Notas de lançamento do DevTools 2.20.0

A versão 2.20.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do CPU profiler

* Adicionado suporte para agrupar amostras por tag -
  [#4693](https://github.com/flutter/devtools/pull/4693)

  ![samples by tag](/tools/devtools/release-notes/images-2.20.0/4693.png "samples by tag")

* Habilitadas linhas-guia para visualização em árvore -
  [#4722](https://github.com/flutter/devtools/pull/4722)

  ![guidelines](/tools/devtools/release-notes/images-2.20.0/4722.png "guidelines")

* Renomeado "Profile granularity" para "CPU sampling rate"
  e movido para a área à qual se relaciona -
  [#4803](https://github.com/flutter/devtools/pull/4722)

  ![sampling rate](/tools/devtools/release-notes/images-2.20.0/4803.png "sampling rate")


## Atualizações do Memory

* Retirada a aba **Analysis** -
  [#4714](https://github.com/flutter/devtools/pull/4714)

* Adicionada nova aba, **Diff**, para permitir detecção de vazamento de memória
  e solução de problemas comparando snapshots do heap,
  fornecendo insights sobre o número de instâncias,
  shallow size, retained size e retaining paths -
  [#4714](https://github.com/flutter/devtools/pull/4714)

  ![diff](/tools/devtools/release-notes/images-2.20.0/4714.png "Diff in Memory tab")

## Atualizações do Debugger

* Suporte para inspecionar mais tipos de instâncias no visualizador de variáveis
  (Expandos, Types, TypeArguments, Parameters, Closures + closure Contexts,
  WeakProperty, Function, FunctionType, ReceivePort, Closure, RegExp) -
  [#4760](https://github.com/flutter/devtools/pull/4760)

* Adicionado suporte para exibir cobertura no CodeView -
  [#4700](https://github.com/flutter/devtools/pull/4700)

  ![coverage](/tools/devtools/release-notes/images-2.20.0/4700.png "coverage in CodeView")

## Atualizações do Network

* Exibição de dados de requisição se o tipo de conteúdo não for json
  (agradecimento a @leungpuikuen!) -
  [#4602](https://github.com/flutter/devtools/pull/4602)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.19.0...v2.20.0).
