---
ia-translate: true
title: Criar uma lista horizontal
description: Como implementar uma lista horizontal.
---

<?code-excerpt path-base="cookbook/lists/horizontal_list"?>

Você pode querer criar uma lista que rola
horizontalmente em vez de verticalmente.
O widget [`ListView`][`ListView`] suporta listas horizontais.

Use o construtor padrão `ListView`, passando uma
`scrollDirection` horizontal, que sobrescreve a direção vertical padrão.

<?code-excerpt "lib/main.dart (list-view)" replace="/^child\: //g"?>
```dart highlightLines=2
ListView(
  scrollDirection: Axis.horizontal,
  children: [
    for (final color in Colors.primaries)
      Container(width: 160, color: color),
  ],
),
```

[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter horizontal list hands-on example in DartPad" run="true"
import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Horizontal list';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 200,
          child: ScrollConfiguration(
            // Add a custom scroll behavior that
            // allows all devices to drag the list.
            behavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {...PointerDeviceKind.values},
            ),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                for (final color in Colors.primaries)
                  Container(width: 160, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/horizontal-list.webp" alt="Horizontal List Demo" class="site-mobile-screenshot" />
</noscript>
