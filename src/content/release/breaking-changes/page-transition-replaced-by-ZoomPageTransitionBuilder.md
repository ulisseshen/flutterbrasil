---
title: Transições de página substituídas por ZoomPageTransitionsBuilder
description: Usando a última transição de página em vez da antiga.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Para garantir que as bibliotecas sigam o comportamento mais recente do OEM,
os construtores de transição de página padrão agora usam
`ZoomPageTransitionsBuilder` em todas as plataformas (excluindo iOS e macOS)
em vez de `FadeUpwardsPageTransitionsBuilder`.

## Contexto

O `FadeUpwardsPageTransitionsBuilder` (fornecido com a primeira
versão do Flutter), definia uma transição de página que é
semelhante à fornecida pelo Android O. Este construtor de transições de página
eventualmente será descontinuado no Android, de acordo com a
[política de descontinuação](/release/compatibility-policy#deprecation-policy) do Flutter.

`ZoomPageTransitionsBuilder`, o novo construtor de transição de página para
Android, Linux e Windows, define uma transição de página semelhante à
fornecida pelo Android Q e R.

De acordo com o [Style guide for Flutter repo][],
o framework seguirá o comportamento mais recente do OEM.
Os construtores de transição de página usando `FadeUpwardsPageTransitionsBuilder`
foram todos alterados para `ZoomPageTransitionsBuilder`.
Quando a `TargetPlatform` atual não tem
`PageTransitionsBuilder` definido em `ThemeData.pageTransitionsTheme`,
`ZoomPageTransitionsBuilder` é usado como padrão.

[Style guide for Flutter repo]: {{site.repo.flutter}}/blob/main/docs/contributing/Style-guide-for-Flutter-repo.md
## Descrição da alteração

Os `PageTransitionsBuilder`s definidos em
`PageTransitionsTheme._defaultBuilders` foram alterados de
`FadeUpwardsPageTransitionsBuilder` para
`ZoomPageTransitionsBuilder` para `TargetPlatform.android`,
`TargetPlatform.linux` e `TargetPlatform.windows`.

## Guia de migração

Se você quiser voltar ao construtor de transição de página anterior
(`FadeUpwardsPageTransitionsBuilder`), você deve definir os construtores
explicitamente para as plataformas de destino.

Código antes da migração:

```dart
MaterialApp(
  theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
)
```

Código após a migração:

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(), // Apply this to every platforms you need.
      },
    ),
  ),
)
```

Se você quiser aplicar o mesmo construtor de transição de página a todas as plataformas:

```dart
MaterialApp(
  theme: ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
        TargetPlatform.values,
        value: (dynamic _) => const FadeUpwardsPageTransitionsBuilder(),
      ),
    ),
  ),
)

```

### Migração de testes

Se você costumava tentar encontrar widgets mas falhava com *Too many elements*
usando a nova transição, e via erros semelhantes ao seguinte:

```plaintext
══╡ EXCEPTION CAUGHT BY FLUTTER TEST FRAMEWORK ╞════════════════════════════════════════════════════
The following StateError was thrown running a test:
Bad state: Too many elements

When the exception was thrown, this was the stack:
#0      Iterable.single (dart:core/iterable.dart:656:24)
#1      WidgetController.widget (package:flutter_test/src/controller.dart:69:30)
#2      main.<anonymous closure> (file:///path/to/your/test.dart:1:2)
```

Você deve migrar seus testes usando o
escopo `descendant` para `Finder`s com o tipo de widget específico.
Abaixo está o exemplo do teste de `DataTable`:

Teste antes da migração:

```dart
final Finder finder = find.widgetWithIcon(Transform, Icons.arrow_upward);
```

Teste após a migração:

```dart
final Finder finder = find.descendant(
  of: find.byType(DataTable),
  matching: find.widgetWithIcon(Transform, Icons.arrow_upward),
);
```

Os widgets que normalmente precisam migrar o escopo do finder são:
`Transform`, `FadeTransition`, `ScaleTransition` e `ColoredBox`.

## Linha do tempo

Disponibilizado na versão: 2.13.0-1.0.pre<br>
Na versão estável: 3.0.0

## Referências

Documentação da API:

* [`ZoomPageTransitionsBuilder`][]
* [`FadeUpwardsPageTransitionsBuilder`][]
* [`PageTransitionsTheme`][]

Issues relevantes:

* [Issue 43277][]

PR relevante:

* [PR 100812][]

[`ZoomPageTransitionsBuilder`]: {{site.api}}/flutter/material/ZoomPageTransitionsBuilder-class.html
[`FadeUpwardsPageTransitionsBuilder`]: {{site.api}}/flutter/material/FadeUpwardsPageTransitionsBuilder-class.html
[`PageTransitionsTheme`]: {{site.api}}/flutter/material/PageTransitionsTheme-class.html
[Issue 43277]: {{site.repo.flutter}}/issues/43277
[PR 100812]: {{site.repo.flutter}}/pull/100812
