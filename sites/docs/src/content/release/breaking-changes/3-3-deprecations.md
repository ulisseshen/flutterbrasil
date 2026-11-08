---
ia-translate: true
title: API descontinuada removida após v3.3
description: >
  Após atingir o fim da vida útil, as seguintes APIs descontinuadas
  foram removidas do Flutter.
---

## Resumo

De acordo com a [Deprecation Policy][Deprecation Policy] do Flutter,
APIs descontinuadas que atingiram o fim da vida útil após a
versão estável 3.3 foram removidas.

Todas as APIs afetadas foram compiladas nesta
fonte primária para auxiliar na migração. Uma
[quick reference sheet][quick reference sheet] também está disponível.

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-3-3

## Mudanças

Esta seção lista as descontinuações, listadas pela classe afetada.

### `RenderUnconstrainedBox`

Suportado pelo Flutter Fix: não

`RenderUnconstrainedBox` foi descontinuado na v2.1.
Use `RenderConstraintsTransformBox` em vez disso.

Onde não restringido em ambos os eixos, forneça `ConstraintsTransformBox.unconstrained`
para `constraintsTransform`.

Se `RenderUnconstrainedBox.constrainedAxis` foi previamente definido,
substitua respectivamente:

- Onde `constrainedAxis` era previamente `Axis.horizontal`, defina
  `constraintsTransform` como `ConstraintsTransformBox.widthUnconstrained`.
- Onde `constrainedAxis` era previamente `Axis.vertical`, defina
  `constraintsTransform` como `ConstraintsTransformBox.heightUnconstrained`.

Esta mudança permitiu a introdução de vários outros tipos de transformação
de restrições através de `ConstraintsTransformBox`. Outros parâmetros da antiga
API são compatíveis com a nova API.

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

* [`RenderConstraintsTransformBox`][RenderConstraintsTransformBox]
* [`ConstraintsTransformBox`][ConstraintsTransformBox]

PRs relevantes:

* Descontinuado em [#78673][#78673]
* Removido em [#111711][#111711]

[RenderConstraintsTransformBox]: {{site.api}}/flutter/rendering/RenderConstraintsTransformBox-class.html
[ConstraintsTransformBox]: {{site.api}}/flutter/widgets/ConstraintsTransformBox-class.html
[#78673]: {{site.repo.flutter}}/pull/78673
[#111711]: {{site.repo.flutter}}/pull/111711

---

### `DragAnchor`, `Draggable.dragAnchor` & `LongPressDraggable.dragAnchor`

Suportado pelo Flutter Fix: sim

O enum `DragAnchor`, e seus usos em `Draggable.dragAnchor` &
`LongPressDraggable.dragAnchor` foram descontinuados na v2.1.
Use `dragAnchorStrategy` em vez disso.

Esta mudança permitiu um feedback mais preciso do widget arrastável quando usado
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

* [`Draggable`][Draggable]
* [`LongPressDraggable`][LongPressDraggable]
* [`DragAnchorStrategy`][DragAnchorStrategy]

Issues relevantes:

* [#73143][#73143]

PRs relevantes:

* Descontinuado em [#79160][#79160]
* Removido em [#111713][#111713]

[Draggable]: {{site.api}}/flutter/widgets/Draggable-class.html
[LongPressDraggable]: {{site.api}}/flutter/widgets/LongPressDraggable-class.html
[DragAnchorStrategy]: {{site.api}}/flutter/widgets/DragAnchorStrategy.html
[#73143]: {{site.repo.flutter}}/pull/73143
[#79160]: {{site.repo.flutter}}/pull/79160
[#111713]: {{site.repo.flutter}}/pull/111713

---

### `ScrollBehavior.buildViewportChrome`

Suportado pelo Flutter Fix: sim

O método `ScrollBehavior.buildViewportChrome` foi descontinuado na v2.1.

Este método era usado pelo widget `Scrollable` para aplicar um indicador
de overscroll, como `GlowingOverscrollIndicator`, por padrão nas
plataformas apropriadas. Como mais decoradores padrão foram adicionados, como `Scrollbar`s, cada
um foi dividido em métodos individuais para substituir `buildViewportChrome`.

Isso permite que classes estendidas substituam apenas o decorador específico, através de
`buildScrollbar` ou `buildOverscrollIndicator`, em vez de precisar reescrever
código para manter um ou outro.

**Guia de migração**

[Guia de migração detalhado disponível][In-depth migration guide available]

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

* [Exposing & Updating ScrollBehaviors][Exposing & Updating ScrollBehaviors]

Documentação da API:

* [`ScrollBehavior`][ScrollBehavior]

Issues relevantes:

* [Scrollbars should be always visible and instantiated by default on web and desktop][Scrollbars issue]

PRs relevantes:

* [#76739][#76739]
* Descontinuado em [#78588][#78588]
* Removido em [#111715][#111715]

[In-depth migration guide available]: /release/breaking-changes/default-desktop-scrollbars
[Exposing & Updating ScrollBehaviors]: /go/exposing-scroll-behaviors
[ScrollBehavior]: {{site.api}}/flutter/widgets/ScrollBehavior-class.html
[Scrollbars issue]: {{site.repo.flutter}}/issues/40107
[#76739]: {{site.repo.flutter}}/pull/76739
[#78588]: {{site.repo.flutter}}/pull/78588
[#111715]: {{site.repo.flutter}}/pull/111715

---

## Cronograma

Na versão estável: 3.7
