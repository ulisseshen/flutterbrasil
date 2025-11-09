---
ia-translate: true
title: Use a view de Logging
description: Aprenda como usar a view de logging do DevTools.
---

:::note
A view de logging funciona com todas as aplicações Flutter e Dart.
:::

## O que é isso?

A view de logging exibe eventos do runtime Dart,
frameworks de aplicação (como Flutter) e eventos
de logging em nível de aplicação.

## Eventos de logging padrão

Por padrão, a view de logging mostra:

* Eventos de garbage collection do runtime Dart
* Eventos do framework Flutter, como eventos de criação de frame
* `stdout` e `stderr` de aplicações
* Eventos de logging customizados de aplicações

![Screenshot of a logging view](/assets/images/docs/tools/devtools/logging_log_entries.png){:width="100%"}

## Logging da sua aplicação

Para implementar logging no seu código,
veja a seção [Logging][Logging] na
página [Debugging Flutter apps programmatically][Debugging Flutter apps programmatically].

## Limpando logs

Para limpar as entradas de log na view de logging,
clique no botão **Clear logs**.

[Logging]: /testing/code-debugging#add-logging-to-your-application
[Debugging Flutter apps programmatically]: /testing/code-debugging

## Outros recursos

Para aprender sobre diferentes métodos de logging
e como usar efetivamente DevTools para
analisar e depurar apps Flutter mais rapidamente,
confira um [tutorial guiado da View de Logging][logging-tutorial].

[logging-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-logging-view-part-5-of-8-b634f3a3af26
