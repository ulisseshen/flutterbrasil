---
ia-translate: true
title: Criar listas com diferentes tipos de itens
description: Como implementar uma lista que contém diferentes tipos de elementos.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/mixed_list/"?>

Pode ser necessário criar listas que exibam diferentes tipos de conteúdo.
Por exemplo, você pode estar trabalhando em uma lista que mostra um cabeçalho
seguido por alguns itens relacionados ao cabeçalho, seguido por outro cabeçalho,
e assim por diante.

Veja como você pode criar essa estrutura com o Flutter:

  1. Crie uma fonte de dados com diferentes tipos de itens.
  2. Converta a fonte de dados em uma lista de widgets.

## 1. Crie uma fonte de dados com diferentes tipos de itens

### Tipos de itens

Para representar diferentes tipos de itens em uma lista, defina
uma classe para cada tipo de item.

Neste exemplo, crie um aplicativo que mostre um cabeçalho seguido por cinco
mensagens. Portanto, crie três classes: `ListItem`, `HeadingItem` e
`MessageItem`.

<?code-excerpt "lib/main.dart (ListItem)"?>
```dart
/// A classe base para os diferentes tipos de itens que a lista pode conter.
abstract class ListItem {
  /// A linha de título a ser exibida em um item da lista.
  Widget buildTitle(BuildContext context);

  /// A linha de subtítulo, se houver, a ser exibida em um item da lista.
  Widget buildSubtitle(BuildContext context);
}

/// Um ListItem que contém dados para exibir um cabeçalho.
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

/// Um ListItem que contém dados para exibir uma mensagem.
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

Na maioria das vezes, você buscaria dados da internet ou de um local
banco de dados e converteria esses dados em uma lista de itens.

Para este exemplo, gere uma lista de itens para trabalhar. A lista
contém um cabeçalho seguido por cinco mensagens. Cada mensagem tem um
de 3 tipos: `ListItem`, `HeadingItem` ou `MessageItem`.

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

Em geral, forneça uma função builder que verifique com qual tipo
de item você está lidando e retorne o widget apropriado
para esse tipo de item.

<?code-excerpt "lib/main.dart (builder)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  // Permita que o ListView saiba quantos itens ele precisa construir.
  itemCount: items.length,
  // Forneça uma função builder. É aqui que a mágica acontece.
  // Converta cada item em um widget com base no tipo de item que ele é.
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
```dartpad title="Exemplo prático de criação de listas mistas no Flutter com DartPad" run="true"
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
    const title = 'Lista Mista';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          // Permita que o ListView saiba quantos itens ele precisa construir.
          itemCount: items.length,
          // Forneça uma função builder. É aqui que a mágica acontece.
          // Converta cada item em um widget com base no tipo de item que ele é.
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

/// A classe base para os diferentes tipos de itens que a lista pode conter.
abstract class ListItem {
  /// A linha de título a ser exibida em um item da lista.
  Widget buildTitle(BuildContext context);

  /// A linha de subtítulo, se houver, a ser exibida em um item da lista.
  Widget buildSubtitle(BuildContext context);
}

/// Um ListItem que contém dados para exibir um cabeçalho.
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

/// Um ListItem que contém dados para exibir uma mensagem.
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
  <img src="/assets/images/docs/cookbook/mixed-list.png" alt="Demonstração de lista mista" class="site-mobile-screenshot" />
</noscript>

[`ListView.builder()`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
