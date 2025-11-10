---
title: Suporte a dry layout para RenderBox
description: >
  O método "computeDryLayout" foi adicionado ao protocolo RenderBox para
  calcular corretamente seu tamanho intrínseco em certas situações.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Um novo método chamado `computeDryLayout` foi adicionado ao protocolo `RenderBox`.
Subclasses de `RenderBox` devem implementá-lo para relatar corretamente
seu tamanho desejado dado um conjunto de `BoxConstraints` durante cálculos
intrínsecos. Subclasses que implementam `computeDryLayout` não precisam mais
sobrescrever `performResize`.

## Contexto {:#context}

Um novo método, `computeDryLayout`, foi adicionado ao protocolo `RenderBox` para
calcular corretamente os tamanhos intrínsecos de um `RenderParagraph` com
filhos `WidgetSpan` e um `RenderWrap`. O método recebe um conjunto de `BoxConstraints` e
deve calcular o tamanho resultante do `RenderBox` sem alterar
nenhum estado interno. É essencialmente uma execução simulada de `performLayout` que apenas
calcula o tamanho resultante e não posiciona os filhos. O
método `computeDryLayout` faz parte do protocolo de intrínsecos (veja também
[`RenderBox.computeMinIntrinsicWidth`][] e similares).

## Descrição da mudança {:#description-of-change}

Subclasses de `RenderBox` precisam sobrescrever o novo método `computeDryLayout`
se forem usadas como descendentes de um `RenderObject` que possa consultar o tamanho
intrínseco de seus filhos. Exemplos de widgets que fazem isso são `IntrinsicHeight`
e `IntrinsicWidth`.

A implementação padrão de `RenderBox.performResize` também usa o tamanho
computado por `computeDryLayout` para realizar o redimensionamento. Sobrescrever `performResize`
não é mais necessário, portanto.

## Guia de migração {:#migration-guide}

Subclasses que já sobrescrevem `performResize` podem ser migradas simplesmente
alterando a assinatura da função de `void performResize()` para
`Size computeDryLayout(BoxConstraints constraints)` e retornando o
tamanho calculado em vez de atribuí-lo ao setter `size`. A antiga
implementação de `performResize` pode ser removida.

Código antes da migração:

```dart
  @override
  void performResize() {
     size = constraints.biggest;
  }
```

Código após a migração:

```dart
  // This replaces the old performResize method.
  @override
  Size computeDryLayout(BoxConstraints constraints) {
     return constraints.biggest;
  }
```

Se a subclasse não sobrescreve `performResize`, a implementação de
`computeDryLayout` deve ser extraída do método `performLayout`.
Basicamente, `computeDryLayout` precisa fazer todo o trabalho que `performLayout` faz
para descobrir o tamanho do `RenderBox`. No entanto, em vez de atribuí-lo
ao setter `size`, ele retorna o tamanho computado. Se `computeDryLayout`
precisa saber o tamanho de seus filhos, deve obter esse tamanho chamando
`getDryLayout` no filho em vez de chamar `layout`.

Se por algum motivo for impossível calcular o dry layout, `computeDryLayout`
deve chamar `debugCannotComputeDryLayout` dentro de um assert e retornar um tamanho
fictício de `const Size(0, 0)`. Calcular um dry layout é, por exemplo, impossível
se o tamanho de um `RenderBox` depende das métricas de baseline de seus filhos.

```dart
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason: 'Layout requires baseline metrics, which are only available after a full layout.'
    ));
    return const Size(0, 0);
  }
```

## Cronograma {:#timeline}

Implementado na versão: 1.25.0-4.0.pre<br>
Na versão estável: 2.0.0

## Referências {:#references}

Documentação da API:

* [`RenderBox`][]
* [`computeMinInstrinsicWidth`][]
* [`computeDryLayout`][]
* [`getDryLayout`][]
* [`performResize`][]
* [`RenderWrap`][]
* [`RenderParagraph`][]

Issues relevantes:

* [Issue 48679][]

PRs relevantes:

* [Fixes Intrinsics for RenderParagraph and RenderWrap][]

[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[`RenderBox.computeMinIntrinsicWidth`]: {{site.api}}/flutter/rendering/RenderBox/computeMinIntrinsicWidth.html
[`computeMinInstrinsicWidth`]: {{site.api}}/flutter/rendering/RenderBox/computeMinIntrinsicWidth.html
[`computeDryLayout`]: {{site.api}}/flutter/rendering/RenderBox/computeDryLayout.html
[`getDryLayout`]: {{site.api}}/flutter/rendering/RenderBox/getDryLayout.html
[`performResize`]: {{site.api}}/flutter/rendering/RenderBox/performResize.html
[`RenderWrap`]: {{site.api}}/flutter/rendering/RenderWrap-class.html
[`RenderParagraph`]: {{site.api}}/flutter/rendering/RenderParagraph-class.html

[Issue 48679]: {{site.repo.flutter}}/issues/48679
[Fixes Intrinsics for RenderParagraph and RenderWrap]: {{site.repo.flutter}}/pull/70656
