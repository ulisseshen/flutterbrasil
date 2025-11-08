---
title: Rolagem
description: Visão geral do suporte de rolagem do Flutter
ia-translate: true
---

O Flutter tem muitos widgets integrados que rolam automaticamente
e também oferece uma variedade de widgets
que você pode personalizar para criar comportamentos de rolagem específicos.

## Rolagem básica

Muitos widgets do Flutter suportam rolagem imediatamente
e fazem a maior parte do trabalho para você. Por exemplo,
[`SingleChildScrollView`][] rola automaticamente seu
filho quando necessário. Outros widgets úteis incluem
[`ListView`][] e [`GridView`][].
Você pode conferir mais desses widgets na
[página de rolagem][] do catálogo de Widgets.

{% ytEmbed 'DbkIQSvwnZc', 'Scrollbar | Flutter widget of the week' %}

{% ytEmbed 'KJpkjHGiI5A', 'ListView | Flutter widget of the week' %}

### Rolagem infinita

Quando você tem uma longa lista de itens
em seu `ListView` ou `GridView` (incluindo uma lista _infinita_),
você pode construir os itens sob demanda
conforme eles rolam para a visualização. Isso fornece uma
experiência de rolagem muito mais eficiente.
Para mais informações, confira
[`ListView.builder`][] ou [`GridView.builder`][].

[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`GridView.builder`]: {{site.api}}/flutter/widgets/GridView/GridView.builder.html

### Widgets roláveis especializados

Os seguintes widgets fornecem
comportamentos de rolagem mais específicos.

Um vídeo sobre o uso de [`DraggableScrollableSheet`][]:

{% ytEmbed 'Hgw819mL_78', 'DraggableScrollableSheet | Flutter widget of the week' %}

Transforme a área rolável em uma roda com [`ListWheelScrollView`][]!

{% ytEmbed 'dUhmWAz4C7Y', 'ListWheelScrollView | Flutter widget of the week' %}

[`DraggableScrollableSheet`]: {{site.api}}/flutter/widgets/DraggableScrollableSheet-class.html
[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListWheelScrollView`]: {{site.api}}/flutter/widgets/ListWheelScrollView-class.html
[página de rolagem]: /ui/widgets/scrolling
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

{% comment %}
  Ainda não, mas em breve. Rolagem bidimensional:
  TableView e TreeView.
  Vídeo: {{site.yt.watch}}?v=UDZ0LPQq-n8
{% endcomment %}

## Rolagem sofisticada

Talvez você queira implementar rolagem _elástica_,
também chamada de _scroll bouncing_. Ou talvez você queira
implementar outros efeitos de rolagem dinâmicos, como rolagem paralaxe.
Ou talvez você queira um cabeçalho de rolagem com comportamento muito específico,
como encolher ou desaparecer.

Você pode conseguir tudo isso e muito mais usando as
classes `Sliver*` do Flutter.
Um _sliver_ refere-se a uma parte da área rolável.
Você pode definir e inserir um sliver em um [`CustomScrollView`][]
para ter controle mais refinado sobre essa área.

Para mais informações, confira
[Usando slivers para obter rolagem sofisticada][]
e as [classes Sliver][].

[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[classes Sliver]: /ui/widgets/layout#widgets-sliver
[Usando slivers para obter rolagem sofisticada]: /ui/layout/scrolling/slivers

## Widgets de rolagem aninhados

Como você aninha um widget de rolagem
dentro de outro widget de rolagem
sem prejudicar o desempenho da rolagem?
Você define a propriedade `ShrinkWrap` como true,
ou usa um sliver?

Confira o vídeo "ShrinkWrap vs Slivers":

{% ytEmbed 'LUqDNnv_dh0', 'ShrinkWrap vs Slivers | Decoding Flutter' %}
