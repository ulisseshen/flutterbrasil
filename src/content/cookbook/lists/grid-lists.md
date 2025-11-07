---
title: Criar uma grid list
description: Como implementar uma grid list.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/lists/grid_lists"?>

Em alguns casos, você pode querer exibir seus itens como uma grade em vez de
uma lista normal de itens que vêm um após o outro.
Para esta tarefa, use o widget [`GridView`][].

A maneira mais simples de começar a usar grades é usando o
construtor [`GridView.count()`][],
porque permite que você especifique quantas linhas ou colunas você gostaria.

Para visualizar como `GridView` funciona,
gere uma lista de 100 widgets que exibem seu índice na lista.

<?code-excerpt "lib/main.dart (GridView)" replace="/^body\: //g"?>
```dart
GridView.count(
  // Create a grid with 2 columns. If you change the scrollDirection to
  // horizontal, this produces 2 rows.
  crossAxisCount: 2,
  // Generate 100 widgets that display their index in the List.
  children: List.generate(100, (index) {
    return Center(
      child: Text(
        'Item $index',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }),
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter GridView hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Grid List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
          // Create a grid with 2 columns. If you change the scrollDirection to
          // horizontal, this produces 2 rows.
          crossAxisCount: 2,
          // Generate 100 widgets that display their index in the List.
          children: List.generate(100, (index) {
            return Center(
              child: Text(
                'Item $index',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          }),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/grid-list.gif" alt="Grid List Demo" class="site-mobile-screenshot" />
</noscript>

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`GridView.count()`]: {{site.api}}/flutter/widgets/GridView/GridView.count.html
