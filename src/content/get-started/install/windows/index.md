---
title: Escolha seu primeiro tipo de app
description: Configure seu sistema para desenvolver Flutter no Windows.
short-title: Windows
ia-translate: true
target-list: [Android, Web, Desktop]
js: [{url: '/assets/js/temp/windows-install-redirector.js'}]
---

{% assign os = 'windows' -%}
{% assign recommend = 'Android' %}
{% capture rec-target -%}
[{{recommend}}](/get-started/install/{{os | downcase}}/mobile)
{%- endcapture %}

<div class="card-grid narrow">
{% for target in target-list %}
  {% case target %}
  {% when "Android" %}
  {% assign targetlink = target | downcase | replace: 'android', 'mobile' %}
  {% else %}
  {% assign targetlink = target | downcase %}
  {% endcase %}
  <a class="card card-app-type card-windows" id="install-{{os | downcase}}" href="/get-started/install/{{os | downcase}}/{{targetlink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'desktop' -%}
            <span class="material-symbols">desktop_windows</span>
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
        </span>
        <span class="text-muted text-nowrap">{{target}}</span>
        {% if icon == 'android' -%}
          <div class="card-subtitle">Recommended</div>
        {% endif -%}
      </header>
    </div>
  </a>
{% endfor %}
</div>

Sua escolha determina quais partes das ferramentas Flutter você configura
para executar seu primeiro app Flutter.
Você pode configurar plataformas adicionais mais tarde.
_Se você não tem preferência, escolha **{{rec-target}}**._

{% render docs/china-notice.md %}
