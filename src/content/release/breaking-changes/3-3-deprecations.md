---
ia-translate: true
title: API Depreciadas Removidas Após a v3.3
description: >
  Após atingir o fim da vida útil, as seguintes APIs depreciadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Política de Depreciação][] do Flutter,
APIs depreciadas que atingiram o fim da vida útil após o
lançamento da versão 3.3 estável foram removidas.

Todas as APIs afetadas foram compiladas nesta fonte
primária para auxiliar na migração. Uma
[folha de referência rápida][] também está disponível.

[Política de Depreciação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-3-3

## Mudanças

Esta seção lista as depreciações, listadas pela classe afetada.

### `RenderUnconstrainedBox`

Suportado pelo Flutter Fix: não

`RenderUnconstrainedBox` foi depreciado na v2.1.
Use `RenderConstraintsTransformBox` em vez disso.

Onde não há restrição em ambos os eixos, forneça `ConstraintsTransformBox.unconstrained`
para `constraintsTransform`.

Se `RenderUnconstrainedBox.constrainedAxis` foi definido anteriormente,
substitua respectivamente:

- Onde `constrainedAxis` era anteriormente `Axis.horizontal`, defina
  `constraintsTransform` para `ConstraintsTransformBox.widthUnconstrained`.
- Onde `constrainedAxis` era anteriormente `Axis.vertical`, defina
  `constraintsTransform` para `ConstraintsTransformBox.heightUnconstrained`.

Essa mudança permitiu a introdução de vários outros tipos de transformação de
restrição por meio de `ConstraintsTransformBox`. Outros parâmetros da antiga
API são compatíveis com a nova API.

**Guia de migração**

Código antes da migração:

```dart
// Sem restrições
final RenderUnconstrainedBox unconstrained = RenderUnconstrainedBox(
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(height: 200.0),
  ),
  alignment: Alignment.center,
);

// Com restrição no eixo horizontal
final RenderUnconstrainedBox unconstrained = RenderUnconstrainedBox(
  constrainedAxis: Axis.horizontal,
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(width: 200.0, height: 200.0),
  ),
  alignment: Alignment.center,
);

// Com restrição no eixo vertical
final RenderUnconstrainedBox unconstrained = RenderUnconstrainedBox(
  constrainedAxis: Axis.vertical,
  textDirection: TextDirection.ltr,
  child: RenderFlex(
    direction: Axis.vertical,
    textDirection: TextDirection.ltr,
    children: <RenderBox>[flexible],
  ),
  alignment: Alignment.center,
);
```

Código após a migração:

```dart
// Sem restrições
final RenderConstraintsTransformBox unconstrained = RenderConstraintsTransformBox(
  constraintsTransform: ConstraintsTransformBox.unconstrained,
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(height: 200.0),
  ),
  alignment: Alignment.center,
);

// Com restrição no eixo horizontal
final RenderConstraintsTransformBox unconstrained = RenderConstraintsTransformBox(
  constraintsTransform: ConstraintsTransformBox.widthUnconstrained,
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(width: 200.0, height: 200.0),
  ),
  alignment: Alignment.center,
);

// Com restrição no eixo vertical
final RenderConstraintsTransformBox unconstrained = RenderConstraintsTransformBox(
  constraintsTransform: ConstraintsTransformBox.widthUnconstrained,
  textDirection: TextDirection.ltr,
  child: RenderFlex(
    direction: Axis.vertical,
    textDirection: TextDirection.ltr,
    children: <RenderBox>[flexible],
  ),
  alignment: Alignment.center,
);
```

**Referências**

Documentação da API:

* [`RenderConstraintsTransformBox`][]
* [`ConstraintsTransformBox`][]

PRs relevantes:

* Depreciado em [#78673][]
* Removido em [#111711][]

[`RenderConstraintsTransformBox`]: {{site.api}}/flutter/rendering/RenderConstraintsTransformBox-class.html
[`ConstraintsTransformBox`]: {{site.api}}/flutter/widgets/ConstraintsTransformBox-class.html
[#78673]: {{site.repo.flutter}}/pull/78673
[#111711]: {{site.repo.flutter}}/pull/111711

---

### `DragAnchor`, `Draggable.dragAnchor` e `LongPressDraggable.dragAnchor`

Suportado pelo Flutter Fix: sim

O enum `DragAnchor`, e seus usos em `Draggable.dragAnchor` e
`LongPressDraggable.dragAnchor` foram depreciados na v2.1.
Use `dragAnchorStrategy` em vez disso.

Essa mudança permitiu um feedback mais preciso do widget arrastável quando usado
em conjunto com outros widgets como `Stack` e `InteractiveViewer`.

**Guia de migração**

Código antes da migração:

```dart
Draggable draggable = Draggable();
draggable = Draggable(dragAnchor: DragAnchor.child);
draggable = Draggable(dragAnchor: DragAnchor.pointer);

LongPressDraggable longPressDraggable = LongPressDraggable();
longPressDraggable = LongPressDraggable(dragAnchor: DragAnchor.child);
longPressDraggable = LongPressDraggable(dragAnchor: DragAnchor.pointer);
```

Código após a migração:

```dart
Draggable draggable = Draggable();
draggable = Draggable(dragAnchorStrategy: childDragAnchorStrategy);
draggable = Draggable(dragAnchorStrategy: pointerDragAnchorStrategy);

LongPressDraggable longPressDraggable = LongPressDraggable();
longPressDraggable = LongPressDraggable(dragAnchorStrategy: childDragAnchorStrategy);
longPressDraggable = LongPressDraggable(dragAnchorStrategy: pointerDragAnchorStrategy);
```

**Referências**

Documentação da API:

* [`Draggable`][]
* [`LongPressDraggable`][]
* [`DragAnchorStrategy`][]

Issues relevantes:

* [#73143][]

PRs relevantes:

* Depreciado em [#79160][]
* Removido em [#111713][]

[`Draggable`]: {{site.api}}/flutter/widgets/Draggable-class.html
[`LongPressDraggable`]: {{site.api}}/flutter/widgets/LongPressDraggable-class.html
[`DragAnchorStrategy`]: {{site.api}}/flutter/widgets/DragAnchorStrategy.html
[#73143]: {{site.repo.flutter}}/pull/73143
[#79160]: {{site.repo.flutter}}/pull/79160
[#111713]: {{site.repo.flutter}}/pull/111713

---

### `ScrollBehavior.buildViewportChrome`

Suportado pelo Flutter Fix: sim

O método `ScrollBehavior.buildViewportChrome` foi depreciado na v2.1.

Este método foi usado pelo widget `Scrollable` para aplicar um indicador de
overscroll, como `GlowingOverscrollIndicator`, por padrão nas plataformas
apropriadas. À medida que mais decoradores padrão foram adicionados, como
`Scrollbar`s, cada um foi dividido em métodos individuais para substituir
`buildViewportChrome`.

Isso permite que classes de extensão substituam apenas o decorador específico,
por meio de `buildScrollbar` ou `buildOverscrollIndicator`, em vez de precisar
reescrever o código para manter um ou outro.

**Guia de migração**

[Guia de migração detalhado disponível][]

Código antes da migração:

```dart
final ScrollBehavior scrollBehavior = ScrollBehavior();
scrollBehavior.buildViewportChrome(context, child, axisDirection);
```

Código após a migração:

```dart
final ScrollBehavior scrollBehavior = ScrollBehavior();
scrollBehavior.buildOverscrollIndicator(context, child, axisDirection);
```

**Referências**

Documento de design:

* [Expondo e Atualizando ScrollBehaviors][]

Documentação da API:

* [`ScrollBehavior`][]

Issues relevantes:

* [As barras de rolagem devem estar sempre visíveis e instanciadas por padrão na web e no desktop][]

PRs relevantes:

* [#76739][]
* Depreciado em [#78588][]
* Removido em [#111715][]

[Guia de migração detalhado disponível]: /release/breaking-changes/default-desktop-scrollbars
[Expondo e Atualizando ScrollBehaviors]: /go/exposing-scroll-behaviors
[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[As barras de rolagem devem estar sempre visíveis e instanciadas por padrão na web e no desktop]: {{site.repo.flutter}}/issues/40107
[#76739]: {{site.repo.flutter}}/pull/76739
[#78588]: {{site.repo.flutter}}/pull/78588
[#111715]: {{site.repo.flutter}}/pull/111715

---

## Linha do tempo

Na versão estável: 3.7
