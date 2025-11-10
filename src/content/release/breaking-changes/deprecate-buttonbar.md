---
title: Descontinuar `ButtonBar` em favor de `OverflowBar`
description: >-
  O widget ButtonBar foi substituído por
  um widget mais eficiente, OverflowBar.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

O widget `ButtonBar` foi descontinuado em favor do
widget mais eficiente `OverflowBar`.
Como resultado, `ThemeData.buttonBarTheme` e
`ButtonBarTheme` também foram descontinuados.

## Context

O widget `ButtonBar` organiza seus children em uma linha e
em uma coluna se não houver espaço horizontal suficiente.
O widget `OverflowBar` faz o mesmo, mas não está
vinculado à biblioteca Material e faz parte da biblioteca principal `widgets.dart`.

## Description of change

- Substitua o widget `ButtonBar` pelo widget `OverflowBar`.
- Por padrão, `ButtonBar` alinha seus children ao final do layout, enquanto
  `OverflowBar` alinha seus children ao início.
  Para alinhar os children do `OverflowBar` ao final, defina
  a propriedade `OverflowBar.alignment` como `MainAxisAlignment.end`.
- `ButtonBar.buttonPadding` fornece espaçamento
  entre botões e padding ao redor dos botões.
  Substitua-o por `OverflowBar.spacing`, que fornece espaçamento entre botões.
  Envolva o widget `OverflowBar` com o widget `Padding` para
  fornecer padding ao redor dos botões.
- Substitua `ButtonBar.overflowButtonSpacing` por `OverflowBar.overflowSpacing`,
  que fornece espaçamento entre botões quando os botões são dispostos em uma coluna
  quando não há espaço horizontal suficiente.
- Se estiver especificado, remova `ButtonBarThemeData` de `ThemeData`.

## Migration guide

Substitua `ButtonBar` por `OverflowBar`, sobrescreva o alinhamento padrão se
necessário, substitua `ButtonBar.buttonPadding` por widget `Padding` e
`OverflowBar.spacing` para espaçamento entre e ao redor dos botões, e substitua
`ButtonBar.overflowButtonSpacing` por `OverflowBar.overflowSpacing` para
espaçamento entre botões quando os botões são dispostos em uma coluna quando não há
espaço horizontal suficiente.

Before:

```dart
ButtonBar(
  buttonPadding: const EdgeInsets.all(8.0),
  overflowButtonSpacing: 8.0,
  children: <Widget>[
    TextButton(child: const Text('Button 1'), onPressed: () {}),
    TextButton(child: const Text('Button 2'), onPressed: () {}),
    TextButton(child: const Text('Button 3'), onPressed: () {}),
  ],
),
```

After:

```dart
Padding(
  padding: const EdgeInsets.all(8.0),
  child: OverflowBar(
    alignment: MainAxisAlignment.end,
    spacing: 8.0,
    overflowSpacing: 8.0,
    children: <Widget>[
      TextButton(child: const Text('Button 1'), onPressed: () {}),
      TextButton(child: const Text('Button 2'), onPressed: () {}),
      TextButton(child: const Text('Button 3'), onPressed: () {}),
    ],
  ),
),
```

Se você especificar um `ThemeData.buttonBarTheme`, remova-o e
use as propriedades do widget `OverflowBar` para customizar o widget `OverflowBar`.

Before:

```dart
ThemeData(
  buttonBarTheme: ButtonBarThemeData(
    alignment: MainAxisAlignment.center,
  ),
),
```

After:

```dart
ThemeData(
  // ...
),
```

Se você usar o widget `ButtonBarTheme`, remova-o e
use as propriedades do widget `OverflowBar` para customizar o widget `OverflowBar`.

Before:

```dart
ButtonBarTheme(
  data: ButtonBarThemeData(
    alignment: MainAxisAlignment.center,
  ),
  child: ButtonBar(
    children: <Widget>[
      // ...
    ],
  ),
),
```

After:

```dart
OverflowBar(
  alignment: MainAxisAlignment.center,
  children: <Widget>[
    // ...
  ],
),
```

## Timeline

Landed in version: 3.22.0-2.0.pre<br>
In stable release: 3.24.0

## References

API documentation:

- [`OverflowBar`][]
- [`ButtonBar`][]

Relevant issues:

- [Issue #127955][]

Relevant PRs:

- [Deprecate `ButtonBar`, `ButtonBarThemeData`, and `ThemeData.buttonBarTheme`][]

[`OverflowBar`]: {{site.api}}/flutter/widgets/OverflowBar-class.html
[`ButtonBar`]: {{site.api}}/flutter/material/ButtonBar-class.html
[Issue #127955]: {{site.repo.flutter}}/issues/127955
[Deprecate `ButtonBar`, `ButtonBarThemeData`, and `ThemeData.buttonBarTheme`]: {{site.repo.flutter}}/pull/145523
