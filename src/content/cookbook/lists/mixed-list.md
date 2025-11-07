---
title: Criar listas com diferentes tipos de itens
description: Como implementar uma lista que contém diferentes tipos de assets.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/lists/mixed_list/"?>

Você pode precisar criar listas que exibem diferentes tipos de conteúdo.
Por exemplo, você pode estar trabalhando em uma lista que mostra um cabeçalho
seguido por alguns itens relacionados ao cabeçalho, seguido por outro cabeçalho,
e assim por diante.

Veja como você pode criar tal estrutura com Flutter:

  1. Criar uma fonte de dados com diferentes tipos de itens.
  2. Converter a fonte de dados em uma lista de widgets.

## 1. Criar uma fonte de dados com diferentes tipos de itens

### Tipos de itens

Para representar diferentes tipos de itens em uma lista, defina
uma classe para cada tipo de item.

Neste exemplo, crie um aplicativo que mostra um cabeçalho seguido por cinco
mensagens. Portanto, crie três classes: `ListItem`, `HeadingItem`,
e `MessageItem`.

<?code-excerpt "lib/main.dart (ListItem)"?>
```dart
/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
```

### Criar uma lista de itens

Na maioria das vezes, você buscaria dados da internet ou de um banco de dados local
e converteria esses dados em uma lista de itens.

Para este exemplo, gere uma lista de itens para trabalhar. A lista
contém um cabeçalho seguido por cinco mensagens. Cada mensagem tem um
de 3 tipos: `ListItem`, `HeadingItem`, ou `MessageItem`.

<?code-excerpt "lib/main.dart (Items)" replace="/^items:/final items =/g;/^\),$/);/g"?>
```dart
final items = List<ListItem>.generate(
  1000,
  (i) => i % 6 == 0
      ? HeadingItem('Heading $i')
      : MessageItem('Sender $i', 'Message body $i'),
);
```

## 2. Converter a fonte de dados em uma lista de widgets

Para converter cada item em um widget,
use o construtor [`ListView.builder()`][].

Em geral, forneça uma função builder que verifica com qual tipo
de item você está lidando e retorna o widget apropriado
para esse tipo de item.

<?code-excerpt "lib/main.dart (builder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  // Let the ListView know how many items it needs to build.
  itemCount: items.length,
  // Provide a builder function. This is where the magic happens.
  // Convert each item into a widget based on the type of item it is.
  itemBuilder: (context, index) {
    final item = items[index];

    return ListTile(
      title: item.buildTitle(context),
      subtitle: item.buildSubtitle(context),
    );
  },
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter create mixed lists hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(
      items: List<ListItem>.generate(
        1000,
        (i) => i % 6 == 0
            ? HeadingItem('Heading $i')
            : MessageItem('Sender $i', 'Message body $i'),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;

  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Mixed List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
          itemBuilder: (context, index) {
            final item = items[index];

            return ListTile(
              title: item.buildTitle(context),
              subtitle: item.buildSubtitle(context),
            );
          },
        ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/mixed-list.png" alt="Mixed list demo" class="site-mobile-screenshot" />
</noscript>


[`ListView.builder()`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
