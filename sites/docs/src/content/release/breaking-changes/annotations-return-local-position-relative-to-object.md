---
title: AnnotatedRegionLayers retornam posição local relativa à região de clipping
description: >
  Fornecer buscas de anotação com posições locais confiáveis e significativas.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

A posição local retornada por `AnnotatedRegionLayers` em uma
busca de anotação foi alterada para ser relativa à região de clipping
ao invés da layer. Isso torna a posição local mais
significativa e confiável, mas quebra código que diretamente executa
buscas de anotação e usa a posição local.

## Context

Anotações são metadados que são atribuídos durante a
fase de renderização para regiões na tela.
Buscar as anotações com uma localização fornece a
informação contextual que contém essa localização.
Elas são usadas para detectar eventos do mouse e o tema de app bars.

Quando `localPosition` foi adicionado pela primeira vez ao resultado da busca,
foi definido como relativo à layer que possuía a anotação,
o que se revelou um erro de design.
O offset da layer é sem significado e não confiável.
Por exemplo, um widget `Transform` desenha na mesma layer
com um offset se a matriz de transformação é uma tradução simples,
ou empurra uma `TransformLayer` dedicada se a matriz não é trivial.
O primeiro caso mantém a origem de coordenadas anterior
(por exemplo, o canto superior esquerdo da aplicação),
enquanto o segundo caso move a origem da posição já que
está em uma nova layer. Os dois casos podem não produzir
diferenças visuais notáveis, já que a layer extra pode ser apenas uma escala de
99%, apesar de que a busca de anotação retorna resultados diferentes.
Para tornar esta posição local confiável, temos que escolher
um dos resultados para seguir.

## Description of change

A `localPosition` retornada por uma `AnnotatedRegionLayer`
agora é a posição local que recebeu subtraída por `offset`,
onde `offset` é a localização da área de clipping relativa
à layer.

```dart
class AnnotatedRegionLayer<T> extends ContainerLayer {
  @override
  bool findAnnotations<S>(AnnotationResult<S> result, Offset localPosition, { required bool onlyFirst }) {
    ...
    if (/* shouldAddAnnotation */) {
      result.add(AnnotationEntry<S>(
        annotation: typedValue,
        // Used to be:
        // localPosition: localPosition,
        localPosition: localPosition - offset,
      ));
    }
    ...
  }
}
```

Conceitualmente, isso mudou como `AnnotatedRegionLayer.offset`
e `size` são definidos. Eles costumavam significar
"o retângulo de clipping que restringe a busca de anotação",
enquanto agora representam conjuntamente
"a região do objeto de anotação".

## Migration guide

Código que está ativamente usando esta posição local provavelmente está
interagindo diretamente com layers, já que usar render objects ou
widgets já tornaram este resultado não confiável. Para
preservar o comportamento anterior, você pode reimplementar
`AnnotatedRegionLayer` para retornar uma posição local sem
subtrair o offset.

## Timeline

Landed in version: 1.15.2<br>
In stable release: 1.17

## References

API documentation:

* [`AnnotatedRegionLayer`][]
* [`AnnotationEntry`][]

Relevant issues:

* [Issue #49568][]

Relevant PR:

* [Make Annotation's localPosition relative to object][]

[`AnnotatedRegionLayer`]: {{site.api}}/flutter/rendering/AnnotatedRegionLayer-class.html
[`AnnotationEntry`]: {{site.api}}/flutter/rendering/AnnotationEntry-class.html
[Issue #49568]: {{site.repo.flutter}}/issues/49568
[Make Annotation's localPosition relative to object]: {{site.repo.flutter}}/pull/50157
