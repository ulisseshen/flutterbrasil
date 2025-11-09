---
ia-translate: true
title: Criar um efeito de carregamento shimmer
description: Como implementar um efeito de carregamento shimmer.
---

<?code-excerpt path-base="cookbook/effects/shimmer_loading"?>

Tempos de carregamento são inevitáveis no desenvolvimento de aplicações.
Do ponto de vista da experiência do usuário (UX),
o mais importante é mostrar aos seus usuários
que o carregamento está ocorrendo. Uma abordagem popular
para comunicar aos usuários que os dados estão carregando é
exibir uma cor cromada com uma animação shimmer sobre
as formas que aproximam o tipo de conteúdo que está carregando.

A animação a seguir mostra o comportamento do app:

![Gif showing the UI loading](/assets/images/docs/cookbook/effects/UILoadingAnimation.webp){:.site-mobile-screenshot}

Esta receita começa com os widgets de conteúdo definidos e posicionados.
Há também um Floating Action Button (FAB) no canto inferior direito
que alterna entre um modo de carregamento e um modo carregado
para que você possa validar facilmente sua implementação.

## Desenhar as formas shimmer

As formas que brilham (shimmer) neste efeito são independentes
do conteúdo real que eventualmente carrega.

Portanto, o objetivo é exibir formas que representem
o conteúdo eventual com a maior precisão possível.

Exibir formas precisas é fácil em situações onde o
conteúdo tem um limite claro. Por exemplo, nesta receita,
há algumas imagens circulares e algumas imagens de retângulo arredondado.
Você pode desenhar formas que correspondem precisamente aos contornos
dessas imagens.

Por outro lado, considere o texto que aparece abaixo das
imagens de retângulo arredondado. Você não saberá quantas linhas de
texto existem até que o texto carregue.
Portanto, não há sentido em tentar desenhar um retângulo
para cada linha de texto. Em vez disso, enquanto os dados estão carregando,
você desenha alguns retângulos arredondados muito finos que
representam o texto que aparecerá. A forma e o tamanho
não correspondem exatamente, mas tudo bem.

Comece com os itens de lista circulares no topo da tela.
Garanta que cada widget `CircleListItem` exiba um círculo
com uma cor enquanto a imagem está carregando.

<?code-excerpt "lib/main.dart (CircleListItem)"?>
```dart
class CircleListItem extends StatelessWidget {
  const CircleListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            'https://docs.flutter.dev/assets/images/'
            'exercise/split-check/Avatar1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
```

Contanto que seus widgets exibam algum tipo de forma,
você pode aplicar o efeito shimmer nesta receita.

Similar aos widgets `CircleListItem`,
garanta que os widgets `CardListItem`
exibam uma cor onde a imagem aparecerá.
Além disso, no widget `CardListItem`,
alterne entre a exibição do texto e
os retângulos com base no status de carregamento atual.

<?code-excerpt "lib/main.dart (CardListItem)"?>
```dart
class CardListItem extends StatelessWidget {
  const CardListItem({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImage(), const SizedBox(height: 16), _buildText()],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://docs.flutter.dev/assets/images/'
            'exercise/split-check/Food1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
      );
    }
  }
}
```

Sua UI agora se renderiza de forma diferente dependendo
de se está carregando ou carregada.
Ao comentar temporariamente as URLs das imagens,
você pode ver as duas maneiras como sua UI renderiza.


![Gif showing the shimmer animation](/assets/images/docs/cookbook/effects/LoadingShimmer.webp){:.site-mobile-screenshot}

O próximo objetivo é pintar todas as áreas coloridas
com um único gradiente que se parece com um shimmer.

## Pintar o gradiente shimmer

A chave para o efeito alcançado nesta receita é usar um widget
chamado [`ShaderMask`][`ShaderMask`]. O widget `ShaderMask`, como o nome sugere,
aplica um shader ao seu filho, mas apenas nas áreas onde
o filho já pintou algo. Por exemplo,
você aplicará um shader apenas às formas pretas que você
configurou anteriormente.

Defina um gradiente linear de cor cromada que é aplicado às
formas shimmer.

<?code-excerpt "lib/main.dart (shimmerGradient)"?>
```dart
const _shimmerGradient = LinearGradient(
  colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
  stops: [0.1, 0.3, 0.4],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
```

Defina um novo stateful widget chamado `ShimmerLoading`
que envolve um widget `child` fornecido com um `ShaderMask`.
Configure o widget `ShaderMask` para aplicar o gradiente
shimmer como um shader com um `blendMode` de `srcATop`.
O modo de mesclagem `srcATop` substitui qualquer cor que seu
widget `child` pintou com a cor do shader.

<?code-excerpt "lib/main.dart (ShimmerLoading)"?>
```dart
class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return _shimmerGradient.createShader(bounds);
      },
      child: widget.child,
    );
  }
}
```

Envolva seus widgets `CircleListItem` com um widget `ShimmerLoading`.

<?code-excerpt "lib/shimmer_loading_items.dart (buildTopRowItem)"?>
```dart
Widget _buildTopRowItem() {
  return ShimmerLoading(isLoading: _isLoading, child: const CircleListItem());
}
```

Envolva seus widgets `CardListItem` com um widget `ShimmerLoading`.

<?code-excerpt "lib/shimmer_loading_items.dart (buildListItem)"?>
```dart
Widget _buildListItem() {
  return ShimmerLoading(
    isLoading: _isLoading,
    child: CardListItem(isLoading: _isLoading),
  );
}
```

Quando suas formas estão carregando, elas agora exibem
o gradiente shimmer que é
retornado do `shaderCallback`.

Este é um grande passo na direção certa,
mas há um problema com esta exibição de gradiente.
Cada widget `CircleListItem` e cada widget `CardListItem`
exibe uma nova versão do gradiente.
Para esta receita, a tela inteira deve
parecer uma grande superfície brilhante.
Você resolve este problema na próxima etapa.

## Pintar um grande shimmer

Para pintar um grande shimmer pela tela,
cada widget `ShimmerLoading` precisa
pintar o mesmo gradiente de tela cheia baseado
na posição daquele widget `ShimmerLoading`
na tela.

Para ser mais preciso, em vez de assumir que o shimmer
deve ocupar a tela inteira,
deve haver alguma área que compartilha o shimmer.
Talvez essa área ocupe a tela inteira,
ou talvez não. A maneira de resolver este
tipo de problema no Flutter é definir outro widget
que fica acima de todos os widgets `ShimmerLoading`
na árvore de widgets, e chamá-lo de `Shimmer`.
Então, cada widget `ShimmerLoading` obtém uma referência
ao ancestral `Shimmer`
e solicita o tamanho e gradiente desejados para exibir.

Defina um novo stateful widget chamado `Shimmer` que
recebe um [`LinearGradient`][`LinearGradient`] e fornece aos descendentes
acesso ao seu objeto `State`.

<?code-excerpt "lib/main.dart (Shimmer)"?>
```dart
class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({super.key, required this.linearGradient, this.child});

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> {
  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
```

Adicione métodos à classe `ShimmerState` para
fornecer acesso ao `linearGradient`,
o tamanho do `RenderBox` do `ShimmerState`,
e procurar a posição de um descendente dentro do
`RenderBox` do `ShimmerState`.

<?code-excerpt "lib/shimmer_state.dart (ShimmerState)"?>
```dart
class ShimmerState extends State<Shimmer> {
  Gradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
  );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}
```

Envolva todo o conteúdo da sua tela com o widget `Shimmer`.

<?code-excerpt "lib/main.dart (ExampleUiAnimationState)"?>
```dart
class _ExampleUiLoadingAnimationState extends State<ExampleUiLoadingAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: _shimmerGradient,
        child: ListView(
          // ListView Contents
        ),
      ),
    );
  }
}
```

Use o widget `Shimmer` dentro do seu
widget `ShimmerLoading` para pintar o gradiente compartilhado.

<?code-excerpt "lib/shimmer_loading_state_pt2.dart (ShimmerLoadingStatePt2)"?>
```dart
class _ShimmerLoadingState extends State<ShimmerLoading> {
  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    // Collect ancestor shimmer information.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      // The ancestor Shimmer widget isn't laid
      // out yet. Return an empty box.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}
```

Seus widgets `ShimmerLoading` agora exibem um gradiente
compartilhado que ocupa todo o espaço dentro do
widget `Shimmer`.

## Animar o shimmer

O gradiente shimmer precisa se mover para
dar a aparência de um brilho cintilante.

O `LinearGradient` tem uma propriedade chamada `transform`
que pode ser usada para transformar a aparência do gradiente,
por exemplo, para movê-lo horizontalmente.
A propriedade `transform` aceita uma instância de `GradientTransform`.

Defina uma classe chamada `_SlidingGradientTransform` que implementa
`GradientTransform` para alcançar a aparência de deslizamento horizontal.

<?code-excerpt "lib/original_example.dart (sliding-gradient-transform)"?>
```dart
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}
```

A porcentagem de deslizamento do gradiente muda ao longo do tempo
para criar a aparência de movimento.
Para mudar a porcentagem, configure um
[`AnimationController`][`AnimationController`] na classe `ShimmerState`.

<?code-excerpt "lib/original_example.dart (shimmer-state-animation)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }
  }
```

Aplique o `_SlidingGradientTransform` ao `gradient`
usando o `value` do `_shimmerController` como o `slidePercent`.

<?code-excerpt "lib/original_example.dart (linear-gradient)"?>
```dart
LinearGradient get gradient => LinearGradient(
  colors: widget.linearGradient.colors,
  stops: widget.linearGradient.stops,
  begin: widget.linearGradient.begin,
  end: widget.linearGradient.end,
  transform: _SlidingGradientTransform(
    slidePercent: _shimmerController.value,
  ),
);
```

O gradiente agora anima, mas seus widgets
`ShimmerLoading` individuais não se repintam
conforme o gradiente muda. Portanto, parece que nada
está acontecendo.

Exponha o `_shimmerController` do `ShimmerState`
como um [`Listenable`][`Listenable`].

<?code-excerpt "lib/original_example.dart (shimmer-changes)"?>
```dart
Listenable get shimmerChanges => _shimmerController;
```

No `ShimmerLoading`, ouça mudanças na propriedade `shimmerChanges`
do ancestral `ShimmerState`,
e repinte o gradiente shimmer.

<?code-excerpt "lib/original_example.dart (shimmer-loading-state)" replace="/\/\/ code-excerpt-closing-bracket/}/g"?>
```dart
class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // Update the shimmer painting.
      });
    }
  }
  }
```

Parabéns!
Agora você tem um efeito shimmer animado
de tela cheia que liga e desliga
conforme o conteúdo carrega.

## Exemplo interativo

<?code-excerpt "lib/original_example.dart" remove="code-excerpt-closing-bracket"?>
```dartpad title="Flutter shimmer loading hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      home: ExampleUiLoadingAnimation(),
      debugShowCheckedModeBanner: false,
    ),
  );
}

const _shimmerGradient = LinearGradient(
  colors: [Color(0xFFEBEBF4), Color(0xFFF4F4F4), Color(0xFFEBEBF4)],
  stops: [0.1, 0.3, 0.4],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);

class ExampleUiLoadingAnimation extends StatefulWidget {
  const ExampleUiLoadingAnimation({super.key});

  @override
  State<ExampleUiLoadingAnimation> createState() =>
      _ExampleUiLoadingAnimationState();
}

class _ExampleUiLoadingAnimationState extends State<ExampleUiLoadingAnimation> {
  bool _isLoading = true;

  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Shimmer(
        linearGradient: _shimmerGradient,
        child: ListView(
          physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
          children: [
            const SizedBox(height: 16),
            _buildTopRowList(),
            const SizedBox(height: 16),
            _buildListItem(),
            _buildListItem(),
            _buildListItem(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleLoading,
        child: Icon(_isLoading ? Icons.hourglass_full : Icons.hourglass_bottom),
      ),
    );
  }

  Widget _buildTopRowList() {
    return SizedBox(
      height: 72,
      child: ListView(
        physics: _isLoading ? const NeverScrollableScrollPhysics() : null,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        children: [
          const SizedBox(width: 16),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
          _buildTopRowItem(),
        ],
      ),
    );
  }

  Widget _buildTopRowItem() {
    return ShimmerLoading(isLoading: _isLoading, child: const CircleListItem());
  }

  Widget _buildListItem() {
    return ShimmerLoading(
      isLoading: _isLoading,
      child: CardListItem(isLoading: _isLoading),
    );
  }
}

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({super.key, required this.linearGradient, this.child});

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  LinearGradient get gradient => LinearGradient(
    colors: widget.linearGradient.colors,
    stops: widget.linearGradient.stops,
    begin: widget.linearGradient.begin,
    end: widget.linearGradient.end,
    transform: _SlidingGradientTransform(
      slidePercent: _shimmerController.value,
    ),
  );

  bool get isSized =>
      (context.findRenderObject() as RenderBox?)?.hasSize ?? false;

  Size get size => (context.findRenderObject() as RenderBox).size;

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox?;
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }

  Listenable get shimmerChanges => _shimmerController;

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      setState(() {
        // Update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    // Collect ancestor shimmer info.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      // The ancestor Shimmer widget has not laid
      // itself out yet. Return an empty box.
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: context.findRenderObject() as RenderBox,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            -offsetWithinShimmer.dx,
            -offsetWithinShimmer.dy,
            shimmerSize.width,
            shimmerSize.height,
          ),
        );
      },
      child: widget.child,
    );
  }
}

//----------- List Items ---------
class CircleListItem extends StatelessWidget {
  const CircleListItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        width: 54,
        height: 54,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: Image.network(
            'https://docs.flutter.dev/assets/images/'
            'exercise/split-check/Avatar1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class CardListItem extends StatelessWidget {
  const CardListItem({super.key, required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_buildImage(), const SizedBox(height: 16), _buildText()],
      ),
    );
  }

  Widget _buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.network(
            'https://docs.flutter.dev/assets/images/'
            'exercise/split-check/Food1.jpg',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildText() {
    if (isLoading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: 250,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      );
    } else {
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Text(
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do '
          'eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        ),
      );
    }
  }
}
```



[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[cloning the example code]: {{site.github}}/flutter/codelabs
[issue 44152]: {{site.repo.flutter}}/issues/44152
[`LinearGradient`]: {{site.api}}/flutter/painting/LinearGradient-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[`ShaderMask`]: {{site.api}}/flutter/widgets/ShaderMask-class.html
