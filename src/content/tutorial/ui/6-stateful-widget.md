---
ia-translate: true
title: Stateful widgets
description: Aprenda sobre StatefulWidgets e reconstrução de UI Flutter.
permalink: /tutorial/stateful-widget/
sitemap: false

---

{%- comment %} TODO(ewindmill) embed video {%- endcomment %}

Até agora, seu app exibe uma grade e um campo de entrada, mas a grade
ainda não atualiza para refletir os palpites do usuário. Quando este app estiver
completo, cada tile na próxima linha não preenchida deve atualizar após cada
palpite do usuário submetido:

* Exibindo a letra correta.
* Mudando de cor para refletir se a letra está correta (verde), está
  na palavra mas em uma posição incorreta (amarelo), ou não aparece
  na palavra de forma alguma (cinza).

Para lidar com este comportamento dinâmico, você precisa converter `GamePage` de um
`StatelessWidget` para um [`StatefulWidget`][].

## Por que stateful widgets?

Quando a aparência ou os dados de um widget precisam mudar durante seu
tempo de vida, você precisa de um `StatefulWidget` e um objeto `State` companheiro.
Enquanto o `StatefulWidget` em si ainda é imutável (suas propriedades
não podem mudar após a criação), o objeto `State` é duradouro, pode
conter dados mutáveis e pode ser reconstruído quando esses dados mudam, fazendo
a UI atualizar.

Por exemplo, a seguinte árvore de widgets imagina um app simples
que tem um contador que aumenta quando o botão é pressionado,
e usa um stateful widget.

<img src='/assets/images/docs/tutorial/widget_tree_stateful.png' alt="A diagram of a widget tree with a stateful widget and state object.">

Aqui está a estrutura básica de `StatefulWidget` (não faça nada ainda):

```dart
class ExampleWidget extends StatefulWidget {
  ExampleWidget({super.key});

  @override
  State<ExampleWidget> createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  @override
  Widget build(BuildContext context) {
   return Container();
  }
}
```

## Converta `GamePage` para um stateful widget

Para converter o widget `GamePage` (ou qualquer outro) de
um stateless widget para um stateful widget, siga os seguintes passos:

1. Altere `GamePage` para estender `StatefulWidget` em vez de
   `StatelessWidget`.
2. Crie uma nova classe chamada `_GamePageState`, que estende
   `State<GamePage>`. Esta nova classe conterá o estado mutável e
   o método `build`. Mova o método `build` e todas as propriedades
   *instanciadas no widget* de `GamePage` para o objeto state.
3. Implemente o método `createState()` em `GamePage`, que retorna
   uma instância de `_GamePageState`.

:::tip Quick assists

Você não precisa fazer este trabalho manualmente, já que os plugins Flutter para
VS Code e IntelliJ fornecem ["quick assists"][], que farão esta
conversão para você.

:::

Seu código modificado deve ficar assim:

```dart
class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in guess)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: Tile(letter),
                  )
              ],
            ),
          GuessInput(
            onSubmitGuess: (_) {
              // TODO, handle guess
              print(guess); // Temporary
            },
          ),
        ],
      ),
    );
  }
}
```

## Atualizando a UI com `setState`

Sempre que você mutar um objeto `State`, você deve chamar [`setState`][] para
sinalizar ao framework para atualizar a interface do usuário e chamar o
método `build` do `State` novamente.

Neste app, quando um usuário faz um palpite, a palavra que ele adivinhou é salva
no objeto `Game`, que é uma propriedade na classe `GamePage`, e
portanto é um estado que pode mudar e exigir que a UI atualize.
Quando este estado é mutado, a grade deve ser redesenhada para mostrar o
palpite do usuário.

Para implementar isso, atualize a função de callback passada para
`GuessInput`. A função precisa chamar `setState` e, dentro de
`setState`, ela precisa executar a lógica para determinar se o palpite do
usuário estava correto.

:::note

A lógica do jogo é abstraída no [objeto `Game`][`Game` object], e
fora do escopo deste tutorial.

:::

Atualize seu código:

```dart
class GamePage extends StatefulWidget {
  GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          for (var guess in _game.guesses)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var letter in guess)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2.5, vertical: 2.5),
                    child: Tile(letter),
                  )
              ],
            ),
          GuessInput(
           onSubmitGuess: (String guess) {
              setState(() { // NEW
                _game.guess(guess);
              });
            },
          ),
        ],
      ),
    );
  }
}
```

Agora, quando você digita um palpite válido no `TextInput` e o submete,
a aplicação refletirá o palpite do usuário. Se você chamar
`_game.guess(guess)` *sem* chamar `setState`, os dados internos do jogo
mudariam, mas o Flutter não saberia que precisa repintar a
tela, e o usuário não veria nenhuma atualização.

["quick assists"]: /tools/android-studio#assists-quick-fixes
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[`Game` object]: https://github.com/flutter/demos
