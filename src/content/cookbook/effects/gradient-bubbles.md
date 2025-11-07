---
title: Criar balões de chat com gradiente
description: Como implementar balões de chat com gradiente.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/effects/gradient_bubbles"?>

{% include docs/deprecated.md %}

Apps de chat tradicionais exibem mensagens em balões de chat
com cores de fundo sólidas. Apps de chat modernos exibem
balões de chat com gradientes que são baseados
na posição dos balões na tela.
Nesta receita, você modernizará a UI de chat implementando
fundos com gradiente para os balões de chat.

A animação a seguir mostra o comportamento do app:

![Rolando os balões de chat com gradiente](/assets/images/docs/cookbook/effects/GradientBubbles.gif){:.site-mobile-screenshot}

## Entender o desafio

A solução tradicional de balão de chat provavelmente usa um
`DecoratedBox` ou um widget similar para pintar um retângulo
arredondado atrás de cada mensagem de chat. Essa abordagem é
ótima para uma cor sólida ou até para um gradiente que
se repete em cada balão de chat. No entanto, fundos de balão
modernos com gradiente de tela cheia requerem
uma abordagem diferente. O gradiente de tela cheia,
combinado com balões rolando para cima e para baixo na tela,
requer uma abordagem que permita tomar decisões de pintura
com base em informações de layout.

O gradiente de cada balão requer conhecimento da
localização do balão na tela. Isso significa que
o comportamento de pintura requer acesso às informações de layout.
Tal comportamento de pintura não é possível com widgets típicos
porque widgets como `Container` e `DecoratedBox`
tomam decisões sobre cores de fundo antes do layout ocorrer,
não depois. Neste caso, como você requer comportamento de pintura
personalizado, mas não requer comportamento de layout personalizado
ou comportamento de teste de toque personalizado, um [`CustomPainter`][]
é uma ótima escolha para realizar o trabalho.

:::note
Em casos onde você precisa de controle sobre o layout dos filhos,
mas não precisa de controle sobre a pintura ou teste de toque,
considere usar um widget [`Flow`][].

Em casos onde você precisa de controle sobre o layout,
pintura _e_ teste de toque,
considere definir um [`RenderBox`][] personalizado.
:::

## Substituir o widget de fundo original

Substitua o widget responsável por desenhar o
fundo por um novo widget stateless chamado
`BubbleBackground`. Inclua uma propriedade `colors` para
representar o gradiente de tela cheia que deve ser
aplicado ao balão.

<?code-excerpt "lib/bubble_background.dart (BubbleBackground)" replace="/return //g"?>
```dart
BubbleBackground(
  // The colors of the gradient, which are different
  // depending on which user sent this message.
  colors: message.isMine
      ? const [Color(0xFF6C7689), Color(0xFF3A364B)]
      : const [Color(0xFF19B7FF), Color(0xFF491CCB)],
  // The content within the bubble.
  child: DefaultTextStyle.merge(
    style: const TextStyle(
      fontSize: 18.0,
      color: Colors.white,
    ),
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Text(message.text),
    ),
  ),
);
```

## Criar um custom painter

Em seguida, introduza uma implementação para `BubbleBackground`
como um widget stateless. Por enquanto, defina o método `build()`
para retornar um `CustomPaint` com um `CustomPainter`
chamado `BubblePainter`. `BubblePainter` é usado para pintar
os gradientes dos balões.

<?code-excerpt "lib/bubble_painter_empty.dart (BubblePainterEmpty)"?>
```dart
@immutable
class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    super.key,
    required this.colors,
    this.child,
  });

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        colors: colors,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required List<Color> colors,
  }) : _colors = colors;

  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO:
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    // TODO:
    return false;
  }
}
```

## Fornecer acesso às informações de rolagem

O `CustomPainter` requer as informações necessárias
para determinar onde seu balão está dentro dos limites do `ListView`,
também conhecido como `Viewport`. Determinar a localização requer
uma referência ao `ScrollableState` ancestral
e uma referência ao `BuildContext` do `BubbleBackground`.
Forneça cada um deles ao `CustomPainter`.

<?code-excerpt "lib/bubble_painter.dart (ScrollableContext)" replace="/painter: //g"?>
```dart
BubblePainter(
  colors: colors,
  bubbleContext: context,
  scrollable: ScrollableState(),
),
```

<?code-excerpt "lib/bubble_painter.dart (bp-without-paint)" plaster="none"?>
```dart
class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors;

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}
```

## Pintar um gradiente de balão de tela cheia

O `CustomPainter` agora tem as cores de gradiente desejadas,
uma referência ao `ScrollableState` contido,
e uma referência ao `BuildContext` deste balão.
Esta é toda a informação que o `CustomPainter` precisa para
pintar os gradientes de balão de tela cheia.
Implemente o método `paint()` para calcular a posição
do balão, configurar um shader com as cores fornecidas,
e então usar uma transformação de matriz para deslocar o shader
com base na posição do balão dentro do `Scrollable`.

<?code-excerpt "lib/bubble_background.dart (BubblePainter)"?>
```dart
class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors;

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }
}
```

Parabéns! Agora você tem uma UI de balão de chat moderna.

:::note
O gradiente de cada balão muda conforme o usuário
rola porque o widget `BubbleBackground`
invoca `Scrollable.of(context)`. Este método
estabelece uma dependência implícita no `ScrollableState`
ancestral, o que faz com que o widget `BubbleBackground`
seja reconstruído toda vez que o usuário rola
para cima ou para baixo. Veja a documentação do [`InheritedWidget`][]
para mais informações sobre esses tipos de dependências.
:::

## Exemplo interativo

Execute o app:

* Role para cima e para baixo para observar o efeito de gradiente.
* Balões de chat localizados na parte inferior da tela
  têm uma cor de gradiente mais escura do que os que estão no topo.

<!-- start dartpad -->
<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter graident bubbles hands-on example in DartPad" run="true"
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(const App(home: ExampleGradientBubbles()));
}

@immutable
class App extends StatelessWidget {
  const App({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Chat',
      theme: ThemeData.dark(useMaterial3: true),
      home: home,
    );
  }
}

@immutable
class ExampleGradientBubbles extends StatefulWidget {
  const ExampleGradientBubbles({super.key});

  @override
  State<ExampleGradientBubbles> createState() => _ExampleGradientBubblesState();
}

class _ExampleGradientBubblesState extends State<ExampleGradientBubbles> {
  late final List<Message> data;

  @override
  void initState() {
    super.initState();
    data = MessageGenerator.generate(60, 1337);
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF4F4F4F),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Chat'),
        ),
        body: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          reverse: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            final message = data[index];
            return MessageBubble(
              message: message,
              child: Text(message.text),
            );
          },
        ),
      ),
    );
  }
}

@immutable
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.child,
  });

  final Message message;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final messageAlignment =
        message.isMine ? Alignment.topLeft : Alignment.topRight;

    return FractionallySizedBox(
      alignment: messageAlignment,
      widthFactor: 0.8,
      child: Align(
        alignment: messageAlignment,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 20.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: BubbleBackground(
              colors: [
                if (message.isMine) ...const [
                  Color(0xFF6C7689),
                  Color(0xFF3A364B),
                ] else ...const [
                  Color(0xFF19B7FF),
                  Color(0xFF491CCB),
                ],
              ],
              child: DefaultTextStyle.merge(
                style: const TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class BubbleBackground extends StatelessWidget {
  const BubbleBackground({
    super.key,
    required this.colors,
    this.child,
  });

  final List<Color> colors;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: BubblePainter(
        scrollable: Scrollable.of(context),
        bubbleContext: context,
        colors: colors,
      ),
      child: child,
    );
  }
}

class BubblePainter extends CustomPainter {
  BubblePainter({
    required ScrollableState scrollable,
    required BuildContext bubbleContext,
    required List<Color> colors,
  })  : _scrollable = scrollable,
        _bubbleContext = bubbleContext,
        _colors = colors,
        super(repaint: scrollable.position);

  final ScrollableState _scrollable;
  final BuildContext _bubbleContext;
  final List<Color> _colors;

  @override
  void paint(Canvas canvas, Size size) {
    final scrollableBox = _scrollable.context.findRenderObject() as RenderBox;
    final scrollableRect = Offset.zero & scrollableBox.size;
    final bubbleBox = _bubbleContext.findRenderObject() as RenderBox;

    final origin =
        bubbleBox.localToGlobal(Offset.zero, ancestor: scrollableBox);
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        scrollableRect.topCenter,
        scrollableRect.bottomCenter,
        _colors,
        [0.0, 1.0],
        TileMode.clamp,
        Matrix4.translationValues(-origin.dx, -origin.dy, 0.0).storage,
      );
    canvas.drawRect(Offset.zero & size, paint);
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) {
    return oldDelegate._scrollable != _scrollable ||
        oldDelegate._bubbleContext != _bubbleContext ||
        oldDelegate._colors != _colors;
  }
}

enum MessageOwner { myself, other }

@immutable
class Message {
  const Message({
    required this.owner,
    required this.text,
  });

  final MessageOwner owner;
  final String text;

  bool get isMine => owner == MessageOwner.myself;
}

class MessageGenerator {
  static List<Message> generate(int count, [int? seed]) {
    final random = Random(seed);
    return List.unmodifiable(List<Message>.generate(count, (index) {
      return Message(
        owner: random.nextBool() ? MessageOwner.myself : MessageOwner.other,
        text: _exampleData[random.nextInt(_exampleData.length)],
      );
    }));
  }

  static final _exampleData = [
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
    'In tempus mauris at velit egestas, sed blandit felis ultrices.',
    'Ut molestie mauris et ligula finibus iaculis.',
    'Sed a tempor ligula.',
    'Test',
    'Phasellus ullamcorper, mi ut imperdiet consequat, nibh augue condimentum nunc, vitae molestie massa augue nec erat.',
    'Donec scelerisque, erat vel placerat facilisis, eros turpis egestas nulla, a sodales elit nibh et enim.',
    'Mauris quis dignissim neque. In a odio leo. Aliquam egestas egestas tempor. Etiam at tortor metus.',
    'Quisque lacinia imperdiet faucibus.',
    'Proin egestas arcu non nisl laoreet, vitae iaculis enim volutpat. In vehicula convallis magna.',
    'Phasellus at diam a sapien laoreet gravida.',
    'Fusce maximus fermentum sem a scelerisque.',
    'Nam convallis sapien augue, malesuada aliquam dui bibendum nec.',
    'Quisque dictum tincidunt ex non lobortis.',
    'In hac habitasse platea dictumst.',
    'Ut pharetra ligula libero, sit amet imperdiet lorem luctus sit amet.',
    'Sed ex lorem, lacinia et varius vitae, sagittis eget libero.',
    'Vestibulum scelerisque velit sed augue ultricies, ut vestibulum lorem luctus.',
    'Pellentesque et risus pretium, egestas ipsum at, facilisis lectus.',
    'Praesent id eleifend lacus.',
    'Fusce convallis eu tortor sit amet mattis.',
    'Vivamus lacinia magna ut urna feugiat tincidunt.',
    'Sed in diam ut dolor imperdiet vehicula non ac turpis.',
    'Praesent at est hendrerit, laoreet tortor sed, varius mi.',
    'Nunc in odio leo.',
    'Praesent placerat semper libero, ut aliquet dolor.',
    'Vestibulum elementum leo metus, vitae auctor lorem tincidunt ut.',
  ];
}
```

## Recapitulação

O desafio fundamental ao pintar com base na
posição de rolagem, ou na posição da tela em geral,
é que o comportamento de pintura deve ocorrer após a
fase de layout estar completa. `CustomPaint` é um
widget único que permite executar comportamentos de pintura
personalizados após a fase de layout estar completa.
Se você executar os comportamentos de pintura após a fase de layout,
então pode basear suas decisões de pintura nas informações
de layout, como a posição do widget `CustomPaint`
dentro de um `Scrollable` ou dentro da tela.

[cloning the example code]: {{site.github}}/flutter/codelabs
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[`Flow`]: {{site.api}}/flutter/widgets/Flow-class.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Issue 44152]: {{site.repo.flutter}}/issues/44152
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
