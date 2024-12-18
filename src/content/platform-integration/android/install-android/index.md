---
ia-translate: true
title: Adicionar Android como plataforma de destino para Flutter
description: Configure seu sistema para desenvolver Flutter para Android.
short-title: Configurar desenvolvimento Android
target-list: [Windows, 'web no Windows', Linux, 'web no Linux', macOS, 'web no macOS', iOS, 'web no ChromeOS']
---

Para configurar seu ambiente de desenvolvimento para Android,
escolha o guia que corresponde ao [caminho Começando][] que você seguiu,
ou a plataforma que você já configurou.

<div class="card-grid">
{% for target in target-list %}
{% assign targetLink = '/platform-integration/android/install-android/install-android-from-' | append: target | downcase | replace: " ", "-" %}

  {% if target contains 'macOS' or target contains 'iOS' %}
    {% assign bug = 'card-macos' %}
  {% elsif target contains 'Windows' %}
    {% assign bug = 'card-windows' %}
  {% elsif target contains 'Linux' %}
    {% assign bug = 'card-linux' %}
  {% elsif target contains 'ChromeOS' %}
    {% assign bug = 'card-chromeos' %}
  {% endif %}

  <a class="card card-app-type {{bug}}" id="install-{{target | downcase}}" href="{{targetLink}}">
    <div class="card-body">
      <header class="card-title text-center">
        <span class="d-block h1">
          {% assign icon = target | downcase | replace: " ", "-" -%}
          {% case icon %}
          {% when 'macos' -%}
            <span class="material-symbols">laptop_mac</span>
          {% when 'windows','linux' -%}
            <span class="material-symbols">desktop_windows</span>
          {% when 'ios' -%}
            <span class="material-symbols">phone_iphone</span>
          {% else -%}
            <span class="material-symbols">web</span>
          {% endcase -%}
          <span class="material-symbols">add</span>
          <span class="material-symbols">phone_android</span>
        </span>
        <span class="text-muted d-block">
        Crie aplicativos Android e
        {% if target contains "iOS" -%}
         {{target}} apps no macOS
        {%- elsif target contains "on" -%}
        {{ target | replace: "on", "apps no" }}
        {%- else -%}
        {{target}} aplicativos desktop
        {%- endif -%}
        </span>
      </header>
    </div>
  </a>
{% endfor %}
</div>

[caminho Começando]: /get-started/install
