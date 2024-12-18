---
ia-translate: true
title: Animar as propriedades de um container
description: Como animar as propriedades de um container usando animações implícitas.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/animated_container/"?>

A classe [`Container`][] fornece uma maneira conveniente
de criar um widget com propriedades específicas:
largura, altura, cor de fundo, preenchimento, bordas e muito mais.

Animações simples geralmente envolvem a mudança dessas propriedades ao longo do tempo.
Por exemplo,
você pode querer animar a cor de fundo de cinza para verde para
indicar que um item foi selecionado pelo usuário.

Para animar essas propriedades,
o Flutter fornece o widget [`AnimatedContainer`][].
Como o widget `Container`, `AnimatedContainer` permite definir
a largura, altura, cores de fundo e muito mais. No entanto, quando o
`AnimatedContainer` é reconstruído com novas propriedades, ele automaticamente
anima entre os valores antigos e novos. No Flutter, esses tipos de
animações são conhecidas como "animações implícitas".

Esta receita descreve como usar um `AnimatedContainer` para animar o tamanho,
a cor de fundo e o raio da borda quando o usuário toca em um botão
usando os seguintes passos:

  1. Crie um StatefulWidget com propriedades padrão.
  2. Construa um `AnimatedContainer` usando as propriedades.
  3. Inicie a animação reconstruindo com novas propriedades.

## 1. Crie um StatefulWidget com propriedades padrão

Para começar, crie as classes [`StatefulWidget`][] e [`State`][].
Use a classe State personalizada para definir as propriedades que mudam ao longo
do tempo. Neste exemplo, isso inclui a largura, altura, cor e raio da borda.
Você também pode definir o valor padrão de cada propriedade.

Essas propriedades pertencem a uma classe `State` personalizada para que
possam ser atualizadas quando o usuário toca em um botão.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define as várias propriedades com valores padrão. Atualize essas propriedades
  // quando o usuário tocar em um FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    // Preencha isso nas próximas etapas.
  }
}
```

## 2. Construa um `AnimatedContainer` usando as propriedades

Em seguida, construa o `AnimatedContainer` usando as propriedades definidas na
etapa anterior. Além disso, forneça uma `duration` que define quanto tempo
a animação deve durar.

<?code-excerpt "lib/main.dart (AnimatedContainer)" replace="/^child: //g;/^\),$/)/g"?>
```dart
AnimatedContainer(
  // Use as propriedades armazenadas na classe State.
  width: _width,
  height: _height,
  decoration: BoxDecoration(
    color: _color,
    borderRadius: _borderRadius,
  ),
  // Defina quanto tempo a animação deve durar.
  duration: const Duration(seconds: 1),
  // Forneça uma curva opcional para tornar a animação mais suave.
  curve: Curves.fastOutSlowIn,
)
```

## 3. Inicie a animação reconstruindo com novas propriedades

Finalmente, inicie a animação reconstruindo o
`AnimatedContainer` com as novas propriedades.
Como acionar uma reconstrução?
Use o método [`setState()`][].

Adicione um botão ao aplicativo. Quando o usuário toca no botão, atualize
as propriedades com uma nova largura, altura, cor de fundo e raio da borda
dentro de uma chamada para `setState()`.

Um aplicativo real normalmente faz a transição entre valores fixos (por exemplo,
de um fundo cinza para um verde). Para este aplicativo,
gere novos valores cada vez que o usuário toca no botão.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  // Quando o usuário toca no botão
  onPressed: () {
    // Use setState para reconstruir o widget com novos valores.
    setState(() {
      // Crie um gerador de números aleatórios.
      final random = Random();

      // Gere uma largura e altura aleatórias.
      _width = random.nextInt(300).toDouble();
      _height = random.nextInt(300).toDouble();

      // Gere uma cor aleatória.
      _color = Color.fromRGBO(
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
        1,
      );

      // Gere um raio de borda aleatório.
      _borderRadius =
          BorderRadius.circular(random.nextInt(100).toDouble());
    });
  },
  child: const Icon(Icons.play_arrow),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de container animado do Flutter no DartPad" run="true"
import 'dart:math';

import 'package:flutter/material.dart';

void main() => runApp(const AnimatedContainerApp());

class AnimatedContainerApp extends StatefulWidget {
  const AnimatedContainerApp({super.key});

  @override
  State<AnimatedContainerApp> createState() => _AnimatedContainerAppState();
}

class _AnimatedContainerAppState extends State<AnimatedContainerApp> {
  // Define as várias propriedades com valores padrão. Atualize essas propriedades
  // quando o usuário toca em um FloatingActionButton.
  double _width = 50;
  double _height = 50;
  Color _color = Colors.green;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Demonstração do AnimatedContainer'),
        ),
        body: Center(
          child: AnimatedContainer(
            // Use as propriedades armazenadas na classe State.
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: _color,
              borderRadius: _borderRadius,
            ),
            // Defina quanto tempo a animação deve durar.
            duration: const Duration(seconds: 1),
            // Forneça uma curva opcional para tornar a animação mais suave.
            curve: Curves.fastOutSlowIn,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          // Quando o usuário toca no botão
          onPressed: () {
            // Use setState para reconstruir o widget com novos valores.
            setState(() {
              // Crie um gerador de números aleatórios.
              final random = Random();

              // Gere uma largura e altura aleatórias.
              _width = random.nextInt(300).toDouble();
              _height = random.nextInt(300).toDouble();

              // Gere uma cor aleatória.
              _color = Color.fromRGBO(
                random.nextInt(256),
                random.nextInt(256),
                random.nextInt(256),
                1,
              );

              // Gere um raio de borda aleatório.
              _borderRadius =
                  BorderRadius.circular(random.nextInt(100).toDouble());
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
  <img src="/assets/images/docs/cookbook/animated-container.gif" alt="Demonstração do AnimatedContainer mostrando uma caixa crescendo e diminuindo de tamanho enquanto muda a cor e o raio da borda" class="site-mobile-screenshot" />
</noscript>

[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
