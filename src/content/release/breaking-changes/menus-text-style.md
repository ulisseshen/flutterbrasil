---
title: Updated default text styles for menus
description: >-
  The default text styles for menus are updated to
  match the Material 3 specification.
ia-translate: true
---

## Resumo

The default text styles used for menus are updated
to match the Material 3 specification.

## Contexto

The default text style for `MenuItemButton` (a widget used
in a `MenuBar`, and in a menu created with `MenuAnchor`), 
and `DropdownMenuEntry` (in the `DropdownMenu`) is
updated to match the Material 3 specification.

Likewise, the default text style for the `DropdownMenu`s `TextField` is updated
to match the Material 3 specification.

## Descrição da mudança

The default text style for `MenuItemButton` (a widget used
in a `MenuBar`, and in a menu created with `MenuAnchor`), 
and `DropdownMenuEntry` (in the `DropdownMenu`) is updated from
`TextTheme.bodyLarge` to `TextTheme.labelLarge` for Material 3.

The default text style for the `DropdownMenu`s `TextField` is updated from
`TextTheme.labelLarge` to `TextTheme.bodyLarge` for Material 3.

## Guia de migração

A `MenuItemButton` for Material 3 uses
`TextTheme.labelLarge` as the default text style. 
To use the previous default text style, set the `TextTheme.bodyLarge` text style
in the `MenuItemButton.style` or `MenuButtonThemeData.style` properties.

Código antes da migração:

```dart
MenuItemButton(
  child: Text(MenuEntry.about.label),
  onPressed: () => _activate(MenuEntry.about),
),
```

```dart
menuButtonTheme: MenuButtonThemeData(
  style: MenuItemButton.styleFrom(
    /// ...
  ),
),
```

Código após a migração:

```dart
MenuItemButton(
  style: MenuItemButton.styleFrom(
    textStyle: Theme.of(context).textTheme.bodyLarge,
  ),
  child: Text(MenuEntry.about.label),
  onPressed: () => _activate(MenuEntry.about),
),
```

```dart
menuButtonTheme: MenuButtonThemeData(
  style: MenuItemButton.styleFrom(
    textStyle: Theme.of(context).textTheme.bodyLarge,
  ),
),
```

A `DropdownMenu`'s `TextField` for Material 3 
uses `TextTheme.bodyLarge` as the default text style. 
To use the previous default text style, 
set the `TextTheme.labelLarge` text style in 
the `DropdownMenu.textStyle` or `DropdownMenuThemeData.textStyle` properties.

Código antes da migração:

```dart
DropdownMenu<ColorLabel>(
  initialSelection: ColorLabel.green,
  controller: colorController,
  label: const Text('Color'),
  dropdownMenuEntries: colorEntries,
  onSelected: (ColorLabel? color) {
    setState(() {
      selectedColor = color;
    });
  },
),
```

```dart
dropdownMenuTheme: DropdownMenuThemeData(
  /// ...
),
```

Código após a migração:

```dart
DropdownMenu<ColorLabel>(
  textStyle: Theme.of(context).textTheme.labelLarge,
  initialSelection: ColorLabel.green,
  controller: colorController,
  label: const Text('Color'),
  dropdownMenuEntries: colorEntries,
  onSelected: (ColorLabel? color) {
    setState(() {
      selectedColor = color;
    });
  },
),
```

```dart
dropdownMenuTheme: DropdownMenuThemeData(
  textStyle: TextStyle(
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.bold,
  ),
),
```

A `DropdownMenu`'s `DropdownMenuEntry` for Material 3 
uses `TextTheme.labelLarge` as the default text style. 
To use the previous default text style, set the
`TextTheme.bodyLarge` text style in
the `DropdownMenuEntry.style` or `MenuButtonThemeData.style` properties.

Código antes da migração:

```dart
DropdownMenuEntry<ColorLabel>(
  value: color,
  label: color.label,
),
```

```dart
menuButtonTheme: MenuButtonThemeData(
  style: MenuItemButton.styleFrom(
    /// ...
  ),
),
```

Código após a migração:

```dart
DropdownMenuEntry<ColorLabel>(
  style: MenuItemButton.styleFrom(
    textStyle: Theme.of(context).textTheme.bodyLarge,
  ),
  value: color,
  label: color.label,
),
```

```dart
menuButtonTheme: MenuButtonThemeData(
  style: MenuItemButton.styleFrom(
    textStyle: Theme.of(context).textTheme.bodyLarge,
  ),
),
```

## Linha do tempo

Lançado na versão: 3.14.0-11.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

* [`MenuBar`][]
* [`MenuAnchor`][]
* [`MenuItemButton`][]
* [`MenuButtonTheme`][]
* [`DropdownMenu`][]
* [`DropdownMenuEntry`][]
* [`DropdownMenuTheme`][]
* [`TextTheme`][]

PRs relevantes:

* [Update default menu text styles for Material 3][]

[`MenuBar`]: {{site.api}}/flutter/material/MenuBar-class.html
[`MenuAnchor`]: {{site.api}}/flutter/material/MenuAnchor-class.html
[`MenuItemButton`]: {{site.api}}/flutter/material/MenuItemButton-class.html
[`MenuButtonTheme`]: {{site.api}}/flutter/material/MenuButtonTheme-class.html
[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`DropdownMenuEntry`]: {{site.api}}/flutter/material/DropdownMenuEntry-class.html
[`DropdownMenuTheme`]: {{site.api}}/flutter/material/DropdownMenuTheme-class.html
[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html

[Update default menu text styles for Material 3]: {{site.repo.flutter}}/pull/131930
