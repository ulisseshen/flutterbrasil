---
title: Escolha seu primeiro tipo de app
description: Configure seu sistema para desenvolver Flutter no ChromeOS.
short-title: ChromeOS
ia-translate: true
target-list: [Android, Web]
js: [{url: '/assets/js/temp/chromeos-install-redirector.js'}]
---

{% assign os = 'chromeos' -%}
{% assign recommend = 'Android' %}
{% capture rec-target -%}
[{{recommend}}](/get-started/install/{{os | downcase}}/{{recommend | downcase}})
{%- endcapture %}

<div class="card-grid narrow">
{% for target in target-list %}
  <a class="card card-app-type card-chromeos" id="install-{{os | remove: ' ' | downcase}}" href="/get-started/install/{{os | remove: ' ' | downcase}}/{{target | downcase}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% if icon == 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% else -%}
            <span class="material-symbols">web</span>
          {% endif -%}
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
