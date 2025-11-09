---
ia-translate: true
title: Notas de versão do DevTools 2.28.1
shortTitle: Notas de versão 2.28.1
breadcrumb: 2.28.1
description: Notas de versão para o Dart e Flutter DevTools versão 2.28.1.
showToc: false
---

A versão 2.28.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionado suporte para extensões do DevTools.
  Isso significa que se você está debugando um app que depende de `package:foo`,
  e `package:foo` fornece uma extensão do DevTools,
  você verá uma aba "Foo" exibida no DevTools
  que você pode usar para debugar seu app.
  Para fornecer uma extensão do DevTools para seu pacote pub,
  confira o guia de introdução para
  [package:devtools_extensions](https://pub.dev/packages/devtools_extensions)!

![Example DevTools extension](/assets/images/docs/tools/devtools/release-notes/images-2.28.1/example_devtools_extension.png "Example DevTools extension for package:foo_package")

* Corrigido bug de tema no seletor de isolate -
  [#6403](https://github.com/flutter/devtools/pull/6403)
* Corrigido bug de isolate onde o isolate principal não estava sendo reselecionado no hot restart -
  [#6436](https://github.com/flutter/devtools/pull/6436)
* Mostrado o botão de hot reload para apps de servidor Dart que suportam hot reload -
  [#6341](https://github.com/flutter/devtools/pull/6341)
* Corrigidas exceções no hot restart -
  [#6451](https://github.com/flutter/devtools/pull/6451),
  [#6450](https://github.com/flutter/devtools/pull/6450)

## Atualizações do Inspector

* Corrigido bug onde chamadas de serviço do inspector eram feitas no isolate selecionado,
  ao invés do isolate principal -
  [#6434](https://github.com/flutter/devtools/pull/6434)

## Atualizações de Logging

* Melhorada responsividade da barra superior na visualização Logging -
  [#6281](https://github.com/flutter/devtools/pull/6281)

* Adicionada a capacidade de copiar logs filtrados -
  [#6260](https://github.com/flutter/devtools/pull/6260)

  ![The copy button on the Logging view to the right of the filter tool](/assets/images/docs/tools/devtools/release-notes/images-2.28.1/logger_copy.png "The Logging view copy button")

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.28.1).
