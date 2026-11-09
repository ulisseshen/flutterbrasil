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

Flutter fornece dois campos de texto do Material Design:
[`TextField`][`TextField`] e [`TextFormField`][`TextFormField`].

## `TextField`

[`TextField`][`TextField`] é o widget de entrada de texto mais comumente usado.

Por padrão, um `TextField` é decorado com um sublinhado.
Você pode adicionar um rótulo, ícone, texto de dica inline e texto de erro fornecendo um
[`InputDecoration`][`InputDecoration`] como a propriedade [`decoration`][`decoration`]
do `TextField`.
Para remover a decoração completamente (incluindo o
sublinhado e o espaço reservado para o rótulo),
defina a `decoration` como `null`.

<?code-excerpt "lib/main.dart (TextField)" replace="/^child\: //g"?>
```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Enter a search term',
  ),
),
```

<noscript>
  <img src="/assets/images/docs/cookbook/text-input.png" alt="Text Input Demo" />
</noscript>

Para recuperar o valor quando ele muda,
consulte a receita [Handle changes to a text field][Handle changes to a text field].

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

## Exemplo interativo {:#interactive-example}

<?code-excerpt "lib/main.dart"?>
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
      children: [
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

Para saber mais sobre validação de entrada,
consulte a receita [Build a form with validation][Build a form with validation].


[Build a form with validation]: /cookbook/forms/validation
[`decoration`]: {{site.material_ui}}/TextField/decoration.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[Handle changes to a text field]: /cookbook/forms/text-field-changes
[`InputDecoration`]: {{site.material_ui}}/InputDecoration-class.html
[`TextField`]: {{site.material_ui}}/TextField-class.html
[`TextFormField`]: {{site.material_ui}}/TextFormField-class.html
