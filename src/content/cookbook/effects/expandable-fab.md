---
title: Criar um FAB expansível
description: Como implementar um FAB que expande para múltiplos botões quando tocado.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/effects/expandable_fab"?>

Um Floating Action Button (FAB) é um botão redondo que
flutua próximo ao canto inferior direito de uma área de conteúdo.
Este botão representa a ação principal para o
conteúdo correspondente, mas às vezes, não há uma ação principal.
Em vez disso, existem algumas ações críticas que o usuário pode executar.
Neste caso, você pode criar um FAB expansível como o mostrado
na figura a seguir. Quando pressionado, este FAB expansível gera
vários outros botões de ação. Cada botão corresponde a uma
dessas ações críticas.

A animação a seguir mostra o comportamento do app:

![Expandindo e colapsando o FAB](/assets/images/docs/cookbook/effects/ExpandingFAB.gif){:.site-mobile-screenshot}

## Criar um widget ExpandableFab

Comece criando um novo widget stateful chamado `ExpandableFab`.
Este widget exibe o FAB principal e coordena a expansão
e colapso dos outros botões de ação. O widget recebe
parâmetros para saber se o `ExpandedFab` começa na
posição expandida, qual é a distância máxima de cada botão de ação,
e uma lista de children. Você usará a lista depois para fornecer
os outros botões de ação.

<?code-excerpt "lib/excerpt1.dart (ExpandableFab)"?>
```dart
@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab> {
  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
```

## Cross-fade do FAB

O `ExpandableFab` exibe um botão de edição azul quando colapsado
e um botão de fechar branco quando expandido. Ao expandir e colapsar,
esses dois botões escalam e fazem um fade entre si.

Implemente o cross-fade de expansão e colapso entre os dois FABs diferentes.

<?code-excerpt "lib/excerpt2.dart (ExpandableFabState)"?>
```dart
class _ExpandableFabState extends State<ExpandableFab> {
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
  }

  void _toggle() {
    setState(() {
      _open = !_open;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}
```

O botão de abrir fica no topo do botão de fechar dentro de um `Stack`,
permitindo a aparência visual de um cross-fade conforme o botão superior
aparece e desaparece.

Para alcançar a animação de cross-fade, o botão de abrir usa um
`AnimatedContainer` com uma transformação de escala e um `AnimatedOpacity`.
O botão de abrir diminui e desaparece quando o `ExpandableFab`
vai de colapsado para expandido. Então, o botão de abrir aumenta
e aparece quando o `ExpandableFab` vai de expandido para colapsado.

Você notará que o botão de abrir está envolvido com um
`IgnorePointer`. Isso porque o botão de abrir sempre existe,
mesmo quando está transparente. Sem o `IgnorePointer`,
o botão de abrir sempre receberia o evento de toque,
mesmo quando o botão de fechar está visível.

## Criar um widget ActionButton

Cada um dos botões que expandem do `ExpandableFab`
tem o mesmo design. Eles são círculos azuis com ícones brancos.
Mais precisamente, a cor de fundo do botão é a cor `ColorScheme.secondary`,
e a cor do ícone é `ColorScheme.onSecondary`.

Defina um novo widget stateless chamado `ActionButton` para exibir
esses botões redondos.

<?code-excerpt "lib/main.dart (ActionButton)"?>
```dart
@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
```

Passe algumas instâncias deste novo widget `ActionButton` para o seu
`ExpandableFab`.

<?code-excerpt "lib/main.dart (FloatingActionButton)"?>
```dart
floatingActionButton: ExpandableFab(
  distance: 112,
  children: [
    ActionButton(
      onPressed: () => _showAction(context, 0),
      icon: const Icon(Icons.format_size),
    ),
    ActionButton(
      onPressed: () => _showAction(context, 1),
      icon: const Icon(Icons.insert_photo),
    ),
    ActionButton(
      onPressed: () => _showAction(context, 2),
      icon: const Icon(Icons.videocam),
    ),
  ],
),
```

## Expandir e colapsar os botões de ação

Os `ActionButton` filhos devem voar para fora de baixo do FAB
aberto quando expandidos. Então, os `ActionButton` filhos devem
voar de volta para baixo do FAB aberto quando colapsados.
Este movimento requer posicionamento explícito (x,y) de cada
`ActionButton` e uma `Animation` para coreografar mudanças para
essas posições (x,y) ao longo do tempo.

Introduza um `AnimationController` e uma `Animation` para
controlar a taxa na qual os vários `ActionButton` expandem e colapsam.

<?code-excerpt "lib/excerpt3.dart (ExpandableFabState3)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }
}
```

Em seguida, introduza um novo widget stateless chamado `_ExpandingActionButton`,
e configure este widget para animar e posicionar um `ActionButton` individual. O `ActionButton` é fornecido como um `Widget` genérico chamado `child`.

<?code-excerpt "lib/excerpt3.dart (ExpandingActionButton)"?>
```dart
@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
```

A parte mais importante do `_ExpandingActionButton` é o
widget `Positioned`, que posiciona o `child` em uma coordenada (x,y)
específica dentro do `Stack` ao redor.
O `AnimatedBuilder` faz com que o widget `Positioned` seja reconstruído
toda vez que a animação muda. O widget `FadeTransition`
orquestra o aparecimento e desaparecimento de cada
`ActionButton` conforme eles expandem e colapsam, respectivamente.

:::note
O uso de um widget `Positioned` dentro de `_ExpandingActionButton`
implica que `_ExpandingActionButton` só pode ser usado como um
filho direto de um `Stack`. Isso se deve à relação explícita
entre `Positioned` e `Stack`.
:::

Finalmente, use o novo widget `_ExpandingActionButton`
dentro do `ExpandableFab` para completar o exercício.

<?code-excerpt "lib/excerpt4.dart (ExpandableFabState4)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }
}
```

Parabéns! Agora você tem um FAB expansível.

## Exemplo interativo

Execute o app:

* Clique no FAB no canto inferior direito,
  representado com um ícone de Edição.
  Ele se expande em 3 botões e é substituído por
  um botão de fechar, representado por um **X**.
* Clique no botão de fechar para ver os botões expandidos
  voarem de volta para o FAB original e
  o **X** ser substituído pelo ícone de Edição.
* Expanda o FAB novamente e clique em qualquer
  um dos 3 botões satélites para ver um diálogo
  representando a ação daquele botão.


<!-- start dartpad -->

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter expandable floating action button hands-on example in DartPad" run="true"
import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleExpandableFab(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

@immutable
class ExampleExpandableFab extends StatelessWidget {
  static const _actionTitles = ['Create Post', 'Upload Photo', 'Upload Video'];

  const ExampleExpandableFab({super.key});

  void _showAction(BuildContext context, int index) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_actionTitles[index]),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expandable Fab'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 25,
        itemBuilder: (context, index) {
          return FakeItem(isBig: index.isOdd);
        },
      ),
      floatingActionButton: ExpandableFab(
        distance: 112,
        children: [
          ActionButton(
            onPressed: () => _showAction(context, 0),
            icon: const Icon(Icons.format_size),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 1),
            icon: const Icon(Icons.insert_photo),
          ),
          ActionButton(
            onPressed: () => _showAction(context, 2),
            icon: const Icon(Icons.videocam),
          ),
        ],
      ),
    );
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}

@immutable
class FakeItem extends StatelessWidget {
  const FakeItem({
    super.key,
    required this.isBig,
  });

  final bool isBig;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
      height: isBig ? 128 : 36,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: Colors.grey.shade300,
      ),
    );
  }
}
```
