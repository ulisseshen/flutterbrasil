---
ia-translate: true
title: Adicionar macOS como plataforma de destino para Flutter
description: Configure seu sistema para desenvolver Flutter para macOS.
short-title: Configurar desenvolvimento macOS
target-list: [iOS, Android, web]
---

Para configurar seu ambiente de desenvolvimento para macOS,
escolha o guia que corresponde ao [caminho Getting Started][Getting Started path] que você seguiu,
ou a plataforma que você já configurou.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/macos/install-macos/install-macos-from-' | append: target | downcase %}
  <a class="card card-app-type card-macos" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'ios' -%}
            <span class="material-symbols">phone_iphone</span>
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">laptop_mac</span>
        </span>
        <span class="text-muted d-block">
        Make {{ target }} and macOS desktop apps
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
