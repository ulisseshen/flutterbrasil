---
ia-translate: true
title: Removendo Notification.visitAncestor
description: >
  Notificações agora percorrem apenas ancestrais que são listeners de notificação.
---

## Resumo

As notificações são mais eficientes percorrendo apenas os ancestrais que
são *listeners* de notificação.

## Contexto

A API de notificação percorria a árvore de elementos para localizar um
receptor de notificação. Isso levava a algumas características de
desempenho desfavoráveis:

  * Se não houvesse receptor para um determinado tipo de notificação, toda
    a árvore de elementos acima do ponto de envio da notificação seria
    percorrida e o tipo verificado.
  * Para várias notificações em um determinado *frame* (o que é comum para
    *scroll views*), acabávamos percorrendo a árvore de elementos várias
    vezes.

Se houvesse múltiplas *scroll views* ou *scroll views* aninhadas em uma
determinada página, a situação piorava significativamente - cada *scroll
view* enviaria várias notificações por *frame*. Por exemplo, na página
do *flamegraph* do Dart/Flutter Devtools, descobrimos que cerca de 30% do
tempo da CPU era gasto no envio de notificações.

Para reduzir o custo de envio de notificações, mudamos o envio de
notificação para que ele visite apenas os ancestrais que são *listeners*
de notificação, reduzindo o número de elementos visitados por *frame*.

No entanto, o antigo sistema de notificação expôs o fato de que ele
percorria cada elemento como parte de sua API através de
`Notification.visitAncestor`. Este método não é mais suportado, pois não
visitamos mais todos os elementos ancestrais.

## Descrição da mudança

`Notification.visitAncestor` foi removido. Quaisquer classes que estendam
`Notification` não devem mais sobrescrever este método.

**Se você não implementar uma `Notification` customizada que sobrescreva
`Notification.visitAncestor`, então nenhuma mudança é necessária.**

## Guia de migração

Se você tiver uma subclasse de `Notification` que sobrescreva
`Notification.visitAncestor`, então você deve deletar a sobrescrita ou
optar pelo envio de notificação no estilo antigo com o seguinte código.

Código antes da migração:

```dart
import 'package:flutter/widgets.dart';

class MyNotification extends Notification {

  @override
  bool visitAncestor(Element element) {
    print('Visitando $element');
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
    print('Visitando $element');
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

Observe que isso tem um desempenho ruim em comparação com o novo
comportamento padrão de `Notification.dispatch`.

## Linha do tempo

Implementado na versão: 2.12.0-4.1<br>
Na versão estável: 3.0.0

## Referências

Documentação da API:

*   [`Notification`]({{site.api}}/flutter/widgets/Notification-class.html)

*Issues* relevantes:

*   [Issue 97849]({{site.repo.flutter}}/issues/97849)

*PRs* relevantes:

*   [melhorar o desempenho da API de notificação]({{site.repo.flutter}}/pull/98451)
