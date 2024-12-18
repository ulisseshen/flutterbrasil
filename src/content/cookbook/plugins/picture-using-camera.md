---
ia-translate: true
title: Tirar uma foto usando a câmera
description: Como usar um plugin de câmera no celular.
---

<?code-excerpt path-base="cookbook/plugins/picture_using_camera/"?>

Muitos aplicativos exigem trabalhar com as câmeras do dispositivo para tirar fotos e vídeos. O Flutter fornece o plugin [`camera`][] para essa finalidade. O plugin `camera` fornece ferramentas para obter uma lista das câmeras disponíveis, exibir uma prévia de uma câmera específica e tirar fotos ou vídeos.

:::note
O plugin [`camera_android_camerax`][],
construído sobre a biblioteca [CameraX][] do Android,
melhora a resolução da imagem com a seleção automática
da resolução com base na capacidade do dispositivo.
Este plugin também ajuda a lidar com _peculiaridades do dispositivo_,
definidas como hardware de câmera que pode
não funcionar como esperado.

Para mais informações,
confira a palestra do Google I/O 2024,
[Building picture perfect camera experiences in Flutter with CameraX][camerax-video].
:::

[`camera_android_camerax`]: {{site.pub-pkg}}/camera_android_camerax
[CameraX]: https://developer.android.com/training/camerax
[camerax-video]: {{site.youtube-site}}/watch?v=d1sRCa5k2Sg&t=1s

Esta receita demonstra como usar o plugin `camera` para exibir uma prévia,
tirar uma foto e exibi-la usando as seguintes etapas:

  1. Adicione as dependências necessárias.
  2. Obtenha uma lista das câmeras disponíveis.
  3. Crie e inicialize o `CameraController`.
  4. Use um `CameraPreview` para exibir o feed da câmera.
  5. Tire uma foto com o `CameraController`.
  6. Exiba a foto com um widget `Image`.

## 1. Adicione as dependências necessárias

Para concluir esta receita, você precisa adicionar três dependências ao seu aplicativo:

[`camera`][]
: Fornece ferramentas para trabalhar com as câmeras do dispositivo.

[`path_provider`][]
: Encontra os caminhos corretos para armazenar imagens.

[`path`][]
: Cria caminhos que funcionam em qualquer plataforma.

Para adicionar os pacotes como dependências, execute `flutter pub add`:

```console
$ flutter pub add camera path_provider path
```

:::tip
- Para o Android, você deve atualizar `minSdkVersion` para 21 (ou superior).
- No iOS, as seguintes linhas devem ser adicionadas dentro
  de `ios/Runner/Info.plist` para acessar a câmera e o microfone.

  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Explicação sobre por que o acesso à câmera é necessário.</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>Explicação sobre por que o acesso ao microfone é necessário.</string>
  ```
:::

## 2. Obtenha uma lista das câmeras disponíveis

Em seguida, obtenha uma lista de câmeras disponíveis usando o plugin `camera`.

<?code-excerpt "lib/main.dart (init)"?>
```dart
// Garanta que os serviços do plugin sejam inicializados para que `availableCameras()`
// possa ser chamado antes de `runApp()`
WidgetsFlutterBinding.ensureInitialized();

// Obtenha uma lista das câmeras disponíveis no dispositivo.
final cameras = await availableCameras();

// Obtenha uma câmera específica da lista de câmeras disponíveis.
final firstCamera = cameras.first;
```

## 3. Crie e inicialize o `CameraController`

Depois de ter uma câmera, use as seguintes etapas para
criar e inicializar um `CameraController`.
Esse processo estabelece uma conexão com
a câmera do dispositivo que permite controlar a câmera
e exibir uma prévia do feed da câmera.

  1. Crie um `StatefulWidget` com uma classe `State` associada.
  2. Adicione uma variável à classe `State` para armazenar o `CameraController`.
  3. Adicione uma variável à classe `State` para armazenar o `Future`
     retornado de `CameraController.initialize()`.
  4. Crie e inicialize o controlador no método `initState()`.
  5. Descarte o controlador no método `dispose()`.

<?code-excerpt "lib/main_step3.dart (controller)" remove="ignore:"?>
```dart
// Uma tela que permite aos usuários tirar uma foto usando uma câmera específica.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Para exibir a saída atual da Câmera,
    // crie um CameraController.
    _controller = CameraController(
      // Obtenha uma câmera específica da lista de câmeras disponíveis.
      widget.camera,
      // Defina a resolução a ser usada.
      ResolutionPreset.medium,
    );

    // Em seguida, inicialize o controlador. Isso retorna um Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Descarte o controlador quando o widget for descartado.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Preencha isso nas próximas etapas.
    return Container();
  }
}
```

:::warning
Se você não inicializar o `CameraController`,
você *não pode* usar a câmera para exibir uma prévia e tirar fotos.
:::

## 4. Use um `CameraPreview` para exibir o feed da câmera

Em seguida, use o widget `CameraPreview` do pacote `camera` para
exibir uma prévia do feed da câmera.

:::note Lembre-se
Você deve esperar até que o controlador tenha terminado
de inicializar antes de trabalhar com a câmera. Portanto,
você deve esperar que o `_initializeControllerFuture()`, criado
na etapa anterior, seja concluído antes de mostrar um `CameraPreview`.
:::

Use um [`FutureBuilder`][] exatamente para esse propósito.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/body: //g;/^\),$/)/g"?>
```dart
// Você deve esperar até que o controlador seja inicializado antes de exibir a
// prévia da câmera. Use um FutureBuilder para exibir um indicador de carregamento até que o
// controlador termine de inicializar.
FutureBuilder<void>(
  future: _initializeControllerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // Se o Future estiver completo, exiba a prévia.
      return CameraPreview(_controller);
    } else {
      // Caso contrário, exiba um indicador de carregamento.
      return const Center(child: CircularProgressIndicator());
    }
  },
)
```

## 5. Tire uma foto com o `CameraController`

Você pode usar o `CameraController` para tirar fotos usando o
método [`takePicture()`][], que retorna um [`XFile`][],
uma abstração `File` multiplataforma simplificada.
Tanto no Android quanto no IOS, a nova imagem é armazenada em seus
respectórios diretórios de cache,
e o `path` para esse local é retornado no `XFile`.

Neste exemplo, crie um `FloatingActionButton` que tire uma foto
usando o `CameraController` quando um usuário tocar no botão.

Tirar uma foto requer 2 etapas:

  1. Garanta que a câmera esteja inicializada.
  2. Use o controlador para tirar uma foto e garantir
     que ele retorne um `Future<XFile>`.

É uma boa prática envolver essas operações em um bloco `try / catch` para
lidar com quaisquer erros que possam ocorrer.

<?code-excerpt "lib/main_step5.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  // Forneça um callback onPressed.
  onPressed: () async {
    // Tire a Foto em um bloco try / catch. Se algo der errado,
    // capture o erro.
    try {
      // Garanta que a câmera esteja inicializada.
      await _initializeControllerFuture;

      // Tente tirar uma foto e, em seguida, obtenha o local
      // onde o arquivo de imagem é salvo.
      final image = await _controller.takePicture();
    } catch (e) {
      // Se ocorrer um erro, registre o erro no console.
      print(e);
    }
  },
  child: const Icon(Icons.camera_alt),
)
```
## 6. Exiba a foto com um widget `Image`

Se você tirar a foto com sucesso, poderá exibir a foto salva
usando um widget `Image`. Neste caso, a foto é armazenada como um arquivo no
dispositivo.

Portanto, você deve fornecer um `File` para o construtor `Image.file`.
Você pode criar uma instância da classe `File` passando o caminho criado em
a etapa anterior.

<?code-excerpt "lib/image_file.dart (ImageFile)" replace="/^return\ //g"?>
```dart
Image.file(File('path/to/my/picture.png'));
```

## Exemplo completo

<?code-excerpt "lib/main.dart"?>
```dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // Garanta que os serviços do plugin sejam inicializados para que `availableCameras()`
  // possa ser chamado antes de `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtenha uma lista das câmeras disponíveis no dispositivo.
  final cameras = await availableCameras();

  // Obtenha uma câmera específica da lista de câmeras disponíveis.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Passe a câmera apropriada para o widget TakePictureScreen.
        camera: firstCamera,
      ),
    ),
  );
}

// Uma tela que permite aos usuários tirar uma foto usando uma câmera específica.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // Para exibir a saída atual da Câmera,
    // crie um CameraController.
    _controller = CameraController(
      // Obtenha uma câmera específica da lista de câmeras disponíveis.
      widget.camera,
      // Defina a resolução a ser usada.
      ResolutionPreset.medium,
    );

    // Em seguida, inicialize o controlador. Isso retorna um Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Descarte o controlador quando o widget for descartado.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tirar uma foto')),
      // Você deve esperar até que o controlador seja inicializado antes de exibir a
      // prévia da câmera. Use um FutureBuilder para exibir um indicador de carregamento até que o
      // controlador termine de inicializar.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // Se o Future estiver completo, exiba a prévia.
            return CameraPreview(_controller);
          } else {
            // Caso contrário, exiba um indicador de carregamento.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Forneça um callback onPressed.
        onPressed: () async {
          // Tire a Foto em um bloco try / catch. Se algo der errado,
          // capture o erro.
          try {
            // Garanta que a câmera esteja inicializada.
            await _initializeControllerFuture;

            // Tente tirar uma foto e obter o arquivo `image`
            // onde ele foi salvo.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // Se a foto foi tirada, exiba-a em uma nova tela.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Passe o caminho gerado automaticamente para
                  // o widget DisplayPictureScreen.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // Se ocorrer um erro, registre o erro no console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// Um widget que exibe a foto tirada pelo usuário.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exibir a Foto')),
      // A imagem é armazenada como um arquivo no dispositivo. Use o construtor `Image.file`
      // com o caminho fornecido para exibir a imagem.
      body: Image.file(File(imagePath)),
    );
  }
}
```


[`camera`]: {{site.pub-pkg}}/camera
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`path`]: {{site.pub-pkg}}/path
[`path_provider`]: {{site.pub-pkg}}/path_provider
[`takePicture()`]: {{site.pub}}/documentation/camera/latest/camera/CameraController/takePicture.html
[`XFile`]:  {{site.pub}}/documentation/cross_file/latest/cross_file/XFile-class.html
