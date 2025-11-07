---
title: Arrastar para fora de um app
description: Como arrastar de um app para outro app ou o sistema operacional.
ia-translate: true
---

Você pode querer implementar
arrastar e soltar em algum lugar do seu app.

Você tem algumas abordagens potenciais
que pode adotar. Uma usa diretamente
widgets do Flutter e a outra usa um pacote
([super_drag_and_drop][]), disponível no [pub.dev][].

[pub.dev]: {{site.pub}}
[super_drag_and_drop]: {{site.pub-pkg}}/super_drag_and_drop

## Crie widgets arrastáveis dentro do seu app

Se você quiser implementar arrastar e soltar dentro
da sua aplicação, pode usar o widget [`Draggable`][].
Para ter uma visão desta abordagem, veja
a receita [Arraste um elemento de UI dentro de um app][Drag a UI element within an app].

Uma vantagem de usar `Draggable` e `DragTarget` é
que você pode fornecer código Dart para decidir se aceita um drop.

Para mais informações, confira o
vídeo [widget `Draggable` da semana][video].

[Drag a UI element within an app]: /cookbook/effects/drag-a-widget
[`Draggable`]:  {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[local data]: {{site.pub-api}}/super_drag_and_drop/latest/super_drag_and_drop/DragItem/localData.html
[video]: https://youtu.be/q4x2G_9-Mu0?si=T4679e90U2yrloCs

## Implemente arrastar e soltar entre apps

Se você quiser implementar arrastar e soltar dentro
da sua aplicação _e também_ entre sua
aplicação e outra (possivelmente não-Flutter) app,
confira o pacote [super_drag_and_drop][].

Para evitar implementar dois estilos de arrastar e soltar,
um para arrastos fora do app e outro para
arrastar dentro do app,
você pode fornecer [dados locais][local data] ao pacote para
realizar arrastos dentro do seu app.

Outra diferença entre esta abordagem e
usar `Draggable` diretamente,
é que você deve dizer ao pacote antecipadamente
quais dados seu app aceita porque as APIs da plataforma
precisam de uma resposta síncrona, o que não
permite uma resposta assíncrona do framework.

Uma vantagem de usar esta abordagem é que ela
funciona em desktop, mobile, _e_ web.
