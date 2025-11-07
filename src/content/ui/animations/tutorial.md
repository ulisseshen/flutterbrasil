---
title: Tutorial de animações
short-title: Tutorial
description: Um tutorial mostrando como construir animações explícitas no Flutter.
ia-translate: true
---

{% assign api = site.api | append: '/flutter' -%}
{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}

<?code-excerpt path-base="animation"?>

:::secondary O que você aprenderá
* Como usar as classes fundamentais da
  biblioteca de animação para adicionar animação a um widget.
* Quando usar `AnimatedWidget` vs. `AnimatedBuilder`.
:::

Este tutorial mostra como construir animações explícitas no Flutter.
Após introduzir alguns dos conceitos, classes
e métodos essenciais na biblioteca de animação, ele percorre 5
exemplos de animação. Os exemplos se baseiam uns nos outros,
introduzindo você a diferentes aspectos da biblioteca de animação.

O SDK Flutter também fornece animações explícitas integradas,
como [`FadeTransition`][], [`SizeTransition`][],
e [`SlideTransition`][]. Essas animações simples são
acionadas definindo um ponto inicial e final.
Elas são mais simples de implementar
do que animações explícitas personalizadas, que são descritas aqui.

<a id="concepts"></a>
## Conceitos e classes essenciais de animação

:::secondary Qual é o ponto?
* [`Animation`][], uma classe central na biblioteca de animação do Flutter,
  interpola os valores usados para guiar uma animação.
* Um objeto `Animation` conhece o estado atual de uma animação
  (por exemplo, se ela está iniciada, parada,
  ou movendo para frente ou ao contrário),
  mas não sabe nada sobre o que aparece na tela.
* Um [`AnimationController`][] gerencia a `Animation`.
* Uma [`CurvedAnimation`][] define a progressão como uma curva não linear.
* Um [`Tween`][] interpola entre o intervalo de dados usado pelo
  objeto sendo animado.
  Por exemplo, um `Tween` pode definir uma interpolação
  de vermelho para azul, ou de 0 a 255.
* Use `Listener`s e `StatusListener`s para monitorar
  mudanças de estado da animação.
:::

O sistema de animação no Flutter é baseado em objetos
[`Animation`][] tipados. Widgets podem incorporar
essas animações em suas funções build diretamente,
lendo seu valor atual e ouvindo suas mudanças
de estado, ou podem usar as animações como base de
animações mais elaboradas que eles passam para
outros widgets.

<a id="animation-class"></a>
### Animation<wbr>\<double>

No Flutter, um objeto `Animation` não sabe nada sobre o que
está na tela. Uma `Animation` é uma classe abstrata que
entende seu valor atual e seu estado (completo ou descartado).
Um dos tipos de animação mais comumente usados é `Animation<double>`.

Um objeto `Animation` gera sequencialmente
números interpolados entre dois valores ao longo de uma certa duração.
A saída de um objeto `Animation` pode ser linear,
uma curva, uma função de passo, ou qualquer outro mapeamento que você possa criar.
Dependendo de como o objeto `Animation` é controlado,
ele pode executar em reverso, ou até mesmo mudar de direção no
meio.

As animações também podem interpolar tipos diferentes de double, como
`Animation<Color>` ou `Animation<Size>`.

Um objeto `Animation` tem estado. Seu valor atual está
sempre disponível no membro `.value`.

Um objeto `Animation` não sabe nada sobre renderização ou
funções `build()`.

### Curved&shy;Animation

Uma [`CurvedAnimation`][] define o progresso da animação
como uma curva não linear.

<?code-excerpt "animate5/lib/main.dart (CurvedAnimation)"?>
```dart
animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
```

:::note
A classe [`Curves`][] define muitas curvas comumente usadas,
ou você pode criar suas próprias. Por exemplo:

<?code-excerpt "animate5/lib/main.dart (ShakeCurve)" plaster="none"?>
```dart
import 'dart:math';

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}
```

Navegue pela documentação do [`Curves`] para uma listagem completa
(com prévias visuais) das constantes `Curves` que vêm com o Flutter.
:::

`CurvedAnimation` e `AnimationController` (descritos na próxima seção)
são ambos do tipo `Animation<double>`, então você pode passá-los de forma intercambiável.
A `CurvedAnimation` envolve o objeto que está modificando&mdash;você
não cria subclasse do `AnimationController` para implementar uma curva.

### Animation&shy;Controller

[`AnimationController`][] é um objeto `Animation`
especial que gera um novo valor sempre que o hardware
está pronto para um novo quadro. Por padrão,
um `AnimationController` produz linearmente os números
de 0.0 a 1.0 durante uma duração determinada.
Por exemplo, este código cria um objeto `Animation`,
mas não o inicia em execução:

<?code-excerpt "animate5/lib/main.dart (animation-controller)"?>
```dart
controller =
    AnimationController(duration: const Duration(seconds: 2), vsync: this);
```

`AnimationController` deriva de `Animation<double>`, então pode ser usado
onde quer que um objeto `Animation` seja necessário. No entanto, o `AnimationController`
tem métodos adicionais para controlar a animação. Por exemplo, você inicia
uma animação com o método `.forward()`. A geração de números está
vinculada à atualização da tela, então normalmente 60 números são gerados por
segundo. Após cada número ser gerado, cada objeto `Animation` chama os
objetos `Listener` anexados. Para criar uma lista de exibição personalizada para cada
filho, consulte [`RepaintBoundary`][].

Ao criar um `AnimationController`, você passa a ele um argumento `vsync`.
A presença de `vsync` impede que animações fora da tela consumam
recursos desnecessários.
Você pode usar seu objeto stateful como vsync adicionando
`SingleTickerProviderStateMixin` à definição da classe.
Você pode ver um exemplo disso em [animate1][] no GitHub.

{% comment %}
The `vsync` object ties the ticking of the animation controller to
the visibility of the widget, so that when the animating widget goes
off-screen, the ticking stops, and when the widget is restored, it
starts again (without stopping the clock, so it's as if it had
been ticking the whole time, but without using the CPU.)
To use your custom State object as the `vsync`, include the
`TickerProviderStateMixin` when defining the custom State class.
{% endcomment -%}

:::note
Em alguns casos, uma posição pode exceder o intervalo
0.0-1.0 do `AnimationController`. Por exemplo, a função `fling()`
permite que você forneça velocidade, força e posição
(através do objeto Force). A posição pode ser qualquer coisa e
portanto pode estar fora do intervalo 0.0 a 1.0.

Uma `CurvedAnimation` também pode exceder o intervalo 0.0 a 1.0,
mesmo que o `AnimationController` não o faça.
Dependendo da curva selecionada, a saída da
`CurvedAnimation` pode ter um intervalo mais amplo que a entrada.
Por exemplo, curvas elásticas como `Curves.elasticIn`
ultrapassam ou ficam aquém significativamente do intervalo padrão.
:::

### Tween

Por padrão, o objeto `AnimationController` varia de 0.0 a 1.0.
Se você precisar de um intervalo diferente ou de um tipo de dados diferente, pode usar um
[`Tween`][] para configurar uma animação para interpolar para um
intervalo ou tipo de dados diferente. Por exemplo, o
seguinte `Tween` vai de -200.0 a 0.0:

<?code-excerpt "animate5/lib/main.dart (tween)"?>
```dart
tween = Tween<double>(begin: -200, end: 0);
```

Um `Tween` é um objeto stateless que recebe apenas `begin` e `end`.
O único trabalho de um `Tween` é definir um mapeamento de um
intervalo de entrada para um intervalo de saída. O intervalo de entrada é comumente
0.0 a 1.0, mas isso não é um requisito.

Um `Tween` herda de `Animatable<T>`, não de `Animation<T>`.
Um `Animatable`, como `Animation`, não precisa produzir double.
Por exemplo, `ColorTween` especifica uma progressão entre duas cores.

<?code-excerpt "animate5/lib/main.dart (colorTween)"?>
```dart
colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54);
```

Um objeto `Tween` não armazena nenhum estado. Em vez disso, ele fornece o
método [`evaluate(Animation<double> animation)`][] que usa a
função `transform` para mapear o valor atual da animação
(entre 0.0 e 1.0), para o valor real da animação.

O valor atual do objeto `Animation` pode ser encontrado no
método `.value`. A função evaluate também realiza algumas tarefas de manutenção,
como garantir que begin e end sejam retornados quando os
valores da animação forem 0.0 e 1.0, respectivamente.

#### Tween.animate

Para usar um objeto `Tween`, chame `animate()` no `Tween`,
passando o objeto controller. Por exemplo,
o código a seguir gera os
valores inteiros de 0 a 255 ao longo de 500 ms.

<?code-excerpt "animate5/lib/main.dart (IntTween)"?>
```dart
AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
```

:::note
O método `animate()` retorna uma [`Animation`][],
não um [`Animatable`][].
:::

O exemplo a seguir mostra um controller, uma curva e um `Tween`:

<?code-excerpt "animate5/lib/main.dart (IntTween-curve)"?>
```dart
AnimationController controller = AnimationController(
    duration: const Duration(milliseconds: 500), vsync: this);
final Animation<double> curve =
    CurvedAnimation(parent: controller, curve: Curves.easeOut);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
```

### Notificações de animação

Um objeto [`Animation`][] pode ter `Listener`s e `StatusListener`s,
definidos com `addListener()` e `addStatusListener()`.
Um `Listener` é chamado sempre que o valor da animação muda.
O comportamento mais comum de um `Listener` é chamar `setState()`
para causar uma reconstrução. Um `StatusListener` é chamado quando uma animação começa,
termina, move para frente, ou move em reverso, conforme definido por `AnimationStatus`.
A próxima seção tem um exemplo do método `addListener()`,
e [Monitorando o progresso da animação][] mostra um
exemplo de `addStatusListener()`.

---

## Exemplos de animação

Esta seção percorre 5 exemplos de animação.
Cada seção fornece um link para o código-fonte desse exemplo.

### Renderizando animações

:::secondary Qual é o ponto?
* Como adicionar animação básica a um widget usando `addListener()` e
  `setState()`.
* Toda vez que a Animation gera um novo número, a função `addListener()`
  chama `setState()`.
* Como definir um `AnimationController` com o parâmetro
  `vsync` obrigatório.
* Entendendo a sintaxe "`..`" em "`..addListener`",
  também conhecida como _notação em cascata_ do Dart.
* Para tornar uma classe privada, inicie seu nome com um sublinhado (`_`).
:::

Até agora você aprendeu como gerar uma sequência de números ao longo do tempo.
Nada foi renderizado na tela. Para renderizar com um
objeto `Animation`, armazene o objeto `Animation` como um
membro do seu widget, então use seu valor para decidir como desenhar.

Considere o seguinte aplicativo que desenha o logo do Flutter sem animação:

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

**Código-fonte do app:** [animate0][]

O seguinte mostra o mesmo código modificado para animar o
logo para crescer de nada até o tamanho completo.
Ao definir um `AnimationController`, você deve passar um
objeto `vsync`. O parâmetro `vsync` é descrito na
[seção `AnimationController`][].

As mudanças do exemplo não animado são destacadas:

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

**Código-fonte do app:** [animate1][]

A função `addListener()` chama `setState()`,
então toda vez que a `Animation` gera um novo número,
o quadro atual é marcado como sujo, o que força
`build()` a ser chamado novamente. Em `build()`,
o container muda de tamanho porque sua altura e
largura agora usam `animation.value` em vez de um valor codificado.
Descarte o controller quando o objeto `State` for
descartado para evitar vazamentos de memória.

Com essas poucas mudanças,
você criou sua primeira animação no Flutter!

:::tip Truque da linguagem Dart
Você pode não estar familiarizado com a notação em cascata do Dart&mdash;os dois
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

Para aprender mais sobre cascatas,
confira [Cascade notation][]
na [documentação da linguagem Dart][].
:::

<a id="simplifying-with-animatedwidget"></a>
###  Simplificando com Animated&shy;Widget

:::secondary Qual é o ponto?
* Como usar a classe auxiliar [`AnimatedWidget`][]
  (em vez de `addListener()`
  e `setState()`) para criar um widget que anima.
* Use `AnimatedWidget` para criar um widget que executa
  uma animação reutilizável.
  Para separar a transição do widget, use um
  `AnimatedBuilder`, conforme mostrado na
  seção [Refatorando com AnimatedBuilder][].
* Exemplos de `AnimatedWidget`s na API do Flutter:
  `AnimatedBuilder`, `AnimatedModalBarrier`,
  `DecoratedBoxTransition`, `FadeTransition`,
  `PositionedTransition`, `RelativePositionedTransition`,
  `RotationTransition`, `ScaleTransition`,
  `SizeTransition`, `SlideTransition`.
:::

A classe base `AnimatedWidget` permite que você separe o
código do widget principal do código da animação.
`AnimatedWidget` não precisa manter um objeto `State`
para conter a animação. Adicione a seguinte classe `AnimatedLogo`:

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

**Código-fonte do app:** [animate2][]

<a id="monitoring"></a>
### Monitorando o progresso da animação

:::secondary Qual é o ponto?
* Use `addStatusListener()` para notificações de mudanças
  no estado da animação, como iniciar, parar,
  ou reverter direção.
* Execute uma animação em um loop infinito revertendo a direção quando
  a animação estiver completa ou retornado ao seu estado inicial.
:::

Muitas vezes é útil saber quando uma animação muda de estado,
como terminar, mover para frente, ou reverter.
Você pode obter notificações para isso com `addStatusListener()`.
O código a seguir modifica o exemplo anterior para que
ele escute uma mudança de estado e imprima uma atualização.
A linha destacada mostra a mudança:

<?code-excerpt "animate3/lib/main.dart (print-state)" plaster="none" replace="/\/\/ (\.\..*)/$1;/g; /\n  }/$&\n  \/\/ .../g"?>
```dart highlightLines=11
class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
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
no início ou no final. Isso cria um efeito de "respiração":

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

**Código-fonte do app:** [animate3][]

<a id="refactoring-with-animatedbuilder"></a>
### Refatorando com AnimatedBuilder

:::secondary Qual é o ponto?
* Um [`AnimatedBuilder`][] entende como renderizar a transição.
* Um `AnimatedBuilder` não sabe como renderizar o widget,
  nem gerencia o objeto `Animation`.
* Use `AnimatedBuilder` para descrever uma animação como
  parte de um método build para outro widget.
  Se você simplesmente quiser definir um widget com uma animação reutilizável,
  use um `AnimatedWidget`, conforme mostrado na
  seção [Simplificando com AnimatedWidget][].
* Exemplos de `AnimatedBuilders` na API do Flutter: `BottomSheet`,
  `ExpansionTile`, `PopupMenu`, `ProgressIndicator`,
  `RefreshIndicator`, `Scaffold`, `SnackBar`, `TabBar`,
  `TextField`.
:::

Um problema com o código no exemplo [animate3][],
é que alterar a animação exigia alterar o widget
que renderiza o logo. Uma solução melhor
é separar responsabilidades em diferentes classes:

* Renderizar o logo
* Definir o objeto `Animation`
* Renderizar a transição

Você pode realizar essa separação com a ajuda da
classe `AnimatedBuilder`. Um `AnimatedBuilder` é uma
classe separada na árvore de renderização. Como `AnimatedWidget`,
`AnimatedBuilder` automaticamente escuta notificações
do objeto `Animation`, e marca a árvore de widgets
como suja conforme necessário, então você não precisa chamar `addListener()`.

A árvore de widgets para o exemplo [animate4][]
se parece com isto:

<img src="/assets/images/docs/ui/AnimatedBuilder-WidgetTree.png"
    alt="AnimatedBuilder widget tree" class="d-block mx-auto" width="160px">

Começando da parte inferior da árvore de widgets, o código para renderizar
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

Os três blocos do meio no diagrama são todos criados no método
`build()` em `GrowTransition`, mostrado abaixo.
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
esse objeto como seu child. O resultado líquido é que o
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
semelhante ao exemplo [animate2][]. O método `initState()`
cria um `AnimationController` e um `Tween`,
depois os vincula com `animate()`. A mágica acontece no
método `build()`, que retorna um objeto `GrowTransition`
com um `LogoWidget` como child, e um objeto animation para
conduzir a transição. Esses são os três elementos listados
nos marcadores acima.

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
+     final animation = listenable as Animation<double>;
+     return Center(
+       child: Container(
+         margin: const EdgeInsets.symmetric(vertical: 10),
+         height: animation.value,
+         width: animation.value,
+         child: const FlutterLogo(),
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

**Código-fonte do app:** [animate4][]

### Animações simultâneas

:::secondary Qual é o ponto?
* A classe [`Curves`][] define um array de
  curvas comumente usadas que você pode
  usar com uma [`CurvedAnimation`][].
:::

Nesta seção, você construirá com base no exemplo de
[monitoramento do progresso da animação][]
([animate3][]), que usou `AnimatedWidget`
para animar continuamente de entrada e saída. Considere o caso
onde você deseja animar de entrada e saída enquanto a
opacidade anima de transparente para opaco.

:::note
Este exemplo mostra como usar múltiplos tweens no mesmo animation
controller, onde cada tween gerencia um efeito diferente na
animação. É apenas para fins ilustrativos.
Se você estivesse fazendo tweening de opacidade e tamanho no código de produção,
você provavelmente usaria [`FadeTransition`][] e [`SizeTransition`][]
em vez disso.
:::

Cada tween gerencia um aspecto da animação. Por exemplo:

<?code-excerpt "animate5/lib/main.dart (tweens)" plaster="none"?>
```dart
controller =
    AnimationController(duration: const Duration(seconds: 2), vsync: this);
sizeAnimation = Tween<double>(begin: 0, end: 300).animate(controller);
opacityAnimation = Tween<double>(begin: 0.1, end: 1).animate(controller);
```

Você pode obter o tamanho com `sizeAnimation.value` e a opacidade
com `opacityAnimation.value`, mas o construtor para `AnimatedWidget`
recebe apenas um único objeto `Animation`. Para resolver este problema,
o exemplo cria seus próprios objetos `Tween` e calcula explicitamente os
valores.

Altere `AnimatedLogo` para encapsular seus próprios objetos `Tween`,
e seu método `build()` chama `Tween.evaluate()`
no objeto animation do pai para calcular
os valores necessários de tamanho e opacidade.
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
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
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

**Código-fonte do app:** [animate5][]

## Próximos passos

Este tutorial oferece uma base para criar animações no
Flutter usando `Tweens`, mas existem muitas outras classes a explorar.
Você pode investigar as classes `Tween` especializadas,
animações específicas do Material Design,
`ReverseAnimation`,
transições de elementos compartilhados (também conhecidas como Hero animations),
simulações físicas e métodos `fling()`.
Consulte a [página inicial de animações][]
para os documentos e exemplos mais recentes disponíveis.


[animate0]: {{examples}}/animation/animate0
[animate1]: {{examples}}/animation/animate1
[animate2]: {{examples}}/animation/animate2
[animate3]: {{examples}}/animation/animate3
[animate4]: {{examples}}/animation/animate4
[animate5]: {{examples}}/animation/animate5
[`AnimatedWidget`]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[`Animatable`]: {{site.api}}/flutter/animation/Animatable-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[página inicial de animações]: /ui/animations
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[seção `AnimationController`]: #animationcontroller
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[Cascade notation]: {{site.dart-site}}/language/operators#cascade-notation
[documentação da linguagem Dart]: {{site.dart-site}}/language
[`evaluate(Animation<double> animation)`]: {{site.api}}/flutter/animation/Animation/value.html
[`FadeTransition`]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[Monitorando o progresso da animação]: #monitoring
[monitoramento do progresso da animação]: #monitoring
[Refatorando com AnimatedBuilder]: #refactoring-with-animatedbuilder
[`RepaintBoundary`]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[`SlideTransition`]: {{site.api}}/flutter/widgets/SlideTransition-class.html
[Simplificando com AnimatedWidget]: #simplifying-with-animatedwidget
[`SizeTransition`]: {{site.api}}/flutter/widgets/SizeTransition-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
