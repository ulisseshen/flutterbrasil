---
ia-translate: true
title: Animar um widget usando uma simulação de física
description: Como implementar uma animação de física.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/animation/physics_simulation/"?>

Simulações de física podem tornar as interações do aplicativo mais realistas e interativas.
Por exemplo, você pode querer animar um widget para agir como se estivesse ligado a
uma mola ou caindo com a gravidade.

Esta receita demonstra como mover um widget de um ponto arrastado de volta para o
centro usando uma simulação de mola.

Esta receita usa estas etapas:

1. Configurar um controlador de animação
2. Mover o widget usando gestos
3. Animar o widget
4. Calcular a velocidade para simular um movimento de mola


## Etapa 1: Configurar um controlador de animação

Comece com um widget stateful chamado `DraggableCard`:

<?code-excerpt "lib/starter.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: PhysicsCardDragDemo()));
}

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Card(
        child: widget.child,
      ),
    );
  }
}
```

Faça a classe `_DraggableCardState` herdar de
[SingleTickerProviderStateMixin][].
Em seguida, construa um [AnimationController][] em
`initState` e defina `vsync` para `this`.

:::note
Herda `SingleTickerProviderStateMixin` permite que o objeto de estado seja um
`TickerProvider` para o `AnimationController`. Para obter mais informações, consulte a
documentação para [TickerProvider][].
:::

```dart diff
- class _DraggableCardState extends State<DraggableCard> {
+ class _DraggableCardState extends State<DraggableCard>
+     with SingleTickerProviderStateMixin {
+   late AnimationController _controller;
+
    @override
    void initState() {
      super.initState();
+     _controller =
+         AnimationController(vsync: this, duration: const Duration(seconds: 1));
    }

    @override
    void dispose() {
+     _controller.dispose();
      super.dispose();
    }
```

## Etapa 2: Mover o widget usando gestos

Faça o widget se mover quando for arrastado e adicione um campo [Alignment][] à
classe `_DraggableCardState`:

```dart diff
  class _DraggableCardState extends State<DraggableCard>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
+   Alignment _dragAlignment = Alignment.center;
```

Adicione um [GestureDetector][] que manipula os callbacks `onPanDown`, `onPanUpdate` e
`onPanEnd`. Para ajustar o alinhamento, use um [MediaQuery][] para obter o
tamanho do widget e divida por 2. (Isso converte unidades de "pixels arrastados" para
coordenadas que [Align][] usa.) Em seguida, defina o `alignment` do widget `Align` para
`_dragAlignment`:

```dart diff
  @override
  Widget build(BuildContext context) {
-   return Align(
-     child: Card(
-       child: widget.child,
+   var size = MediaQuery.of(context).size;
+   return GestureDetector(
+     onPanDown: (details) {},
+     onPanUpdate: (details) {
+       setState(() {
+         _dragAlignment += Alignment(
+           details.delta.dx / (size.width / 2),
+           details.delta.dy / (size.height / 2),
+         );
+       });
+     },
+     onPanEnd: (details) {},
+     child: Align(
+       alignment: _dragAlignment,
+       child: Card(
+         child: widget.child,
+       ),
      ),
    );
  }
```

## Etapa 3: Animar o widget

Quando o widget for liberado, ele deve voltar ao centro com um efeito de mola.

Adicione um campo `Animation<Alignment>` e um método `_runAnimation`. Este
método define um `Tween` que interpola entre o ponto para o qual o widget foi
arrastado e o ponto no centro.

```dart diff
  class _DraggableCardState extends State<DraggableCard>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
+   late Animation<Alignment> _animation;
    Alignment _dragAlignment = Alignment.center;
```

<?code-excerpt "lib/step3.dart (runAnimation)"?>
```dart
void _runAnimation() {
  _animation = _controller.drive(
    AlignmentTween(
      begin: _dragAlignment,
      end: Alignment.center,
    ),
  );
  _controller.reset();
  _controller.forward();
}
```

Em seguida, atualize `_dragAlignment` quando o `AnimationController` produzir um
valor:

```dart diff
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
+   _controller.addListener(() {
+     setState(() {
+       _dragAlignment = _animation.value;
+     });
+   });
  }
```

Em seguida, faça o widget `Align` usar o campo `_dragAlignment`:

<?code-excerpt "lib/step3.dart (align)"?>
```dart
child: Align(
  alignment: _dragAlignment,
  child: Card(
    child: widget.child,
  ),
),
```

Finalmente, atualize o `GestureDetector` para gerenciar o controlador de animação:

```dart diff
  return GestureDetector(
-   onPanDown: (details) {},
+   onPanDown: (details) {
+     _controller.stop();
+   },
    onPanUpdate: (details) {
      // ...
    },
-   onPanEnd: (details) {},
+   onPanEnd: (details) {
+     _runAnimation();
+   },
    child: Align(
```

## Etapa 4: Calcular a velocidade para simular um movimento de mola

A última etapa é fazer um pouco de matemática, para calcular a velocidade do widget
depois que ele terminar de ser arrastado. Isso é para que o widget, realisticamente,
continue nessa velocidade antes de ser encaixado de volta. (O método `_runAnimation`
já define a direção definindo o alinhamento inicial e final da animação.)

Primeiro, importe o pacote `physics`:

<?code-excerpt "lib/main.dart (import)"?>
```dart
import 'package:flutter/physics.dart';
```

O callback `onPanEnd` fornece um objeto [DragEndDetails][]. Este objeto
fornece a velocidade do ponteiro quando ele parou de entrar em contato com a tela. A
velocidade está em pixels por segundo, mas o widget `Align` não usa pixels. Ele
usa valores de coordenadas entre [-1.0, -1.0] e [1.0, 1.0], onde [0.0, 0.0]
representa o centro. O `size` calculado na etapa 2 é usado para converter pixels
em valores de coordenadas neste intervalo.

Finalmente, `AnimationController` tem um método `animateWith()` que pode receber um
[SpringSimulation][]:

<?code-excerpt "lib/main.dart (runAnimation)"?>
```dart
/// Calculates and runs a [SpringSimulation].
void _runAnimation(Offset pixelsPerSecond, Size size) {
  _animation = _controller.drive(
    AlignmentTween(
      begin: _dragAlignment,
      end: Alignment.center,
    ),
  );
  // Calculate the velocity relative to the unit interval, [0,1],
  // used by the animation controller.
  final unitsPerSecondX = pixelsPerSecond.dx / size.width;
  final unitsPerSecondY = pixelsPerSecond.dy / size.height;
  final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
  final unitVelocity = unitsPerSecond.distance;

  const spring = SpringDescription(
    mass: 30,
    stiffness: 1,
    damping: 1,
  );

  final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

  _controller.animateWith(simulation);
}
```

Não se esqueça de chamar `_runAnimation()` com a velocidade e o tamanho:

<?code-excerpt "lib/main.dart (onPanEnd)"?>
```dart
onPanEnd: (details) {
  _runAnimation(details.velocity.pixelsPerSecond, size);
},
```

:::note
Agora que o controlador de animação usa uma simulação, seu argumento `duration`
não é mais necessário.
:::

## Exemplo Interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de simulação física do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

void main() {
  runApp(const MaterialApp(home: PhysicsCardDragDemo()));
}

class PhysicsCardDragDemo extends StatelessWidget {
  const PhysicsCardDragDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const DraggableCard(
        child: FlutterLogo(
          size: 128,
        ),
      ),
    );
  }
}

/// Um card arrastável que volta para [Alignment.center] quando é
/// liberado.
class DraggableCard extends StatefulWidget {
  const DraggableCard({required this.child, super.key});

  final Widget child;

  @override
  State<DraggableCard> createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  /// O alinhamento do card enquanto ele está sendo arrastado ou animado.
  ///
  /// Enquanto o card está sendo arrastado, esse valor é definido para os valores calculados
  /// no callback GestureDetector onPanUpdate. Se a animação estiver sendo executada,
  /// esse valor é definido como o valor de [_animation].
  Alignment _dragAlignment = Alignment.center;

  late Animation<Alignment> _animation;

  /// Calcula e executa um [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      ),
    );
    // Calcula a velocidade relativa ao intervalo da unidade, [0,1],
    // usado pelo controlador de animação.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/animation-physics-card-drag.gif" alt="Demonstração mostrando um widget sendo arrastado e encaixado de volta ao centro" class="site-mobile-screenshot" />
</noscript>

[Align]: {{site.api}}/flutter/widgets/Align-class.html
[Alignment]: {{site.api}}/flutter/painting/Alignment-class.html
[AnimationController]: {{site.api}}/flutter/animation/AnimationController-class.html
[GestureDetector]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[SingleTickerProviderStateMixin]: {{site.api}}/flutter/widgets/SingleTickerProviderStateMixin-mixin.html
[TickerProvider]: {{site.api}}/flutter/scheduler/TickerProvider-class.html
[MediaQuery]: {{site.api}}/flutter/widgets/MediaQuery-class.html
[DragEndDetails]: {{site.api}}/flutter/gestures/DragEndDetails-class.html
[SpringSimulation]: {{site.api}}/flutter/physics/SpringSimulation-class.html
