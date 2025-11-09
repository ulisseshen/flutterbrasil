---
ia-translate: true
title: Construir um formulário com validação
description: Como construir um formulário que valida entrada.
---

<?code-excerpt path-base="cookbook/forms/validation"?>

Apps frequentemente exigem que os usuários insiram informações em um campo de texto.
Por exemplo, você pode exigir que os usuários façam login com um endereço de e-mail
e uma combinação de senha.

Para tornar os apps seguros e fáceis de usar, verifique se as
informações que o usuário forneceu são válidas. Se o usuário preencheu corretamente
o formulário, processe as informações. Se o usuário enviar informações incorretas,
exiba uma mensagem de erro amigável informando o que deu
errado.

Neste exemplo, aprenda como adicionar validação a um formulário que possui
um único campo de texto usando as seguintes etapas:

  1. Criar um `Form` com uma `GlobalKey`.
  2. Adicionar um `TextFormField` com lógica de validação.
  3. Criar um botão para validar e enviar o formulário.

## 1. Criar um `Form` com uma `GlobalKey`

Crie um [`Form`][`Form`].
O widget `Form` atua como um contêiner para agrupar e
validar múltiplos campos de formulário.

Ao criar o formulário, forneça uma [`GlobalKey`][`GlobalKey`].
Isso atribui um identificador único ao seu `Form`.
Também permite que você valide o formulário posteriormente.

Crie o formulário como um `StatefulWidget`.
Isso permite que você crie uma `GlobalKey<FormState>()` única uma vez.
Você pode então armazená-la como uma variável e acessá-la em diferentes pontos.

Se você fizesse isso como um `StatelessWidget`, você precisaria armazenar esta chave *em algum lugar*.
Como é um recurso caro, você não gostaria de gerar uma nova
`GlobalKey` cada vez que executar o método `build`.

<?code-excerpt "lib/form.dart"?>
```dart
import 'package:flutter/material.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: const Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }
}
```

:::tip
Usar uma `GlobalKey` é a maneira recomendada de acessar um formulário.
No entanto, se você tiver uma árvore de widgets mais complexa,
você pode usar o método [`Form.of()`][`Form.of()`] para
acessar o formulário dentro de widgets aninhados.
:::

## 2. Adicionar um `TextFormField` com lógica de validação

Embora o `Form` esteja no lugar,
ele não tem uma maneira para os usuários inserirem texto.
Esse é o trabalho de um [`TextFormField`][`TextFormField`].
O widget `TextFormField` renderiza um campo de texto de material design
e pode exibir erros de validação quando eles ocorrem.

Valide a entrada fornecendo uma função `validator()` para o
`TextFormField`. Se a entrada do usuário não for válida,
a função `validator` retorna uma `String` contendo
uma mensagem de erro.
Se não houver erros, o validador deve retornar null.

Para este exemplo, crie um `validator` que garanta que o
`TextFormField` não esteja vazio. Se estiver vazio,
retorne uma mensagem de erro amigável.

<?code-excerpt "lib/main.dart (TextFormField)"?>
```dart
TextFormField(
  // The validator receives the text that the user has entered.
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Please enter some text';
    }
    return null;
  },
),
```

## 3. Criar um botão para validar e enviar o formulário

Agora que você tem um formulário com um campo de texto,
forneça um botão que o usuário possa tocar para enviar as informações.

Quando o usuário tentar enviar o formulário, verifique se o formulário é válido.
Se for, exiba uma mensagem de sucesso.
Se não for (o campo de texto não tem conteúdo) exiba a mensagem de erro.

<?code-excerpt "lib/main.dart (ElevatedButton)" replace="/^child\: //g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Validate returns true if the form is valid, or false otherwise.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processing Data')),
      );
    }
  },
  child: const Text('Submit'),
),
```

### Como isso funciona?

Para validar o formulário, use a `_formKey` criada na
etapa 1. Você pode usar o accessor `_formKey.currentState`
para acessar o [`FormState`][`FormState`],
que é automaticamente criado pelo Flutter ao construir um `Form`.

A classe `FormState` contém o método `validate()`.
Quando o método `validate()` é chamado, ele executa a função `validator()`
para cada campo de texto no formulário.
Se tudo estiver correto, o método `validate()` retorna `true`.
Se algum campo de texto contiver erros, o método `validate()`
reconstrói o formulário para exibir quaisquer mensagens de erro e retorna `false`.

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter form validation hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Validation Demo';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Create a Form widget.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // The validator receives the text that the user has entered.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/form-validation.webp" alt="Form Validation Demo" class="site-mobile-screenshot" />
</noscript>

Para aprender como recuperar esses valores, consulte a
receita [Retrieve the value of a text field][Retrieve the value of a text field].


[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`Form.of()`]: {{site.api}}/flutter/widgets/Form/of.html
[`FormState`]: {{site.api}}/flutter/widgets/FormState-class.html
[`GlobalKey`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
