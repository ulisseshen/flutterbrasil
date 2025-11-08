---
title: The RenderEditable needs to be laid out before hit testing
description: >
  The hit testing of RenderEditable requires additional information
  that is only available after the layout.
ia-translate: true
---

## Resumo

Instances of `RenderEditable` must be laid out before processing hit
testing. Trying to hit-test a `RenderEditable` object before layout
results in an assertion such as the following:

```plaintext
Failed assertion: line 123 pos 45: '!debugNeedsLayout': is not true.
```

## Contexto

To support gesture recognizers in selectable text, the
`RenderEditable` requires the layout information for its
text spans to determine which text span receives the
pointer event. (Before this change, `RenderEditable` objects 
didn't take their text into account when evaluating hit tests.)
To implement this, layout was made a prerequisite for performing
hit testing on a `RenderEditable` object.

In practice, this is rarely an issue. The widget library
ensures that layout is performed before any hit test on all
render objects. This problem is only likely to be seen in
code that directly interacts with render objects, for
example in tests of custom render objects.

## Guia de migração

If you see the `'!debugNeedsLayout': is not true`
assertion error while hit testing the `RenderEditable`,
lay out the `RenderEditable` before doing so.

Código antes da migração:

```dart
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  test('attach and detach correctly handle gesture', () {
    final RenderEditable editable = RenderEditable(
      textDirection: TextDirection.ltr,
      offset: ViewportOffset.zero(),
      textSelectionDelegate: FakeEditableTextState(),
      startHandleLayerLink: LayerLink(),
      endHandleLayerLink: LayerLink(),
    );
    final PipelineOwner owner = PipelineOwner(onNeedVisualUpdate: () {});
    editable.attach(owner);
    // This throws an assertion error because
    // the RenderEditable hasn't been laid out.
    editable.handleEvent(const PointerDownEvent(),
        BoxHitTestEntry(editable, const Offset(10, 10)));
    editable.detach();
  });
}

class FakeEditableTextState extends TextSelectionDelegate {
  @override
  TextEditingValue textEditingValue;
  @override
  void hideToolbar() {}
  @override
  void bringIntoView(TextPosition position) {}
}
```

Código após a migração:

```dart
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  test('attach and detach correctly handle gesture', () {
    final RenderEditable editable = RenderEditable(
      textDirection: TextDirection.ltr,
      offset: ViewportOffset.zero(),
      textSelectionDelegate: FakeEditableTextState(),
      startHandleLayerLink: LayerLink(),
      endHandleLayerLink: LayerLink(),
    );
    // Lay out the RenderEditable first.
    editable.layout(BoxConstraints.loose(const Size(1000.0, 1000.0)));
    final PipelineOwner owner = PipelineOwner(onNeedVisualUpdate: () {});
    editable.attach(owner);
    editable.handleEvent(const PointerDownEvent(),
        BoxHitTestEntry(editable, const Offset(10, 10)));
    editable.detach();
  });
}

class FakeEditableTextState extends TextSelectionDelegate {
  @override
  TextEditingValue textEditingValue;
  @override
  void hideToolbar() {}
  @override
  void bringIntoView(TextPosition position) {}
}
```

## Linha do tempo

Lançado na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`RenderEditable`][]

Issues relevantes:

* [Issue 43494][]: SelectableText.rich used along with
  TapGestureRecognizer isn't working

PRs relevantes:

* [PR 54479: Enable gesture recognizer in selectable rich text][]


[Issue 43494]: {{site.repo.flutter}}/issues/43494
[`RenderEditable`]: {{site.api}}/flutter/rendering/RenderEditable-class.html
[PR 54479: Enable gesture recognizer in selectable rich text]: {{site.repo.flutter}}/pull/54479
