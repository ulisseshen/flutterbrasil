---
ia-translate: true
title: A transição de página padrão no Android agora é PredictiveBackPageTransitionsBuilder
description: >-
  A transição de página padrão do Android foi atualizada para acompanhar a
  plataforma e oferecer suporte ao gesto de voltar preditivo.
---

## Resumo {:#summary}

A transição de página padrão no Android foi atualizada de
[`ZoomPageTransitionsBuilder`][`ZoomPageTransitionsBuilder`] para [`PredictiveBackPageTransitionsBuilder`][`PredictiveBackPageTransitionsBuilder`].
Quando o gesto de voltar preditivo não é usado, a transição recorre a
[`FadeForwardsPageTransitionsBuilder`][`FadeForwardsPageTransitionsBuilder`].

## Contexto {:#context}

O Android está lançando um recurso chamado voltar preditivo, em que realizar um gesto
de voltar permite que o usuário espie a rota ou o app anterior e, possivelmente,
cancele a navegação. O Flutter adicionou suporte a isso com o widget [`PopScope`][`PopScope`]
e, em seguida, com [`PredictiveBackPageTransitionsBuilder`][`PredictiveBackPageTransitionsBuilder`].

Enquanto isso, o Android também atualizou a sua transição de página padrão. O Flutter
adicionou suporte a ela com [`FadeForwardsPageTransitionsBuilder`][`FadeForwardsPageTransitionsBuilder`].

## Descrição da mudança {:#description-of-change}

Com essa mudança, [`PredictiveBackPageTransitionsBuilder`][`PredictiveBackPageTransitionsBuilder`] substituiu
[`ZoomPageTransitionsBuilder`][`ZoomPageTransitionsBuilder`] como a transição de página padrão no Android.
Durante uma transição de página normal, sem o gesto de voltar preditivo, os
usuários veem a nova [`FadeForwardsPageTransitionsBuilder`][`FadeForwardsPageTransitionsBuilder`] como transição padrão.
Ao usar o gesto de voltar preditivo, a página acompanha o gesto e permite
cancelar ou confirmar a navegação para trás.

Neste exemplo, nenhuma transição de página é definida explicitamente, então o
[padrão]({{site.repo.flutter}}/blob/e983e4bd81f29b17215057fa5c9f46f96cbaf183/packages/flutter/lib/src/material/page_transitions_theme.dart#L806-L813)
é definido como [`PredictiveBackPageTransitionsBuilder`][`PredictiveBackPageTransitionsBuilder`] no tema, no Android.

```dart
MaterialApp(
  theme: ThemeData(
    brightness: Brightness.light,
  ),
  home: const PageOne(),
);
```

## Guia de migração {:#migration-guide}

Se você quiser manter a transição de página do seu app no antigo
[`ZoomPageTransitionsBuilder`][`ZoomPageTransitionsBuilder`], basta definir a transição de página
explicitamente no tema do seu app. Lembre-se de que você não poderá
oferecer suporte às transições de rota do voltar preditivo.

Código antes da migração:

```dart
return MaterialApp(
  theme: ThemeData(
    brightness: Brightness.light,
    // pageTransitionsTheme is the default.
  ),
  home: const MyFirstScreen(),
);
```

Código após a migração:

```dart
MaterialApp(
  theme: ThemeData(
    // pageTransitionsTheme is explicitly set to the old transition on Android.
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: ZoomPageTransitionsBuilder(),
      },
    ),
  ),
  home: const MyFirstScreen(),
);
```

Um efeito colateral de mudar a transição padrão é que a duração da transição
entre páginas aumentou de 300ms para 450ms. Isso pode
quebrar testes que dependem da duração da transição anterior.
Felizmente, é possível usar [`TransitionDurationObserver`][`TransitionDurationObserver`] para manter os testes
independentes da transição de página utilizada.

Código antes da migração:

```dart
testWidgets('example', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      onGenerateRoute: (RouteSettings settings) { ... },
    ),
  );

  expect(find.text('Page 1'), findsOneWidget);
  expect(find.text('Page 2'), findsNothing);

  // Pump through the whole transition, hardcoded to 300ms.
  await tester.tap(find.text('Next'));
  await tester.pump(const Duration(milliseconds: 300));

  expect(find.text('Page 1'), findsNothing);
  expect(find.text('Page 2'), findsOneWidget);
});
```

Código após a migração:

```dart
testWidgets('example', (WidgetTester tester) async {
  final TransitionDurationObserver observer = TransitionDurationObserver();

  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      onGenerateRoute: (RouteSettings settings) { ... },
    ),
  );

  expect(find.text('Page 1'), findsOneWidget);
  expect(find.text('Page 2'), findsNothing);

  // Pump through the whole transition independent of the duration.
  await tester.tap(find.text('Next'));
  await observer.pumpPastTransition(tester);

  expect(find.text('Page 1'), findsNothing);
  expect(find.text('Page 2'), findsOneWidget);
});
```

Também é possível escrever testes que precisam avançar até o meio de uma
transição de página sem depender da duração exata.

Código antes da migração:

```dart
testWidgets('example', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      onGenerateRoute: (RouteSettings settings) { ... },
    ),
  );

  expect(find.text('Page 1'), findsOneWidget);
  expect(find.text('Page 2'), findsNothing);

  // Pump through half of the transition with a hardcoded value.
  await tester.tap(find.text('Back'));
  await tester.pump(const Duration(milliseconds: 150));

  expect(find.text('Page 1'), findsOneWidget);
  expect(find.text('Page 2'), findsOneWidget);
});
```

Código após a migração:

```dart
testWidgets('example', (WidgetTester tester) async {
  final TransitionDurationObserver observer = TransitionDurationObserver();

  await tester.pumpWidget(
    MaterialApp(
      navigatorObservers: <NavigatorObserver>[observer],
      onGenerateRoute: (RouteSettings settings) { ... },
    ),
  );

  expect(find.text('Page 1'), findsOneWidget);
  expect(find.text('Page 2'), findsNothing);

  // Pump through half of the transition independent of the duration.
  await tester.tap(find.text('Back'));
  await tester.pump(observer.transitionDuration ~/ 2);

  expect(find.text('Page 1'), findsOneWidget);
  expect(find.text('Page 2'), findsOneWidget);
});
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.37.0-0.0.pre<br>
Na versão estável: 3.38.0

## Referências {:#references}

Documentação da API:

* [`ZoomPageTransitionsBuilder`][`ZoomPageTransitionsBuilder`]
* [`PredictiveBackPageTransitionsBuilder`][`PredictiveBackPageTransitionsBuilder`]
* [`FadeForwardsPageTransitionsBuilder`][`FadeForwardsPageTransitionsBuilder`]
* [`PopScope`][`PopScope`]
* [`TransitionDurationObserver`][`TransitionDurationObserver`]

Issues relevantes:

* [Transições de rota do voltar preditivo no Android][Android predictive back route transitions]

PRs relevantes:

* [Transições de rota do voltar preditivo por padrão][Predictive back route transitions by default]

[`FadeForwardsPageTransitionsBuilder`]: {{site.material_ui}}/FadeForwardsPageTransitionsBuilder-class.html
[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[`PredictiveBackPageTransitionsBuilder`]: {{site.material_ui}}/PredictiveBackPageTransitionsBuilder-class.html
[`TransitionDurationObserver`]: {{site.api}}/flutter/flutter_test/TransitionDurationObserver-class.html
[`ZoomPageTransitionsBuilder`]: {{site.material_ui}}/ZoomPageTransitionsBuilder-class.html

[Android predictive back route transitions]: {{site.repo.flutter}}/issues/131961
[Predictive back route transitions by default]: {{site.repo.flutter}}/pull/165832
