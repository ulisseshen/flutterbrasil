---
ia-translate: true
title: Reproduza ou transmita sons e músicas com flutter_soloud
description: >-
  Aprenda a reproduzir ou transmitir áudio no seu app Flutter
  usando o pacote flutter_soloud.
---

Esta receita demonstra como integrar o [pacote `flutter_soloud`][`flutter_soloud` package]
à sua aplicação Flutter para reproduzir efeitos sonoros e
músicas de fundo com baixa latência.
Para começar a usar o pacote, siga estes passos:

[`flutter_soloud` package]: {{site.pub-pkg}}/flutter_soloud

## 1. Adicione a dependência do pacote {:#1-add-the-package-dependency}

Para adicionar o `package:flutter_soloud` como dependência, use `flutter pub add`:

```console
$ flutter pub add flutter_soloud
```

## 2. Inicialize o `SoLoud` {:#2-initialize-soloud}

Antes de reproduzir qualquer áudio,
você precisa inicializar a instância do `SoLoud`.
Você também pode configurar opções de reprodução, como taxa de amostragem,
tamanho do buffer e número de canais.

```dart
import 'package:flutter_soloud/flutter_soloud.dart';

// Initialize with default settings.
await SoLoud.instance.init();

// Or configure with custom settings.
await SoLoud.instance.init(
  sampleRate: 44100,
  bufferSize: 2048,
  channels: Channels.stereo,
);
```

## 3. Carregue o áudio {:#3-load-audio}

O pacote `flutter_soloud` oferece suporte a vários formatos de áudio,
incluindo MP3, WAV, OGG e FLAC.
Você pode carregar áudio de diferentes fontes.

A partir de um arquivo local:

```dart
final sound = await SoLoud.instance.loadFile('path/to/sound.mp3');
```

A partir de um asset do app:

```dart
final sound = await SoLoud.instance.loadAsset('assets/sound.mp3');
```

A partir de uma URL de rede:

```dart
final sound = await SoLoud.instance.loadUrl(
  'https://example.com/sound.mp3',
  mode: LoadMode.memory,
);
```

A partir de bytes na memória:

```dart
// TODO: Replace with your actual audio data.
final soundBytes = Uint8List.fromList([]);

final sound = await SoLoud.instance.loadMem(
  'reference_name.mp3',
  soundBytes,
  mode: LoadMode.memory,
);
```

## 4. Reproduza o áudio {:#4-play-audio}

Depois que o áudio for carregado,
você pode reproduzi-lo usando `SoLoud.instance.play`.
Você também pode configurar a repetição sem interrupções (gapless).

```dart
// Play the sound.
var handle = await SoLoud.instance.play(sound);

// Play with gapless looping.
handle = await SoLoud.instance.play(
  sound,
  looping: true,
  loopingStartAt: Duration(seconds: 1),
);
```

O método `play` retorna um handle que referencia
aquela instância específica do som em reprodução.
Você pode usar esse handle para controlar a reprodução.

## 5. Controle a reprodução {:#5-control-playback}

Com o handle retornado por `play`,
você pode executar várias ações, como pausar ou retomar a reprodução:

```dart
// Toggle pause state.
SoLoud.instance.pauseSwitch(handle);
```

Avance até um timestamp específico:

```dart
SoLoud.instance.seek(handle, Duration(seconds: 5));
```

Defina a velocidade de reprodução:

```dart
// Play twice as fast.
SoLoud.instance.setRelativePlaySpeed(handle, 2.0);
```

Ajuste o volume de reprodução:

```dart
// Set playback to 50% volume.
SoLoud.instance.setVolume(handle, 0.5);
```

Aplique um fade no volume do áudio:

```dart
SoLoud.instance.fadeVolume(
  handle,
  0.0, // The volume to fade to.
  Duration(seconds: 2), // The duration of the fade.
);
```

Pare a reprodução:

```dart
await SoLoud.instance.stop(handle);
```

## 6. Descarte as fontes de som {:#6-dispose-of-sound-sources}

Quando terminar com uma fonte de som,
lembre-se de descartá-la para liberar recursos.

```dart
await SoLoud.instance.disposeSource(sound);
```

## 7. [Opcional] Transmita áudio {:#7-optional-stream-audio}

O pacote `flutter_soloud` também oferece suporte à transmissão
de dados de áudio em tempo real.

Inicialize e configure um stream de buffer:

```dart
final stream = SoLoud.instance.setBufferStream(
  bufferingType: BufferingType.released,
  sampleRate: 24000,
  channels: Channels.mono,
  format: BufferType.s16le, // pcm16bits
);
```

Reproduza o stream:

```dart
final handle = await SoLoud.instance.play(stream);
```

Conforme o app recebe dados de áudio, adicione-os ao stream:

```dart
// TODO: Replace with your actual audio data.
final audioChunk = Uint8List.fromList([]);

SoLoud.instance.addAudioDataStream(
  stream,
  audioChunk,
);
```

Quando terminar com o stream de áudio, marque-o como concluído:

```dart
SoLoud.instance.setDataIsEnded(stream);
```

## Mais informações {:#more-information}

Para informações e exemplos mais detalhados,
visite o [pacote `flutter_soloud`][`flutter_soloud` package] no pub.dev ou
assista ao vídeo do Package of the Week sobre o `flutter_soloud`.

<div class="video-wrapper">
  <YouTubeEmbed id="2t6Bt04EyLw" title="flutter_soloud - Package of the Week"></YouTubeEmbed>
</div>
