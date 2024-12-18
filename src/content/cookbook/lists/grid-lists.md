---
ia-translate: true
title: Criar uma lista em grade
description: Como implementar uma lista em grade.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/grid_lists"?>

Em alguns casos, você pode querer exibir seus itens como uma grade em vez de uma lista normal de itens que vêm um após o outro. Para esta tarefa, use o widget [`GridView`][].

A maneira mais simples de começar a usar grades é usando o construtor [`GridView.count()`][], porque ele permite especificar quantas linhas ou colunas você gostaria.

Para visualizar como `GridView` funciona, gere uma lista de 100 widgets que exibem seu índice na lista.

<?code-excerpt "lib/main.dart (GridView)" replace="/^body\: //g"?>
```dart
GridView.count(
  // Cria uma grade com 2 colunas. Se você alterar o scrollDirection para
  // horizontal, isso produz 2 linhas.
  crossAxisCount: 2,
  // Gera 100 widgets que exibem seu índice na Lista.
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
```dartpad title="Exemplo prático de Flutter GridView no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Lista em Grade';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: GridView.count(
          // Cria uma grade com 2 colunas. Se você alterar o scrollDirection para
          // horizontal, isso produz 2 linhas.
          crossAxisCount: 2,
          // Gera 100 widgets que exibem seu índice na Lista.
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
  <img src="/assets/images/docs/cookbook/grid-list.gif" alt="Demonstração de Lista em Grade" class="site-mobile-screenshot" />
</noscript>

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`GridView.count()`]: {{site.api}}/flutter/widgets/GridView/GridView.count.html
