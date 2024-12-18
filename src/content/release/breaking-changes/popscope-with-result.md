---
ia-translate: true
title: Tipos genéricos em PopScope
description: >-
  Adicionado um tipo genérico à classe PopScope e atualizada a
  assinatura da função onPopInvoked.
---

## Resumo

Adicionado um tipo genérico à classe [`PopScope`][] e substituído
o [`onPopInvoked`][] por um novo método [`onPopInvokedWithResult`][].
O novo método recebe um booleano `didPop` e um `result` como parâmetros posicionais.

Também substituído o [`Form.onPopInvoked`] por [`Form.onPopInvokedWithResult`][]
pelo mesmo motivo.

## Contexto

Anteriormente, `PopScope` não tinha como acessar o resultado
do pop quando `onPopInvoked` era chamado.
O tipo genérico é adicionado à classe `PopScope` para que o
novo método `onPopInvokedWithResult` possa acessar o resultado com tipo seguro.

## Descrição da mudança

Adicionado um tipo genérico (`<T>`) à classe `PopScope` e
um novo método `onPopInvokedWithResult`.
A propriedade `onPopInvoked` foi depreciada em favor de `onPopInvokedWithResult`.

Também adicionado um novo método `onPopInvokedWithResult`
a `Form` para substituir `onPopInvoked`.

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

O tipo genérico deve corresponder ao tipo genérico da [`Route`][]
em que o `PopScope` está.
Por exemplo, se a rota usa `int` como seu tipo genérico,
considere usar `PopScope<int>`.

Se os widgets `PopScope` forem compartilhados entre várias rotas com
tipos diferentes, você pode usar `PopScope<Object?>` para capturar todos os tipos possíveis.

## Linha do tempo

Implementado na versão: 3.22.0-26.0.pre<br>
Na versão estável: 3.24.0

## Referências

Documentação da API:

* [`PopScope`][]
* [`onPopInvoked`][]
* [`Route`][]
* [`onPopInvokedWithResult`][]
* [`Form.onPopInvoked`][]
* [`Form.onPopInvokedWithResult`][]

Issue relevante:

* [Issue 137458][]

PRs relevantes:

* [Add generic type for result in PopScope][] _(revertido)_
* [Reapply new PopScope API][] _(re-aplicação final)_

[Add generic type for result in PopScope]: {{site.repo.flutter}}/pull/139164
[Reapply new PopScope API]: {{site.repo.flutter}}/pull/147607
[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`onPopInvoked`]: {{site.api}}/flutter/widgets/PopScope/onPopInvoked.html
[`onPopInvokedWithResult`]: {{site.api}}/flutter/widgets/PopScope/onPopInvokedWithResult.html
[`Form.onPopInvoked`]: {{site.api}}/flutter/widgets/Form/onPopInvoked.html
[`Form.onPopInvokedWithResult`]: {{site.api}}/flutter/widgets/Form/onPopInvokedWithResult.html
[Issue 137458]: {{site.repo.flutter}}/issues/137458
