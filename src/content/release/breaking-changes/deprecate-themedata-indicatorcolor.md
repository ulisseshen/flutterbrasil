---
ia-translate: true
title: Descontinuar `ThemeData.indicatorColor` em favor de
  `TabBarThemeData.indicatorColor`
description: >-
  O parâmetro `ThemeData.indicatorColor` foi substituído por
  `TabBarThemeData.indicatorColor`.
---

## Resumo

O parâmetro [`ThemeData.indicatorColor`][] foi descontinuado em favor do
parâmetro [`TabBarThemeData.indicatorColor`][].

## Contexto

Os padrões para o widget [`TabBar`][] podem ser sobrepostos com um tema
específico do componente, como [`TabBarThemeData`][]. Anteriormente, o
parâmetro `ThemeData.indicatorColor` era usado para sobrepor a cor padrão do
indicador da barra de abas no Material Design 2, que se tornou redundante com
[`TabBarThemeData`][].

## Descrição da mudança

O [`ThemeData.indicatorColor`][] foi descontinuado em favor de um tema
específico do componente. Use [`TabBarThemeData`][] para sobrepor a cor
padrão do indicador.

## Guia de migração

Substitua [`ThemeData.indicatorColor`][] por
[`TabBarThemeData.indicatorColor`][] para sobrepor a cor padrão do indicador da
barra de abas quando a flag [`ThemeData.useMaterial3`][] estiver definida
como `false`.

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

## Cronograma

Implementado na versão: v3.27.0-0.2.pre.<br>
Na versão estável: A ser definido

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

- [Descontinuar `ThemeData.indicatorColor` em favor de `TabBarThemeData.indicatorColor`][]

[`ThemeData.indicatorColor`]: {{site.api}}/flutter/material/ThemeData/indicatorColor.html
[`ThemeData.useMaterial3`]: {{site.api}}/flutter/material/ThemeData/useMaterial3.html
[`TabBarThemeData.indicatorColor`]: {{site.api}}/flutter/material/TabBarThemeData/indicatorColor.html
[`TabBarThemeData`]: {{site.api}}/flutter/material/TabBarThemeData-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[Issue #91772]: {{site.repo.flutter}}/issues/91772
[Descontinuar `ThemeData.indicatorColor` em favor de `TabBarThemeData.indicatorColor`]: {{site.repo.flutter}}/pull/160024
