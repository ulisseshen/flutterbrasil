---
title: Indicadores de progresso Material 3 atualizados
description: >-
  Os widgets `LinearProgressIndicator` e `CircularProgressIndicator`
  foram atualizados para corresponder às especificações de Design Material 3.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Os `LinearProgressIndicator` e `CircularProgressIndicator` foram
atualizados para corresponder às especificações de Design Material 3.

As mudanças em `LinearProgressIndicator` incluem uma lacuna entre
as trilhas ativa e inativa, um indicador de parada e cantos arredondados.
As mudanças em `CircularProgressIndicator` incluem uma lacuna entre
as trilhas ativa e inativa, e extremidade de traço arredondada.

## Context

As especificações de Design Material 3 para `LinearProgressIndicator` e
`CircularProgressIndicator` foram atualizadas em dezembro de 2023.

Para optar pelas especificações de design de 2024,
defina as flags `LinearProgressIndicator.year2023` e
`CircularProgressIndicator.year2023` como `false`.
Isso é feito para garantir que aplicações existentes não sejam afetadas pela
especificação de design atualizada.

## Description of change

Os widgets `LinearProgressIndicator` e `CircularProgressIndicator` têm cada um
uma flag `year2023` que pode ser definida como `false` para
optar pela especificação de design atualizada.
O valor padrão para a flag `year2023` é `true`, o que significa que
os indicadores de progresso usam a especificação de design de 2023.

Quando [`LinearProgressIndicator.year2023`][] é definido como `false`,
o indicador de progresso tem lacunas entre trilhas ativa e inativa,
um indicador de parada e cantos arredondados.
Se o `LinearProgressIndicator` é indeterminado,
o indicador de parada não é mostrado.

Quando [`CircularProgressIndicator.year2023`][] é definido como `false`,
o indicador de progresso tem uma lacuna na trilha e extremidade de traço arredondada.

## Migration guide

Para optar pela especificação de design atualizada para o `LinearProgressIndicator`,
defina a flag `year2023` como `false`:

```dart highlightLines=2
LinearProgressIndicator(
  year2023: false,
  value: 0.5,
),
```

Para atualizar sua aplicação inteira para usar o design atualizado de `LinearProgressIndicator`,
defina a propriedade `ProgressIndicatorThemeData.year2023` como `false` no seu
`MaterialApp`:

```dart highlightLines=2
return MaterialApp(
  theme: ThemeData(progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false)),
        // ...
        LinearProgressIndicator(
          year2023: false,
          value: 0.5,
        ),
        // ...
```

Para optar pela especificação de design atualizada para o `CircularProgressIndicator`,
defina a flag `year2023` como `false`:

```dart highlightLines=2
CircularProgressIndicator(
  year2023: false,
  value: 0.5,
),
```

Para atualizar sua aplicação inteira para usar o design atualizado de `CircularProgressIndicator`,
defina a propriedade `ProgressIndicatorThemeData.year2023` como `false` no seu
`MaterialApp`:

```dart highlightLines=2
return MaterialApp(
  theme: ThemeData(progressIndicatorTheme: const ProgressIndicatorThemeData(year2023: false)),
        // ...
        CircularProgressIndicator(
          year2023: false,
          value: 0.5,
        ),
        // ...
```

## Timeline

Landed in version: 3.28.0-0.1.pre<br>
In stable release: 3.29

## References

API documentation:

- [`LinearProgressIndicator`][]
- [`CircularProgressIndicator`][]
- [`LinearProgressIndicator.year2023`][]
- [`CircularProgressIndicator.year2023`][]

Relevant issues:

- [Update both `ProgressIndicator` for Material 3 redesign][]

Relevant PRs:

- [Update Material 3 `LinearProgressIndicator` for new visual style][]
- [Update Material 3 `CircularProgressIndicator` for new visual style][]

[`LinearProgressIndicator`]: {{site.main-api}}/flutter/material/LinearProgressIndicator-class.html
[`CircularProgressIndicator`]: {{site.main-api}}/flutter/material/CircularProgressIndicator-class.html
[`LinearProgressIndicator.year2023`]: {{site.main-api}}/flutter/material/LinearProgressIndicator/year2023.html
[`CircularProgressIndicator.year2023`]: {{site.main-api}}/flutter/material/CircularProgressIndicator/year2023.html
[Update both `ProgressIndicator` for Material 3 redesign]: {{site.repo.flutter}}/issues/141340
[Update Material 3 `LinearProgressIndicator` for new visual style]: {{site.repo.flutter}}/pull/154817
[Update Material 3 `CircularProgressIndicator` for new visual style]: {{site.repo.flutter}}/pull/158104
