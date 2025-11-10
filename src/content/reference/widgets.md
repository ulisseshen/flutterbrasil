---
ia-translate: true
title: Índice de widgets do Flutter
description: Uma lista alfabética de widgets do Flutter.
shortTitle: Widgets
showBreadcrumbs: false
---

Esta é uma lista alfabética de muitos dos widgets que
vêm junto com o Flutter.
Você também pode [navegar por widgets por categoria][catalog].

Você também pode querer conferir nossa série de vídeos Widget of the Week
no [canal do Flutter no YouTube]({{site.social.youtube}}). Cada episódio curto
apresenta um widget diferente do Flutter. Para mais séries de vídeos, veja
nossa página de [vídeos](/resources/videos).

<YouTubeEmbed id="b_sQ9bMltGU" title="Introducing the Flutter Widget of the Week"></YouTubeEmbed>

[Playlist do Widget of the Week]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

<div class="card-grid">
{% for comp in catalog.widgets | sortBy: 'name' -%}
  <a class="card outlined-card" href="{{comp.link}}">
    <div class="card-image-holder">
      {% if comp.vector -%}
        {{comp.vector}}
      {% elsif comp.image -%}
        <img alt="Rendered image or visualization of the {{comp.name}} widget." src="{{comp.image.src}}">
      {% else -%}
        <img alt="Flutter logo for widget missing visualization image." src="/assets/images/docs/catalog-widget-placeholder.png" aria-hidden="true">
      {% endif -%}
    </div>
    <div class="card-header">
      <span class="card-title">{{comp.name}}</span>
    </div>
    <div class="card-content">
      <p class="card-text">{{ comp.description | truncatewords: 25 }}</p>
    </div>
  </a>
{% endfor %}
</div>

[catalog]: /ui/widgets
