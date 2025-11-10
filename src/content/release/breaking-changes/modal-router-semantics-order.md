---
title: Ordem de Semantics das Overlay Entries em Modal Routes
description: >
  O escopo do modal route tem uma ordem de travessia de semantics
  mais alta do que sua modal barrier.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Alteramos a ordem de travessia de semantics das overlay entries em modal routes.
O talk back de acessibilidade ou voice over agora foca no escopo de um modal route
primeiro, em vez de sua modal barrier.

## Contexto

O modal route tem duas overlay entries, o escopo e a modal barrier. O
escopo é o conteúdo real do modal route, e a modal barrier é o
plano de fundo da rota se seu escopo não cobrir toda a tela. Se o
modal route retornar true para `barrierDismissible`, a modal barrier se torna
focável para acessibilidade porque os usuários podem tocar na modal barrier para fechar o
modal route. Esta alteração especificamente fez a acessibilidade focar no escopo
primeiro antes da modal barrier.

## Descrição da alteração

Adicionamos um nó de semantics adicional acima de ambas
as overlay entries dos modal routes.
Esses nós de semantics denotam a ordem de travessia
de semantics dessas duas overlay entries.
Isso também alterou a estrutura da árvore de semantics.

## Guia de migração

Se seus testes começarem a falhar devido a alterações na árvore de semantics após a atualização,
você pode migrar seu código esperando um novo nó acima das overlay entries
do modal route.

Código antes da migração:

```dart
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('example test', (WidgetTester tester) async {
    final SemanticsHandle handle =
        tester.binding.pipelineOwner.ensureSemantics();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text('test'))));

    final SemanticsNode root =
        tester.binding.pipelineOwner.semanticsOwner.rootSemanticsNode;

    final SemanticsNode firstNode = getChild(root);
    expect(firstNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    // Fixes the test by expecting an additional node above the scope route.
    final SemanticsNode secondNode = getChild(firstNode);
    expect(secondNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    final SemanticsNode thirdNode = getChild(secondNode);
    expect(thirdNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));
    expect(thirdNode.hasFlag(SemanticsFlag.scopesRoute), true);

    final SemanticsNode forthNode = getChild(thirdNode);
    expect(forthNode.rect, Rect.fromLTRB(0.0, 0.0, 56.0, 14.0));
    expect(forthNode.label, 'test');
    handle.dispose();
  });
}

SemanticsNode getChild(SemanticsNode node) {
  SemanticsNode child;
  bool visiter(SemanticsNode target) {
    child = target;
    return false;
  }

  node.visitChildren(visiter);
  return child;
}
```

Código após a migração:

```dart
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('example test', (WidgetTester tester) async {
    final SemanticsHandle handle =
        tester.binding.pipelineOwner.ensureSemantics();

    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text('test'))));

    final SemanticsNode root =
        tester.binding.pipelineOwner.semanticsOwner.rootSemanticsNode;

    final SemanticsNode firstNode = getChild(root);
    expect(firstNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    // Fixes the test by expecting an additional node above the scope route.
    final SemanticsNode secondNode = getChild(firstNode);
    expect(secondNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    final SemanticsNode thirdNode = getChild(secondNode);
    expect(thirdNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));
    expect(thirdNode.hasFlag(SemanticsFlag.scopesRoute), true);

    final SemanticsNode forthNode = getChild(thirdNode);
    expect(forthNode.rect, Rect.fromLTRB(0.0, 0.0, 56.0, 14.0));
    expect(forthNode.label, 'test');
    handle.dispose();
  });
}

SemanticsNode getChild(SemanticsNode node) {
  SemanticsNode child;
  bool visiter(SemanticsNode target) {
    child = target;
    return false;
  }

  node.visitChildren(visiter);
  return child;
}
```

## Linha do tempo

Disponibilizado na versão: 1.19.0<br>
Na versão estável: 1.20

## Referências

Documentação da API:

* [`ModalRoute`][]
* [`OverlayEntry`][]

Issue relevante:

* [Issue 46625][]

PR relevante:

* [PR 59290][]

[`ModalRoute`]: {{site.api}}/flutter/widgets/ModalRoute-class.html
[`OverlayEntry`]: {{site.api}}/flutter/widgets/OverlayEntry-class.html
[Issue 46625]: {{site.repo.flutter}}/issues/46625
[PR 59290]: {{site.repo.flutter}}/pull/59290
