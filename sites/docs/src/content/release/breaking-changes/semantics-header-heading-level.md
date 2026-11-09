---
ia-translate: true
title: Atualização do comportamento de header e headingLevel no iOS e Android
description: >-
  A propriedade de semântica `header` agora não tem efeito no iOS e no Android.
  Os comportamentos de cabeçalho de acessibilidade agora são controlados por `headingLevel`.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

A propriedade de semântica `header` agora não tem efeito no iOS e no Android.
Para declarar um título de seção para fins de acessibilidade nessas plataformas,
use a propriedade `headingLevel` com um valor maior que `0`.

## Contexto {:#context}

Historicamente, o Flutter usava a propriedade booleana de semântica `header`
para indicar cabeçalhos nas implementações das plataformas:

* No Android, um valor `true` em `header` era mapeado para `View.setHeading(true)`.
* No iOS, um valor `true` em `header` era mapeado para o
  traço de acessibilidade `UIAccessibilityTraitHeader`.

No entanto, `setHeading` e `UIAccessibilityTraitHeader`
representam cabeçalhos (equivalentes a títulos de seção),
que são melhor representados por um nível de cabeçalho.
Por outro lado, "header" nessas plataformas costuma representar um banner
ou uma app bar (como `SliverAppBar` ou `AppBar`),
o que gera confusão e descompasso
entre as APIs das plataformas e as propriedades do Flutter.

Com essa mudança:

* A propriedade de semântica `header` não tem efeito no iOS e no Android.
  Ela continua disponível na API e ainda pode ser
  usada no futuro, caso APIs semelhantes sejam fornecidas.
* A propriedade `headingLevel` foi atualizada para que, ao definir
  um valor maior que `0`, ela seja mapeada diretamente para
  `View.setHeading(true)` no Android
  e para `UIAccessibilityTraitHeader` no iOS.
  No iOS 13 ou superior, ela também é mapeada para `accessibilityHeadingLevel`.

## Guia de migração {:#migration-guide}

Se o seu código usava `Semantics(header: true, ...)` ou
`SemanticsProperties(header: true, ...)` para declarar cabeçalhos,
migre o código para usar `headingLevel: 1`
(ou outro inteiro maior que `0`).

Observe que, embora definir `headingLevel` com qualquer valor maior que `0`
declare um cabeçalho no Android e no iOS, outras plataformas (como a web)
tratam o número do nível de cabeçalho de forma diferente.
Por exemplo, na web, os valores de `1` a `6` são mapeados para os
elementos HTML `<h1>` a `<h6>`.

Código antes da migração:

```dart highlightLines=2
Semantics(
  header: true,
  child: Text('Section Title'),
)
```

Código após a migração:

```dart highlightLines=2
Semantics(
  headingLevel: 1,
  child: Text('Section Title'),
)
```

Da mesma forma, se você usava `SemanticsProperties`:

Código antes da migração:

```dart highlightLines=2
SemanticsProperties(
  header: true,
)
```

Código após a migração:

```dart highlightLines=2
SemanticsProperties(
  headingLevel: 1,
)
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.45.0-0.1.pre<br>
Na versão estável: 3.47

## Referências {:#references}

Documentação da API:

* [`Semantics`][`Semantics`]
* [`SemanticsProperties`][`SemanticsProperties`]
* [`SemanticsConfiguration`][`SemanticsConfiguration`]

Issues relevantes:

* [Issue 175416][Issue 175416]

PRs relevantes:

* [PR 186916][PR 186916]
* [PR 175416][PR 175416]

[`Semantics`]: {{site.api}}/flutter/widgets/Semantics-class.html
[`SemanticsProperties`]: {{site.api}}/flutter/semantics/SemanticsProperties-class.html
[`SemanticsConfiguration`]: {{site.api}}/flutter/semantics/SemanticsConfiguration-class.html
[Issue 175416]: {{site.repo.flutter}}/issues/175416
[PR 186916]: {{site.repo.flutter}}/pull/186916
[PR 175416]: {{site.repo.flutter}}/pull/175416
