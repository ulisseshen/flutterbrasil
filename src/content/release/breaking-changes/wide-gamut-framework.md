---
ia-translate: true
title: Guia de Migração para Cores de Ampla Gama
description: >-
  Alterações para suportar cores de ampla gama e instruções de migração.
---

## Sumário

A API para a classe [`Color`][] em `dart:ui` está mudando para suportar [espaços de
cores de ampla gama][].

## Contexto

O engine do Flutter [já suporta cores de ampla gama][] com [Impeller][], e o
suporte está agora sendo adicionado [ao framework][].

Os dispositivos iOS que o Flutter suporta renderizam para um array maior de cores,
especificamente no espaço de cores [DisplayP3][]. Após esta mudança, o framework do
Flutter pode renderizar todas essas cores no iOS Impeller, e a classe `Color`
estará melhor preparada para futuros espaços de cores ou mudanças na profundidade
de bits do componente de cor.

## Descrição da Mudança

Mudanças em [`Color`][]:

 1. Adiciona um campo enum que especifica seu [`ColorSpace`][].
 1. Adiciona API para usar componentes de cor de ponto flutuante normalizados.
 1. Remove a API que usa componentes de cor inteiros não assinados de 8 bits que
    podem levar à perda de dados.

Mudanças em [`ColorSpace`][]:

 1. Adiciona uma propriedade `displayP3`.

## Guia de Migração

### Construtores de inteiro não assinado de 8 bits

Construtores como `Color.fromARGB` permanecem inalterados e têm suporte contínuo.
Para aproveitar as cores Display P3, você deve usar o novo construtor `Color.from`
que aceita componentes de cor de ponto flutuante normalizados.

```dart
// Antes
final magenta = Color.fromARGB(0xff, 0xff, 0x0, 0xff);
// Depois
final magenta = Color.from(alpha: 1.0, red: 1.0, green: 0.0, blue: 1.0)
```

### Implementadores de `Color`

Há novos métodos sendo adicionados a `Color`, então qualquer classe que `implements`
Color quebrará e terá que implementar os novos métodos como `Color.a`, e
`Color.b`. Em última análise, os implementadores devem ser migrados para aproveitar
a nova API. No curto prazo, esses métodos podem ser facilmente implementados sem
alterar a estrutura subjacente de sua classe.

Por exemplo:

```dart
class Foo implements Color {
  int _red;

  @override
  double get r => _red * 255.0;
}
```

:::note
Planejamos eventualmente bloquear a classe `Color` e torná-la `sealed`. Agora
pode ser uma boa oportunidade para mudar de [herança para composição][] e
parar de reimplementar `Color`.
:::

### Suporte a espaço de cores

Clientes que usam `Color` e realizam qualquer tipo de cálculo nos componentes de cor
agora devem primeiro verificar o componente de espaço de cores antes de realizar
cálculos. Para ajudar com isso, você pode usar o novo método `Color.withValues`
para realizar conversões de espaço de cores.

Exemplo de migração:

```dart
// Antes
double redRatio(Color x, Color y) => x.red / y.red;

// Depois
double redRatio(Color x, Color y) {
  final xPrime = x.withValues(colorSpace: ColorSpace.extendedSRGB);
  final yPrime = y.withValues(colorSpace: ColorSpace.extendedSRGB);
  return xPrime.r / yPrime.r;
}
```

Realizar cálculos com componentes de cor sem alinhar espaços de cores pode
levar a resultados sutis inesperados. No exemplo acima, o `redRatio` teria
a diferença de 0.09 quando calculado com diferentes espaços de cores versus
espaços de cores alinhados.

### Acessar componentes de cor

Se seu aplicativo alguma vez acessar um componente `Color`, considere aproveitar
os componentes de ponto flutuante. No curto prazo, você pode facilmente
escalar os próprios componentes.

```dart
extension IntColorComponents on Color {
  int get intAlpha => this.a ~/ 255;
  int get intRed => this.r ~/ 255;
  int get intGreen => this.g ~/ 255;
  int get intBlue => this.b ~/ 255;
}
```

### Opacidade

Anteriormente, Color tinha o conceito de "opacidade" que aparecia nos métodos
`opacity` e `withOpacity()`. A opacidade foi introduzida como uma forma de se comunicar
com `Color` sobre seu canal alfa com valores de ponto flutuante. Agora que o alfa
é um valor de ponto flutuante, a opacidade é redundante e `opacity` e `withOpacity`
estão obsoletos e programados para serem removidos.

#### Migração de `opacity`

```dart
// Antes
final x = color.opacity;
// Depois
final x = color.a;
```

#### Migração de `withOpacity`

```dart
// Antes
final x = color.withOpacity(0.0);
// Depois
final x = color.withValues(alpha: 0.0);
```

### Igualdade

Uma vez que `Color` armazena seus componentes de cor como números de ponto flutuante,
a igualdade funciona de forma ligeiramente diferente. Ao calcular cores, pode haver
pequenas diferenças em valores que poderiam ser considerados iguais.
Para acomodar isso, use o matcher [`closeTo`][] ou o matcher [`isColorSameAs`][].

```dart
// Antes
expect(calculateColor(), const Color(0xffff00ff));
// Depois
expect(calculateColor(), isSameColorAs(const Color(0xffff00ff)));
```

## Cronograma

### Fase 1 - Introdução da nova API, depreciação da API antiga

**Lançamento para stable:** A ser definido
**PR:**: [PR 54737][]

### Fase 2 - Remoção da API antiga

**Lançamento para stable:** A ser definido

## Referências

PRs relevantes:

* [issue 127855][]: Implementar suporte a cores de ampla gama no Framework

[`Color`]: {{site.api}}/flutter/dart-ui/Color-class.html
[já suporta cores de ampla gama]: {{site.repo.flutter}}/issues/55092
[ao framework]: {{site.repo.flutter}}/issues/127855
[issue 127855]: {{site.repo.flutter}}/issues/127855
[`ColorSpace`]: {{site.api}}/flutter/dart-ui/ColorSpace.html
[PR 54737]: {{site.repo.engine}}/pull/54737
[DisplayP3]: https://en.wikipedia.org/wiki/DCI-P3
[Impeller]: {{site.api}}/perf/impeller
[espaços de cores de ampla gama]: https://en.wikipedia.org/wiki/RGB_color_spaces
[herança para composição]: https://en.wikipedia.org/wiki/Composition_over_inheritance
[`closeTo`]: {{site.api}}/documentation/matcher/latest/matcher/closeTo.html
[`isColorSameAs`]: {{site.api}}/flutter/flutter_test/isSameColorAs.html

