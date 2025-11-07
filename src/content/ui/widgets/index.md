---
title: Catálogo de widgets
description: Um catálogo de alguns dos ricos conjuntos de widgets do Flutter.
short-title: Widgets
toc: false
ia-translate: true
---

Crie aplicativos bonitos mais rapidamente com a coleção de widgets visuais, estruturais,
de plataforma e interativos do Flutter. Além de navegar pelos widgets por categoria,
você também pode ver todos os widgets no [índice de widgets][widget index].

## Sistemas de design

O Flutter vem com dois sistemas de design como parte do SDK.

<div class="card-grid">
{% assign categories = catalog.index | sort: 'name' -%}
{% for section in categories %}
    {%- if section.name == "Cupertino" or section.name == "Material components" -%}
        <div class="card">
            <div class="card-body">
                <a href="{{page.url}}{{section.id}}"><header class="card-title">{{section.name}}</header></a>
                <p class="card-text">{{section.description}}</p>
            </div>
        </div>
    {% endif -%}
{% endfor %}
</div>

Você pode encontrar muitos mais sistemas de design criados pela comunidade Flutter
no [pub.dev]({{site.pub}}), o repositório de pacotes para Dart e Flutter,
como por exemplo o [fluent_ui]({{site.pub-pkg}}/fluent_ui) inspirado no Windows,
o [macos_ui]({{site.pub-pkg}}/macos_ui) inspirado no macOS,
e os widgets [yaru]({{site.pub-pkg}}/yaru) inspirados no Ubuntu.

## Widgets base

Os widgets base suportam uma variedade de opções de renderização comuns
como input, layout e texto.

<div class="card-grid">
{% assign categories = catalog.index | sort: 'name' -%}
{% for section in categories %}
    {%- if section.name != "Cupertino" and section.name != "Material components" and section.name != "Material 2 components" -%}
        <div class="card">
            <div class="card-body">
                <a href="{{page.url}}{{section.id}}"><header class="card-title">{{section.name}}</header></a>
                <p class="card-text">{{section.description}}</p>
            </div>
        </div>
    {% endif -%}
{% endfor %}
</div>

## Widget da semana

Mais de 100 vídeos curtos de 1 minuto explicando
para ajudá-lo a começar rapidamente com os widgets do Flutter.

<div class="card-grid wide">
    <div class="card">
        <div class="card-body">
            {% ytEmbed '1z6YP7YmvwA', 'TextStyle - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'VdkRy3yZiPo', 'flutter_rating_bar - Flutter package of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'gYNTcgZVcWw', 'LinearGradient - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed '-Nny8kzW380', 'AutoComplete - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'y9xchtVTtqQ', 'NavigationRail - Flutter widget of the week', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'qjA0JFiPMnQ', 'mason - Flutter package of the week', true, true %}
        </div>
    </div>
</div>

<a class="btn btn-primary full-width" target="_blank" href="{{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Assista mais vídeos de widget da semana</a>

[widget index]: /reference/widgets
