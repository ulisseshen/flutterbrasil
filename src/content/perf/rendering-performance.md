---
ia-translate: true
title: Melhorando o desempenho de renderização
description: Como medir e avaliar o desempenho de renderização do seu aplicativo.
---

{% render docs/performance.md %}

Renderizar animações no seu aplicativo é um dos tópicos de maior interesse quando se trata de medir o desempenho. Graças em parte ao motor Skia do Flutter e à sua capacidade de criar e descartar widgets rapidamente, os aplicativos Flutter têm um bom desempenho por padrão, então você só precisa evitar armadilhas comuns para alcançar um desempenho excelente.

## Conselho geral

Se você vir animações instáveis (não suaves), **certifique-se** de que está fazendo o perfil de desempenho com um aplicativo construído no modo _profile_. A construção padrão do Flutter cria um aplicativo no modo _debug_, o que não é indicativo do desempenho de lançamento. Para mais informações, veja [Modos de construção do Flutter][].

Algumas armadilhas comuns:

* Reconstruir muito mais da UI do que o esperado a cada frame. Para rastrear reconstruções de widget, veja [Exibir dados de desempenho][].
* Construir uma grande lista de filhos diretamente, em vez de usar um ListView.

Para mais informações sobre como avaliar o desempenho, incluindo informações sobre armadilhas comuns, veja os seguintes documentos:

* [Melhores práticas de desempenho][]
* [Perfil de desempenho do Flutter][]

## Conselho apenas para dispositivos móveis

Você vê jank notável no seu aplicativo móvel, mas apenas na primeira execução de uma animação? Se sim, veja [Reduzir o jank de animação de shader em dispositivos móveis][].

[Reduzir o jank de animação de shader em dispositivos móveis]: /perf/shader

## Conselho apenas para Web

A seguinte série de artigos aborda o que a equipe do Flutter Material aprendeu ao melhorar o desempenho do aplicativo Flutter Gallery na web:

* [Otimizando o desempenho em aplicativos web Flutter com tree shaking e carregamento diferido][shaking]
* [Melhorando o desempenho percebido com placeholders de imagem, pré-cache e transições de navegação desativadas][images]
* [Construindo widgets Flutter com bom desempenho][]


[Construindo widgets Flutter com bom desempenho]: {{site.flutter-medium}}/building-performant-flutter-widgets-3b2558aa08fa
[Modos de construção do Flutter]: /testing/build-modes
[Perfil de desempenho do Flutter]: /perf/ui-performance
[images]: {{site.flutter-medium}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[Melhores práticas de desempenho]: /perf/best-practices
[shaking]: {{site.flutter-medium}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[Exibir dados de desempenho]: /tools/android-studio#show-performance-data
