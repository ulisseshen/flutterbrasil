---
ia-translate: true
title: Entrada do usuário
description: Aceite entrada do usuário com botões e campos de texto.
layout: tutorial
---

Aprenda a construir entradas de texto, gerenciar texto com controllers e lidar com ações do usuário com botões.

<SummaryCard>
title: O que você vai realizar
items:
  - title: Construir um widget de entrada de texto com TextField
    icon: text_fields
  - title: Gerenciar texto com TextEditingController
    icon: edit_note
  - title: Controlar o foco da entrada para uma melhor experiência do usuário
    icon: center_focus_strong
  - title: Lidar com ações do usuário com callbacks e botões
    icon: touch_app
</SummaryCard>

---

### Introdução {:#introduction}

O app exibirá os palpites do usuário nos widgets `Tile`,
mas precisa de uma maneira para o usuário inserir esses palpites.
Nesta lição, construa essa funcionalidade com dois widgets de interação:
[`TextField`][] e [`IconButton`][].

[`TextField`]: {{site.material_ui}}/TextField-class.html
[`IconButton`]: {{site.material_ui}}/IconButton-class.html

### Implemente funções de callback {:#implement-callback-functions}

Para permitir que os usuários digitem seus palpites,
você criará um widget dedicado chamado `GuessInput`.
Primeiro, crie a estrutura básica para seu widget `GuessInput` que
requer uma função de callback como argumento.
Nomeie a função de callback `onSubmitGuess`.

Adicione o seguinte código ao seu arquivo `main.dart`.

<?code-excerpt "fwe/birdle/lib/step4a_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  Widget build(BuildContext context) {
    // You'll build the UI in the next steps.
    return Container(); // Placeholder
  }
}
```

A linha `final void Function(String) onSubmitGuess;`
declara um membro `final` da classe chamado `onSubmitGuess`
que tem o tipo `void Function(String)`.
Esta função recebe um único argumento `String` (o palpite do usuário) e
não retorna nenhum valor (denotado por `void`).

Este callback nos diz que a lógica que
realmente lida com o palpite do usuário será escrita em outro lugar.
É uma boa prática para widgets interativos
usar funções de callback para manter o widget que lida com interações reutilizável e
desacoplado de qualquer funcionalidade específica.

Ao final desta lição, a função `onSubmitGuess` passada
é chamada quando um usuário insere um palpite.
Primeiro, você precisará construir as partes visuais deste widget.
É assim que o widget ficará.

<img src='/assets/images/docs/tutorial/app_with_input.png' width="320px" alt="A screenshot of the Flutter property editor tool.">

### O widget `TextField` {:#the-textfield-widget}

Dado que o campo de texto e o botão são exibidos lado a lado,
crie-os como um widget `Row`.
Substitua o placeholder `Container` no seu método `build` por
uma `Row` contendo um `TextField` `Expanded`:

<?code-excerpt "fwe/birdle/lib/step4b_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
```

Você viu alguns desses widgets em lições anteriores:
`Row` e `Padding`. Novo, porém, é o widget [`Expanded`][].
Quando um filho de uma `Row` (ou `Column`) é envolvido em `Expanded`,
ele diz àquele filho para preencher todo o espaço disponível ao longo do eixo principal
(horizontal para `Row`, vertical para `Column`) que
não foi ocupado por outros filhos.
Isso faz o `TextField` esticar para ocupar todo o espaço *exceto*
o que foi ocupado por outros widgets na linha.

:::tip
`Expanded` é frequentemente a solução para exceções de "[largura/altura ilimitada][unbounded width/height]".
:::

O widget `TextField` também é novo nesta lição e é a estrela do show.
Este é o widget básico do Flutter para entrada de texto.

Até agora, `TextField` tem a seguinte configuração.

- Ele é decorado com uma borda arredondada.
  Note que a configuração de decoração é
  muito similar a como um `Container` e caixas são decorados.
- Sua propriedade `maxLength` está definida como 5 porque o jogo
  só permite palpites de palavras de 5 letras.

[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[unbounded width/height]: https://www.youtube.com/watch?v=jckqXR5CrPI

### Lide com texto com `TextEditingController` {:#handle-text-with-texteditingcontroller}

Em seguida, você precisa de uma maneira de gerenciar o texto que
o usuário digita no campo de entrada.
Para isso, use um [`TextEditingController`][].

<?code-excerpt "fwe/birdle/lib/step4c_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  // NEW
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
            ),
          ),
        ),
        //
      ],
    );
  }
}
```

Um `TextEditingController` é usado para
ler, limpar e modificar o texto em um `TextField`.
Para usá-lo, passe-o para o `TextField`.

<?code-excerpt "fwe/birdle/lib/step4d_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController, // NEW
            ),
          ),
        ),
      ],
    );
  }
}
```

Agora, quando um usuário insere texto, você pode
capturá-lo com o `_textEditingController`, mas
você precisará saber _quando_ capturá-lo.
A maneira mais simples de reagir à entrada é
usando o argumento `TextField.onSubmitted`.
Este argumento aceita um callback, e o callback é acionado sempre que
o usuário pressiona a tecla "Enter" no teclado enquanto o campo de texto tem foco.

Por enquanto, garanta que isso funcione
adicionando o seguinte callback a `TextField.onSubmitted`:

<?code-excerpt "fwe/birdle/lib/step4e_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              onSubmitted: (input) {
                // NEW
                print(_textEditingController.text); // Temporary
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

Neste caso,
você poderia imprimir o `input` passado para o callback `onSubmitted` diretamente,
mas uma melhor experiência do usuário limpa o texto após cada palpite:
Você precisa de um `TextEditingController` para fazer isso. Atualize o código da seguinte forma:

<?code-excerpt "fwe/birdle/lib/step4f_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              onSubmitted: (_) {
                // UPDATED
                print(_textEditingController.text); // Temporary
                _textEditingController.clear(); // NEW
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

:::note
No Dart, é uma boa prática usar o [wildcard][] `_` para
ocultar a entrada de uma função que nunca será usada.
O exemplo anterior faz isso.
:::

[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[wildcard]: {{site.dart-site}}/language/variables#wildcard-variables

### Ganhe foco na entrada {:#gain-input-focus}

Frequentemente, você quer que uma entrada ou widget específico
ganhe foco automaticamente sem que o usuário tome uma ação.
Neste app, por exemplo, a única coisa que um usuário pode fazer é inserir um palpite,
então o `TextField` deve ter foco automaticamente quando o app é iniciado.
E depois que o usuário insere um palpite, o foco deve permanecer
no `TextField` para que ele possa inserir seu próximo palpite.

Para resolver o primeiro problema de foco,
configure a propriedade `autofocus` no `TextField`.

<?code-excerpt "fwe/birdle/lib/step4g_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true, // NEW
              onSubmitted: (input) {
                print(input); // Temporary
                _textEditingController.clear();
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

O segundo problema requer que você
use um [`FocusNode`][] para gerenciar o foco do teclado.
Você pode usar `FocusNode` para solicitar que um `TextField` ganhe foco
(fazendo o teclado aparecer no mobile),
ou para saber quando um campo tem foco.

Primeiro, crie um `FocusNode` na classe `GuessInput`:

<?code-excerpt "fwe/birdle/lib/step4h_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode(); // NEW

  @override
  Widget build(BuildContext context) {
    // ...
    return Container();
  }
}
```

Então, use o `FocusNode` para solicitar foco sempre que
o `TextField` é submetido após o controller ser limpo:

<?code-excerpt "fwe/birdle/lib/step4i_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode, // NEW
              onSubmitted: (input) {
                print(input); // Temporary
                _textEditingController.clear();
                _focusNode.requestFocus(); // NEW
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

Agora, quando você pressiona <kbd>Enter</kbd> após inserir texto,
você pode continuar digitando.

[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html

### Use a entrada {:#use-the-input}

Finalmente, você precisa lidar com o texto que o usuário insere.
Lembre-se de que o construtor para `GuessInput` requer um
callback chamado `onSubmitGuess`.
Em `GuessInput`, você precisa usar esse callback.
Substitua a instrução `print` por uma chamada para essa função.

<?code-excerpt "fwe/birdle/lib/step4j_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              onSubmitted: (input) {
                onSubmitGuess(_textEditingController.text.trim());
                _textEditingController.clear();
                _focusNode.requestFocus();
              },
            ),
          ),
        ),
      ],
    );
  }
}
```

:::note
A função `trim` evita que espaços em branco sejam inseridos;
caso contrário, o usuário poderia inserir uma palavra de quatro letras mais um caractere de espaço.
:::

A funcionalidade restante é tratada no widget pai, `GamePage`.
No método `build` dessa classe,
sob os widgets `Row` nos filhos do widget `Column`,
adicione o widget `GuessInput`:

<?code-excerpt "fwe/birdle/lib/step4k_main.dart (GamePage)"?>
```dart
class GamePage extends StatelessWidget {
  GamePage({super.key});

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
          GuessInput(
            onSubmitGuess: (guess) {
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

Por enquanto, isso apenas imprime o palpite para
provar que está conectado corretamente.
Submeter o palpite requer usar a funcionalidade de um `StatefulWidget`,
o que você fará na próxima lição.

### Botões {:#buttons}

Para melhorar a UX no mobile e refletir práticas de UI bem conhecidas,
também deve haver um botão que possa submeter o palpite.

Existem muitos widgets de botão integrados ao Flutter, como [`TextButton`][],
[`ElevatedButton`][], e o botão que você usará agora: [`IconButton`][].
Todos esses botões (e muitos outros widgets de interação) requerem dois
argumentos (além de seus argumentos opcionais):

- Uma função de callback passada para `onPressed`.
- Um widget que compõe o conteúdo do botão (frequentemente `Text` ou um `Icon`).

Adicione um botão de ícone à lista de filhos do widget row no widget `GuessInput`,
e dê a ele um widget [`Icon`][] para exibir.
O widget `Icon` requer configuração; neste caso,
a propriedade `padding` define o padding entre a
borda do botão e o ícone que ele envolve como zero.
Isso remove o padding padrão e torna o botão menor.

<?code-excerpt "fwe/birdle/lib/step4l_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: null,
        ),
      ],
    );
  }
}
```

O callback `IconButton.onPressed` deve parecer familiar:

<?code-excerpt "fwe/birdle/lib/step4m_main.dart (GuessInput)"?>
```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Container()),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: () {
            onSubmitGuess(_textEditingController.text.trim());
            _textEditingController.clear();
            _focusNode.requestFocus();
          },
        ),
      ],
    );
  }
}
```

Este método faz o mesmo que o callback `onSubmitted` no `TextField`.

[`Icon`]: {{site.material_ui}}/Icons-class.html
[`TextButton`]: {{site.material_ui}}/TextButton-class.html
[`ElevatedButton`]: {{site.material_ui}}/ElevatedButton-class.html
[`IconButton`]: {{site.material_ui}}/IconButton-class.html

:::note Desafio - Compartilhe a lógica "on submitted".

Você pode estar pensando, "Não deveríamos abstrair esses métodos em uma
função e passá-la para ambas as entradas?"
Você poderia, e conforme seu app cresce em complexidade, provavelmente deveria.
Dito isso, os callbacks `IconButton.onPressed` e `TextField.onSubmitted` têm
assinaturas diferentes, então não é completamente direto.

Refatore o código de modo que a lógica dentro desse método não seja repetida.

**Solução:**

<?code-excerpt "fwe/birdle/lib/step4_main.dart (GuessInput)"?>
```dart title="solution.dart" collapsed
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  void _onSubmit() {
    onSubmitGuess(_textEditingController.text);
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
              onSubmitted: (value) {
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

:::

### Revisão {:#review}


<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Construiu um widget de entrada de texto com TextField
    icon: text_fields
    details: >-
      Você criou um widget `GuessInput` com um `TextField` para entrada de texto.
      Você o configurou com uma borda arredondada, um limite de caracteres e
      usou `Expanded` para fazê-lo preencher o espaço disponível na linha.
  - title: Gerenciou texto com TextEditingController
    icon: edit_note
    details: >-
      `TextEditingController` permite ler e modificar o conteúdo do campo de texto.
      Você o usou para capturar a entrada do usuário com `.text` e limpar o
      campo após o envio com `.clear()`.
  - title: Controlou o foco da entrada para uma UX refinada
    icon: center_focus_strong
    details: >-
      Você usou `autofocus` para focar o campo de texto ao iniciar e `FocusNode`
      com `requestFocus()` para manter o foco após cada palpite.
      Esses detalhes fazem seu app parecer responsivo e bem construído.
  - title: Lidou com ações do usuário com callbacks e botões
    icon: touch_app
    details: >-
      Para responder à entrada do usuário,
      você especificou funções de callback como `onSubmitted` e `onPressed`.
      Passar funções de callback como argumentos do construtor mantém seus
      widgets reutilizáveis e desacoplados de lógica específica.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de entrada do usuário">
- question: Como você lê ou limpa programaticamente o texto em um TextField?
  options:
    - text: Acessar diretamente a propriedade text do TextField.
      correct: false
      explanation: TextField não expõe uma propriedade text; você precisa de um controller.
    - text: Usar o TextEditingController associado ao TextField.
      correct: true
      explanation: TextEditingController fornece a propriedade text para ler o valor e o método clear() para redefini-lo.
    - text: Ouvir o callback onChanged e armazenar o valor em uma variável.
      correct: false
      explanation: Embora onChanged funcione para leitura, limpar requer um TextEditingController.
    - text: Chamar o método TextField.getText().
      correct: false
      explanation: TextField não tem um método getText; use TextEditingController em vez disso.
- question: Como você move programaticamente o foco para um TextField específico?
  options:
    - text: "Chamar `TextField.focus()` diretamente."
      correct: false
      explanation: TextField não tem um método focus; você usa um FocusNode.
    - text: "Definir a propriedade `autofocus` como true em tempo de execução."
      correct: false
      explanation: A propriedade 'autofocus' só funciona no build inicial, não para mover o foco depois.
    - text: "Usar um FocusNode e chamar `requestFocus()` nele."
      correct: true
      explanation: "Um FocusNode dá a você controle sobre o foco, e chamar `requestFocus()` move o foco para seu widget associado."
    - text: Envolver o TextField em um GestureDetector e tocar programaticamente.
      correct: false
      explanation: Não é assim que o foco é gerenciado; FocusNode é a abordagem correta.
</Quiz>
