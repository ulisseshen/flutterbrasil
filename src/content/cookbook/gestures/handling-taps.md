---
ia-translate: true
title: Lidar com toques
description: Como lidar com toques e arrastar.
---

<?code-excerpt path-base="cookbook/gestures/handling_taps/"?>

Você não quer apenas exibir informações aos usuários,
você quer que os usuários interajam com seu app.
Use o widget [`GestureDetector`][`GestureDetector`] para responder
a ações fundamentais, como tocar e arrastar.

:::note
Para saber mais, assista este vídeo curto Widget of the Week sobre
o widget `GestureDetector`:

<YouTubeEmbed id="WhVXkCFPmK4" title="GestureDetector | Flutter widget of the week"></YouTubeEmbed>
:::

Esta receita mostra como criar um botão customizado que mostra
uma snackbar quando tocado com os seguintes passos:

  1. Crie o botão.
  2. Envolva-o em um `GestureDetector` e forneça um callback `onTap()`.

<?code-excerpt "lib/main.dart (GestureDetector)" replace="/return //g;/^\);$/)/g"?>
```dart
// The GestureDetector wraps the button.
GestureDetector(
  // When the child is tapped, show a snackbar.
  onTap: () {
    const snackBar = SnackBar(content: Text('Tap'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  },
  // The custom button
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text('My Button'),
  ),
)
```

## Notas

  1. Para informações sobre como adicionar o efeito ripple Material ao seu
     botão, veja a receita [Add Material touch ripples][Add Material touch ripples].
  2. Embora este exemplo crie um botão customizado,
     Flutter inclui um punhado de implementações de botões, como:
     [`ElevatedButton`][`ElevatedButton`], [`TextButton`][`TextButton`], e
     [`CupertinoButton`][`CupertinoButton`].

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter tap handling hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Gesture Demo';

    return const MaterialApp(
      title: title,
      home: MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: MyButton()),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    // The GestureDetector wraps the button.
    return GestureDetector(
      // When the child is tapped, show a snackbar.
      onTap: () {
        const snackBar = SnackBar(content: Text('Tap'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      // The custom button
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('My Button'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/handling-taps.webp" alt="Handle taps demo" class="site-mobile-screenshot" />
</noscript>

[Add Material touch ripples]: /cookbook/gestures/ripples
[`CupertinoButton`]: {{site.api}}/flutter/cupertino/CupertinoButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
