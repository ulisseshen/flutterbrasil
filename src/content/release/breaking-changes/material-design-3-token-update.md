---
title: Atualização de tokens Material 3 no Flutter
description: >-
  Os tokens Material Design 3 mais recentes (v6.1) foram aplicados à
  biblioteca Material do Flutter.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Os tokens de Material Design atualizaram o mapeamento de
4 papéis de cor no modo claro para ser mais
visualmente atraente enquanto retém contraste acessível.
Testes identificaram esta mudança como [não-quebra][non-breaking] no Flutter, mas
alguns clientes podem notar esta pequena mudança.
A atualização afetou as seguintes propriedades de cor:

* `onPrimaryContainer` (Primary10 para Primary30)
* `onSecondaryContainer` (Secondary10 para Secondary30)
* `onTertiaryContainer` (Tertiary10 para Tertiary30)
* `onErrorContainer` (Error10 para Error30)

Widgets que têm usado esses papéis como seus
valores padrão podem parecer diferentes.

Além disso, os tokens Material 3 atualizaram a cor da borda de
widgets chip de `ColorScheme.outline` para `ColorScheme.outlineVariant` para
melhorar a hierarquia visual entre chips e botões.
Chips (`Chip`, `ActionChip`, `ChoiceChip`, `FilterChip`, e `InputChip`) que
têm usado os tokens de borda do chip podem parecer diferentes.

## Migration guide

As diferenças nos mapeamentos dos papéis de cor são pequenas.
Use `ColorScheme.copyWith` para reverter para as cores padrão originais:

Code before migration:

```dart
final ColorScheme colors = ThemeData().colorScheme;
```

Code after migration:

```dart
final ColorScheme colors = ThemeData().colorScheme.copyWith(
  onPrimaryContainer: const Color(0xFF21005D),
  onSecondaryContainer: const Color(0xFF1D192B),
  onTertiaryContainer: const Color(0xFF31111D),
  onErrorContainer: const Color(0xFF410E0B),
);
```

Após aplicar a atualização de token,
a cor da borda padrão de chips M3 parece mais clara.
Tome `ActionChip` como exemplo:

Code before migration:

```dart
final chip = ActionChip(
  label: const Text('action chip'),
  onPressed: () {},
);
```

Code after migration:

```dart
final chip = ChipTheme(
  data: ChipThemeData(
    side: BorderSide(
      color: Theme.of(context).colorScheme.outline
    ),
  ),
  child: ActionChip(
    label: const Text('action chip'),
    onPressed: () {}
  )
);
```

## Timeline

Landed in version: 3.26.0-0.0.pre<br>
In stable release: 3.27

## References

API documentation:

* [`ColorScheme`][]
* [`ThemeData`][]
* [`Chip`][]

Relevant PRs:

* [Update tokens to v5.0.0][]
* [Update tokens to v6.1.0][]

[`ColorScheme`]: {{site.api}}/flutter/material/ColorScheme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[Update tokens to v5.0.0]: {{site.repo.flutter}}/pull/153385
[Update tokens to v6.1.0]: {{site.repo.flutter}}/pull/153722
[non-breaking]: {{site.repo.flutter}}/flutter/blob/master/docs/contributing/Tree-hygiene.md#1-determine-if-your-change-is-a-breaking-change
