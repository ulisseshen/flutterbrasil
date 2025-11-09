---
ia-translate: true
title: Processos em background
description: Onde encontrar mais informações sobre implementação de processos em background no Flutter.
---

Você já quis executar código Dart em
background—mesmo se seu app não fosse o app ativo no momento?
Talvez você quisesse implementar um processo que observa o tempo,
ou que captura movimento da câmera.
No Flutter, você pode executar código Dart em background.

O mecanismo para este recurso envolve configurar um isolate.
_Isolates_ são o modelo do Dart para multithreading,
embora um isolate difira de uma thread convencional
por não compartilhar memória com o programa principal.
Você vai configurar seu isolate para execução em background usando
callbacks e um callback dispatcher.

Adicionalmente, o plugin [WorkManager][] habilita processamento em background persistente
que mantém tarefas agendadas através de reinicializações de app e reboots do sistema.

Para mais informações e um exemplo de geofencing que usa execução em background
de código Dart, veja o artigo no Medium por Ben Konyi,
[Executando Dart em Background com Flutter Plugins e
Geofencing][background-processes]. No final deste artigo,
você encontrará links para código de exemplo e documentação relevante para Dart,
iOS e Android.

[background-processes]: {{site.flutter-blog}}/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124
[WorkManager]: {{site.pub-pkg}}/workmanager
