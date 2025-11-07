---
title: Introdução às animações
short-title: Animações
description: Como realizar animações no Flutter.
ia-translate: true
---

Animações bem projetadas fazem com que a UI pareça mais intuitiva,
contribuem para a aparência elegante de um aplicativo polido
e melhoram a experiência do usuário.
O suporte a animações do Flutter facilita a implementação de uma variedade de
tipos de animação. Muitos widgets, especialmente [Material widgets][],
vêm com os efeitos de movimento padrão definidos em suas especificações de design,
mas também é possível personalizar esses efeitos.

## Escolhendo uma abordagem

Existem diferentes abordagens que você pode adotar ao criar
animações no Flutter. Qual abordagem é adequada para você?
Para ajudá-lo a decidir, confira o vídeo,
[How to choose which Flutter Animation Widget is right for you?][]
(Também publicado como um [_artigo complementar_][article1].)

{% ytEmbed 'GXIJJkq_H8g', 'How to choose which Flutter animation widget is right for your use case' %}

(Para aprofundar-se no processo de decisão,
assista ao vídeo [Animations in Flutter done right][],
apresentado no Flutter Europe.)

Como mostrado no vídeo, a seguinte
árvore de decisão ajuda você a decidir qual abordagem
usar ao implementar uma animação Flutter:

<img src='/assets/images/docs/ui/animations/animation-decision-tree.png'
    alt="The animation decision tree" class="mw-100">

Se uma animação implícita pré-empacotada (a animação mais fácil
de implementar) atende às suas necessidades, assista
[Animation basics with implicit animations][].
(Também publicado como um [_artigo complementar_][article2].)

{% ytEmbed 'IVTjpW3W33s', 'Flutter implicit animation basics' %}

Para criar uma animação implícita personalizada, assista
[Creating your own custom implicit animations with TweenAnimationBuilder][].
(Também publicado como um [_artigo complementar_][article3].)

{% ytEmbed '6KiPEqzJIKQ', 'Create custom implicit animations with TweenAnimationBuilder' %}

Para criar uma animação explícita (onde você controla a animação,
em vez de deixar o framework controlá-la), talvez
você possa usar uma das classes de animações explícitas integradas.
Para mais informações, assista
[Making your first directional animations with
built-in explicit animations][].
(Também publicado como um [_artigo complementar_][article4].)

{% ytEmbed 'CunyH6unILQ', 'Making your first directional animations with built-in explicit animations', true %}

Se você precisar construir uma animação explícita do zero, assista
[Creating custom explicit animations with
AnimatedBuilder and AnimatedWidget][].
(Também publicado como um [_artigo complementar_][article5].)

{% ytEmbed 'fneC7t4R_B0', 'Creating custom explicit animations with AnimatedBuilder and AnimatedWidget', true %}

Para uma compreensão mais profunda de como as animações funcionam no Flutter, assista
[Animation deep dive][].
(Também publicado como um [_artigo complementar_][article6].)

{% ytEmbed 'PbcILiN8rbo', 'Take a deep dive into Flutter animation', true %}

## Codelabs, tutoriais e artigos

Os recursos a seguir são um bom lugar para começar a aprender
o framework de animação do Flutter. Cada um desses documentos
mostra como escrever código de animação.

* [Implicit animations codelab][]<br>
  Aborda como usar animações implícitas
  usando instruções passo a passo e exemplos interativos.

* [Animations tutorial][]<br>
  Explica as classes fundamentais no pacote de animação do Flutter
  (controllers, `Animatable`, curves, listeners, builders),
  enquanto orienta você através de uma progressão de tween animations usando
  diferentes aspectos das APIs de animação. Este tutorial mostra
  como criar suas próprias animações explícitas personalizadas.

* [Zero to One with Flutter, part 1][] e [part 2][]<br>
  Artigos do Medium mostrando como criar um gráfico animado usando tweening.

* [Write your first Flutter app on the web][]<br>
  Codelab demonstrando como criar um formulário
  que usa animação para mostrar o progresso do usuário
  enquanto eles preenchem os campos.

## Tipos de animação

Geralmente, as animações são baseadas em tween ou física.
As seções a seguir explicam o que esses termos significam,
e apontam para recursos onde você pode aprender mais.

### Tween animation

Abreviação de _in-betweening_. Em uma tween animation, os pontos
inicial e final são definidos, assim como uma linha do tempo, e uma curva
que define o tempo e a velocidade da transição.
O framework calcula como fazer a transição do ponto inicial
para o ponto final.

Os documentos listados acima, como o
[Animations tutorial][], não são especificamente
sobre tweening, mas usam tweens em seus exemplos.

### Physics-based animation

Na animação baseada em física, o movimento é modelado para se assemelhar ao
comportamento do mundo real. Quando você lança uma bola, por exemplo, onde e quando ela pousa
depende de quão rápido ela foi lançada e quão longe estava do chão.
Da mesma forma, soltar uma bola presa a uma mola cai
(e salta) de forma diferente de soltar uma bola presa a uma corda.

* [Animate a widget using a physics simulation][]<br>
  Uma receita na seção de animações do Flutter cookbook.

* Veja também a documentação da API para
  [`AnimationController.animateWith`][] e
  [`SpringSimulation`][].

## Pre-canned animations

Se você está usando Material widgets, talvez queira verificar
o [animations package][] disponível no pub.dev.
Este pacote contém animações pré-construídas para
os seguintes padrões comumente usados:
transformações de `Container`, transições de eixo compartilhado,
transições de fade through e transições de fade.

## Padrões de animação comuns

A maioria dos designers de UX ou motion descobre que certos
padrões de animação são usados repetidamente ao projetar uma UI.
Esta seção lista alguns dos padrões de animação comumente
usados e informa onde aprender mais.

### Animated list or grid

Este padrão envolve animar a adição ou remoção de
elementos de uma lista ou grade.

* [`AnimatedList` example][]<br>
  Esta demonstração, do [Sample app catalog][], mostra como
  animar a adição de um elemento a uma lista, ou remover um elemento selecionado.
  A lista interna em Dart é sincronizada conforme o usuário modifica a lista usando
  os botões de mais (+) e menos (-).

### Shared element transition

Neste padrão, o usuário seleciona um elemento&mdash;geralmente uma
imagem&mdash;da página, e a UI anima o elemento selecionado
para uma nova página com mais detalhes. No Flutter, você pode facilmente implementar
transições de elementos compartilhados entre rotas (páginas)
usando o widget `Hero`.

* [Hero animations][]
  Como criar dois estilos de Hero animations:
  * O hero voa de uma página para outra enquanto muda de posição
    e tamanho.
  * O limite do hero muda de forma, de um círculo para um quadrado,
    enquanto voa de uma página para outra.

* Veja também a documentação da API para as
  classes [`Hero`][], [`Navigator`][] e [`PageRoute`][].

### Staggered animation

Animações que são divididas em movimentos menores,
onde parte do movimento é atrasada.
As animações menores podem ser sequenciais,
ou podem se sobrepor parcial ou completamente.

* [Staggered Animations][]

{% comment %}
  Save so I can remember how to add it back later.
  <img src="/assets/images/docs/ic_new_releases_black_24px.svg" alt="this doc is new!"> NEW<br>
{% endcomment -%}

## Outros recursos

Saiba mais sobre animações do Flutter nos seguintes links:

* [Animation samples][] do [Sample app catalog][].

* [Animation recipes][] do Flutter cookbook.

* [Animation videos][] do canal Flutter no YouTube.

* [Animations: overview][]<br>
  Uma visão geral de algumas das principais classes na
  biblioteca de animações e a arquitetura de animação do Flutter.

* [Animation and motion widgets][]<br>
  Um catálogo de alguns dos widgets de animação
  fornecidos nas APIs do Flutter.

* A [animation library][] na [Flutter API documentation][]<br>
  A API de animação para o framework Flutter. Este link
  leva você a uma página de visão geral técnica da biblioteca.

[Animate a widget using a physics simulation]: /cookbook/animation/physics-simulation
[`AnimatedList` example]: https://flutter.github.io/samples/animations.html
[Animation and motion widgets]: /ui/widgets/animation
[Animation basics with implicit animations]: {{site.yt.watch}}?v=IVTjpW3W33s&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=1
[Animation deep dive]: {{site.yt.watch}}?v=PbcILiN8rbo&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=5
[animation library]: {{site.api}}/flutter/animation/animation-library.html
[Animation recipes]: /cookbook/animation
[Animation samples]: {{site.repo.samples}}/tree/main/animations#animation-samples
[Animation videos]: {{site.social.youtube}}/search?query=animation
[Animations in Flutter done right]: {{site.yt.watch}}?v=wnARLByOtKA&t=3s
[Animations: overview]: /ui/animations/overview
[animations package]: {{site.pub}}/packages/animations
[Animations tutorial]: /ui/animations/tutorial
[`AnimationController.animateWith`]: {{site.api}}/flutter/animation/AnimationController/animateWith.html
[article1]: {{site.flutter-medium}}/how-to-choose-which-flutter-animation-widget-is-right-for-you-79ecfb7e72b5
[article2]: {{site.flutter-medium}}/flutter-animation-basics-with-implicit-animations-95db481c5916
[article3]: {{site.flutter-medium}}/custom-implicit-animations-in-flutter-with-tweenanimationbuilder-c76540b47185
[article4]: {{site.flutter-medium}}/directional-animations-with-built-in-explicit-animations-3e7c5e6fbbd7
[article5]: {{site.flutter-medium}}/when-should-i-useanimatedbuilder-or-animatedwidget-57ecae0959e8
[article6]: {{site.flutter-medium}}/animation-deep-dive-39d3ffea111f
[Creating your own custom implicit animations with TweenAnimationBuilder]: {{site.yt.watch}}?v=6KiPEqzJIKQ&feature=youtu.be
[Creating custom explicit animations with AnimatedBuilder and AnimatedWidget]: {{site.yt.watch}}?v=fneC7t4R_B0&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=4
[Flutter API documentation]: {{site.api}}
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Hero animations]: /ui/animations/hero-animations
[How to choose which Flutter Animation Widget is right for you?]: {{site.yt.watch}}?v=GXIJJkq_H8g
[Implicit animations codelab]: /codelabs/implicit-animations
[Making your first directional animations with built-in explicit animations]: {{site.yt.watch}}?v=CunyH6unILQ&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=3
[Material widgets]: /ui/widgets/material
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PageRoute`]: {{site.api}}/flutter/widgets/PageRoute-class.html
[part 2]: {{site.medium}}/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb
[Sample app catalog]: https://flutter.github.io/samples
[`SpringSimulation`]: {{site.api}}/flutter/physics/SpringSimulation-class.html
[Staggered Animations]: /ui/animations/staggered-animations
[Write your first Flutter app on the web]: /get-started/codelab-web
[Zero to One with Flutter, part 1]: {{site.medium}}/dartlang/zero-to-one-with-flutter-43b13fd7b354
