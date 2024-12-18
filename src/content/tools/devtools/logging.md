---
ia-translate: true
title: Use a visualização de Logging
description: Aprenda a usar a visualização de logging do DevTools.
---

:::note
A visualização de logging funciona com todos os aplicativos Flutter e Dart.
:::

## O que é?

A visualização de logging exibe eventos do tempo de execução do Dart,
frameworks de aplicativos (como Flutter) e eventos de logging
no nível do aplicativo.

## Eventos de logging padrão

Por padrão, a visualização de logging mostra:

* Eventos de coleta de lixo do tempo de execução do Dart
* Eventos do framework Flutter, como eventos de criação de frame
* `stdout` e `stderr` de aplicativos
* Eventos de logging personalizados de aplicativos

![Captura de tela de uma visualização de logging](/assets/images/docs/tools/devtools/logging_log_entries.png){:width="100%"}

## Logging do seu aplicativo

Para implementar logging no seu código,
veja a seção [Logging][] na
página [Depurando aplicativos Flutter programaticamente][].

## Limpando logs

Para limpar as entradas de log na visualização de logging,
clique no botão **Limpar logs**.

[Logging]: /testing/code-debugging#add-logging-to-your-application
[Depurando aplicativos Flutter programaticamente]: /testing/code-debugging

## Outros recursos

Para aprender sobre diferentes métodos de logging
e como usar efetivamente o DevTools para
analisar e depurar aplicativos Flutter mais rapidamente,
confira um [tutorial guiado sobre a visualização de Logging][logging-tutorial].

[logging-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-logging-view-part-5-of-8-b634f3a3af26
