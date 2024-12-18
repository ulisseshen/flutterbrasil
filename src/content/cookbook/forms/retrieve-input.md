---
ia-translate: true
title: Recuperar o valor de um campo de texto
description: Como recuperar texto de um campo de texto.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/retrieve_input"?>

Nesta receita,
aprenda como recuperar o texto que um usuário inseriu em um campo de texto
usando os seguintes passos:

  1. Crie um `TextEditingController`.
  2. Forneça o `TextEditingController` a um `TextField`.
  3. Exiba o valor atual do campo de texto.

## 1. Crie um `TextEditingController`

Para recuperar o texto que um usuário inseriu em um campo de texto,
crie um [`TextEditingController`][]
e forneça-o a um `TextField` ou `TextFormField`.

:::important
Chame `dispose` do `TextEditingController` quando
você terminar de usá-lo. Isso garante que você descarte quaisquer recursos
usados pelo objeto.
:::

<?code-excerpt "lib/starter.dart (Starter)" remove="return Container();"?>
```dart
// Define um widget Form personalizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define uma classe State correspondente.
// Esta classe contém os dados relacionados ao Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Cria um controlador de texto e usa-o para recuperar o valor atual
  // do TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpa o controlador quando o widget é descartado.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Preencha isso no próximo passo.
  }
}
```

## 2. Forneça o `TextEditingController` a um `TextField`

Agora que você tem um `TextEditingController`, conecte-o
a um campo de texto usando a propriedade `controller`:

<?code-excerpt "lib/step2.dart (TextFieldController)"?>
```dart
return TextField(
  controller: myController,
);
```

## 3. Exiba o valor atual do campo de texto

Após fornecer o `TextEditingController` ao campo de texto,
comece a ler os valores. Use o método [`text()`][]
fornecido pelo `TextEditingController` para recuperar a
String que o usuário inseriu no campo de texto.

O código a seguir exibe um diálogo de alerta com o valor atual
do campo de texto quando o usuário toca em um botão de ação flutuante.

<?code-excerpt "lib/step3.dart (FloatingActionButton)" replace="/^floatingActionButton\: //g"?>
```dart
FloatingActionButton(
  // Quando o usuário pressiona o botão, mostra um diálogo de alerta contendo
  // o texto que o usuário inseriu no campo de texto.
  onPressed: () {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          // Recupera o texto que o usuário inseriu usando o
          // TextEditingController.
          content: Text(myController.text),
        );
      },
    );
  },
  tooltip: 'Mostre-me o valor!',
  child: const Icon(Icons.text_fields),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de recuperação de entrada do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Recuperar Entrada de Texto',
      home: MyCustomForm(),
    );
  }
}

// Define um widget Form personalizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define uma classe State correspondente.
// Esta classe contém os dados relacionados ao Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Cria um controlador de texto e usa-o para recuperar o valor atual
  // do TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpa o controlador quando o widget é descartado.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Entrada de Texto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // Quando o usuário pressiona o botão, mostra um diálogo de alerta contendo
        // o texto que o usuário inseriu no campo de texto.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Recupera o texto que o usuário inseriu usando o
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Mostre-me o valor!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/retrieve-input.gif" alt="Demonstração de Recuperar Entrada de Texto" class="site-mobile-screenshot" />
</noscript>


[`text()`]: {{site.api}}/flutter/widgets/TextEditingController/text.html
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
