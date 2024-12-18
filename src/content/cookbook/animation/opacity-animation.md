---
ia-translate: true
title: Fazer um widget aparecer e desaparecer gradualmente
description: Como fazer um widget aparecer e desaparecer gradualmente.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/opacity_animation/"?>

Desenvolvedores de UI frequentemente precisam mostrar e esconder elementos na tela. No entanto, fazer elementos aparecerem e desaparecerem rapidamente da tela pode parecer abrupto para os usuários finais. Em vez disso, faça os elementos aparecerem e desaparecerem gradualmente com uma animação de opacidade para criar uma experiência suave.

O widget [`AnimatedOpacity`][] facilita a realização de animações de opacidade. Esta receita usa os seguintes passos:

  1. Crie uma caixa para aparecer e desaparecer gradualmente.
  2. Defina um `StatefulWidget`.
  3. Exiba um botão que alterna a visibilidade.
  4. Faça a caixa aparecer e desaparecer gradualmente.

## 1. Crie uma caixa para aparecer e desaparecer gradualmente

Primeiro, crie algo para aparecer e desaparecer gradualmente. Para este exemplo, desenhe uma caixa verde na tela.

<?code-excerpt "lib/main.dart (Container)" replace="/^child: //g;/\),$/)/g"?>
```dart
Container(
  width: 200,
  height: 200,
  color: Colors.green,
)
```

## 2. Defina um `StatefulWidget`

Agora que você tem uma caixa verde para animar, você precisa de uma maneira de saber se a caixa deve estar visível. Para fazer isso, use um [`StatefulWidget`][].

Um `StatefulWidget` é uma classe que cria um objeto `State`. O objeto `State` contém alguns dados sobre o aplicativo e fornece uma maneira de atualizar esses dados. Ao atualizar os dados, você também pode pedir ao Flutter para reconstruir a UI com essas alterações.

Neste caso, você tem um dado: um booleano representando se o botão está visível.

Para construir um `StatefulWidget`, crie duas classes: um `StatefulWidget` e uma classe `State` correspondente. Dica: Os plugins do Flutter para Android Studio e VSCode incluem o snippet `stful` para gerar este código rapidamente.

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// O trabalho do StatefulWidget é pegar dados e criar uma classe State.
// Neste caso, o widget recebe um título e cria um _MyHomePageState.
class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// A classe State é responsável por duas coisas: manter alguns dados que você pode
// atualizar e construir a UI usando esses dados.
class _MyHomePageState extends State<MyHomePage> {
  // Se a caixa verde deve estar visível.
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    // A caixa verde vai aqui com alguns outros Widgets.
  }
}
```

## 3. Exiba um botão que alterna a visibilidade

Agora que você tem alguns dados para determinar se a caixa verde deve estar visível, você precisa de uma maneira de atualizar esses dados. Neste exemplo, se a caixa estiver visível, esconda-a. Se a caixa estiver escondida, mostre-a.

Para lidar com isso, exiba um botão. Quando um usuário pressionar o botão, inverta o booleano de verdadeiro para falso ou de falso para verdadeiro. Faça essa alteração usando [`setState()`][], que é um método na classe `State`. Isso diz ao Flutter para reconstruir o widget.

Para mais informações sobre como trabalhar com entrada do usuário, consulte a seção [Gestos][] do cookbook.

<?code-excerpt "lib/main.dart (FAB)" replace="/^floatingActionButton: //g;/^\),$/)/g"?>
```dart
FloatingActionButton(
  onPressed: () {
    // Chame setState. Isso diz ao Flutter para reconstruir a
    // UI com as alterações.
    setState(() {
      _visible = !_visible;
    });
  },
  tooltip: 'Alternar Opacidade',
  child: const Icon(Icons.flip),
)
```

## 4. Faça a caixa aparecer e desaparecer gradualmente

Você tem uma caixa verde na tela e um botão para alternar a visibilidade para `true` ou `false`. Como fazer a caixa aparecer e desaparecer gradualmente? Com um widget [`AnimatedOpacity`][].

O widget `AnimatedOpacity` requer três argumentos:

* `opacity`: Um valor de 0.0 (invisível) a 1.0 (totalmente visível).
* `duration`: Quanto tempo a animação deve levar para ser concluída.
* `child`: O widget para animar. Neste caso, a caixa verde.

<?code-excerpt "lib/main.dart (AnimatedOpacity)" replace="/^child: //g;/^\),$/)/g"?>
```dart
AnimatedOpacity(
  // Se o widget estiver visível, anime para 0.0 (invisível).
  // Se o widget estiver escondido, anime para 1.0 (totalmente visível).
  opacity: _visible ? 1.0 : 0.0,
  duration: const Duration(milliseconds: 500),
  // A caixa verde deve ser um filho do widget AnimatedOpacity.
  child: Container(
    width: 200,
    height: 200,
    color: Colors.green,
  ),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de Opacidade com Animação Implícita no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demonstração de Opacidade';
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

// O trabalho do StatefulWidget é pegar dados e criar uma classe State.
// Neste caso, o widget recebe um título e cria um _MyHomePageState.
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// A classe State é responsável por duas coisas: manter alguns dados que você pode
// atualizar e construir a UI usando esses dados.
class _MyHomePageState extends State<MyHomePage> {
  // Se a caixa verde deve estar visível
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: AnimatedOpacity(
          // Se o widget estiver visível, anime para 0.0 (invisível).
          // Se o widget estiver escondido, anime para 1.0 (totalmente visível).
          opacity: _visible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          // A caixa verde deve ser um filho do widget AnimatedOpacity.
          child: Container(
            width: 200,
            height: 200,
            color: Colors.green,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Chame setState. Isso diz ao Flutter para reconstruir a
          // UI com as alterações.
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Alternar Opacidade',
        child: const Icon(Icons.flip),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/fade-in-out.gif" alt="Demonstração de Aparecer e Desaparecer Gradualmente" class="site-mobile-screenshot" />
</noscript>

[`AnimatedOpacity`]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[Gestures]: /cookbook#gestures
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
