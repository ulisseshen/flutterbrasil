---
ia-translate: true
title: Catálogo de widgets
description: Um catálogo de alguns dos ricos widgets do Flutter.
shortTitle: Widgets
showToc: false
---

Crie apps bonitos mais rapidamente com a coleção de widgets visuais, estruturais,
de plataforma e interativos do Flutter. Além de navegar pelos widgets por categoria,
você também pode ver todos os widgets no [índice de widgets][widget index].

## Design systems

O Flutter inclui dois design systems como parte do SDK.

<div class="card-grid">
{% assign categories = catalog.index | sortBy: 'name' -%}
{% for section in categories %}
  {%- if section.name == "Cupertino" or section.name == "Material components" -%}
    <a class="card outlined-card" href="{{page.url}}/{{section.id}}">
      <div class="card-header">
        <span class="card-title">{{section.name}}</span>
      </div>
      <div class="card-content">
        <p>{{section.description}}</p>
      </div>
    </a>
  {% endif -%}
{% endfor %}
</div>

Você pode encontrar muito mais design systems criados pela comunidade Flutter
no [pub.dev]({{site.pub}}), o repositório de pacotes para Dart e Flutter,
como por exemplo o [fluent_ui]({{site.pub-pkg}}/fluent_ui) inspirado no Windows,
o [macos_ui]({{site.pub-pkg}}/macos_ui) inspirado no macOS,
e os widgets [yaru]({{site.pub-pkg}}/yaru) inspirados no Ubuntu.

## Base widgets

Os widgets base suportam uma variedade de opções comuns de renderização
como input, layout e texto.

<div class="card-grid">
{% assign categories = catalog.index | sortBy: 'name' -%}
{% for section in categories %}
  {%- if section.name != "Cupertino" and section.name != "Material components" and section.name != "Material 2 components" -%}
    <a class="card outlined-card" href="{{page.url}}/{{section.id}}">
      <div class="card-header">
        <span class="card-title">{{section.name}}</span>
      </div>
      <div class="card-content">
        <p>{{section.description}}</p>
      </div>
    </a>
  {% endif -%}
{% endfor %}
</div>

## Widget of the Week

Mais de 100 vídeos explicativos curtos de 1 minuto para
ajudá-lo a começar rapidamente com os widgets do Flutter.

<div class="card-grid wide">
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="D0xwcz2IqAY" title="CupertinoRadio - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="5H-WvH5O29I" title="CupertinoSheetRoute - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="esnBf6V4C34" title="CupertinoSlidingSegmentedControl - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="ua54JU7k1Us" title="CupertinoCheckbox - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="24tg_N4sdMQ" title="CupertinoSwitch - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="GQ8ajYVF0bo" title="CarouselView - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
</div>

<a class="filled-button" target="_blank" href="{{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Assista mais vídeos do widget of the week</a>

[widget index]: /reference/widgets
