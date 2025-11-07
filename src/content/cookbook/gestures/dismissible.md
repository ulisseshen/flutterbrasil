---
title: Implementar swipe para descartar
description: Como implementar swipe para descartar ou deletar.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/gestures/dismissible"?>

O padrão "swipe para descartar" é comum em muitos aplicativos mobile.
Por exemplo, ao escrever um aplicativo de e-mail,
você pode querer permitir que um usuário descarte
mensagens de e-mail deslizando-as para deletá-las de uma lista.

O Flutter facilita essa tarefa fornecendo o
widget [`Dismissible`][].
Aprenda como implementar swipe para descartar com os seguintes passos:

  1. Criar uma lista de itens.
  2. Envolver cada item em um widget `Dismissible`.
  3. Fornecer indicadores "leave behind".

## 1. Criar uma lista de itens

Primeiro, crie uma lista de itens. Para instruções detalhadas
sobre como criar uma lista,
siga a receita [Working with long lists][].

### Criar uma fonte de dados

Neste exemplo,
você quer 20 itens de exemplo para trabalhar.
Para manter simples, gere uma lista de strings.

<?code-excerpt "lib/main.dart (Items)"?>
```dart
final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
```

### Converter a fonte de dados em uma lista

Exiba cada item na lista na tela. Os usuários ainda não
conseguirão descartar esses itens deslizando.

<?code-excerpt "lib/step1.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

## 2. Envolver cada item em um widget Dismissible

Neste passo,
dê aos usuários a capacidade de descartar um item da lista usando o
widget [`Dismissible`][].

Após o usuário ter deslizado o item,
remova o item da lista e exiba uma snackbar.
Em um aplicativo real, você pode precisar executar lógica mais complexa,
como remover o item de um web service ou banco de dados.

Atualize a função `itemBuilder()` para retornar um widget `Dismissible`:

<?code-excerpt "lib/step2.dart (Dismissible)"?>
```dart
itemBuilder: (context, index) {
  final item = items[index];
  return Dismissible(
    // Each Dismissible must contain a Key. Keys allow Flutter to
    // uniquely identify widgets.
    key: Key(item),
    // Provide a function that tells the app
    // what to do after an item has been swiped away.
    onDismissed: (direction) {
      // Remove the item from the data source.
      setState(() {
        items.removeAt(index);
      });

      // Then show a snackbar.
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$item dismissed')));
    },
    child: ListTile(
      title: Text(item),
    ),
  );
},
```

## 3. Fornecer indicadores "leave behind"

Como está,
o aplicativo permite que os usuários descartem itens da lista, mas não
dá uma indicação visual do que acontece quando eles fazem isso.
Para fornecer uma pista de que os itens são removidos,
exiba um indicador "leave behind" enquanto eles
deslizam o item para fora da tela. Neste caso,
o indicador é um fundo vermelho.

Para adicionar o indicador,
forneça um parâmetro `background` ao `Dismissible`.


```dart diff
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('$item dismissed')));
  },
+ // Show a red background as the item is swiped away.
+ background: Container(color: Colors.red),
  child: ListTile(
    title: Text(item),
  ),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Swipe to Dismiss hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// MyApp is a StatefulWidget. This allows updating the state of the
// widget when an item is removed.
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');

  @override
  Widget build(BuildContext context) {
    const title = 'Dismissing Items';

    return MaterialApp(
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return Dismissible(
              // Each Dismissible must contain a Key. Keys allow Flutter to
              // uniquely identify widgets.
              key: Key(item),
              // Provide a function that tells the app
              // what to do after an item has been swiped away.
              onDismissed: (direction) {
                // Remove the item from the data source.
                setState(() {
                  items.removeAt(index);
                });

                // Then show a snackbar.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              child: ListTile(
                title: Text(item),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/dismissible.gif" alt="Dismissible Demo" class="site-mobile-screenshot" />
</noscript>


[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[Working with long lists]: /cookbook/lists/long-lists
