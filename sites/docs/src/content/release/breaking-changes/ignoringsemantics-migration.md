---
ia-translate: true
title: Guia de migração para ignoringSemantics em IgnorePointer e classes relacionadas
description: Remoção de ignoringSemantics em IgnorePointer e classes relacionadas.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O widget `IgnoringPointer` permite que você designe uma área da UI
onde você não quer aceitar eventos de ponteiro, por exemplo, quando
você não quer permitir que o usuário insira texto em um campo de texto.

Anteriormente, o `IgnorePointer` não apenas bloqueava eventos de ponteiro mas também
descartava sua subárvore da árvore de semântica. O parâmetro `ignoreSemantics` foi
introduzido como uma solução alternativa para preservar a árvore de semântica ao usar
`IgnorePointer`s.

O comportamento do `IgnorePointer` mudou no sentido de que ele não mais descarta
toda a subárvore de semântica mas apenas bloqueia ações de semântica na
subárvore. A solução alternativa `ignoringSemantics` não é mais necessária e está
descontinuada.

Esta mudança também se aplica aos widgets `AbsorbPointer` e
`SliverIgnorePointer`.

## Descrição da mudança

`ignoringSemantics` foi removido.

## Guia de migração

Se você definir este parâmetro como true nestes widgets, considere usar
`ExcludeSemantics` em vez disso.

Código antes da migração:

```dart
IgnorePointer(
  ignoringSemantics: true,
  child: const PlaceHolder(),
);

AbsorbPointer(
  ignoringSemantics: true,
  child: const PlaceHolder(),
);

SliverIgnorePointer(
  ignoringSemantics: true,
  child: const PlaceHolder(),
);
```

Código após a migração:

```dart
ExcludeSemantics(
  child: IgnorePointer(
    child: const PlaceHolder(),
  ),
);

ExcludeSemantics(
  child: AbsorbPointer(
    child: const PlaceHolder(),
  ),
);

SliverIgnorePointer(
  child: ExcludeSemantics(
    child: const PlaceHolder(),
  ),
);
```

Se você estava anteriormente usando `IgnorePointer`s com `ignoringSemantics` definido como `false`,
você pode obter o mesmo comportamento copiando os seguintes widgets diretamente para seu
código e usando.

```dart
/// A widget ignores pointer events without modifying the semantics tree.
class _IgnorePointerWithSemantics extends SingleChildRenderObjectWidget {
  const _IgnorePointerWithSemantics({
    super.child,
  });

  @override
  _RenderIgnorePointerWithSemantics createRenderObject(BuildContext context) {
    return _RenderIgnorePointerWithSemantics();
  }
}

class _RenderIgnorePointerWithSemantics extends RenderProxyBox {
  _RenderIgnorePointerWithSemantics();

  @override
  bool hitTest(BoxHitTestResult result, { required Offset position }) => false;
}

/// A widget absorbs pointer events without modifying the semantics tree.
class _AbsorbPointerWithSemantics extends SingleChildRenderObjectWidget {
  const _AbsorbPointerWithSemantics({
    super.child,
  });

  @override
  _RenderAbsorbPointerWithSemantics createRenderObject(BuildContext context) {
    return _RenderAbsorbPointerWithSemantics();
  }
}

class _RenderAbsorbPointerWithSemantics extends RenderProxyBox {
  _RenderAbsorbPointerWithSemantics();

  @override
  bool hitTest(BoxHitTestResult result, { required Offset position }) {
    return size.contains(position);
  }
}

/// A sliver ignores pointer events without modifying the semantics tree.
class _SliverIgnorePointerWithSemantics extends SingleChildRenderObjectWidget {
  const _SliverIgnorePointerWithSemantics({
    super.child,
  });

  @override
  _RenderSliverIgnorePointerWithSemantics createRenderObject(BuildContext context) {
    return _RenderSliverIgnorePointerWithSemantics();
  }
}

class _RenderSliverIgnorePointerWithSemantics extends RenderProxySliver {
  _RenderSliverIgnorePointerWithSemantics();

  @override
  bool hitTest(BoxHitTestResult result, { required Offset position }) => false;
}
```

## Cronograma

Disponibilizado na versão: 3.10.0-2.0.pre<br>
Na versão estável: 3.13.0

## Referências

PRs relevantes:

* [PR 120619][PR 120619]: Fixes IgnorePointer and AbsorbPointer to only block user
  interactions in a11y.

[PR 120619]: {{site.repo.flutter}}/pull/120619
[IgnorePointer]: {{site.api}}/flutter/widgets/IgnorePointer-class.html
[AbsorbPointer]: {{site.api}}/flutter/widgets/AbsorbPointer-class.html
[SliverIgnorePointer]: {{site.api}}/flutter/widgets/SliverIgnorePointer-class.html
[RenderSliverIgnorePointer]: {{site.api}}/flutter/rendering/RenderSliverIgnorePointer-class.html
[RenderIgnorePointer]: {{site.api}}/flutter/rendering/RenderIgnorePointer-class.html
[RenderAbsorbPointer]: {{site.api}}/flutter/rendering/RenderAbsorbPointer-class.html
