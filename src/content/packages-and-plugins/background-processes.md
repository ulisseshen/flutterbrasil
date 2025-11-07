---
ia-translate: true
title: Background processes
description: Onde encontrar mais informações sobre implementação de background processes no Flutter.
---

Você já quis executar código Dart em background—mesmo se seu app não fosse o app atualmente ativo?
Talvez você quisesse implementar um processo que observa o tempo,
ou que captura movimentos da câmera.
No Flutter, você pode executar código Dart em background.

O mecanismo para este recurso envolve configurar um isolate.
_Isolates_ são o modelo de multithreading do Dart,
embora um isolate difira de uma thread convencional
por não compartilhar memória com o programa principal.
Você configurará seu isolate para execução em background usando
callbacks e um callback dispatcher.

Adicionalmente, o plugin [WorkManager][] habilita processamento persistente em background
que mantém tarefas agendadas através de reinicializações do app e do sistema.

Para mais informações e um exemplo de geofencing que usa execução
em background de código Dart, veja o artigo no Medium por Ben Konyi,
[Executing Dart in the Background with Flutter Plugins and
Geofencing][background-processes]. No final deste artigo,
você encontrará links para código de exemplo e documentação relevante para Dart,
iOS e Android.

[background-processes]: {{site.flutter-medium}}/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124
[WorkManager]: {{site.pub-pkg}}/workmanager
