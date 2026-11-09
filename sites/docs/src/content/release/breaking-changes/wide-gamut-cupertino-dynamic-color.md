---
title: Guia de migração para CupertinoDynamicColor de gamut amplo
description: >-
  Abordando descontinuações anteriormente perdidas no CupertinoDynamicColor para
  alinhar com a API Color de gamut amplo.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Certas propriedades e métodos em [`CupertinoDynamicColor`][] foram descontinuados
para alinhar com a classe [`Color`][] devido ao suporte a [wide gamut color spaces][]
adicionado no [Flutter 3.27][Migration guide for wide gamut Color].

## Contexto {:#context}

A classe `Color` foi atualizada para suportar espaços de cores de gamut amplo,
mas algumas descontinuações correspondentes não foram inicialmente aplicadas ao
`CupertinoDynamicColor` devido à sua implementação, e não
devido à extensão de `Color`.

## Descrição da alteração {:#description-of-change}

1.  O campo [`CupertinoDynamicColor.red`][] foi descontinuado em
    favor de [`CupertinoDynamicColor.r`].
1.  O [`CupertinoDynamicColor.green`][] foi descontinuado em
    favor de [`CupertinoDynamicColor.g`].
1.  O [`CupertinoDynamicColor.blue`][] foi descontinuado em
    favor de [`CupertinoDynamicColor.b`].
1.  O [`CupertinoDynamicColor.opacity`][] foi descontinuado em
    favor de [`CupertinoDynamicColor.a`].
1.  O [`CupertinoDynamicColor.withOpacity()`][] foi descontinuado em
    favor de [`CupertinoDynamicColor.withValues()`].


## Guia de migração {:#migration-guide}

### Acessar componentes de cor {:#access-color-components}

Se seu aplicativo acessa um único componente de cor, considere
aproveitar os componentes de ponto flutuante.
A curto prazo, você pode escalar os próprios componentes.

```dart
int _floatToInt8(double x) {
  return (x * 255.0).round().clamp(0, 255);
}

const CupertinoDynamicColor color = CupertinoColors.systemBlue;
final intRed = _floatToInt8(color.r);
final intGreen = _floatToInt8(color.g);
final intBlue = _floatToInt8(color.b);
```

### Opacidade {:#opacity}

Antes do Flutter 3.27, `Color` tinha o conceito de "opacity", que
aparecia nos métodos `opacity` e `withOpacity()`.
Desde o Flutter 3.27, o canal alfa é armazenado como um valor de ponto flutuante.
Usar `.a` e `.withValues()` fornecerá a expressão completa de
um valor de ponto flutuante e não será quantizado (restrito a um intervalo limitado).
Isso significa que "alpha" expressa a intenção de "opacity" de forma mais correta.

#### Migrar `opacity` {:#migrate-opacity}

```dart
// Before: Access the alpha channel as a (converted) floating-point value.
final x = color.opacity;

// After: Access the alpha channel directly.
final x = color.a;
```

#### Migrar `withOpacity` {:#migrate-withopacity}

```dart
// Before: Create a new color with the specified opacity.
final x = color.withOpacity(0.5);

// After: Create a new color with the specified alpha channel value,
// accounting for the current or specified color space.
final x = color.withValues(alpha: 0.5);
```

## Linha do tempo {:#timeline}

Disponibilizado na versão: 3.36.0-0.1.pre<br>
Versão estável: 3.38

## Referências {:#references}

Guias relevantes:

* [Migration guide for wide gamut Color][]

Issues relevantes:

* [Implement wide gamut color support in the Framework][]
* [CupertinoDynamicColor is missing deprecation notices][]

PRs relevantes:

* [Add missing deprecations to CupertinoDynamicColor][]

[`Color`]: {{site.api}}/flutter/dart-ui/Color-class.html
[`CupertinoDynamicColor`]: {{site.cupertino_ui}}/CupertinoDynamicColor-class.html
[wide gamut color spaces]: https://en.wikipedia.org/wiki/RGB_color_spaces
[`CupertinoDynamicColor.red`]: {{site.cupertino_ui}}/CupertinoDynamicColor/red.html
[`CupertinoDynamicColor.r`]: {{site.cupertino_ui}}/CupertinoDynamicColor/r.html
[`CupertinoDynamicColor.green`]: {{site.cupertino_ui}}/CupertinoDynamicColor/green.html
[`CupertinoDynamicColor.g`]: {{site.cupertino_ui}}/CupertinoDynamicColor/g.html
[`CupertinoDynamicColor.blue`]: {{site.cupertino_ui}}/CupertinoDynamicColor/blue.html
[`CupertinoDynamicColor.b`]: {{site.cupertino_ui}}/CupertinoDynamicColor/b.html
[`CupertinoDynamicColor.opacity`]: {{site.cupertino_ui}}/CupertinoDynamicColor/opacity.html
[`CupertinoDynamicColor.a`]: {{site.cupertino_ui}}/CupertinoDynamicColor/a.html
[`CupertinoDynamicColor.withOpacity()`]: {{site.cupertino_ui}}/CupertinoDynamicColor/withOpacity.html
[`CupertinoDynamicColor.withValues()`]: {{site.cupertino_ui}}/CupertinoDynamicColor/withValues.html
[Migration guide for wide gamut Color]: /release/breaking-changes/wide-gamut-framework
[Implement wide gamut color support in the Framework]: {{site.repo.flutter}}/issues/127855
[CupertinoDynamicColor is missing deprecation notices]: {{site.repo.flutter}}/issues/171059
[Add missing deprecations to CupertinoDynamicColor]: {{site.repo.flutter}}/pull/171160
