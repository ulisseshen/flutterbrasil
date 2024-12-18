---
ia-translate: true
title: Animações implícitas
description: Onde encontrar mais informações sobre como usar animações implícitas no Flutter.
---

Com a [biblioteca de animação][] do Flutter,
você pode adicionar movimento e criar efeitos visuais
para os widgets em sua interface de usuário.
Uma parte da biblioteca é um conjunto de widgets
que gerenciam animações para você.
Esses widgets são coletivamente chamados de _animações implícitas_,
ou _widgets implicitamente animados_, derivando seu nome da
classe [`ImplicitlyAnimatedWidget`][] que eles implementam.
O seguinte conjunto de recursos fornece muitas maneiras de aprender
sobre animações implícitas no Flutter.

## Documentação

[Codelab de animações implícitas][]
: Vá direto para o código!
  Este codelab usa exemplos interativos
  e instruções passo a passo para ensinar você
  como usar animações implícitas.

[Exemplo de `AnimatedContainer`][]
: Uma receita passo a passo do [livro de receitas do Flutter][]
  para usar o widget implicitamente animado
  [`AnimatedContainer`][].

Página da API [`ImplicitlyAnimatedWidget`][]
: Todas as animações implícitas estendem a classe `ImplicitlyAnimatedWidget`.

## Vídeos Flutter in Focus

Os vídeos Flutter in Focus apresentam tutoriais de 5 a 10 minutos
com código real que abordam técnicas
que todo desenvolvedor Flutter precisa conhecer de cima a baixo.
Os vídeos a seguir abordam tópicos
relevantes para animações implícitas.

{% ytEmbed 'IVTjpW3W33s', 'Conceitos básicos de animação implícita do Flutter' %}

{% ytEmbed '6KiPEqzJIKQ', 'Crie animações implícitas personalizadas com TweenAnimationBuilder' %}

## The Boring Show

Assista ao Boring Show para acompanhar os engenheiros do Google construindo aplicativos
do zero no Flutter. O seguinte episódio aborda
o uso de animações implícitas em um aplicativo agregador de notícias.

{% ytEmbed '8ehlWchLVlQ', 'Adicionando animações implícitas a um aplicativo de notícias' %}

## Vídeos Widget da Semana

Uma série semanal de vídeos curtos animados, cada um mostrando
os recursos importantes de um widget em particular.
Em cerca de 60 segundos, você verá o código real de cada
widget com uma demonstração de como ele funciona.
Os seguintes vídeos Widget da Semana abordam
widgets implicitamente animados:

{% assign animated-widgets = 'AnimatedOpacity, AnimatedPadding, AnimatedPositioned, AnimatedSwitcher' | split: ", " %}
{% assign animated-urls = 'QZAvjqOqiLY, PY2m0fhGNz4, hC3s2YdtWt8, 2W7POjFb88g' | split: ", " %}

{% for widget in animated-widgets %}
{% assign videoUrl = animated-urls[forloop.index0] %}
{% assign videoDescription = 'Aprenda sobre o ' | append: widget | append: ' Widget do Flutter' %}

{% ytEmbed videoUrl, videoDescription %}

{% endfor -%}

[Exemplo de `AnimatedContainer`]: /cookbook/animation/animated-container
[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[biblioteca de animação]: {{site.api}}/flutter/animation/animation-library.html
[livro de receitas do Flutter]: /cookbook
[Codelab de animações implícitas]: /codelabs/implicit-animations
[`ImplicitlyAnimatedWidget`]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
