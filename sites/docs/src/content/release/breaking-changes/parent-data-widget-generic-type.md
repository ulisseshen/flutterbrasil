---
ia-translate: true
title: O tipo genérico de ParentDataWidget mudou para ParentData
description: O ParentDataWidget agora está vinculado ao tipo ParentData.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O tipo genérico de `ParentDataWidget` mudou de
`RenderObjectWidget` para `ParentData`.

## Contexto

Antes desta mudança, um `ParentDataWidget` estava vinculado
a um tipo específico de `RenderObjectWidget` como ancestral.
Por exemplo, um widget `Positioned` só podia ser usado
dentro de um widget `Stack`. Com esta mudança,
um `ParentDataWidget` pode ser usado com qualquer
tipo de `RenderObjectWidget` como ancestral, desde que
o `RenderObject` do referido `RenderObjectWidget`
configure o tipo correto de `ParentData`. Neste novo cenário,
o widget `Positioned` pode ser reutilizado com um hipotético
novo widget `SuperStack`.

## Descrição da mudança

O argumento de tipo genérico de `ParentDataWidget`
mudou de `RenderObjectWidget` para `ParentData`,
e uma nova propriedade de debug, `debugTypicalAncestorWidgetClass`,
foi adicionada ao `ParentDataWidget`.
Esta última é usada para mensagens de erro para dar aos usuários uma
melhor ideia do contexto no qual um determinado `ParentDataWidget`
deve ser usado.

## Guia de migração

Você deve migrar seu código conforme descrito nesta seção
se estiver criando subclasses ou implementando `ParentDataWidget`.
Se você fizer isso, o analisador mostrará os seguintes avisos quando você
atualizar para a versão do Flutter que inclui esta mudança:

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
  Type get debugTypicalAncestorWidgetClass => FrogJar; // Recém adicionado
}
```

O tipo genérico da superclasse `ParentDataWidget`
muda de `FrogJar` (um `RenderObjectWidget`) para
`FrogJarParentData` (o tipo `ParentData` no qual
`FrogSize.applyParentData` deseja operar).
Além disso, a nova propriedade `debugTypicalAncestorWidgetClass`
é implementada para esta subclasse de `ParentDataWidget`.
Ela retorna o tipo de um `RenderObjectWidget` ancestral típico
para este `ParentDataWidget`. Na maioria das vezes,
você apenas deseja retornar o antigo tipo genérico aqui
(`FrogJar` neste exemplo).

## Linha do tempo

Lançado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`ParentDataWidget`][`ParentDataWidget`]

PR relevante:

* [Make ParentDataWidget usable with different ancestor RenderObjectWidget types][Make ParentDataWidget usable with different ancestor RenderObjectWidget types]


[Make ParentDataWidget usable with different ancestor RenderObjectWidget types]: {{site.repo.flutter}}/pull/48541
[`ParentDataWidget`]: {{site.api}}/flutter/widgets/ParentDataWidget-class.html
