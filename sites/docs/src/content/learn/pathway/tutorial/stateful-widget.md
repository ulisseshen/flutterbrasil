---
ia-translate: true
title: Stateful widgets
description: Aprenda sobre StatefulWidgets e reconstrução de UI Flutter.
layout: tutorial
---

Aprenda quando widgets precisam ser stateful e como disparar atualizações de UI com setState.

<YouTubeEmbed id="Gzz8FwSlsUg" title="Stateful widgets in Flutter" fullWidth="true"></YouTubeEmbed>

<SummaryCard>
title: O que você vai realizar
items:
  - title: Aprender quando widgets precisam ser stateful
    icon: change_circle
  - title: Converter um StatelessWidget em um StatefulWidget
    icon: swap_horiz
  - title: Disparar atualizações de UI com setState
    icon: refresh
</SummaryCard>

---

### Introdução {:#introduction}

Até agora, seu app exibe uma grade e um campo de entrada,
mas a grade ainda não atualiza para refletir os palpites do usuário.
Quando este app estiver completo, cada tile na próxima linha não preenchida deve
atualizar após cada palpite do usuário submetido:

- Exibindo a letra correta.
- Mudando de cor para refletir se a letra está correta (verde),
  está na palavra mas em uma posição incorreta (amarelo), ou
  não aparece na palavra de forma alguma (cinza).

Para lidar com este comportamento dinâmico, você precisa converter `GamePage` de um
`StatelessWidget` para um [`StatefulWidget`][].

[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html

### Por que stateful widgets? {:#why-stateful-widgets}

Quando a aparência ou os dados de um widget precisam mudar durante seu tempo de vida,
você precisa de um `StatefulWidget` e um objeto `State` companheiro.
Enquanto o `StatefulWidget` em si ainda é imutável (suas propriedades
não podem mudar após a criação), o objeto `State` é duradouro,
pode conter dados mutáveis e pode ser reconstruído quando esses dados mudam,
fazendo a UI atualizar.

Por exemplo, a seguinte árvore de widgets imagina um app simples
que usa um stateful widget com um contador que
aumenta quando o botão é pressionado.

<img src='/assets/images/docs/tutorial/widget_tree_stateful.png' width="320px" alt="A diagram of a widget tree with a stateful widget and state object.">

Aqui está a estrutura básica de `StatefulWidget` (ainda não faz nada):

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

### Converta `GamePage` para um stateful widget {:#convert-gamepage-to-a-stateful-widget}

Para converter o widget `GamePage` (ou qualquer outro) de
um stateless widget para um stateful widget, siga os seguintes passos:

1.  Altere `GamePage` para estender `StatefulWidget` em vez de `StatelessWidget`.
1.  Crie uma nova classe chamada `_GamePageState`, que estende `State<GamePage>`.
    Esta nova classe conterá o estado mutável e o método `build`.
    Mova o método `build` e todas as propriedades *instanciadas no widget*
    de `GamePage` para o objeto state.
1.  Implemente o método `createState()` em `GamePage`, que
    retorna uma instância de `_GamePageState`.

:::tip Quick assists

Você não precisa fazer este trabalho manualmente, já que os plugins Flutter para
VS Code e IntelliJ fornecem ["quick assists"][] que podem
fazer esta conversão para você.

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
                    child: Tile(letter.char, letter.type),
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

["quick assists"]: /tools/android-studio#assists-quick-fixes

### Atualizando a UI com `setState` {:#updating-the-ui-with-setstate}

Sempre que você mutar um objeto `State`,
você deve chamar [`setState`][] para sinalizar ao framework para
atualizar a interface do usuário e chamar o método `build` novamente.

Neste app, quando um usuário faz um palpite, a palavra que ele adivinhou é
salva no objeto `Game`, que é uma propriedade na classe `GamePage`,
e portanto é um estado que pode mudar e exigir que a UI atualize.
Quando este estado é mutado, a grade deve ser
redesenhada para mostrar o palpite do usuário.

Para implementar isso, atualize a função de callback passada para `GuessInput`.
A função precisa chamar `setState` e, dentro de `setState`,
ela precisa executar a lógica para determinar se o palpite do usuário estava correto.

:::note

A lógica do jogo é abstraída no objeto `Game`,
e está fora do escopo deste tutorial.

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
                    child: Tile(letter.char, letter.type),
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
a aplicação refletirá o palpite do usuário.
Se você chamar `_game.guess(guess)` *sem* chamar `setState`,
os dados internos do jogo mudariam, mas o Flutter não saberia que
precisa repintar a tela, e o usuário não veria nenhuma atualização.

[`setState`]: {{site.api}}/flutter/widgets/State/setState.html

### Converta `GuessInput` para um stateful widget {:#convert-guessinput-to-a-stateful-widget}

Quando `GamePage` é reconstruído após chamar `setState`,
todos os seus widgets filhos também são reconstruídos.
Como `GuessInput` foi criado originalmente como um `StatelessWidget`,
seu `TextEditingController` e seu `FocusNode` eram armazenados diretamente na classe do widget.
Como uma nova instância do widget é criada a cada reconstrução, esses controllers
eram recriados toda vez, fazendo o campo de entrada de texto perder o foco
e deixando controllers não utilizados sem o descarte adequado.

Para manter o foco no campo de texto entre os palpites e
gerenciar corretamente o ciclo de vida dos controllers,
converta `GuessInput` em um `StatefulWidget`:

1. Altere `GuessInput` para estender `StatefulWidget` em vez de `StatelessWidget`.
1. Crie uma classe companheira `_GuessInputState` que estende `State<GuessInput>`.
1. Mova `_textEditingController`, `_focusNode`, `_onSubmit()` e `build()`
   para `_GuessInputState`.
1. Implemente `dispose()` para liberar `_textEditingController` e `_focusNode`.

Seu widget `GuessInput` modificado deve ficar assim:

<?code-excerpt "fwe/birdle/lib/step5_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  State<GuessInput> createState() => _GuessInputState();
}

class _GuessInputState extends State<GuessInput> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit() {
    widget.onSubmitGuess(_textEditingController.text.trim());
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              focusNode: _focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              onSubmitted: (input) {
                _onSubmit();
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit,
        ),
      ],
    );
  }
}
```

Ao converter `GuessInput` para um `StatefulWidget`,
`_GuessInputState` persiste entre as reconstruções do pai,
mantendo o foco no campo de texto após cada palpite submetido
e descartando adequadamente os recursos quando o widget é desmontado.

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Aprendeu quando widgets precisam ser stateful
    icon: change_circle
    details: >-
      Quando a aparência ou os dados de um widget precisam mudar durante seu tempo de vida,
      você precisa de um `StatefulWidget`. O widget em si permanece imutável, mas
      seu objeto `State` companheiro contém dados mutáveis e dispara reconstruções.
  - title: Converteu GamePage e GuessInput em StatefulWidgets
    icon: swap_horiz
    details: >-
      Você refatorou `GamePage` e `GuessInput` para serem stateful
      criando classes `State` companheiras, movendo para elas as propriedades mutáveis e
      o gerenciamento de ciclo de vida (como `dispose`), e
      implementando `createState()`.
      O suporte da sua IDE a quick assists pode automatizar essa conversão.
  - title: Fez seu app responder à entrada do usuário com setState
    icon: refresh
    details: >-
      Chamar `setState` diz ao Flutter para reconstruir a UI de um widget.
      Quando um usuário submete um palpite, você chama `setState` para atualizar o estado do jogo,
      e a grade reflete automaticamente os novos dados enquanto mantém o foco no campo de texto.
      Seu app agora é realmente interativo!
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz sobre Stateful Widgets">
- question: Quando você deve usar um StatefulWidget em vez de um StatelessWidget?
  options:
    - text: Quando o widget precisa fazer requisições HTTP.
      correct: false
      explanation: Requisições HTTP podem ser feitas a partir de qualquer um deles, mas mudanças de estado exigem StatefulWidget.
    - text: Quando a aparência ou os dados do widget precisam mudar durante seu tempo de vida.
      correct: true
      explanation: StatefulWidget é necessário quando a UI precisa ser atualizada em resposta a mudanças de dados ao longo do tempo.
    - text: Quando o widget tem mais de três widgets filhos.
      correct: false
      explanation: O número de filhos não determina se um widget é stateful.
    - text: Quando o widget está na raiz da árvore de widgets.
      correct: false
      explanation: Widgets raiz podem ser stateless; ser stateful depende de os dados mudarem durante o tempo de vida do widget.
- question: O que acontece se você alterar dados em um objeto State sem chamar setState?
  options:
    - text: O app vai travar com um erro.
      correct: false
      explanation: O app não vai travar, mas a UI não será atualizada.
    - text: Os dados mudam internamente, mas o Flutter não reconstrói a UI para refletir a mudança.
      correct: true
      explanation: Sem chamar setState, o Flutter não sabe que precisa repintar, então o usuário não verá atualizações.
    - text: O Flutter detecta a mudança automaticamente e reconstrói a UI.
      correct: false
      explanation: O Flutter precisa de setState para saber quando reconstruir; ele não detecta mudanças automaticamente.
    - text: O widget é removido da árvore de widgets.
      correct: false
      explanation: O widget permanece; ele apenas não será atualizado visualmente sem setState.
</Quiz>
