---
title: API depreciada removida após v3.3
description: >
  Após atingir o fim da vida útil, as seguintes APIs depreciadas
  foram removidas do Flutter.
ia-translate: true
---

## Resumo

De acordo com a [Política de Depreciação][Deprecation Policy] do Flutter,
APIs depreciadas que atingiram o fim da vida útil após a
3.3 versão estável foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. A
[folha de referência rápida][quick reference sheet] também está disponível.

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-3

## Mudanças

Esta seção lista as depreciações, organizadas pela classe afetada.

### `RenderUnconstrainedBox`

Suportado pelo Flutter Fix: não

`RenderUnconstrainedBox` foi depreciado na v2.1.
Use `RenderConstraintsTransformBox` no lugar.

Where unconstrained in both axes, provide `ConstraintsTransformBox.unconstrained`
to `constraintsTransform`.

If `RenderUnconstrainedBox.constrainedAxis` was previously set,
replace respectively:

- Where `constrainedAxis` was previously `Axis.horizontal`, set
  `constraintsTransform` to `ConstraintsTransformBox.widthUnconstrained`.
- Where `constrainedAxis` was previously `Axis.vertical`, set
  `constraintsTransform` to `ConstraintsTransformBox.heightUnconstrained`.

This change allowed for the introduction of several more types of constraint
transformations through `ConstraintsTransformBox`. Other parameters of the old
API are compatible with the new API.

**Guia de migração**

Código antes da migração:

```dart
// Unconstrained
final RenderUnconstrainedBox unconstrained = RenderUnconstrainedBox(
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(height: 200.0),
  ),
  alignment: Alignment.center,
);

// Constrained in horizontal axis
final RenderUnconstrainedBox unconstrained = RenderUnconstrainedBox(
  constrainedAxis: Axis.horizontal,
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(width: 200.0, height: 200.0),
  ),
  alignment: Alignment.center,
);

// Constrained in vertical axis
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
// Unconstrained
final RenderConstraintsTransformBox unconstrained = RenderConstraintsTransformBox(
  constraintsTransform: ConstraintsTransformBox.unconstrained,
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(height: 200.0),
  ),
  alignment: Alignment.center,
);

// Constrained in horizontal axis
final RenderConstraintsTransformBox unconstrained = RenderConstraintsTransformBox(
  constraintsTransform: ConstraintsTransformBox.widthUnconstrained,
  textDirection: TextDirection.ltr,
  child: RenderConstrainedBox(
    additionalConstraints: const BoxConstraints.tightFor(width: 200.0, height: 200.0),
  ),
  alignment: Alignment.center,
);

// Constrained in vertical axis
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

### `DragAnchor`, `Draggable.dragAnchor` & `LongPressDraggable.dragAnchor`

Suportado pelo Flutter Fix: sim

The enum `DragAnchor`, and its uses in `Draggable.dragAnchor` &
`LongPressDraggable.dragAnchor` foram depreciados na v2.1.
Use `dragAnchorStrategy` no lugar.

This change allowed for more accurate feedback of the draggable widget when used
in conjunction with other widgets like `Stack` and `InteractiveViewer`.

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

The method `ScrollBehavior.buildViewportChrome` foi depreciado na v2.1.

This method was used by the `Scrollable` widget to apply an overscroll
indicator, like `GlowingOverscrollIndicator`, by default on the appropriate
platforms. As more default decorators have been added, like `Scrollbar`s, each
has instead been split into individual methods to replace `buildViewportChrome`.

This allows extending classes to only override the specific decorator, through
`buildScrollbar` or `buildOverscrollIndicator`, rather than needing to rewrite
code in order to maintain one or the other.

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

* [Exposing & Updating ScrollBehaviors][]

Documentação da API:

* [`ScrollBehavior`][]

Issues relevantes:

* [Scrollbars should be always visible and instantiated by default on web and desktop][]

PRs relevantes:

* [#76739][]
* Depreciado em [#78588][]
* Removido em [#111715][]

[Guia de migração detalhado disponível]: /release/breaking-changes/default-desktop-scrollbars
[Exposing & Updating ScrollBehaviors]: /go/exposing-scroll-behaviors
[`ScrollBehavior`]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[Scrollbars should be always visible and instantiated by default on web and desktop]: {{site.repo.flutter}}/issues/40107
[#76739]: {{site.repo.flutter}}/pull/76739
[#78588]: {{site.repo.flutter}}/pull/78588
[#111715]: {{site.repo.flutter}}/pull/111715

---

## Linha do tempo

Na versão estável: 3.7
