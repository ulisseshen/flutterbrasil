---
ia-translate: true
title: Criar e estilizar um campo de texto
description: Como implementar um campo de texto.
---

<?code-excerpt path-base="cookbook/forms/text_input/"?>

Campos de texto permitem que os usuários digitem texto em um app.
Eles são usados para construir formulários,
enviar mensagens, criar experiências de busca e muito mais.
Nesta receita, explore como criar e estilizar campos de texto.

Flutter fornece dois campos de texto:
[`TextField`][`TextField`] e [`TextFormField`][`TextFormField`].

## `TextField`

[`TextField`][`TextField`] é o widget de entrada de texto mais comumente usado.

Por padrão, um `TextField` é decorado com um sublinhado.
Você pode adicionar um rótulo, ícone, texto de dica inline e texto de erro fornecendo um
[`InputDecoration`][`InputDecoration`] como a propriedade [`decoration`][`decoration`]
do `TextField`.
Para remover a decoração completamente (incluindo o
sublinhado e o espaço reservado para o rótulo),
defina a `decoration` como null.

<?code-excerpt "lib/main.dart (TextField)" replace="/^child\: //g"?>
```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter a search term',
  ),
),
```

Para recuperar o valor quando ele muda,
veja a receita [Handle changes to a text field][Handle changes to a text field].

## `TextFormField`

[`TextFormField`][`TextFormField`] envolve um `TextField` e o integra
com o [`Form`][`Form`] envolvente.
Isso fornece funcionalidade adicional,
como validação e integração com outros
widgets [`FormField`][`FormField`].

<?code-excerpt "lib/main.dart (TextFormField)" replace="/^child\: //g"?>
```dart
TextFormField(
  decoration: const InputDecoration(
    border: UnderlineInputBorder(),
    labelText: 'Enter your username',
  ),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart" replace="/^child\: //g"?>
```dartpad title="Flutter text input hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Form Styling Demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: const MyCustomForm(),
      ),
    );
  }
}

class MyCustomForm extends StatelessWidget {
  const MyCustomForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Enter a search term',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Enter your username',
            ),
          ),
        ),
      ],
    );
  }
}
```

Para mais informações sobre validação de entrada, veja a
receita [Building a form with validation][Building a form with validation].


[Building a form with validation]: /cookbook/forms/validation/
[`decoration`]: {{site.api}}/flutter/material/TextField/decoration.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[Handle changes to a text field]: /cookbook/forms/text-field-changes/
[`InputDecoration`]: {{site.api}}/flutter/material/InputDecoration-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
