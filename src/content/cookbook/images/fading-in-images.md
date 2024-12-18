---
ia-translate: true
title: Efeito de Fade-in em Imagens com um Placeholder
description: Como aplicar um efeito de fade-in em imagens ao carregá-las.
---

<?code-excerpt path-base="cookbook/images/fading_in_images"?>

Ao exibir imagens usando o widget `Image` padrão,
você pode notar que elas simplesmente aparecem na tela assim que são carregadas.
Isso pode ser visualmente incômodo para seus usuários.

Em vez disso, não seria bom exibir um placeholder no início,
e as imagens surgirem com um efeito de fade-in ao serem carregadas? Use o
widget [`FadeInImage`][] exatamente para esse propósito.

`FadeInImage` funciona com imagens de qualquer tipo: em memória, assets locais,
ou imagens da internet.

## Em memória

Neste exemplo, use o pacote [`transparent_image`][]
para um placeholder transparente simples.

<?code-excerpt "lib/memory_main.dart (MemoryNetwork)" replace="/^child\: //g"?>
```dart
FadeInImage.memoryNetwork(
  placeholder: kTransparentImage,
  image: 'https://picsum.photos/250?image=9',
),
```

### Exemplo completo

<?code-excerpt "lib/memory_main.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

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
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Stack(
          children: <Widget>[
            const Center(child: CircularProgressIndicator()),
            Center(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
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

![Demonstração de Fade-in de Imagem](/assets/images/docs/cookbook/fading-in-images.gif){:.site-mobile-screenshot}

## Do bundle de assets

Você também pode considerar usar assets locais para placeholders.
Primeiro, adicione o asset ao arquivo `pubspec.yaml` do projeto
(para mais detalhes, veja [Adicionando assets e imagens][]):

```yaml diff
  flutter:
    assets:
+     - assets/loading.gif
```

Em seguida, use o construtor [`FadeInImage.assetNetwork()`][]:

<?code-excerpt "lib/asset_main.dart (AssetNetwork)" replace="/^child\: //g"?>
```dart
FadeInImage.assetNetwork(
  placeholder: 'assets/loading.gif',
  image: 'https://picsum.photos/250?image=9',
),
```

### Exemplo completo

<?code-excerpt "lib/asset_main.dart"?>
```dart
import 'package:flutter/material.dart';

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
        appBar: AppBar(
          title: const Text(title),
        ),
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

![Fade-in de asset](/assets/images/docs/cookbook/fading-in-asset-demo.gif){:.site-mobile-screenshot}


[Adicionando assets e imagens]: /ui/assets/assets-and-images
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`FadeInImage.assetNetwork()`]: {{site.api}}/flutter/widgets/FadeInImage/FadeInImage.assetNetwork.html
[`transparent_image`]: {{site.pub-pkg}}/transparent_image
