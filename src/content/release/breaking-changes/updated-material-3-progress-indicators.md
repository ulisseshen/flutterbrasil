---
ia-translate: true
title: Indicadores de Progresso Material 3 Atualizados
description: >-
  Os widgets `LinearProgressIndicator` e `CircularProgressIndicator` foram
  atualizados para corresponder às especificações do Material 3 Design.
---

## Resumo

Os widgets `LinearProgressIndicator` e `CircularProgressIndicator` foram
atualizados para corresponder às especificações do Material 3 Design. As
alterações no `LinearProgressIndicator` incluem um espaço entre as trilhas
ativas e inativas, um indicador de parada e cantos arredondados. As alterações
no `CircularProgressIndicator` incluem um espaço entre as trilhas ativas e
inativas e um `stroke cap` arredondado.

## Contexto

As especificações do Material 3 Design para `LinearProgressIndicator` e
`CircularProgressIndicator` foram atualizadas em dezembro de 2023. Para optar
pelas especificações de design de 2024, defina os flags
`LinearProgressIndicator.year2023` e `CircularProgressIndicator.year2023`
como `false`. Isso é feito para garantir que os aplicativos existentes não
sejam afetados pela especificação de design atualizada.

## Descrição da mudança

Os widgets `LinearProgressIndicator` e `CircularProgressIndicator` possuem
cada um um flag `year2023` que pode ser definido como `false` para optar pela
especificação de design atualizada. O valor padrão para o flag `year2023` é
`true`, o que significa que os indicadores de progresso usam a especificação
de design de 2023.

Quando [`LinearProgressIndicator.year2023`][] é definido como `false`, o
indicador de progresso terá espaços entre as trilhas ativas e inativas, um
indicador de parada e cantos arredondados. Se o `LinearProgressIndicator` for
indeterminado, o indicador de parada não será mostrado.

Quando [`CircularProgressIndicator.year2023`][] é definido como `false`, o
indicador de progresso terá um espaço na trilha e um `stroke cap` arredondado.

## Guia de migração

Para optar pela especificação de design atualizada para o
`LinearProgressIndicator`, defina o flag `year2023` como `false`:

```dart
LinearProgressIndicator(
  year2023: false,
  value: 0.5,
),
```

Para optar pela especificação de design atualizada para o
`CircularProgressIndicator`, defina o flag `year2023` como `false`:

```dart
CircularProgressIndicator(
  year2023: false,
  value: 0.5,
),
```

## Cronograma

Implementado na versão: v3.27.0-0.2.pre.<br>
Na versão estável: A ser definido

## Referências

Documentação da API:

- [`LinearProgressIndicator`][]
- [`CircularProgressIndicator`][]
- [`LinearProgressIndicator.year2023`][]
- [`CircularProgressIndicator.year2023`][]

Issues relevantes:

- [Update both `ProgressIndicator` for Material 3 redesign][]

PRs relevantes:

- [Update Material 3 `LinearProgressIndicator` for new visual style][]
- [Update Material 3 `CircularProgressIndicator` for new visual style][]

[`LinearProgressIndicator`]: {{site.api}}/flutter/material/LinearProgressIndicator-class.html
[`CircularProgressIndicator`]: {{site.api}}/flutter/material/CircularProgressIndicator-class.html
[`LinearProgressIndicator.year2023`]: {{site.api}}/flutter/material/LinearProgressIndicator/year2023.html
[`CircularProgressIndicator.year2023`]: {{site.api}}/flutter/material/CircularProgressIndicator/year2023.html
[Update both `ProgressIndicator` for Material 3 redesign]: {{site.repo.flutter}}/issues/141340
[Update Material 3 `LinearProgressIndicator` for new visual style]: {{site.repo.flutter}}/pull/141340
[Update Material 3 `CircularProgressIndicator` for new visual style]: {{site.repo.flutter}}/pull/141340
