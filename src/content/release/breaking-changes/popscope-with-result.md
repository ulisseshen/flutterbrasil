---
title: Generic types in PopScope
description: >-
  Added a generic type to the PopScope class and updated
  the onPopInvoked function signature.
ia-translate: true
---

## Resumo

Added a generic type to the [`PopScope`][] class and replaced
the [`onPopInvoked`][] with a new method [`onPopInvokedWithResult`][].
The new method takes a boolean `didPop` and a `result` as position parameters.

Also replaced the [`Form.onPopInvoked`] with [`Form.onPopInvokedWithResult`][]
for the same reason.

## Contexto

Previously, `PopScope` didn't have a way to access
the pop result when `onPopInvoked` was called.
The generic type is added to the `PopScope` class so that
the new method `onPopInvokedWithResult` can access the type-safe result.

## Descrição da mudança

Added a generic type (`<T>`) to the `PopScope` class and
a new method `onPopInvokedWithResult`. 
The `onPopInvoked` property was deprecated in favor of `onPopInvokedWithResult`.

Also added a new method `onPopInvokedWithResult`
to `Form` to replace `onPopInvoked`.

## Guia de migração

Código antes da migração:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      navigatorKey: nav,
      home: Column(
        children: [
          Form(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              launchConfirmationDialog();
            },
            child: MyWidget(),
          ),
          PopScope(
            canPop: false,
            onPopInvoked: (bool didPop) {
              if (didPop) {
                return;
              }
              launchConfirmationDialog();
            },
            child: MyWidget(),
          ),
        ],
      ),
    ),
  );
}
```

Código após a migração:

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      navigatorKey: nav,
      home: Column(
        children: [
          Form(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (didPop) {
                return;
              }
              launchConfirmationDialog();
            },
            child: MyWidget(),
          ),
          PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              if (didPop) {
                return;
              }
              launchConfirmationDialog();
            },
            child: MyWidget(),
          ),
        ],
      ),
    ),
  );
}
```

The generic type should match the generic type of the [`Route`][]
that the `PopScope` is in.
For example, if the route uses `int` as its generic type,
consider using `PopScope<int>`.

If the `PopScope` widgets are shared across multiple routes with
different types, you can use `PopScope<Object?>` to catch all possible types.

## Linha do tempo

Lançado na versão: 3.22.0-26.0.pre<br>
Na versão estável: 3.24.0

## Referências

Documentação da API:

* [`PopScope`][]
* [`onPopInvoked`][]
* [`Route`][]
* [`onPopInvokedWithResult`][]
* [`Form.onPopInvoked`][]
* [`Form.onPopInvokedWithResult`][]

Issues relevantes:

* [Issue 137458][]

PRs relevantes:

* [Add generic type for result in PopScope][] _(reverted)_
* [Reapply new PopScope API][] _(final reland)_

[Add generic type for result in PopScope]: {{site.repo.flutter}}/pull/139164
[Reapply new PopScope API]: {{site.repo.flutter}}/pull/147607
[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`onPopInvoked`]: {{site.api}}/flutter/widgets/PopScope/onPopInvoked.html
[`onPopInvokedWithResult`]: {{site.api}}/flutter/widgets/PopScope/onPopInvokedWithResult.html
[`Form.onPopInvoked`]: {{site.api}}/flutter/widgets/Form/onPopInvoked.html
[`Form.onPopInvokedWithResult`]: {{site.api}}/flutter/widgets/Form/onPopInvokedWithResult.html
[Issue 137458]: {{site.repo.flutter}}/issues/137458
