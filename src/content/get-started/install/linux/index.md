---
ia-translate: true
title: Escolha seu primeiro tipo de aplicativo
description: Configure seu sistema para desenvolver Flutter no Linux.
short-title: Linux
target-list: [Android, Web, Desktop]
js: [{url: '/assets/js/temp/linux-install-redirector.js'}]
---

{% assign os = 'linux' -%}
{% assign recommend = 'Android' %}
{% capture rec-target -%}
[{{recommend}}](/get-started/install/{{os | downcase}}/{{recommend | downcase}})
{%- endcapture %}

<div class="card-grid narrow">
{% for target in target-list %}
  <a class="card card-app-type card-linux" id="install-{{os | remove: ' ' | downcase}}" href="/get-started/install/{{os | remove: ' ' | downcase}}/{{target | downcase}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% if icon == 'desktop' -%}
            <span class="material-symbols">desktop_windows</span>
          {% elsif icon == 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% else -%}
            <span class="material-symbols">web</span>
          {% endif -%}
        </span>
        <span class="text-muted text-nowrap">{{target}}</span>
        {% if icon == 'android' -%}
          <div class="card-subtitle">Recomendado</div>
        {% endif -%}
      </header>
    </div>
  </a>
{% endfor %}
</div>

Sua escolha informa quais partes das ferramentas Flutter você configura
para executar seu primeiro aplicativo Flutter. Você pode configurar plataformas
adicionais posteriormente. _Se você não tem preferência, escolha **{{rec-target}}**._

{% render docs/china-notice.md %}
