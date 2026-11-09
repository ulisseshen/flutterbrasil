---
ia-translate: true
title: Aplicar fade in em imagens com um placeholder
description: Como aplicar fade in em imagens.
---

<?code-excerpt path-base="cookbook/images/fading_in_images"?>

Ao exibir imagens usando o widget padrão `Image`,
você pode notar que elas simplesmente aparecem na tela enquanto são carregadas.
Isso pode parecer visualmente desagradável para seus usuários.

Em vez disso, não seria legal exibir um placeholder primeiro,
e as imagens aplicariam fade in conforme são carregadas? Use o
widget [`FadeInImage`][`FadeInImage`] exatamente para esse propósito.

`FadeInImage` funciona com imagens de qualquer tipo: in-memory, assets locais,
ou imagens da internet.

## In-memory

Para usar um PNG transparente de um único pixel como imagem de placeholder,
conclua os seguintes passos:

1.  **Crie os dados da imagem transparente.**

    Importe `dart:convert` e `dart:typed_data`,
    e então decodifique a imagem a partir de uma string codificada em Base64:

    <?code-excerpt "lib/memory_main.dart (TransparentImage)" plaster="none"?>
    ```dart
    import 'dart:convert';
    import 'dart:typed_data';
    final Uint8List transparentImage = base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4'
      'nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
    );
    ```

1.  **Use os dados da imagem como placeholder.**

    Passe os dados da imagem decodificada para o parâmetro `placeholder`:

    <?code-excerpt "lib/memory_main.dart (MemoryNetwork)" replace="/^child\: //g"?>
    ```dart
    FadeInImage.memoryNetwork(
      placeholder: transparentImage,
      image: 'https://picsum.photos/250?image=9',
    ),
    ```

{:.steps}

### Exemplo completo

<?code-excerpt "lib/memory_main.dart"?>
```dart
import 'dart:convert';
import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

final Uint8List transparentImage = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAACklEQVR4'
  'nGMAAQAABQABDQottAAAAABJRU5ErkJggg==',
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Fade in images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Stack(
          children: <Widget>[
            const Center(child: CircularProgressIndicator()),
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: transparentImage,
                image: 'https://picsum.photos/250?image=9',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

![Fading In Image Demo](/assets/images/docs/cookbook/fading-in-images.webp){:.site-mobile-screenshot}

## Do asset bundle

Para usar um asset de imagem local como imagem de placeholder,
conclua os seguintes passos:

1.  **Adicione o placeholder ao asset bundle.**

    Adicione uma imagem de placeholder ao diretório `assets` do projeto,
    como `assets/loading.gif`.
    Em seguida, declare o asset no arquivo `pubspec.yaml` do projeto.
    Para mais detalhes, veja [Adicionando assets e imagens][Adding assets and images].

    ```yaml diff
      flutter:
        assets:
    +     - assets/loading.gif
    ```

1.  **Use o asset como placeholder.**

    Passe o caminho do asset para o parâmetro `placeholder` do
    construtor [`FadeInImage.assetNetwork`][]:

    <?code-excerpt "lib/asset_main.dart (AssetNetwork)" replace="/^child\: //g"?>
    ```dart
    FadeInImage.assetNetwork(
      placeholder: 'assets/loading.gif',
      image: 'https://picsum.photos/250?image=9',
    ),
    ```

{:.steps}

### Exemplo completo

<?code-excerpt "lib/asset_main.dart"?>
```dart
import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Fade in images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Center(
          child: FadeInImage.assetNetwork(
            placeholder: 'assets/loading.gif',
            image: 'https://picsum.photos/250?image=9',
          ),
        ),
      ),
    );
  }
}
```

![Asset fade-in](/assets/images/docs/cookbook/fading-in-asset-demo.webp){:.site-mobile-screenshot}


[Adding assets and images]: /ui/assets/assets-and-images
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`FadeInImage.assetNetwork`]: {{site.api}}/flutter/widgets/FadeInImage/FadeInImage.assetNetwork.html
