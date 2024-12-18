---
ia-translate: true
title: Ordem de percurso de acessibilidade do tooltip alterada
description: >-
  A mensagem do widget Tooltip agora segue imediatamente o
  child do widget Tooltip durante o percurso de acessibilidade.
---

## Resumo

Durante o percurso de foco de acessibilidade, `Tooltip.message` é
visitado imediatamente após `Tooltip.child`.

## Contexto

O widget `Tooltip` geralmente envolve um componente de UI interativo, como um botão,
e mostra uma mensagem de ajuda quando pressionado longamente.
Quando a mensagem está visível, as tecnologias assistivas devem anunciá-la após
o botão.

O widget `Tooltip` originalmente colocava `Tooltip.message` em
um `OverlayEntry` quando pressionado longamente.
Como resultado, `Tooltip.message` não estava imediatamente após
`Tooltip.child` na árvore semântica.

## Guia de migração

Essa mudança moveu a mensagem do tooltip na árvore semântica.
Você pode ver falhas de testes de acessibilidade se
seus testes esperam que uma mensagem de tooltip apareça em uma
localização específica na árvore semântica, quando ela está visível.
Atualize quaisquer testes de acessibilidade com falha para adotar a nova ordem semântica do tooltip.

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

Quando a mensagem do tooltip está visível, a árvore semântica correspondente antes
dessa mudança deveria se parecer com isto:

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

Após essa mudança, a mesma árvore de widgets gera uma
árvore semântica ligeiramente diferente, conforme mostrado abaixo.
O nó #6 torna-se um filho do nó #3, em vez do nó #0.

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

## Linha do tempo

Implementado na versão: 3.16.0-11.0.pre<br>
Na versão estável: 3.19.0

## Referências

Documentação da API:

* [`Tooltip`][]

PRs relevantes:

* [OverlayPortal.overlayChild contributes semantics to OverlayPortal instead of Overlay][]

[`Tooltip`]: {{site.api}}/flutter/material/Tooltip-class.html
[OverlayPortal.overlayChild contributes semantics to OverlayPortal instead of Overlay]: {{site.repo.flutter}}/pull/134921
