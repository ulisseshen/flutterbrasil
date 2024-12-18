---
ia-translate: true
title: Exibir imagens da internet
description: Como exibir imagens da internet.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/images/network_image"?>

Exibir imagens é fundamental para a maioria dos aplicativos móveis. O Flutter fornece o widget [`Image`][] para exibir diferentes tipos de imagens.

Para trabalhar com imagens de uma URL, use o construtor [`Image.network()`][].

<?code-excerpt "lib/main.dart (ImageNetwork)" replace="/^body\: //g"?>
```dart
Image.network('https://picsum.photos/250?image=9'),
```

## Bônus: GIFs animados

Uma coisa útil sobre o widget `Image`: ele suporta GIFs animados.

<?code-excerpt "lib/gif.dart (Gif)" replace="/^return\ //g"?>
```dart
Image.network(
    'https://docs.flutter.dev/assets/images/dash/dash-fainting.gif');
```

## Imagem com efeito de fade-in e placeholders

O construtor padrão `Image.network` não lida com funcionalidades mais avançadas, como aplicar fade-in nas imagens após o carregamento. Para realizar essa tarefa, consulte [Efeito de fade-in em imagens com placeholder][].

* [Efeito de fade-in em imagens com placeholder][]

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de imagens de rede do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var title = 'Imagens da Web';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Image.network('https://picsum.photos/250?image=9'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/network-image.png" alt="Demonstração de imagem de rede" class="site-mobile-screenshot" />
</noscript>


[Efeito de fade-in em imagens com placeholder]: /cookbook/images/fading-in-images
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`Image.network()`]: {{site.api}}/flutter/widgets/Image/Image.network.html
