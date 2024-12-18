---
ia-translate: true
title: Trabalhando com listas longas
description: Use ListView.builder para implementar uma lista longa ou infinita.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/long_lists/"?>

O construtor padrão [`ListView`][] funciona bem para listas pequenas. Para trabalhar com listas que contêm um grande número de itens, é melhor usar o construtor [`ListView.builder`][].

Em contraste com o construtor `ListView` padrão, que exige a criação de todos os itens de uma vez, o construtor `ListView.builder()` cria os itens à medida que eles são rolados para a tela.

## 1. Crie uma fonte de dados

Primeiro, você precisa de uma fonte de dados. Por exemplo, sua fonte de dados pode ser uma lista de mensagens, resultados de pesquisa ou produtos em uma loja. Na maioria das vezes, esses dados vêm da internet ou de um banco de dados.

Para este exemplo, gere uma lista de 10.000 Strings usando o construtor [`List.generate`][].

<?code-excerpt "lib/main.dart (Items)" replace="/^items: //g"?>
```dart
List<String>.generate(10000, (i) => 'Item $i'),
```

## 2. Converta a fonte de dados em widgets

Para exibir a lista de strings, renderize cada String como um widget usando `ListView.builder()`. Neste exemplo, exiba cada String em sua própria linha.

<?code-excerpt "lib/main.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  prototypeItem: ListTile(
    title: Text(items.first),
  ),
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index]),
    );
  },
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de criação de lista longa em Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    MyApp(
      items: List<String>.generate(10000, (i) => 'Item $i'),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<String> items;

  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Lista Longa';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          itemCount: items.length,
          prototypeItem: ListTile(
            title: Text(items.first),
          ),
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(items[index]),
            );
          },
        ),
      ),
    );
  }
}
```

## Extensão dos filhos (Children's extent)

Para especificar a extensão de cada item, você pode usar [`prototypeItem`][], [`itemExtent`][] ou [`itemExtentBuilder`][].

Especificar qualquer um deles é mais eficiente do que deixar os filhos determinarem sua própria extensão, porque o mecanismo de rolagem pode usar o conhecimento prévio da extensão dos filhos para economizar trabalho, por exemplo, quando a posição de rolagem muda drasticamente.

Use [`prototypeItem`][] ou [`itemExtent`][] se sua lista tiver itens de tamanho fixo.

Use [`itemExtentBuilder`][] se sua lista tiver itens de tamanhos diferentes.

<noscript>
  <img src="/assets/images/docs/cookbook/long-lists.gif" alt="Demonstração de listas longas" class="site-mobile-screenshot" />
</noscript>

[`List.generate`]: {{site.api}}/flutter/dart-core/List/List.generate.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`prototypeItem`]: {{site.api}}/flutter/widgets/ListView/prototypeItem.html
[`itemExtent`]: {{site.api}}/flutter/widgets/ListView/itemExtent.html
[`itemExtentBuilder`]: {{site.api}}/flutter/widgets/ListView/itemExtentBuilder.html
