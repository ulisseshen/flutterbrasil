---
ia-translate: true
title: Animações implícitas
description: Onde encontrar mais informações sobre o uso de animações implícitas no Flutter.
---

Com a [biblioteca de animação][animation library] do Flutter,
você pode adicionar movimento e criar efeitos visuais
para os widgets em sua UI.
Uma parte da biblioteca é um conjunto de widgets
que gerenciam animações para você.
Esses widgets são coletivamente referidos como _animações implícitas_,
ou _widgets implicitamente animados_, derivando seu nome da
classe [`ImplicitlyAnimatedWidget`][`ImplicitlyAnimatedWidget`] que eles implementam.
O seguinte conjunto de recursos fornece muitas maneiras de aprender
sobre animações implícitas no Flutter.

## Documentation

[Codelab de Animações no Flutter][Animations in Flutter codelab]
: Aprenda sobre animações implícitas e explícitas
  e ganhe experiência prática adicionando animações implícitas
  a um app Flutter completo.

[Exemplo de `AnimatedContainer`][`AnimatedContainer` sample]
: Uma receita passo a passo para usar o
  widget implicitamente animado [`AnimatedContainer`][`AnimatedContainer`].

Página da API [`ImplicitlyAnimatedWidget`][`ImplicitlyAnimatedWidget`]
: Todas as animações implícitas estendem a classe `ImplicitlyAnimatedWidget`.

[Animations in Flutter codelab]: {{site.codelabs}}/advanced-flutter-animations
[`AnimatedContainer` sample]: /cookbook/animation/animated-container
[`ImplicitlyAnimatedWidget`]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html

## Flutter in Focus videos

Os vídeos Flutter in Focus apresentam tutoriais de 5 a 10 minutos
com código real que cobrem técnicas
que todo desenvolvedor Flutter precisa saber de cima a baixo.
Os seguintes vídeos cobrem tópicos
que são relevantes para animações implícitas.

<YouTubeEmbed id="IVTjpW3W33s" title="Flutter implicit animation basics"></YouTubeEmbed>

<YouTubeEmbed id="6KiPEqzJIKQ" title="Create custom implicit animations with TweenAnimationBuilder"></YouTubeEmbed>

## The Boring Show

Assista ao Boring Show para acompanhar Engenheiros do Google construindo apps
do zero no Flutter. O seguinte episódio cobre
o uso de animações implícitas em um app agregador de notícias.

<YouTubeEmbed id="8ehlWchLVlQ" title="Adding implicit animations to a news application"></YouTubeEmbed>

## Widget of the Week videos

Uma série semanal de vídeos animados curtos, cada um mostrando
as características importantes de um widget específico.
Em cerca de 60 segundos, você verá código real para cada
widget com uma demonstração sobre como ele funciona.
Os seguintes vídeos Widget of the Week cobrem
widgets implicitamente animados:

{% assign animatedWidgets = 'AnimatedOpacity, AnimatedPadding, AnimatedPositioned, AnimatedSwitcher' | split: ", " %}
{% assign animatedUrls = 'QZAvjqOqiLY, PY2m0fhGNz4, hC3s2YdtWt8, 2W7POjFb88g' | split: ", " %}

{% for widget in animatedWidgets %}
{% assign videoUrl = animatedUrls[forloop.index0] %}
{% assign videoDescription = 'Learn about the ' | append: widget | append: ' Flutter Widget' %}

<YouTubeEmbed id="{{ videoUrl }}" title="{{ videoDescription }}"></YouTubeEmbed>

{% endfor -%}

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[animation library]: {{site.api}}/flutter/animation/animation-library.html
