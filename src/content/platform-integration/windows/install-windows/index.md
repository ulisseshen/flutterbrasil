---
ia-translate: true
title: Adicione o Windows como uma plataforma de destino para o Flutter
description: Configure seu sistema para desenvolver Flutter para Windows.
short-title: Configurar o desenvolvimento para Windows
target-list: [Android, web]
---

Para configurar seu ambiente de desenvolvimento para direcionar o Windows,
escolha o guia que corresponde ao [Caminho de Introdução][] que você seguiu,
ou a plataforma que você já configurou.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/windows/install-windows/install-windows-from-' | append: target | downcase %}
  <a class="card card-app-type card-windows" id="install-{{target | downcase}}" href="{{targetLink}}">
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
          <span class="material-symbols">add</span>
          <span class="material-symbols">desktop_windows</span>
        </span>
        <span class="text-muted d-block">
        Crie aplicativos para desktop Windows e {{ target }}
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Caminho de Introdução]: /get-started/install
