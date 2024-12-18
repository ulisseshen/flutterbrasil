---
ia-translate: true
title: Introdução a animações
short-title: Animações
description: Como realizar animações no Flutter.
---

Animações bem projetadas tornam uma UI mais intuitiva, contribuem para a aparência elegante de um aplicativo refinado e melhoram a experiência do usuário. O suporte a animações do Flutter facilita a implementação de diversos tipos de animação. Muitos widgets, especialmente [widgets Material][], vêm com os efeitos de movimento padrão definidos em sua especificação de design, mas também é possível personalizar esses efeitos.

## Escolhendo uma abordagem

Existem diferentes abordagens que você pode adotar ao criar animações no Flutter. Qual abordagem é a certa para você? Para ajudá-lo a decidir, confira o vídeo, [Como escolher qual Widget de Animação do Flutter é o certo para você?][] (Também publicado como um [_artigo complementar_][article1].)

{% ytEmbed 'GXIJJkq_H8g', 'Como escolher qual widget de animação Flutter é o certo para seu caso de uso' %}

(Para se aprofundar no processo de decisão, assista ao vídeo [Animações no Flutter da maneira certa][], apresentado no Flutter Europe.)

Como mostrado no vídeo, a seguinte árvore de decisão ajuda você a decidir qual abordagem usar ao implementar uma animação Flutter:

<img src='/assets/images/docs/ui/animations/animation-decision-tree.png'
    alt="A árvore de decisão da animação" class="mw-100">

Se uma animação implícita pré-empacotada (a animação mais fácil de implementar) atender às suas necessidades, assista a [Noções básicas de animação com animações implícitas][]. (Também publicado como um [_artigo complementar_][article2].)

{% ytEmbed 'IVTjpW3W33s', 'Noções básicas de animação implícita do Flutter' %}

Para criar uma animação implícita personalizada, assista a [Criando suas próprias animações implícitas personalizadas com TweenAnimationBuilder][]. (Também publicado como um [_artigo complementar_][article3].)

{% ytEmbed '6KiPEqzJIKQ', 'Crie animações implícitas personalizadas com TweenAnimationBuilder' %}

Para criar uma animação explícita (onde você controla a animação, em vez de deixar o framework controlá-la), talvez você possa usar uma das classes de animações explícitas integradas. Para mais informações, assista [Fazendo suas primeiras animações direcionais com animações explícitas integradas][]. (Também publicado como um [_artigo complementar_][article4].)

{% ytEmbed 'CunyH6unILQ', 'Fazendo suas primeiras animações direcionais com animações explícitas integradas', true %}

Se você precisar construir uma animação explícita do zero, assista a [Criando animações explícitas personalizadas com AnimatedBuilder e AnimatedWidget][]. (Também publicado como um [_artigo complementar_][article5].)

{% ytEmbed 'fneC7t4R_B0', 'Criando animações explícitas personalizadas com AnimatedBuilder e AnimatedWidget', true %}

Para uma compreensão mais profunda de como as animações funcionam no Flutter, assista a [Animação em detalhes][]. (Também publicado como um [_artigo complementar_][article6].)

{% ytEmbed 'PbcILiN8rbo', 'Mergulhe na animação do Flutter', true %}

## Codelabs, tutoriais e artigos

Os recursos a seguir são um bom ponto de partida para aprender sobre o framework de animação do Flutter. Cada um desses documentos mostra como escrever código de animação.

* [Codelab de animações implícitas][]<br>
  Cobre como usar animações implícitas usando instruções passo a passo e exemplos interativos.

* [Tutorial de animações][]<br>
  Explica as classes fundamentais no pacote de animação do Flutter (controladores, `Animatable`, curvas, listeners, builders), enquanto orienta você por uma progressão de animações tween usando diferentes aspectos das APIs de animação. Este tutorial mostra como criar suas próprias animações explícitas personalizadas.

* [Do Zero ao Um com Flutter, parte 1][] e [parte 2][]<br>
  Artigos do Medium mostrando como criar um gráfico animado usando tweening.

* [Escreva seu primeiro aplicativo Flutter na web][]<br>
  Codelab demonstrando como criar um formulário que usa animação para mostrar o progresso do usuário ao preencher os campos.

## Tipos de animação

Geralmente, as animações são baseadas em tween ou em física. As seções a seguir explicam o que esses termos significam e apontam para recursos onde você pode aprender mais.

### Animação Tween

Abreviatura de _in-betweening_. Em uma animação tween, os pontos inicial e final são definidos, bem como uma linha do tempo e uma curva que define o tempo e a velocidade da transição. O framework calcula como fazer a transição do ponto inicial para o ponto final.

Os documentos listados acima, como o [Tutorial de animações][], não são especificamente sobre tweening, mas usam tweens em seus exemplos.

### Animação baseada em física

Na animação baseada em física, o movimento é modelado para se assemelhar ao comportamento do mundo real. Quando você joga uma bola, por exemplo, onde e quando ela aterrissa depende da rapidez com que foi lançada e da distância do chão. Da mesma forma, deixar cair uma bola presa a uma mola cai (e salta) de maneira diferente de deixar cair uma bola presa a uma corda.

* [Anime um widget usando uma simulação física][]<br>
  Uma receita na seção de animações do cookbook do Flutter.

* Consulte também a documentação da API para [`AnimationController.animateWith`][] e [`SpringSimulation`][].

## Animações pré-fabricadas

Se você estiver usando widgets Material, pode consultar o [pacote animations][] disponível no pub.dev. Este pacote contém animações pré-construídas para os seguintes padrões comumente usados: transformações `Container`, transições de eixo compartilhado, transições de fade through e transições de fade.

## Padrões de animação comuns

A maioria dos designers de UX ou motion percebe que certos padrões de animação são usados repetidamente ao projetar uma UI. Esta seção lista alguns dos padrões de animação comumente usados e informa onde aprender mais.

### Lista ou grade animada

Esse padrão envolve animar a adição ou remoção de elementos de uma lista ou grade.

* Exemplo de [`AnimatedList`][]:<br>
  Esta demonstração, do [Catálogo de aplicativos de amostra][], mostra como animar a adição de um elemento a uma lista ou remover um elemento selecionado. A lista interna do Dart é sincronizada à medida que o usuário modifica a lista usando os botões de mais (+) e menos (-).

### Transição de elemento compartilhado

Nesse padrão, o usuário seleciona um elemento — geralmente uma imagem — na página, e a UI anima o elemento selecionado para uma nova página com mais detalhes. No Flutter, você pode implementar facilmente transições de elementos compartilhados entre rotas (páginas) usando o widget `Hero`.

* [Animações Hero][]
  Como criar dois estilos de animações Hero:
  * O hero voa de uma página para outra enquanto muda de posição e tamanho.
  * O limite do hero muda de forma, de um círculo para um quadrado, enquanto ele voa de uma página para outra.

* Consulte também a documentação da API para as classes [`Hero`][], [`Navigator`][] e [`PageRoute`][].

### Animação escalonada

Animações que são divididas em movimentos menores, onde parte do movimento é atrasada. As animações menores podem ser sequenciais ou podem se sobrepor parcial ou completamente.

* [Animações escalonadas][]

{% comment %}
  Salve para que eu possa lembrar como adicioná-lo de volta mais tarde.
  <img src="/assets/images/docs/ic_new_releases_black_24px.svg" alt="este documento é novo!"> NOVO<br>
{% endcomment -%}

## Outros recursos

Saiba mais sobre animações do Flutter nos links a seguir:

* [Amostras de animação][] do [Catálogo de aplicativos de amostra][].

* [Receitas de animação][] do cookbook do Flutter.

* [Vídeos de animação][] do canal do Flutter no YouTube.

* [Animações: visão geral][]<br>
  Uma olhada em algumas das principais classes na biblioteca de animações e na arquitetura de animação do Flutter.

* [Widgets de animação e movimento][]<br>
  Um catálogo de alguns dos widgets de animação fornecidos nas APIs do Flutter.

* A [biblioteca de animação][] na [documentação da API do Flutter][]<br>
  A API de animação para o framework Flutter. Este link leva você a uma página de visão geral técnica da biblioteca.

[Anime um widget usando uma simulação física]: /cookbook/animation/physics-simulation
[Exemplo de `AnimatedList`]: https://flutter.github.io/samples/animations.html
[Widgets de animação e movimento]: /ui/widgets/animation
[Noções básicas de animação com animações implícitas]: {{site.yt.watch}}?v=IVTjpW3W33s&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=1
[Animação em detalhes]: {{site.yt.watch}}?v=PbcILiN8rbo&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=5
[biblioteca de animação]: {{site.api}}/flutter/animation/animation-library.html
[Receitas de animação]: /cookbook/animation
[Amostras de animação]: {{site.repo.samples}}/tree/main/animations#animation-samples
[Vídeos de animação]: {{site.social.youtube}}/search?query=animation
[Animações no Flutter da maneira certa]: {{site.yt.watch}}?v=wnARLByOtKA&t=3s
[Animações: visão geral]: /ui/animations/overview
[pacote animations]: {{site.pub}}/packages/animations
[Tutorial de animações]: /ui/animations/tutorial
[`AnimationController.animateWith`]: {{site.api}}/flutter/animation/AnimationController/animateWith.html
[article1]: {{site.flutter-medium}}/how-to-choose-which-flutter-animation-widget-is-right-for-you-79ecfb7e72b5
[article2]: {{site.flutter-medium}}/flutter-animation-basics-with-implicit-animations-95db481c5916
[article3]: {{site.flutter-medium}}/custom-implicit-animations-in-flutter-with-tweenanimationbuilder-c76540b47185
[article4]: {{site.flutter-medium}}/directional-animations-with-built-in-explicit-animations-3e7c5e6fbbd7
[article5]: {{site.flutter-medium}}/when-should-i-useanimatedbuilder-or-animatedwidget-57ecae0959e8
[article6]: {{site.flutter-medium}}/animation-deep-dive-39d3ffea111f
[Criando suas próprias animações implícitas personalizadas com TweenAnimationBuilder]: {{site.yt.watch}}?v=6KiPEqzJIKQ&feature=youtu.be
[Criando animações explícitas personalizadas com AnimatedBuilder e AnimatedWidget]: {{site.yt.watch}}?v=fneC7t4R_B0&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=4
[documentação da API do Flutter]: {{site.api}}
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[Animações Hero]: /ui/animations/hero-animations
[Como escolher qual Widget de Animação do Flutter é o certo para você?]: {{site.yt.watch}}?v=GXIJJkq_H8g
[Codelab de animações implícitas]: /codelabs/implicit-animations
[Fazendo suas primeiras animações direcionais com animações explícitas integradas]: {{site.yt.watch}}?v=CunyH6unILQ&list=PLjxrf2q8roU2v6UqYlt_KPaXlnjbYySua&index=3
[widgets Material]: /ui/widgets/material
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PageRoute`]: {{site.api}}/flutter/widgets/PageRoute-class.html
[parte 2]: {{site.medium}}/dartlang/zero-to-one-with-flutter-part-two-5aa2f06655cb
[Catálogo de aplicativos de amostra]: https://flutter.github.io/samples
[`SpringSimulation`]: {{site.api}}/flutter/physics/SpringSimulation-class.html
[Animações escalonadas]: /ui/animations/staggered-animations
[Escreva seu primeiro aplicativo Flutter na web]: /get-started/codelab-web
[Do Zero ao Um com Flutter, parte 1]: {{site.medium}}/dartlang/zero-to-one-with-flutter-43b13fd7b354

