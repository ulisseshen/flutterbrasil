---
ia-translate: true
title: Adicionar iOS como plataforma de destino para Flutter
description: Configure seu sistema para desenvolver Flutter para iOS.
short-title: Configurar desenvolvimento iOS
target-list: [macOS, Android, web]
---

Para configurar seu ambiente de desenvolvimento para iOS,
escolha o guia que corresponde ao [caminho Getting Started][Getting Started path] que você seguiu,
ou a plataforma que você já configurou.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/ios/install-ios/install-ios-from-' | append: target | downcase %}
  <a class="card card-app-type card-macos" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase -%}
          {% case icon %}
          {% when 'macos' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'android' -%}
            <span class="material-symbols">phone_android</span>
          {% when 'web' -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">phone_iphone</span>
        </span>
        <span class="text-muted d-block">
        Make iOS and {{ target }}{% if target == 'macOS' %} desktop{% endif %} apps
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Getting Started path]: /get-started/install
