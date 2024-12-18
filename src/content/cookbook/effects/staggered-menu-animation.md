---
ia-translate: true
title: Criar uma animação de menu escalonada
description: Como implementar uma animação de menu escalonada.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/effects/staggered_menu_animation"?>

Uma única tela de aplicativo pode conter várias animações.
Reproduzir todas as animações ao mesmo tempo pode ser
avassalador. Reproduzir as animações uma após a outra
pode demorar muito. Uma opção melhor é escalonar as animações.
Cada animação começa em um momento diferente,
mas as animações se sobrepõem para criar uma duração mais curta.
Nesta receita, você cria um menu de gaveta com conteúdo animado
que é escalonado e tem um botão que aparece
na parte inferior.

A animação a seguir mostra o comportamento do aplicativo:

![Exemplo de Animação de Menu Escalonada](/assets/images/docs/cookbook/effects/StaggeredMenuAnimation.gif){:.site-mobile-screenshot}

## Criar o menu sem animações

O menu da gaveta exibe uma lista de títulos,
seguida por um botão Começar na
parte inferior do menu.

Defina um widget stateful chamado `Menu`
que exibe a lista e o botão
em locais estáticos.

<?code-excerpt "lib/step1.dart (step1)"?>
```dart
class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  static const _menuTitles = [
    'Estilo Declarativo',
    'Widgets Prontos',
    'Recarregamento Dinâmico Stateful',
    'Performance Nativa',
    'Ótima Comunidade',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    // TODO: Vamos implementar isso mais tarde.
    return Container();
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(
            _menuTitles[i],
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          ),
          onPressed: () {},
          child: const Text(
            'Começar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    );
  }
}
```

## Preparar para animações

O controle do tempo de animação requer um
`AnimationController`.

Adicione o `SingleTickerProviderStateMixin`
à classe `MenuState`. Em seguida, declare e
instancie um `AnimationController`.

<?code-excerpt "lib/step2.dart (animation-controller)" plaster="none"?>
```dart
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  late AnimationController _staggeredController;

  @override
  void initState() {
    super.initState();

    _staggeredController = AnimationController(
      vsync: this,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }
}
```

O comprimento do atraso antes de cada animação é
com você. Defina os atrasos da animação,
durações individuais da animação e o total
duração da animação.

<?code-excerpt "lib/animation_delays.dart (delays)" plaster="none"?>
```dart
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;
}
```

Neste caso, todas as animações são atrasadas em 50 ms.
Depois disso, os itens da lista começam a aparecer.
O aparecimento de cada item da lista é atrasado em 50 ms após o
item da lista anterior começa a deslizar.
Cada item da lista leva 250 ms para deslizar da direita para a esquerda.
Depois que o último item da lista começa a deslizar,
o botão na parte inferior espera mais 150 ms para aparecer.
A animação do botão leva 500 ms.

Com cada atraso e duração da animação definidos,
a duração total é calculada para que possa ser
usada para calcular os tempos individuais de animação.

Os tempos de animação desejados são mostrados no diagrama a seguir:

![Diagrama de Tempo de Animação](/assets/images/docs/cookbook/effects/TimingDiagram.png){:.site-mobile-screenshot}

Para animar um valor durante uma subseção de uma animação maior,
o Flutter fornece a classe `Interval`.
Um `Interval` usa uma porcentagem de tempo inicial e um tempo final
porcentagem de tempo. Esse `Interval` pode então ser usado para
animar um valor entre esses tempos inicial e final,
em vez de usar o início e o final de toda a animação.
tempos finais. Por exemplo, dada uma animação que leva 1 segundo,
um intervalo de 0,2 a 0,5 começaria em 200 ms
(20%) e terminar em 500 ms (50%).

Declare e calcule o `Interval` de cada item da lista e o
botão inferior `Interval`.

<?code-excerpt "lib/step3.dart (step3)" plaster="none"?>
```dart
class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }
}
```

## Animar os itens da lista e o botão

A animação escalonada é reproduzida assim que o menu se torna visível.

Inicie a animação em `initState()`.

<?code-excerpt "lib/step4.dart (init-state)"?>
```dart
@override
void initState() {
  super.initState();

  _createAnimationIntervals();

  _staggeredController = AnimationController(
    vsync: this,
    duration: _animationDuration,
  )..forward();
}
```

Cada item da lista desliza da direita para a esquerda e
aparece ao mesmo tempo.

Use o `Interval` do item da lista e uma curva `easeOut`
para animar a opacidade e a tradução
valores para cada item da lista.

<?code-excerpt "lib/step4.dart (build-list-items)"?>
```dart
List<Widget> _buildListItems() {
  final listItems = <Widget>[];
  for (var i = 0; i < _menuTitles.length; ++i) {
    listItems.add(
      AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.easeOut.transform(
            _itemSlideIntervals[i].transform(_staggeredController.value),
          );
          final opacity = animationPercent;
          final slideDistance = (1.0 - animationPercent) * 150;

          return Opacity(
            opacity: opacity,
            child: Transform.translate(
              offset: Offset(slideDistance, 0),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(
            _menuTitles[i],
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
  return listItems;
}
```

Use a mesma abordagem para animar a opacidade e
a escala do botão inferior. Desta vez, use um
curva `elasticOut` para dar ao botão um efeito saltitante.

<?code-excerpt "lib/step4.dart (build-get-started)"?>
```dart
Widget _buildGetStartedButton() {
  return SizedBox(
    width: double.infinity,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: AnimatedBuilder(
        animation: _staggeredController,
        builder: (context, child) {
          final animationPercent = Curves.elasticOut.transform(
              _buttonInterval.transform(_staggeredController.value));
          final opacity = animationPercent.clamp(0.0, 1.0);
          final scale = (animationPercent * 0.5) + 0.5;

          return Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          );
        },
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
          ),
          onPressed: () {},
          child: const Text(
            'Começar',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
            ),
          ),
        ),
      ),
    ),
  );
}
```

Parabéns!
Você tem um menu animado onde o aparecimento de cada
item da lista é escalonado, seguido por um botão inferior que
aparece no lugar.

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de animação de menu escalonado do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleStaggeredAnimations(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

class ExampleStaggeredAnimations extends StatefulWidget {
  const ExampleStaggeredAnimations({
    super.key,
  });

  @override
  State<ExampleStaggeredAnimations> createState() =>
      _ExampleStaggeredAnimationsState();
}

class _ExampleStaggeredAnimationsState extends State<ExampleStaggeredAnimations>
    with SingleTickerProviderStateMixin {
  late AnimationController _drawerSlideController;

  @override
  void initState() {
    super.initState();

    _drawerSlideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
  }

  @override
  void dispose() {
    _drawerSlideController.dispose();
    super.dispose();
  }

  bool _isDrawerOpen() {
    return _drawerSlideController.value == 1.0;
  }

  bool _isDrawerOpening() {
    return _drawerSlideController.status == AnimationStatus.forward;
  }

  bool _isDrawerClosed() {
    return _drawerSlideController.value == 0.0;
  }

  void _toggleDrawer() {
    if (_isDrawerOpen() || _isDrawerOpening()) {
      _drawerSlideController.reverse();
    } else {
      _drawerSlideController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Stack(
        children: [
          _buildContent(),
          _buildDrawer(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text(
        'Menu do Flutter',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      actions: [
        AnimatedBuilder(
          animation: _drawerSlideController,
          builder: (context, child) {
            return IconButton(
              onPressed: _toggleDrawer,
              icon: _isDrawerOpen() || _isDrawerOpening()
                  ? const Icon(
                      Icons.clear,
                      color: Colors.black,
                    )
                  : const Icon(
                      Icons.menu,
                      color: Colors.black,
                    ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContent() {
    // Coloque o conteúdo da página aqui.
    return const SizedBox();
  }

  Widget _buildDrawer() {
    return AnimatedBuilder(
      animation: _drawerSlideController,
      builder: (context, child) {
        return FractionalTranslation(
          translation: Offset(1.0 - _drawerSlideController.value, 0.0),
          child: _isDrawerClosed() ? const SizedBox() : const Menu(),
        );
      },
    );
  }
}

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
  static const _menuTitles = [
    'Estilo declarativo',
    'Widgets pré-fabricados',
    'Recarga dinâmica stateful',
    'Desempenho nativo',
    'Ótima comunidade',
  ];

  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  static const _buttonDelayTime = Duration(milliseconds: 150);
  static const _buttonTime = Duration(milliseconds: 500);
  final _animationDuration = _initialDelayTime +
      (_staggerTime * _menuTitles.length) +
      _buttonDelayTime +
      _buttonTime;

  late AnimationController _staggeredController;
  final List<Interval> _itemSlideIntervals = [];
  late Interval _buttonInterval;

  @override
  void initState() {
    super.initState();

    _createAnimationIntervals();

    _staggeredController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..forward();
  }

  void _createAnimationIntervals() {
    for (var i = 0; i < _menuTitles.length; ++i) {
      final startTime = _initialDelayTime + (_staggerTime * i);
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }

    final buttonStartTime =
        Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
    final buttonEndTime = buttonStartTime + _buttonTime;
    _buttonInterval = Interval(
      buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
      buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
    );
  }

  @override
  void dispose() {
    _staggeredController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _buildFlutterLogo(),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildFlutterLogo() {
    return const Positioned(
      right: -100,
      bottom: -30,
      child: Opacity(
        opacity: 0.2,
        child: FlutterLogo(
          size: 400,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        ..._buildListItems(),
        const Spacer(),
        _buildGetStartedButton(),
      ],
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < _menuTitles.length; ++i) {
      listItems.add(
        AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.easeOut.transform(
              _itemSlideIntervals[i].transform(_staggeredController.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 150;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(slideDistance, 0),
                child: child,
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
            child: Text(
              _menuTitles[i],
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }
    return listItems;
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AnimatedBuilder(
          animation: _staggeredController,
          builder: (context, child) {
            final animationPercent = Curves.elasticOut.transform(
                _buttonInterval.transform(_staggeredController.value));
            final opacity = animationPercent.clamp(0.0, 1.0);
            final scale = (animationPercent * 0.5) + 0.5;

            return Opacity(
              opacity: opacity,
              child: Transform.scale(
                scale: scale,
                child: child,
              ),
            );
          },
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const StadiumBorder(),
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
            ),
            onPressed: () {},
            child: const Text(
              'Começar',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```
