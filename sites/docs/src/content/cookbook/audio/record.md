---
ia-translate: true
title: Grave ou transmita entrada de áudio
description: >-
  Aprenda a gravar ou transmitir entrada de áudio no seu app Flutter
  usando o pacote record.
---

Esta receita demonstra como usar o [pacote `record`][`record` package] para adicionar
recursos de gravação e streaming de áudio ao seu app Flutter.
Para começar a usar o pacote, siga estes passos:

[`record` package]: {{site.pub-pkg}}/record

## 1. Adicione a dependência do pacote {:#1-add-the-package-dependency}

Para adicionar o `package:record` como dependência, use `flutter pub add`:

```console
$ flutter pub add record
```

## 2. Inicialize um `AudioRecorder` {:#2-initialize-an-audiorecorder}

Inicialize um objeto `AudioRecorder`. Este é o objeto principal
que controla o processo de gravação.

```dart
import 'package:record/record.dart';

final recorder = AudioRecorder();
```

## 3. Solicite a permissão do usuário {:#3-request-user-permission}

Antes de gravar, você precisa solicitar a permissão do usuário.
Também pode ser necessário adicionar configurações de permissão específicas de cada plataforma.
Consulte a documentação do [pacote `record`][`record` package] para mais detalhes.

```dart
final recorder = AudioRecorder();
if (await recorder.hasPermission()) {
  // Permission granted, proceed with recording.
} else {
  // Permission denied.
}
```

## 4. Crie uma configuração de gravação {:#4-create-a-recording-configuration}

Crie e configure um objeto `RecordConfig` para especificar as configurações de gravação,
como o codificador, a taxa de amostragem e o número de canais.
Você também pode ativar recursos como ganho automático, cancelamento de eco
e supressão de ruído.

```dart
final recordConfig = RecordConfig(
  encoder: AudioEncoder.pcm16bits,
  sampleRate: 24000,
  numChannels: 1,
  autoGain: true,
  echoCancel: true,
  noiseSuppress: true,
);
```

## 5. Comece a gravar em um arquivo {:#5-start-recording-to-a-file}

Para começar a gravar em um arquivo,
chame o método `start` do `AudioRecorder`,
passando o `recordConfig` que você definiu
e o caminho onde o arquivo deve ser armazenado.

```dart
// TODO: Specify the path where the audio file should be saved.
final audioFilePath = 'myRecording.wav';
await recorder.start(recordConfig, path: audioFilePath);
```

## 6. Controle uma gravação em andamento {:#6-control-an-ongoing-recording}

Você pode controlar uma gravação em andamento usando os métodos
`pause`, `resume` e `stop` do `AudioRecorder`.

```dart
await recorder.pause();
await recorder.resume();
await recorder.stop();
```

## 7. [Opcional] Grave em um stream de áudio {:#7-optional-record-to-an-audio-stream}

Para transmitir áudio, use o método `startStream`.
Ele retorna um [stream][stream] de dados de áudio.

```dart
final stream = await recorder.startStream(recordConfig);
stream.listen((audioChunk) {
  // Process the audio data. For example, send it to a server.
});
```

[stream]: {{site.api}}/flutter/dart-async/Stream-class.html

## 8. Pare a gravação {:#8-stop-recording}

Para parar a gravação e obter o caminho do arquivo salvo,
chame o método assíncrono `stop` do `AudioRecorder`.

```dart
final path = await recorder.stop();
print('Recording stopped. File saved to: $path');
```

## 9. Libere o recorder {:#9-dispose-of-the-recorder}

Quando terminar de usar o `AudioRecorder`,
lembre-se de chamar seu método `dispose` para liberar seus recursos.

```dart
await recorder.dispose();
```

## Formatos e codificações suportados {:#supported-formats-and-encodings}

O pacote `record` suporta vários codificadores e formatos de arquivo,
mas o suporte varia de acordo com a plataforma.
Para a lista completa de codificadores suportados por plataforma,
consulte a [tabela de suporte a codificação][encoding support table] do pacote.

Para informações mais detalhadas e exemplos,
visite a página do [pacote `record`][`record` package] no pub.dev ou
assista ao vídeo Package of the Week sobre o `record`.

<div class="video-wrapper">
  <YouTubeEmbed id="Vv2A_nUL1tw" title="record - Package of the Week"></YouTubeEmbed>
</div>

[encoding support table]: {{site.pub-pkg}}/record#file
