---
ia-translate: true
title: Lidar com mudanças em um campo de texto
description: Como detectar mudanças em um campo de texto.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/text_field_changes/"?>

Em alguns casos, é útil executar uma função de callback cada vez que o texto
em um campo de texto muda. Por exemplo, você pode querer construir uma tela de busca
com funcionalidade de preenchimento automático onde você quer atualizar os
resultados à medida que o usuário digita.

Como você executa uma função de callback cada vez que o texto muda?
Com o Flutter, você tem duas opções:

  1. Fornecer um callback `onChanged()` para um `TextField` ou um `TextFormField`.
  2. Usar um `TextEditingController`.

## 1. Fornecer um callback `onChanged()` para um `TextField` ou um `TextFormField`

A abordagem mais simples é fornecer um callback [`onChanged()`][] para um
[`TextField`][] ou um [`TextFormField`][].
Sempre que o texto muda, o callback é invocado.

Neste exemplo, imprima o valor atual e o comprimento do campo de texto
no console cada vez que o texto muda.

É importante usar [characters][] ao lidar com entrada do usuário,
já que o texto pode conter caracteres complexos.
Isso garante que cada caractere seja contado corretamente
como eles aparecem para o usuário.

<?code-excerpt "lib/main.dart (TextField1)"?>
```dart
TextField(
  onChanged: (text) {
    print('Primeiro campo de texto: $text (${text.characters.length})');
  },
),
```

## 2. Usar um `TextEditingController`

Uma abordagem mais poderosa, mas mais elaborada, é fornecer um
[`TextEditingController`][] como a propriedade [`controller`][]
do `TextField` ou um `TextFormField`.

Para ser notificado quando o texto mudar, ouça o controller
usando o método [`addListener()`][] usando os seguintes passos:

  1. Criar um `TextEditingController`.
  2. Conectar o `TextEditingController` a um campo de texto.
  3. Criar uma função para imprimir o valor mais recente.
  4. Ouvir o controller para mudanças.

### Criar um `TextEditingController`

Crie um `TextEditingController`:

<?code-excerpt "lib/main_step1.dart (Step1)" remove="return Container();"?>
```dart
// Define um widget Form customizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define uma classe State correspondente.
// Esta classe contém dados relacionados ao Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Crie um controller de texto. Mais tarde, use-o para recuperar o
  // valor atual do TextField.
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpe o controller quando o widget for removido da
    // árvore de widgets.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Preencha isso na próxima etapa.
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
ou um `TextFormField`. Uma vez que você conecte essas duas classes juntas,
você pode começar a ouvir por mudanças no campo de texto.

<?code-excerpt "lib/main.dart (TextField2)"?>
```dart
TextField(
  controller: myController,
),
```

### Criar uma função para imprimir o valor mais recente

Você precisa de uma função para executar cada vez que o texto muda.
Crie um método na classe `_MyCustomFormState` que imprime
o valor atual do campo de texto.

<?code-excerpt "lib/main.dart (printLatestValue)"?>
```dart
void _printLatestValue() {
  final text = myController.text;
  print('Segundo campo de texto: $text (${text.characters.length})');
}
```

### Ouvir o controller por mudanças

Finalmente, ouça o `TextEditingController` e chame o
método `_printLatestValue()` quando o texto mudar. Use o
método [`addListener()`][] para este propósito.

Comece a ouvir por mudanças quando a classe
`_MyCustomFormState` é inicializada,
e pare de ouvir quando o `_MyCustomFormState` é descartado.

<?code-excerpt "lib/main.dart (init-state)"?>
```dart
@override
void initState() {
  super.initState();

  // Comece a ouvir por mudanças.
  myController.addListener(_printLatestValue);
}
```

<?code-excerpt "lib/main.dart (dispose)"?>
```dart
@override
void dispose() {
  // Limpe o controller quando o widget for removido da árvore de widgets.
  // Isso também remove o ouvinte _printLatestValue.
  myController.dispose();
  super.dispose();
}
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de mudança de campo de texto do Flutter no DartPad" run="true"
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

// Define um widget Form customizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  State<MyCustomForm> createState() => _MyCustomFormState();
}

// Define uma classe State correspondente.
// Esta classe contém dados relacionados ao Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Crie um controller de texto e use-o para recuperar o valor atual
  // do TextField.
  final myController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Comece a ouvir por mudanças.
    myController.addListener(_printLatestValue);
  }

  @override
  void dispose() {
    // Limpe o controller quando o widget for removido da árvore de widgets.
    // Isso também remove o ouvinte _printLatestValue.
    myController.dispose();
    super.dispose();
  }

  void _printLatestValue() {
    final text = myController.text;
    print('Segundo campo de texto: $text (${text.characters.length})');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Entrada de Texto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (text) {
                print('Primeiro campo de texto: $text (${text.characters.length})');
              },
            ),
            TextField(
              controller: myController,
            ),
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
