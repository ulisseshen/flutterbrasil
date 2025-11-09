---
ia-translate: true
title: Criar um efeito parallax de rolagem
description: Como implementar um efeito parallax de rolagem.
---

<?code-excerpt path-base="cookbook/effects/parallax_scrolling"?>

Quando você rola uma lista de cards (contendo imagens,
por exemplo) em um app, você pode notar que essas
imagens parecem rolar mais lentamente do que o resto da
tela. Parece quase como se os cards na lista
estivessem em primeiro plano, mas as imagens em si ficam
bem distantes no fundo. Este efeito é
conhecido como parallax.

Nesta receita, você cria o efeito parallax construindo
uma lista de cards (com cantos arredondados contendo algum texto).
Cada card também contém uma imagem.
Conforme os cards deslizam para cima na tela,
as imagens dentro de cada card deslizam para baixo.

A animação a seguir mostra o comportamento do app:

![Parallax scrolling](/assets/images/docs/cookbook/effects/ParallaxScrolling.webp){:.site-mobile-screenshot}

## Criar uma lista para armazenar os itens parallax

Para exibir uma lista de imagens com rolagem parallax,
você deve primeiro exibir uma lista.

Crie um novo stateless widget chamado `ParallaxRecipe`.
Dentro de `ParallaxRecipe`, construa uma árvore de widgets com um
`SingleChildScrollView` e uma `Column`, que forma
uma lista.

<?code-excerpt "lib/excerpt1.dart (ParallaxRecipe)"?>
```dart
class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(child: Column(children: []));
  }
}
```

## Exibir itens com texto e uma imagem estática

Cada item da lista exibe uma imagem de fundo de
retângulo arredondado, representando uma das sete localizações no mundo.
Empilhado em cima dessa imagem de fundo está o
nome da localização e seu país,
posicionado no canto inferior esquerdo. Entre a
imagem de fundo e o texto há um gradiente escuro,
que melhora a legibilidade
do texto contra o fundo.

Implemente um stateless widget chamado `LocationListItem`
que consiste dos visuais mencionados anteriormente.
Por enquanto, use um widget `Image` estático para o fundo.
Mais tarde, você substituirá esse widget por uma versão parallax.

<?code-excerpt "lib/excerpt2.dart (LocationListItem)"?>
```dart
@immutable
class LocationListItem extends StatelessWidget {
  const LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover));
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
```

Em seguida, adicione os itens da lista ao seu widget `ParallaxRecipe`.

<?code-excerpt "lib/excerpt3.dart (ParallaxRecipeItems)"?>
```dart
class ParallaxRecipe extends StatelessWidget {
  const ParallaxRecipe({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}
```

Agora você tem uma lista típica e rolável de cards
que exibe sete localizações únicas no mundo.
Na próxima etapa, você adiciona um efeito parallax à
imagem de fundo.

## Implementar o efeito parallax

Um efeito de rolagem parallax é alcançado empurrando levemente
a imagem de fundo na direção oposta
ao resto da lista. Conforme os itens da lista deslizam para cima
na tela, cada imagem de fundo desliza levemente para baixo.
Inversamente, conforme os itens da lista deslizam para baixo na tela,
cada imagem de fundo desliza levemente para cima.
Visualmente, isso resulta em parallax.

O efeito parallax depende da posição atual
do item da lista dentro de seu ancestral `Scrollable`.
Conforme a posição de rolagem do item da lista muda, a posição
da imagem de fundo do item da lista também deve mudar.
Este é um problema interessante de resolver. A posição
de um item da lista dentro do `Scrollable` não está
disponível até que a fase de layout do Flutter esteja completa.
Isso significa que a posição da imagem de fundo
deve ser determinada na fase de pintura, que vem após
a fase de layout. Felizmente, Flutter fornece um widget
chamado `Flow`, que é especificamente projetado para dar a você
controle sobre a transformação de um widget filho imediatamente
antes do widget ser pintado. Em outras palavras,
você pode interceptar a fase de pintura e assumir o controle
para reposicionar seus widgets filhos como quiser.

:::note
Para saber mais, confira este curto
vídeo Widget of the Week sobre o widget `Flow`:

<YouTubeEmbed id="NG6pvXpnIso" title="Flow | Flutter widget of the week"></YouTubeEmbed>
:::

:::note
Nos casos em que você precisa de controle sobre o que um filho pinta,
em vez de onde um filho é pintado,
considere usar um widget [`CustomPaint`][`CustomPaint`].

Nos casos em que você precisa de controle sobre o layout,
pintura e teste de hit, considere definir um
[`RenderBox`][`RenderBox`] personalizado.
:::

Envolva seu widget `Image` de fundo com um
widget [`Flow`][`Flow`].

<?code-excerpt "lib/excerpt4.dart (BuildParallaxBackground)" replace="/\n    delegate: ParallaxFlowDelegate\(\),//g"?>
```dart
Widget _buildParallaxBackground(BuildContext context) {
  return Flow(
    children: [Image.network(imageUrl, fit: BoxFit.cover)],
  );
}
```

Introduza um novo `FlowDelegate` chamado `ParallaxFlowDelegate`.

<?code-excerpt "lib/excerpt4.dart (BuildParallaxBackground)"?>
```dart
Widget _buildParallaxBackground(BuildContext context) {
  return Flow(
    delegate: ParallaxFlowDelegate(),
    children: [Image.network(imageUrl, fit: BoxFit.cover)],
  );
}
```

<?code-excerpt "lib/excerpt4.dart (parallax-flow-delegate)" replace="/\n    return constraints;//g"?>
```dart
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate();

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    // TODO: We'll add more to this later.
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // TODO: We'll add more to this later.
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) {
    // TODO: We'll add more to this later.
    return true;
  }
}
```

Um `FlowDelegate` controla como seus filhos são dimensionados
e onde esses filhos são pintados. Neste caso,
seu widget `Flow` tem apenas um filho: a imagem de fundo.
Essa imagem deve ter exatamente a mesma largura que o widget `Flow`.

Retorne constraints de largura tight para seu filho de imagem de fundo.

<?code-excerpt "lib/main.dart (TightWidth)"?>
```dart
@override
BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
  return BoxConstraints.tightFor(width: constraints.maxWidth);
}
```

Suas imagens de fundo agora estão dimensionadas apropriadamente,
mas você ainda precisa calcular a posição vertical
de cada imagem de fundo com base em sua posição
de rolagem, e então pintá-la.

Existem três peças críticas de informação que
você precisa para calcular a posição desejada de uma
imagem de fundo:

* Os limites do ancestral `Scrollable`
* Os limites do item individual da lista
* O tamanho da imagem após ser reduzida
   para caber no item da lista

Para procurar os limites do `Scrollable`,
você passa um `ScrollableState` para seu `FlowDelegate`.

Para procurar os limites do seu item individual da lista,
passe o `BuildContext` do seu item da lista para seu `FlowDelegate`.

Para procurar o tamanho final da sua imagem de fundo,
atribua uma `GlobalKey` ao seu widget `Image`,
e então você passa essa `GlobalKey` para seu
`FlowDelegate`.

Torne essa informação disponível para `ParallaxFlowDelegate`.

<?code-excerpt "lib/excerpt5.dart (global-key)" plaster="none"?>
```dart
@immutable
class LocationListItem extends StatelessWidget {
  final GlobalKey _backgroundImageKey = GlobalKey();

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(imageUrl, key: _backgroundImageKey, fit: BoxFit.cover),
      ],
    );
  }
}
```

<?code-excerpt "lib/excerpt5.dart (parallax-flow-delegate-gk)" plaster="none"?>
```dart
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  });

  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;
}
```

Tendo toda a informação necessária para implementar
rolagem parallax, implemente o método `shouldRepaint()`.

<?code-excerpt "lib/main.dart (ShouldRepaint)"?>
```dart
@override
bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
  return scrollable != oldDelegate.scrollable ||
      listItemContext != oldDelegate.listItemContext ||
      backgroundImageKey != oldDelegate.backgroundImageKey;
}
```

Agora, implemente os cálculos de layout para o efeito parallax.

Primeiro, calcule a posição em pixels de um item da lista
dentro de seu ancestral `Scrollable`.

<?code-excerpt "lib/excerpt5.dart (paint-children)" plaster="none"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // Calculate the position of this list item within the viewport.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
    listItemBox.size.centerLeft(Offset.zero),
    ancestor: scrollableBox,
  );
}
```

Use a posição em pixels do item da lista para calcular sua
porcentagem do topo do `Scrollable`.
Um item da lista no topo da área rolável deve
produzir 0%, e um item da lista na parte inferior da
área rolável deve produzir 100%.

<?code-excerpt "lib/excerpt5.dart (paint-children-2)"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // Calculate the position of this list item within the viewport.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
    listItemBox.size.centerLeft(Offset.zero),
    ancestor: scrollableBox,
  );

  // Determine the percent position of this list item within the
  // scrollable area.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
    0.0,
    1.0,
  );
  // ···
}
```

Use a porcentagem de rolagem para calcular um `Alignment`.
Em 0%, você quer `Alignment(0.0, -1.0)`,
e em 100%, você quer `Alignment(0.0, 1.0)`.
Essas coordenadas correspondem ao alinhamento
superior e inferior, respectivamente.

<?code-excerpt "lib/excerpt5.dart (paint-children-3)" plaster="none"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // Calculate the position of this list item within the viewport.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
    listItemBox.size.centerLeft(Offset.zero),
    ancestor: scrollableBox,
  );

  // Determine the percent position of this list item within the
  // scrollable area.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
    0.0,
    1.0,
  );

  // Calculate the vertical alignment of the background
  // based on the scroll percent.
  final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);
}
```

Use `verticalAlignment`, junto com o tamanho do
item da lista e o tamanho da imagem de fundo,
para produzir um `Rect` que determina onde a
imagem de fundo deve ser posicionada.

<?code-excerpt "lib/excerpt5.dart (paint-children-4)" plaster="none"?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // Calculate the position of this list item within the viewport.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
    listItemBox.size.centerLeft(Offset.zero),
    ancestor: scrollableBox,
  );

  // Determine the percent position of this list item within the
  // scrollable area.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
    0.0,
    1.0,
  );

  // Calculate the vertical alignment of the background
  // based on the scroll percent.
  final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

  // Convert the background alignment into a pixel offset for
  // painting purposes.
  final backgroundSize =
      (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
          .size;
  final listItemSize = context.size;
  final childRect = verticalAlignment.inscribe(
    backgroundSize,
    Offset.zero & listItemSize,
  );
}
```

Usando `childRect`, pinte a imagem de fundo com
a transformação de translação desejada.
É essa transformação ao longo do tempo que dá a você o
efeito parallax.

<?code-excerpt "lib/excerpt5.dart (paint-children-5)" plaster="none" ?>
```dart
@override
void paintChildren(FlowPaintingContext context) {
  // Calculate the position of this list item within the viewport.
  final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
  final listItemBox = listItemContext.findRenderObject() as RenderBox;
  final listItemOffset = listItemBox.localToGlobal(
    listItemBox.size.centerLeft(Offset.zero),
    ancestor: scrollableBox,
  );

  // Determine the percent position of this list item within the
  // scrollable area.
  final viewportDimension = scrollable.position.viewportDimension;
  final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
    0.0,
    1.0,
  );

  // Calculate the vertical alignment of the background
  // based on the scroll percent.
  final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

  // Convert the background alignment into a pixel offset for
  // painting purposes.
  final backgroundSize =
      (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
          .size;
  final listItemSize = context.size;
  final childRect = verticalAlignment.inscribe(
    backgroundSize,
    Offset.zero & listItemSize,
  );

  // Paint the background.
  context.paintChild(
    0,
    transform: Transform.translate(
      offset: Offset(0.0, childRect.top),
    ).transform,
  );
}
```

Você precisa de um detalhe final para alcançar o efeito parallax.
O `ParallaxFlowDelegate` repinta quando as entradas mudam,
mas o `ParallaxFlowDelegate` não repinta toda vez que
a posição de rolagem muda.

Passe o `ScrollPosition` do `ScrollableState` para
a superclasse `FlowDelegate` para que o `FlowDelegate`
repinte toda vez que o `ScrollPosition` muda.

<?code-excerpt "lib/main.dart (SuperScrollPosition)" replace="/;\n/;\n}/g"?>
```dart
class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);
}
```

Parabéns!
Agora você tem uma lista de cards com parallax,
rolando imagens de fundo.

## Exemplo interativo

Execute o app:

* Role para cima e para baixo para observar o efeito parallax.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter parallax scrolling hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Color darkBlue = Color.fromARGB(255, 18, 32, 47);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: darkBlue),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(body: Center(child: ExampleParallax())),
    );
  }
}

class ExampleParallax extends StatelessWidget {
  const ExampleParallax({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final location in locations)
            LocationListItem(
              imageUrl: location.imageUrl,
              name: location.name,
              country: location.place,
            ),
        ],
      ),
    );
  }
}

class LocationListItem extends StatelessWidget {
  LocationListItem({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.country,
  });

  final String imageUrl;
  final String name;
  final String country;
  final GlobalKey _backgroundImageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildParallaxBackground(context),
              _buildGradient(),
              _buildTitleAndSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParallaxBackground(BuildContext context) {
    return Flow(
      delegate: ParallaxFlowDelegate(
        scrollable: Scrollable.of(context),
        listItemContext: context,
        backgroundImageKey: _backgroundImageKey,
      ),
      children: [
        Image.network(imageUrl, key: _backgroundImageKey, fit: BoxFit.cover),
      ],
    );
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            country,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class ParallaxFlowDelegate extends FlowDelegate {
  ParallaxFlowDelegate({
    required this.scrollable,
    required this.listItemContext,
    required this.backgroundImageKey,
  }) : super(repaint: scrollable.position);


  final ScrollableState scrollable;
  final BuildContext listItemContext;
  final GlobalKey backgroundImageKey;

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    return BoxConstraints.tightFor(width: constraints.maxWidth);
  }

  @override
  void paintChildren(FlowPaintingContext context) {
    // Calculate the position of this list item within the viewport.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final listItemBox = listItemContext.findRenderObject() as RenderBox;
    final listItemOffset = listItemBox.localToGlobal(
      listItemBox.size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    // Determine the percent position of this list item within the
    // scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;
    final scrollFraction = (listItemOffset.dy / viewportDimension).clamp(
      0.0,
      1.0,
    );

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final backgroundSize =
        (backgroundImageKey.currentContext!.findRenderObject() as RenderBox)
            .size;
    final listItemSize = context.size;
    final childRect = verticalAlignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    // Paint the background.
    context.paintChild(
      0,
      transform: Transform.translate(
        offset: Offset(0.0, childRect.top),
      ).transform,
    );
  }

  @override
  bool shouldRepaint(ParallaxFlowDelegate oldDelegate) {
    return scrollable != oldDelegate.scrollable ||
        listItemContext != oldDelegate.listItemContext ||
        backgroundImageKey != oldDelegate.backgroundImageKey;
  }

}

class Parallax extends SingleChildRenderObjectWidget {
  const Parallax({super.key, required Widget background})
    : super(child: background);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderParallax(scrollable: Scrollable.of(context));
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderParallax renderObject,
  ) {
    renderObject.scrollable = Scrollable.of(context);
  }
}

class ParallaxParentData extends ContainerBoxParentData<RenderBox> {}

class RenderParallax extends RenderBox
    with RenderObjectWithChildMixin<RenderBox>, RenderProxyBoxMixin {
  RenderParallax({required ScrollableState scrollable})
    : _scrollable = scrollable;

  ScrollableState _scrollable;

  ScrollableState get scrollable => _scrollable;

  set scrollable(ScrollableState value) {
    if (value != _scrollable) {
      if (attached) {
        _scrollable.position.removeListener(markNeedsLayout);
      }
      _scrollable = value;
      if (attached) {
        _scrollable.position.addListener(markNeedsLayout);
      }
    }
  }

  @override
  void attach(covariant PipelineOwner owner) {
    super.attach(owner);
    _scrollable.position.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollable.position.removeListener(markNeedsLayout);
    super.detach();
  }

  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! ParallaxParentData) {
      child.parentData = ParallaxParentData();
    }
  }

  @override
  void performLayout() {
    size = constraints.biggest;

    // Force the background to take up all available width
    // and then scale its height based on the image's aspect ratio.
    final background = child!;
    final backgroundImageConstraints = BoxConstraints.tightFor(
      width: size.width,
    );
    background.layout(backgroundImageConstraints, parentUsesSize: true);

    // Set the background's local offset, which is zero.
    (background.parentData as ParallaxParentData).offset = Offset.zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Get the size of the scrollable area.
    final viewportDimension = scrollable.position.viewportDimension;

    // Calculate the global position of this list item.
    final scrollableBox = scrollable.context.findRenderObject() as RenderBox;
    final backgroundOffset = localToGlobal(
      size.centerLeft(Offset.zero),
      ancestor: scrollableBox,
    );

    // Determine the percent position of this list item within the
    // scrollable area.
    final scrollFraction = (backgroundOffset.dy / viewportDimension).clamp(
      0.0,
      1.0,
    );

    // Calculate the vertical alignment of the background
    // based on the scroll percent.
    final verticalAlignment = Alignment(0.0, scrollFraction * 2 - 1);

    // Convert the background alignment into a pixel offset for
    // painting purposes.
    final background = child!;
    final backgroundSize = background.size;
    final listItemSize = size;
    final childRect = verticalAlignment.inscribe(
      backgroundSize,
      Offset.zero & listItemSize,
    );

    // Paint the background.
    context.paintChild(
      background,
      (background.parentData as ParallaxParentData).offset +
          offset +
          Offset(0.0, childRect.top),
    );
  }
}

class Location {
  const Location({
    required this.name,
    required this.place,
    required this.imageUrl,
  });

  final String name;
  final String place;
  final String imageUrl;
}

const urlPrefix =
    'https://docs.flutterbrasil.dev/assets/images/exercise/effects/parallax';

const locations = [
  Location(
    name: 'Mount Rushmore',
    place: 'U.S.A',
    imageUrl: '$urlPrefix/01-mount-rushmore.jpg',
  ),
  Location(
    name: 'Gardens By The Bay',
    place: 'Singapore',
    imageUrl: '$urlPrefix/02-singapore.jpg',
  ),
  Location(
    name: 'Machu Picchu',
    place: 'Peru',
    imageUrl: '$urlPrefix/03-machu-picchu.jpg',
  ),
  Location(
    name: 'Vitznau',
    place: 'Switzerland',
    imageUrl: '$urlPrefix/04-vitznau.jpg',
  ),
  Location(
    name: 'Bali',
    place: 'Indonesia',
    imageUrl: '$urlPrefix/05-bali.jpg',
  ),
  Location(
    name: 'Mexico City',
    place: 'Mexico',
    imageUrl: '$urlPrefix/06-mexico-city.jpg',
  ),
  Location(name: 'Cairo', place: 'Egypt', imageUrl: '$urlPrefix/07-cairo.jpg'),
];
```

[`CustomPaint`]: {{site.api}}/flutter/widgets/CustomPaint-class.html
[`Flow`]: {{site.api}}/flutter/widgets/Flow-class.html
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
