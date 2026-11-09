---
ia-translate: true
title: Animações escalonadas
description: Como escrever uma animação escalonada no Flutter.
shortTitle: Escalonadas
---

:::secondary O que você aprenderá
* Uma animação escalonada consiste em animações
    sequenciais ou sobrepostas.
* Para criar uma animação escalonada, use vários objetos `Animation`.
* Um `AnimationController` controla todos os objetos `Animation`.
* Cada objeto `Animation` especifica a animação durante um `Interval`.
* Para cada propriedade sendo animada, crie um `Tween`.
:::

:::tip Terminologia
Se o conceito de tweens ou tweening é novo para você, consulte o
[Animations in Flutter tutorial][].
:::

Animações escalonadas são um conceito direto: mudanças visuais
acontecem como uma série de operações, em vez de todas de uma vez.
A animação pode ser puramente sequencial, com uma mudança ocorrendo após
a próxima, ou pode se sobrepor parcial ou completamente. Também pode
ter lacunas, onde nenhuma mudança ocorre.

Este guia mostra como construir uma animação escalonada no Flutter
que aplica uma série de animações sequenciais e sobrepostas
a um único widget. Tocar na tela inicia uma animação
que muda opacidade, tamanho, forma, cor e padding.

O vídeo a seguir demonstra esta animação escalonada:

<YouTubeEmbed id="0fFvnZemmh8" title="Staggered animation example"></YouTubeEmbed>

No vídeo, você vê a seguinte animação de um único widget,
que começa como um quadrado azul com borda e cantos ligeiramente arredondados.
O quadrado passa por mudanças na seguinte ordem:

1. Fade in
1. Alarga
1. Torna-se mais alto enquanto se move para cima
1. Transforma-se em um círculo com borda
1. Muda de cor para laranja

Após executar para frente, a animação executa em reverso.

:::secondary Novo no Flutter?
Esta página assume que você sabe como criar um layout usando os
widgets do Flutter. Para saber mais, visite [Building Layouts in Flutter][].
:::

## Estrutura básica de uma animação escalonada {:#basic-structure-of-a-staggered-animation}

:::secondary Qual é o ponto?
* Todas as animações são conduzidas pelo mesmo
  [`AnimationController`][].
* Independentemente de quanto tempo a animação dura em tempo real,
  os valores do controller devem estar entre 0.0 e 1.0, inclusive.
* Cada animação tem um [`Interval`][]
  entre 0.0 e 1.0, inclusive.
* Para cada propriedade que anima em um intervalo, crie um
  [`Tween`][]. O `Tween` especifica os valores inicial e final
  para essa propriedade.
* O `Tween` produz um objeto [`Animation`][]
  que é gerenciado pelo controller.
:::

O diagrama a seguir mostra os objetos `Interval` usados no
exemplo de animação escalonada.
Você pode notar as seguintes características:

* A opacidade muda durante os primeiros 10% da linha do tempo.
* Uma pequena lacuna ocorre entre a mudança de opacidade
  e a mudança de largura.
* Nada é animado durante os últimos 25% da linha do tempo.
* Aumentar o padding faz o widget parecer subir.
* Aumentar o raio da borda para `75.0`
  transforma o quadrado de `150.0` x `150.0` com cantos arredondados em um círculo.
* As mudanças de padding e altura ocorrem durante
  exatamente o mesmo intervalo, mas não precisam.

![Diagram showing the interval specified for each motion](/assets/images/docs/ui/animations/StaggeredAnimationIntervals.png)

Para configurar a animação:

* Crie um `AnimationController` que gerencia todos os
  objetos `Animation`.
* Crie um `Tween` para cada propriedade sendo animada.
  * O `Tween` define uma faixa de valores.
  * O método `animate()` do `Tween` recebe uma animação pai
    e produz uma `Animation` para essa propriedade.
* Especifique o intervalo com a propriedade `curve` de `CurvedAnimation`.

Quando o valor da animação controladora muda,
o valor da nova animação muda, acionando a atualização da UI.

O código a seguir cria um tween para a propriedade `width`.
Ele constrói um [`CurvedAnimation`][], especificando uma curva eased.
Para outras curvas de animação pré-definidas disponíveis, consulte [`Curves`][].

<?code-excerpt "animation/staggered_animation/lib/main.dart (width)"?>
```dart
width = Tween<double>(begin: 50, end: 150).animate(
  CurvedAnimation(
    parent: controller,
    curve: const Interval(0.125, 0.250, curve: Curves.ease),
  ),
),
```

Os valores `begin` e `end` não precisam ser doubles.
O código a seguir constrói o tween para a propriedade `borderRadius`
(que controla o arredondamento dos cantos do quadrado),
usando `BorderRadius.circular()`.

<?code-excerpt "animation/staggered_animation/lib/main.dart (border-radius)"?>
```dart
borderRadius =
    BorderRadiusTween(
      begin: BorderRadius.circular(4),
      end: BorderRadius.circular(75),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.375, 0.500, curve: Curves.ease),
      ),
    ),
```

### Animação escalonada completa {:#complete-staggered-animation}

Como todos os widgets interativos, a animação completa consiste
em um par de widgets: um stateless e um stateful.

O widget stateless especifica os objetos `Tween`,
define os objetos `Animation` e fornece uma função `build()`
responsável por construir a parte animada da árvore de widgets.

O widget stateful cria o controller, executa a animação
e constrói a parte não animada da árvore de widgets.
A animação começa quando um toque é detectado em qualquer lugar da tela.

**App source:** [staggered animation example][]

### Widget stateless: StaggerAnimation {:#stateless-widget-staggeranimation}

No widget stateless, `StaggerAnimation`,
a função `build()` instancia um
[`AnimatedBuilder`][]&mdash;um widget de propósito geral para construir animações.
O `AnimatedBuilder` constrói um widget e o configura
usando os valores atuais dos objetos `Animation`.
O exemplo cria uma função chamada `_buildAnimation()` (que executa
as atualizações reais da UI), e a atribui à sua propriedade `builder`.
`AnimatedBuilder` ouve notificações do animation controller,
marcando a árvore de widgets como suja conforme os valores mudam.
Para cada tick da animação, os valores são atualizados,
resultando em uma chamada para `_buildAnimation()`.

:::tip
Este exemplo usa um widget `Opacity` dentro do `AnimatedBuilder` para manter todas
as propriedades animadas em um único builder. Ao animar apenas a opacidade,
prefira [`FadeTransition`][] para evitar reconstruir o widget filho a cada frame.
:::


<?code-excerpt "animation/staggered_animation/lib/main.dart (stagger-animation)"?>
```dart highlightLines=6,12,63-69,74,94-95
import 'dart:async';

import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:material_ui/material_ui.dart';

class StaggerAnimation extends StatelessWidget {
  StaggerAnimation({super.key, required this.controller})
    : // Each animation defined here transforms its value during the subset
      // of the controller's duration defined by the animation's interval.
      // For example, the opacity animation transforms its value during
      // the first 10% of the controller's duration.
      opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0, 0.100, curve: Curves.ease),
        ),
      ),

      width = Tween<double>(begin: 50, end: 150).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.125, 0.250, curve: Curves.ease),
        ),
      ),

      height = Tween<double>(begin: 50, end: 150).animate(
        CurvedAnimation(
          parent: controller,
          curve: const Interval(0.250, 0.375, curve: Curves.ease),
        ),
      ),

      padding =
          EdgeInsetsTween(
            begin: const EdgeInsets.only(bottom: 16),
            end: const EdgeInsets.only(bottom: 75),
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.250, 0.375, curve: Curves.ease),
            ),
          ),

      borderRadius =
          BorderRadiusTween(
            begin: BorderRadius.circular(4),
            end: BorderRadius.circular(75),
          ).animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.375, 0.500, curve: Curves.ease),
            ),
          ),

      color = ColorTween(begin: Colors.indigo[100], end: Colors.orange[400])
          .animate(
            CurvedAnimation(
              parent: controller,
              curve: const Interval(0.500, 0.750, curve: Curves.ease),
            ),
          );

  final Animation<double> controller;
  final Animation<double> opacity;
  final Animation<double> width;
  final Animation<double> height;
  final Animation<EdgeInsets> padding;
  final Animation<BorderRadius?> borderRadius;
  final Animation<Color?> color;

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  Widget _buildAnimation(BuildContext context, Widget? child) {
    return Container(
      padding: padding.value,
      alignment: Alignment.bottomCenter,
      child: Opacity(
        opacity: opacity.value,
        child: Container(
          width: width.value,
          height: height.value,
          decoration: BoxDecoration(
            color: color.value,
            border: Border.all(color: Colors.indigo[300]!, width: 3),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(builder: _buildAnimation, animation: controller);
  }
}
```

### Widget stateful: StaggerDemo {:#stateful-widget-staggerdemo}

O widget stateful, `StaggerDemo`, cria o `AnimationController`,
especificando uma duração de 2000 ms. Ele executa a animação
e constrói a parte não animada da árvore de widgets.
A animação começa quando um toque é detectado na tela.
A animação executa para frente e depois para trás.
Toques durante a reprodução são ignorados para que a sequência possa terminar.

<?code-excerpt "animation/staggered_animation/lib/main.dart (stagger-demo)"?>
```dart highlightLines=1,28,32-33,40
class StaggerDemo extends StatefulWidget {
  const StaggerDemo({super.key});

  @override
  State<StaggerDemo> createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _playAnimation() async {
    if (_controller.isAnimating) return;

    try {
      await _controller.forward().orCancel;
      await _controller.reverse().orCancel;
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Staggered Animation')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _playAnimation,
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              border: Border.all(color: Colors.black.withValues(alpha: 0.5)),
            ),
            child: StaggerAnimation(controller: _controller.view),
          ),
        ),
      ),
    );
  }
}

void main() {
  timeDilation = 10; // 1 is normal animation speed.
  runApp(const MaterialApp(home: StaggerDemo()));
}
```

[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[Animations in Flutter tutorial]: /ui/animations/tutorial
[Building Layouts in Flutter]: /ui/layout
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[`FadeTransition`]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[`Interval`]: {{site.api}}/flutter/animation/Interval-class.html
[staggered animation example]: {{site.repo.this}}/tree/main/examples/animation/staggered_animation
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
