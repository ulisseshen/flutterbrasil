---
ia-translate: true
title: Suporte a layout "Dry" para RenderBox
description: >
  O método "computeDryLayout" foi adicionado ao protocolo RenderBox para
  calcular corretamente seu tamanho intrínseco em certas situações.
---

## Sumário

Um novo método chamado `computeDryLayout` foi adicionado ao protocolo
`RenderBox`. Espera-se que as subclasses de `RenderBox` o implementem para
relatar corretamente seu tamanho desejado, dado um conjunto de
`BoxConstraints` durante cálculos intrínsecos. Subclasses que implementam
`computeDryLayout` não precisam mais sobrescrever `performResize`.

## Contexto

Um novo método, `computeDryLayout`, foi adicionado ao protocolo `RenderBox`
para calcular corretamente os tamanhos intrínsecos de um `RenderParagraph` com
filhos `WidgetSpan` e um `RenderWrap`. O método recebe um conjunto de
`BoxConstraints` e espera-se que calcule o tamanho resultante do `RenderBox`
sem alterar nenhum estado interno. É essencialmente uma execução "dry" de
`performLayout` que apenas calcula o tamanho resultante e não posiciona os
filhos. O método `computeDryLayout` faz parte do protocolo de intrínsecos (veja
também [`RenderBox.computeMinIntrinsicWidth`][] e similares).

## Descrição da mudança

Subclasses de `RenderBox` precisam sobrescrever o novo método `computeDryLayout`
se forem usadas como descendentes de um `RenderObject` que pode consultar o
tamanho intrínseco de seus filhos. Exemplos de widgets que fazem isso são
`IntrinsicHeight` e `IntrinsicWidth`.

A implementação padrão de `RenderBox.performResize` também usa o tamanho
calculado por `computeDryLayout` para realizar o redimensionamento.
Sobrescrever `performResize` não é mais necessário.

## Guia de migração

Subclasses que já sobrescrevem `performResize` podem ser migradas simplesmente
alterando a assinatura da função de `void performResize()` para
`Size computeDryLayout(BoxConstraints constraints)` e retornando o tamanho
calculado em vez de atribuí-lo ao setter `size`. A antiga implementação de
`performResize` pode ser removida.

Código antes da migração:

```dart
  @override
  void performResize() {
     size = constraints.biggest;
  }
```

Código após a migração:

```dart
  // Isso substitui o antigo método performResize.
  @override
  Size computeDryLayout(BoxConstraints constraints) {
     return constraints.biggest;
  }
```

Se a subclasse não sobrescrever `performResize`, a implementação de
`computeDryLayout` precisa ser extraída do método `performLayout`.
Basicamente, `computeDryLayout` precisa fazer todo o trabalho que `performLayout`
está fazendo para descobrir o tamanho do `RenderBox`. No entanto, em vez de
atribuí-lo ao setter `size`, ele retorna o tamanho calculado. Se
`computeDryLayout` precisar saber o tamanho de seus filhos, ele deve obter
esse tamanho chamando `getDryLayout` no filho em vez de chamar `layout`.

Se, por algum motivo, for impossível calcular o layout "dry",
`computeDryLayout` deve chamar `debugCannotComputeDryLayout` de dentro de um
`assert` e retornar um tamanho dummy de `const Size(0, 0)`. Calcular um layout
"dry" é, por exemplo, impossível se o tamanho de um `RenderBox` depender das
métricas de linha de base de seus filhos.

```dart
  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason: 'O layout requer métricas de linha de base, que só estão disponíveis após um layout completo.'
    ));
    return const Size(0, 0);
  }
```

## Linha do tempo

Incluído na versão: 1.25.0-4.0.pre<br>
Na versão estável: 2.0.0

## Referências

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
