---
ia-translate: true
title: O tipo genérico de ParentDataWidget mudou para ParentData
description: O ParentDataWidget agora está vinculado ao tipo ParentData.
---

## Sumário

O tipo genérico de `ParentDataWidget` mudou de
`RenderObjectWidget` para `ParentData`.

## Contexto

Antes desta mudança, um `ParentDataWidget` era vinculado a um tipo específico de `RenderObjectWidget` como ancestral. Por exemplo, um widget `Positioned` só poderia ser usado dentro de um widget `Stack`. Com esta mudança, um `ParentDataWidget` pode ser usado com qualquer tipo `RenderObjectWidget` como ancestral, desde que o `RenderObject` do referido `RenderObjectWidget` configure o tipo correto `ParentData`. Neste novo mundo, o widget `Positioned` pode ser reutilizado com um hipotético novo widget `SuperStack`.

## Descrição da mudança

O argumento de tipo genérico de `ParentDataWidget`
mudou de `RenderObjectWidget` para `ParentData`,
e uma nova propriedade de debug, `debugTypicalAncestorWidgetClass`,
é adicionada ao `ParentDataWidget`.
A última é usada para mensagens de erro para dar aos usuários uma
melhor ideia do contexto em que um dado `ParentDataWidget`
deve ser usado.

## Guia de migração

Você deve migrar seu código conforme descrito nesta seção
se você estiver fazendo subclassing ou implementando `ParentDataWidget`.
Se você o fizer, o analisador mostra os seguintes avisos quando você
atualizar para a versão Flutter que inclui esta mudança:

```plaintext
  error • Missing concrete implementation of 'getter ParentDataWidget.debugTypicalAncestorWidgetClass' • lib/main.dart:114:7 • non_abstract_class_inherits_abstract_member
  error • 'FrogJar' doesn't extend 'ParentData' • lib/main.dart:114:41 • type_argument_not_matching_bounds
```

Código antes da migração:

```dart
class FrogSize extends ParentDataWidget<FrogJar> {
  FrogSize({
    Key key,
    required this.size,
    required Widget child,
  }) : assert(child != null),
        assert(size != null),
        super(key: key, child: child);

  final Size size;

  @override
  void applyParentData(RenderObject renderObject) {
    final FrogJarParentData parentData = renderObject.parentData;
    if (parentData.size != size) {
      parentData.size = size;
      final RenderFrogJar targetParent = renderObject.parent;
      targetParent.markNeedsLayout();
    }
  }
}

class FrogJarParentData extends ParentData {
  Size size;
}

class FrogJar extends RenderObjectWidget {
  // ...
}
```

Código após a migração:

```dart
class FrogSize extends ParentDataWidget<FrogJarParentData> { // FrogJar mudou para FrogJarParentData
  FrogSize({
    Key key,
    required this.size,
    required Widget child,
  }) : assert(child != null),
        assert(size != null),
        super(key: key, child: child);

  final Size size;

  @override
  void applyParentData(RenderObject renderObject) {
    final FrogJarParentData parentData = renderObject.parentData;
    if (parentData.size != size) {
      parentData.size = size;
      final RenderFrogJar targetParent = renderObject.parent;
      targetParent.markNeedsLayout();
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => FrogJar; // Adicionado recentemente
}
```

O tipo genérico da superclasse `ParentDataWidget`
muda de `FrogJar` (um `RenderObjectWidget`) para
`FrogJarParentData` (o tipo `ParentData` que
`FrogSize.applyParentData` quer operar).
Além disso, o novo `debugTypicalAncestorWidgetClass`
é implementado para esta subclasse `ParentDataWidget`.
Ele retorna o tipo de um ancestral típico `RenderObjectWidget`
para este `ParentDataWidget`. Na maioria das vezes,
você só quer retornar o tipo genérico antigo aqui
(`FrogJar` neste exemplo).

## Linha do tempo

Implementado na versão: 1.16.3<br>
Em release estável: 1.17

## Referências

Documentação da API:

* [`ParentDataWidget`][]

PR relevante:

* [Make ParentDataWidget usable with different ancestor RenderObjectWidget types][]


[Make ParentDataWidget usable with different ancestor RenderObjectWidget types]: {{site.repo.flutter}}/pull/48541
[`ParentDataWidget`]: {{site.api}}/flutter/widgets/ParentDataWidget-class.html
