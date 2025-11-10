---
ia-translate: true
title: Reproduzir e pausar um vídeo
description: Como usar o plugin video_player.
---

<?code-excerpt path-base="cookbook/plugins/play_video/"?>

Reproduzir vídeos é uma tarefa comum no desenvolvimento de apps,
e os apps Flutter não são exceção. Para reproduzir vídeos,
a equipe Flutter fornece o plugin [`video_player`][`video_player`].
Você pode usar o plugin `video_player` para reproduzir vídeos
armazenados no sistema de arquivos, como um asset ou da internet.

:::warning
No momento,
o plugin `video_player` não funciona em Linux e Windows.
Para saber mais, consulte o pacote [`video_player`][`video_player`].
:::

No iOS, o plugin `video_player` faz uso do
[`AVPlayer`][`AVPlayer`] para lidar com a reprodução. No Android,
ele usa o [`ExoPlayer`][`ExoPlayer`].

Esta receita demonstra como usar o pacote `video_player` para transmitir um
vídeo da internet com controles básicos de reprodução e pausa usando
as seguintes etapas:

  1. Adicionar a dependência `video_player`.
  2. Adicionar permissões ao seu app.
  3. Criar e inicializar um `VideoPlayerController`.
  4. Exibir o video player.
  5. Reproduzir e pausar o vídeo.

## 1. Adicionar a dependência `video_player`

Esta receita depende de um plugin Flutter: `video_player`.
Primeiro, adicione esta dependência ao seu projeto.

Para adicionar o pacote `video_player` como dependência, execute `flutter pub add`:

```console
$ flutter pub add video_player
```

## 2. Adicionar permissões ao seu app

Em seguida, atualize suas configurações `android` e `ios` para garantir
que seu app tenha as permissões corretas para transmitir vídeos
da internet.

### Android

Adicione a seguinte permissão ao arquivo `AndroidManifest.xml` logo após a
definição `<application>`. O arquivo `AndroidManifest.xml` está localizado em
`<project root>/android/app/src/main/AndroidManifest.xml`.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>

    </application>

    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

### iOS

Para iOS, adicione o seguinte ao arquivo `Info.plist` localizado em
`<project root>/ios/Runner/Info.plist`.

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

:::warning
O plugin `video_player` só pode reproduzir vídeos de assets em simuladores iOS.
Você deve testar vídeos hospedados em rede em dispositivos iOS físicos.
:::

### macOS

Se você usa vídeos baseados em rede,
[adicione o entitlement `com.apple.security.network.client`][mac-entitlement].

### Web

Flutter web **não** suporta `dart:io`,
então evite usar o construtor `VideoPlayerController.file` para o plugin.
Usar este construtor tenta criar um `VideoPlayerController.file`
que lança um `UnimplementedError`.

Diferentes navegadores web podem ter diferentes capacidades de reprodução de vídeo,
como formatos suportados ou autoplay.
Consulte o pacote [video_player_web] para mais informações específicas da web.

A opção `VideoPlayerOptions.mixWithOthers` não pode ser implementada na web,
pelo menos no momento. Se você usar esta opção na web, ela será ignorada silenciosamente.

## 3. Criar e inicializar um `VideoPlayerController`

Agora que você tem o plugin `video_player` instalado com as
permissões corretas, crie um `VideoPlayerController`. A
classe `VideoPlayerController` permite que você se conecte a diferentes tipos de
vídeos e controle a reprodução.

Antes de poder reproduzir vídeos, você também deve `initialize` o controller.
Isso estabelece a conexão com o vídeo e prepara o
controller para reprodução.

Para criar e inicializar o `VideoPlayerController`, faça o seguinte:

  1. Criar um `StatefulWidget` com uma classe `State` companheira
  2. Adicionar uma variável à classe `State` para armazenar o `VideoPlayerController`
  3. Adicionar uma variável à classe `State` para armazenar o `Future` retornado de
  `VideoPlayerController.initialize`
  4. Criar e inicializar o controller no método `initState`
  5. Descartar o controller no método `dispose`

<?code-excerpt "lib/main_step3.dart (VideoPlayerScreen)"?>
```dart
class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Complete the code in the next step.
    return Container();
  }
}
```

## 4. Exibir o video player

Agora, exiba o vídeo. O plugin `video_player` fornece o
widget [`VideoPlayer`][`VideoPlayer`] para exibir o vídeo inicializado pelo
`VideoPlayerController`.
Por padrão, o widget `VideoPlayer` ocupa o máximo de espaço possível.
Isso geralmente não é ideal para vídeos porque eles devem
ser exibidos em uma proporção de aspecto específica, como 16x9 ou 4x3.

Portanto, envolva o widget `VideoPlayer` em um widget [`AspectRatio`][`AspectRatio`]
para garantir que o vídeo tenha as proporções corretas.

Além disso, você deve exibir o widget `VideoPlayer` após o
`_initializeVideoPlayerFuture()` ser concluído. Use `FutureBuilder` para
exibir um spinner de carregamento até que o controller termine de inicializar.
Nota: inicializar o controller não inicia a reprodução.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/body: //g;/^\),$/)/g"?>
```dart
// Use a FutureBuilder to display a loading spinner while waiting for the
// VideoPlayerController to finish initializing.
FutureBuilder(
  future: _initializeVideoPlayerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // If the VideoPlayerController has finished initialization, use
      // the data it provides to limit the aspect ratio of the video.
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        // Use the VideoPlayer widget to display the video.
        child: VideoPlayer(_controller),
      );
    } else {
      // If the VideoPlayerController is still initializing, show a
      // loading spinner.
      return const Center(child: CircularProgressIndicator());
    }
  },
)
```

## 5. Reproduzir e pausar o vídeo

Por padrão, o vídeo começa em estado pausado. Para iniciar a reprodução,
chame o método [`play()`][`play()`] fornecido pelo `VideoPlayerController`.
Para pausar a reprodução, chame o método [`pause()`][`pause()`].

Para este exemplo,
adicione um `FloatingActionButton` ao seu app que exibe um ícone de play
ou pause dependendo da situação.
Quando o usuário tocar no botão,
reproduza o vídeo se ele estiver pausado no momento,
ou pause o vídeo se ele estiver sendo reproduzido.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  onPressed: () {
    // Wrap the play or pause in a call to `setState`. This ensures the
    // correct icon is shown.
    setState(() {
      // If the video is playing, pause it.
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // If the video is paused, play it.
        _controller.play();
      }
    });
  },
  // Display the correct icon depending on the state of the player.
  child: Icon(
    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
  ),
)
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter video player hands-on example in DartPad" run="true"
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Video Player Demo',
      home: VideoPlayerScreen(),
    );
  }
}

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen({super.key});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Butterfly Video')),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the VideoPlayerController has finished initialization, use
            // the data it provides to limit the aspect ratio of the video.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use the VideoPlayer widget to display the video.
              child: VideoPlayer(_controller),
            );
          } else {
            // If the VideoPlayerController is still initializing, show a
            // loading spinner.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Wrap the play or pause in a call to `setState`. This ensures the
          // correct icon is shown.
          setState(() {
            // If the video is playing, pause it.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // If the video is paused, play it.
              _controller.play();
            }
          });
        },
        // Display the correct icon depending on the state of the player.
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
    );
  }
}
```


[`AspectRatio`]: {{site.api}}/flutter/widgets/AspectRatio-class.html
[`AVPlayer`]: {{site.apple-dev}}/documentation/avfoundation/avplayer
[`ExoPlayer`]: https://google.github.io/ExoPlayer/
[`pause()`]: {{site.pub-api}}/video_player/latest/video_player/VideoPlayerController/pause.html
[`play()`]: {{site.pub-api}}/video_player/latest/video_player/VideoPlayerController/play.html
[`video_player`]: {{site.pub-pkg}}/video_player
[`VideoPlayer`]: {{site.pub-api}}/video_player/latest/video_player/VideoPlayer-class.html
[mac-entitlement]: {{site.url}}/platform-integration/macos/building#entitlements-and-the-app-sandbox
[video_player_web]: {{site.pub-pkg}}/video_player_web
