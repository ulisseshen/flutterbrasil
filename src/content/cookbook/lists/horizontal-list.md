---
ia-translate: true
title: Criar uma lista horizontal
description: Como implementar uma lista horizontal.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/horizontal_list"?>

Você pode querer criar uma lista que role horizontalmente em vez de verticalmente. O widget [`ListView`][] suporta listas horizontais.

Use o construtor padrão `ListView`, passando um `scrollDirection` horizontal, que sobrepõe a direção vertical padrão.

<?code-excerpt "lib/main.dart (ListView)" replace="/^child\: //g"?>
```dart
ListView(
  // Esta próxima linha faz o truque.
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

:::note Nota para desktop e web
Este exemplo funciona no navegador e no desktop.
No entanto, como esta lista rola no eixo horizontal
(da esquerda para a direita ou da direita para a esquerda),
segure <kbd>Shift</kbd> enquanto usa a roda do mouse para rolar a lista.

Para saber mais, leia a página sobre [mudança de comportamento][] no
arraste padrão para dispositivos de rolagem.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de lista horizontal do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Lista Horizontal';

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
            // Esta próxima linha faz o truque.
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
  <img src="/assets/images/docs/cookbook/horizontal-list.gif" alt="Demonstração de Lista Horizontal" class="site-mobile-screenshot" />
</noscript>

[mudança de comportamento]: /release/breaking-changes/default-scroll-behavior-drag
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
