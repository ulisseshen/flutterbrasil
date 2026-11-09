---
title: Mudança em TestWidgetsFlutterBinding.clock
description: A implementação de Clock agora vem do package:clock.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

O `TestWidgetsFlutterBinding.clock` agora vem do
`package:clock` e não do `package:quiver`.

## Context

O package `flutter_test` está removendo sua dependência do
package `quiver` de maior peso em favor de uma dependência
em dois packages mais direcionados e leves,
`clock` e `fake_async`.

Isso pode afetar o código do usuário que obtém o clock de um
`TestWidgetsFlutterBinding` e passa isso para uma API
que espera um `Clock` do `package:quiver`,
por exemplo, algum código como este:

```dart
testWidgets('some test', (WidgetTester tester) {
  someApiThatWantsAQuiverClock(tester.binding.clock);
});
```

## Migration guide

O erro que você pode ver após esta mudança se parece com algo assim:

```plaintext
Error: The argument type 'Clock/*1*/' can't be assigned to the parameter type 'Clock/*2*/'.
 - 'Clock/*1*/' is from 'package:clock/src/clock.dart' ('<pub-cache>/clock/lib/src/clock.dart').
 - 'Clock/*2*/' is from 'package:quiver/time.dart' ('<pub-cache>/quiver/lib/time.dart').
```

### Option #1: Create a package:quiver Clock from a package:clock Clock

A migração mais fácil é criar um clock `package:quiver` a partir do
clock `package:clock`, o que pode ser feito passando a função `.now`
como tearoff para o construtor `Clock`:

Código antes da migração:

```dart
testWidgets('some test', (WidgetTester tester) {
  someApiThatWantsAQuiverClock(tester.binding.clock);
});
```

Código após a migração:

```dart
testWidgets('some test', (WidgetTester tester) {
  someApiThatWantsAQuiverClock(Clock(tester.binding.clock.now));
});
```

### Option #2: Change the api to accept a package:clock Clock

Se você possui a API que está chamando,
você pode querer alterá-la para aceitar um `Clock`
do `package:clock`.
Esta é uma decisão de julgamento baseada em quantos lugares estão
chamando esta API com algo diferente de um clock
recuperado de um `TestWidgetsFlutterBinding`.

Se você seguir esta rota, seus sites de chamada que estão passando
`tester.binding.clock` não precisarão ser modificados,
mas outros sites de chamada precisarão.

### Option #3: Change the API to accept a `DateTime function()`

Se você usa apenas o `Clock` para sua função `now`,
e você controla a API, então você também pode alterá-la
para aceitar essa função diretamente em vez de um `Clock`.
Isso a torna facilmente chamável com qualquer tipo de `Clock`,
passando um tearoff do método `now` de qualquer tipo de clock:

Código de chamada antes da migração:

```dart
testWidgets('some test', (WidgetTester tester) {
  someApiThatWantsAQuiverClock(tester.binding.clock);
});
```

Código de chamada após a migração:

```dart
testWidgets('some test', (WidgetTester tester) {
  modifiedApiThatTakesANowFunction(tester.binding.clock.now);
});
```

## Timeline

Adicionado na versão: 1.18.0<br>
Na versão estável: 1.20

## References

Documentação da API:

* [`TestWidgetsFlutterBinding`][]

PRs relevantes:

* [PR 54125][]: remove flutter_test quiver dep,
  use fake_async and clock instead

[`TestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding-class.html
[PR 54125]: {{site.repo.flutter}}/pull/54125
