---
ia-translate: true
title: AnnotatedRegionLayers retornam a posição local relativa à região de recorte
description: >
  Fornece buscas de anotação com posições locais confiáveis e significativas.
---

## Sumário

A posição local retornada por `AnnotatedRegionLayers` em uma
busca de anotação foi alterada para ser relativa à região de recorte,
em vez da camada. Isso torna a posição local mais
significativa e confiável, mas quebra o código que realiza diretamente
buscas de anotação e usa a posição local.

## Contexto

Anotações são metadados que são atribuídos durante a
fase de renderização para regiões na tela.
Buscar as anotações com uma localização fornece a
informação contextual que contém essa localização.
Elas são usadas para detectar eventos de mouse e o tema de barras de app.

Quando `localPosition` foi adicionado pela primeira vez ao resultado da busca,
ele foi definido como relativo à camada que possuía a anotação,
o que acabou sendo um erro de design.
O deslocamento da camada não tem significado e é não confiável.
Por exemplo, um widget `Transform` desenha na mesma camada
com um deslocamento se a matriz de transformação for uma tradução simples,
ou envia um `TransformLayer` dedicado se a matriz for não trivial.
O primeiro caso mantém a origem da coordenada anterior
(por exemplo, o canto superior esquerdo do aplicativo),
enquanto o último caso move a origem da posição, já que
está em uma nova camada. Os dois casos podem não produzir diferenças
visuais perceptíveis, já que a camada extra pode ser apenas uma escala de
99%, apesar de que a busca de anotação retorna resultados diferentes.
Para tornar essa posição local confiável, temos que escolher
um dos resultados para aderir.

## Descrição da mudança

O `localPosition` retornado por um `AnnotatedRegionLayer`
é agora a posição local que ele recebeu subtraída por `offset`,
onde `offset` é a localização da área de recorte relativa
à camada.

```dart
class AnnotatedRegionLayer<T> extends ContainerLayer {
  @override
  bool findAnnotations<S>(AnnotationResult<S> result, Offset localPosition, { required bool onlyFirst }) {
    ...
    if (/* shouldAddAnnotation */) {
      result.add(AnnotationEntry<S>(
        annotation: typedValue,
        // Costumava ser:
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
"o retângulo de recorte que restringe a busca de anotação",
enquanto agora eles representam em conjunto
"a região do objeto de anotação".

## Guia de migração

O código que está usando ativamente essa posição local provavelmente
está interagindo diretamente com as camadas, já que o uso de objetos de renderização ou
widgets já tornou esse resultado não confiável. Para
preservar o comportamento anterior, você pode reimplementar
`AnnotatedRegionLayer` para retornar uma posição local sem
subtrair o offset.

## Cronologia

Implementado na versão: 1.15.2<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`AnnotatedRegionLayer`][]
* [`AnnotationEntry`][]

Issues relevantes:

* [Issue #49568][]

PR relevante:

* [Make Annotation's localPosition relative to object][]

[`AnnotatedRegionLayer`]: {{site.api}}/flutter/rendering/AnnotatedRegionLayer-class.html
[`AnnotationEntry`]: {{site.api}}/flutter/rendering/AnnotationEntry-class.html
[Issue #49568]: {{site.repo.flutter}}/issues/49568
[Make Annotation's localPosition relative to object]: {{site.repo.flutter}}/pull/50157
