---
title: Recuperar o valor de um text field
description: Como recuperar texto de um text field.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/forms/retrieve_input"?>

Nesta receita,
aprenda como recuperar o texto que um usuário digitou em um text field
usando os seguintes passos:

  1. Criar um `TextEditingController`.
  2. Fornecer o `TextEditingController` para um `TextField`.
  3. Exibir o valor atual do text field.

## 1. Criar um `TextEditingController`

Para recuperar o texto que um usuário digitou em um text field,
crie um [`TextEditingController`][]
e forneça-o para um `TextField` ou `TextFormField`.

:::important
Chame `dispose` do `TextEditingController` quando
você terminar de usá-lo. Isso garante que você descarte quaisquer recursos
usados pelo objeto.
:::

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
  }
}
```

## 2. Fornecer o `TextEditingController` para um `TextField`

Agora que você tem um `TextEditingController`, conecte-o
a um text field usando a propriedade `controller`:

<?code-excerpt "lib/step2.dart (TextFieldController)"?>
```dart
return TextField(
  controller: myController,
);
```

## 3. Exibir o valor atual do text field

Depois de fornecer o `TextEditingController` ao text field,
comece a ler valores. Use o método [`text()`][]
fornecido pelo `TextEditingController` para recuperar a
String que o usuário digitou no text field.

O código a seguir exibe um alert dialog com o valor
atual do text field quando o usuário toca em um floating action button.

<?code-excerpt "lib/step3.dart (FloatingActionButton)" replace="/^floatingActionButton\: //g"?>
```dart
FloatingActionButton(
  // When the user presses the button, show an alert dialog containing
  // the text that the user has entered into the text field.
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Retrieve the text that the user has entered by using the
          // TextEditingController.
          content: Text(myController.text),
        );
      },
    );
  },
  tooltip: 'Show me the value!',
  child: const Icon(Icons.text_fields),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter retrieve input hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Retrieve Text Input',
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
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrieve Text Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog containing
        // the text that the user has entered into the text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the that user has entered by using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/retrieve-input.gif" alt="Retrieve Text Input Demo" class="site-mobile-screenshot" />
</noscript>


[`text()`]: {{site.api}}/flutter/widgets/TextEditingController/text.html
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
