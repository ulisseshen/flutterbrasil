---
ia-translate: true
title: Adicionar ondulações de toque Material
description: Como implementar animações de ondulação.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/gestures/ripples/"?>

Widgets que seguem as diretrizes do Material Design exibem
uma animação de ondulação quando tocados.

O Flutter fornece o widget [`InkWell`][]
para executar esse efeito.
Crie um efeito de ondulação usando os seguintes passos:

  1. Crie um widget que suporte toque.
  2. Envolva-o em um widget `InkWell` para gerenciar os callbacks de toque e
     as animações de ondulação.

<?code-excerpt "lib/main.dart (InkWell)" replace="/return //g;/^\);$/)/g"?>
```dart
// O InkWell envolve o widget de botão plano customizado.
InkWell(
  // Quando o usuário tocar no botão, exibe um snackbar.
  onTap: () {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Tap'),
    ));
  },
  child: const Padding(
    padding: EdgeInsets.all(12),
    child: Text('Flat Button'),
  ),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de ondulações Material do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Demonstração do InkWell';

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
    // O InkWell envolve o widget de botão plano customizado.
    return InkWell(
      // Quando o usuário tocar no botão, exibe um snackbar.
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Tap'),
        ));
      },
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('Flat Button'),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/ripples.gif" alt="Demonstração de Ondulações" class="site-mobile-screenshot" />
</noscript>


[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
