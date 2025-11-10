---
title: Descontinuar `ThemeData.indicatorColor` em favor de
  `TabBarThemeData.indicatorColor`
description: >-
  O parâmetro `ThemeData.indicatorColor` foi substituído por
  `TabBarThemeData.indicatorColor`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

O parâmetro [`ThemeData.indicatorColor`][] foi descontinuado em favor do
parâmetro [`TabBarThemeData.indicatorColor`][].

## Context

Os padrões para o widget [`TabBar`][] podem ser sobrescritos com um
theme específico do componente como [`TabBarThemeData`][].
Anteriormente, o parâmetro `ThemeData.indicatorColor` era usado para
sobrescrever a cor padrão do indicador da tab bar no Material Design 2,
o que foi tornado redundante por [`TabBarThemeData`][].

## Description of change

O [`ThemeData.indicatorColor`][] está descontinuado em
favor de um theme específico do componente.
Use [`TabBarThemeData`][] para sobrescrever a cor padrão do indicador.

## Migration guide

Substitua [`ThemeData.indicatorColor`][] por
[`TabBarThemeData.indicatorColor`][] para sobrescrever a cor padrão do indicador
da tab bar quando a flag [`ThemeData.useMaterial3`][] está definida como `false`.

Code before migration:

```dart
theme: ThemeData(
  indicatorColor: Colors.red,
  useMaterial3: false,
),
```

Code after migration:

```dart
theme: ThemeData(
  tabBarTheme: const TabBarThemeData(indicatorColor: Colors.red),
  useMaterial3: false,
),
```

## Timeline

Landed in version: 3.30.0-0.0.pre<br>
In stable release: 3.32

## References

API documentation:

- [`ThemeData.indicatorColor`][]
- [`ThemeData.useMaterial3`][]
- [`TabBarThemeData.indicatorColor`][]
- [`TabBarThemeData`][]
- [`TabBar`][]

Relevant issues:

- [Issue #91772][]

Relevant PRs:

- [Deprecate `ThemeData.indicatorColor` in favor of `TabBarThemeData.indicatorColor`][]

[`ThemeData.indicatorColor`]: {{site.api}}/flutter/material/ThemeData/indicatorColor.html
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[`TabBarThemeData.indicatorColor`]: {{site.api}}/flutter/material/TabBarThemeData/indicatorColor.html
[`TabBarThemeData`]: {{site.api}}/flutter/material/TabBarThemeData-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[Issue #91772]: {{site.repo.flutter}}/issues/91772
[Deprecate `ThemeData.indicatorColor` in favor of `TabBarThemeData.indicatorColor`]: {{site.repo.flutter}}/pull/160024
