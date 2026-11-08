---
ia-translate: true
title: Animações hero
description: Como animar um widget para voar entre duas telas.
shortTitle: Hero
---

:::secondary O que você aprenderá
* O _hero_ se refere ao widget que voa entre telas.
* Criar uma animação hero usando o widget `Hero` do Flutter.
* Voar o hero de uma tela para outra.
* Animar a transformação da forma de um hero de circular para
  retangular enquanto o voa de uma tela para outra.
* O widget `Hero` no Flutter implementa um estilo de animação
  comumente conhecido como _transições de elementos compartilhados_ ou
  _animações de elementos compartilhados_.
:::

Você provavelmente já viu animações hero muitas vezes. Por exemplo, uma tela exibe
uma lista de miniaturas representando itens à venda. Selecionar um item o voa para
uma nova tela, contendo mais detalhes e um botão **Buy**. Voar uma imagem de
uma tela para outra é chamado de _animação hero_ no Flutter, embora o mesmo
movimento seja às vezes referido como uma _transição de elemento compartilhado_.

Você pode querer assistir este vídeo de um minuto introduzindo o widget `Hero`:

<YouTubeEmbed id="Be9UH1kXFDw" title="Hero | Flutter widget of the week"></YouTubeEmbed>

Este guia demonstra como construir animações hero padrão, e animações
hero que transformam a imagem de uma forma circular para uma forma quadrada
durante o voo.

:::secondary Exemplos
Este guia percorre exemplos de cada estilo de animação hero:

* [Animações hero padrão](#standard-hero-animations)
* [Animações hero radiais](#radial-hero-animations)

Se você quiser executar os exemplos por conta própria,
siga os passos em [Execute os exemplos](#run-the-examples).
:::

:::secondary Novo no Flutter?
Esta página assume que você sabe como criar um layout
usando os widgets do Flutter. Para saber mais, visite
[Construindo Layouts no Flutter][Building Layouts in Flutter].
:::

:::tip Terminologia
Uma [_Route_][_Route_] descreve uma página ou tela em um app Flutter.
:::

## Estilos de animação hero {:#hero-animation-styles}

Você pode criar animações hero no Flutter com widgets `Hero`.
Enquanto o hero anima da rota de origem para a rota de destino,
a rota de destino (menos o hero) aparece gradualmente.
Normalmente, heroes são pequenas partes da UI, como imagens,
que ambas as rotas têm em comum. Da perspectiva do usuário,
o hero "voa" entre as rotas. Este guia mostra como
criar as seguintes animações hero:

### Animações padrão {:#standard-hero-animation-preview}

Uma _animação hero padrão_ voa o hero de uma rota para uma nova rota,
geralmente pousando em uma localização diferente e com um tamanho diferente.

O vídeo a seguir (gravado em velocidade lenta) mostra um exemplo típico.
Tocar nos flippers no centro da rota os voa para o
canto superior esquerdo de uma nova rota azul, em um tamanho menor.
Tocar nos flippers na rota azul (ou usar o gesto
voltar-para-rota-anterior do dispositivo) voa os flippers de volta para
a rota original.

<YouTubeEmbed id="CEcFnqRDfgw" title="Standard hero animation in Flutter"></YouTubeEmbed>

### Animações radiais {:#radial-hero-animation-preview}

Em uma _animação hero radial_, enquanto o hero voa entre rotas
sua forma parece mudar de circular para retangular.

O vídeo a seguir (gravado em velocidade lenta),
mostra um exemplo de uma animação hero radial. No início, uma
linha de três imagens circulares aparece na parte inferior da rota.
Tocar em qualquer uma das imagens circulares voa essa imagem para uma nova rota
que a exibe com uma forma quadrada.
Tocar na imagem quadrada voa o hero de volta para
a rota original, exibida com uma forma circular.

<YouTubeEmbed id="LWKENpwDKiM" title="Radial hero animation in Flutter"></YouTubeEmbed>

Antes de passar para as seções específicas de
[padrão](#standard-hero-animations)
ou [radial](#radial-hero-animations) animações hero,
leia [estrutura básica de uma animação hero](#basic-structure)
para aprender como estruturar código de animação hero,
e [por trás das cenas](#behind-the-scenes) para entender
como o Flutter executa uma animação hero.

<a id="basic-structure"></a>

## Basic structure of a hero animation

:::secondary Qual é o ponto?
* Use dois widgets hero em rotas diferentes mas com tags correspondentes para
  implementar a animação.
* O `Navigator` gerencia uma pilha contendo as rotas do app.
* Empurrar uma rota ou remover uma rota da pilha do `Navigator`
  dispara a animação.
* O framework Flutter calcula um rectangle tween,
  [`RectTween`][`RectTween`], que define os limites do hero
  enquanto voa da rota de origem para a rota de destino.
  Durante seu voo, o hero é movido para
  um overlay de aplicação, para que apareça no topo de ambas as rotas.
:::

:::tip Terminologia
Se o conceito de tweens ou tweening é novo para você,
visite o [tutorial de Animações no Flutter][Animations in Flutter tutorial].
:::

Animações hero são implementadas usando dois widgets [`Hero`][`Hero`]:
um descrevendo o widget na rota de origem,
e outro descrevendo o widget na rota de destino.
Do ponto de vista do usuário, o hero parece ser compartilhado, e
apenas o programador precisa entender este detalhe de implementação.
O código de animação hero tem a seguinte estrutura:

1. Defina um widget `Hero` inicial, referido como o _hero
   de origem_. O hero especifica sua representação gráfica
   (tipicamente uma imagem), e uma tag de identificação, e está na
   árvore de widgets atualmente exibida conforme definido pela rota de origem.
1. Defina um widget `Hero` final, referido como o _hero de destino_.
   Este hero também especifica sua representação gráfica,
   e a mesma tag que o hero de origem.
   É **essencial que ambos os widgets hero sejam criados com
   a mesma tag**, tipicamente um objeto que representa os
   dados subjacentes. Para melhores resultados, os heroes devem ter
   árvores de widgets virtualmente idênticas.
1. Crie uma rota que contém o hero de destino.
   A rota de destino define a árvore de widgets que existe
   ao final da animação.
1. Dispare a animação empurrando
   a rota de destino na pilha do `Navigator`.
   As operações push e pop do `Navigator` disparam
   uma animação hero para cada par de heroes com tags correspondentes nas
   rotas de origem e destino.

O Flutter calcula o tween que anima os limites do widget `Hero` do
ponto inicial ao ponto final (interpolando tamanho e posição),
e executa a animação em um overlay.

A próxima seção descreve o processo do Flutter em maior detalhe.

## Behind the scenes

O seguinte descreve como o Flutter executa a
transição de uma rota para outra.

![Before the transition the source hero appears in the source route](/assets/images/docs/ui/animations/hero-transition-0.png)

Antes da transição, o hero de origem espera na
árvore de widgets da rota de origem. A rota de destino ainda não existe,
e o overlay está vazio.

---

![The transition begins](/assets/images/docs/ui/animations/hero-transition-1.png)

Empurrar uma rota para o `Navigator` dispara a animação.
Em `t=0.0`, o Flutter faz o seguinte:

* Calcula o caminho do hero de destino, fora da tela,
  usando o movimento curvo conforme descrito na especificação de
  motion do Material. O Flutter agora sabe onde o hero termina.

* Coloca o hero de destino no overlay,
  na mesma localização e tamanho que o hero de _origem_.
  Adicionar um hero ao overlay muda sua ordem Z de forma que apareça
  no topo de todas as rotas.

* Move o hero de origem para fora da tela.

---

![The hero flies in the overlay to its final position and size](/assets/images/docs/ui/animations/hero-transition-2.png)

Enquanto o hero voa, seus limites retangulares são animados usando [`Tween<Rect>`][],
especificado pela propriedade [`createRectTween`][`createRectTween`] do widget `Hero`.
Por padrão, o Flutter usa uma instância de
[`MaterialRectArcTween`][`MaterialRectArcTween`], que anima os
cantos opostos do retângulo ao longo de um caminho curvo.
(Consulte [Animações hero radiais][Radial hero animations] para um exemplo
que usa uma animação `Tween` diferente.)

---

![When the transition is complete, the hero is moved from the overlay to the destination route](/assets/images/docs/ui/animations/hero-transition-3.png)

Quando o voo completa:

* O Flutter move o widget hero do overlay para
  a rota de destino. O overlay está agora vazio.

* O hero de destino aparece em sua posição final
  na rota de destino.

* O hero de origem é restaurado para sua rota.

---

Remover a rota executa o mesmo processo,
animando o hero de volta para seu tamanho
e localização na rota de origem.

### Essential classes

Os exemplos neste guia usam as seguintes classes para
implementar animações hero:

[`Hero`][`Hero`]
: O widget que voa da rota de origem para a rota de destino.
  Defina um `Hero` para a rota de origem e outro para a
  rota de destino, e atribua a cada um a mesma tag.
  O Flutter anima pares de heroes com tags correspondentes.

[`InkWell`][`InkWell`]
: Especifica o que acontece ao tocar no hero.
  O callback `onTap()` do widget `InkWell` constrói a
  nova rota e a empurra para a pilha do `Navigator`.

[`Navigator`][`Navigator`]
: O `Navigator` gerencia uma pilha de rotas.
  Empurrar uma rota ou remover uma rota da pilha do `Navigator`
  dispara a animação.

[`Route`][`Route`]
: Especifica uma tela ou página. A maioria dos apps,
  além dos mais básicos, tem múltiplas rotas.

## Standard hero animations

:::secondary Qual é o ponto?
* Especifique uma rota usando [`MaterialPageRoute`][], [`CupertinoPageRoute`][],
  ou construa uma rota customizada usando [`PageRouteBuilder`][].
  Os exemplos nesta seção usam `MaterialPageRoute`.
* Mude o tamanho da imagem ao final da transição
  envolvendo a imagem de destino em um `SizedBox`.
* Mude a localização da imagem colocando a imagem de destino
  em um widget de layout. Estes exemplos usam `Container`.
:::

<a id="standard-hero-animation-code"></a>

### What's going on?

Voar uma imagem de uma rota para outra é simples de implementar
usando o widget `Hero` do Flutter. Ao usar `MaterialPageRoute`
para especificar a nova rota, a imagem voa ao longo de um caminho curvo,
conforme descrito pela [especificação de motion do Material Design][Material Design motion spec].

O código completo e as imagens desta seção estão no
[exemplo de animação hero padrão][standard hero animation example].
Para explorar a animação por conta própria,
[configure e execute o exemplo](#run-the-examples)
e então experimente o seguinte:

* Toque na foto da rota inicial para voar a imagem para uma nova rota
  mostrando a mesma foto em uma localização e escala diferentes.
* Retorne à rota anterior tocando na imagem, ou usando o
  gesto voltar-para-rota-anterior do dispositivo.
* Desacelere ainda mais a transição aumentando o valor de [`timeDilation`][].

### PhotoHero class

A classe customizada `PhotoHero` mantém o hero,
e seu tamanho, imagem e comportamento quando tocado.
O `PhotoHero` constrói a seguinte árvore de widgets:

<DashImage figure image="ui/animations/photohero-class.png" alt="PhotoHero class widget tree" />

Aqui está o código:

<?code-excerpt "animation/hero_animation/lib/main.dart (photo-hero)"?>
```dart
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:material_ui/material_ui.dart';

class PhotoHero extends StatelessWidget {
  const PhotoHero({
    super.key,
    required this.photo,
    this.onTap,
    required this.width,
  });

  final String photo;
  final VoidCallback? onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Hero(
        tag: photo,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Image.asset(photo, fit: BoxFit.contain),
          ),
        ),
      ),
    );
  }
}
```

Informações-chave:

* A rota inicial é implicitamente empurrada pelo `MaterialApp` quando
  `HeroAnimation` é fornecido como a propriedade `home` do app.
* Um `InkWell` envolve a imagem, tornando fácil adicionar um
  gesto de toque aos heroes de origem e destino.
* Definir o widget `Material` com uma cor transparente
  permite que a imagem "salte" do fundo enquanto
  voa para seu destino.
* O `SizedBox` especifica o tamanho do hero no início e
  fim da animação.
* Definir a propriedade `fit` do widget `Image` como `BoxFit.contain`
  garante que a imagem seja tão grande quanto possível durante a
  transição sem mudar sua proporção de aspecto.

### HeroAnimation class

A classe `HeroAnimation` cria os widgets `PhotoHero` de origem e destino,
e configura a transição.

Aqui está o código:

<?code-excerpt "animation/hero_animation/lib/main.dart (hero-animation)"?>
```dart highlightLines=9,12-15,23,26-27,43
class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Hero Animation')),
      body: Center(
        child: PhotoHero(
          photo: 'images/flippers.png',
          width: 300,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) {
                  return Scaffold(
                    appBar: AppBar(title: const Text('Flippers Page')),
                    body: Container(
                      // Set background to blue to emphasize that it's a new route.
                      color: Colors.lightBlueAccent,
                      padding: const EdgeInsets.all(16),
                      alignment: Alignment.topLeft,
                      child: PhotoHero(
                        photo: 'images/flippers.png',
                        width: 100,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

void main() {
  timeDilation = 5; // 1 means normal animation speed.
  runApp(const MaterialApp(home: HeroAnimation()));
}
```

Informações-chave:

* Quando o usuário toca no `InkWell` contendo o hero de origem,
  o código cria a rota de destino usando `MaterialPageRoute`.
  Empurrar a rota de destino para a pilha do `Navigator` dispara
  a animação.
* O `Container` posiciona o `PhotoHero` no
  canto superior esquerdo da rota de destino, abaixo do `AppBar`.
* O método `onTap()` para o `PhotoHero` de destino
  remove da pilha do `Navigator`, disparando a animação
  que voa o `Hero` de volta para a rota original.
* Use a propriedade `timeDilation` para desacelerar a transição
  durante a depuração.

---

## Radial hero animations

:::secondary Qual é o ponto?
* Uma _transformação radial_ anima uma forma circular em uma forma
  quadrada.
* Uma animação _hero_ radial executa uma transformação radial enquanto
  voa o hero da rota de origem para a rota de destino.
* `MaterialRectCenterArcTween` define a animação tween.
* Construa a rota de destino usando `PageRouteBuilder`.
:::

Voar um hero de uma rota para outra enquanto se transforma
de uma forma circular para uma forma retangular é um efeito
visual que você pode implementar usando widgets `Hero`.
Para realizar isso, o código anima a interseção de
duas formas de recorte: um círculo e um quadrado.
Ao longo da animação, o recorte circular (e a imagem)
escala de `minRadius` para `maxRadius`, enquanto o
recorte quadrado mantém tamanho constante. Ao mesmo tempo,
a imagem voa de sua posição na rota de origem para sua
posição na rota de destino. Para exemplos visuais
desta transição, consulte [Transformação radial][Radial transformation]
na especificação de motion do Material.
<a id="radial-hero-animation-code"></a>

:::tip Dica profissional
A animação hero radial envolve interseccionar uma forma redonda com
uma forma quadrada. Isso pode ser difícil de ver, mesmo ao desacelerar
a animação com `timeDilation`, então você pode considerar habilitar
a flag [`debugPaintSizeEnabled`][`debugPaintSizeEnabled`] durante o desenvolvimento.
:::

### What's going on?

O diagrama a seguir mostra a imagem recortada no início
(`t = 0.0`), e no fim (`t = 1.0`) da animação.

![Radial transformation from beginning to end](/assets/images/docs/ui/animations/radial-hero-animation.png)

O gradiente azul (representando a imagem), indica onde as formas de recorte
se interseccionam. No início da transição,
o resultado da interseção é um recorte circular ([`ClipOval`][`ClipOval`]).
Durante a transformação, o `ClipOval` escala de `minRadius`
para `maxRadius` enquanto o [`ClipRect`][] mantém um tamanho constante.
No fim da transição a interseção dos recortes circular e
retangular produz um retângulo que tem o mesmo tamanho que o widget
hero. Em outras palavras, no fim da transição a imagem não está
mais recortada.

O código completo e as imagens desta seção,
incluindo a configuração de rotas que não é mostrada nesta página,
estão no [exemplo de animação hero radial][radial hero animation example].
Para explorar a animação por conta própria,
[configure e execute o exemplo](#run-the-examples)
e então experimente o seguinte:

* Toque em uma das três miniaturas circulares para animar a imagem
  para um quadrado maior posicionado no meio de uma nova rota que
  obscurece a rota original.
* Retorne à rota anterior tocando na imagem, ou usando o
  gesto voltar-para-rota-anterior do dispositivo.
* Desacelere ainda mais a transição aumentando o valor de [`timeDilation`][].

### Photo class

A classe `Photo` constrói a árvore de widgets que mantém a imagem:

<?code-excerpt "animation/radial_hero_animation/lib/main.dart (photo)"?>
```dart highlightLines=9,11-14
class Photo extends StatelessWidget {
  const Photo({super.key, required this.photo, this.onTap});

  final String photo;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      // Slightly opaque color appears where the image has transparency.
      color: Theme.of(context).primaryColor.withValues(alpha: 0.25),
      child: InkWell(
        onTap: onTap,
        child: Image.asset(photo, fit: BoxFit.contain),
      ),
    );
  }
}
```

Informações-chave:

* O `InkWell` captura o gesto de toque.
  A função chamadora passa a função `onTap()` para
  o construtor de `Photo`.
* Durante o voo, o `InkWell` desenha seu splash no seu primeiro
  ancestral `Material`.
* O widget `Material` tem uma cor levemente opaca, então as
  porções transparentes da imagem são renderizadas com cor.
  Isso garante que a transição círculo-para-quadrado seja fácil de ver,
  mesmo para imagens com transparência.
* A classe `Photo` não inclui o `Hero` em sua árvore de widgets.
  Para a animação funcionar, o hero
  envolve o widget `RadialExpansion`.

### RadialExpansion class

O widget `RadialExpansion`, o núcleo da demo, constrói a
árvore de widgets que recorta a imagem durante a transição.
A forma recortada resulta da interseção de um recorte circular
(que cresce durante o voo),
com um recorte retangular (que permanece com tamanho constante ao longo).

Para fazer isso, ele constrói a seguinte árvore de widgets:

<DashImage figure image="ui/animations/radial-expansion-class.png" alt="RadialExpansion widget tree" />

Aqui está o código:

<?code-excerpt "animation/radial_hero_animation/lib/main.dart (radial-expansion)"?>
```dart highlightLines=3,11-13,16-17
class RadialExpansion extends StatelessWidget {
  const RadialExpansion({super.key, required this.maxRadius, this.child})
    : clipRectSize = 2 * (maxRadius / math.sqrt2);

  final double maxRadius;
  final double clipRectSize;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Center(
        child: SizedBox(
          width: clipRectSize,
          height: clipRectSize,
          child: ClipRect(
            child: child, // Photo
          ),
        ),
      ),
    );
  }
}
```

Informações-chave:

* O hero envolve o widget `RadialExpansion`.
* Enquanto o hero voa, seu tamanho muda e,
  porque restringe o tamanho de seu filho,
  o widget `RadialExpansion` muda de tamanho para corresponder.
* A animação `RadialExpansion` é criada por dois recortes sobrepostos.
* O exemplo define a interpolação tweening usando
  [`MaterialRectCenterArcTween`][`MaterialRectCenterArcTween`].
  O caminho de voo padrão para uma animação hero
  interpola os tweens usando os cantos dos heroes.
  Esta abordagem afeta a proporção de aspecto do hero durante
  a transformação radial, então o novo caminho de voo usa
  `MaterialRectCenterArcTween` para interpolar os tweens usando o
  ponto central de cada hero.

  Aqui está o código:

  <?code-excerpt "animation/radial_hero_animation/lib/main.dart (create-rect-tween)"?>
  ```dart
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
  ```

  O caminho de voo do hero ainda segue um arco,
  mas a proporção de aspecto da imagem permanece constante.

---

## Execute os exemplos {:#run-the-examples}

Cada exemplo neste guia é um app completo:
o [exemplo de animação hero padrão][standard hero animation example] e
o [exemplo de animação hero radial][radial hero animation example].
Para executar os exemplos por conta própria:

1.  [Crie um novo app Flutter][Create a new Flutter app].
1.  Adicione o pacote [`material_ui`][] como dependência
    executando `flutter pub add material_ui`.
1.  Substitua `lib/main.dart` pelo arquivo `lib/main.dart` do exemplo.
1.  Baixe as seguintes imagens para um diretório `images`
    na raiz do seu projeto:
    [`beachball.png`][], [`binoculars.png`][],
    [`chair.png`][] e [`flippers.png`][].
1.  Declare as imagens como [assets][asset declarations]
    adicionando uma entrada `assets` à seção `flutter` existente
    do arquivo `pubspec.yaml` do projeto:

    ```yaml title="pubspec.yaml" highlightLines=3-4
    flutter:
      uses-material-design: true
      assets:
        - images/
    ```
1.  Execute o app com `flutter run`.

[Animations in Flutter tutorial]: /ui/animations/tutorial
[asset declarations]: /ui/assets/assets-and-images#specifying-assets
[`beachball.png`]: https://raw.githubusercontent.com/flutter/website/main/examples/animation/radial_hero_animation/images/beachball.png
[`binoculars.png`]: https://raw.githubusercontent.com/flutter/website/main/examples/animation/radial_hero_animation/images/binoculars.png
[Building Layouts in Flutter]: /ui/layout
[`chair.png`]: https://raw.githubusercontent.com/flutter/website/main/examples/animation/radial_hero_animation/images/chair.png
[`ClipOval`]: {{site.api}}/flutter/widgets/ClipOval-class.html
[`ClipRect`]: {{site.api}}/flutter/widgets/ClipRect-class.html
[Create a new Flutter app]: /reference/create-new-app
[`createRectTween`]: {{site.api}}/flutter/widgets/CreateRectTween.html
[`CupertinoPageRoute`]: {{site.cupertino_ui}}/CupertinoPageRoute-class.html
[`debugPaintSizeEnabled`]: /tools/devtools/inspector#debugging-layout-issues-visually
[`flippers.png`]: https://raw.githubusercontent.com/flutter/website/main/examples/animation/hero_animation/images/flippers.png
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[`InkWell`]: {{site.material_ui}}/InkWell-class.html
[Material Design motion spec]: {{site.material2}}/design/motion/understanding-motion.html#principles
[`material_ui`]: {{site.pub-pkg}}/material_ui
[`MaterialPageRoute`]: {{site.material_ui}}/MaterialPageRoute-class.html
[`MaterialRectArcTween`]: {{site.material_ui}}/MaterialRectArcTween-class.html
[`MaterialRectCenterArcTween`]: {{site.material_ui}}/MaterialRectCenterArcTween-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PageRouteBuilder`]: {{site.api}}/flutter/widgets/PageRouteBuilder-class.html
[Radial hero animations]: #radial-hero-animations
[radial hero animation example]: {{site.repo.this}}/tree/main/examples/animation/radial_hero_animation
[Radial transformation]: https://web.archive.org/web/20180223140424/https://material.io/guidelines/motion/transforming-material.html
[`RectTween`]: {{site.api}}/flutter/animation/RectTween-class.html
[_Route_]: /cookbook/navigation/navigation-basics
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[standard hero animation example]: {{site.repo.this}}/tree/main/examples/animation/hero_animation
[`timeDilation`]: {{site.api}}/flutter/scheduler/timeDilation.html
[`Tween<Rect>`]: {{site.api}}/flutter/animation/Tween-class.html
