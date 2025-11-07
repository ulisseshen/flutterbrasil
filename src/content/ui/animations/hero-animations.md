---
title: Hero animations
description: Como animar um widget para voar entre duas telas.
short-title: Hero
ia-translate: true
---

:::secondary O que você aprenderá
* O _hero_ refere-se ao widget que voa entre telas.
* Criar uma hero animation usando o widget Hero do Flutter.
* Fazer o hero voar de uma tela para outra.
* Animar a transformação da forma de um hero de circular para
    retangular enquanto ele voa de uma tela para outra.
* O widget Hero no Flutter implementa um estilo de animação
    comumente conhecido como _shared element transitions_ ou
    _shared element animations._
:::

Você provavelmente já viu hero animations muitas vezes. Por exemplo, uma tela exibe
uma lista de miniaturas representando itens à venda. Selecionar um item o faz voar para
uma nova tela, contendo mais detalhes e um botão "Comprar". Fazer uma imagem voar de
uma tela para outra é chamado de _hero animation_ no Flutter, embora o mesmo
movimento às vezes seja referido como _shared element transition_.

Você pode querer assistir a este vídeo de um minuto apresentando o widget Hero:

{% ytEmbed 'Be9UH1kXFDw', 'Hero | Flutter widget of the week' %}

Este guia demonstra como construir hero animations padrão, e hero
animations que transformam a imagem de uma forma circular para uma forma quadrada
durante o voo.

:::secondary Exemplos
Este guia fornece exemplos de cada estilo de hero animation nos
seguintes links.

* [Standard hero animation code][]
* [Radial hero animation code][]
::

:::secondary Novo no Flutter?
Esta página assume que você sabe como criar um layout
usando widgets do Flutter. Para mais informações, consulte
[Building Layouts in Flutter][].
:::

:::tip Terminologia
  Uma [_Route_][] descreve uma página ou tela em um aplicativo Flutter.
:::

Você pode criar essa animação no Flutter com widgets Hero.
À medida que o hero anima da rota de origem para a rota de destino,
a rota de destino (menos o hero) desaparece na visualização.
Normalmente, os heroes são pequenas partes da UI, como imagens,
que ambas as rotas têm em comum. Da perspectiva do usuário,
o hero "voa" entre as rotas. Este guia mostra como
criar as seguintes hero animations:

**Standard hero animations**<br>

Uma _standard hero animation_ faz o hero voar de uma rota para uma nova rota,
geralmente pousando em uma localização diferente e com um tamanho diferente.

O vídeo a seguir (gravado em velocidade lenta) mostra um exemplo típico.
Tocar nas nadadeiras no centro da rota as faz voar para o
canto superior esquerdo de uma nova rota azul, em um tamanho menor.
Tocar nas nadadeiras na rota azul (ou usar o gesto
de voltar para a rota anterior do dispositivo) faz as nadadeiras voltarem para
a rota original.

{% ytEmbed 'CEcFnqRDfgw', 'Standard hero animation in Flutter' %}

**Radial hero animations**<br>

Em _radial hero animation_, à medida que o hero voa entre rotas,
sua forma parece mudar de circular para retangular.

O vídeo a seguir (gravado em velocidade lenta),
mostra um exemplo de uma radial hero animation. No início, uma
linha de três imagens circulares aparece na parte inferior da rota.
Tocar em qualquer uma das imagens circulares faz essa imagem voar para uma nova rota
que a exibe com uma forma quadrada.
Tocar na imagem quadrada faz o hero voltar para
a rota original, exibido com uma forma circular.

{% ytEmbed 'LWKENpwDKiM', 'Radial hero animation in Flutter' %}

Antes de passar para as seções específicas para
[standard](#standard-hero-animations)
ou [radial](#radial-hero-animations) hero animations,
leia [estrutura básica de uma hero animation](#basic-structure)
para aprender como estruturar o código de hero animation,
e [behind the scenes](#behind-the-scenes) para entender
como o Flutter executa uma hero animation.

<a id="basic-structure"></a>

## Estrutura básica de uma hero animation

:::secondary Qual é o ponto?
* Use dois hero widgets em rotas diferentes, mas com tags correspondentes, para
    implementar a animação.
* O Navigator gerencia uma pilha contendo as rotas do aplicativo.
* Fazer push de uma rota ou fazer pop de uma rota da pilha do Navigator
    aciona a animação.
* O framework Flutter calcula um rectangle tween,
    [`RectTween`][] que define o limite do hero
    à medida que ele voa da rota de origem para a rota de destino.
    Durante seu voo, o hero é movido para
    um overlay de aplicativo, para que apareça sobre ambas as rotas.
:::

:::tip Terminologia
Se o conceito de tweens ou tweening é novo para você,
confira o [Animations in Flutter tutorial][].
:::

Hero animations são implementadas usando dois widgets [`Hero`][]:
um descrevendo o widget na rota de origem,
e outro descrevendo o widget na rota de destino.
Do ponto de vista do usuário, o hero parece ser compartilhado, e
apenas o programador precisa entender esse detalhe de implementação.
O código de hero animation tem a seguinte estrutura:

1. Defina um widget Hero inicial, referido como o _source
   hero_. O hero especifica sua representação gráfica
   (normalmente uma imagem), e uma tag de identificação, e está na
   árvore de widgets atualmente exibida conforme definido pela rota de origem.
1. Defina um widget Hero final, referido como o _destination hero_.
   Este hero também especifica sua representação gráfica,
   e a mesma tag que o source hero.
   É **essencial que ambos os hero widgets sejam criados com
   a mesma tag**, normalmente um objeto que representa os
   dados subjacentes. Para melhores resultados, os heroes devem ter
   árvores de widgets virtualmente idênticas.
1. Crie uma rota que contenha o destination hero.
   A rota de destino define a árvore de widgets que existe
   no final da animação.
1. Acione a animação fazendo push da rota de destino na
   pilha do Navigator. As operações de push e pop do Navigator acionam
   uma hero animation para cada par de heroes com tags correspondentes nas
   rotas de origem e destino.

O Flutter calcula o tween que anima os limites do Hero do
ponto inicial ao ponto final (interpolando tamanho e posição),
e executa a animação em um overlay.

A próxima seção descreve o processo do Flutter em maior detalhe.

## Behind the scenes

O seguinte descreve como o Flutter executa a
transição de uma rota para outra.

![Before the transition the source hero appears in the source route](/assets/images/docs/ui/animations/hero-transition-0.png)

Antes da transição, o source hero aguarda na
árvore de widgets da rota de origem. A rota de destino ainda não existe,
e o overlay está vazio.

---

![The transition begins](/assets/images/docs/ui/animations/hero-transition-1.png)

Fazer push de uma rota para o `Navigator` aciona a animação.
Em `t=0.0`, o Flutter faz o seguinte:

* Calcula o caminho do destination hero, fora da tela,
  usando o curved motion conforme descrito na
  especificação de motion do Material. O Flutter agora sabe onde o hero termina.

* Coloca o destination hero no overlay,
  na mesma localização e tamanho do _source_ hero.
  Adicionar um hero ao overlay altera sua ordem Z para que ele
  apareça sobre todas as rotas.

* Move o source hero para fora da tela.

---

![The hero flies in the overlay to its final position and size](/assets/images/docs/ui/animations/hero-transition-2.png)

À medida que o hero voa, seus limites retangulares são animados usando
[Tween&lt;Rect&gt;][], especificado na propriedade
[`createRectTween`][] do Hero.
Por padrão, o Flutter usa uma instância de
[`MaterialRectArcTween`][], que anima os
cantos opostos do retângulo ao longo de um caminho curvo.
(Consulte [Radial hero animations][] para um exemplo
que usa uma animação Tween diferente.)

---

![When the transition is complete, the hero is moved from the overlay to the destination route](/assets/images/docs/ui/animations/hero-transition-3.png)

Quando o voo é concluído:

* O Flutter move o hero widget do overlay para
  a rota de destino. O overlay agora está vazio.

* O destination hero aparece em sua posição final
  na rota de destino.

* O source hero é restaurado para sua rota.

---

Fazer pop da rota executa o mesmo processo,
animando o hero de volta ao seu tamanho
e localização na rota de origem.

### Classes essenciais

Os exemplos neste guia usam as seguintes classes para
implementar hero animations:

[`Hero`][]
: O widget que voa da rota de origem para a rota de destino.
  Defina um Hero para a rota de origem e outro para a
  rota de destino, e atribua a cada um a mesma tag.
  O Flutter anima pares de heroes com tags correspondentes.

[`InkWell`][]
: Especifica o que acontece ao tocar no hero.
  O método `onTap()` do `InkWell` constrói a
  nova rota e a faz push para a pilha do `Navigator`.

[`Navigator`][]
: O `Navigator` gerencia uma pilha de rotas. Fazer push de uma rota ou
  fazer pop de uma rota da pilha do `Navigator` aciona a animação.

[`Route`][]
: Especifica uma tela ou página. A maioria dos aplicativos,
  além dos mais básicos, tem múltiplas rotas.

## Standard hero animations

:::secondary Qual é o ponto?
* Especifique uma rota usando `MaterialPageRoute`, `CupertinoPageRoute`,
    ou construa uma rota personalizada usando `PageRouteBuilder`.
    Os exemplos nesta seção usam MaterialPageRoute.
* Altere o tamanho da imagem no final da transição
    envolvendo a imagem de destino em um `SizedBox`.
* Altere a localização da imagem colocando a imagem de destino
    em um layout widget. Esses exemplos usam `Container`.
:::

<a id="standard-hero-animation-code"></a>

:::secondary Standard hero animation code
Cada um dos exemplos a seguir demonstra fazer uma imagem voar de uma
rota para outra. Este guia descreve o primeiro exemplo.

[hero_animation][]
: Encapsula o código do hero em um widget `PhotoHero` personalizado.
  Anima o movimento do hero ao longo de um caminho curvo,
  conforme descrito na especificação de motion do Material.

[basic_hero_animation][]
: Usa o hero widget diretamente.
  Este exemplo mais básico, fornecido para sua referência, não está
  descrito neste guia.
:::

### O que está acontecendo?

Fazer uma imagem voar de uma rota para outra é fácil de implementar
usando o hero widget do Flutter. Ao usar `MaterialPageRoute`
para especificar a nova rota, a imagem voa ao longo de um caminho curvo,
conforme descrito pela [Material Design motion spec][].

[Crie um novo exemplo Flutter][] e
atualize-o usando os arquivos do [hero_animation][].

Para executar o exemplo:

* Toque na foto da rota inicial para fazer a imagem voar para uma nova rota
  mostrando a mesma foto em uma localização e escala diferentes.
* Retorne à rota anterior tocando na imagem, ou usando o
  gesto de voltar para a rota anterior do dispositivo.
* Você pode desacelerar ainda mais a transição usando a propriedade `timeDilation`.

### Classe PhotoHero

A classe PhotoHero personalizada mantém o hero,
e seu tamanho, imagem e comportamento quando tocado.
O PhotoHero constrói a seguinte árvore de widgets:

<div class="text-center mb-4">

  ![PhotoHero class widget tree](/assets/images/docs/ui/animations/photohero-class.png)

</div>

Aqui está o código:

```dart
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
            child: Image.asset(
              photo,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
```

Informações chave:

* A rota inicial é implicitamente feita push pelo `MaterialApp` quando
  `HeroAnimation` é fornecido como a propriedade home do aplicativo.
* Um `InkWell` envolve a imagem, tornando trivial adicionar um gesto
  de toque aos heroes de origem e destino.
* Definir o widget Material com uma cor transparente
  permite que a imagem "apareça" do fundo enquanto
  voa para seu destino.
* O `SizedBox` especifica o tamanho do hero no início e
  no final da animação.
* Definir a propriedade `fit` do Image como `BoxFit.contain`,
  garante que a imagem seja o maior possível durante a
  transição sem alterar sua proporção de aspecto.

### Classe HeroAnimation

A classe `HeroAnimation` cria os
PhotoHeroes de origem e destino, e configura a transição.

Aqui está o código:

```dart
class HeroAnimation extends StatelessWidget {
  const HeroAnimation({super.key});

  Widget build(BuildContext context) {
    [!timeDilation = 5.0; // 1.0 means normal animation speed.!]

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Hero Animation'),
      ),
      body: Center(
        [!child: PhotoHero(!]
          photo: 'images/flippers-alpha.png',
          width: 300.0,
          [!onTap: ()!] {
            [!Navigator.of(context).push(MaterialPageRoute<void>(!]
              [!builder: (context)!] {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Flippers Page'),
                  ),
                  body: Container(
                    // Set background to blue to emphasize that it's a new route.
                    color: Colors.lightBlueAccent,
                    padding: const EdgeInsets.all(16),
                    alignment: Alignment.topLeft,
                    [!child: PhotoHero(!]
                      photo: 'images/flippers-alpha.png',
                      width: 100.0,
                      [!onTap: ()!] {
                        [!Navigator.of(context).pop();!]
                      },
                    ),
                  ),
                );
              }
            ));
          },
        ),
      ),
    );
  }
}
```

Informações chave:

* Quando o usuário toca no `InkWell` contendo o source hero,
  o código cria a rota de destino usando `MaterialPageRoute`.
  Fazer push da rota de destino para a pilha do `Navigator` aciona
  a animação.
* O `Container` posiciona o `PhotoHero` no canto
  superior esquerdo da rota de destino, abaixo do `AppBar`.
* O método `onTap()` para o destination `PhotoHero`
  faz pop da pilha do `Navigator`, acionando a animação
  que faz o `Hero` voar de volta para a rota original.
* Use a propriedade `timeDilation` para desacelerar a transição
  durante a depuração.

---

## Radial hero animations

:::secondary Qual é o ponto?
* Uma _radial transformation_ anima uma forma circular em uma
    forma quadrada.
* Uma radial _hero_ animation executa uma radial transformation enquanto
    faz o hero voar da rota de origem para a rota de destino.
* MaterialRectCenter&shy;Arc&shy;Tween define a animação tween.
* Construa a rota de destino usando `PageRouteBuilder`.
:::

Fazer um hero voar de uma rota para outra enquanto se transforma
de uma forma circular para uma forma retangular é um efeito
elegante que você pode implementar usando widgets Hero.
Para realizar isso, o código anima a interseção de
duas formas de recorte: um círculo e um quadrado.
Durante toda a animação, o recorte circular (e a imagem)
escala de `minRadius` para `maxRadius`, enquanto o
recorte quadrado mantém tamanho constante. Ao mesmo tempo,
a imagem voa de sua posição na rota de origem para sua
posição na rota de destino. Para exemplos visuais
dessa transição, consulte [Radial transformation][]
na especificação de motion do Material.

Essa animação pode parecer complexa (e é), mas você pode **personalizar o
exemplo fornecido para suas necessidades.** O trabalho pesado é feito para você.

<a id="radial-hero-animation-code"></a>

:::secondary Radial hero animation code
Cada um dos exemplos a seguir demonstra uma radial hero animation.
Este guia descreve o primeiro exemplo.

[radial_hero_animation][]
: Uma radial hero animation conforme descrito na especificação de motion do Material.

[basic_radial_hero_animation][]
: O exemplo mais simples de uma radial hero animation. A rota de destino
  não tem Scaffold, Card, Column ou Text.
  Este exemplo básico, fornecido para sua referência, não está
  descrito neste guia.

[radial_hero_animation_animate<wbr>_rectclip][]
: Estende radial_hero_animation também animando o tamanho do
  recorte retangular. Este exemplo mais avançado,
  fornecido para sua referência, não está descrito neste guia.
:::

:::tip Dica profissional
A radial hero animation envolve intersectar uma forma redonda com
uma forma quadrada. Isso pode ser difícil de ver, mesmo ao desacelerar
a animação com `timeDilation`, então você pode considerar habilitar
o flag [`debugPaintSizeEnabled`][] durante o desenvolvimento.
:::

### O que está acontecendo?

O diagrama a seguir mostra a imagem recortada no início
(`t = 0.0`), e no final (`t = 1.0`) da animação.

![Radial transformation from beginning to end](/assets/images/docs/ui/animations/radial-hero-animation.png)

O gradiente azul (representando a imagem), indica onde as formas de recorte
se intersectam. No início da transição,
o resultado da interseção é um recorte circular ([`ClipOval`][]).
Durante a transformação, o `ClipOval` escala de `minRadius`
para `maxRadius` enquanto o [ClipRect][] mantém um tamanho constante.
No final da transição, a interseção dos recortes circular e
retangular produz um retângulo que é do mesmo tamanho que o hero
widget. Em outras palavras, no final da transição, a imagem não está
mais recortada.

[Crie um novo exemplo Flutter][] e
atualize-o usando os arquivos do
diretório GitHub [radial_hero_animation][].

Para executar o exemplo:

* Toque em uma das três miniaturas circulares para animar a imagem
  para um quadrado maior posicionado no meio de uma nova rota que
  oculta a rota original.
* Retorne à rota anterior tocando na imagem, ou usando o
  gesto de voltar para a rota anterior do dispositivo.
* Você pode desacelerar ainda mais a transição usando a propriedade `timeDilation`.

### Classe Photo

A classe `Photo` constrói a árvore de widgets que contém a imagem:

```dart
class Photo extends StatelessWidget {
  const Photo({super.key, required this.photo, this.color, this.onTap});

  final String photo;
  final Color? color;
  final VoidCallback onTap;

  Widget build(BuildContext context) {
    return [!Material(!]
      // Slightly opaque color appears where the image has transparency.
      [!color: Theme.of(context).primaryColor.withValues(alpha: 0.25),!]
      child: [!InkWell(!]
        onTap: [!onTap,!]
        child: [!Image.asset(!]
          photo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
```

Informações chave:

* O `InkWell` captura o gesto de toque.
  A função chamadora passa a função `onTap()` para o
  construtor de `Photo`.
* Durante o voo, o `InkWell` desenha seu splash em seu primeiro
  ancestral Material.
* O widget Material tem uma cor ligeiramente opaca, então as
  porções transparentes da imagem são renderizadas com cor.
  Isso garante que a transição de círculo para quadrado seja fácil de ver,
  mesmo para imagens com transparência.
* A classe `Photo` não inclui o `Hero` em sua árvore de widgets.
  Para que a animação funcione, o hero
  envolve o widget `RadialExpansion`.

### Classe RadialExpansion

O widget `RadialExpansion`, o núcleo da demonstração, constrói a
árvore de widgets que recorta a imagem durante a transição.
A forma recortada resulta da interseção de um recorte circular
(que cresce durante o voo),
com um recorte retangular (que permanece com tamanho constante durante todo o tempo).

Para fazer isso, ele constrói a seguinte árvore de widgets:

<div class="text-center mb-4">

  ![RadialExpansion widget tree](/assets/images/docs/ui/animations/radial-expansion-class.png)

</div>

Aqui está o código:

```dart
class RadialExpansion extends StatelessWidget {
  const RadialExpansion({
    super.key,
    required this.maxRadius,
    this.child,
  }) : [!clipRectSize = 2.0 * (maxRadius / math.sqrt2);!]

  final double maxRadius;
  final clipRectSize;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return [!ClipOval(!]
      child: [!Center(!]
        child: [!SizedBox(!]
          width: clipRectSize,
          height: clipRectSize,
          child: [!ClipRect(!]
            child: [!child,!] // Photo
          ),
        ),
      ),
    );
  }
}
```

Informações chave:

* O hero envolve o widget `RadialExpansion`.
* À medida que o hero voa, seu tamanho muda e,
  porque ele restringe o tamanho de seu filho,
  o widget `RadialExpansion` muda de tamanho para corresponder.
* A animação `RadialExpansion` é criada por dois recortes sobrepostos.
* O exemplo define a interpolação do tweening usando
  [`MaterialRectCenterArcTween`][].
  O caminho de voo padrão para uma hero animation
  interpola os tweens usando os cantos dos heroes.
  Essa abordagem afeta a proporção de aspecto do hero durante
  a transformação radial, então o novo caminho de voo usa
  `MaterialRectCenterArcTween` para interpolar os tweens usando o
  ponto central de cada hero.

  Aqui está o código:

  ```dart
  static RectTween _createRectTween(Rect? begin, Rect? end) {
    return MaterialRectCenterArcTween(begin: begin, end: end);
  }
  ```

  O caminho de voo do hero ainda segue um arco,
  mas a proporção de aspecto da imagem permanece constante.

[Animations in Flutter tutorial]: /ui/animations/tutorial
[basic_hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_hero_animation/
[basic_radial_hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/basic_radial_hero_animation
[Building Layouts in Flutter]: /ui/layout
[`ClipOval`]: {{site.api}}/flutter/widgets/ClipOval-class.html
[ClipRect]: {{site.api}}/flutter/widgets/ClipRect-class.html
[Crie um novo exemplo Flutter]: /get-started/test-drive
[`createRectTween`]: {{site.api}}/flutter/widgets/CreateRectTween.html
[`debugPaintSizeEnabled`]: /tools/devtools/inspector#debugging-layout-issues-visually
[`Hero`]: {{site.api}}/flutter/widgets/Hero-class.html
[hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/hero_animation/
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[Material Design motion spec]: {{site.material2}}/design/motion/understanding-motion.html#principles
[`MaterialRectArcTween`]: {{site.api}}/flutter/material/MaterialRectArcTween-class.html
[`MaterialRectCenterArcTween`]: {{site.api}}/flutter/material/MaterialRectCenterArcTween-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[Radial hero animation code]: #radial-hero-animation-code
[radial_hero_animation]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/radial_hero_animation
[radial_hero_animation_animate<wbr>_rectclip]: {{site.repo.this}}/tree/{{site.branch}}/examples/_animation/radial_hero_animation_animate_rectclip
[Radial hero animations]: #radial-hero-animations
[Radial transformation]: https://web.archive.org/web/20180223140424/https://material.io/guidelines/motion/transforming-material.html
[`RectTween`]: {{site.api}}/flutter/animation/RectTween-class.html
[_Route_]: /cookbook/navigation/navigation-basics
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[Standard hero animation code]: #standard-hero-animation-code
[Tween&lt;Rect&gt;]: {{site.api}}/flutter/animation/Tween-class.html
