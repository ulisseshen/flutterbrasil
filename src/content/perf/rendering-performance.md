---
ia-translate: true
title: Melhorando o desempenho de renderização
description: Como medir e avaliar o desempenho de renderização do seu app.
---

{% render docs/performance.md %}

Renderizar animações no seu app é um dos tópicos
mais citados de interesse quando se trata de medir desempenho.
Graças em parte ao motor Skia do Flutter e sua capacidade
de criar e descartar widgets rapidamente,
aplicações Flutter são performantes por padrão,
então você só precisa evitar armadilhas comuns para alcançar
excelente desempenho.

## Conselho geral

Se você vê animações travadas (não suaves), tenha
**certeza** de que você está criando um perfil de desempenho com um
app construído em modo _profile_.
O build padrão do Flutter cria um app em modo _debug_,
que não é indicativo do desempenho de release.
Para informações,
veja [modos de build do Flutter][Flutter's build modes].

Algumas armadilhas comuns:

* Reconstruir muito mais da UI do que esperado em cada frame.
  Para rastrear reconstruções de widgets, veja [Show performance data][].
* Construir uma lista grande de filhos diretamente, em vez de
  usar um ListView.

Para mais informações sobre avaliação de desempenho
incluindo informações sobre armadilhas comuns,
veja os seguintes documentos:

* [Performance best practices][]
* [Flutter performance profiling][]

## Conselho apenas para mobile

Você vê jank notável no seu app mobile, mas apenas na primeira execução de uma
animação? Para evitar isso, certifique-se de que está usando o
renderizador gráfico padrão do Flutter, [Impeller][].

[Impeller]: /perf/impeller

## Conselho apenas para web

A seguinte série de artigos cobre o que a equipe
Flutter Material aprendeu ao melhorar o desempenho do app Flutter Gallery
na web:

* [Optimizing performance in Flutter web apps with tree shaking and deferred loading][shaking]
* [Improving perceived performance with image placeholders, precaching, and disabled navigation transitions][images]
* [Building performant Flutter widgets][]


[Building performant Flutter widgets]: {{site.flutter-medium}}/building-performant-flutter-widgets-3b2558aa08fa
[Flutter's build modes]: /testing/build-modes
[Flutter performance profiling]: /perf/ui-performance
[images]: {{site.flutter-medium}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[Performance best practices]: /perf/best-practices
[shaking]: {{site.flutter-medium}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[Show performance data]: /tools/android-studio#show-performance-data
