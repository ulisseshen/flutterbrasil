---
ia-translate: true
title: Introdução a animações
shortTitle: Animações
description: Como criar animações no Flutter.
---

Animações bem projetadas fazem uma UI parecer mais intuitiva,
contribuem para a aparência elegante de um app refinado
e melhoram a experiência do usuário.
O suporte a animações do Flutter facilita a implementação de uma variedade de
tipos de animação. Muitos widgets, especialmente [Material widgets][],
vêm com os efeitos de movimento padrão definidos em sua especificação de design,
mas também é possível personalizar esses efeitos.

## Escolhendo uma abordagem

Existem diferentes abordagens que você pode adotar ao criar
animações no Flutter. Qual abordagem é a certa para você?
Para ajudá-lo a decidir, confira o vídeo,
[How to choose which Flutter Animation Widget is right for you?][]
(Também publicado como um [_artigo complementar_][article1].)

<YouTubeEmbed id="GXIJJkq_H8g" title="How to choose which Flutter animation widget is right for your use case"></YouTubeEmbed>

(Para se aprofundar no processo de decisão,
assista ao vídeo [Animations in Flutter done right][],
apresentado na Flutter Europe.)

Como mostrado no vídeo, a seguinte
árvore de decisão ajuda você a decidir qual abordagem
usar ao implementar uma animação Flutter:

<img src='/assets/images/docs/ui/animations/animation-decision-tree.png' alt="The animation decision tree">

## Mergulho profundo em animações

Para uma compreensão mais profunda de como as animações funcionam no Flutter, assista
[Animation deep dive][].
(Também publicado como um [_artigo complementar_][article6].)

<YouTubeEmbed id="PbcILiN8rbo" title="Take a deep dive into Flutter animation"></YouTubeEmbed>

## Animações implícitas e explícitas

### Animações implícitas pré-empacotadas

Se uma animação implícita pré-empacotada (a animação mais fácil
de implementar) atende às suas necessidades, assista
[Animation basics with implicit animations][].
(Também publicado como um [_artigo complementar_][article2].)

<YouTubeEmbed id="IVTjpW3W33s" title="Flutter implicit animation basics"></YouTubeEmbed>

### Animações implícitas personalizadas

Para criar uma animação implícita personalizada, assista
[Creating your own custom implicit animations with TweenAnimationBuilder][].
(Também publicado como um [_artigo complementar_][article3].)

<YouTubeEmbed id="6KiPEqzJIKQ" title="Create custom implicit animations with TweenAnimationBuilder"></YouTubeEmbed>

### Animações implícitas integradas

Para criar uma animação explícita (onde você controla a animação,
em vez de deixar o framework controlá-la), talvez
você possa usar uma das classes de animações explícitas integradas.
Para mais informações, assista
[Making your first directional animations with
built-in explicit animations][].
(Também publicado como um [_artigo complementar_][article4].)

<YouTubeEmbed id="CunyH6unILQ" title="Making your first directional animations with built-in explicit animations"></YouTubeEmbed>

### Animações explícitas

Se você precisar construir uma animação explícita do zero, assista
[Creating custom explicit animations with
AnimatedBuilder and AnimatedWidget][].
(Também publicado como um [_artigo complementar_][article5].)

<YouTubeEmbed id="fneC7t4R_B0" title="Creating custom explicit animations with AnimatedBuilder and AnimatedWidget"></YouTubeEmbed>

## Tipos de animação

Geralmente, as animações são baseadas em tween ou física.
As seções a seguir explicam o que esses termos significam
e indicam recursos onde você pode aprender mais.

### Animação tween {:#tween-animation}

Abreviação de _in-betweening_. Em uma animação tween, os pontos
inicial e final são definidos, assim como uma linha do tempo e uma curva
que define o tempo e a velocidade da transição.
O framework calcula como fazer a transição do ponto inicial
para o ponto final.

* Veja o [Animations tutorial][], que usa tweens nos exemplos.

* Veja também a documentação da API para [`Tween`][], [`CurveTween`][] e
  [`TweenSequence`][].

### Animação baseada em física

Na animação baseada em física, o movimento é modelado para se assemelhar ao comportamento
do mundo real. Quando você lança uma bola, por exemplo, onde e quando ela pousa
depende da velocidade com que foi lançada e da distância do chão.
Da mesma forma, deixar cair uma bola presa a uma mola cai
(e quica) de maneira diferente de deixar cair uma bola presa a uma corda.

* [Animate a widget using a physics simulation][]<br>
  Uma receita na seção de animações do cookbook do Flutter.

* Veja também a documentação da API para
  [`AnimationController.animateWith`][] e
  [`SpringSimulation`][].

## Padrões comuns de animação

A maioria dos designers de UX ou motion designers descobrem que certos
padrões de animação são usados repetidamente ao projetar uma UI.
Esta seção lista alguns dos padrões de animação
comumente usados e indica onde aprender mais.

### Lista ou grid animada

Este padrão envolve animar a adição ou remoção de
elementos de uma lista ou grid.

* [`AnimatedList` example][]<br>
  Esta demonstração, do [Sample app catalog][], mostra como
  animar a adição de um elemento a uma lista ou a remoção de um elemento selecionado.
  A lista Dart interna é sincronizada conforme o usuário modifica a lista usando
  os botões de mais (+) e menos (-).

### Transição de elemento compartilhado

Neste padrão, o usuário seleciona um elemento&mdash;geralmente uma
imagem&mdash;da página, e a UI anima o elemento selecionado
para uma nova página com mais detalhes. No Flutter, você pode facilmente implementar
transições de elementos compartilhados entre rotas (páginas)
usando o widget `Hero`.

* [Hero animations][]
  Como criar dois estilos de animações Hero:
  * O hero voa de uma página para outra enquanto muda de posição
    e tamanho.
  * O limite do hero muda de forma, de um círculo para um quadrado,
    enquanto voa de uma página para outra.

* Veja também a documentação da API para as
  classes [`Hero`][], [`Navigator`][] e [`PageRoute`][].

### Animação escalonada

Animações que são divididas em movimentos menores,
onde alguns dos movimentos são atrasados.
As animações menores podem ser sequenciais
ou podem se sobrepor parcial ou completamente.

* [Staggered Animations][]

<a id="concepts"></a>

## Conceitos e classes essenciais de animação

O sistema de animação no Flutter é baseado em
objetos [`Animation`][] tipados. Os widgets podem incorporar
essas animações em suas funções build diretamente
lendo seu valor atual e ouvindo suas mudanças de estado,
ou podem usar as animações como base de
animações mais elaboradas que passam para
outros widgets.

<a id="animation-class"></a>

### Animation<wbr>\<double>

No Flutter, um objeto `Animation` não sabe nada sobre o que
está na tela. Um `Animation` é uma classe abstrata que
entende seu valor atual e seu estado (completed ou dismissed).
Um dos tipos de animação mais comumente usados é `Animation<double>`.

Um objeto `Animation` gera sequencialmente
números interpolados entre dois valores durante uma certa duração.
A saída de um objeto `Animation` pode ser linear,
uma curva, uma função de passo ou qualquer outro mapeamento que você possa criar.
Dependendo de como o objeto `Animation` é controlado,
ele pode ser executado ao contrário ou até mudar de direção no
meio.

As animações também podem interpolar tipos diferentes de double, como
`Animation<Color>` ou `Animation<Size>`.

Um objeto `Animation` tem estado. Seu valor atual está
sempre disponível no membro `.value`.

Um objeto `Animation` não sabe nada sobre renderização ou
funções `build()`.

### CurvedAnimation

Uma [`CurvedAnimation`][] define o progresso da animação
como uma curva não linear.

<?code-excerpt "animation/animate5/lib/main.dart (CurvedAnimation)"?>
```dart
animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
```

`CurvedAnimation` e `AnimationController` (descritos nas próximas seções)
são ambos do tipo `Animation<double>`, então você pode passá-los de forma intercambiável.
O `CurvedAnimation` envolve o objeto que está modificando&mdash;você
não cria uma subclasse de `AnimationController` para implementar uma curva.

Você pode usar [`Curves`][] com `CurvedAnimation`. A classe `Curves` define
muitas curvas comumente usadas, ou você pode criar a sua própria. Por exemplo:

<?code-excerpt "animation/animate5/lib/main.dart (ShakeCurve)" plaster="none"?>
```dart
import 'dart:math';

class ShakeCurve extends Curve {
  @override
  double transform(double t) => sin(t * pi * 2);
}
```

Se você quiser aplicar uma curva de animação a um `Tween`, considere usar
[`CurveTween`][].

### AnimationController

[`AnimationController`][] é um objeto `Animation`
especial que gera um novo valor sempre que o hardware
está pronto para um novo frame. Por padrão,
um `AnimationController` produz linearmente os números
de 0.0 a 1.0 durante uma determinada duração.
Por exemplo, este código cria um objeto `Animation`,
mas não o inicia:

<?code-excerpt "animation/animate5/lib/main.dart (animation-controller)"?>
```dart
controller = AnimationController(
  duration: const Duration(seconds: 2),
  vsync: this,
);
```

`AnimationController` deriva de `Animation<double>`, então pode ser usado
onde quer que um objeto `Animation` seja necessário. No entanto, o `AnimationController`
tem métodos adicionais para controlar a animação. Por exemplo, você inicia
uma animação com o método `.forward()`. A geração de números está
vinculada à atualização da tela, então tipicamente 60 números são gerados por
segundo. Após cada número ser gerado, cada objeto `Animation` chama os
objetos `Listener` anexados. Para criar uma lista de exibição personalizada para cada
filho, veja [`RepaintBoundary`][].

Ao criar um `AnimationController`, você passa um argumento `vsync`.
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
{% endcomment %}

:::note
Em alguns casos, uma posição pode exceder a faixa
0.0-1.0 do `AnimationController`. Por exemplo, a função `fling()`
permite que você forneça velocidade, força e posição
(usando o objeto Force). A posição pode ser qualquer coisa e
portanto pode estar fora da faixa de 0.0 a 1.0.

Um `CurvedAnimation` também pode exceder a faixa de 0.0 a 1.0,
mesmo se o `AnimationController` não exceder.
Dependendo da curva selecionada, a saída do
`CurvedAnimation` pode ter uma faixa mais ampla que a entrada.
Por exemplo, curvas elásticas como `Curves.elasticIn`
ultrapassam ou ficam significativamente abaixo da faixa padrão.
:::

### Tween

Por padrão, o objeto `AnimationController` varia de 0.0 a 1.0.
Se você precisar de uma faixa diferente ou um tipo de dados diferente, você pode usar um
[`Tween`][] para configurar uma animação para interpolar para uma
faixa ou tipo de dados diferente. Por exemplo, o
seguinte `Tween` vai de -200.0 a 0.0:

<?code-excerpt "animation/animate5/lib/main.dart (tween)"?>
```dart
tween = Tween<double>(begin: -200, end: 0);
```

Um `Tween` é um objeto stateless que recebe apenas `begin` e `end`.
O único trabalho de um `Tween` é definir um mapeamento de uma
faixa de entrada para uma faixa de saída. A faixa de entrada é comumente
de 0.0 a 1.0, mas isso não é um requisito.

Um `Tween` herda de `Animatable<T>`, não de `Animation<T>`.
Um `Animatable`, como `Animation`, não precisa produzir double.
Por exemplo, `ColorTween` especifica uma progressão entre duas cores.

<?code-excerpt "animation/animate5/lib/main.dart (colorTween)"?>
```dart
colorTween = ColorTween(begin: Colors.transparent, end: Colors.black54);
```

Um objeto `Tween` não armazena nenhum estado. Em vez disso, ele fornece o
método [`evaluate(Animation<double> animation)`][] que usa a
função `transform` para mapear o valor atual da animação
(entre 0.0 e 1.0), para o valor real da animação.

O valor atual do objeto `Animation` pode ser encontrado no
método `.value`. A função evaluate também executa algumas tarefas de manutenção,
como garantir que begin e end sejam retornados quando os
valores da animação são 0.0 e 1.0, respectivamente.

#### Tween.animate

Para usar um objeto `Tween`, chame `animate()` no `Tween`,
passando o objeto controller. Por exemplo,
o código a seguir gera os
valores inteiros de 0 a 255 durante 500 ms.

<?code-excerpt "animation/animate5/lib/main.dart (IntTween)"?>
```dart
AnimationController controller = AnimationController(
  duration: const Duration(milliseconds: 500),
  vsync: this,
);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(controller);
```

:::note
O método `animate()` retorna um [`Animation`][],
não um [`Animatable`][].
:::

O exemplo a seguir mostra um controller, uma curva e um `Tween`:

<?code-excerpt "animation/animate5/lib/main.dart (IntTween-curve)"?>
```dart
AnimationController controller = AnimationController(
  duration: const Duration(milliseconds: 500),
  vsync: this,
);
final Animation<double> curve = CurvedAnimation(
  parent: controller,
  curve: Curves.easeOut,
);
Animation<int> alpha = IntTween(begin: 0, end: 255).animate(curve);
```

### Notificações de animação

Um objeto [`Animation`][] pode ter `Listener`s e `StatusListener`s,
definidos com `addListener()` e `addStatusListener()`.
Um `Listener` é chamado sempre que o valor da animação muda.
O comportamento mais comum de um `Listener` é chamar `setState()`
para causar uma reconstrução. Um `StatusListener` é chamado quando uma animação começa,
termina, avança ou retrocede, conforme definido por `AnimationStatus`.

## Codelabs, tutoriais e artigos

Os seguintes recursos são um bom ponto de partida para aprender
o framework de animação do Flutter. Cada um desses documentos
mostra como escrever código de animação.

* [Animations in Flutter codelab][]<br>
  Aprenda sobre animações implícitas e explícitas
  enquanto constrói um jogo de quiz de múltipla escolha.

* [Animations tutorial][]<br>
  Explica as classes fundamentais no pacote de animação do Flutter
  (controllers, `Animatable`, curvas, listeners, builders),
  enquanto o guia através de uma progressão de animações tween usando
  diferentes aspectos das APIs de animação. Este tutorial mostra
  como criar suas próprias animações explícitas personalizadas.

* [Zero to One with Flutter, part 1][] e [part 2][]<br>
  Artigos do Medium mostrando como criar um gráfico animado usando tweening.

* [Casual games toolkit][]<br>
  Um toolkit com templates de jogos que contêm exemplos de como usar animações
  Flutter.

## Outros recursos

Aprenda mais sobre animações Flutter nos seguintes links:

* Existem vários [animations packages][] disponíveis no pub.dev que contêm
  animações pré-construídas para padrões comumente usados, incluindo:
  transformações de `Container`, transições de eixo compartilhado,
  transições fade through e transições fade.

* [Animation samples][] do [Sample app catalog][].

* [Animation recipes][] do cookbook do Flutter.

* [Animation videos][] do canal do Flutter no YouTube.

* [Animations: overview][]<br>
  Uma visão de algumas das principais classes na
  biblioteca de animações e a arquitetura de animação do Flutter.

* [Animation and motion widgets][]<br>
  Um catálogo de alguns dos widgets de animação
  fornecidos nas APIs do Flutter.

* A [animation library][] na [Flutter API documentation][]<br>
  A API de animação para o framework Flutter. Este link
  leva você a uma página de visão geral técnica da biblioteca.

[animate1]: {{site.repo.this}}/tree/main/examples/animation/animate1
[Animate a widget using a physics simulation]: /cookbook/animation/physics-simulation
[`Animatable`]: {{site.api}}/flutter/animation/Animatable-class.html
[`AnimatedList` example]: {{site.github}}/flutter/samples/blob/main/animations
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[Animation and motion widgets]: /ui/widgets/animation
[Animation basics with implicit animations]: {{site.yt.watch}}?v=IVTjpW3W33s&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=1
[Animation deep dive]: {{site.yt.watch}}?v=PbcILiN8rbo&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=5
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[Animation recipes]: /cookbook/animation
[Animation samples]: {{site.repo.samples}}/tree/main/animations#animation-samples
[Animation videos]: {{site.social.youtube}}/search?query=animation
[Animations in Flutter done right]: {{site.yt.watch}}?v=wnARLByOtKA&t=3s
[Animations: overview]: /ui/animations/overview
[animations packages]: {{site.pub}}/packages?q=topic%3Aanimation
[Animations tutorial]: /ui/animations/tutorial
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimationController.animateWith`]: {{site.api}}/flutter/animation/AnimationController/animateWith.html
[article1]: {{site.flutter-blog}}/how-to-choose-which-flutter-animation-widget-is-right-for-you-79ecfb7e72b5
[article2]: {{site.flutter-blog}}/flutter-animation-basics-with-implicit-animations-95db481c5916
[article3]: {{site.flutter-blog}}/custom-implicit-animations-in-flutter-with-tweenanimationbuilder-c76540b47185
[article4]: {{site.flutter-blog}}/directional-animations-with-built-in-explicit-animations-3e7c5e6fbbd7
[article5]: {{site.flutter-blog}}/when-should-i-useanimatedbuilder-or-animatedwidget-57ecae0959e8
[article6]: {{site.flutter-blog}}/animation-deep-dive-39d3ffea111f
[Casual games toolkit]: /resources/games-toolkit/
[Creating your own custom implicit animations with TweenAnimationBuilder]: {{site.yt.watch}}?v=6KiPEqzJIKQ&feature=youtu.be
[Creating custom explicit animations with AnimatedBuilder and AnimatedWidget]: {{site.yt.watch}}?v=fneC7t4R_B0&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=4
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[`CurveTween`]: {{site.api}}/flutter/animation/CurveTween-class.html
[`evaluate(Animation<double> animation)`]: {{site.api}}/flutter/animation/Animation/value.html
[Flutter API documentation]: {{site.api}}
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Hero animations]: /ui/animations/hero-animations
[How to choose which Flutter Animation Widget is right for you?]: {{site.yt.watch}}?v=GXIJJkq_H8g
[Animations in Flutter codelab]: {{site.codelabs}}/advanced-flutter-animations
[Making your first directional animations with built-in explicit animations]: {{site.yt.watch}}?v=CunyH6unILQ&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=3
[Material widgets]: /ui/widgets/material
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PageRoute`]: {{site.api}}/flutter/widgets/PageRoute-class.html
[part 2]: {{site.medium}}/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb
[`RepaintBoundary`]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[Sample app catalog]: {{site.github}}/flutter/samples
[`SpringSimulation`]: {{site.api}}/flutter/physics/SpringSimulation-class.html
[Staggered Animations]: /ui/animations/staggered-animations
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
[`TweenSequence`]: {{site.api}}/flutter/animation/TweenSequence-class.html
[Zero to One with Flutter, part 1]: {{site.medium}}/dartlang/zero-to-one-with-flutter-43b13fd7b354
