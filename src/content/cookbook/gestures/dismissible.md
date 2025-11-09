---
ia-translate: true
title: Implementar deslizar para dispensar
description: Como implementar deslizar para dispensar ou deletar.
---

<?code-excerpt path-base="cookbook/gestures/dismissible"?>

O padrão "deslizar para dispensar" é comum em muitos apps mobile.
Por exemplo, ao escrever um app de email,
você pode querer permitir que um usuário deslize
mensagens de email para deletá-las de uma lista.

Flutter torna esta tarefa fácil fornecendo o
widget [`Dismissible`][`Dismissible`].
Aprenda como implementar deslizar para dispensar com os seguintes passos:

  1. Crie uma lista de itens.
  2. Envolva cada item em um widget `Dismissible`.
  3. Forneça indicadores "deixados para trás".

## 1. Crie uma lista de itens

Primeiro, crie uma lista de itens. Para instruções detalhadas
sobre como criar uma lista,
siga a receita [Working with long lists][Working with long lists].

### Crie uma fonte de dados

Neste exemplo,
você quer 20 itens de amostra para trabalhar.
Para manter simples, gere uma lista de strings.

<?code-excerpt "lib/main.dart (Items)"?>
```dart
final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
```

### Converta a fonte de dados em uma lista

Exiba cada item da lista na tela. Os usuários ainda não
poderão deslizar esses itens para removê-los.

<?code-excerpt "lib/step1.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

## 2. Envolva cada item em um widget Dismissible

Neste passo,
dê aos usuários a habilidade de deslizar um item para fora da lista usando o
widget [`Dismissible`][`Dismissible`].

Depois que o usuário deslizar o item para fora,
remova o item da lista e exiba uma snackbar.
Em um app real, você pode precisar executar lógica mais complexa,
como remover o item de um serviço web ou banco de dados.

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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$item dismissed')));
    },
    child: ListTile(title: Text(item)),
  );
},
```

## 3. Forneça indicadores "deixados para trás"

Como está,
o app permite que os usuários deslizem itens para fora da lista, mas não
dá uma indicação visual do que acontece quando eles fazem isso.
Para fornecer uma pista de que itens são removidos,
exiba um indicador "deixado para trás" enquanto eles
deslizam o item para fora da tela. Neste caso,
o indicador é um fundo vermelho.

Para adicionar o indicador,
forneça um parâmetro `background` para o `Dismissible`.


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
        appBar: AppBar(title: const Text(title)),
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
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('$item dismissed')));
              },
              // Show a red background as the item is swiped away.
              background: Container(color: Colors.red),
              child: ListTile(title: Text(item)),
            );
          },
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/dismissible.webp" alt="Dismissible Demo" class="site-mobile-screenshot" />
</noscript>


[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[Working with long lists]: /cookbook/lists/long-lists
