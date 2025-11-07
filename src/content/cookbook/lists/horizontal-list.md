---
title: Criar uma lista horizontal
description: Como implementar uma lista horizontal.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/lists/horizontal_list"?>

Você pode querer criar uma lista que role
horizontalmente em vez de verticalmente.
O widget [`ListView`][] suporta listas horizontais.

Use o construtor padrão `ListView`, passando um
`scrollDirection` horizontal, que substitui a direção vertical padrão.

<?code-excerpt "lib/main.dart (ListView)" replace="/^child\: //g"?>
```dart
ListView(
  // This next line does the trick.
  scrollDirection: Axis.horizontal,
  children: <Widget>[
    Container(
      width: 160,
      color: Colors.red,
    ),
    Container(
      width: 160,
      color: Colors.blue,
    ),
    Container(
      width: 160,
      color: Colors.green,
    ),
    Container(
      width: 160,
      color: Colors.yellow,
    ),
    Container(
      width: 160,
      color: Colors.orange,
    ),
  ],
),
```

## Exemplo interativo

:::note Nota para Desktop e web
Este exemplo funciona no navegador e no desktop.
No entanto, como esta lista rola no eixo horizontal
(esquerda para direita ou direita para esquerda),
segure <kbd>Shift</kbd> enquanto usa a roda de rolagem do mouse para rolar a lista.

Para saber mais, leia a página de [breaking change][] sobre o
drag padrão para dispositivos de rolagem.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter horizontal list hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Horizontal List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 200,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                width: 160,
                color: Colors.red,
              ),
              Container(
                width: 160,
                color: Colors.blue,
              ),
              Container(
                width: 160,
                color: Colors.green,
              ),
              Container(
                width: 160,
                color: Colors.yellow,
              ),
              Container(
                width: 160,
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/horizontal-list.gif" alt="Horizontal List Demo" class="site-mobile-screenshot" />
</noscript>

[breaking change]: /release/breaking-changes/default-scroll-behavior-drag
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
