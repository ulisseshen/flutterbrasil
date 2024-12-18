---
ia-translate: true
title: Estilos de texto padrão atualizados para menus
description: >-
  Os estilos de texto padrão para menus foram atualizados
  para corresponder à especificação do Material 3.
---

## Resumo

Os estilos de texto padrão usados para menus foram atualizados
para corresponder à especificação do Material 3.

## Contexto

O estilo de texto padrão para `MenuItemButton` (um widget usado
em um `MenuBar` e em um menu criado com `MenuAnchor`), 
e `DropdownMenuEntry` (em `DropdownMenu`) foi
atualizado para corresponder à especificação do Material 3.

Da mesma forma, o estilo de texto padrão para o `TextField` de `DropdownMenu` foi
atualizado para corresponder à especificação do Material 3.

## Descrição da alteração

O estilo de texto padrão para `MenuItemButton` (um widget usado
em um `MenuBar` e em um menu criado com `MenuAnchor`), 
e `DropdownMenuEntry` (em `DropdownMenu`) foi atualizado de
`TextTheme.bodyLarge` para `TextTheme.labelLarge` para Material 3.

O estilo de texto padrão para o `TextField` de `DropdownMenu` foi atualizado de
`TextTheme.labelLarge` para `TextTheme.bodyLarge` para Material 3.

## Guia de migração

Um `MenuItemButton` para Material 3 usa
`TextTheme.labelLarge` como o estilo de texto padrão.
Para usar o estilo de texto padrão anterior, defina o estilo de texto `TextTheme.bodyLarge`
nas propriedades `MenuItemButton.style` ou `MenuButtonThemeData.style`.

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

O `TextField` de um `DropdownMenu` para Material 3
usa `TextTheme.bodyLarge` como o estilo de texto padrão.
Para usar o estilo de texto padrão anterior,
defina o estilo de texto `TextTheme.labelLarge` nas
propriedades `DropdownMenu.textStyle` ou `DropdownMenuThemeData.textStyle`.

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

Um `DropdownMenuEntry` de `DropdownMenu` para Material 3
usa `TextTheme.labelLarge` como o estilo de texto padrão.
Para usar o estilo de texto padrão anterior, defina o
estilo de texto `TextTheme.bodyLarge` nas
propriedades `DropdownMenuEntry.style` ou `MenuButtonThemeData.style`.

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

Implementado na versão: 3.14.0-11.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

*   [`MenuBar`][]
*   [`MenuAnchor`][]
*   [`MenuItemButton`][]
*   [`MenuButtonTheme`][]
*   [`DropdownMenu`][]
*   [`DropdownMenuEntry`][]
*   [`DropdownMenuTheme`][]
*   [`TextTheme`][]

PRs relevantes:

*   [Atualizar os estilos de texto padrão do menu para Material 3][]

[`MenuBar`]: {{site.api}}/flutter/material/MenuBar-class.html
[`MenuAnchor`]: {{site.api}}/flutter/material/MenuAnchor-class.html
[`MenuItemButton`]: {{site.api}}/flutter/material/MenuItemButton-class.html
[`MenuButtonTheme`]: {{site.api}}/flutter/material/MenuButtonTheme-class.html
[`DropdownMenu`]: {{site.api}}/flutter/material/DropdownMenu-class.html
[`DropdownMenuEntry`]: {{site.api}}/flutter/material/DropdownMenuEntry-class.html
[`DropdownMenuTheme`]: {{site.api}}/flutter/material/DropdownMenuTheme-class.html
[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html

[Atualizar os estilos de texto padrão do menu para Material 3]: {{site.repo.flutter}}/pull/131930
