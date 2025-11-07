---
title: Fazer fade in de images com um placeholder
description: Como fazer fade de images.
ia-translate: true
---

<?code-excerpt path-base="cookbook/images/fading_in_images"?>

Ao exibir images usando o widget padrão `Image`,
você pode notar que elas simplesmente aparecem na tela conforme são carregadas.
Isso pode parecer visualmente perturbador para seus usuários.

Em vez disso, não seria legal exibir um placeholder primeiro,
e as images fariam fade in conforme são carregadas? Use o
widget [`FadeInImage`][] exatamente para esse propósito.

`FadeInImage` funciona com images de qualquer tipo: in-memory, assets locais,
ou images da internet.

## In-Memory

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

![Fading In Image Demo](/assets/images/docs/cookbook/fading-in-images.gif){:.site-mobile-screenshot}

## Do asset bundle

Você também pode considerar usar assets locais para placeholders.
Primeiro, adicione o asset ao arquivo `pubspec.yaml` do projeto
(para mais detalhes, veja [Adding assets and images][]):

```yaml diff
  flutter:
    assets:
+     - assets/loading.gif
```

Então, use o construtor [`FadeInImage.assetNetwork()`][]:

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

![Asset fade-in](/assets/images/docs/cookbook/fading-in-asset-demo.gif){:.site-mobile-screenshot}


[Adding assets and images]: /ui/assets/assets-and-images
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`FadeInImage.assetNetwork()`]: {{site.api}}/flutter/widgets/FadeInImage/FadeInImage.assetNetwork.html
[`transparent_image`]: {{site.pub-pkg}}/transparent_image
