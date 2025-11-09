---
ia-translate: true
title: Criar widgets
description: Aprenda sobre stateless widgets e como construir o seu próprio.
permalink: /tutorial/stateless-widgets/
sitemap: false
---

{%- comment %}
<!-- TODO(ewindmill) embed video -->
{%- endcomment %}

Nesta lição, você criará seu próprio widget customizado e aprenderá sobre alguns dos
widgets mais comuns incluídos no SDK.

Widgets customizados permitem que você reutilize componentes de UI em todo o seu app, organize
código de UI complexo em partes gerenciáveis e crie código mais limpo e fácil de manter.
Ao final desta lição, você terá criado seu próprio widget Tile customizado.


## Antes de começar

Este app depende de um pouco de lógica de jogo que não está relacionada à UI e, portanto, está fora do escopo deste tutorial. Antes de continuar, você precisa adicionar essa lógica ao seu app.

1. Crie um novo arquivo no diretório `lib` chamado `game.dart`.
2. Copie o código a seguir nele e importe esse código no seu arquivo `main.dart`.

{% render docs/tutorial/game-code.md  %}

:::note Nota sobre a lógica do jogo
Você pode notar que as listas chamadas `legalGuesses` e `legalWords` contêm apenas algumas palavras. As listas completas combinadas têm mais de 10.000 palavras e foram omitidas por questão de brevidade. Você não precisa das listas completas para continuar o tutorial. Ao testar seu app, certifique-se de usar as poucas palavras dessas listas.

Alternativamente, você pode encontrar as listas completas [neste repositório github][this github repository], assim como instruções para importá-las em seu projeto.
:::

## Anatomia de um stateless widget

Um `Widget` é uma classe Dart que estende uma das classes de widget do Flutter, neste caso [`StatelessWidget`][].

Abra seu arquivo `main.dart` e adicione este código abaixo da classe `MainApp`, que
define um novo widget chamado `Tile`.

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  // ...
}
```

### Construtor

A classe `Tile` tem um [`constructor`][] que define
quais dados precisam ser passados para o widget para renderizá-lo. Aqui, uma
`String` é passada, que representa a letra adivinhada, e um `HitType`,
que é um [valor enum][enum value] usado para
determinar a cor do tile. (Por exemplo, `HitType.hit` resulta em um
tile verde). Passar dados para o widget está no cerne de tornar widgets reutilizáveis.


### Método `Build`

Finalmente, há o importantíssimo método `build`, que deve ser definido em
cada widget e sempre retornará outro widget.

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
	// TODO: Replace Containter with widgets.
	return Container();
  }
}
```

## Use o widget customizado

Quando este app estiver concluído, haverá 25 instâncias deste widget na tela.
Por enquanto, porém, exiba apenas um para que você possa ver as atualizações conforme são feitas. No
método `MainApp.build`, substitua o widget `Text` pelo seguinte:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Tile('A', HitType.hit), // NEW
        ),
      ),
    );
  }
}
```

No momento, seu app ficará em branco, porque o widget `Tile` retorna um
`Container` vazio, que não exibe nada por padrão.

## O widget `Container`

O widget `Tile` consiste em três dos widgets básicos mais comuns:
`Container`, `Center` e `Text`.
[`Container`][] é um
widget de conveniência que envolve vários widgets básicos de estilo, como `Padding`,
[`ColoredBox`][], [`SizedBox`][], [`DecoratedBox`][] e muitos mais.

Como a UI finalizada contém 25 widgets `Tile` em colunas e linhas organizadas, ele
deve ter um tamanho explícito. Defina as propriedades width e height no
`Container`. (Você também poderia fazer isso com um widget `SizedBox`, mas você usará
mais propriedades do `Container` a seguir.)

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
	// NEW
	  return Container(
       width: 60,
       height: 60,
       // TODO: Add needed widgets
    );
  }
}
```

## BoxDecoration

Em seguida, adicione uma [`Border`][] à caixa com o seguinte código:

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
	// NEW
	  return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        // TODO: add background color
      ),
    );
  }
}
```

`BoxDecoration` é um objeto que sabe como adicionar qualquer número de decorações a
um widget, desde cor de fundo até bordas, box shadows e muito mais. Neste
caso, você adicionou uma borda. Quando você fizer hot reload, deve haver uma borda
levemente colorida ao redor do quadrado branco.

Quando este jogo estiver completo, a cor do tile dependerá do palpite do
usuário. O tile será verde quando o usuário adivinhar corretamente, amarelo quando
a letra estiver correta mas a posição estiver incorreta, e cinza se o palpite estiver
errado em ambos os eixos.

A figura a seguir mostra todas as três possibilidades.

<img src='/assets/images/docs/tutorial/tiles.png' alt="A screenshot of a green, yellow, and grey tile.">


Para conseguir isso na UI, use uma [expressão switch][switch expression] para definir a
`color` da `BoxDecoration`.

```dart
class Tile extends StatelessWidget {
  const Tile(required this.letter, required hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
	return Container(
       width: 60,
       height: 60,
       decoration: BoxDecoration(
         border: Border.all(color: Colors.grey.shade300),
         color: switch (hitType) {
           HitType.hit => Colors.green,
           HitType.partial => Colors.yellow,
           HitType.miss => Colors.grey,
           _ => Colors.white,
        },
        // TODO: add children
      ),
    );
  }
}
```

## Widgets filhos

Finalmente, adicione os widgets `Center` e `Text` à propriedade `Container.child`.

A maioria dos widgets no Flutter SDK tem uma propriedade `child` ou `children` que
deve receber um widget ou uma lista de widgets, respectivamente. É uma boa
prática usar a mesma convenção de nomenclatura em seus próprios widgets customizados.

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
```

Faça hot reload e uma caixa verde aparece. Para alternar a cor,
atualize e faça hot reload do `HitType` passado para o `Tile` que você criou:

```dart
// main.dart line ~16
// green
child: Tile('A', HitType.hit)
// grey
child: Tile('A', HitType.miss)
// yellow
child: Tile('A', HitType.partial)
```

Em breve, esta pequena caixa será um dos muitos widgets na tela. Na próxima
lição, você começará a construir a própria grade do jogo.



[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`constructor`]: {{site.dart-site}}/language/constructors
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`Border`]: {{site.api}}/flutter/widgets/Container-class.html
[`ColoredBox`]: {{site.api}}/flutter/widgets/ColoredBox-class.html
[`SizedBox`]: {{site.api}}/flutter/widgets/SizedBox-class.html
[`DecoratedBox`]: {{site.api}}/flutter/widgets/DecoratedBox-class.html
[switch expression]: {{site.dart-site}}/language/branches#switch-statements
[enum value]: {{site.dart-site}}/language/branches#switch-statements
[this github repository]: https://github.com/ericwindmill/legal_wordle_words
