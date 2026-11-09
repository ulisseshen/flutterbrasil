---
ia-translate: true
title: Layout
description: Aprenda sobre widgets de layout comuns no Flutter.
layout: tutorial
---

Aprenda a construir layouts com widgets comuns como Scaffold, AppBar, Column e Row.

<YouTubeEmbed id="z8bY3XVAzgI" title="Flutter layout and constraints" fullWidth="true"></YouTubeEmbed>

<SummaryCard>
title: O que você vai realizar
items:
  - title: Estruturar um app com Scaffold e AppBar
    icon: web_asset
  - title: Organizar widgets usando Column e Row
    icon: view_column
  - title: Gerar widgets dinamicamente a partir de dados
    icon: repeat
  - title: Construir um layout de grade para o tabuleiro do jogo
    icon: grid_view
</SummaryCard>

---

### Introdução {:#introduction}

Dado que Flutter é um toolkit de UI,
você passará muito tempo criando layouts com widgets Flutter.

Nesta seção, você aprenderá como construir layouts com
alguns dos widgets de layout mais comuns.
Isso inclui widgets de alto nível como
[`Scaffold`][] e [`AppBar`][], que definem a estrutura de uma tela,
assim como widgets de nível mais baixo como [`Column`][] ou [`Row`][] que
organizam widgets verticalmente ou horizontalmente.

[`Scaffold`]: {{site.material_ui}}/Scaffold-class.html
[`AppBar`]: {{site.material_ui}}/AppBar-class.html
[`Column`]:  {{site.api}}/flutter/widgets/Column-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html

### `Scaffold` e `AppBar` {:#scaffold-and-appbar}

Aplicações mobile frequentemente têm uma barra no topo chamada de "app bar" que pode
exibir um título, controles de navegação e/ou ações.

<img src='/assets/images/docs/tutorial/appbar.png' width="320px" alt="Uma captura de tela de uma aplicação simples com uma barra no topo que tem um título e um botão de configurações.">

A forma mais simples de adicionar uma app bar ao seu app é usando dois widgets:
`Scaffold` e `AppBar`.

`Scaffold` é um widget de conveniência que fornece um layout de página estilo Material,
tornando simples adicionar uma app bar, drawer, navigation bar
e muito mais a uma página do seu app.
`AppBar` é, claro, a app bar.

Adicione um `AppBar` ao widget `Scaffold`
dentro do método `build` do seu widget `MainApp`.
O código a seguir usa um widget de layout adicional: [`Align`][].
Isso posiciona o título à esquerda, que seria centralizado por padrão.
O widget `Text` contém o título em si.

Passar um enum ou uma propriedade estática diretamente (como `Alignment.centerLeft`)
também pode ser abreviado usando a sintaxe de [dot shorthands do Dart][Dart's dot shorthands],
sobre a qual você pode ler mais tanto na documentação oficial do Dart
quanto na [visão geral de shorthands do Flutter][Flutter shorthands overview].

[Dart's dot shorthands]: https://dart.dev/language/dot-shorthands
[Flutter shorthands overview]: /ui/dot-shorthands

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: const Center(
          child: Tile('A', HitType.hit),
        ),
      ),
    );
  }
}
```

[`Align`]: {{site.api}}/flutter/widgets/Align-class.html

#### Uma árvore de widgets atualizada {:#an-updated-widget-tree}

Considerar a árvore de widgets do seu app se torna mais importante conforme seu app cresce.
Neste ponto, há uma "ramificação" na árvore de widgets pela primeira vez,
e agora ela se parece com a figura a seguir:

<img src='/assets/images/docs/tutorial/widget_tree_with_app_bar.png' width="320px" alt="Uma captura de tela que se assemelha ao popular jogo Wordle.">


### Crie um widget para o layout da página do jogo {:#create-a-widget-for-the-game-page-layout}

Adicione o código a seguir para um novo widget,
chamado `GamePage`, ao seu arquivo `main.dart`.
Este widget eventualmente exibirá os elementos de UI necessários para o jogo em si.

<?code-excerpt "fwe/birdle/lib/step3a_main.dart (GamePage)"?>
```dart title="lib/main.dart"
class GamePage extends StatelessWidget {
  GamePage({super.key});
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

Em seguida, atualize seu widget `MainApp` para criar e
exibir um widget `GamePage` em vez do widget `Tile`.

<?code-excerpt "fwe/birdle/lib/step3_main.dart (MainApp)"?>
```dart highlightLines=14
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: Center(child: GamePage()),
      ),
    );
  }
}
```

:::note Resolvendo erros de construtor `const`

Como `GamePage` inicializa um campo não constante
(`final Game _game = Game();`),
seu construtor não pode ser `const`.
Se você tinha anteriormente const Center(...) ou const MaterialApp(...),
o Dart reporta um erro:
"The constructor being called isn't a const constructor."
Para resolver isso, remova a palavra-chave const de Center (ou MaterialApp)
(ou do widget pai que os envolve)
e use `const` apenas em widgets com argumentos constantes,
como `const Align(...)`.
:::

### Organize widgets com `Column` e `Row` {:#arrange-widgets-with-column-and-row}

O layout do `GamePage` contém a grade de tiles que exibe os palpites de um usuário.

<img src='/assets/images/docs/tutorial/birdle.png' width="320px" alt="Uma captura de tela que se assemelha ao popular jogo Wordle.">

Existem várias maneiras de construir este layout.
A mais simples é com os widgets `Column` e `Row`.
Cada linha contém cinco tiles que representam as cinco letras em um palpite,
com cinco linhas no total.
Então você precisará de uma única `Column` com cinco widgets `Row` como filhos,
em que cada linha contém cinco filhos.

Para começar, substitua o `Container` em `GamePage.build` por um
widget `Padding` com um widget `Column` como filho:

<?code-excerpt "fwe/birdle/lib/step3b_main.dart (GamePage)"?>
```dart
class GamePage extends StatelessWidget {
  GamePage({super.key});
  // This manages game logic, and is out of scope for this lesson.
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          // Add children next.
        ],
      ),
    );
  }
}
```

A propriedade `spacing` coloca cinco pixels entre cada elemento no eixo principal.

Dentro de `Column.children`, para cada elemento na lista `_game.guesses`,
adicione um widget `Row` como filho.

:::note
Esta lista `guesses` é uma lista de **tamanho fixo**, começando com cinco
elementos, um para cada palpite *potencial*.
A lista sempre conterá exatamente cinco elementos
e, portanto, sempre renderizará cinco linhas.
:::

<?code-excerpt "fwe/birdle/lib/step3c_main.dart (GamePage)"?>
```dart
class GamePage extends StatelessWidget {
  GamePage({super.key});
  // This manages game logic, and is out of scope for this lesson.
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (final guess in _game.guesses)
            Row(
              spacing: 5.0,
              children: [
                // We'll add the tiles here later.
              ],
            ),
        ],
      ),
    );
  }
}
```

O loop `for` na lista `children` é chamado de [collection for element][],
uma sintaxe do Dart que permite adicionar itens iterativamente a uma coleção
quando ela é construída em tempo de execução.
Este açúcar sintático facilita o trabalho
com coleções de widgets,
fornecendo uma alternativa declarativa ao seguinte:

```dart
[..._game.guesses.map((guess) => Row(/* ... */))],
```

Neste caso, adiciona cinco widgets `Row` à coluna,
um para cada palpite no objeto `Game`.

[collection for element]: {{site.dart-site}}/language/collections#for-element

#### Uma árvore de widgets atualizada {:#an-updated-widget-tree-2}

A árvore de widgets para este app se expandiu significativamente nesta lição.
Agora, ela se parece mais com a figura a seguir (abreviada):

<img src='/assets/images/docs/tutorial/widget_tree_rows_columns.png' width="320px" alt="Um diagrama mostrando uma estrutura de árvore com um nó para cada widget no app.">

:::note Desafio

Adicione um `Tile` a cada linha para cada letra permitida no palpite.
Cada elemento em `guess` é um [registro][record] com o tipo
`({String char, HitType type})`.

Use um loop aninhado para iterar sobre as letras de cada palpite.

**Solução:**

<?code-excerpt "fwe/birdle/lib/step3_main.dart (GamePage)"?>
```dart title="lib/main.dart" collapsed
class GamePage extends StatelessWidget {
  GamePage({super.key});

  // This manages game logic, and is out of scope for this lesson.
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (final guess in _game.guesses)
            Row(
              spacing: 5.0,
              children: [
                for (final letter in guess) Tile(letter.char, letter.type),
              ],
            ),
        ],
      ),
    );
  }
}
```

:::

Quando você recarregar seu app, você deverá ver uma grade 5x5 de quadrados brancos.

<img src='/assets/images/docs/tutorial/grid_of_tiles.png' width="320px" alt="Uma captura de tela que se assemelha ao popular jogo Wordle.">

[record]: {{site.dart-site}}/language/records

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Estruturou seu app com Scaffold e AppBar
    icon: web_asset
    details: >-
      Você usou `Scaffold` para fornecer um layout de página estilo Material e
      `AppBar` para adicionar uma barra de título no topo do seu app.
      Esses widgets de alto nível dão ao seu app uma estrutura padrão, porém refinada.
  - title: Organizou widgets usando Column e Row
    icon: view_column
    details: >-
      `Column` organiza widgets verticalmente e `Row` os organiza horizontalmente.
      Esses são widgets de layout fundamentais que você usará constantemente no Flutter.
      A propriedade `spacing` adiciona espaços consistentes entre os filhos.
  - title: Gerou widgets dinamicamente a partir de dados
    icon: repeat
    details: >-
      Você usou um collection for element para construir widgets a partir de uma lista.
      Essa abordagem declarativa permite construir interfaces de usuário que
      refletem seus dados de forma automática e visual,
      um padrão central no desenvolvimento Flutter.
  - title: Construiu a grade do tabuleiro do jogo
    icon: grid_view
    details: >-
      Ao aninhar widgets `Row` dentro de uma `Column` e usar loops aninhados,
      você criou uma grade 5x5 de widgets `Tile`.
      Seu app agora exibe o layout completo do tabuleiro do jogo!
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de Layout">
- question: Qual é a principal diferença entre um widget Column e um widget Row?
  options:
    - text: Column é para conteúdo rolável; Row é para conteúdo estático.
      correct: false
      explanation: Tanto Column quanto Row servem para layout, não para rolagem. Use ListView ou SingleChildScrollView para rolagem.
    - text: Column organiza os filhos verticalmente; Row organiza os filhos horizontalmente.
      correct: true
      explanation: Column dispõe seus filhos ao longo do eixo vertical, enquanto Row usa o eixo horizontal.
    - text: Column pode ter filhos ilimitados; Row é limitado a dois.
      correct: false
      explanation: Ambos os widgets podem ter qualquer número de filhos.
    - text: Column requer um Scaffold como pai; Row não.
      correct: false
      explanation: Nenhum dos widgets requer um Scaffold como pai.
- question: O que o widget Scaffold fornece em um app Flutter?
  options:
    - text: Apenas uma cor de fundo para a página.
      correct: false
      explanation: O Scaffold fornece muito mais, incluindo estrutura para app bars, drawers e mais.
    - text: Um layout de página estilo Material com espaços para app bar, body, drawer e mais.
      correct: true
      explanation: Scaffold é um widget de conveniência que fornece uma estrutura de página Material padrão.
    - text: Uma forma de navegar entre páginas diferentes.
      correct: false
      explanation: A navegação é tratada pelo Navigator, não pelo Scaffold.
    - text: Gerenciamento automático de estado para a página.
      correct: false
      explanation: O Scaffold não gerencia estado; para isso você usa StatefulWidget ou soluções de gerenciamento de estado.
</Quiz>

