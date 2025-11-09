---
ia-translate: true
title: Aplicar fade in e fade out em um widget
description: Como aplicar fade in e fade out em um widget.
---

<?code-excerpt path-base="cookbook/animation/opacity_animation/"?>

Desenvolvedores de UI frequentemente precisam mostrar e ocultar elementos na tela.
No entanto, fazer elementos aparecerem e desaparecerem rapidamente na tela pode
parecer abrupto para os usuários finais. Em vez disso,
aplique fade in e fade out em elementos com uma animação de opacidade para criar
uma experiência suave.

O widget [`AnimatedOpacity`][] torna fácil realizar animações de
opacidade. Esta receita usa os seguintes passos:

  1. Criar uma caixa para aplicar fade in e fade out.
  2. Definir um `StatefulWidget`.
  3. Exibir um botão que alterna a visibilidade.
  4. Aplicar fade in e fade out na caixa.

## 1. Criar uma caixa para aplicar fade in e fade out

Primeiro, crie algo para aplicar fade in e fade out. Para este exemplo,
desenhe uma caixa verde na tela.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g;/\),$/)/g"?>
```dart
Container(width: 200, height: 200, color: Colors.green)
```

## 2. Definir um `StatefulWidget`

Agora que você tem uma caixa verde para animar,
você precisa de uma maneira de saber se a caixa deve estar visível.
Para realizar isso, use um [`StatefulWidget`][].

Um `StatefulWidget` é uma classe que cria um objeto `State`.
O objeto `State` contém alguns dados sobre o app e fornece uma maneira de
atualizar esses dados. Ao atualizar os dados,
você também pode pedir ao Flutter para reconstruir a UI com essas mudanças.

Neste caso, você tem uma informação:
um booleano representando se o botão está visível.

Para construir um `StatefulWidget`, crie duas classes: Um
`StatefulWidget` e uma classe `State` correspondente.
Dica profissional: Os plugins do Flutter para Android Studio e VSCode incluem
o snippet `stful` para gerar rapidamente este código.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// The StatefulWidget's job is to take data and create a State class.
// In this case, the widget takes a title, and creates a _MyHomePageState.
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The State class is responsible for two things: holding some data you can
// update and building the UI using that data.
class _MyHomePageState extends State<MyHomePage> {
  // Whether the green box should be visible.
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    // The green box goes here with some other Widgets.
  }
}
```

## 3. Exibir um botão que alterna a visibilidade

Agora que você tem alguns dados para determinar se a caixa verde
deve estar visível, você precisa de uma maneira de atualizar esses dados.
Neste exemplo, se a caixa estiver visível, oculte-a.
Se a caixa estiver oculta, mostre-a.

Para lidar com isso, exiba um botão. Quando um usuário pressiona o botão,
inverta o booleano de true para false, ou false para true.
Faça essa mudança usando [`setState()`][],
que é um método na classe `State`.
Isso diz ao Flutter para reconstruir o widget.

Para mais informações sobre trabalhar com entrada do usuário,
veja a seção [Gestures][] do cookbook.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  onPressed: () {
    // Call setState. This tells Flutter to rebuild the
    // UI with the changes.
    setState(() {
      _visible = !_visible;
    });
  },
  tooltip: 'Toggle Opacity',
  child: const Icon(Icons.flip),
)
```

## 4. Aplicar fade in e fade out na caixa

Você tem uma caixa verde na tela e um botão para alternar a visibilidade
para `true` ou `false`. Como aplicar fade in e fade out na caixa? Com um
widget [`AnimatedOpacity`][].

O widget `AnimatedOpacity` requer três argumentos:

* `opacity`: Um valor de 0.0 (invisível) a 1.0 (totalmente visível).
* `duration`: Quanto tempo a animação deve levar para completar.
* `child`: O widget a ser animado. Neste caso, a caixa verde.

<?code-excerpt "lib/main.dart (AnimatedOpacity)" replace="/^child: //g;/^\),$/)/g"?>
```dart
AnimatedOpacity(
  // If the widget is visible, animate to 0.0 (invisible).
  // If the widget is hidden, animate to 1.0 (fully visible).
  opacity: _visible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  // The green box must be a child of the AnimatedOpacity widget.
  child: Container(width: 200, height: 200, color: Colors.green),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de animação de opacidade implícita no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Opacity Demo';
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

// The StatefulWidget's job is to take data and create a State class.
// In this case, the widget takes a title, and creates a _MyHomePageState.
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// The State class is responsible for two things: holding some data you can
// update and building the UI using that data.
class _MyHomePageState extends State<MyHomePage> {
  // Whether the green box should be visible
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          // The green box must be a child of the AnimatedOpacity widget.
          child: Container(width: 200, height: 200, color: Colors.green),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call setState. This tells Flutter to rebuild the
          // UI with the changes.
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: const Icon(Icons.flip),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/fade-in-out.webp" alt="Fade In and Out Demo" class="site-mobile-screenshot" />
</noscript>

[`AnimatedOpacity`]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[Gestures]: /cookbook/gestures
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
