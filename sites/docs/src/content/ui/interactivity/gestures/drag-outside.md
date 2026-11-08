---
ia-translate: true
title: Arrastar para fora de um app
description: Como arrastar de um app para outro app ou o sistema operacional.
---

Você pode querer implementar
drag and drop em algum lugar do seu app.

Você tem algumas abordagens potenciais
que pode adotar. Uma usa diretamente
widgets Flutter e a outra usa um package
([super_drag_and_drop][super_drag_and_drop]), disponível no [pub.dev][pub.dev].

[pub.dev]: {{site.pub}}
[super_drag_and_drop]: {{site.pub-pkg}}/super_drag_and_drop

## Criar widgets arrastáveis dentro do seu app

Se você quiser implementar drag and drop dentro
da sua aplicação, pode usar o widget [`Draggable`][`Draggable`].
Para entender essa abordagem, veja
a receita [Arrastar um elemento de UI dentro de um app][Drag a UI element within an app].

Uma vantagem de usar `Draggable` e `DragTarget` é
que você pode fornecer código Dart para decidir se aceita um drop.

Para mais informações, confira o
vídeo [widget of the week do `Draggable`][video].

[Drag a UI element within an app]: /cookbook/effects/drag-a-widget
[`Draggable`]:  {{site.api}}/flutter/widgets/Draggable-class.html
[`DragTarget`]: {{site.api}}/flutter/widgets/DragTarget-class.html
[local data]: {{site.pub-api}}/super_drag_and_drop/latest/super_drag_and_drop/DragItem/localData.html
[video]: https://youtu.be/q4x2G_9-Mu0?si=T4679e90U2yrloCs

## Implementar drag and drop entre apps

Se você quiser implementar drag and drop dentro
da sua aplicação e _também_ entre sua
aplicação e outra aplicação (possivelmente não-Flutter),
confira o package [super_drag_and_drop][super_drag_and_drop].

Para evitar implementar dois estilos de drag and drop,
um para drags fora do app e outro para
arrastar dentro do app,
você pode fornecer [local data][local data] ao package para
realizar drags dentro do seu app.

Outra diferença entre essa abordagem e
usar `Draggable` diretamente,
é que você deve dizer ao package antecipadamente
quais dados seu app aceita porque as APIs de plataforma
precisam de uma resposta síncrona, o que não
permite uma resposta assíncrona do framework.

Uma vantagem de usar essa abordagem é que ela
funciona em desktop, mobile, _e_ web.
