---
ia-translate: true
title: Removendo Notification.visitAncestor
description: >
  Notifications apenas percorrem ancestrais que são notification listeners.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Notifications são mais eficientes ao percorrer apenas ancestrais que
são notification listeners.

## Contexto

A API de notification percorria a árvore de elements para localizar um
receptor de notification. Isso levou a algumas características de desempenho
infelizes:

  * Se não houvesse receptor para um determinado tipo de notification, toda a árvore de
    elements acima do ponto de despacho da notification seria percorrida e verificada
    quanto ao tipo.
  * Para múltiplas notifications em um determinado frame (o que é comum para scroll
    views) acabávamos percorrendo a árvore de elements várias vezes.

Se houvesse múltiplas ou scroll views aninhadas em uma determinada página, a situação
piorava significativamente - cada scroll view despacharia múltiplas
notifications por frame. Por exemplo, na página flamegraph do Dart/Flutter Devtools,
descobrimos que cerca de 30% do tempo de CPU era gasto despachando notifications.

Para reduzir o custo de despachar notifications, mudamos
o despacho de notifications para que ele visite apenas ancestrais que são notification
listeners, reduzindo o número de elements visitados por frame.

No entanto, o antigo sistema de notifications expunha o fato de que percorria
cada element como parte de sua API via `Notification.visitAncestor`. Este
método não é mais suportado já que não visitamos mais todos os elements ancestrais.

## Descrição da mudança

`Notification.visitAncestor` foi removido.
Quaisquer classes que estendem `Notification` não devem mais
sobrescrever este método.

**Se você não implementa uma Notification customizada
que sobrescreve `Notification.visitAncestor`,
então nenhuma mudança é necessária.**

## Guia de migração

Se você tem uma subclasse de `Notification` que sobrescreve
`Notification.visitAncestor`, então você deve deletar a sobrescrita ou
optar pelo despacho de notifications no estilo antigo com o seguinte código.

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

Note que isso tem desempenho ruim comparado ao
novo comportamento padrão de `Notification.dispatch`.

## Cronograma

Landed in version: 2.12.0-4.1<br>
In stable release: 3.0.0

## Referências

Documentação da API:

* [`Notification`]({{site.api}}/flutter/widgets/Notification-class.html)

Issues relevantes:

* [Issue 97849]({{site.repo.flutter}}/issues/97849)

PRs relevantes:

* [improve Notification API performance]({{site.repo.flutter}}/pull/98451)
