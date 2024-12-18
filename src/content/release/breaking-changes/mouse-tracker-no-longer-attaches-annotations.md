---
ia-translate: true
title: MouseTracker não anexa mais anotações
description: >
  MouseTracker não depende mais da anexação de anotações para
  realizar a verificação de saída-montada; portanto,
  todos os três métodos relacionados são removidos.
---

## Resumo

Removidos os métodos de `MouseTracker` `attachAnnotation`,
`detachAnnotation` e `isAnnotationAttached`.

## Contexto

Eventos de mouse, como quando um ponteiro do mouse entrou em uma região,
saiu ou está pairando sobre uma região, são detectados com a ajuda de
`MouseTrackerAnnotation`s que são colocadas em regiões de interesse
durante a fase de renderização. A cada atualização (um novo frame ou um novo evento),
`MouseTracker` compara as anotações sobre as quais o ponteiro do mouse
pairou antes e depois da atualização, então despacha
callbacks adequadamente.

A classe `MouseTracker`, que gerencia o estado dos ponteiros do mouse,
costumava exigir que `MouseRegion` anexasse anotações quando montado,
e desanexasse as anotações quando desmontado.
Isso era usado por `MouseTracker` para realizar a
_verificação de saída-montada_ (por exemplo, `MouseRegion.onExit`
não deve ser chamado se a saída foi causada pela desmontagem
do widget), a fim de evitar chamar `setState`
de um widget desmontado e lançar exceções (explicado
em detalhes em [Issue #44631][]).

Este mecanismo foi substituído fazendo de `MouseRegion`
um widget stateful, para que ele possa realizar a verificação
de saída-montada por si só, bloqueando o callback quando
desmontado.
Portanto, esses métodos foram removidos e `MouseTracker`
não rastreia mais todas as anotações na tela.

## Descrição da mudança

A classe `MouseTracker` removeu três métodos relacionados
à anexação de anotações:

```dart diff
  class MouseTracker extends ChangeNotifier {
    // ...
-   void attachAnnotation(MouseTrackerAnnotation annotation) {/* ... */}

-   void detachAnnotation(MouseTrackerAnnotation annotation) {/* ... */}

-   @visibleForTesting
-   bool isAnnotationAttached(MouseTrackerAnnotation annotation) {/* ... */}
  }
```

`RenderMouseRegion` e `MouseTrackerAnnotation` não realizam mais a
verificação de saída-montada, enquanto `MouseRegion` ainda realiza.

## Guia de migração

Chamadas para `MouseTracker.attachAnnotation` e
`detachAnnotation` devem ser removidas com pouco ou nenhum impacto:

* Usos de `MouseRegion` não devem ser afetados de forma alguma.
* Se o seu código usa diretamente `RenderMouseRegion` ou
  `MouseTrackerAnnotation`, esteja ciente de que `onExit`
  agora é chamado quando a saída é causada por eventos que
  costumavam chamar `MouseTracker.detachAnnotation`.
  Isso não deve ser um problema se nenhum estado estiver envolvido,
  caso contrário, você pode querer adicionar a verificação de saída-montada,
  especialmente se o callback vazar para que widgets externos possam
  chamar `setState` nele. Por exemplo:

Código antes da migração:

```dart
class MyMouseRegion extends SingleChildRenderObjectWidget {
  const MyMouseRegion({this.onHoverChange});

  final ValueChanged<bool> onHoverChange;

  @override
  RenderMouseRegion createRenderObject(BuildContext context) {
    return RenderMouseRegion(
      onEnter: (_) { onHoverChange(true); },
      onExit: (_) { onHoverChange(false); },
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMouseRegion renderObject) {
    renderObject
      ..onEnter = (_) { onHoverChange(true); }
      ..onExit = (_) { onHoverChange(false); };
  }
}
```

Código após a migração:

```dart
class MyMouseRegion extends SingleChildRenderObjectWidget {
  const MyMouseRegion({this.onHoverChange});

  final ValueChanged<bool> onHoverChange;

  @override
  RenderMouseRegion createRenderObject(BuildContext context) {
    return RenderMouseRegion(
      onEnter: (_) { onHoverChange(true); },
      onExit: (_) { onHoverChange(false); },
    );
  }

  @override
  void updateRenderObject(BuildContext context, RenderMouseRegion renderObject) {
    renderObject
      ..onEnter = (_) { onHoverChange(true); }
      ..onExit = (_) { onHoverChange(false); };
  }

  @override
  void didUnmountRenderObject(RenderMouseRegion renderObject) {
    renderObject
      ..onExit = onHoverChange == null ? null : (_) {};
  }
}
```

Chamadas para `MouseTracker.isAnnotationAttached` devem ser removidas.
Esse recurso não é mais tecnicamente possível,
já que as anotações não são mais rastreadas.
Se você precisar desse recurso de alguma forma, envie um issue.

## Linha do tempo

Implementado na versão: 1.15.4<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`MouseRegion`][]
* [`MouseTracker`][]
* [`MouseTrackerAnnotation`][]
* [`RenderMouseRegion`][]

PRs relevantes:

* [MouseTracker no longer requires annotations attached][],
  que fez a mudança
* [Improve MouseTracker lifecycle: Move checks to post-frame][],
  que primeiro introduziu a mudança de saída-montada,
  explicado em _The change to onExit_.


[Improve MouseTracker lifecycle: Move checks to post-frame]: {{site.repo.flutter}}/issues/44631
[Issue #44631]: {{site.repo.flutter}}/pull/44631
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`MouseTracker`]: {{site.api}}/flutter/gestures/MouseTracker-class.html
[MouseTracker no longer requires annotations attached]: {{site.repo.flutter}}/issues/48453
[`MouseTrackerAnnotation`]: {{site.api}}/flutter/gestures/MouseTrackerAnnotation-class.html
[`RenderMouseRegion`]: {{site.api}}/flutter/rendering/RenderMouseRegion-class.html
