---
ia-translate: true
title: Ordem de travessia de acessibilidade do tooltip alterada
description: >-
  A mensagem do widget Tooltip agora aparece imediatamente após o
  filho do widget Tooltip durante a travessia de acessibilidade.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Durante a travessia de foco de acessibilidade, `Tooltip.message` é
visitado imediatamente após `Tooltip.child`.

## Contexto

O widget `Tooltip` geralmente envolve um componente de UI interativo, como um botão,
e exibe uma mensagem de ajuda quando pressionado longamente.
Quando a mensagem está visível, as tecnologias assistivas devem anunciá-la após
o botão.

O widget `Tooltip` originalmente colocava `Tooltip.message` em
um `OverlayEntry` quando pressionado longamente.
Como resultado, `Tooltip.message` não ficava imediatamente após
`Tooltip.child` na árvore de semântica.

## Guia de migração

Esta mudança moveu a mensagem do tooltip na árvore de semântica.
Você pode ver falhas em testes de acessibilidade se
seus testes esperam que uma mensagem de tooltip apareça em uma
localização específica na árvore de semântica, quando ela está visível.
Atualize quaisquer testes de acessibilidade com falhas para adotar a nova ordem de semântica do tooltip.

Por exemplo, se você construiu a seguinte árvore de widgets em seu teste:

```dart
Directionality(
  textDirection: TextDirection.ltr,
  child: Overlay(
    initialEntries: <OverlayEntry>[
      OverlayEntry(
        builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              const Text('before'),
              Tooltip(
                key: tooltipKey,
                showDuration: const Duration(days: 365),
                message: 'message',
                child: const Text('child'),
              ),
              const Text('after'),
            ],
          );
        },
      ),
    ],
  ),
);
```

Quando a mensagem do tooltip está visível, a árvore de semântica correspondente antes
desta mudança deveria se parecer com isto:

```dart
SemanticsNode#0
 │
 ├─SemanticsNode#1
 │ │
 │ └─SemanticsNode#5
 │   │ flags: hasImplicitScrolling
 │   │ scrollChildren: 3
 │   │
 │   ├─SemanticsNode#2
 │   │   tags: RenderViewport.twoPane
 │   │   label: "before"
 │   │   textDirection: ltr
 │   │
 │   ├─SemanticsNode#3
 │   │   tags: RenderViewport.twoPane
 │   │   label: "child"
 │   │   tooltip: "message"
 │   │   textDirection: ltr
 │   │
 │   └─SemanticsNode#4
 │       tags: RenderViewport.twoPane
 │       label: "after"
 │       textDirection: ltr
 │
 └─SemanticsNode#6
     label: "message"
     textDirection: ltr
```

Após esta mudança, a mesma árvore de widgets gera uma
árvore de semântica ligeiramente diferente, conforme mostrado abaixo.
O nó #6 se torna um filho do nó #3, em vez do nó #0.

```dart
SemanticsNode#0
 │
 └─SemanticsNode#1
   │
   └─SemanticsNode#5
     │ flags: hasImplicitScrolling
     │ scrollChildren: 3
     │
     ├─SemanticsNode#2
     │   tags: RenderViewport.twoPane
     │   label: "before"
     │   textDirection: ltr
     │
     ├─SemanticsNode#3
     │ │ tags: RenderViewport.twoPane
     │ │ label: "child"
     │ │ tooltip: "message"
     │ │ textDirection: ltr
     │ │
     │ └─SemanticsNode#6
     │     label: "message"
     │     textDirection: ltr
     │
     └─SemanticsNode#4
         tags: RenderViewport.twoPane
         label: "after"
         textDirection: ltr
```

## Cronograma

Implementado na versão: 3.16.0-11.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API:

* [`Tooltip`][`Tooltip`]

PRs relevantes:

* [OverlayPortal.overlayChild contributes semantics to OverlayPortal instead of Overlay][OverlayPortal.overlayChild contributes semantics to OverlayPortal instead of Overlay]

[`Tooltip`]: {{site.api}}/flutter/material/Tooltip-class.html
[OverlayPortal.overlayChild contributes semantics to OverlayPortal instead of Overlay]: {{site.repo.flutter}}/pull/134921
