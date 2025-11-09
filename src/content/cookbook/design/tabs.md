---
ia-translate: true
title: Trabalhar com tabs
description: Como implementar tabs em um layout.
---

<?code-excerpt path-base="cookbook/design/tabs/"?>

Trabalhar com tabs é um padrão comum em apps que seguem as
diretrizes do Material Design.
Flutter inclui uma maneira conveniente de criar layouts com tabs como parte da
[biblioteca material][material library].

Esta receita cria um exemplo com tabs usando os seguintes passos:

  1. Criar um `TabController`.
  2. Criar as tabs.
  3. Criar conteúdo para cada tab.

## 1. Criar um `TabController`

Para que as tabs funcionem, você precisa manter a tab selecionada e as
seções de conteúdo sincronizadas.
Este é o trabalho do [`TabController`][].

Crie um `TabController` manualmente,
ou automaticamente usando um widget [`DefaultTabController`][].

Usar `DefaultTabController` é a opção mais simples, pois ele
cria um `TabController` e o torna disponível para todos os widgets descendentes.

<?code-excerpt "lib/partials.dart (TabController)"?>
```dart
return MaterialApp(
  home: DefaultTabController(length: 3, child: Scaffold()),
);
```

## 2. Criar as tabs

Quando uma tab é selecionada, ela precisa exibir conteúdo.
Você pode criar tabs usando o widget [`TabBar`][].
Neste exemplo, crie uma `TabBar` com três
widgets [`Tab`][] e a coloque dentro de um [`AppBar`][].

<?code-excerpt "lib/partials.dart (Tabs)"?>
```dart
return MaterialApp(
  home: DefaultTabController(
    length: 3,
    child: Scaffold(
      appBar: AppBar(
        bottom: const TabBar(
          tabs: [
            Tab(icon: Icon(Icons.directions_car)),
            Tab(icon: Icon(Icons.directions_transit)),
            Tab(icon: Icon(Icons.directions_bike)),
          ],
        ),
      ),
    ),
  ),
);
```

Por padrão, a `TabBar` procura na árvore de widgets pelo
`DefaultTabController` mais próximo. Se você estiver criando manualmente um `TabController`,
passe-o para a `TabBar`.

## 3. Criar conteúdo para cada tab

Agora que você tem tabs, exiba conteúdo quando uma tab for selecionada.
Para este propósito, use o widget [`TabBarView`][].

:::note
A ordem é importante e deve corresponder à
ordem das tabs na `TabBar`.
:::

<?code-excerpt "lib/main.dart (TabBarView)"?>
```dart
body: const TabBarView(
  children: [
    Icon(Icons.directions_car),
    Icon(Icons.directions_transit),
    Icon(Icons.directions_bike),
  ],
),
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de TabBar Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const TabBarDemo());
}

class TabBarDemo extends StatelessWidget {
  const TabBarDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(icon: Icon(Icons.directions_transit)),
                Tab(icon: Icon(Icons.directions_bike)),
              ],
            ),
            title: const Text('Tabs Demo'),
          ),
          body: const TabBarView(
            children: [
              Icon(Icons.directions_car),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/tabs.webp" alt="Tabs Demo" class="site-mobile-screenshot" />
</noscript>


[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`DefaultTabController`]: {{site.api}}/flutter/material/DefaultTabController-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
[`Tab`]: {{site.api}}/flutter/material/Tab-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBarView`]: {{site.api}}/flutter/material/TabBarView-class.html
[`TabController`]: {{site.api}}/flutter/material/TabController-class.html
