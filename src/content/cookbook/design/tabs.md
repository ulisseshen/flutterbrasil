---
ia-translate: true
title: Trabalhando com abas
description: Como implementar abas em um layout.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/tabs/"?>

Trabalhar com abas é um *design pattern* comum em aplicativos que seguem as diretrizes do Material Design. O Flutter inclui uma maneira conveniente de criar layouts de abas como parte da [biblioteca Material][].

Esta receita cria um exemplo com abas usando os seguintes passos:

  1. Crie um `TabController`.
  2. Crie as abas.
  3. Crie o conteúdo para cada aba.

## 1. Crie um `TabController`

Para que as abas funcionem, é necessário manter a aba selecionada e as seções de conteúdo em sincronia. Este é o trabalho do [`TabController`][].

Você pode criar um `TabController` manualmente, ou automaticamente usando um widget [`DefaultTabController`][].

Usar `DefaultTabController` é a opção mais simples, pois ele cria um `TabController` e o disponibiliza para todos os widgets descendentes.

<?code-excerpt "lib/partials.dart (TabController)"?>
```dart
return MaterialApp(
  home: DefaultTabController(
    length: 3,
    child: Scaffold(),
  ),
);
```

## 2. Crie as abas

Quando uma aba é selecionada, ela precisa exibir conteúdo. Você pode criar abas usando o widget [`TabBar`][]. Neste exemplo, crie um `TabBar` com três widgets [`Tab`][] e coloque-o dentro de um [`AppBar`][].

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

Por padrão, o `TabBar` procura na árvore de widgets pelo `DefaultTabController` mais próximo. Se você estiver criando um `TabController` manualmente, passe-o para o `TabBar`.

## 3. Crie conteúdo para cada aba

Agora que você tem as abas, exiba o conteúdo quando uma aba for selecionada. Para isso, use o widget [`TabBarView`][].

:::note
A ordem é importante e deve corresponder à ordem das abas no `TabBar`.
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
```dartpad title="Exemplo prático de Flutter TabBar no DartPad" run="true"
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
  <img src="/assets/images/docs/cookbook/tabs.gif" alt="Tabs Demo" class="site-mobile-screenshot" />
</noscript>


[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`DefaultTabController`]: {{site.api}}/flutter/material/DefaultTabController-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
[`Tab`]: {{site.api}}/flutter/material/Tab-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBarView`]: {{site.api}}/flutter/material/TabBarView-class.html
[`TabController`]: {{site.api}}/flutter/material/TabController-class.html
