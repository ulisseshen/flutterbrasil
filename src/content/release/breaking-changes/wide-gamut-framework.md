---
title: Guia de migração para Color de gama ampla
description: >-
  Alterações para suportar cor de gama ampla e instruções de migração.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A API para a classe [`Color`][] em `dart:ui` está mudando para
suportar [wide gamut color spaces][].

## Context

O engine do Flutter [already supports wide gamut color][] com [Impeller][], e
o suporte agora está sendo adicionado [to the framework][].

Os dispositivos iOS que o Flutter suporta renderizam em uma gama maior de cores,
especificamente no espaço de cores [DisplayP3][].
Após esta alteração, o framework Flutter pode
renderizar todas essas cores no iOS Impeller, e
a classe `Color` está melhor preparada para futuros espaços de cores ou
alterações na profundidade de bits dos componentes de cor.

## Description of change

Alterações em [`Color`][]:

 1. Adiciona um campo enum que especifica seu [`ColorSpace`][].
 1. Adiciona API para usar componentes de cor de ponto flutuante normalizados.
 1. Remove API que usa componentes de cor inteiros sem sinal de 8 bits que podem
    levar à perda de dados.

Alterações em [`ColorSpace`][]:

 1. Adiciona uma propriedade `displayP3`.

## Migration guide

### 8-bit unsigned integer constructors

Construtores como `Color.fromARGB` permanecem inalterados e têm suporte contínuo.
Para aproveitar as cores Display P3, você deve usar o novo
construtor `Color.from` que recebe componentes de cor de ponto flutuante normalizados.

```dart
// Before: Constructing an sRGB color from the lower 8 bits of four integers.
final magenta = Color.fromARGB(0xff, 0xff, 0x0, 0xff);

// After: Constructing a color with normalized floating-point components.
final magenta = Color.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 1.0);
```

### Implementors of `Color`

Há novos métodos sendo adicionados a `Color`, então
qualquer classe que `implements Color` vai quebrar e terá que
implementar os novos métodos, como `Color.a` e `Color.b`.

Em última análise, os implementadores devem migrar para aproveitar a nova API.
No curto prazo, esses métodos podem ser facilmente implementados sem
alterar a estrutura subjacente da sua classe.

Por exemplo:

```dart
class Foo implements Color {
  int _red;

  @override
  double get r => _red / 255.0;
}
```

:::note
O Flutter planeja eventualmente bloquear a classe `Color` e torná-la `sealed`.

Agora pode ser uma boa oportunidade para mudar de [inheritance to composition][]
e parar de reimplementar `Color`.
:::

### Color space support

Clientes que usam `Color` e realizam qualquer tipo de cálculo nos
componentes de cor agora devem primeiro verificar o
componente de espaço de cor antes de realizar cálculos.
Para ajudar com isso, você pode usar o novo método `Color.withValues` para
realizar conversões de espaço de cores.

Exemplo de migração:

```dart
// Before
double redRatio(Color x, Color y) => x.red / y.red;

// After
double redRatio(Color x, Color y) {
  final xPrime = x.withValues(colorSpace: ColorSpace.extendedSRGB);
  final yPrime = y.withValues(colorSpace: ColorSpace.extendedSRGB);
  return xPrime.r / yPrime.r;
}
```

Realizar cálculos com componentes de cor sem
alinhar espaços de cores pode levar a resultados sutis inesperados.
No exemplo anterior, o `redRatio` teria a diferença de `0.09`
quando calculado com espaços de cores diferentes versus espaços de cores alinhados.

### Access color components

Se seu app acessa um componente `Color`, considere
aproveitar os componentes de ponto flutuante.
No curto prazo, você pode escalar os componentes.

```dart
extension IntColorComponents on Color {
  int get intAlpha => _floatToInt8(this.a);
  int get intRed => _floatToInt8(this.r);
  int get intGreen => _floatToInt8(this.g);
  int get intBlue => _floatToInt8(this.b);

  int _floatToInt8(double x) {
    return (x * 255.0).round() & 0xff;
  }
}
```

### Opacity

Antes do Flutter 3.27, Color tinha o conceito de "opacity" que aparecia nos
métodos `opacity` e `withOpacity()`. Opacity foi introduzida como uma forma de
comunicar com `Color` sobre seu canal alpha com valores de ponto flutuante
([0.0, 1.0]). Os métodos de opacity eram métodos de conveniência para definir o valor
alpha de 8 bits ([0, 255]), mas nunca ofereceram a expressão completa de um
número de ponto flutuante. Isso era suficiente quando os componentes de cor eram armazenados como
inteiros de 8 bits.

Desde o Flutter 3.27, alpha é armazenado como um valor de ponto flutuante. Usar `.a` e
`.withValues()` dará a expressão completa de um valor de ponto flutuante e
não será quantizado (restrito a uma faixa limitada). Isso significa que "alpha" expressa
a intenção de "opacity" de forma mais correta. Opacity é diferente de uma forma sutil
onde seu uso pode resultar em perda de dados inesperada, então `.withOpacity()` e
`.opacity` foram descontinuados e suas semânticas foram mantidas para
evitar quebrar ninguém.

Por exemplo:

```dart
// Prints 0.5019607843137255.
print(Colors.black.withOpacity(0.5).a);
// Prints 0.5.
print(Colors.black.withValues(alpha: 0.5).a);
```

Praticamente todos os usos se beneficiarão diretamente das cores mais precisas. No
caso raro onde não se beneficia, pode-se tomar cuidado para quantizar a opacity para [0,
255] usando `.alpha` e `.withAlpha()` para corresponder ao comportamento antes do Flutter
3.27.

<a id="opacity-migration" aria-hidden="true"></a>
#### Migrate `opacity`

```dart
// Before: Access the alpha channel as a (converted) floating-point value.
final x = color.opacity;

// After: Access the alpha channel directly.
final x = color.a;
```

<a id="withopacity-migration" aria-hidden="true"></a>
#### Migrate `withOpacity`

```dart
// Before: Create a new color with the specified opacity.
final x = color.withOpacity(0.0);

// After: Create a new color with the specified alpha channel value,
// accounting for the current or specified color space.
final x = color.withValues(alpha: 0.0);
```

### Equality

Uma vez que `Color` armazena seus componentes de cor como números de ponto flutuante,
a igualdade funciona de forma um pouco diferente.
Ao calcular cores, pode haver uma
pequena diferença nos valores que poderiam ser considerados iguais.
Para acomodar isso, use os matchers [`closeTo`][] ou [`isColorSameAs`][].

```dart
// Before: Check exact equality of int-based color.
expect(calculateColor(), const Color(0xffff00ff));

// After: Check rough equality of floating-point-based color.
expect(calculateColor(), isSameColorAs(const Color(0xffff00ff)));
```

## Timeline

### Phase 1 - New API introduction, old API deprecation

Landed in version: 3.26.0-0.1.pre<br>
In stable release: 3.27.0

### Phase 2 - Old API removal

Landed in version: Not yet<br>
In stable release: Not yet

## References

Relevant issue:

* [issue 127855][]: Implement wide gamut color support in the Framework

Relevant PRs:

* [PR 54737][]: Framework wide color

[`Color`]: {{site.api}}/flutter/dart-ui/Color-class.html
[already supports wide gamut color]: {{site.repo.flutter}}/issues/55092
[to the framework]: {{site.repo.flutter}}/issues/127855
[issue 127855]: {{site.repo.flutter}}/issues/127855
[`ColorSpace`]: {{site.api}}/flutter/dart-ui/ColorSpace.html
[PR 54737]: {{site.repo.engine}}/pull/54737
[DisplayP3]: https://en.wikipedia.org/wiki/DCI-P3
[Impeller]: {{site.api}}/perf/impeller
[wide gamut color spaces]: https://en.wikipedia.org/wiki/RGB_color_spaces
[inheritance to composition]: https://en.wikipedia.org/wiki/Composition_over_inheritance
[`closeTo`]: {{site.api}}/documentation/matcher/latest/matcher/closeTo.html
[`isColorSameAs`]: {{site.api}}/flutter/flutter_test/isSameColorAs.html
