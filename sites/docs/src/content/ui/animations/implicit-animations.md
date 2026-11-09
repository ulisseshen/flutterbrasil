---
ia-translate: true
title: Animações implícitas
description: Onde encontrar mais informações sobre o uso de animações implícitas no Flutter.
---

Com a [biblioteca de animação][animation library] do Flutter,
você pode adicionar movimento e criar efeitos visuais
para os widgets em sua UI.
Uma parte da biblioteca é um conjunto de widgets
que gerenciam animações para você.
Esses widgets são coletivamente referidos como _animações implícitas_,
ou _widgets implicitamente animados_, derivando seu nome da
classe [`ImplicitlyAnimatedWidget`][] que eles implementam.

Com animações implícitas, você não precisa
gerenciar um `AnimationController` ou um `Ticker`.
Em vez disso, você passa uma `duration` e uma `curve` opcional
para um widget implicitamente animado, como `AnimatedOpacity`.
Quando você atualiza o widget com um novo valor alvo,
como após chamar `setState()`,
o widget anima automaticamente até esse valor:

<?code-excerpt "animation/implicit/lib/main.dart (fade-box-demo)"?>
```dart
import 'package:material_ui/material_ui.dart';

class FadeBoxDemo extends StatefulWidget {
  const FadeBoxDemo({super.key});

  @override
  State<FadeBoxDemo> createState() => _FadeBoxDemoState();
}

class _FadeBoxDemoState extends State<FadeBoxDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedOpacity(
          opacity: _visible ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          child: const FlutterLogo(size: 100),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: const Text('Toggle opacity'),
        ),
      ],
    );
  }
}
```

**Código-fonte do app:** [exemplo de animação implícita][implicit animation example]

Quando nenhum widget implicitamente animado integrado cobre
a propriedade que você quer animar,
você pode construir uma animação implícita personalizada com [`TweenAnimationBuilder`][].

O seguinte conjunto de recursos fornece muitas maneiras de aprender
sobre animações implícitas no Flutter.

[animation library]: {{site.api}}/flutter/animation/animation-library.html
[implicit animation example]: {{site.repo.this}}/tree/main/examples/animation/implicit

## Documentation

[Codelab de Animações no Flutter][Animations in Flutter codelab]
: Aprenda sobre animações implícitas e explícitas
  e ganhe experiência prática adicionando animações implícitas
  a um app Flutter completo.

[Exemplo de `AnimatedContainer`][`AnimatedContainer` sample]
: Uma receita passo a passo para usar o
  widget implicitamente animado [`AnimatedContainer`][`AnimatedContainer`].

[Fazer um widget aparecer e desaparecer gradualmente][Fade a widget in and out]
: Uma receita do cookbook mostrando como fazer o fade de um widget usando [`AnimatedOpacity`][].

Página da API [`TweenAnimationBuilder`][]
: Crie animações implícitas personalizadas para qualquer propriedade usando um `Tween`
  e um callback `builder`.

Página da API [`ImplicitlyAnimatedWidget`][]
: Todas as animações implícitas estendem a classe `ImplicitlyAnimatedWidget`.

[Animations in Flutter codelab]: {{site.codelabs}}/advanced-flutter-animations
[`AnimatedContainer` sample]: /cookbook/animation/animated-container
[`AnimatedContainer`]: {{site.api}}/flutter/widgets/AnimatedContainer-class.html
[`AnimatedOpacity`]: {{site.api}}/flutter/widgets/AnimatedOpacity-class.html
[Fade a widget in and out]: /cookbook/animation/opacity-animation
[`ImplicitlyAnimatedWidget`]: {{site.api}}/flutter/widgets/ImplicitlyAnimatedWidget-class.html
[`TweenAnimationBuilder`]: {{site.api}}/flutter/widgets/TweenAnimationBuilder-class.html

## Flutter in Focus videos

Os vídeos Flutter in Focus apresentam tutoriais de 5 a 10 minutos
com código real que cobrem técnicas
que todo desenvolvedor Flutter precisa saber de cima a baixo.
Os seguintes vídeos cobrem tópicos
que são relevantes para animações implícitas.

<YouTubeEmbed id="IVTjpW3W33s" title="Flutter implicit animation basics"></YouTubeEmbed>

<YouTubeEmbed id="6KiPEqzJIKQ" title="Create custom implicit animations with TweenAnimationBuilder"></YouTubeEmbed>

## The Boring Show

Assista ao Boring Show para acompanhar engenheiros do Google construindo apps
do zero no Flutter. O seguinte episódio cobre
o uso de animações implícitas em um app agregador de notícias.

<YouTubeEmbed id="8ehlWchLVlQ" title="Adding implicit animations to a news application"></YouTubeEmbed>

## Widget of the Week videos

Uma série semanal de vídeos animados curtos, cada um mostrando
as características importantes de um widget específico.
Em cerca de 60 segundos, você verá código real para cada
widget com uma demonstração sobre como ele funciona.
Os seguintes vídeos Widget of the Week cobrem
widgets implicitamente animados:

<div class="card-grid wide">
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="QZAvjqOqiLY" title="AnimatedOpacity - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="PY2m0fhGNz4" title="AnimatedPadding - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="hC3s2YdtWt8" title="AnimatedPositioned - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="2W7POjFb88g" title="AnimatedSwitcher - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
</div>
