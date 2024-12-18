---
ia-translate: true
title: Ordem Semântica das Entradas de Sobreposição em Rotas Modais
description: >
  O escopo da rota modal tem uma ordem de percurso semântico
  superior à sua barreira modal.
---

## Resumo

Nós alteramos a ordem de percurso semântico das entradas de sobreposição em rotas modais.
O talkback ou voice over de acessibilidade agora foca o escopo de uma rota modal
primeiro, em vez de sua barreira modal.

## Contexto

A rota modal tem duas entradas de sobreposição, o escopo e a barreira modal. O
escopo é o conteúdo real da rota modal, e a barreira modal é o
fundo da rota se seu escopo não cobrir a tela inteira. Se a
rota modal retorna verdadeiro para `barrierDismissible`, a barreira modal se torna
focável por acessibilidade porque os usuários podem tocar na barreira modal para remover a
rota modal. Esta mudança fez especificamente com que a acessibilidade focasse o escopo
primeiro antes da barreira modal.

## Descrição da mudança

Nós adicionamos um nó semântico adicional acima de ambas
as entradas de sobreposição de rotas modais.
Esses nós semânticos denotam a ordem de
percurso semântico dessas duas entradas de sobreposição.
Isso também mudou a estrutura da árvore semântica.

## Guia de migração

Se seus testes começarem a falhar devido a mudanças na árvore semântica após a atualização,
você pode migrar seu código esperando um novo nó acima das
entradas de sobreposição da rota modal.

Código antes da migração:

```dart
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('exemplo de teste', (WidgetTester tester) async {
    final SemanticsHandle handle =
        tester.binding.pipelineOwner.ensureSemantics();

    // Constrói nosso aplicativo e aciona um frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text('teste'))));

    final SemanticsNode root =
        tester.binding.pipelineOwner.semanticsOwner.rootSemanticsNode;

    final SemanticsNode firstNode = getChild(root);
    expect(firstNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    // Corrige o teste esperando um nó adicional acima da rota do escopo.
    final SemanticsNode secondNode = getChild(firstNode);
    expect(secondNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    final SemanticsNode thirdNode = getChild(secondNode);
    expect(thirdNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));
    expect(thirdNode.hasFlag(SemanticsFlag.scopesRoute), true);

    final SemanticsNode forthNode = getChild(thirdNode);
    expect(forthNode.rect, Rect.fromLTRB(0.0, 0.0, 56.0, 14.0));
    expect(forthNode.label, 'teste');
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
  testWidgets('exemplo de teste', (WidgetTester tester) async {
    final SemanticsHandle handle =
        tester.binding.pipelineOwner.ensureSemantics();

    // Constrói nosso aplicativo e aciona um frame.
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Text('teste'))));

    final SemanticsNode root =
        tester.binding.pipelineOwner.semanticsOwner.rootSemanticsNode;

    final SemanticsNode firstNode = getChild(root);
    expect(firstNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    // Corrige o teste esperando um nó adicional acima da rota do escopo.
    final SemanticsNode secondNode = getChild(firstNode);
    expect(secondNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));

    final SemanticsNode thirdNode = getChild(secondNode);
    expect(thirdNode.rect, Rect.fromLTRB(0.0, 0.0, 800.0, 600.0));
    expect(thirdNode.hasFlag(SemanticsFlag.scopesRoute), true);

    final SemanticsNode forthNode = getChild(thirdNode);
    expect(forthNode.rect, Rect.fromLTRB(0.0, 0.0, 56.0, 14.0));
    expect(forthNode.label, 'teste');
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

Implementado na versão: 1.19.0<br>
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
