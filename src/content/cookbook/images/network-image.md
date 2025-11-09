---
ia-translate: true
title: Exibir imagens da internet
description: Como exibir imagens da internet.
---

<?code-excerpt path-base="cookbook/images/network_image"?>

Exibir imagens é fundamental para a maioria dos apps mobile.
Flutter fornece o widget [`Image`][`Image`] para
exibir diferentes tipos de imagens.

Para trabalhar com imagens de uma URL, use o
construtor [`Image.network()`][`Image.network()`].

<?code-excerpt "lib/main.dart (ImageNetwork)" replace="/^body\: //g"?>
```dart
Image.network('https://picsum.photos/250?image=9'),
```

## Bônus: gifs animados

Uma coisa útil sobre o widget `Image`:
Ele suporta gifs animados.

<?code-excerpt "lib/gif.dart (Gif)" replace="/^return\ //g"?>
```dart
Image.network(
  'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif',
);
```

## Fade in de imagens com placeholders

O construtor padrão `Image.network` não lida com funcionalidades
mais avançadas, como aplicar fade in em imagens após o carregamento.
Para realizar essa tarefa,
confira [Aplicar fade in em imagens com um placeholder][Fade in images with a placeholder].

* [Aplicar fade in em imagens com um placeholder][Fade in images with a placeholder]

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter network images hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var title = 'Web Images';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Image.network('https://picsum.photos/250?image=9'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/network-image.png" alt="Network image demo" class="site-mobile-screenshot" />
</noscript>


[Fade in images with a placeholder]: /cookbook/images/fading-in-images
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`Image.network()`]: {{site.api}}/flutter/widgets/Image/Image.network.html
