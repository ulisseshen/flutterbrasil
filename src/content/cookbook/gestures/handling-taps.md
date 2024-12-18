---
ia-translate: true
title: Lidar com toques
description: Como lidar com toques e arrastes.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/gestures/handling_taps/"?>

Você não quer apenas exibir informações para os usuários, você quer que eles interajam com seu aplicativo. Use o widget [`GestureDetector`][] para responder a ações fundamentais, como tocar e arrastar.

:::note
Para saber mais, assista a este pequeno vídeo Widget of the Week sobre o widget `GestureDetector`:

{% ytEmbed 'WhVXkCFPmK4', 'GestureDetector | Flutter widget of the week' %}
:::

Esta receita mostra como criar um botão personalizado que exibe uma snackbar quando tocado com os seguintes passos:

  1. Crie o botão.
  2. Envolva-o em um `GestureDetector` com um callback `onTap()`.

<?code-excerpt "lib/main.dart (GestureDetector)" replace="/return //g;/^\);$/)/g"?>
```dart
// O GestureDetector envolve o botão.
GestureDetector(
  // Quando o filho é tocado, exibe uma snackbar.
  onTap: () {
    const snackBar = SnackBar(content: Text('Tap'));

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  },
  // O botão personalizado
  child: Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.lightBlue,
      borderRadius: BorderRadius.circular(8),
    ),
    child: const Text('Meu Botão'),
  ),
)
```

## Notas

  1. Para informações sobre como adicionar o efeito ripple do Material ao seu botão, consulte a receita [Adicionar ripples de toque do Material][].
  2. Embora este exemplo crie um botão personalizado, o Flutter inclui várias implementações de botões, como: [`ElevatedButton`][], [`TextButton`][], e [`CupertinoButton`][].

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de tratamento de toques no Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Demo de Gestos';

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
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: MyButton(),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    // O GestureDetector envolve o botão.
    return GestureDetector(
      // Quando o filho é tocado, exibe uma snackbar.
      onTap: () {
        const snackBar = SnackBar(content: Text('Tap'));

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      // O botão personalizado
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('Meu Botão'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/handling-taps.gif" alt="Demonstração de lidar com toques" class="site-mobile-screenshot" />
</noscript>

[Adicionar ripples de toque do Material]: /cookbook/gestures/ripples
[`CupertinoButton`]: {{site.api}}/flutter/cupertino/CupertinoButton-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
