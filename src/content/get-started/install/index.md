---
title: Escolha sua plataforma de desenvolvimento para começar
short-title: Instalar
description: Instale o Flutter e comece. Downloads disponíveis para os sistemas operacionais Windows, macOS, Linux e ChromeOS.
ia-translate: true
os-list: [Windows, macOS, Linux, ChromeOS]
js: [{url: '/assets/js/page/install-current.js'}]
---

<div class="card-grid narrow">
{% for os in os-list %}
  <a class="card" id="install-{{os | remove: ' ' | downcase}}" href="/get-started/install/{{os | remove: ' ' | downcase}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = os | downcase -%}
            <img src="/assets/images/docs/brand-svg/{{icon}}.svg" width="72" height="72" aria-hidden="true" alt="{{os}} logo"> 
        </span>
        <span class="text-muted text-nowrap">{{os}}</span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

{% render docs/china-notice.md %}
