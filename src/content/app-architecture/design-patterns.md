---
title: Design patterns de arquitetura
short-title: Design patterns
description: >-
  Uma coleção de artigos sobre design patterns úteis para
  construir aplicativos Flutter.
prev:
  title: Recomendações
  path: /app-architecture/recommendations
toc: false
ia-translate: true
---

Se você já leu a página do [guia de arquitetura][],
ou se você está confortável com Flutter e o padrão MVVM,
os artigos a seguir são para você.

Estes artigos não são sobre a arquitetura de alto nível do aplicativo,
mas sim sobre a resolução de problemas de design específicos que melhoram a
base de código da sua aplicação, independentemente de como você arquitetou seu app.
Dito isso, os artigos assumem o padrão MVVM apresentado nas
páginas anteriores nos exemplos de código.

{% assign recipes = collections.design-patterns | sort: "data.order" -%}
{% render expansion-list.html, list: recipes, baseId: 'design-patterns' %}

[guia de arquitetura]: /app-architecture/guide
