---
ia-translate: true
title: O RenderEditable precisa ser disposto antes do hit testing
description: >
  O hit testing do RenderEditable requer informações adicionais
  que estão disponíveis apenas após o layout.
---

## Resumo

Instâncias de `RenderEditable` devem ser dispostas antes de processar o hit
testing. Tentar fazer hit-test em um objeto `RenderEditable` antes do layout
resulta em uma asserção como a seguinte:

```plaintext
Falha na asserção: linha 123 pos 45: '!debugNeedsLayout': não é verdadeiro.
```

## Contexto

Para dar suporte a recognizers de gestos em texto selecionável, o
`RenderEditable` requer as informações de layout para seus
spans de texto para determinar qual span de texto recebe o
evento de ponteiro. (Antes desta mudança, objetos `RenderEditable`
não levavam em consideração seu texto ao avaliar hit tests.)
Para implementar isso, o layout foi tornado um pré-requisito para realizar
hit testing em um objeto `RenderEditable`.

Na prática, isso raramente é um problema. A biblioteca de widgets
garante que o layout seja realizado antes de qualquer hit test em todos
os objetos de renderização. É provável que esse problema seja visto apenas em
código que interage diretamente com objetos de renderização, por
exemplo, em testes de objetos de renderização personalizados.

## Guia de migração

Se você vir o erro de asserção `'!debugNeedsLayout': não é verdadeiro`
ao fazer hit testing no `RenderEditable`,
faça o layout do `RenderEditable` antes de fazê-lo.

Código antes da migração:

```dart
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  test('attach e detach manipulam corretamente o gesto', () {
    final RenderEditable editable = RenderEditable(
      textDirection: TextDirection.ltr,
      offset: ViewportOffset.zero(),
      textSelectionDelegate: FakeEditableTextState(),
      startHandleLayerLink: LayerLink(),
      endHandleLayerLink: LayerLink(),
    );
    final PipelineOwner owner = PipelineOwner(onNeedVisualUpdate: () {});
    editable.attach(owner);
    // Isso lança um erro de asserção porque
    // o RenderEditable não foi disposto.
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
  test('attach e detach manipulam corretamente o gesto', () {
    final RenderEditable editable = RenderEditable(
      textDirection: TextDirection.ltr,
      offset: ViewportOffset.zero(),
      textSelectionDelegate: FakeEditableTextState(),
      startHandleLayerLink: LayerLink(),
      endHandleLayerLink: LayerLink(),
    );
    // Primeiro, faça o layout do RenderEditable.
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

Implementado na versão: 1.18.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`RenderEditable`][]

Problema relevante:

* [Issue 43494][]: SelectableText.rich usado junto com
  TapGestureRecognizer não está funcionando

PR relevante:

* [PR 54479: Enable gesture recognizer in selectable rich text][]


[Issue 43494]: {{site.repo.flutter}}/issues/43494
[`RenderEditable`]: {{site.api}}/flutter/rendering/RenderEditable-class.html
[PR 54479: Enable gesture recognizer in selectable rich text]: {{site.repo.flutter}}/pull/54479
