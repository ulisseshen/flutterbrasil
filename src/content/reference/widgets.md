---
ia-translate: true
title: Índice de widgets do Flutter
description: Uma lista alfabética de widgets do Flutter.
short-title: Widgets
show_breadcrumbs: false
---

{% assign sorted = catalog.widgets | sort:'name' -%}

Esta é uma lista alfabética de muitos dos widgets que
vêm incluídos com o Flutter.
Você também pode [navegar widgets por categoria][catalog].

Você também pode querer conferir nossa série de vídeos Widget of the Week
no [canal do Flutter no YouTube]({{site.social.youtube}}). Cada episódio curto
apresenta um widget Flutter diferente. Para mais séries de vídeo, veja
nossa página de [vídeos](/resources/videos).

{% ytEmbed 'b_sQ9bMltGU', 'Introducing the Flutter Widget of the Week' %}

[Widget of the Week playlist]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

<div class="card-grid">
{% for comp in sorted -%}
    <div class="card">
        <a href="{{comp.link}}">
            <div class="card-image-holder">
                {% if comp.vector -%}
                    {{comp.vector}}
                {% elsif comp.image -%}
                    <img alt="Rendered image or visualization of the {{comp.name}} widget." src="{{comp.image.src}}">
                {% else -%}
                    <img alt="Flutter logo for widget missing visualization image." src="/assets/images/docs/catalog-widget-placeholder.png" aria-hidden="true">
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
