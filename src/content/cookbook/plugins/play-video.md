---
ia-translate: true
title: Reproduzir e pausar um vídeo
description: Como usar o plugin video_player.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/plugins/play_video/"?>

Reproduzir vídeos é uma tarefa comum no desenvolvimento de aplicativos,
e os aplicativos Flutter não são exceção. Para reproduzir vídeos,
a equipe do Flutter fornece o plugin [`video_player`][].
Você pode usar o plugin `video_player` para reproduzir vídeos
armazenados no sistema de arquivos, como um asset ou da internet.

:::warning
Neste momento,
o plugin `video_player` não funciona no Linux e Windows.
Para saber mais, confira o pacote [`video_player`][].
:::

No iOS, o plugin `video_player` utiliza o
[`AVPlayer`][] para lidar com a reprodução. No Android,
ele usa o [`ExoPlayer`][].

Esta receita demonstra como usar o pacote `video_player` para transmitir um
vídeo da internet com controles básicos de reprodução e pausa usando
os seguintes passos:

  1. Adicione a dependência `video_player`.
  2. Adicione permissões ao seu aplicativo.
  3. Crie e inicialize um `VideoPlayerController`.
  4. Exiba o reprodutor de vídeo.
  5. Reproduza e pause o vídeo.

## 1. Adicione a dependência `video_player`

Esta receita depende de um plugin Flutter: `video_player`.
Primeiro, adicione esta dependência ao seu projeto.

Para adicionar o pacote `video_player` como dependência, execute `flutter pub add`:

```console
$ flutter pub add video_player
```

## 2. Adicione permissões ao seu aplicativo

Em seguida, atualize suas configurações `android` e `ios` para garantir
que seu aplicativo tenha as permissões corretas para transmitir vídeos
da internet.

### Android

Adicione a seguinte permissão ao arquivo `AndroidManifest.xml` logo após a
definição `<application>`. O arquivo `AndroidManifest.xml` é encontrado em
`<raiz do projeto>/android/app/src/main/AndroidManifest.xml`.

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application ...>

    </application>

    <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
```

### iOS

Para iOS, adicione o seguinte ao arquivo `Info.plist` encontrado em
`<raiz do projeto>/ios/Runner/Info.plist`.

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

:::warning
O plugin `video_player` só pode reproduzir vídeos de assets em simuladores iOS.
Você deve testar vídeos hospedados na rede em dispositivos iOS físicos.
:::

### macOS

Se você usar vídeos baseados em rede,
[adicione o direito `com.apple.security.network.client`][mac-entitlement].

### Web

O Flutter web **não** suporta `dart:io`,
portanto, evite usar o construtor `VideoPlayerController.file` para o plugin.
Usar este construtor tenta criar um `VideoPlayerController.file`
que lança um `UnimplementedError`.

Navegadores da web diferentes podem ter capacidades de reprodução de vídeo diferentes,
como formatos suportados ou reprodução automática.
Verifique o pacote [video_player_web] para mais informações específicas da web.

A opção `VideoPlayerOptions.mixWithOthers` não pode ser implementada na web,
pelo menos neste momento. Se você usar esta opção na web, ela será ignorada silenciosamente.

## 3. Crie e inicialize um `VideoPlayerController`

Agora que você tem o plugin `video_player` instalado com as permissões corretas,
crie um `VideoPlayerController`. A classe
`VideoPlayerController` permite que você se conecte a diferentes tipos de
vídeos e controle a reprodução.

Antes de reproduzir vídeos, você também deve `inicializar` o controller.
Isso estabelece a conexão com o vídeo e prepara o
controller para a reprodução.

Para criar e inicializar o `VideoPlayerController` faça o seguinte:

  1. Crie um `StatefulWidget` com uma classe `State` companheira
  2. Adicione uma variável à classe `State` para armazenar o `VideoPlayerController`
  3. Adicione uma variável à classe `State` para armazenar o `Future` retornado de
  `VideoPlayerController.initialize`
  4. Crie e inicialize o controller no método `initState`
  5. Descarte o controller no método `dispose`

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

    // Crie e armazene o VideoPlayerController. O VideoPlayerController
    // oferece vários construtores diferentes para reproduzir vídeos de assets, arquivos,
    // ou a internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Garanta o descarte do VideoPlayerController para liberar recursos.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Complete o código no próximo passo.
    return Container();
  }
}
```

## 4. Exiba o reprodutor de vídeo

Agora, exiba o vídeo. O plugin `video_player` fornece o
widget [`VideoPlayer`][] para exibir o vídeo inicializado pelo
`VideoPlayerController`.
Por padrão, o widget `VideoPlayer` ocupa o máximo de espaço possível.
Isso geralmente não é ideal para vídeos, porque eles são projetados
para serem exibidos em uma proporção específica, como 16x9 ou 4x3.

Portanto, envolva o widget `VideoPlayer` em um widget [`AspectRatio`][]
para garantir que o vídeo tenha as proporções corretas.

Além disso, você deve exibir o widget `VideoPlayer` após o
`_initializeVideoPlayerFuture()` ser concluído. Use `FutureBuilder` para
exibir um indicador de carregamento até que o controller termine a inicialização.
Observação: inicializar o controller não inicia a reprodução.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/body: //g;/^\),$/)/g"?>
```dart
// Use um FutureBuilder para exibir um indicador de carregamento enquanto espera o
// VideoPlayerController terminar a inicialização.
FutureBuilder(
  future: _initializeVideoPlayerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // Se o VideoPlayerController terminou a inicialização, use
      // os dados que ele fornece para limitar a proporção do vídeo.
      return AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        // Use o widget VideoPlayer para exibir o vídeo.
        child: VideoPlayer(_controller),
      );
    } else {
      // Se o VideoPlayerController ainda estiver inicializando, mostre um
      // indicador de carregamento.
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  },
)
```

## 5. Reproduza e pause o vídeo

Por padrão, o vídeo começa em um estado pausado. Para iniciar a reprodução,
chame o método [`play()`][] fornecido pelo `VideoPlayerController`.
Para pausar a reprodução, chame o método [`pause()`][].

Para este exemplo,
adicione um `FloatingActionButton` ao seu aplicativo que exibe um ícone de reprodução
ou pausa, dependendo da situação.
Quando o usuário tocar no botão,
reproduza o vídeo se ele estiver atualmente pausado,
ou pause o vídeo se estiver sendo reproduzido.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  onPressed: () {
    // Envolva a reprodução ou pausa em uma chamada a `setState`. Isso garante que o
    // ícone correto seja mostrado.
    setState(() {
      // Se o vídeo estiver sendo reproduzido, pause-o.
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        // Se o vídeo estiver pausado, reproduza-o.
        _controller.play();
      }
    });
  },
  // Exiba o ícone correto dependendo do estado do reprodutor.
  child: Icon(
    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
  ),
)
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático do reprodutor de vídeo Flutter no DartPad" run="true"
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() => runApp(const VideoPlayerApp());

class VideoPlayerApp extends StatelessWidget {
  const VideoPlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Demonstração do Reprodutor de Vídeo',
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

    // Crie e armazene o VideoPlayerController. O VideoPlayerController
    // oferece vários construtores diferentes para reproduzir vídeos de assets, arquivos,
    // ou a internet.
    _controller = VideoPlayerController.networkUrl(
      Uri.parse(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
      ),
    );

    // Inicialize o controller e armazene o Future para uso posterior.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use o controller para reproduzir o vídeo em loop.
    _controller.setLooping(true);
  }

  @override
  void dispose() {
    // Garanta o descarte do VideoPlayerController para liberar recursos.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vídeo da Borboleta'),
      ),
      // Use um FutureBuilder para exibir um indicador de carregamento enquanto espera o
      // VideoPlayerController terminar a inicialização.
      body: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Se o VideoPlayerController terminou a inicialização, use
            // os dados que ele fornece para limitar a proporção do vídeo.
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              // Use o widget VideoPlayer para exibir o vídeo.
              child: VideoPlayer(_controller),
            );
          } else {
            // Se o VideoPlayerController ainda estiver inicializando, mostre um
            // indicador de carregamento.
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Envolva a reprodução ou pausa em uma chamada a `setState`. Isso garante que o
          // ícone correto seja mostrado.
          setState(() {
            // Se o vídeo estiver sendo reproduzido, pause-o.
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              // Se o vídeo estiver pausado, reproduza-o.
              _controller.play();
            }
          });
        },
        // Exiba o ícone correto dependendo do estado do reprodutor.
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
