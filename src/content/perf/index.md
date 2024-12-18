---
ia-translate: true
title: Desempenho
description: Avaliando o desempenho do seu aplicativo de diversos ângulos.
---

{% ytEmbed 'PKGguGUwSYE', 'Dicas de desempenho do Flutter | Flutter em Foco' %}

:::note
Se o seu aplicativo tiver um problema de desempenho e você estiver tentando
depurá-lo, consulte a página do DevTool sobre
[Usando a visualização de Desempenho][].
:::

[Usando a visualização de Desempenho]: /tools/devtools/performance

O que é desempenho? Por que o desempenho é importante? Como melhoro o desempenho?

Nosso objetivo é responder a essas três perguntas (principalmente a terceira) e
tudo relacionado a elas. Este documento deve servir como o ponto de entrada único
ou o nó raiz de uma árvore de recursos que aborda todas as perguntas
que você tem sobre desempenho.

As respostas para as duas primeiras perguntas são principalmente filosóficas e não
tão úteis para muitos desenvolvedores que visitam esta página com problemas
específicos de desempenho que precisam ser resolvidos.
Portanto, as respostas a essas
perguntas estão no [apêndice](/perf/appendix).

Para melhorar o desempenho, você primeiro precisa de métricas: alguns números
mensuráveis para verificar os problemas e as melhorias.
Na página de [métricas](/perf/metrics),
você verá quais métricas estão sendo usadas no momento e
quais ferramentas e APIs estão disponíveis para obter as métricas.

Há uma lista de [Perguntas frequentes](/perf/faq),
para que você possa descobrir se as perguntas que você tem ou os problemas que
está tendo já foram respondidos ou encontrados e se existem soluções.
(Como alternativa, você pode verificar o banco de dados de issues do Flutter no
GitHub usando a label [performance][performance].)

Finalmente, os problemas de desempenho são divididos em quatro categorias. Elas
correspondem às quatro labels que são usadas no banco de dados de issues do
Flutter no GitHub: "[perf: velocidade][speed]", "[perf: memória][memory]",
"[perf: tamanho do app][size]", "[perf: energia][energy]".

O restante do conteúdo é organizado usando essas quatro categorias.

{% comment %}
Vamos colocar "velocidade" (renderização) primeiro, pois é a categoria de
problema de desempenho mais popular.
{% endcomment -%}

## Velocidade

Suas animações estão travando (não suaves)? Aprenda como avaliar e corrigir
problemas de renderização.

[Melhorando o desempenho de renderização](/perf/rendering-performance)

{% comment %}
Seus aplicativos demoram muito para abrir? Também abordaremos o problema da
velocidade de inicialização em algumas páginas futuras.
{% endcomment -%}

{% comment %}

TODO(<https://github.com/flutter/website/issues/8249>): Reintroduzir este artigo e adicionar este link de volta.

## Memória

[Usando a memória com sabedoria](/perf/memory)

{% endcomment -%}

## Tamanho do aplicativo

Como medir o tamanho do seu aplicativo. Quanto menor o tamanho, mais rápido é
o download.

[Medindo o tamanho do seu aplicativo][]

{% comment %}

TODO(<https://github.com/flutter/website/issues/8249>): Reintroduzir este artigo e adicionar este link de volta.

## Energia

Como garantir uma maior duração da bateria ao executar seu aplicativo.

[Preservando sua bateria](/perf/power)

{% endcomment -%}

[Medindo o tamanho do seu aplicativo]: /perf/app-size

[speed]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+speed%22+sort%3Aupdated-asc+
[energy]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+energy%22+sort%3Aupdated-asc+
[memory]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+memory%22+sort%3Aupdated-asc+
[size]: {{site.repo.flutter}}/issues?q=is%3Aopen+label%3A%22perf%3A+app+size%22+sort%3Aupdated-asc+
[performance]: {{site.repo.flutter}}/issues?q=+label%3A%22severe%3A+performance%22
