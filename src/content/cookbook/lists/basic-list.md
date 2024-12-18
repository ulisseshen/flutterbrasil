---
ia-translate: true
title: Usar listas
description: Como implementar uma lista.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/basic_list"?>

Exibir listas de dados é um padrão fundamental para aplicativos móveis.
O Flutter inclui o widget [`ListView`][]
para facilitar o trabalho com listas.

## Criar um ListView

Usar o construtor padrão `ListView` é
perfeito para listas que contêm apenas alguns itens.
O widget [`ListTile`][] integrado
é uma maneira de dar aos itens uma estrutura visual.

<?code-excerpt "lib/main.dart (ListView)" replace="/^body\: //g"?>
```dart
ListView(
  children: const <Widget>[
    ListTile(
      leading: Icon(Icons.map),
      title: Text('Mapa'),
    ),
    ListTile(
      leading: Icon(Icons.photo_album),
      title: Text('Álbum'),
    ),
    ListTile(
      leading: Icon(Icons.phone),
      title: Text('Telefone'),
    ),
  ],
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de listas do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Lista Básica';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView(
          children: const <Widget>[
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Mapa'),
            ),
            ListTile(
              leading: Icon(Icons.photo_album),
              title: Text('Álbum'),
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text('Telefone'),
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/basic-list.png" alt="Demonstração de Lista Básica" class="site-mobile-screenshot" /> 
</noscript>


[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
