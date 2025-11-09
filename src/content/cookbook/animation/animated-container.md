---
ia-translate: true
title: Animar as propriedades de um container
description: Como animar propriedades de um container usando animações implícitas.
---

<?code-excerpt path-base="cookbook/animation/animated_container/"?>

A classe [`Container`][] fornece uma maneira conveniente
de criar um widget com propriedades específicas:
largura, altura, cor de fundo, padding, bordas, e mais.

Animações simples frequentemente envolvem mudar essas propriedades ao longo do tempo.
Por exemplo,
você pode querer animar a cor de fundo de cinza para verde para
indicar que um item foi selecionado pelo usuário.

Para animar essas propriedades,
Flutter fornece o widget [`AnimatedContainer`][].
Como o widget `Container`, `AnimatedContainer` permite que você defina
a largura, altura, cores de fundo, e mais. No entanto, quando o
`AnimatedContainer` é reconstruído com novas propriedades, ele automaticamente
anima entre os valores antigos e novos. No Flutter, esses tipos de
animações são conhecidos como "animações implícitas".

Esta receita descreve como usar um `AnimatedContainer` para animar o tamanho,
cor de fundo, e raio da borda quando o usuário toca em um botão
usando os seguintes passos:

  1. Criar um StatefulWidget com propriedades padrão.
  2. Construir um `AnimatedContainer` usando as propriedades.
  3. Iniciar a animação reconstruindo com novas propriedades.

## 1. Criar um StatefulWidget com propriedades padrão

Para começar, crie classes [`StatefulWidget`][] e [`State`][].
Use a classe State customizada para definir as propriedades que mudam ao
longo do tempo. Neste exemplo, isso inclui a largura, altura, cor, e raio
da borda. Você também pode definir o valor padrão de cada propriedade.

Essas propriedades pertencem a uma classe `State` customizada para que
possam ser atualizadas quando o usuário toca em um botão.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
  }
}
```

## 2. Construir um `AnimatedContainer` usando as propriedades

Em seguida, construa o `AnimatedContainer` usando as propriedades definidas no
passo anterior. Além disso, forneça uma `duration` que define quanto tempo
a animação deve executar.

<?code-excerpt "lib/main.dart (AnimatedContainer)" replace="/^child: //g;/^\),$/)/g"?>
```dart
AnimatedContainer(
  // Use the properties stored in the State class.
  width: _width,
  height: _height,
  decoration: BoxDecoration(
    color: _color,
    borderRadius: _borderRadius,
  ),
  // Define how long the animation should take.
  duration: const Duration(seconds: 1),
  // Provide an optional curve to make the animation feel smoother.
  curve: Curves.fastOutSlowIn,
)
```

## 3. Iniciar a animação reconstruindo com novas propriedades

Finalmente, inicie a animação reconstruindo o
`AnimatedContainer` com as novas propriedades.
Como acionar uma reconstrução?
Use o método [`setState()`][].

Adicione um botão ao app. Quando o usuário toca no botão, atualize
as propriedades com uma nova largura, altura, cor de fundo e raio da borda
dentro de uma chamada para `setState()`.

Um app real normalmente transiciona entre valores fixos (por exemplo,
de um fundo cinza para um verde). Para este app,
gere novos valores cada vez que o usuário toca no botão.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  // When the user taps the button
  onPressed: () {
    // Use setState to rebuild the widget with new values.
    setState(() {
      // Create a random number generator.
      final random = Random();

      // Generate a random width and height.
      _width = random.nextInt(300).toDouble();
      _height = random.nextInt(300).toDouble();

      // Generate a random color.
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      // Generate a random border radius.
      _borderRadius = BorderRadius.circular(
        random.nextInt(100).toDouble(),
      );
    });
  },
  child: const Icon(Icons.play_arrow),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de animated container Flutter no DartPad" run="true"
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const AnimatedContainerApp());

class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define the various properties with default values. Update these properties
  // when the user taps a FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('AnimatedContainer Demo')),
        body: Center(
          child: AnimatedContainer(
            // Use the properties stored in the State class.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // Define how long the animation should take.
            duration: const Duration(seconds: 1),
            // Provide an optional curve to make the animation feel smoother.
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // When the user taps the button
          onPressed: () {
            // Use setState to rebuild the widget with new values.
            setState(() {
              // Create a random number generator.
              final random = Random();

              // Generate a random width and height.
              _width = random.nextInt(300).toDouble();
              _height = random.nextInt(300).toDouble();

              // Generate a random color.
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );

              // Generate a random border radius.
              _borderRadius = BorderRadius.circular(
                random.nextInt(100).toDouble(),
              );
            });
          },
          child: const Icon(Icons.play_arrow),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/animated-container.webp" alt="AnimatedContainer demo showing a box growing and shrinking in size while changing color and border radius" class="site-mobile-screenshot" />
</noscript>


[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
