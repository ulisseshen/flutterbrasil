---
ia-translate: true
title: Processos em segundo plano
description: Onde encontrar mais informações sobre a implementação de processos em segundo plano no Flutter.
---

Você já quis executar código Dart em segundo plano—mesmo se seu app não fosse o app ativo no momento? Talvez você quisesse implementar um processo que observasse o tempo, ou que capturasse o movimento da câmera. No Flutter, você pode executar código Dart em segundo plano.

O mecanismo para esse recurso envolve configurar um _isolate_. _Isolates_ são o modelo do Dart para multithreading, embora um isolate difira de uma thread convencional no sentido de que ele não compartilha memória com o programa principal. Você configurará seu isolate para execução em segundo plano usando callbacks e um despachante de callback.

Além disso, o plugin [WorkManager] permite o processamento persistente em segundo plano que mantém as tarefas agendadas por meio de reinicializações de aplicativos e reinicializações do sistema.

Para obter mais informações e um exemplo de geofencing que usa a execução em segundo plano de código Dart, consulte o artigo do Medium de Ben Konyi, [Executando Dart em Segundo Plano com Plugins Flutter e Geofencing][background-processes]. No final deste artigo, você encontrará links para exemplos de código e documentação relevante para Dart, iOS e Android.

[background-processes]: {{site.flutter-medium}}/executing-dart-in-the-background-with-flutter-plugins-and-geofencing-2b3e40a1a124
[WorkManager]: {{site.pub-pkg}}/workmanager
