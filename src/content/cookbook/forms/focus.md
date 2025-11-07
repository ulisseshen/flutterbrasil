---
title: Focus e text fields
description: Como funciona o focus com text fields.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/forms/focus/"?>

Quando um text field é selecionado e está aceitando entrada de dados,
dizemos que ele tem "focus".
Geralmente, usuários movem o focus para um text field tocando nele,
e desenvolvedores movem o focus para um text field programaticamente
usando as ferramentas descritas nesta receita.

Gerenciar o focus é uma ferramenta fundamental para criar forms com um fluxo
intuitivo. Por exemplo, digamos que você tem uma tela de busca com um text field.
Quando o usuário navega para a tela de busca,
você pode definir o focus para o text field do termo de busca.
Isso permite que o usuário comece a digitar assim que a tela
estiver visível, sem precisar tocar manualmente no text field.

Nesta receita, aprenda como dar focus
a um text field assim que ele estiver visível,
bem como dar focus a um text field
quando um botão for tocado.

## Dar focus a um text field assim que ele estiver visível

Para dar focus a um text field assim que ele estiver visível,
use a propriedade `autofocus`.

```dart
TextField(
  autofocus: true,
);
```

Para mais informações sobre como lidar com entrada de dados e criar text fields,
veja a seção [Forms][] do cookbook.

## Dar focus a um text field quando um botão for tocado

Em vez de mover imediatamente o focus para um text field específico,
você pode precisar dar focus a um text field em um momento posterior.
No mundo real, você também pode precisar dar focus a um text field específico
em resposta a uma chamada de API ou erro de validação.
Neste exemplo, dê focus a um text field depois que o usuário
pressionar um botão usando os seguintes passos:

  1. Criar um `FocusNode`.
  2. Passar o `FocusNode` para um `TextField`.
  3. Dar focus ao `TextField` quando um botão for tocado.

### 1. Criar um `FocusNode`

Primeiro, crie um [`FocusNode`][].
Use o `FocusNode` para identificar um `TextField` específico na
"árvore de focus" do Flutter. Isso permite que você dê focus ao `TextField`
nos próximos passos.

Como focus nodes são objetos de longa duração, gerencie o ciclo de vida
usando um objeto `State`. Use as instruções a seguir para criar
uma instância de `FocusNode` dentro do método `initState()` de uma
classe `State`, e limpe-o no método `dispose()`:

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
  return TextField(
    focusNode: myFocusNode,
  );
}
```

### 3. Dar focus ao `TextField` quando um botão for tocado

Finalmente, dê focus ao text field quando o usuário tocar em um floating
action button. Use o método [`requestFocus()`][] para realizar
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
    return const MaterialApp(
      title: 'Text Field Focus',
      home: MyCustomForm(),
    );
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
      appBar: AppBar(
        title: const Text('Text Field Focus'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // The first text field is focused on as soon as the app starts.
            const TextField(
              autofocus: true,
            ),
            // The second text field is focused on when a user taps the
            // FloatingActionButton.
            TextField(
              focusNode: myFocusNode,
            ),
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
  <img src="/assets/images/docs/cookbook/focus.gif" alt="Text Field Focus Demo" class="site-mobile-screenshot" />
</noscript>


[fix has landed]: {{site.repo.flutter}}/pull/50372
[`FocusNode`]: {{site.api}}/flutter/widgets/FocusNode-class.html
[Forms]: /cookbook#forms
[flutter/flutter@bf551a3]: {{site.repo.flutter}}/commit/bf551a31fe7ef45c854a219686b6837400bfd94c
[Issue 52221]: {{site.repo.flutter}}/issues/52221
[`requestFocus()`]: {{site.api}}/flutter/widgets/FocusNode/requestFocus.html
[workaround]: {{site.repo.flutter}}/issues/52221#issuecomment-598244655
