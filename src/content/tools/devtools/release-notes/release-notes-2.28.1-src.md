# Notas de lançamento do DevTools 2.28.1

O lançamento 2.28.1 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionado suporte para extensões do DevTools.
  Isso significa que, se você estiver depurando um aplicativo que depende do `package:foo`, e o `package:foo` fornecer uma extensão do DevTools, você verá uma aba "Foo" exibida no DevTools que poderá usar para depurar seu aplicativo. Para fornecer uma extensão do DevTools para seu pacote pub, confira o guia de introdução para [package:devtools_extensions](https://pub.dev/packages/devtools_extensions)!

![Exemplo de extensão do DevTools](/tools/devtools/release-notes/images-2.28.1/example_devtools_extension.png "Exemplo de extensão do DevTools para package:foo_package")

* Corrigido bug de tema no seletor de isolate -
  [#6403](https://github.com/flutter/devtools/pull/6403)
* Corrigido bug de isolate em que o isolate principal não era re-selecionado no hot restart -
  [#6436](https://github.com/flutter/devtools/pull/6436)
* Mostrar o botão hot reload para aplicativos de servidor Dart que suportam hot reload -
  [#6341](https://github.com/flutter/devtools/pull/6341)
* Corrigidas exceções no hot restart -
  [#6451](https://github.com/flutter/devtools/pull/6451),
  [#6450](https://github.com/flutter/devtools/pull/6450)

## Atualizações do Inspector

* Corrigido bug em que as chamadas de serviço do inspector eram feitas no isolate selecionado, em vez do isolate principal -
  [#6434](https://github.com/flutter/devtools/pull/6434)

## Atualizações de Logging

* Melhorada a capacidade de resposta da barra superior na visualização de Logging -
  [#6281](https://github.com/flutter/devtools/pull/6281)

* Adicionada a capacidade de copiar logs filtrados -
  [#6260](https://github.com/flutter/devtools/pull/6260)

  ![O botão de cópia na visualização de Logging à direita da ferramenta de filtro](/tools/devtools/release-notes/images-2.28.1/logger_copy.png "O botão de cópia da visualização de Logging")

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, consulte o [log do git do DevTools](https://github.com/flutter/devtools/tree/v2.28.1).
