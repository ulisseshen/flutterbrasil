---
ia-translate: true
title: Lidar com mudanças em um campo de texto
description: Como detectar mudanças em um campo de texto.
---

<?code-excerpt path-base="cookbook/forms/text_field_changes/"?>

Em alguns casos, é útil executar uma função de callback cada vez que o texto
em um campo de texto muda. Por exemplo, você pode querer construir uma tela de busca
com funcionalidade de autocompletar onde você deseja atualizar os
resultados conforme o usuário digita.

Como executar uma função de callback cada vez que o texto muda?
Com Flutter, você tem duas opções:

  1. Fornecer um callback `onChanged()` para um `TextField` ou um `TextFormField`.
  2. Usar um `TextEditingController`.

## 1. Fornecer um callback `onChanged()` para um `TextField` ou um `TextFormField`

A abordagem mais simples é fornecer um callback [`onChanged()`][`onChanged()`] para um
[`TextField`][`TextField`] ou um [`TextFormField`][`TextFormField`].
Sempre que o texto muda, o callback é invocado.

Neste exemplo, imprima o valor atual e o comprimento do texto do campo de texto
no console cada vez que o texto muda.

É importante usar [characters][characters] ao lidar com entrada de usuário,
pois o texto pode conter caracteres complexos.
Isso garante que cada caractere seja contado corretamente
como eles aparecem para o usuário.

<?code-excerpt "lib/main.dart (TextField1)"?>
```dart
TextField(
  onChanged: (text) {
    print('First text field: $text (${text.characters.length})');
  },
),
```

## 2. Usar um `TextEditingController`

Uma abordagem mais poderosa, mas mais elaborada, é fornecer um
[`TextEditingController`][`TextEditingController`] como a propriedade [`controller`][`controller`]
do `TextField` ou um `TextFormField`.

Para ser notificado quando o texto muda, ouça o controlador
usando o método [`addListener()`][`addListener()`] seguindo as seguintes etapas:

  1. Criar um `TextEditingController`.
  2. Conectar o `TextEditingController` a um campo de texto.
  3. Criar uma função para imprimir o valor mais recente.
  4. Ouvir o controlador para mudanças.

### Criar um `TextEditingController`

Crie um `TextEditingController`:

<?code-excerpt "lib/main_step1.dart (Step1)" remove="return Container();"?>
```dart
// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next step.
  }
}
```

:::note
Lembre-se de descartar o `TextEditingController` quando ele não for
mais necessário. Isso garante que você descarte quaisquer recursos usados
pelo objeto.
:::

### Conectar o `TextEditingController` a um campo de texto

Forneça o `TextEditingController` para um `TextField`
ou um `TextFormField`. Uma vez que você conecte essas duas classes,
você pode começar a ouvir mudanças no campo de texto.

<?code-excerpt "lib/main.dart (TextField2)"?>
```dart
TextField(controller: myController),
```

### Criar uma função para imprimir o valor mais recente

Você precisa de uma função para executar cada vez que o texto muda.
Crie um método na classe `_MyCustomFormState` que imprima
o valor atual do campo de texto.

<?code-excerpt "lib/main.dart (printLatestValue)"?>
```dart
void _printLatestValue() {
  final text = myController.text;
  print('Second text field: $text (${text.characters.length})');
}
```

### Ouvir o controlador para mudanças

Finalmente, ouça o `TextEditingController` e chame o
método `_printLatestValue()` quando o texto mudar. Use o
método [`addListener()`][`addListener()`] para este propósito.

Comece a ouvir mudanças quando a
classe `_MyCustomFormState` for inicializada,
e pare de ouvir quando a `_MyCustomFormState` for descartada.

<?code-excerpt "lib/main.dart (init-state)"?>
```dart
@override
void initState() {
  super.initState();

  // Start listening to changes.
  myController.addListener(_printLatestValue);
}
```

<?code-excerpt "lib/main.dart (dispose)"?>
```dart
@override
void dispose() {
  // Clean up the controller when the widget is removed from the widget tree.
  // This also removes the _printLatestValue listener.
  myController.dispose();
  super.dispose();
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter text field change hands-on example in DartPad" run="true"
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
// This class holds data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    final text = myController.text;
    print('Second text field: $text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retrieve Text Input')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                print('First text field: $text (${text.characters.length})');
              },
            ),
            TextField(controller: myController),
          ],
        ),
      ),
    );
  }
}
```

[`addListener()`]: {{site.api}}/flutter/foundation/ChangeNotifier/addListener.html
[`controller`]: {{site.api}}/flutter/material/TextField/controller.html
[`onChanged()`]: {{site.api}}/flutter/material/TextField/onChanged.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[characters]: {{site.pub}}/packages/characters
