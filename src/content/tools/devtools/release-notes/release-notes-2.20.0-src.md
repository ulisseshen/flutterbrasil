# Notas de lançamento do DevTools 2.20.0

A versão 2.20.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações do CPU profiler

* Add support for grouping samples by tag -
  [#4693](https://github.com/flutter/devtools/pull/4693)

  ![samples by tag](/tools/devtools/release-notes/images-2.20.0/4693.png "samples by tag")

* Enable guidelines for tree view -
  [#4722](https://github.com/flutter/devtools/pull/4722)

  ![guidelines](/tools/devtools/release-notes/images-2.20.0/4722.png "guidelines")

* Rename "Profile granularity" to "CPU sampling rate"
  and move down to the area it relates to -
  [#4803](https://github.com/flutter/devtools/pull/4722)

  ![sampling rate](/tools/devtools/release-notes/images-2.20.0/4803.png "sampling rate")


## Atualizações de Memory

* Retire the **Analysis** tab -
  [#4714](https://github.com/flutter/devtools/pull/4714)

* Add a new tab, **Diff**, to enable memory leak detection
  and troubleshooting by comparing heap snapshots,
  providing insights about the number of instances,
  shallow size, retained size, and retaining paths -
  [#4714](https://github.com/flutter/devtools/pull/4714)

  ![diff](/tools/devtools/release-notes/images-2.20.0/4714.png "Diff in Memory tab")

## Atualizações do Debugger

* Support for inspecting more types of instances in the variables viewer
  (Expandos, Types, TypeArguments, Parameters, Closures + closure Contexts, 
  WeakProperty, Function, FunctionType, ReceivePort, Closure, RegExp) -
  [#4760](https://github.com/flutter/devtools/pull/4760)

* Add support for displaying coverage in CodeView -
  [#4700](https://github.com/flutter/devtools/pull/4700)

  ![coverage](/tools/devtools/release-notes/images-2.20.0/4700.png "coverage in CodeView")

## Network updates

* Display request data if content type is not json
  (thanks to @leungpuikuen!) -
  [#4602](https://github.com/flutter/devtools/pull/4602)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.19.0...v2.20.0).
