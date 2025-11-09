---
ia-translate: true
title: Tutorial de animações
shortTitle: Tutorial
description: Um tutorial mostrando como construir animações explícitas no Flutter.
---

<?code-excerpt path-base="animation"?>

:::secondary O que você aprenderá
* Como usar as classes fundamentais da
  biblioteca de animações para adicionar animação a um widget.
* Quando usar `AnimatedWidget` vs. `AnimatedBuilder`.
:::

Este tutorial mostra como construir animações explícitas no Flutter.
Os exemplos constroem uns sobre os outros, introduzindo você a diferentes aspectos da
biblioteca de animações. O tutorial é baseado em conceitos, classes
e métodos essenciais na biblioteca de animações que você pode aprender em
[Introduction to animations][Introduction to animations].

O Flutter SDK também fornece animações explícitas integradas,
como [`FadeTransition`][FadeTransition], [`SizeTransition`][SizeTransition]
e [`SlideTransition`][SlideTransition]. Essas animações simples são
acionadas definindo um ponto inicial e final.
Elas são mais simples de implementar
do que animações explícitas personalizadas, que são descritas aqui.

As seções a seguir guiam você através de vários exemplos de animação.
Cada seção fornece um link para o código-fonte desse exemplo.

## Renderizando animações

:::secondary Qual é o ponto?
* Como adicionar animação básica a um widget usando `addListener()` e
  `setState()`.
* Toda vez que a Animation gera um novo número, a função
  `addListener()` chama `setState()`.
* Como definir um `AnimationController` com o parâmetro
  `vsync` requerido.
* Entendendo a sintaxe "`..`" em "`..addListener`",
  também conhecida como _notação cascade_ do Dart.
* Para tornar uma classe privada, inicie seu nome com um sublinhado (`_`).
:::

Até agora você aprendeu como gerar uma sequência de números ao longo do tempo.
Nada foi renderizado na tela. Para renderizar com um
objeto `Animation`, armazene o objeto `Animation` como um
membro do seu widget e depois use seu valor para decidir como desenhar.

Considere o seguinte app que desenha o logo do Flutter sem animação:

<?code-excerpt "animate0/lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const LogoApp());

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: 300,
        width: 300,
        child: const FlutterLogo(),
      ),
    );
  }
}
```

**Código-fonte do app:** [animate0][animate0]

O código a seguir mostra o mesmo código modificado para animar o
logo crescendo de nada até o tamanho completo.
Ao definir um `AnimationController`, você deve passar um
objeto `vsync`. O parâmetro `vsync` é descrito na
[seção `AnimationController`][`AnimationController` section].

As mudanças em relação ao exemplo não animado estão destacadas:

```dart diff
- class _LogoAppState extends State<LogoApp> {
+ class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
+   late Animation<double> animation;
+   late AnimationController controller;
+
+   @override
+   void initState() {
+     super.initState();
+     controller =
+         AnimationController(duration: const Duration(seconds: 2), vsync: this);
+     animation = Tween<double>(begin: 0, end: 300).animate(controller)
+       ..addListener(() {
+         setState(() {
+           // The state that has changed here is the animation object's value.
+         });
+       });
+     controller.forward();
+   }
+
    @override
    Widget build(BuildContext context) {
      return Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
-         height: 300,
-         width: 300,
+         height: animation.value,
+         width: animation.value,
          child: const FlutterLogo(),
        ),
      );
    }
+
+   @override
+   void dispose() {
+     controller.dispose();
+     super.dispose();
+   }
  }
```

**Código-fonte do app:** [animate1][animate1]

A função `addListener()` chama `setState()`,
então toda vez que a `Animation` gera um novo número,
o frame atual é marcado como sujo, o que força
`build()` a ser chamado novamente. Em `build()`,
o container muda de tamanho porque sua altura e
largura agora usam `animation.value` em vez de um valor fixo.
Descarte o controller quando o objeto `State` for
descartado para prevenir vazamentos de memória.

Com essas poucas mudanças,
você criou sua primeira animação no Flutter!

:::tip Truque da linguagem Dart
Você pode não estar familiarizado com a notação cascade do Dart&mdash;os dois
pontos em `..addListener()`. Esta sintaxe significa que o método `addListener()`
é chamado com o valor de retorno de `animate()`.
Considere o seguinte exemplo:

<?code-excerpt "animate1/lib/main.dart (add-listener)"?>
```dart highlightLines=2
animation = Tween<double>(begin: 0, end: 300).animate(controller)
  ..addListener(() {
    // ···
  });
```

Este código é equivalente a:

<?code-excerpt "animate1/lib/main.dart (add-listener)" replace="/animation.*/$&;/g; /  \./animation/g;"?>
```dart highlightLines=2
animation = Tween<double>(begin: 0, end: 300).animate(controller);
animation.addListener(() {
    // ···
  });
```

Para aprender mais sobre cascades,
confira [Cascade notation][Cascade notation]
na [documentação da linguagem Dart][Dart language documentation].
:::

## Simplificando com AnimatedWidget

:::secondary Qual é o ponto?
* Como usar a classe auxiliar [`AnimatedWidget`][AnimatedWidget]
  (em vez de `addListener()`
  e `setState()`) para criar um widget que anima.
* Use `AnimatedWidget` para criar um widget que executa
  uma animação reutilizável.
  Para separar a transição do widget, use um
  `AnimatedBuilder`, como mostrado na
  seção [Refatorando com AnimatedBuilder][Refactoring with AnimatedBuilder].
* Exemplos de `AnimatedWidget`s na API do Flutter:
  `AnimatedBuilder`, `AnimatedModalBarrier`,
  `DecoratedBoxTransition`, `FadeTransition`,
  `PositionedTransition`, `RelativePositionedTransition`,
  `RotationTransition`, `ScaleTransition`,
  `SizeTransition`, `SlideTransition`.
:::

A classe base `AnimatedWidget` permite que você separe
o código do widget principal do código de animação.
`AnimatedWidget` não precisa manter um objeto `State`
para armazenar a animação. Adicione a seguinte classe `AnimatedLogo`:

<?code-excerpt path-base="animation/animate2"?>
<?code-excerpt "lib/main.dart (AnimatedLogo)"?>
```dart
class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
    : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        height: animation.value,
        width: animation.value,
        child: const FlutterLogo(),
      ),
    );
  }
}
```
<?code-excerpt path-base="animation"?>

`AnimatedLogo` usa o valor atual da `animation`
ao se desenhar.

O `LogoApp` ainda gerencia o `AnimationController` e o `Tween`,
e passa o objeto `Animation` para `AnimatedLogo`:

```dart diff
  void main() => runApp(const LogoApp());

+ class AnimatedLogo extends AnimatedWidget {
+   const AnimatedLogo({super.key, required Animation<double> animation})
+       : super(listenable: animation);
+
+   @override
+   Widget build(BuildContext context) {
+     final animation = listenable as Animation<double>;
+     return Center(
+       child: Container(
+         margin: const EdgeInsets.symmetric(vertical: 10),
+         height: animation.value,
+         width: animation.value,
+         child: const FlutterLogo(),
+       ),
+     );
+   }
+ }
+
  class LogoApp extends StatefulWidget {
    // ...

    @override
    void initState() {
      super.initState();
      controller =
          AnimationController(duration: const Duration(seconds: 2), vsync: this);
-     animation = Tween<double>(begin: 0, end: 300).animate(controller)
-       ..addListener(() {
-         setState(() {
-           // The state that has changed here is the animation object's value.
-         });
-       });
+     animation = Tween<double>(begin: 0, end: 300).animate(controller);
      controller.forward();
    }

    @override
-   Widget build(BuildContext context) {
-     return Center(
-       child: Container(
-         margin: const EdgeInsets.symmetric(vertical: 10),
-         height: animation.value,
-         width: animation.value,
-         child: const FlutterLogo(),
-       ),
-     );
-   }
+   Widget build(BuildContext context) => AnimatedLogo(animation: animation);

    // ...
  }
```

**Código-fonte do app:** [animate2][animate2]

<a id="monitoring"></a>

## Monitorando o progresso da animação

:::secondary Qual é o ponto?
* Use `addStatusListener()` para notificações de mudanças
  no estado da animação, como iniciar, parar
  ou reverter a direção.
* Execute uma animação em loop infinito revertendo a direção quando
  a animação for concluída ou retornar ao seu estado inicial.
:::

Muitas vezes é útil saber quando uma animação muda de estado,
como finalizar, avançar ou reverter.
Você pode obter notificações para isso com `addStatusListener()`.
O código a seguir modifica o exemplo anterior para que
ele ouça uma mudança de estado e imprima uma atualização.
A linha destacada mostra a mudança:

<?code-excerpt "animate3/lib/main.dart (print-state)" plaster="none" replace="/\/\/ (\.\..*)/$1;/g; /\n  }/$&\n  \/\/ .../g"?>
```dart highlightLines=13
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addStatusListener((status) => print('$status'));
    controller.forward();
  }
  // ...
}
```

Executar este código produz esta saída:

```console
AnimationStatus.forward
AnimationStatus.completed
```

Em seguida, use `addStatusListener()` para reverter a animação
no início ou no fim. Isso cria um efeito de "respiração":

```dart diff
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
-   animation = Tween<double>(begin: 0, end: 300).animate(controller);
+   animation = Tween<double>(begin: 0, end: 300).animate(controller)
+     ..addStatusListener((status) {
+       if (status == AnimationStatus.completed) {
+         controller.reverse();
+       } else if (status == AnimationStatus.dismissed) {
+         controller.forward();
+       }
+     })
+     ..addStatusListener((status) => print('$status'));
    controller.forward();
  }
```

**Código-fonte do app:** [animate3][animate3]

## Refatorando com AnimatedBuilder

:::secondary Qual é o ponto?
* Um [`AnimatedBuilder`][AnimatedBuilder] entende como renderizar a transição.
* Um `AnimatedBuilder` não sabe como renderizar o widget,
  nem gerencia o objeto `Animation`.
* Use `AnimatedBuilder` para descrever uma animação como
  parte de um método build para outro widget.
  Se você simplesmente deseja definir um widget com uma
  animação reutilizável, use um `AnimatedWidget`, como mostrado na
  seção [Simplificando com AnimatedWidget][Simplifying with AnimatedWidget].
* Exemplos de `AnimatedBuilders` na API do Flutter: `BottomSheet`,
  `ExpansionTile`, `PopupMenu`, `ProgressIndicator`,
  `RefreshIndicator`, `Scaffold`, `SnackBar`, `TabBar`,
  `TextField`.
:::

Um problema com o código no exemplo [animate3][animate3]
é que mudar a animação exigia mudar o widget
que renderiza o logo. Uma solução melhor
é separar responsabilidades em classes diferentes:

* Renderizar o logo
* Definir o objeto `Animation`
* Renderizar a transição

Você pode realizar essa separação com a ajuda da
classe `AnimatedBuilder`. Um `AnimatedBuilder` é uma
classe separada na árvore de renderização. Como `AnimatedWidget`,
`AnimatedBuilder` automaticamente ouve notificações
do objeto `Animation` e marca a árvore de widgets
como suja conforme necessário, então você não precisa chamar `addListener()`.

A árvore de widgets para o exemplo [animate4][animate4]
se parece com isto:

<DashImage figure image="ui/AnimatedBuilder-WidgetTree.png" alt="AnimatedBuilder widget tree" />

Começando pela base da árvore de widgets, o código para renderizar
o logo é direto:

<?code-excerpt "animate4/lib/main.dart (logo-widget)"?>
```dart
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  // Leave out the height and width so it fills the animating parent.
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const FlutterLogo(),
    );
  }
}
```

Os três blocos do meio no diagrama são todos criados no
método `build()` em `GrowTransition`, mostrado abaixo.
O widget `GrowTransition` em si é stateless e contém
o conjunto de variáveis finais necessárias para definir a animação de transição.
A função build() cria e retorna o `AnimatedBuilder`,
que recebe o método (`Anonymous` builder) e o
objeto `LogoWidget` como parâmetros. O trabalho de renderizar a
transição realmente acontece no método (`Anonymous` builder),
que cria um `Container` do tamanho apropriado
para forçar o `LogoWidget` a encolher para caber.

Um ponto complicado no código abaixo é que o child parece
estar especificado duas vezes. O que está acontecendo é que a
referência externa de child é passada para `AnimatedBuilder`,
que a passa para a closure anônima, que então usa
esse objeto como seu child. O resultado final é que o
`AnimatedBuilder` é inserido entre os dois widgets
na árvore de renderização.

<?code-excerpt "animate4/lib/main.dart (grow-transition)"?>
```dart
class GrowTransition extends StatelessWidget {
  const GrowTransition({
    required this.child,
    required this.animation,
    super.key,
  });

  final Widget child;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return SizedBox(
            height: animation.value,
            width: animation.value,
            child: child,
          );
        },
        child: child,
      ),
    );
  }
}
```

Finalmente, o código para inicializar a animação parece muito
similar ao exemplo [animate2][animate2]. O método `initState()`
cria um `AnimationController` e um `Tween`,
e depois os vincula com `animate()`. A mágica acontece no
método `build()`, que retorna um objeto `GrowTransition`
com um `LogoWidget` como filho, e um objeto animation para
conduzir a transição. Esses são os três elementos listados
nos bullet points acima.

```dart diff
  void main() => runApp(const LogoApp());

+ class LogoWidget extends StatelessWidget {
+   const LogoWidget({super.key});
+
+   // Leave out the height and width so it fills the animating parent.
+   @override
+   Widget build(BuildContext context) {
+     return Container(
+       margin: const EdgeInsets.symmetric(vertical: 10),
+       child: const FlutterLogo(),
+     );
+   }
+ }
+
+ class GrowTransition extends StatelessWidget {
+   const GrowTransition({
+     required this.child,
+     required this.animation,
+     super.key,
+   });
+
+   final Widget child;
+   final Animation<double> animation;
+
+   @override
+   Widget build(BuildContext context) {
+     return Center(
+       child: AnimatedBuilder(
+         animation: animation,
+         builder: (context, child) {
+           return SizedBox(
+             height: animation.value,
+             width: animation.value,
+             child: child,
+           );
+         },
+         child: child,
+       ),
+     );
+   }
+ }

  class LogoApp extends StatefulWidget {
    // ...

    @override
-   Widget build(BuildContext context) => AnimatedLogo(animation: animation);
+   Widget build(BuildContext context) {
+     return GrowTransition(
+       animation: animation,
+       child: const LogoWidget(),
+     );
+   }

    // ...
  }
```

**Código-fonte do app:** [animate4][animate4]

## Animações simultâneas

:::secondary Qual é o ponto?
* A classe [`Curves`][Curves] define um array de
  curvas comumente usadas que você pode
  usar com um [`CurvedAnimation`][CurvedAnimation].
:::

Nesta seção, você construirá sobre o exemplo de
[monitorar o progresso da animação][Monitoring the progress of the animation]
([animate3][animate3]), que usou `AnimatedWidget`
para animar continuamente para dentro e para fora. Considere o caso
onde você quer animar para dentro e para fora enquanto a
opacidade anima de transparente para opaco.

:::note
Este exemplo mostra como usar múltiplos tweens no mesmo animation
controller, onde cada tween gerencia um efeito diferente na
animação. É apenas para fins ilustrativos.
Se você estivesse fazendo tween de opacidade e tamanho em código de produção,
você provavelmente usaria [`FadeTransition`][FadeTransition] e [`SizeTransition`][SizeTransition]
em vez disso.
:::

Cada tween gerencia um aspecto da animação. Por exemplo:

<?code-excerpt "animate5/lib/main.dart (tweens)" plaster="none"?>
```dart
controller = AnimationController(
  duration: const Duration(seconds: 2),
  vsync: this,
);
sizeAnimation = Tween<double>(begin: 0, end: 300).animate(controller);
opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(controller);
```

Você pode obter o tamanho com `sizeAnimation.value` e a opacidade
com `opacityAnimation.value`, mas o construtor de `AnimatedWidget`
recebe apenas um único objeto `Animation`. Para resolver esse problema,
o exemplo cria seus próprios objetos `Tween` e calcula explicitamente os
valores.

Mude `AnimatedLogo` para encapsular seus próprios objetos `Tween`,
e seu método `build()` chama `Tween.evaluate()`
no objeto animation do pai para calcular
os valores de tamanho e opacidade necessários.
O código a seguir mostra as mudanças com destaques:

<?code-excerpt "animate5/lib/main.dart (diff)" replace="/(static final|child: Opacity|opacity:|_sizeTween\.|CurvedAnimation).*/[!$&!]/g"?>
```dart
class AnimatedLogo extends AnimatedWidget {
  const AnimatedLogo({super.key, required Animation<double> animation})
    : super(listenable: animation);

  // Make the Tweens static because they don't change.
  [!static final _opacityTween = Tween<double>(begin: 0.1, end: 1);!]
  [!static final _sizeTween = Tween<double>(begin: 0, end: 300);!]

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Center(
      [!child: Opacity(!]
        [!opacity: _opacityTween.evaluate(animation),!]
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          height: [!_sizeTween.evaluate(animation),!]
          width: [!_sizeTween.evaluate(animation),!]
          child: const FlutterLogo(),
        ),
      ),
    );
  }
}

class LogoApp extends StatefulWidget {
  const LogoApp({super.key});

  @override
  State<LogoApp> createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    animation = [!CurvedAnimation(parent: controller, curve: Curves.easeIn)!]
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) => AnimatedLogo(animation: animation);

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
```

**Código-fonte do app:** [animate5][animate5]

:::secondary Resumo
* Um objeto [`Animation`][Animation] conhece o estado atual de uma animação
  (por exemplo, se ela começou, parou
  ou está avançando ou em reverso),
  mas não sabe nada sobre o que aparece na tela.
* Um [`AnimationController`][AnimationController] gerencia a `Animation`.
* Um [`CurvedAnimation`][CurvedAnimation] define a progressão como uma curva não linear.
* Um [`Tween`][Tween] interpola entre um valor inicial e final
  para uma propriedade sendo animada.
:::

## Próximos passos

Este tutorial fornece uma base para criar animações no
Flutter usando `Tweens`, mas há muitas outras classes para explorar.
Você pode investigar as classes `Tween` especializadas,
animações específicas para seu tipo de sistema de design, `ReverseAnimation`,
transições de elementos compartilhados (também conhecidas como animações Hero),
simulações físicas e métodos `fling()`.

[animate0]: {{site.repo.this}}/tree/main/examples/animation/animate0
[animate1]: {{site.repo.this}}/tree/main/examples/animation/animate1
[animate2]: {{site.repo.this}}/tree/main/examples/animation/animate2
[animate3]: {{site.repo.this}}/tree/main/examples/animation/animate3
[animate4]: {{site.repo.this}}/tree/main/examples/animation/animate4
[animate5]: {{site.repo.this}}/tree/main/examples/animation/animate5
[AnimatedWidget]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[AnimatedBuilder]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[Introduction to animations]: /ui/animations
[AnimationController]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimationController` section]: /ui/animations/index#animationcontroller
[Curves]: {{site.api}}/flutter/animation/Curves-class.html
[CurvedAnimation]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[Cascade notation]: {{site.dart-site}}/language/operators#cascade-notation
[Dart language documentation]: {{site.dart-site}}/language
[FadeTransition]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[Monitoring the progress of the animation]: #monitoring
[Refactoring with AnimatedBuilder]: #refactoring-with-animatedbuilder
[SlideTransition]: {{site.api}}/flutter/widgets/SlideTransition-class.html
[Simplifying with AnimatedWidget]: #simplifying-with-animatedwidget
[SizeTransition]: {{site.api}}/flutter/widgets/SizeTransition-class.html
[Tween]: {{site.api}}/flutter/animation/Tween-class.html
[Animation]: {{site.api}}/flutter/animation/Animation-class.html
