---
ia-translate: true
title: Adicione Linux como plataforma alvo para Flutter
description: Configure seu sistema para desenvolver Flutter para Linux.
short-title: Configure o desenvolvimento Linux
target-list: [Android, web]
---

Para configurar seu ambiente de desenvolvimento para ter o Linux como alvo,
escolha o guia que corresponde ao caminho de [Começando][] que você seguiu,
ou a plataforma que você já tem configurada.

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
        Crie aplicativos desktop {{ target }} e Linux
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[Começando]: /get-started/install
