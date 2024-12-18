---
ia-translate: true
title: Escolha seu primeiro tipo de aplicativo
description: Configure seu sistema para desenvolver Flutter no macOS.
short-title: macOS
target-list: [iOS, Android, Web, Desktop]
js: [{url: '/assets/js/temp/macos-install-redirector.js'}]
---

{% assign os = 'macos' -%}
{% assign recommend = 'iOS' %}
{% capture rec-target -%}
[{{recommend | strip}}](/get-started/install/{{os | downcase}}/mobile-{{recommend | downcase}})
{%- endcapture %}

<div class="card-grid narrow">
{% for target in target-list %}
  {% case target %}
  {% when "iOS", "Android" %}
  {% assign targetlink = target | downcase | prepend: 'mobile-' %}
  {% else %}
  {% assign targetlink = target | downcase %}
  {% endcase %}

  <a class="card card-app-type card-macos" id="install-{{os | downcase}}" href="/get-started/install/{{os | downcase}}/{{targetlink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'desktop' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'ios' -%}
            <span class="material-symbols">phone_iphone</span>
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
        </span>
        <span class="text-muted">{{ target }}</span>
        {% if icon == 'ios' -%}
          <div class="card-subtitle">Recomendado</div>
        {% endif -%}
      </header>
    </div>
  </a>

{% endfor %}
</div>

Sua escolha informa quais partes das ferramentas Flutter você configura
para executar seu primeiro aplicativo Flutter.
Você pode configurar plataformas adicionais mais tarde.
_Se você não tem preferência, escolha **{{rec-target}}**._

{% render docs/china-notice.md %}
