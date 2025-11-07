---
ia-translate: true
title: Adicionar Linux como plataforma de destino para Flutter
description: Configure seu sistema para desenvolver Flutter para Linux.
short-title: Configurar desenvolvimento Linux
target-list: [Android, web]
---

Para configurar seu ambiente de desenvolvimento para Linux,
escolha o guia que corresponde ao [caminho Getting Started][Getting Started path] que você seguiu,
ou a plataforma que você já configurou.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/linux/install-linux/install-linux-from-' | append: target | downcase %}
  <a class="card card-app-type card-linux" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
        </span>
        <span class="text-muted d-block">
        Make {{ target }} and Linux desktop apps
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
