---
ia-translate: true
title: Scrolling
description: Visão geral do suporte de scrolling do Flutter
---

O Flutter possui muitos widgets embutidos que fazem o
scrolling automaticamente e também oferece uma variedade
de widgets que você pode customizar para criar um
comportamento de scrolling específico.

## Scrolling Básico

Muitos widgets do Flutter suportam scrolling
imediatamente e fazem a maior parte do trabalho para
você. Por exemplo, [`SingleChildScrollView`][] rola
automaticamente seu filho quando necessário. Outros
widgets úteis incluem [`ListView`][] e [`GridView`][].
Você pode verificar mais desses widgets na [página de
scrolling][] do catálogo de Widgets.

{% ytEmbed 'DbkIQSvwnZc', 'Scrollbar | Flutter widget of the week' %}

{% ytEmbed 'KJpkjHGiI5A', 'ListView | Flutter widget of the week' %}

### Scrolling Infinito

Quando você tem uma longa lista de itens em seu
`ListView` ou `GridView` (incluindo uma lista _infinita_),
você pode construir os itens sob demanda conforme eles
rolam para a visualização. Isso proporciona uma experiência
de rolagem muito mais eficiente. Para mais informações,
confira [`ListView.builder`][] ou [`GridView.builder`][].

[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`GridView.builder`]: {{site.api}}/flutter/widgets/GridView/GridView.builder.html

### Widgets de Scrolling Especializados

Os seguintes widgets fornecem um comportamento de
scrolling mais específico.

Um vídeo sobre como usar [`DraggableScrollableSheet`][]:

{% ytEmbed 'Hgw819mL_78', 'DraggableScrollableSheet | Flutter widget of the week' %}

Transforme a área rolável em uma roda com
[`ListWheelScrollView`][]!

{% ytEmbed 'dUhmWAz4C7Y', 'ListWheelScrollView | Flutter widget of the week' %}

[`DraggableScrollableSheet`]: {{site.api}}/flutter/widgets/DraggableScrollableSheet-class.html
[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListWheelScrollView`]: {{site.api}}/flutter/widgets/ListWheelScrollView-class.html
[página de scrolling]: /ui/widgets/scrolling
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

{% comment %}
  Ainda não, mas chegando. Scrolling bidimensional:
  TableView e TreeView.
  Video: {{site.yt.watch}}?v=UDZ0LPQq-n8
{% endcomment %}

## Scrolling Elaborado

Talvez você queira implementar o scrolling _elástico_, também
chamado de _scroll bouncing_. Ou talvez você queira
implementar outros efeitos de scrolling dinâmicos, como o
scrolling parallax. Ou talvez você queira um cabeçalho de
scrolling com comportamento muito específico, como encolher
ou desaparecer.

Você pode conseguir tudo isso e muito mais usando as classes
`Sliver*` do Flutter. Um _sliver_ se refere a um pedaço
da área rolável. Você pode definir e inserir um sliver
em um [`CustomScrollView`][] para ter um controle mais
refinado sobre essa área.

Para mais informações, confira [Usando slivers para
obter scrolling elaborado][] e as [Sliver classes][].

[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[Sliver classes]: /ui/widgets/layout#sliver-widgets
[Usando slivers para obter scrolling elaborado]: /ui/layout/scrolling/slivers

## Widgets de Scrolling Aninhados

Como você aninha um widget de scrolling
dentro de outro widget de scrolling sem prejudicar o
desempenho do scrolling? Você define a propriedade
`ShrinkWrap` para true ou usa um sliver?

Confira o vídeo "ShrinkWrap vs Slivers":

{% ytEmbed 'LUqDNnv_dh0', 'ShrinkWrap vs Slivers | Decoding Flutter' %}
