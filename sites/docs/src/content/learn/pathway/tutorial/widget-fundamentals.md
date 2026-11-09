---
ia-translate: true
title: Criar widgets
description: Aprenda sobre stateless widgets e como construir o seu próprio.
layout: tutorial
---

Aprenda a criar widgets customizados e a usar os widgets mais comuns do SDK, como
Container, Center e Text.

<YouTubeEmbed id="gyBUnaojFDg" title="Anatomy of a widget" fullWidth="true"></YouTubeEmbed>

<SummaryCard>
title: O que você vai realizar
items:
  - title: Criar um StatelessWidget customizado
    icon: widgets
  - title: Tornar widgets reutilizáveis com parâmetros de construtor
    icon: tune
  - title: Estilizar widgets usando Container e BoxDecoration
    icon: palette
</SummaryCard>

---

### Antes de começar {:#before-you-start}

Este app depende de um pouco de lógica de jogo que não está relacionada à UI
e, portanto, está fora do escopo deste tutorial.
Antes de continuar, você precisa adicionar essa lógica ao seu app.

1.  Baixe o arquivo Dart a seguir e salve-o
    como `lib/game.dart` no diretório do seu projeto.

    <DownloadableSnippet src="tutorial/game-code.dart" name="game.dart" />

1.  Para habilitar o acesso aos tipos definidos na biblioteca `game.dart`,
    adicione uma importação dela no seu arquivo `lib/main.dart`:

    ```dart title="main.dart" highlightLines=3
    import 'package:material_ui/material_ui.dart';

    import 'game.dart';
    ```

:::note Nota sobre a lógica do jogo

As listas `legalGuesses` e `legalWords` em `lib/game.dart` contêm apenas uma
pequena amostra de palavras de cinco letras (como `aback`, `abase` e `abate`) por
questão de brevidade. Ao testar seu app mais adiante neste tutorial, apenas as palavras definidas em
`lib/game.dart` são aceitas como palpites válidos.
:::

### Anatomia de um stateless widget {:#anatomy-of-a-stateless-widget}

Um `Widget` é uma classe Dart que estende uma das classes de widget do Flutter,
neste caso [`StatelessWidget`][].

Abra seu arquivo `main.dart` e adicione este código abaixo da classe `MainApp`,
que define um novo widget chamado `Tile`.

<?code-excerpt "fwe/birdle/lib/step2a_main.dart (Tile)"?>
```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
```

[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html

#### Construtor {:#constructor}

A classe `Tile` tem um [construtor][constructor] que define
quais dados precisam ser passados para o widget para renderizá-lo.
Neste caso, o construtor aceita dois parâmetros:

- Uma `String` representando a letra adivinhada do tile.
- Um [valor enum][enum value] `HitType` que representa o resultado do palpite e
  é usado para determinar a cor do tile.
  Por exemplo, `HitType.hit` resulta em um tile verde.

Passar dados para construtores de widgets está no cerne de tornar widgets reutilizáveis.

[constructor]: {{site.dart-site}}/language/constructors
[enum value]: {{site.dart-site}}/language/enums

#### Método build {:#build-method}

Finalmente, há o importantíssimo método `build`,
que deve ser definido em cada widget
e sempre retornará outro widget.

<?code-excerpt "fwe/birdle/lib/step2b_main.dart (Tile)"?>
```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    // TODO: Replace Container with widgets.
    return Container();
  }
}
```

### Use o widget customizado {:#use-the-custom-widget}

Quando o app estiver concluído,
haverá 25 instâncias deste widget na tela.
Por enquanto, exiba apenas um único tile no centro da tela
para que você possa ver as atualizações de estilo conforme as faz.
No método `MainApp.build`,
substitua o widget `Text` pelo seu widget `Tile`:

<?code-excerpt "fwe/birdle/lib/step2_main.dart (MainApp)"?>
```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Tile('A', HitType.hit), // NEW
        ),
      ),
    );
  }
}
```

No momento, seu app aparece em branco
porque o widget `Tile` retorna um `Container` vazio,
que não renderiza nada por padrão.

### O widget `Container` {:#the-container-widget}

O widget `Tile` consiste em três dos widgets principais mais comuns:
`Container`, `Center` e `Text`.
[`Container`][] é um widget de conveniência que envolve vários widgets principais de estilo,
como [`Padding`][], [`ColoredBox`][], [`SizedBox`][] e [`DecoratedBox`][].

Como a UI finalizada contém 25 widgets `Tile` em colunas e linhas organizadas,
ele deve ter um tamanho explícito.
Defina as propriedades width e height no `Container`.
(Você também poderia fazer isso com um widget `SizedBox`, mas você usará
mais propriedades do `Container` a seguir.)

<?code-excerpt "fwe/birdle/lib/step2c_main.dart (Tile)"?>
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

[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`Padding`]: {{site.api}}/flutter/widgets/Padding-class.html
[`ColoredBox`]: {{site.api}}/flutter/widgets/ColoredBox-class.html
[`SizedBox`]: {{site.api}}/flutter/widgets/SizedBox-class.html
[`DecoratedBox`]: {{site.api}}/flutter/widgets/DecoratedBox-class.html

### BoxDecoration

Em seguida, adicione uma [`Border`][] à caixa com o seguinte código:

<?code-excerpt "fwe/birdle/lib/step2d_main.dart (Tile)"?>
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

`BoxDecoration` é um objeto que sabe como
adicionar qualquer número de decorações a um widget, desde
cor de fundo até bordas, box shadows e muito mais.
Neste caso, você adicionou uma borda.
Quando você fizer hot reload,
uma borda levemente colorida aparece ao redor do tile.

Quando este jogo estiver completo,
a cor do tile dependerá do palpite do usuário.
O tile será verde quando o usuário adivinhar corretamente,
amarelo quando a letra estiver correta mas a posição estiver incorreta, e
cinza se o palpite estiver errado em ambos os aspectos.

A figura a seguir mostra as três possibilidades.

<img src='/assets/images/docs/tutorial/tiles.png' width="320px" alt="Uma captura de tela de um tile verde, um amarelo e um cinza.">


Para conseguir isso na UI, use uma [expressão switch][switch expression] para
definir a `color` da `BoxDecoration`.

<?code-excerpt "fwe/birdle/lib/step2e_main.dart (Tile)"?>
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
        // TODO: add children
      ),
    );
  }
}
```

[`Border`]: {{site.api}}/flutter/widgets/Container-class.html
[switch expression]: {{site.dart-site}}/language/branches#switch-expressions

### Widgets filhos {:#child-widgets}

Finalmente, adicione os widgets `Center` e `Text` à propriedade `Container.child`.

A maioria dos widgets no Flutter SDK tem uma propriedade `child` ou `children` que
deve receber um widget ou uma lista de widgets, respectivamente.
É uma boa prática usar a mesma convenção de nomenclatura em
seus próprios widgets customizados.

<?code-excerpt "fwe/birdle/lib/step2f_main.dart (Tile)"?>
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

Faça hot reload, e um único tile verde contendo a letra **A**
aparece no centro do seu app.
Para testar cores diferentes,
tente substituir o widget Tile no MainApp
por um dos exemplos a seguir e depois faça hot reload:

<?code-excerpt "fwe/birdle/lib/step2_main.dart (TileUsage)"?>
```dart
// main.dart line ~16
// green
Tile('A', HitType.hit);
// grey
Tile('A', HitType.miss);
// yellow
Tile('A', HitType.partial);
```

Em breve, esta pequena caixa será um dos muitos widgets na tela.
Na próxima lição,
você construirá a grade completa de 5x5 tiles para o tabuleiro do jogo.

### Revisão {:#review}


<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Construiu um StatelessWidget customizado
    icon: widgets
    details: >-
      Você criou um novo widget `Tile` estendendo `StatelessWidget`.
      Todo widget tem um construtor para aceitar dados e
      um método `build` que retorna outros widgets.
      Esse padrão é fundamental para construir interfaces de usuário com Flutter.
  - title: Tornou widgets reutilizáveis com parâmetros de construtor
    icon: tune
    details: >-
      Ao aceitar `letter` e `hitType` como parâmetros de construtor,
      seu widget `Tile` pode exibir conteúdos e cores diferentes.
      Passar dados por meio de construtores é como você pode
      criar componentes flexíveis e reutilizáveis.
  - title: Estilizou widgets usando Container e BoxDecoration
    icon: palette
    details: >-
      Você usou `Container` para definir o tamanho do widget e
      `BoxDecoration` para adicionar bordas e cores de fundo.
      Depois, para estilizar condicionalmente a cor do tile,
      você usou uma expressão switch no valor de `hitType`.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de fundamentos de widgets">
- question: "O que o método `build` de todo widget Flutter deve retornar?"
  options:
    - text: Uma String descrevendo o widget.
      correct: false
      explanation: "O método `build` retorna um widget, não uma String."
    - text: Outro widget.
      correct: true
      explanation: "O método `build` sempre retorna outro widget, que faz parte da árvore de widgets."
    - text: Um booleano indicando sucesso ou falha.
      correct: false
      explanation: Widgets não indicam sucesso; eles retornam outros widgets para serem renderizados.
    - text: Null se não houver nada para exibir.
      correct: false
      explanation: "O método `build` não pode retornar null; ele deve retornar um widget válido."
- question: Qual objeto é usado para adicionar decorações como bordas, cores de fundo e sombras a um Container?
  options:
    - text: ThemeData
      correct: false
      explanation: ThemeData é para estilização de todo o app, não para decorações individuais de containers.
    - text: TextStyle
      correct: false
      explanation: TextStyle é para formatação de texto, não para decorações de containers.
    - text: BoxDecoration
      correct: true
      explanation: BoxDecoration pode adicionar bordas, cores de fundo, gradientes, sombras e mais a um Container.
    - text: EdgeInsets
      correct: false
      explanation: EdgeInsets é para especificar padding ou margin, não decorações visuais.
</Quiz>
