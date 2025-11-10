---
title: Tirar uma foto usando a câmera
description: Como usar um plugin de câmera no celular.
ia-translate: true
---

<?code-excerpt path-base="cookbook/plugins/picture_using_camera/"?>

Muitos aplicativos exigem trabalhar com as câmeras do dispositivo para
tirar fotos e vídeos. O Flutter fornece o plugin [`camera`][]
para esse propósito. O plugin `camera` fornece ferramentas para obter uma lista das
câmeras disponíveis, exibir uma visualização vinda de uma câmera específica
e tirar fotos ou vídeos.

:::note
O plugin [`camera_android_camerax`][],
construído sobre a biblioteca Android [CameraX][],
melhora a resolução da imagem com seleção automática
da resolução com base na capacidade do dispositivo.
Este plugin também ajuda a lidar com _peculiaridades do dispositivo_,
definidas como hardware de câmera que pode
não funcionar como esperado.

Para mais informações,
confira a palestra do Google I/O 2024,
[Construindo experiências de câmera perfeitas no Flutter com CameraX][camerax-video].
:::

[`camera_android_camerax`]: {{site.pub-pkg}}/camera_android_camerax
[CameraX]: https://developer.android.com/training/camerax
[camerax-video]: {{site.youtube-site}}/watch?v=d1sRCa5k2Sg&t=1s

Esta receita demonstra como usar o plugin `camera` para exibir uma visualização,
tirar uma foto e exibi-la usando as seguintes etapas:

  1. Adicionar as dependências necessárias.
  2. Obter uma lista das câmeras disponíveis.
  3. Criar e inicializar o `CameraController`.
  4. Usar um `CameraPreview` para exibir o feed da câmera.
  5. Tirar uma foto com o `CameraController`.
  6. Exibir a foto com um widget `Image`.

## 1. Adicionar as dependências necessárias

Para completar esta receita, você precisa adicionar três dependências ao seu aplicativo:

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
- Para Android, você deve atualizar `minSdkVersion` para 21 (ou superior).
- No iOS, as seguintes linhas devem ser adicionadas dentro de
  `ios/Runner/Info.plist` para acessar a câmera e o microfone.

  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Explanation on why the camera access is needed.</string>
  <key>NSMicrophoneUsageDescription</key>
  <string>Explanation on why the microphone access is needed.</string>
  ```
:::

## 2. Obter uma lista das câmeras disponíveis

Em seguida, obtenha uma lista de câmeras disponíveis usando o plugin `camera`.

<?code-excerpt "lib/main.dart (init)"?>
```dart
// Ensure that plugin services are initialized so that `availableCameras()`
// can be called before `runApp()`
WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
final firstCamera = cameras.first;
```

## 3. Criar e inicializar o `CameraController`

Depois de ter uma câmera, use as seguintes etapas para
criar e inicializar um `CameraController`.
Este processo estabelece uma conexão com
a câmera do dispositivo que permite controlar a câmera
e exibir uma visualização do feed da câmera.

  1. Criar um `StatefulWidget` com uma classe `State` complementar.
  2. Adicionar uma variável à classe `State` para armazenar o `CameraController`.
  3. Adicionar uma variável à classe `State` para armazenar o `Future`
     retornado de `CameraController.initialize()`.
  4. Criar e inicializar o controlador no método `initState()`.
  5. Descartar o controlador no método `dispose()`.

<?code-excerpt "lib/main_step3.dart (controller)" remove="ignore:"?>
```dart
// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

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
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Container();
  }
}
```

:::warning
Se você não inicializar o `CameraController`,
você *não pode* usar a câmera para exibir uma visualização e tirar fotos.
:::

## 4. Usar um `CameraPreview` para exibir o feed da câmera

Em seguida, use o widget `CameraPreview` do pacote `camera` para
exibir uma visualização do feed da câmera.

:::note Lembre-se
Você deve esperar até que o controlador termine
de inicializar antes de trabalhar com a câmera. Portanto,
você deve esperar pelo `_initializeControllerFuture()`, criado
na etapa anterior, ser concluído antes de mostrar um `CameraPreview`.
:::

Use um [`FutureBuilder`][] exatamente para esse propósito.

<?code-excerpt "lib/main.dart (FutureBuilder)" replace="/body: //g;/^\),$/)/g"?>
```dart
// You must wait until the controller is initialized before displaying the
// camera preview. Use a FutureBuilder to display a loading spinner until the
// controller has finished initializing.
FutureBuilder<void>(
  future: _initializeControllerFuture,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
      // If the Future is complete, display the preview.
      return CameraPreview(_controller);
    } else {
      // Otherwise, display a loading indicator.
      return const Center(child: CircularProgressIndicator());
    }
  },
)
```

## 5. Tirar uma foto com o `CameraController`

Você pode usar o `CameraController` para tirar fotos usando o
método [`takePicture()`][], que retorna um [`XFile`][],
uma abstração de `File` simplificada e multiplataforma.
Tanto no Android quanto no iOS, a nova imagem é armazenada em seus
respectivos diretórios de cache,
e o `path` para essa localização é retornado no `XFile`.

Neste exemplo, crie um `FloatingActionButton` que tira uma foto
usando o `CameraController` quando um usuário toca no botão.

Tirar uma foto requer 2 etapas:

  1. Garantir que a câmera esteja inicializada.
  2. Usar o controlador para tirar uma foto e garantir
     que ele retorne um `Future<XFile>`.

É uma boa prática envolver essas operações em um bloco `try / catch` para
lidar com quaisquer erros que possam ocorrer.

<?code-excerpt "lib/main_step5.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  // Provide an onPressed callback.
  onPressed: () async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and then get the location
      // where the image file is saved.
      final image = await _controller.takePicture();
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  },
  child: const Icon(Icons.camera_alt),
)
```
## 6. Exibir a foto com um widget `Image`

Se você tirar a foto com sucesso, poderá então exibir a foto salva
usando um widget `Image`. Neste caso, a foto é armazenada como um arquivo no
dispositivo.

Portanto, você deve fornecer um `File` para o construtor `Image.file`.
Você pode criar uma instância da classe `File` passando o caminho criado na
etapa anterior.

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
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras.first;

  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({super.key, required this.camera});

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
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            if (!context.mounted) return;

            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
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
