---
ia-translate: true
title: Experimente
description: Como criar um app Flutter a partir de um template e usar hot reload.
prev:
  title: Set up Flutter
  path: /get-started/install
next:
  title: Write your first Flutter app
  path: /get-started/codelab
toc: false
---

{% case os %}
{% when 'Windows' -%}
   {% assign path='C:\dev\' %}
   {% assign terminal='PowerShell' %}
   {% assign prompt1='D:>' %}
   {% assign prompt2=path | append: '>' %}
   {% assign dirdl='%CSIDL_DEFAULT_DOWNLOADS%\' %}
{% when "macOS" -%}
   {% assign path='~/development/' %}
   {% assign terminal='the Terminal' %}
   {% assign prompt1='$' %}
   {% assign prompt2='$' %}
   {% assign dirdl='~/Downloads/' %}
{% else -%}
   {% assign path='~/development/' %}
   {% assign terminal='a shell' %}
   {% assign prompt1='$' %}
   {% assign prompt2='$' %}
   {% assign dirdl='~/Downloads/' %}
{% endcase -%}

## O que você vai aprender

1. Como criar um novo app Flutter a partir de um template de exemplo.
1. Como executar o novo app Flutter.
1. Como usar "hot reload" depois de fazer mudanças no app.


Essas tarefas dependem de qual ambiente de desenvolvimento integrado (IDE) você usa.

* **Opção 1** explica como programar com Visual Studio Code e
  sua extensão Flutter.

* **Opção 2** explica como programar com Android Studio ou IntelliJ IDEA com
  seu plugin Flutter.

  Flutter suporta as edições Community, Educational e Ultimate do IntelliJ IDEA.

* **Opção 3** explica como programar com um editor de sua escolha e usar
  o terminal para compilar e depurar seu código.

## Escolha sua IDE

Selecione sua IDE preferida para apps Flutter.

{% tabs %}
{% tab "Visual Studio Code" %}

{% include docs/install/test-drive/vscode.md %}

{% endtab %}
{% tab "Android Studio and IntelliJ" %}

{% include docs/install/test-drive/androidstudio.md %}

{% endtab %}
{% tab "Terminal & editor" %}

{% include docs/install/test-drive/terminal.md %}

{% endtab %}
{% endtabs %}

