---
ia-translate: true
title: Performance
description: Avaliando a performance do seu app de vários ângulos.
---

<YouTubeEmbed id="PKGguGUwSYE" title="Flutter performance tips | Flutter in Focus"></YouTubeEmbed>

:::note
Se seu app tem um problema de performance e você está
tentando depurá-lo, confira a página do DevTools
sobre [Usando a visualização Performance][Using the Performance view].
:::

[Using the Performance view]: /tools/devtools/performance

O que é performance? Por que performance é importante? Como eu melhoro a performance?

Nosso objetivo é responder essas três perguntas (principalmente a terceira),
e qualquer coisa relacionada a elas. Este documento deve servir como o único ponto de entrada
ou o nó raiz de uma árvore de recursos que aborda quaisquer questões
que você tenha sobre performance.

As respostas para as duas primeiras perguntas são principalmente filosóficas,
e não tão úteis para muitos desenvolvedores que visitam esta página com problemas
específicos de performance que precisam ser resolvidos.
Portanto, as respostas para essas
perguntas estão no [apêndice](/perf/appendix).

Para melhorar a performance, você primeiro precisa de métricas: alguns números mensuráveis para
verificar os problemas e melhorias.
Na página de [métricas](/perf/metrics),
você verá quais métricas são atualmente usadas,
e quais ferramentas e APIs estão disponíveis para obter as métricas.

Há uma lista de [Perguntas frequentes](/perf/faq),
para que você possa descobrir se as perguntas que você tem ou os problemas que está tendo
já foram respondidos ou encontrados, e se há soluções existentes.
(Alternativamente, você pode verificar o banco de dados de issues do GitHub do Flutter usando o
rótulo [performance][performance].)

Finalmente, os problemas de performance são divididos em quatro categorias. Eles
correspondem aos quatro rótulos que são usados no banco de dados de issues do GitHub do
Flutter: "[perf: speed][speed]", "[perf: memory][memory]",
"[perf: app size][size]", "[perf: energy][energy]".

O resto do conteúdo é organizado usando essas quatro categorias.

{% comment %}
Let's put "speed" (rendering) first as it's the most popular performance issue
category.
{% endcomment -%}

## Velocidade

Suas animações estão travadas (não suaves)? Aprenda como
avaliar e corrigir problemas de renderização.

[Melhorando a performance de renderização](/perf/rendering-performance)

{% comment %}
Do your apps take a long time to open? We'll also cover the startup speed issue
in some future pages.
{% endcomment -%}

{% comment %}

TODO(<https://github.com/flutter/website/issues/8249>): Reintroduce this article and add this link back.

## Memory

[Using memory wisely](/perf/memory)

{% endcomment -%}

## Tamanho do app

Como medir o tamanho do seu app. Quanto menor o tamanho,
mais rápido é o download.

[Medindo o tamanho do seu app][Measuring your app's size]

{% comment %}

TODO(<https://github.com/flutter/website/issues/8249>): Reintroduce this article and add this link back.

## Energy

How to ensure a longer battery life when running your app.

[Preserving your battery](/perf/power)

{% endcomment -%}

[Measuring your app's size]: /perf/app-size

[speed]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+speed%22+sort%3Aupdated-asc+
[energy]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+energy%22+sort%3Aupdated-asc+
[memory]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+memory%22+sort%3Aupdated-asc+
[size]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+app+size%22+sort%3Aupdated-asc+
[performance]: {{site.repo.flutter}}/issues?q=+label%3A%22severe%3A+performance%22
