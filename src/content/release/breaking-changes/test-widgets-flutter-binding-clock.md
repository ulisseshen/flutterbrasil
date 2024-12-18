---
ia-translate: true
title: Mudança em TestWidgetsFlutterBinding.clock
description: A implementação de Clock agora vem do package:clock.
---

## Resumo

O `TestWidgetsFlutterBinding.clock` agora vem do `package:clock` e não do `package:quiver`.

## Contexto

O pacote `flutter_test` está removendo sua dependência do pacote `quiver`, que é mais pesado, em favor de uma dependência de dois pacotes mais direcionados e leves, `clock` e `fake_async`.

Isso pode afetar o código do usuário que obtém o clock de um `TestWidgetsFlutterBinding` e o passa para uma API que espera um `Clock` do `package:quiver`, por exemplo, algum código como este:

```dart
testWidgets('algum teste', (WidgetTester tester) {
  algumaApiQueQuerUmQuiverClock(tester.binding.clock);
});
```

## Guia de migração

O erro que você pode ver após essa alteração se parece com algo assim:

```plaintext
Error: The argument type 'Clock/*1*/' can't be assigned to the parameter type 'Clock/*2*/'.
 - 'Clock/*1*/' is from 'package:clock/src/clock.dart' ('<pub-cache>/clock/lib/src/clock.dart').
 - 'Clock/*2*/' is from 'package:quiver/time.dart' ('<pub-cache>/quiver/lib/time.dart').
```

### Opção #1: Criar um `Clock` do package:quiver a partir de um `Clock` do package:clock

A migração mais fácil é criar um clock do `package:quiver` a partir do clock do `package:clock`, o que pode ser feito passando a função `.now` para o construtor `Clock`:

Código antes da migração:

```dart
testWidgets('algum teste', (WidgetTester tester) {
  algumaApiQueQuerUmQuiverClock(tester.binding.clock);
});
```

Código após a migração:

```dart
testWidgets('algum teste', (WidgetTester tester) {
  algumaApiQueQuerUmQuiverClock(Clock(tester.binding.clock.now));
});
```

### Opção #2: Alterar a API para aceitar um `Clock` do package:clock

Se você é o dono da API que está chamando, você pode querer alterá-la para aceitar um `Clock` do `package:clock`. Esta é uma decisão baseada em quantos lugares estão chamando essa API com algo diferente de um clock recuperado de um `TestWidgetsFlutterBinding`.

Se você seguir esse caminho, seus locais de chamada que estão passando `tester.binding.clock` não precisarão ser modificados, mas outros locais de chamada precisarão.

### Opção #3: Alterar a API para aceitar uma `função DateTime()`

Se você usa o `Clock` apenas para sua função `now`, e você controla a API, então você também pode alterá-la para aceitar essa função diretamente em vez de um `Clock`. Isso o torna facilmente chamável com qualquer tipo de `Clock`, passando uma referência do método `now` de qualquer tipo de clock:

Código de chamada antes da migração:

```dart
testWidgets('algum teste', (WidgetTester tester) {
  algumaApiQueQuerUmQuiverClock(tester.binding.clock);
});
```

Código de chamada após a migração:

```dart
testWidgets('algum teste', (WidgetTester tester) {
  apiModificadaQueRecebeUmaFuncaoNow(tester.binding.clock.now);
});
```

## Linha do tempo

Incluído na versão: 1.18.0<br>
Em lançamento estável: 1.20

## Referências

Documentação da API:

* [`TestWidgetsFlutterBinding`][]

PRs relevantes:

* [PR 54125][]: remover a dependência do quiver de flutter_test, usar fake_async e clock em vez disso

[`TestWidgetsFlutterBinding`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding-class.html
[PR 54125]: {{site.repo.flutter}}/pull/54125
