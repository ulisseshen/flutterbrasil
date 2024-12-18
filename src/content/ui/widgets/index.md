---
ia-translate: true
title: Catálogo de widgets
description: Um catálogo de alguns dos ricos conjuntos de widgets do Flutter.
short-title: Widgets
toc: false
---

Crie aplicativos bonitos mais rapidamente com a coleção de widgets visuais,
estruturais, de plataforma e interativos do Flutter. Além de navegar pelos widgets
por categoria, você também pode ver todos os widgets no [índice de widgets][].

## Sistemas de design

O Flutter é fornecido com dois sistemas de design como parte do SDK.
Você pode encontrar muitos outros sistemas de design criados pela comunidade
Flutter em [pub.dev]({{site.pub}}), o repositório de pacotes para Dart e Flutter.

<div class="card-grid">
{% assign categories = catalog.index | sort: 'name' -%}
{% for section in categories %}
    {%- if section.name == "Cupertino" or section.name == "Componentes Material" -%}
        <div class="card">
            <div class="card-body">
                <a href="{{page.url}}{{section.id}}"><header class="card-title">{{section.name}}</header></a>
                <p class="card-text">{{section.description}}</p>
            </div>
        </div>
    {% endif -%}
{% endfor %}
</div>

## Widgets base

Widgets base suportam uma variedade de opções de renderização comuns como entrada,
layout e texto.

<div class="card-grid">
{% assign categories = catalog.index | sort: 'name' -%}
{% for section in categories %}
    {%- if section.name != "Cupertino" and section.name != "Componentes Material" and section.name != "Componentes Material 2" -%}
        <div class="card">
            <div class="card-body">
                <a href="{{page.url}}{{section.id}}"><header class="card-title">{{section.name}}</header></a>
                <p class="card-text">{{section.description}}</p>
            </div>
        </div>
    {% endif -%}
{% endfor %}
</div>

## Widget da Semana

Mais de 100 vídeos explicativos curtos de 1 minuto para ajudá-lo a começar
rapidamente com os widgets do Flutter.

<div class="card-grid wide">
    <div class="card">
        <div class="card-body">
            {% ytEmbed '1z6YP7YmvwA', 'TextStyle - Widget do Flutter da semana', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'VdkRy3yZiPo', 'flutter_rating_bar - Pacote Flutter da semana', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'gYNTcgZVcWw', 'LinearGradient - Widget do Flutter da semana', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed '-Nny8kzW380', 'AutoComplete - Widget do Flutter da semana', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'y9xchtVTtqQ', 'NavigationRail - Widget do Flutter da semana', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'qjA0JFiPMnQ', 'mason - Pacote Flutter da semana', true, true %}
        </div>
    </div>
</div>

<a class="btn btn-primary full-width" target="_blank" href="{{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Assista mais vídeos do widget da semana</a>

[widget index]: /reference/widgets
