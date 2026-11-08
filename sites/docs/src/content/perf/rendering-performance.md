---
ia-translate: true
title: Melhorando a performance de renderização
description: Como medir e avaliar a performance de renderização do seu app.
---

{% render "docs/performance.md" %}

Renderizar animações em seu app é um dos tópicos mais citados
de interesse quando se trata de medir performance.
Graças em parte ao engine Skia do Flutter e sua capacidade
de criar e descartar widgets rapidamente,
aplicações Flutter são performáticas por padrão,
então você só precisa evitar armadilhas comuns para alcançar
excelente performance.

## Conselhos gerais

Se você vê animações travadas (não suaves), certifique-se
de que você está fazendo profiling de performance com um
app construído em modo _profile_.
O build padrão do Flutter cria um app em modo _debug_,
que não é indicativo de performance de release.
Para informações,
veja [modos de build do Flutter][Flutter's build modes].

Algumas armadilhas comuns:

* Reconstruir muito mais da UI do que o esperado em cada frame.
  Para rastrear rebuilds de widgets, veja [Mostrar dados de performance][Show performance data].
* Construir uma lista grande de filhos diretamente, ao invés de
  usar um ListView.

Para mais informações sobre avaliar performance
incluindo informações sobre armadilhas comuns,
veja os seguintes docs:

* [Melhores práticas de performance][Performance best practices]
* [Profiling de performance do Flutter][Flutter performance profiling]

## Conselhos apenas para mobile

Você vê jank notável no seu app mobile, mas apenas na primeira execução de uma
animação? Para evitar isso, certifique-se de que está usando o
renderizador gráfico padrão do Flutter, [Impeller][Impeller].

[Impeller]: /perf/impeller

## Conselhos apenas para web

A seguinte série de artigos cobre o que a equipe Flutter Material
aprendeu ao melhorar a performance do app Flutter Gallery
na web:

* [Otimizando performance em apps Flutter web com tree shaking e deferred loading][shaking]
* [Melhorando a performance percebida com placeholders de imagem, pré-caching e transições de navegação desabilitadas][images]
* [Construindo widgets Flutter performáticos][Building performant Flutter widgets]


[Building performant Flutter widgets]: {{site.flutter-blog}}/building-performant-flutter-widgets-3b2558aa08fa
[Flutter's build modes]: /testing/build-modes
[Flutter performance profiling]: /perf/ui-performance
[images]: {{site.flutter-blog}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[Performance best practices]: /perf/best-practices
[shaking]: {{site.flutter-blog}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[Show performance data]: /tools/android-studio#show-performance-data
