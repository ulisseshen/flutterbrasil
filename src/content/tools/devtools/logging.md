---
ia-translate: true
title: Usar a visualização Logging
description: Aprenda como usar a visualização de logging do DevTools.
---

:::note
A visualização de logging funciona com todas as aplicações Flutter e Dart.
:::

## O que é?

A visualização de logging exibe eventos do runtime Dart,
frameworks de aplicação (como Flutter) e eventos de
logging em nível de aplicação.

## Eventos de logging padrão

Por padrão, a visualização de logging mostra:

* Eventos de coleta de lixo do runtime Dart
* Eventos do framework Flutter, como eventos de criação de frames
* `stdout` e `stderr` de aplicações
* Eventos de logging personalizados de aplicações

![Screenshot of a logging view](/assets/images/docs/tools/devtools/logging_log_entries.png){:width="100%"}

## Logging da sua aplicação

Para implementar logging no seu código,
veja a seção [Logging][] na
página [Depurando apps Flutter programaticamente][Debugging Flutter apps programmatically].

## Limpando logs

Para limpar as entradas de log na visualização de logging,
clique no botão **Clear logs**.

[Logging]: /testing/code-debugging#add-logging-to-your-application
[Debugging Flutter apps programmatically]: /testing/code-debugging

## Outros recursos

Para aprender sobre diferentes métodos de logging
e como usar efetivamente DevTools para
analisar e depurar apps Flutter mais rapidamente,
confira um [tutorial guiado da Logging View][logging-tutorial].

[logging-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-logging-view-part-5-of-8-b634f3a3af26
