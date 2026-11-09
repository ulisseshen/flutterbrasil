---
ia-translate: true
title: Mudança na ordem de fechamento do RawMenuAnchor
description: >-
  Fechar um `RawMenuAnchor` agora dispara os callbacks
  `onClose` e `onCloseRequested` de todos os `RawMenuAnchor`s
  descendentes em uma sequência coordenada.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Fechar um `RawMenuAnchor` agora dispara os callbacks `onCloseRequested`
e `onClose` de todos os `RawMenuAnchor`s descendentes.
O callback `onCloseRequested` é disparado de cima para baixo,
começando pelo `RawMenuAnchor` que iniciou o fechamento e seguindo para os seus descendentes,
enquanto o callback `onClose` é disparado de baixo para cima.
Se um `RawMenuAnchor` já estiver fechado,
chamadas a `MenuController.close` e `MenuController.closeChildren`
não disparam o callback `onCloseRequested`.

## Contexto {:#background}

`RawMenuAnchor` é um widget de baixo nível usado para construir sistemas de menu customizados.
Antes, um `RawMenuAnchor` não notificava automaticamente os seus descendentes
quando era fechado.
Era preciso chamar manualmente `controller.closeChildren()`
dentro do callback `onCloseRequested`
para fechar os `RawMenuAnchor`s descendentes.

Além disso, o momento de disparo do callback `onClose` era inconsistente.
O `onClose` de um `RawMenuAnchor` pai podia ser executado
antes de os seus descendentes terminarem de fechar.

O comportamento atualizado garante que, quando um `RawMenuAnchor` pai começa a fechar,
ele dispara em seguida `onCloseRequested` para todos os seus
`RawMenuAnchor`s descendentes, de cima para baixo.

Quando `hideOverlay` é chamado dentro de `onCloseRequested` para fechar o menu,
todos os `RawMenuAnchor`s descendentes têm seus callbacks `onClose`
executados de baixo para cima.
Isso significa que o `RawMenuAnchor` aberto mais recentemente
agora tem o seu callback `onClose` executado primeiro,
seguido pelo seu pai, e assim por diante até o topo da hierarquia.

Esse design permite uma sequência de fechamento coordenada, em que os
`RawMenuAnchor`s filhos podem executar qualquer limpeza necessária antes
de os pais finalizarem o processo de fechamento.

Por fim, se um `RawMenuAnchor` já estiver fechado,
chamadas a `MenuController.close` e `MenuController.closeChildren`
não disparam o callback `onCloseRequested`,
evitando execuções desnecessárias de callbacks.

## Guia de migração {:#migration-guide}

Se o seu código não sobrescreve a implementação padrão de
`RawMenuAnchor.onCloseRequested` ou se o seu `RawMenuAnchor`
não contém submenus, nenhuma alteração é necessária.

Se você tem uma implementação customizada de `onCloseRequested`
em um `RawMenuAnchor` que contém submenus,
`controller.closeChildren()` agora é chamado automaticamente
quando o menu pai fecha.
Garanta que a sua implementação de `onCloseRequested`
continue se comportando corretamente com essa chamada automática.
Chamadas imediatas a `controller.closeChildren()` dentro do seu
callback `onCloseRequested` não são mais necessárias.
Remova essas chamadas.

Além disso, se a sua lógica dependia de o `onClose` do pai
ser disparado antes dos descendentes, refatore o código para
levar em conta a nova ordem de execução de baixo para cima.

Código antes da migração:

```dart
RawMenuAnchor(
  controller: menuController,
  onCloseRequested: (hideOverlay) {
    if (!animationController.isForwardOrCompleted) {
      return;
    }

    // Descendant submenus must be closed before the parent menu.
    // This is now handled automatically, so this call is no longer necessary.
    menuController.closeChildren();
    animationController.reverse().whenComplete(hideOverlay);
  },
  onClose: () {
    // This might have executed before descendants called onClose().
    _handleMenuClosed();
  },
  // ...
)
```

Código após a migração:

```dart
RawMenuAnchor(
  controller: menuController,
  onCloseRequested: (hideOverlay) {
    if (!animationController.isForwardOrCompleted) {
      return;
    }

    // `menuController.closeChildren()` is now called automatically.
    animationController.reverse().whenComplete(hideOverlay);
  },
  onClose: () {
    // This now executes only after all descendant submenus have
    // called `onClose()`.
    _handleMenuClosed();
  },
  // ...
)
```

:::important
Esta migração não é suportada pelo `dart fix`
:::

## Linha do tempo {:#timeline}

Incluído na versão: 3.44.0-0.1.pre<br>
Na versão estável: 3.44

## Referências {:#references}

Documentação da API:

* [`RawMenuAnchor`][`RawMenuAnchor`]
* [`RawMenuAnchor.onCloseRequested`][`RawMenuAnchor.onCloseRequested`]

Issues relevantes:

* [[widgets/raw_menu_anchor.dart] onClose deve ser chamado pelos menus descendentes antes do pai][issue-182355]

PRs relevantes:

* [[widgets/raw_menu_anchor.dart] Sempre chamar onClose e onCloseRequested nos descendentes antes do pai.][pr-182357]

[`RawMenuAnchor`]: {{site.api}}/flutter/widgets/RawMenuAnchor-class.html
[`RawMenuAnchor.onCloseRequested`]: {{site.api}}/flutter/widgets/RawMenuAnchor/onCloseRequested.html
[issue-182355]: {{site.repo.flutter}}/issues/182355
[pr-182357]: {{site.repo.flutter}}/pull/182357
