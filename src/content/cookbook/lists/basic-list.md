---
ia-translate: true
title: Use listas
description: Como implementar uma lista.
---

<?code-excerpt path-base="cookbook/lists/basic_list"?>

Exibir listas de dados é um padrão fundamental para apps mobile.
O Flutter inclui o widget [`ListView`][`ListView`]
para facilitar o trabalho com listas.

## Crie um ListView

Usar o construtor padrão do `ListView` é
perfeito para listas que contêm apenas alguns itens.
O widget [`ListTile`][`ListTile`] integrado
é uma forma de dar aos itens uma estrutura visual.

<?code-excerpt "lib/main.dart (ListView)" replace="/^body\: //g"?>
```dart
ListView(
  children: const <Widget>[
    ListTile(leading: Icon(Icons.map), title: Text('Map')),
    ListTile(leading: Icon(Icons.photo_album), title: Text('Album')),
    ListTile(leading: Icon(Icons.phone), title: Text('Phone')),
  ],
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter lists hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Basic List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: ListView(
          children: const <Widget>[
            ListTile(leading: Icon(Icons.map), title: Text('Map')),
            ListTile(leading: Icon(Icons.photo_album), title: Text('Album')),
            ListTile(leading: Icon(Icons.phone), title: Text('Phone')),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/basic-list.png" alt="Basic List Demo" class="site-mobile-screenshot" />
</noscript>


[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
