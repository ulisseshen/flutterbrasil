---
ia-translate: true
title: Layout
description: Aprenda sobre widgets de layout comuns no Flutter.
permalink: /tutorial/layout/
sitemap: false
---

{%- comment %} TODO(ewindmill) embed video {%- endcomment %}


Dado que Flutter é um toolkit de UI, você passará muito tempo criando layouts
com widgets Flutter. Nesta seção, você aprenderá como construir layouts com
alguns dos widgets de layout mais comuns, incluindo widgets de alto nível como
[`Scaffold`][] e [`AppBar`][], que definem a estrutura de uma tela, até
widgets de nível mais baixo como [`Column`][] ou [`Row`][]
que organizam widgets verticalmente ou horizontalmente.

## `Scaffold` e `AppBar`

Aplicações mobile frequentemente têm uma barra no topo chamada de "app bar" que pode
exibir um título, controles de navegação e/ou ações.

<img src='/assets/images/docs/tutorial/apppad.png' alt="A screenshot of a simple application with a bar across the top that has a title and settings button.">

A forma mais simples de adicionar uma app bar ao seu app é usando dois widgets:
`Scaffold` e `AppBar`.

`Scaffold` é um widget de conveniência que fornece um layout de página estilo Material,
tornando simples adicionar uma app bar, drawer, navigation bar e muito mais a uma página do
seu app. `AppBar` é, claro, a app bar.

O código gerado pelo comando `$ flutter create --empty` já contém
um widget `AppBar` e um widget `Scaffold`. O código a seguir atualiza isso para usar um
widget de layout adicional: [`Align`][]. Isso posiciona o título à esquerda,
que seria centralizado por padrão. O widget `Text` contém o
título em si.

Modifique o `Scaffold` dentro do método `build` do seu `MainApp`:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: Center(child: Tile('A', HitType.hit)),
      ),
    );
  }
}
```

### Uma árvore de widgets atualizada

Note que a árvore de widgets do seu app se torna mais importante conforme seu app
cresce. Neste ponto, há uma "ramificação" na árvore de widgets pela primeira
vez, e agora ela se parece com a figura a seguir.

<img src='/assets/images/docs/tutorial/widget_tree_with_app_bar.png' alt="A screenshot that resembles the popular game Wordle.">


## Crie o widget GamePage

Adicione o código a seguir para um novo widget, chamado `GamePage`, ao seu arquivo `main.dart`.
Este widget eventualmente exibirá os elementos de UI necessários para o jogo
em si.

```dart
class GamePage extends StatelessWidget {
  const GamePage({super.key});
  // This object is part of the game.dart file.
  // It manages wordle logic, and is outside the scope of this tutorial.
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    // TODO: Replace with screen contents
    return Container();
  }
}
```

:::note Desafio - Exiba o `GamePage` em vez de um `Tile`.

**Solução:**

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        // Changed from `Tile`
        body: Center(child: GamePage()),
      ),
    );
  }
}
```
:::

## Organize widgets com `Column` e `Row`

O layout do `GamePage` contém a grade de tiles que exibe os palpites de um usuário.

<img src='/assets/images/docs/tutorial/birdle.png' alt="A screenshot that resembles the popular game Wordle.">

Existem várias maneiras de construir este layout, e a mais simples é com
widgets `Column` e `Row`. Cada linha contém cinco tiles que representam as
cinco letras em um palpite, com cinco linhas no total. Você precisará de uma coluna
com cinco linhas, cada linha contendo cinco filhos.
Primeiro, retorne uma `Column` (envolvida com um widget `Padding`)
do método `GamePage.build`.

```dart
class GamePage extends StatelessWidget {
  const GamePage({super.key});
  // This manages game logic, and is out of scope for this lesson
  final Game _game = Game();

    @override
    Widget build(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          spacing: 5.0,
          children: [
            // Add children next
          ],
        ),
      );
    }`
}
```

A propriedade `spacing` coloca cinco pixels entre cada elemento no eixo principal.

Dentro de `Column.children`, adicione uma linha *para cada* elemento na lista `_game.guesses`.

:::note
Esta lista `guesses` é uma lista de **tamanho fixo**, começando com cinco
elementos, um para cada palpite *potencial*. A lista sempre conterá exatamente cinco
elementos e, portanto, sempre renderizará cinco linhas.
:::

```dart
class GamePage extends StatelessWidget {
  const GamePage({super.key});
  // This manages game logic, and is out of scope for this lesson
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (var guess in _game.guesses)
              Row(
                spacing: 5.0,
                children: [
                // tiles
                ]
              ),
          ],
      ),
    );
  }
}
```

Isso é chamado de loop [collection-for][], um recurso do Dart que permite
desenrolar uma lista dentro de outra lista quando o loop é executado.
Este açúcar sintático facilita o trabalho
com coleções de widgets e alcança o mesmo resultado que o seguinte pseudocódigo:

```dart
[...ListOfData.map((element) => Widget(element)).toList()],
```

Neste caso, adiciona cinco widgets `Row` à coluna, um para cada palpite
no objeto `Game`.

### Uma árvore de widgets atualizada

A árvore de widgets para este app se expandiu significativamente nesta
lição. Agora, ela se parece mais com a figura a seguir (embora esteja
abreviada para legibilidade.)

### Uma árvore de widgets atualizada

Considerando que a árvore de widgets do seu app se torna mais importante conforme seu app
cresce. Neste ponto, há uma "ramificação" na árvore pela primeira
vez, e agora ela se parece com a figura a seguir.

<img src='/assets/images/docs/tutorial/widget_tree_rows_columns.png' alt="A diagram showing a tree like structure with a node for each widget in the app.">

:::note Desafio

Adicione um `Tile` a cada linha para cada letra permitida no palpite.
A variável `guess` no loop é um [registro][record] com o tipo
`({String char, HitType type})`.

**Solução:**

```dart
class GamePage extends StatelessWidget {
  const GamePage({super.key});
  // This manages game logic, and is out of scope for this lesson
  final Game _game = Game();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
            for (var guess in _game.guesses)
              Row(
                spacing: 5.0,
                children: [
                  for (var letter in guess)
                    Tile(letter.char, letter.type),
                ]
              ),
          ],
      ),
    );
  }
}
```

:::

Quando você recarregar seu app, você deverá ver uma grade 5x5 de quadrados brancos.

<img src='/assets/images/docs/tutorial/grid_of_tiles.png' alt="A screenshot that resembles the popular game Wordle.">

[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`Column`]:  {{site.api}}/flutter/widgets/Column-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Align`]: {{site.api}}/flutter/widgets/Align-class.html
[collection-for]: {{site.dart-site}}/language/collections#for-element
[record]: {{site.dart-site}}/language/records
