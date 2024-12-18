---
ia-translate: true
title: Test drive
description: Como criar um aplicativo Flutter com template e usar o hot reload.
prev:
  title: Configurar o Flutter
  path: /get-started/install
next:
  title: Escreva seu primeiro aplicativo Flutter
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
   {% assign terminal='o Terminal' %}
   {% assign prompt1='$' %}
   {% assign prompt2='$' %}
   {% assign dirdl='~/Downloads/' %}
{% else -%}
   {% assign path='~/development/' %}
   {% assign terminal='um shell' %}
   {% assign prompt1='$' %}
   {% assign prompt2='$' %}
   {% assign dirdl='~/Downloads/' %}
{% endcase -%}

## O que você aprenderá

1. Como criar um novo aplicativo Flutter a partir de um modelo de exemplo.
2. Como executar o novo aplicativo Flutter.
3. Como usar o "hot reload" após fazer alterações no aplicativo.

Essas tarefas dependem de qual ambiente de desenvolvimento integrado (IDE) você usa.

* A **Opção 1** explica como programar com o Visual Studio Code e sua extensão Flutter.

* A **Opção 2** explica como programar com o Android Studio ou IntelliJ IDEA com seu plugin Flutter.

  O Flutter suporta as edições Community, Educational e Ultimate do IntelliJ IDEA.

* A **Opção 3** explica como programar com um editor de sua escolha e usar o terminal para compilar e depurar seu código.

## Escolha seu IDE

Selecione seu IDE preferido para aplicativos Flutter.

{% tabs %}
{% tab "Visual Studio Code" %}

{% include docs/install/test-drive/vscode.md %}

{% endtab %}
{% tab "Android Studio e IntelliJ" %}

{% include docs/install/test-drive/androidstudio.md %}

{% endtab %}
{% tab "Terminal & editor" %}

{% include docs/install/test-drive/terminal.md %}

{% endtab %}
{% endtabs %}
