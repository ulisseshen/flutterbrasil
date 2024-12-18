---
ia-translate: true
title: Criar um formulário com validação
description: Como criar um formulário que valida a entrada.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/validation"?>

Aplicativos frequentemente exigem que os usuários insiram informações em um campo de texto.
Por exemplo, você pode exigir que os usuários façam login com um endereço de e-mail
e combinação de senha.

Para tornar os aplicativos seguros e fáceis de usar, verifique se as
informações que o usuário forneceu são válidas. Se o usuário preencheu corretamente
o formulário, processe as informações. Se o usuário enviar informações incorretas,
exiba uma mensagem de erro amigável informando o que deu
errado.

Neste exemplo, aprenda como adicionar validação a um formulário que tem
um único campo de texto usando as seguintes etapas:

  1. Crie um `Form` com uma `GlobalKey`.
  2. Adicione um `TextFormField` com lógica de validação.
  3. Crie um botão para validar e enviar o formulário.

## 1. Crie um `Form` com uma `GlobalKey`

Crie um [`Form`][].
O widget `Form` age como um contêiner para agrupar e
validar vários campos de formulário.

Ao criar o formulário, forneça uma [`GlobalKey`][].
Isso atribui um identificador único ao seu `Form`.
Ele também permite que você valide o formulário posteriormente.

Crie o formulário como um `StatefulWidget`.
Isso permite que você crie um `GlobalKey<FormState>()` exclusivo uma vez.
Em seguida, você pode armazená-lo como uma variável e acessá-lo em diferentes pontos.

Se você fizesse isso como um `StatelessWidget`, você precisaria armazenar essa chave *em algum lugar*.
Como é um recurso caro, você não gostaria de gerar um novo
`GlobalKey` cada vez que executar o método `build`.

<?code-excerpt "lib/form.dart"?>
```dart
import 'package:flutter/material.dart';

// Define um widget Form personalizado.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define uma classe State correspondente.
// Esta classe contém dados relacionados ao formulário.
class MyCustomFormState extends State<MyCustomForm> {
  // Crie uma chave global que identifica exclusivamente o widget Form
  // e permite a validação do formulário.
  //
  // Nota: Esta é uma `GlobalKey<FormState>`,
  // não uma GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Construa um widget Form usando o _formKey criado acima.
    return Form(
      key: _formKey,
      child: const Column(
        children: <Widget>[
          // Adicione TextFormFields e ElevatedButton aqui.
        ],
      ),
    );
  }
}
```

:::tip
Usar uma `GlobalKey` é a maneira recomendada de acessar um formulário.
No entanto, se você tiver uma árvore de widgets mais complexa,
você pode usar o método [`Form.of()`][] para
acessar o formulário dentro de widgets aninhados.
:::

## 2. Adicione um `TextFormField` com lógica de validação

Embora o `Form` esteja no lugar,
ele não tem uma maneira para os usuários inserirem texto.
Esse é o trabalho de um [`TextFormField`][].
O widget `TextFormField` renderiza um campo de texto de design Material
e pode exibir erros de validação quando eles ocorrem.

Valide a entrada, fornecendo uma função `validator()` para o
`TextFormField`. Se a entrada do usuário não for válida,
a função `validator` retorna uma `String` contendo
uma mensagem de erro.
Se não houver erros, o validador deve retornar nulo.

Para este exemplo, crie um `validator` que garanta que o
`TextFormField` não esteja vazio. Se estiver vazio,
retorne uma mensagem de erro amigável.

<?code-excerpt "lib/main.dart (TextFormField)"?>
```dart
TextFormField(
  // O validador recebe o texto que o usuário inseriu.
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira algum texto';
    }
    return null;
  },
),
```

## 3. Crie um botão para validar e enviar o formulário

Agora que você tem um formulário com um campo de texto,
forneça um botão que o usuário pode tocar para enviar as informações.

Quando o usuário tentar enviar o formulário, verifique se o formulário é válido.
Se for, exiba uma mensagem de sucesso.
Se não for (o campo de texto não tem conteúdo), exiba a mensagem de erro.

<?code-excerpt "lib/main.dart (ElevatedButton)" replace="/^child\: //g"?>
```dart
ElevatedButton(
  onPressed: () {
    // Validate retorna verdadeiro se o formulário for válido ou falso caso contrário.
    if (_formKey.currentState!.validate()) {
      // Se o formulário for válido, exiba um snackbar. No mundo real,
      // você geralmente chamaria um servidor ou salvaria as informações em um banco de dados.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Processando Dados')),
      );
    }
  },
  child: const Text('Enviar'),
),
```

### Como isso funciona?

Para validar o formulário, use o `_formKey` criado no
passo 1. Você pode usar o acessador `_formKey.currentState`
para acessar o [`FormState`][],
que é criado automaticamente pelo Flutter ao construir um `Form`.

A classe `FormState` contém o método `validate()`.
Quando o método `validate()` é chamado, ele executa a função `validator()`
para cada campo de texto no formulário.
Se tudo estiver correto, o método `validate()` retorna `true`.
Se algum campo de texto contiver erros, o método `validate()`
reconstrói o formulário para exibir quaisquer mensagens de erro e retorna `false`.

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de validação de formulário Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demonstração de Validação de Formulário';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const MyCustomForm(),
      ),
    );
  }
}

// Crie um widget Form.
class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Crie uma classe State correspondente.
// Esta classe contém dados relacionados ao formulário.
class MyCustomFormState extends State<MyCustomForm> {
  // Crie uma chave global que identifica exclusivamente o widget Form
  // e permite a validação do formulário.
  //
  // Nota: Esta é uma GlobalKey<FormState>,
  // não uma GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // Construa um widget Form usando o _formKey criado acima.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            // O validador recebe o texto que o usuário inseriu.
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira algum texto';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                // Validate retorna verdadeiro se o formulário for válido ou falso caso contrário.
                if (_formKey.currentState!.validate()) {
                  // Se o formulário for válido, exiba um snackbar. No mundo real,
                  // você geralmente chamaria um servidor ou salvaria as informações em um banco de dados.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processando Dados')),
                  );
                }
              },
              child: const Text('Enviar'),
            ),
          ),
        ],
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/form-validation.gif" alt="Demonstração de Validação de Formulário" class="site-mobile-screenshot" />
</noscript>

Para saber como recuperar esses valores, consulte a receita
[Recuperar o valor de um campo de texto][].

[Recuperar o valor de um campo de texto]: /cookbook/forms/retrieve-input
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`Form.of()`]: {{site.api}}/flutter/widgets/Form/of.html
[`FormState`]: {{site.api}}/flutter/widgets/FormState-class.html
[`GlobalKey`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
