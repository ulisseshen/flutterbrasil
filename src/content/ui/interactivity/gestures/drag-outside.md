---
ia-translate: true
title: Arrastar para fora de um app
description: Como arrastar de um aplicativo para outro ou para o sistema operacional.
---

Você pode querer implementar
arrastar e soltar em algum lugar do seu aplicativo.

Você tem algumas abordagens potenciais
que você pode adotar. Uma usa diretamente
widgets Flutter e a outra usa um pacote
([super_drag_and_drop][]), disponível em [pub.dev][].

[pub.dev]: {{site.pub}}
[super_drag_and_drop]: {{site.pub-pkg}}/super_drag_and_drop

## Criar widgets arrastáveis dentro do seu app

Se você deseja implementar arrastar e soltar dentro
do seu aplicativo, você pode usar o widget [`Draggable`][].
Para obter informações sobre essa abordagem, consulte
a receita [Arrastar um elemento de UI dentro de um app][].

Uma vantagem de usar `Draggable` e `DragTarget` é
que você pode fornecer código Dart para decidir se deve aceitar
uma soltura.

Para mais informações, confira o
vídeo [`Draggable` widget da semana][video].

[Arrastar um elemento de UI dentro de um app]: /cookbook/effects/drag-a-widget
[`Draggable`]:  {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[local data]: {{site.pub-api}}/super_drag_and_drop/latest/super_drag_and_drop/DragItem/localData.html
[video]: https://youtu.be/q4x2G_9-Mu0?si=T4679e90U2yrloCs

## Implementar arrastar e soltar entre apps

Se você deseja implementar arrastar e soltar dentro
do seu aplicativo e _também_ entre seu
aplicativo e outro aplicativo (possivelmente não-Flutter),
confira o pacote [super_drag_and_drop][].

Para evitar a implementação de dois estilos de arrastar e soltar,
um para arrastar para fora do aplicativo e outro para
arrastar dentro do aplicativo,
você pode fornecer [local data][] para o pacote para
realizar arrastos dentro do seu aplicativo.

Outra diferença entre esta abordagem e
usar `Draggable` diretamente,
é que você deve informar ao pacote antecipadamente
quais dados seu aplicativo aceita porque a plataforma
APIs precisam de uma resposta síncrona, o que não
permite uma resposta assíncrona do framework.

Uma vantagem de usar esta abordagem é que ela
funciona em desktop, mobile e _web_.
