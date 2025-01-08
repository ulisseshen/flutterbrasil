---
ia-translate: true
title: Desinstalar o Flutter
description: Como remover o SDK do Flutter.
toc: false
os-list: [Windows, macOS, Linux, ChromeOS]
---

Para remover completamente o Flutter da sua máquina de desenvolvimento,
delete os diretórios que armazenam o Flutter e seus arquivos de configuração.

## Desinstalar o SDK do Flutter

Selecione sua plataforma de desenvolvimento nas abas a seguir.

{% tabs %}

{% for os in os-list %}
{% tab os %}

{% assign id = os | downcase -%}
{% case os %}
{% when 'Windows' -%}
{% assign dirinstall='C:\\user\{username}\dev\' %}
{% assign localappdata='%LOCALAPPDATA%\' %}
{% assign appdata='%APPDATA%\' %}
{% assign ps-localappdata='$env:LOCALAPPDATA\' %}
{% assign ps-appdata='$env:APPDATA\' %}
{% assign unzip='Expand-Archive' %}
{% assign path='C:\\user\{username}\dev' %}
{% assign prompt='C:\\>' %}
{% assign terminal='PowerShell' %}
{% assign rm = 'Remove-Item -Recurse -Force -Path' %}
{% capture rm-sdk %}Remove-Item -Recurse -Force -Path '{{dirinstall}}flutter'{% endcapture %}
{% capture dart-files %}
{{localappdata}}.dartServer
{{appdata}}.dart
{{appdata}}.dart-tool
{% endcapture %}
{% capture rm-dart-files %}
{{prompt}} {{rm}} {{ps-localappdata}}.dartServer,{{ps-appdata}}.dart,{{ps-appdata}}.dart-tool
{% endcapture %}
{% capture flutter-files %}{{appdata}}.flutter-devtools{% endcapture %}
{% capture rm-flutter-files %}
{{prompt}} {{rm}} {{ps-appdata}}.flutter-devtools
{% endcapture %}
{% capture rm-pub-dir %}
{{prompt}} {{rm}} {{ps-localappdata}}Pub\Cache
{% endcapture %}
{% else -%}
{% assign dirinstall='~/development' %}
{% assign dirconfig='~/' %}
{% assign path='~/development/' %}
{% assign prompt='$' %}
{% assign rm = 'rm -rf ' %}
{% assign rm-sdk = rm | append: dirinstall | append: '/flutter' %}
{% capture dart-files %}
{{dirconfig}}.dart
{{dirconfig}}.dart-tool
{{dirconfig}}.dartServer
{% endcapture %}
{% capture rm-dart-files %}
{{prompt}} {{rm}} {{dirconfig}}.dart*
{% endcapture %}
{% capture flutter-files %}
{{dirconfig}}.flutter
{{dirconfig}}.flutter-devtools
{{dirconfig}}.flutter_settings
{% endcapture %}
{% capture rm-flutter-files %}
{{prompt}} {{rm}} {{dirconfig}}.flutter*
{% endcapture %}
{% capture rm-pub-dir %}
{{prompt}} {{rm}} {{dirconfig}}.pub-cache
{% endcapture %}
{% endcase -%}

Este guia presume que você instalou o Flutter em `{{path}}` no {{os}}.

Para desinstalar o SDK, remova o diretório `flutter`.

```console
{{prompt}} {{rm-sdk}}
```

## Remover diretórios de configuração e pacotes {:.no_toc}

Flutter e Dart instalam diretórios adicionais no seu diretório home.
Eles contêm arquivos de configuração e downloads de pacotes.
Cada um dos procedimentos a seguir são _opcionais_.

### Remover arquivos de configuração do Flutter {:.no_toc}

Se você não quer preservar sua configuração do Flutter,
remova os seguintes diretórios do seu diretório home.

```plaintext
{{ flutter-files | strip }}
```

Para remover esses diretórios, execute o seguinte comando.

```console
{{rm-flutter-files | strip}}
```

### Remover arquivos de configuração do Dart {:.no_toc}

Se você não quer preservar sua configuração do Dart,
remova os seguintes diretórios do seu diretório home.

```plaintext
{{ dart-files | strip}}
```

Para remover esses diretórios, execute o seguinte comando.

```console
{{rm-dart-files | strip}}
```

### Remover arquivos de pacotes pub {:.no_toc}

:::important
Se você quer remover o Flutter, mas não o Dart,
não execute esta seção.
:::

Se você não quer preservar seus pacotes pub,
remova o diretório `.pub-cache` do seu diretório home.

```console
{{rm-pub-dir | strip}}
```

{% case os %}
{% when 'Windows','macOS' -%}
{% include docs/install/reqs/{{os | downcase}}/unset-path.md terminal=terminal -%}
{% endcase %}

{% endtab %}
{% endfor -%}

{% endtabs %}

## Reinstalar o Flutter

Você pode [reinstalar o Flutter](/get-started/install) a qualquer momento.
Se você removeu os diretórios de configuração,
reinstalar o Flutter restaura-os para as configurações padrão.
