---
ia-translate: true
title: Foco e campos de texto
description: Como o foco funciona com campos de texto.
---

<?code-excerpt path-base="cookbook/forms/focus/"?>

Quando um campo de texto é selecionado e aceita entrada,
diz-se que ele possui "foco" (_focus_).
Geralmente, os usuários movem o foco para um campo de texto tocando nele,
e os desenvolvedores movem o foco para um campo de texto programaticamente
usando as ferramentas descritas nesta receita.

Gerenciar o foco é uma ferramenta fundamental para criar formulários com um fluxo
intuitivo. Por exemplo, digamos que você tenha uma tela de busca com um campo de texto.
Quando o usuário navega para a tela de busca,
você pode definir o foco para o campo de texto do termo de busca.
Isso permite que o usuário comece a digitar assim que a tela
estiver visível, sem precisar tocar manualmente no campo de texto.

Nesta receita, aprenda como dar foco
a um campo de texto assim que ele estiver visível,
bem como dar foco a um campo de texto
quando um botão for tocado.

## Dar foco a um campo de texto assim que ele estiver visível

Para dar foco a um campo de texto assim que ele estiver visível,
use a propriedade `autofocus`.

```dart
TextField(
  autofocus: true,
);
```

Para mais informações sobre manipulação de entrada e criação de campos de texto,
veja a seção [Forms][Forms] do cookbook.

## Dar foco a um campo de texto quando um botão for tocado

Em vez de imediatamente mover o foco para um campo de texto específico,
você pode precisar dar foco a um campo de texto em um momento posterior.
No mundo real, você também pode precisar dar foco a um campo de texto específico
em resposta a uma chamada de API ou um erro de validação.
Neste exemplo, dê foco a um campo de texto após o usuário
pressionar um botão usando as seguintes etapas:

  1. Criar um `FocusNode`.
  2. Passar o `FocusNode` para um `TextField`.
  3. Dar foco ao `TextField` quando um botão for tocado.

### 1. Criar um `FocusNode`

Primeiro, crie um [`FocusNode`][`FocusNode`].
Use o `FocusNode` para identificar um `TextField` específico na
"árvore de foco" do Flutter. Isso permite que você dê foco ao `TextField`
nas próximas etapas.

Como os nós de foco são objetos de longa duração, gerencie o ciclo de vida
usando um objeto `State`. Use as seguintes instruções para criar
uma instância de `FocusNode` dentro do método `initState()` de uma
classe `State`, e faça a limpeza no método `dispose()`:

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
  }
}
```

### 2. Passar o `FocusNode` para um `TextField`

Agora que você tem um `FocusNode`,
passe-o para um `TextField` específico no método `build()`.

<?code-excerpt "lib/step2.dart (Build)"?>
```dart
@override
Widget build(BuildContext context) {
  return TextField(focusNode: myFocusNode);
}
```

### 3. Dar foco ao `TextField` quando um botão for tocado

Finalmente, dê foco ao campo de texto quando o usuário tocar em um botão
de ação flutuante. Use o método [`requestFocus()`][`requestFocus()`] para realizar
esta tarefa.

<?code-excerpt "lib/step3.dart (FloatingActionButton)" replace="/^floatingActionButton\: //g"?>
```dart
FloatingActionButton(
  // When the button is pressed,
  // give focus to the text field using myFocusNode.
  onPressed: () => myFocusNode.requestFocus(),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter text focus hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Text Field Focus', home: MyCustomForm());
  }
}

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Define the focus node. To manage the lifecycle, create the FocusNode in
  // the initState method, and clean it up in the dispose method.
  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Text Field Focus')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // The first text field is focused on as soon as the app starts.
            const TextField(autofocus: true),
            // The second text field is focused on when a user taps the
            // FloatingActionButton.
            TextField(focusNode: myFocusNode),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the button is pressed,
        // give focus to the text field using myFocusNode.
        onPressed: () => myFocusNode.requestFocus(),
        tooltip: 'Focus Second Text Field',
        child: const Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/focus.webp" alt="Text Field Focus Demo" class="site-mobile-screenshot" />
</noscript>


[fix has landed]: {{site.repo.flutter}}/pull/50372
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[Forms]: /cookbook/forms
[flutter/flutter@bf551a3]: {{site.repo.flutter}}/commit/bf551a31fe7ef45c854a219686b6837400bfd94c
[Issue 52221]: {{site.repo.flutter}}/issues/52221
[`requestFocus()`]: {{site.api}}/flutter/widgets/FocusNode/requestFocus.html
[workaround]: {{site.repo.flutter}}/issues/52221#issuecomment-598244655
