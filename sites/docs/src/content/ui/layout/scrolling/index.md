---
title: Rolagem
description: Visão geral do suporte à rolagem do Flutter
ia-translate: true
---

O Flutter possui muitos widgets integrados que fazem rolagem automaticamente
e também oferece uma variedade de widgets
que você pode personalizar para criar comportamentos
específicos de rolagem.

## Rolagem básica {:#basic-scrolling}

Muitos widgets do Flutter suportam rolagem prontos para uso
e fazem a maior parte do trabalho para você. Por exemplo,
[`SingleChildScrollView`][] faz rolagem automaticamente de seu
filho quando necessário. Outros widgets úteis incluem
[`ListView`][] e [`GridView`][].
Você pode conferir mais desses widgets na
[scrolling page][] do catálogo de Widgets.

<YouTubeEmbed id="DbkIQSvwnZc" title="Scrollbar | Flutter widget of the week"></YouTubeEmbed>

<YouTubeEmbed id="KJpkjHGiI5A" title="ListView | Flutter widget of the week"></YouTubeEmbed>

### Rolagem infinita {:#infinite-scrolling}

Quando você tem uma longa lista de itens
em seu `ListView` ou `GridView` (incluindo uma lista _infinita_),
você pode construir os itens sob demanda
conforme eles aparecem na visualização. Isso fornece uma
experiência de rolagem muito mais eficiente.
Para mais informações, confira
[`ListView.builder`][] ou [`GridView.builder`][].

[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`GridView.builder`]: {{site.api}}/flutter/widgets/GridView/GridView.builder.html

### Widgets roláveis especializados {:#specialized-scrollable-widgets}

Os seguintes widgets fornecem
comportamento de rolagem mais específico.

Um vídeo sobre o uso de [`DraggableScrollableSheet`][]:

<YouTubeEmbed id="Hgw819mL_78" title="DraggableScrollableSheet | Flutter widget of the week"></YouTubeEmbed>

Transforme a área rolável em uma roda com [`ListWheelScrollView`][]!

<YouTubeEmbed id="dUhmWAz4C7Y" title="ListWheelScrollView | Flutter widget of the week"></YouTubeEmbed>

[`DraggableScrollableSheet`]: {{site.api}}/flutter/widgets/DraggableScrollableSheet-class.html
[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListWheelScrollView`]: {{site.api}}/flutter/widgets/ListWheelScrollView-class.html
[scrolling page]: /ui/widgets/scrolling
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

{% comment %}
  Not yet, but coming. Two dimensional scrolling:
  TableView and TreeView.
  Video: {{site.yt.watch}}?v=UDZ0LPQq-n8
{% endcomment %}

## Rolagem sofisticada {:#fancy-scrolling}

Talvez você queira implementar rolagem _elástica_,
também chamada de _scroll bouncing_. Ou talvez você queira
implementar outros efeitos dinâmicos de rolagem, como rolagem paralaxe.
Ou talvez você queira um cabeçalho rolável com comportamento muito específico,
como encolher ou desaparecer.

Você pode alcançar tudo isso e muito mais usando as
classes `Sliver*` do Flutter.
Um _sliver_ refere-se a um pedaço da área rolável.
Você pode definir e inserir um sliver em um [`CustomScrollView`][]
para ter controle mais refinado sobre essa área.

Para mais informações, confira
[Using slivers to achieve fancy scrolling][]
e as [Sliver classes][].

[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[Sliver classes]: /ui/widgets/layout#sliver-widgets
[Using slivers to achieve fancy scrolling]: /ui/layout/scrolling/slivers

## Widgets roláveis aninhados {:#nested-scrolling-widgets}

Como você aninha um widget rolável
dentro de outro widget rolável
sem prejudicar o desempenho da rolagem?
Você define a propriedade `ShrinkWrap` como true,
ou você usa um sliver?

Confira o vídeo "ShrinkWrap vs Slivers":

<YouTubeEmbed id="LUqDNnv_dh0" title="ShrinkWrap vs Slivers | Decoding Flutter"></YouTubeEmbed>
