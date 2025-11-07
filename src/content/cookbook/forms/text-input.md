---
title: Criar e estilizar um text field
description: Como implementar um text field.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/forms/text_input/"?>

Text fields permitem que usuários digitem texto em um app.
Eles são usados para construir forms,
enviar mensagens, criar experiências de busca e muito mais.
Nesta receita, explore como criar e estilizar text fields.

Flutter fornece dois text fields:
[`TextField`][] e [`TextFormField`][].

## `TextField`

[`TextField`][] é o widget de entrada de texto mais comumente usado.

Por padrão, um `TextField` é decorado com um sublinhado.
Você pode adicionar um label, ícone, texto de dica inline e texto de erro fornecendo um
[`InputDecoration`][] como propriedade [`decoration`][]
do `TextField`.
Para remover completamente a decoração (incluindo o
sublinhado e o espaço reservado para o label),
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
veja a receita [Handle changes to a text field][].

## `TextFormField`

[`TextFormField`][] envolve um `TextField` e o integra
com o [`Form`][] envolvente.
Isso fornece funcionalidade adicional,
como validação e integração com outros
widgets [`FormField`][].

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
        appBar: AppBar(
          title: const Text(appTitle),
        ),
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
receita [Building a form with validation][].


[Building a form with validation]: /cookbook/forms/validation/
[`decoration`]: {{site.api}}/flutter/material/TextField/decoration.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[Handle changes to a text field]: /cookbook/forms/text-field-changes/
[`InputDecoration`]: {{site.api}}/flutter/material/InputDecoration-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
