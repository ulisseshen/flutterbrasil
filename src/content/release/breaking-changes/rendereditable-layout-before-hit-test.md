---
ia-translate: true
title: O RenderEditable precisa ser diagramado antes do hit testing
description: >
  O hit testing do RenderEditable requer informações adicionais
  que estão disponíveis apenas após o layout.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Instâncias de `RenderEditable` devem ser diagramadas antes de processar hit
testing. Tentar fazer hit-test em um objeto `RenderEditable` antes do layout
resulta em uma asserção como a seguinte:

```plaintext
Failed assertion: line 123 pos 45: '!debugNeedsLayout': is not true.
```

## Contexto

Para suportar gesture recognizers em texto selecionável, o
`RenderEditable` requer as informações de layout para seus
text spans para determinar qual text span recebe o
evento de ponteiro. (Antes dessa mudança, objetos `RenderEditable`
não levavam seu texto em consideração ao avaliar hit tests.)
Para implementar isso, o layout foi tornado um pré-requisito para realizar
hit testing em um objeto `RenderEditable`.

Na prática, isso raramente é um problema. A biblioteca de widgets
garante que o layout seja realizado antes de qualquer hit test em todos
os render objects. Este problema só é provável de ser visto em
código que interage diretamente com render objects, por
exemplo em testes de render objects personalizados.

## Guia de migração

Se você vir o erro de asserção `'!debugNeedsLayout': is not true`
ao fazer hit testing do `RenderEditable`,
diagrame o `RenderEditable` antes de fazer isso.

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

## Cronograma

Landed in version: 1.18.0<br>
In stable release: 1.20

## Referências

Documentação da API:

* [`RenderEditable`][]

Issue relevante:

* [Issue 43494][]: SelectableText.rich used along with
  TapGestureRecognizer isn't working

PR relevante:

* [PR 54479: Enable gesture recognizer in selectable rich text][]


[Issue 43494]: {{site.repo.flutter}}/issues/43494
[`RenderEditable`]: {{site.api}}/flutter/rendering/RenderEditable-class.html
[PR 54479: Enable gesture recognizer in selectable rich text]: {{site.repo.flutter}}/pull/54479
