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
* Um `AnimationController` controla todos os `Animation`s.
* Cada objeto `Animation` especifica a animação durante um `Interval`.
* Para cada propriedade sendo animada, crie um `Tween`.
:::

:::tip Terminologia
Se o conceito de tweens ou tweening é novo para você, veja o
[Animations in Flutter tutorial][].
:::

Animações escalonadas são um conceito direto: mudanças visuais
acontecem como uma série de operações, em vez de todas de uma vez.
A animação pode ser puramente sequencial, com uma mudança ocorrendo após
a próxima, ou pode se sobrepor parcial ou completamente. Também pode
ter lacunas, onde nenhuma mudança ocorre.

Este guia mostra como construir uma animação escalonada no Flutter.

:::secondary Exemplos
Este guia explica o exemplo basic_staggered_animation.
Você também pode consultar um exemplo mais complexo,
staggered_pic_selection.

[basic_staggered_animation][]
: Mostra uma série de animações sequenciais e sobrepostas
  de um único widget. Tocar na tela inicia uma animação
  que muda opacidade, tamanho, forma, cor e padding.

[staggered_pic_selection][]
: Mostra a exclusão de uma imagem de uma lista de imagens exibidas
  em um de três tamanhos. Este exemplo usa dois
  [animation controllers][]: um para seleção/desseleção de imagem
  e um para exclusão de imagem. A animação de seleção/desseleção
  é escalonada. (Para ver este efeito,
  você pode precisar aumentar o valor `timeDilation`.)
  Selecione uma das maiores imagens&mdash;ela encolhe enquanto
  exibe uma marca de verificação dentro de um círculo azul.
  Em seguida, selecione uma das menores imagens&mdash;a
  imagem grande se expande enquanto a marca de verificação desaparece.
  Antes que a imagem grande termine de se expandir,
  a imagem pequena encolhe para exibir sua marca de verificação.
  Este comportamento escalonado é similar ao que você pode
  ver no Google Photos.
:::

O vídeo a seguir demonstra a animação executada por
basic_staggered_animation:

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
widgets do Flutter. Para mais informações, veja [Building Layouts in Flutter][].
:::

## Estrutura básica de uma animação escalonada

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

{% comment %}
The app is essentially animating a `Container` whose
decoration and size are animated. The `Container`
is within another `Container` whose padding moves the
inner container around and an `Opacity` widget that's
used to fade everything in and out.
{% endcomment %}

O diagrama a seguir mostra os `Interval`s usados no
exemplo [basic_staggered_animation][].
Você pode notar as seguintes características:

* A opacidade muda durante os primeiros 10% da linha do tempo.
* Uma pequena lacuna ocorre entre a mudança de opacidade
  e a mudança de largura.
* Nada é animado durante os últimos 25% da linha do tempo.
* Aumentar o padding faz o widget parecer subir.
* Aumentar o raio da borda para 0.5
  transforma o quadrado com cantos arredondados em um círculo.
* As mudanças de padding e altura ocorrem durante
  o mesmo intervalo exato, mas não precisam.

![Diagram showing the interval specified for each motion](/assets/images/docs/ui/animations/StaggeredAnimationIntervals.png)

Para configurar a animação:

* Crie um `AnimationController` que gerencia todas as
  `Animations`.
* Crie um `Tween` para cada propriedade sendo animada.
  * O `Tween` define uma faixa de valores.
  * O método `animate` do `Tween` requer o
    controller `parent` e produz uma `Animation`
    para essa propriedade.
* Especifique o intervalo na propriedade `curve` da `Animation`.

Quando o valor da animação controladora muda,
o valor da nova animação muda, acionando a atualização da UI.

O código a seguir cria um tween para a propriedade `width`.
Ele constrói um [`CurvedAnimation`][],
especificando uma curva eased. Veja [`Curves`][] para
outras curvas de animação pré-definidas disponíveis.

```dart
width = Tween<double>(
  begin: 50.0,
  end: 150.0,
).animate(
  CurvedAnimation(
    parent: controller,
    curve: const Interval(
      0.125,
      0.250,
      curve: Curves.ease,
    ),
  ),
),
```

Os valores `begin` e `end` não precisam ser doubles.
O código a seguir constrói o tween para a propriedade `borderRadius`
(que controla o arredondamento dos cantos do quadrado),
usando `BorderRadius.circular()`.

```dart
borderRadius = BorderRadiusTween(
  begin: BorderRadius.circular(4),
  end: BorderRadius.circular(75),
).animate(
  CurvedAnimation(
    parent: controller,
    curve: const Interval(
      0.375,
      0.500,
      curve: Curves.ease,
    ),
  ),
),
```

### Animação escalonada completa

Como todos os widgets interativos, a animação completa consiste
em um par de widgets: um stateless e um stateful.

O widget stateless especifica os `Tween`s,
define os objetos `Animation` e fornece uma função `build()`
responsável por construir a parte animada da árvore de widgets.

O widget stateful cria o controller, executa a animação
e constrói a parte não animada da árvore de widgets.
A animação começa quando um toque é detectado em qualquer lugar da tela.

[Full code for basic_staggered_animation's main.dart][]

### Widget stateless: StaggerAnimation

No widget stateless, `StaggerAnimation`,
a função `build()` instancia um
[`AnimatedBuilder`][]&mdash;um widget de propósito geral para construir
animações. O `AnimatedBuilder`
constrói um widget e o configura usando os valores atuais dos `Tweens`.
O exemplo cria uma função chamada `_buildAnimation()` (que executa
as atualizações reais da UI), e a atribui à sua propriedade `builder`.
AnimatedBuilder ouve notificações do animation controller,
marcando a árvore de widgets como suja conforme os valores mudam.
Para cada tick da animação, os valores são atualizados,
resultando em uma chamada para `_buildAnimation()`.

```dart
[!class StaggerAnimation extends StatelessWidget!] {
  StaggerAnimation({super.key, required this.controller}) :

    // Each animation defined here transforms its value during the subset
    // of the controller's duration defined by the animation's interval.
    // For example the opacity animation transforms its value during
    // the first 10% of the controller's duration.

    [!opacity = Tween<double>!](
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(
          0.0,
          0.100,
          curve: Curves.ease,
        ),
      ),
    ),

    // ... Other tween definitions ...
    );

  [!final AnimationController controller;!]
  [!final Animation<double> opacity;!]
  [!final Animation<double> width;!]
  [!final Animation<double> height;!]
  [!final Animation<EdgeInsets> padding;!]
  [!final Animation<BorderRadius?> borderRadius;!]
  [!final Animation<Color?> color;!]

  // This function is called each time the controller "ticks" a new frame.
  // When it runs, all of the animation's values will have been
  // updated to reflect the controller's current value.
  [!Widget _buildAnimation(BuildContext context, Widget? child)!] {
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
            border: Border.all(
              color: Colors.indigo[300]!,
              width: 3,
            ),
            borderRadius: borderRadius.value,
          ),
        ),
      ),
    );
  }

  @override
  [!Widget build(BuildContext context)!] {
    return [!AnimatedBuilder!](
      [!builder: _buildAnimation!],
      animation: controller,
    );
  }
}
```

### Widget stateful: StaggerDemo

O widget stateful, `StaggerDemo`, cria o `AnimationController`
(aquele que governa todos), especificando uma duração de 2000 ms. Ele executa
a animação e constrói a parte não animada da árvore de widgets.
A animação começa quando um toque é detectado na tela.
A animação executa para frente e depois para trás.

```dart
[!class StaggerDemo extends StatefulWidget!] {
  @override
  State<StaggerDemo> createState() => _StaggerDemoState();
}

class _StaggerDemoState extends State<StaggerDemo>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
  }

  // ...Boilerplate...

  [!Future<void> _playAnimation() async!] {
    try {
      [!await _controller.forward().orCancel;!]
      [!await _controller.reverse().orCancel;!]
    } on TickerCanceled {
      // The animation got canceled, probably because it was disposed of.
    }
  }

  @override
  [!Widget build(BuildContext context)!] {
    timeDilation = 10.0; // 1.0 is normal animation speed.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staggered Animation'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _playAnimation();
        },
        child: Center(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.black.withValues(alpha: 0.5),
              ),
            ),
            child: StaggerAnimation(controller:_controller.view),
          ),
        ),
      ),
    );
  }
}
```

[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[animation controllers]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[Animations in Flutter tutorial]: /ui/animations/tutorial
[basic_staggered_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_staggered_animation
[Building Layouts in Flutter]: /ui/layout
[staggered_pic_selection]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/staggered_pic_selection
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[`Curves`]: {{site.api}}/flutter/animation/Curves-class.html
[Full code for basic_staggered_animation's main.dart]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_staggered_animation/lib/main.dart
[`Interval`]: {{site.api}}/flutter/animation/Interval-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
