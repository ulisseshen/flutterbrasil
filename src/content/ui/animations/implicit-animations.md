---
title: Animações implícitas
description: Onde encontrar mais informações sobre o uso de animações implícitas no Flutter.
ia-translate: true
---

Com a [animation library][] do Flutter,
você pode adicionar movimento e criar efeitos visuais
para os widgets na sua UI.
Uma parte da biblioteca é um conjunto de widgets
que gerenciam animações para você.
Esses widgets são coletivamente chamados de _animações implícitas_,
ou _widgets implicitamente animados_, derivando seu nome da
classe [`ImplicitlyAnimatedWidget`][] que eles implementam.
O conjunto de recursos a seguir fornece muitas maneiras de aprender
sobre animações implícitas no Flutter.

## Documentação

[Implicit animations codelab][]
: Mergulhe direto no código!
  Este codelab usa exemplos interativos
  e instruções passo a passo para ensinar você
  a usar animações implícitas.

[`AnimatedContainer` sample][]
: Uma receita passo a passo do [Flutter cookbook][]
  para usar o widget implicitamente animado
  [`AnimatedContainer`][].

[`ImplicitlyAnimatedWidget`][] API page
: Todas as animações implícitas estendem a classe `ImplicitlyAnimatedWidget`.

## Vídeos Flutter in Focus

Os vídeos Flutter in Focus apresentam tutoriais de 5 a 10 minutos
com código real que cobrem técnicas
que todo desenvolvedor Flutter precisa saber de cima a baixo.
Os vídeos a seguir cobrem tópicos
relevantes para animações implícitas.

{% ytEmbed 'IVTjpW3W33s', 'Flutter implicit animation basics' %}

{% ytEmbed '6KiPEqzJIKQ', 'Create custom implicit animations with TweenAnimationBuilder' %}

## The Boring Show

Assista ao Boring Show para acompanhar engenheiros do Google construindo aplicativos
do zero no Flutter. O episódio a seguir cobre
o uso de animações implícitas em um aplicativo agregador de notícias.

{% ytEmbed '8ehlWchLVlQ', 'Adding implicit animations to a news application' %}

## Vídeos Widget of the Week

Uma série semanal de vídeos animados curtos, cada um mostrando
os recursos importantes de um widget específico.
Em cerca de 60 segundos, você verá código real para cada
widget com uma demonstração de como ele funciona.
Os vídeos Widget of the Week a seguir cobrem
widgets implicitamente animados:

{% assign animated-widgets = 'AnimatedOpacity, AnimatedPadding, AnimatedPositioned, AnimatedSwitcher' | split: ", " %}
{% assign animated-urls = 'QZAvjqOqiLY, PY2m0fhGNz4, hC3s2YdtWt8, 2W7POjFb88g' | split: ", " %}

{% for widget in animated-widgets %}
{% assign videoUrl = animated-urls[forloop.index0] %}
{% assign videoDescription = 'Learn about the ' | append: widget | append: ' Flutter Widget' %}

{% ytEmbed videoUrl, videoDescription %}

{% endfor -%}

[`AnimatedContainer` sample]: /cookbook/animation/animated-container
[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[Flutter cookbook]: /cookbook
[Implicit animations codelab]: /codelabs/implicit-animations
[`ImplicitlyAnimatedWidget`]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
