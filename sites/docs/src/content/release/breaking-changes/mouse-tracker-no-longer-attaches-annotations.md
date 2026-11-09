---
title: MouseTracker não anexa mais annotations
description: >
  MouseTracker não depende mais da anexação de annotations para
  realizar a verificação de saída montada; por isso,
  os três métodos relacionados foram removidos.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Os métodos `attachAnnotation`, `detachAnnotation` e `isAnnotationAttached`
do `MouseTracker` foram removidos.

## Contexto {:#context}

Eventos do mouse, como quando um ponteiro do mouse entra em uma região,
sai dela ou passa sobre ela, são detectados com a ajuda de
`MouseTrackerAnnotation`s posicionados nas regiões de interesse
durante a fase de renderização. A cada atualização (um novo frame ou um novo evento),
o `MouseTracker` compara as annotations sobre as quais o ponteiro do mouse
estava antes e depois da atualização e, então, dispara
os callbacks de acordo.

A classe `MouseTracker`, que gerencia o estado dos ponteiros do mouse,
costumava exigir que `MouseRegion` anexasse annotations ao ser montado,
e as desanexasse ao ser desmontado.
Isso era usado pelo `MouseTracker` para realizar a
_verificação de saída montada_ (por exemplo, `MouseRegion.onExit`
não deve ser chamado se a saída foi causada pela desmontagem
do widget), a fim de evitar chamar `setState`
de um widget desmontado e lançar exceções (explicado
em detalhes na [Issue #44631][]).

Esse mecanismo foi substituído por tornar `MouseRegion`
um widget com estado, para que ele mesmo possa realizar a
verificação de saída montada, bloqueando o callback quando desmontado.
Por isso, esses métodos foram removidos, e o `MouseTracker`
não rastreia mais todas as annotations da tela.

## Descrição da mudança {:#description-of-change}

A classe `MouseTracker` removeu três métodos relacionados
à anexação de annotations:

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
verificação de saída montada, enquanto `MouseRegion` continua realizando.

## Guia de migração {:#migration-guide}

As chamadas a `MouseTracker.attachAnnotation` e
`detachAnnotation` devem ser removidas, com pouco ou nenhum impacto:

* Usos de `MouseRegion` não devem ser afetados de forma alguma.
* Se o seu código usa diretamente `RenderMouseRegion` ou
  `MouseTrackerAnnotation`, esteja ciente de que `onExit`
  agora é chamado quando a saída é causada por eventos que
  antes chamavam `MouseTracker.detachAnnotation`.
  Isso não deve ser um problema se nenhum estado estiver envolvido;
  caso contrário, talvez você queira adicionar a verificação de saída montada,
  especialmente se o callback vazar para que widgets externos
  possam chamar `setState` nele. Por exemplo:

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

As chamadas a `MouseTracker.isAnnotationAttached` devem ser removidas.
Esse recurso não é mais tecnicamente possível,
já que as annotations não são mais rastreadas.
Se você de alguma forma precisar desse recurso, abra uma issue.

## Linha do tempo {:#timeline}

Incluído na versão: 1.15.4<br>
Na versão estável: 1.17

## Referências {:#references}

Documentação da API:

* [`MouseRegion`][]
* [`MouseTracker`][]
* [`MouseTrackerAnnotation`][]
* [`RenderMouseRegion`][]

PRs relevantes:

* [MouseTracker no longer requires annotations attached][],
  que realizou a mudança
* [Improve MouseTracker lifecycle: Move checks to post-frame][],
  que introduziu pela primeira vez a mudança de saída montada,
  explicada em _A mudança no onExit_.


[Improve MouseTracker lifecycle: Move checks to post-frame]: {{site.repo.flutter}}/issues/44631
[Issue #44631]: {{site.repo.flutter}}/pull/44631
[`MouseRegion`]: {{site.api}}/flutter/widgets/MouseRegion-class.html
[`MouseTracker`]: {{site.api}}/flutter/gestures/MouseTracker-class.html
[MouseTracker no longer requires annotations attached]: {{site.repo.flutter}}/issues/48453
[`MouseTrackerAnnotation`]: {{site.api}}/flutter/gestures/MouseTrackerAnnotation-class.html
[`RenderMouseRegion`]: {{site.api}}/flutter/rendering/RenderMouseRegion-class.html
