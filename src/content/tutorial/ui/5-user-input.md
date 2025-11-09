---
ia-translate: true
title: Entrada do usuário
description: Aceite entrada do usuário com botões e campos de texto
permalink: /tutorial/user-input/
sitemap: false
---

{%- comment %} TODO(ewindmill) embed video {%- endcomment %}


O app exibirá os palpites do usuário nos widgets `Tile`,
mas precisa de uma maneira para o usuário inserir esses palpites. Nesta lição,
construa essa funcionalidade com dois widgets de interação: [`TextField`][] e
[`IconButton`][].

## Implemente funções de callback

Para permitir que os usuários digitem seus palpites, você criará um
widget dedicado chamado `GuessInput`. Primeiro, crie a estrutura básica para seu
widget `GuessInput` que requer uma função de callback como argumento.
Nomeie a função de callback `onSubmitGuess`.

Adicione o seguinte código ao seu arquivo `main.dart`.

```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  @override
  Widget build(BuildContext context) {
    // You'll build the UI in the next steps
    return Container(); // Placeholder
  }
}
```

A linha `final void Function(String) onSubmitGuess;`
declara um membro `final` da classe chamado `onSubmitGuess`
que tem o tipo `void Function(String)`. Esta função recebe um
único argumento `String` (o palpite do usuário) e não retorna nenhum
valor (denotado por `void`).

Este callback nos diz que a lógica que realmente lida com o palpite do
usuário será escrita em outro lugar. É uma boa prática para widgets interativos
usar funções de callback para manter o widget
que lida com interações reutilizável e desacoplado de qualquer
funcionalidade específica.

Ao final desta lição, a função `onGuessSubmitted` passada
é chamada quando um usuário insere um palpite. Primeiro, você precisará construir
as partes visuais deste widget. É assim que o widget ficará.

<img src='/assets/images/docs/tutorial/app_with_input.png' alt="A screenshot of the Flutter property editor tool.">

## O widget `TextField`

Dado que o campo de texto e o botão são exibidos lado a lado,
crie-os como um widget `Row`. Substitua o placeholder `Container` no seu
método `build` por uma `Row` contendo um `TextField` `Expanded`:

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

Você viu alguns desses widgets em lições anteriores: `Row` e
`Padding`. Novo, porém, é o widget [`Expanded`][]. Quando um filho de
uma `Row` (ou `Column`) é envolvido em `Expanded`, ele diz àquele filho para
preencher todo o espaço disponível ao longo do eixo principal (horizontal para
`Row`, vertical para `Column`) que não foi ocupado por outros
filhos. Isso faz o `TextField` esticar para ocupar todo o espaço
*exceto* o que foi ocupado por outros widgets na linha.

:::tip Dica
`Expanded` é frequentemente a solução para exceções de "[largura/altura ilimitada][unbounded width/height]".
:::

O widget `TextField` também é novo nesta lição e é a estrela do show.
Este é o widget básico do Flutter para entrada de texto.

Até agora, `TextField` tem a seguinte configuração.

* Ele é decorado com uma borda arredondada. Note que a configuração de
  decoração é muito similar a como um `Container` e caixas são decorados.
* Sua propriedade `maxLength` está definida como 5 porque o jogo só
  permite palpites de palavras de 5 letras.

## Lide com texto com `TextEditingController`

Em seguida, você precisa de uma maneira de gerenciar o texto que o usuário digita no
campo de entrada. Para isso, use um [`TextEditingController`][].

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

Um `TextEditingController` é usado para ler, limpar e modificar o texto
em um `TextField`. Para usá-lo, passe-o para o `TextField`.

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
              inputDecoration: InputDecoration(
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

Agora, quando um usuário insere texto, você pode capturá-lo com o
`_textEditingController`, mas você precisará saber *quando* capturá-lo.
A maneira mais simples de reagir à entrada é usando o
argumento `TextField.onSubmitted`. Este argumento aceita um callback,
e o callback é acionado sempre que o usuário pressiona a
tecla "Enter" no teclado enquanto o campo de texto tem foco.

Por enquanto, garanta que isso funcione adicionando o seguinte callback a
`TextField.onSubmitted`.

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
              inputDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              onSubmitted: (String input) { // NEW
                print(_textEditingController.text); // Temporary
              }
            ),
          ),
        ),
      ],
    );
  }
}
```

Neste caso, você poderia imprimir o `input` passado para o callback `onSubmitted`
diretamente, mas uma melhor experiência do usuário limpa o texto
após cada palpite: Você precisa de um `TextEditingController` para
fazer isso. Atualize o código da seguinte forma:

:::note
No Dart, é uma boa prática usar o [wildcard][] `_` para
ocultar a entrada de uma função que nunca será usada. O seguinte
exemplo faz isso.
:::


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
              inputDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              onSubmitted: (_) { // UPDATED
                print(_textEditingController.text); // Temporary
                _textEditingController.clear(); // NEW
              }
            ),
          ),
        ),
      ],
    );
  }
}
```

## Ganhe foco na entrada

Frequentemente, você quer que uma entrada ou widget específico ganhe foco automaticamente
sem que o usuário tome uma ação. Neste app, por exemplo, a única
coisa que um usuário pode fazer é inserir um palpite, então o `TextField` deve
ter foco automaticamente quando o app é iniciado. E depois que o usuário
insere um palpite, o foco deve permanecer no `TextField` para que eles possam
inserir seu próximo palpite.

Para resolver o primeiro problema de foco, configure a propriedade `autoFocus` no `TextField`.

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
              inputDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
		          controller: _textEditingController,
		          autoFocus: true // NEW
		          onSubmitted: (String input) {
                print(input); // Temporary
                _textEditingController.clear();
              }
 		        ),
          ),
        ),
      ],
    );
  }
}
```

O segundo problema requer que você use um [`FocusNode`][] para
gerenciar o foco do teclado. Você pode usar `FocusNode` para solicitar
que um `TextField` ganhe foco (fazendo o teclado aparecer no mobile),
ou para saber quando um campo tem foco.

Primeiro, crie um `FocusNode` na classe `GuessInput`:

```dart
class GuessInput extends StatelessWidget {
  GuessInput({super.key, required this.onSubmitGuess});

  final void Function(String) onSubmitGuess;

  final TextEditingController _textEditingController = TextEditingController();

  final FocusNode _focusNode = FocusNode(); // NEW

  @override
  Widget build(BuildContext context) {
    // ...
  }
}
```

Então, use o `FocusNode` para solicitar foco sempre que o `TextField` é
submetido após o controller ser limpo:

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
              inputDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autoFocus: true
              focusNode: _focusNode, // NEW
              onSubmitted: (String input) {
                print(input); // Temporary
                _textEditingController.clear();
                _focusNode.requestFocus(); // NEW
              }
            ),
          ),
        ),
      ],
    );
  }
}
```

Agora, quando você pressiona 'Enter' após inserir texto, você pode continuar digitando.

## Use a entrada

Finalmente, você precisa lidar com o texto que o usuário insere.
Lembre-se de que o construtor para `GuessInput` requer um callback chamado
`onGuessSubmitted`. Em `GuessInput`, você precisa usar esse callback.
Substitua a instrução `print` por uma chamada para essa função.

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
              inputDecoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autoFocus: true
              focusNode: _focusNode,
              onSubmitted: (String input) {
                onSubmitGuess(_textEditionController.text.trim())
                _textEditingController.clear();
                _focusNode.requestFocus();
              }
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
caso contrário, o usuário poderia inserir uma palavra de quatro letras mais um espaço em branco.
:::

A funcionalidade restante é tratada no widget pai,
`GamePage`. No método `build` dessa classe, adicione o
widget `GuessInput` sob os widgets `Row` nos
filhos da `Column`.

```dart
class GamePage extends StatelessWidget {
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
                for (var letter in guess) Tile(letter),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              // TODO, handle guess
              print(guess); // Temporary
            }
          ),
        ],
      ),
    );
  }
}
```

Por enquanto, isso apenas imprime o palpite para provar que está conectado
corretamente. Submeter o palpite requer usar a funcionalidade
de um `StatefulWidget`, o que você fará na [lição sobre `StatefulWidget`][`StatefulWidget` lesson].

## Botões

Para melhorar a UX no mobile e refletir uma UI bem conhecida, também deve
haver um botão que possa submeter o palpite.

Existem muitos widgets de botão integrados ao Flutter, como [`TextButton`][],
[`ElevatedButton`][], e o botão que você usará agora: [`IconButton`][]. Todos esses
botões (e muitos outros widgets de interação) requerem dois
argumentos (além de seus argumentos opcionais):

* Uma função de callback passada para `onPressed`.
* Um widget que compõe o conteúdo do botão (frequentemente `Text` ou um `Icon`).

Adicione um botão de ícone à lista de filhos do widget row no
widget `GuessInput`, e dê a ele um widget [`Icon`][] para exibir.
O widget `Icon` requer configuração; neste caso, a
propriedade `padding` define o padding entre a borda do
botão e o ícone que ele envolve como zero. Isso remove o padding
padrão e torna o botão menor.

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
        Expanded(...),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_circle_up),
        ),
      ],
    );
  }
}
```

O callback `IconButton.onPressed` deve parecer familiar:

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
        Expanded(...),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_circle_up),
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

:::note Desafio - Compartilhe a lógica "on submitted".

Você pode estar pensando, "Não deveríamos abstrair esses métodos em uma
função e passá-la para ambas as entradas?" Você poderia, e conforme seu app cresce
em complexidade, provavelmente deveria. Dito isso, os callbacks
`IconButton.onPressed` e `TextField.onSubmitted` têm
assinaturas diferentes, então não é completamente direto.

Refatore o código de modo que a lógica dentro desses métodos não seja repetida.

**Solução**

```dart
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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              onSubmitted: (String value) {
                _onSubmit();
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_circle_up),
          onPressed: _onSubmit,
        ),
      ],
    );
  }
}
```

:::


[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[unbounded width/height]: https://www.youtube.com/watch?v=jckqXR5CrPI
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[wildcard]: {{site.dart-site}}/language/pattern-types#wildcard
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[`StatefulWidget` lesson]: /tutorial/stateful-widget
[`Icon`]: {{site.api}}/flutter/material/Icons-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
