---
title: Depreciar `ThemeData.indicatorColor` em favor de
  `TabBarThemeData.indicatorColor`
description: >-
  O parâmetro `ThemeData.indicatorColor` foi substituído por
  `TabBarThemeData.indicatorColor`.
ia-translate: true
---

## Resumo

O parâmetro [`ThemeData.indicatorColor`][] foi depreciado em favor do
parâmetro [`TabBarThemeData.indicatorColor`][].

## Contexto

Os padrões do widget [`TabBar`][] podem ser sobrescritos com um
tema específico de componente como [`TabBarThemeData`][].
Anteriormente, o parâmetro `ThemeData.indicatorColor` era usado para
sobrescrever a cor padrão do indicador da tab bar no Material Design 2,
o que foi tornado redundante pelo [`TabBarThemeData`][].

## Descrição da mudança

O [`ThemeData.indicatorColor`][] está depreciado em
favor de um tema específico de componente.
Use [`TabBarThemeData`][] para sobrescrever a cor padrão do indicador.

## Guia de migração

Substitua [`ThemeData.indicatorColor`][] por
[`TabBarThemeData.indicatorColor`][] para sobrescrever a cor padrão do indicador
da tab bar quando a flag [`ThemeData.useMaterial3`][] estiver definida como `false`.

Código antes da migração:

```dart
theme: ThemeData(
  indicatorColor: Colors.red,
  useMaterial3: false,
),
```

Código após a migração:

```dart
theme: ThemeData(
  tabBarTheme: const TabBarThemeData(indicatorColor: Colors.red),
  useMaterial3: false,
),
```

## Linha do tempo

Implementado na versão: Ainda não<br>
Na versão estável: Ainda não

## Referências

Documentação da API:

- [`ThemeData.indicatorColor`][]
- [`ThemeData.useMaterial3`][]
- [`TabBarThemeData.indicatorColor`][]
- [`TabBarThemeData`][]
- [`TabBar`][]

Issues relevantes:

- [Issue #91772][]

PRs relevantes:

- [Deprecate `ThemeData.indicatorColor` in favor of `TabBarThemeData.indicatorColor`][]

[`ThemeData.indicatorColor`]: {{site.api}}/flutter/material/ThemeData/indicatorColor.html
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[`TabBarThemeData.indicatorColor`]: {{site.api}}/flutter/material/TabBarThemeData/indicatorColor.html
[`TabBarThemeData`]: {{site.api}}/flutter/material/TabBarThemeData-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[Issue #91772]: {{site.repo.flutter}}/issues/91772
[Deprecate `ThemeData.indicatorColor` in favor of `TabBarThemeData.indicatorColor`]: {{site.repo.flutter}}/pull/160024
