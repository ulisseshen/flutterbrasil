---
ia-translate: true
title: Trabalhar com listas longas
description: Use ListView.builder para implementar uma lista longa ou infinita.
---

<?code-excerpt path-base="cookbook/lists/long_lists/"?>

O construtor padrão de [`ListView`][`ListView`] funciona bem
para listas pequenas. Para trabalhar com listas que contêm
um grande número de itens, é melhor usar o
construtor [`ListView.builder`][`ListView.builder`].

Em contraste com o construtor padrão `ListView`, que requer
criar todos os itens de uma vez, o construtor `ListView.builder()`
cria itens conforme eles são exibidos na tela.

## 1. Criar uma fonte de dados

Primeiro, você precisa de uma fonte de dados. Por exemplo, sua fonte de dados
pode ser uma lista de mensagens, resultados de pesquisa ou produtos em uma loja.
Na maioria das vezes, esses dados vêm da internet ou de um banco de dados.

Para este exemplo, gere uma lista de 10.000 Strings usando o
construtor [`List.generate`][`List.generate`].

<?code-excerpt "lib/main.dart (Items)" replace="/^items: //g"?>
```dart
List<String>.generate(10000, (i) => 'Item $i'),
```

## 2. Converter a fonte de dados em widgets

Para exibir a lista de strings, renderize cada String como um widget
usando `ListView.builder()`.
Neste exemplo, exiba cada String em sua própria linha.

<?code-excerpt "lib/main.dart (ListView)" replace="/^body: //g;/^\),$/)/g"?>
```dart
ListView.builder(
  itemCount: items.length,
  prototypeItem: ListTile(title: Text(items.first)),
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter create long list hands-on example in DartPad" run="true"
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
    const title = 'Long List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: ListView.builder(
          itemCount: items.length,
          prototypeItem: ListTile(title: Text(items.first)),
          itemBuilder: (context, index) {
            return ListTile(title: Text(items[index]));
          },
        ),
      ),
    );
  }
}
```

## Extensão dos filhos

Para especificar a extensão de cada item, você pode usar [`prototypeItem`][`prototypeItem`], [`itemExtent`][`itemExtent`],
ou [`itemExtentBuilder`][`itemExtentBuilder`].

Especificar qualquer um deles é mais eficiente do que deixar os filhos determinarem sua própria extensão
porque a maquinaria de rolagem pode fazer uso do conhecimento prévio da extensão dos filhos
para economizar trabalho, por exemplo, quando a posição de rolagem muda drasticamente.

Use [`prototypeItem`][`prototypeItem`] ou [`itemExtent`][`itemExtent`] se sua lista tiver itens de tamanho fixo.

Use [`itemExtentBuilder`][`itemExtentBuilder`] se sua lista tiver itens de tamanhos diferentes.

<noscript>
  <img src="/assets/images/docs/cookbook/long-lists.webp" alt="Long Lists Demo" class="site-mobile-screenshot" />
</noscript>

[`List.generate`]: {{site.api}}/flutter/dart-core/List/List.generate.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`prototypeItem`]: {{site.api}}/flutter/widgets/ListView/prototypeItem.html
[`itemExtent`]: {{site.api}}/flutter/widgets/ListView/itemExtent.html
[`itemExtentBuilder`]: {{site.api}}/flutter/widgets/ListView/itemExtentBuilder.html
