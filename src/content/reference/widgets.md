---
ia-translate: true
title: Índice de widgets do Flutter
description: Uma lista alfabética de widgets do Flutter.
short-title: Widgets
show_breadcrumbs: false
---

{% assign sorted = catalog.widgets | sort:'name' -%}

Esta é uma lista alfabética de muitos dos widgets que
vêm com o Flutter.
Você também pode [navegar pelos widgets por categoria][catalog].

Você também pode querer conferir nossa série de vídeos Widget da Semana
no [canal do Flutter no YouTube]({{site.social.youtube}}). Cada episódio curto
apresenta um widget diferente do Flutter. Para mais séries de vídeos, veja
nossa página de [vídeos](/resources/videos).

{% ytEmbed 'b_sQ9bMltGU', 'Apresentando o Widget da Semana do Flutter' %}

[Playlist Widget da Semana]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

<div class="card-grid">
{% for comp in sorted -%}
    <div class="card">
        <a href="{{comp.link}}">
            <div class="card-image-holder">
                {% if comp.vector -%}
                    {{comp.vector}}
                {% elsif comp.image -%}
                    <img alt="Imagem renderizada ou visualização do widget {{comp.name}}." src="{{comp.image.src}}">
                {% else -%}
                    <img alt="Logo do Flutter para widget sem imagem de visualização." src="/assets/images/docs/catalog-widget-placeholder.png" aria-hidden="true">
                {% endif -%}
            </div>
        </a>
        <div class="card-body">
            <a href="{{comp.link}}"><header class="card-title">{{comp.name}}</header></a>
            <p class="card-text">{{ comp.description | truncatewords: 25 }}</p>
        </div>
    </div>
{% endfor %}
</div>

[catalog]: /ui/widgets
