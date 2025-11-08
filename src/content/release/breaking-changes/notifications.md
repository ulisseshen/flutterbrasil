---
title: Removing Notification.visitAncestor
description: >
  Notifications only traverse ancestors that are notification listeners.
ia-translate: true
---

## Resumo

Notifications are more efficient by traversing only ancestors that
are notification listeners.

## Contexto

The notification API traversed the element tree in order to locate a
notification receiver. This led to some unfortunate performance
characteristics:

  * If there was no receiver for a given notification type, the entire element
    tree above the notification dispatch point would be traversed and type
    checked.
  * For multiple notifications in a given frame (which is common for scroll
    views) we ended up traversing the element tree multiple times.

If there were multiple or nested scroll views on a given page, the situation
was worsened significantly - each scroll view would dispatch multiple
notifications per frame. For example, in the Dart/Flutter Devtools flamegraph
page, we found that about 30% of CPU time was spent dispatching notifications.

In order to reduce the cost of dispatching notifications, we have changed
notification dispatch so that it only visits ancestors that are notification
listeners, reducing the number of elements visited per frame.

However, the old notification system exposed the fact that it traversed
each element as part of its API via `Notification.visitAncestor`. This
method is no longer supported as we no longer visit all ancestor elements.

## Descrição da mudança

`Notification.visitAncestor` has been removed.
Any classes that extend `Notification` should
no longer override this method.

**If you don't implement a custom Notification
that overrides `Notification.visitAncestor`,
then no changes are required.**

## Guia de migração

If you have a subclass of `Notification` that overrides
`Notification.visitAncestor`, then you must either delete the override or
opt-into old style notification dispatch with the following code.

Código antes da migração:

```dart
import 'package:flutter/widgets.dart';

class MyNotification extends Notification {

  @override
  bool visitAncestor(Element element) {
    print('Visiting $element');
    return super.visitAncestor(element);
  }
}

void methodThatSendsNotification(BuildContext? context) {
  MyNotification().dispatch(context);
}
```

Código após a migração:

```dart
import 'package:flutter/widgets.dart';

class MyNotification extends Notification {

  bool visitAncestor(Element element) {
    print('Visiting $element');
    if (element is ProxyElement) {
      final Widget widget = element.widget;
      if (widget is NotificationListener<MyNotification>) {
        return widget.onNotification?.call(notification) ?? true;
      }
    }
    return true;
  }
}

void methodThatSendsNotification(BuildContext? context) {
  context?.visitAncestor(MyNotification().visitAncestor);
}
```

Note that this performs poorly compared to the
new default behavior of `Notification.dispatch`.

## Linha do tempo

Lançado na versão: 2.12.0-4.1<br>
Na versão estável: 3.0.0

## Referências

Documentação da API:

* [`Notification`]({{site.api}}/flutter/widgets/Notification-class.html)

Issues relevantes:

* [Issue 97849]({{site.repo.flutter}}/issues/97849)

PRs relevantes:

* [improve Notification API performance]({{site.repo.flutter}}/pull/98451)
