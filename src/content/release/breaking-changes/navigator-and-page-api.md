---
title: Navigator's page APIs breaking change
description: >-
  Replace Navigator's 'onPopPage' property with the 'onDidRemovePage' property.
ia-translate: true
---

## Resumo

The [`Navigator`][] page APIs are refactored so that
they can integrate with Flutter's other pop mechanisms.

## Contexto

The `onPopPage` property was added for cleaning up pages after
a page is about to be popped.
To veto pop, you'd return `false` in the callback.
This did not work well with other popping mechanisms in the framework,
such as [`PopScope`][] and iOS back gestures.

To integrate the framework's pop mechanisms together,
the page APIs needed to be refactored.

## Descrição da mudança

The `onDidRemovePage` property replaces the `onPopPage` property.
You can no longer veto a pop in the `onDidRemovePage` property.
Instead, you are only responsible for updating the [`pages`][].

The veto mechanism is now managed with the
`Page.canPop` and `Page.onPopInvoked` properties.
These function similar to how you use the `PopScope` widget.

[`pages`]: {{site.api}}/flutter/widgets/Navigator/pages.html

## Guia de migração

Código antes da migração:

```dart
import 'package:flutter/material.dart';

final MaterialPage<void> page1 = MaterialPage<void>(child: Placeholder());
final MaterialPage<void> page2 = MaterialPage<void>(child: Placeholder());
final MaterialPage<void> page3 = MaterialPage<void>(child: Placeholder());

void main() {
  final List<Page<void>> pages = <Page<void>>[page1, page2, page3];
  runApp(
    MaterialApp(
      home: Navigator(
        pages: pages,
        onPopPage: (Route<Object?> route, Object? result) {
          if (route.settings == page2) {
            return false;
          }
          if (route.didPop) {
            pages.remove(route.settings);
            return true;
          }
          return false;
        },
      ),
    ),
  );
}
```

Código após a migração:

```dart
import 'package:flutter/material.dart';

final MaterialPage<void> page1 = MaterialPage<void>(child: Placeholder());
final MaterialPage<void> page2 = MaterialPage<void>(canPop: false, child: Placeholder());
final MaterialPage<void> page3 = MaterialPage<void>(child: Placeholder());

void main() {
  final List<Page<void>> pages = <Page<void>>[page1, page2, page3];
  runApp(
    MaterialApp(
      home: Navigator(
        pages: pages,
        onDidRemovePage: (Page<Object?> page) {
          pages.remove(page);
        },
      ),
    ),
  );
}
```

## Linha do tempo

Lançado na versão: 3.22.0-32.0.pre<br>
Na versão estável: 3.24.0

## Referências

Documentação da API:

* [`Navigator`][]
* [`PopScope`][]

Issues relevantes:

* [Issue 137458][]

PRs relevantes:

* [Refactors page API][]

[Refactors page API]: {{site.repo.flutter}}/pull/137792
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[Issue 137458]: {{site.repo.flutter}}/issues/137458
