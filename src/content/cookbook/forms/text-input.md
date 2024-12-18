---
ia-translate: true
title: Criar e estilizar um campo de texto
description: Como implementar um campo de texto.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/forms/text_input/"?>

Campos de texto permitem que usuários digitem texto em um aplicativo.
Eles são usados para construir formulários,
enviar mensagens, criar experiências de pesquisa e muito mais.
Nesta receita, explore como criar e estilizar campos de texto.

O Flutter fornece dois campos de texto:
[`TextField`][] e [`TextFormField`][].

## `TextField`

[`TextField`][] é o widget de entrada de texto mais comumente usado.

Por padrão, um `TextField` é decorado com um sublinhado.
Você pode adicionar um rótulo, ícone, texto de dica embutido e texto de erro, fornecendo um
[`InputDecoration`][] como a propriedade [`decoration`][]
do `TextField`.
Para remover a decoração completamente (incluindo o
sublinhado e o espaço reservado para o rótulo),
defina a `decoration` como nula.

<?code-excerpt "lib/main.dart (TextField)" replace="/^child\: //g"?>
```dart
TextField(
  decoration: InputDecoration(
    border: OutlineInputBorder(),
    hintText: 'Digite um termo de pesquisa',
  ),
),
```

Para recuperar o valor quando ele mudar,
veja a receita [Lidar com mudanças em um campo de texto][].

## `TextFormField`

[`TextFormField`][] envolve um `TextField` e o integra
com o [`Form`][] delimitador.
Isso fornece funcionalidades adicionais,
como validação e integração com outros
widgets [`FormField`][].

<?code-excerpt "lib/main.dart (TextFormField)" replace="/^child\: //g"?>
```dart
TextFormField(
  decoration: const InputDecoration(
    border: UnderlineInputBorder(),
    labelText: 'Digite seu nome de usuário',
  ),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart" replace="/^child\: //g"?>
```dartpad title="Exemplo prático de entrada de texto do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Demonstração de Estilo de Formulário';
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
              hintText: 'Digite um termo de pesquisa',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Digite seu nome de usuário',
            ),
          ),
        ),
      ],
    );
  }
}
```

Para mais informações sobre validação de entrada, veja a receita
[Construindo um formulário com validação][].


[Construindo um formulário com validação]: /cookbook/forms/validation/
[`decoration`]: {{site.api}}/flutter/material/TextField/decoration.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`FormField`]: {{site.api}}/flutter/widgets/FormField-class.html
[Lidar com mudanças em um campo de texto]: /cookbook/forms/text-field-changes/
[`InputDecoration`]: {{site.api}}/flutter/material/InputDecoration-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
