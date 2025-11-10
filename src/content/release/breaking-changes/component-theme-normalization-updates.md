---
title: Atualizações de normalização de temas de componentes
description: >-
  `AppBarTheme`, `BottomAppBarTheme` e `InputDecorationTheme` foram
  normalizados para seguir a convenção do Flutter para temas de componentes na
  biblioteca Material.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

`AppBarTheme`, `BottomAppBarTheme` e `InputDecorationTheme` foram refatorados
para estar em conformidade com as convenções do Flutter para temas de componentes.
`AppBarThemeData`, `BottomAppBarThemeData` e `InputDecorationThemeData` foram
adicionados para definir substituições para os padrões das propriedades visuais do componente.
Os lançamentos do Flutter continuam a normalizar temas de componentes como estes para
uma experiência de temas mais consistente na biblioteca material.

## Migration guide

Em `ThemeData`:
- O tipo da propriedade `appBarTheme` foi
  alterado de `AppBarTheme` para `AppBarThemeData`.
- O tipo da propriedade `bottomAppBarTheme` foi
  alterado de `BottomAppBarTheme` para `BottomAppBarThemeData`.
- O tipo da propriedade `inputDecorationTheme` foi
  alterado de `InputDecorationTheme` para `InputDecorationThemeData`.

O tipo de retorno dos métodos `xTheme.of()` do tema do componente e
`Theme.of().xTheme` também foram alterados para `xThemeData`.

Em `DatePickerThemeData` e `TimePickerThemeData`, o tipo da propriedade
`inputDecorationTheme` foi alterado de `InputDecorationTheme`
para `InputDecorationThemeData`.

Código antes da migração:

```dart
final AppBarTheme appBarTheme = Theme.of(context).appBarTheme;
final AppBarTheme appBarTheme = AppBarTheme.of(context);

final BottomAppBarTheme bottomAppBarTheme = Theme.of(context).bottomAppBarTheme;
final BottomAppBarTheme bottomAppBarTheme = BottomAppBarTheme.of(context);

final InputDecorationTheme inputDecorationTheme = Theme.of(context).inputDecorationTheme;
final InputDecorationTheme inputDecorationTheme = InputDecorationTheme.of(context);
final InputDecorationTheme inputDecorationTheme = Theme.of(context).datePickerTheme.inputDecorationTheme;
final InputDecorationTheme inputDecorationTheme = Theme.of(context).timePickerTheme.inputDecorationTheme;
```

```dart
final ThemeData theme = ThemeData(
  appBarTheme: AppBarTheme(),
  bottomAppBarTheme: BottomAppBarTheme(),
  inputDecorationTheme: InputDecorationTheme(),
);

final ThemeData theme = ThemeData().copyWith(
  appBarTheme: AppBarTheme(),
  bottomAppBarTheme: BottomAppBarTheme(),
  inputDecorationTheme: InputDecorationTheme(),
);

const DatePickerThemeData datePickerTheme = DatePickerThemeData(inputDecorationTheme: InputDecorationTheme());
const TimePickerThemeData timePickerTheme = TimePickerThemeData(inputDecorationTheme: InputDecorationTheme());
```

Código após a migração:

```dart
final AppBarThemeData appBarTheme = Theme.of(context).appBarTheme;
final AppBarThemeData appBarTheme = AppBarTheme.of(context);

final BottomAppBarThemeData bottomAppBarTheme = Theme.of(context).bottomAppBarTheme;
final BottomAppBarThemeData bottomAppBarTheme = BottomAppBarTheme.of(context);

final InputDecorationThemeData inputDecorationTheme = Theme.of(context).inputDecorationTheme;
final InputDecorationThemeData inputDecorationTheme = InputDecorationTheme.of(context);
final InputDecorationThemeData inputDecorationTheme = Theme.of(context).datePickerTheme.inputDecorationTheme;
final InputDecorationThemeData inputDecorationTheme = Theme.of(context).timePickerTheme.inputDecorationTheme;
```

```dart
final ThemeData theme = ThemeData(
  appBarTheme: AppBarThemeData(),
  bottomAppBarTheme: BottomAppBarThemeData(),
  inputDecorationTheme: InputDecorationThemeData(),
);

final ThemeData theme = ThemeData().copyWith(
  appBarTheme: AppBarThemeData(),
  bottomAppBarTheme: BottomAppBarThemeData(),
  inputDecorationTheme: InputDecorationThemeData(),
);

const DatePickerThemeData datePickerTheme = DatePickerThemeData(inputDecorationTheme: InputDecorationThemeData());
const TimePickerThemeData timePickerTheme = TimePickerThemeData(inputDecorationTheme: InputDecorationThemeData());
```

## Timeline

Adicionado na versão: 3.33.0-1.0.pre até 3.35.0-0.0.pre<br>
Versão estável: 3.35

## References

Documentação da API:

* [`AppBarTheme`][]
* [`BottomAppBarTheme`][]
* [`InputDecorationTheme`][]

PRs relevantes:

* [Normalize ThemeData.appBarTheme][]
* [Normalize ThemeData.bottomAppBarTheme][]
* [Normalize InputDecorationTheme][]
* [Apply normalization to TimePickerThemeData.inputDecorationTheme][]

[`AppBarTheme`]: {{site.api}}/flutter/material/AppBarTheme-class.html
[Normalize ThemeData.appBarTheme]: {{site.repo.flutter}}/pull/169130
[`BottomAppBarTheme`]: {{site.api}}/flutter/material/BottomAppBarTheme-class.html
[Normalize ThemeData.bottomAppBarTheme]: {{site.repo.flutter}}/pull/168586
[`InputDecorationTheme`]: {{site.api}}/flutter/material/InputDecorationTheme-class.html
[Normalize InputDecorationTheme]: {{site.repo.flutter}}/pull/168981
[Apply normalization to TimePickerThemeData.inputDecorationTheme]: {{site.repo.flutter}}/pull/171584
