# Notas de lançamento do DevTools 2.28.1

A versão 2.28.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionado support for DevTools extensions.
  This means if you are debugging an app that depends on `package:foo`,
  and `package:foo` provides a DevTools extension,
  you will see a "Foo" tab display in DevTools
  that you can use to debug your app.
  To provide a DevTools extension for your pub package,
  check out the getting started guide for
  [package:devtools_extensions](https://pub.dev/packages/devtools_extensions)!

![Example DevTools extension](/tools/devtools/release-notes/images-2.28.1/example_devtools_extension.png "Example DevTools extension for package:foo_package")

* Corrigido theming bug in isolate selector -
  [#6403](https://github.com/flutter/devtools/pull/6403)
* Corrigido isolate bug where main isolate was not reselecting on hot restart -
  [#6436](https://github.com/flutter/devtools/pull/6436)
* Show the hot reload button for Dart server apps that support hot reload -
  [#6341](https://github.com/flutter/devtools/pull/6341)
* Corrigido exceptions on hot restart -
  [#6451](https://github.com/flutter/devtools/pull/6451),
  [#6450](https://github.com/flutter/devtools/pull/6450)

## Atualizações do Inspector

* Corrigido bug where inspector service calls were done on the selected isolate,
  instead of the main isolate -
  [#6434](https://github.com/flutter/devtools/pull/6434)

## Atualizações do Logging

* Melhorado responsiveness of the top bar on the Logging view -
  [#6281](https://github.com/flutter/devtools/pull/6281)

* Adicionado the ability to copy filtered logs -
  [#6260](https://github.com/flutter/devtools/pull/6260)

  ![The copy button on the Logging view to the right of the filter tool](/tools/devtools/release-notes/images-2.28.1/logger_copy.png "The Logging view copy button")

## Histórico completo de commits

To find a complete list of changes in this release, check out the
[DevTools git log](https://github.com/flutter/devtools/tree/v2.28.1).
