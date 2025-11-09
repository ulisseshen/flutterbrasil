---
ia-translate: true
title: Adicionar um drawer a uma tela
description: Como implementar um Material Drawer.
---

<?code-excerpt path-base="cookbook/design/drawer"?>

Em apps que usam Material Design,
existem duas opções principais para navegação: tabs e drawers.
Quando não há espaço suficiente para suportar tabs,
drawers fornecem uma alternativa útil.

No Flutter, use o widget [`Drawer`][] em combinação com um
[`Scaffold`][] para criar um layout com um drawer Material Design.
Esta receita usa os seguintes passos:

  1. Criar um `Scaffold`.
  2. Adicionar um drawer.
  3. Preencher o drawer com itens.
  4. Fechar o drawer programaticamente.

## 1. Criar um `Scaffold`

Para adicionar um drawer ao app, envolva-o em um widget [`Scaffold`][].
O widget `Scaffold` fornece uma estrutura visual consistente para apps que
seguem as Diretrizes do Material Design.
Ele também suporta componentes especiais do Material Design,
como Drawers, AppBars, e SnackBars.

Neste exemplo, crie um `Scaffold` com um `drawer`:

<?code-excerpt "lib/drawer.dart (DrawerStart)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(title: const Text('AppBar without hamburger button')),
  drawer: // Add a Drawer here in the next step.
);
```

## 2. Adicionar um drawer

Agora adicione um drawer ao `Scaffold`. Um drawer pode ser qualquer widget,
mas geralmente é melhor usar o widget `Drawer` da
[biblioteca material][material library],
que adere à especificação do Material Design.

<?code-excerpt "lib/drawer.dart (DrawerEmpty)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(title: const Text('AppBar with hamburger button')),
  drawer: Drawer(
    child: // Populate the Drawer in the next step.
  ),
);
```

## 3. Preencher o drawer com itens

Agora que você tem um `Drawer` em vigor, adicione conteúdo a ele.
Para este exemplo, use um [`ListView`][].
Embora você possa usar um widget `Column`,
`ListView` é conveniente porque permite que os usuários rolem
pelo drawer se o
conteúdo ocupar mais espaço do que a tela suporta.

Preencha o `ListView` com um [`DrawerHeader`][]
e dois widgets [`ListTile`][].
Para mais informações sobre trabalhar com Listas,
veja as [receitas de lista][list recipes].

<?code-excerpt "lib/drawer.dart (DrawerListView)"?>
```dart
Drawer(
  // Add a ListView to the drawer. This ensures the user can scroll
  // through the options in the drawer if there isn't enough vertical
  // space to fit everything.
  child: ListView(
    // Important: Remove any padding from the ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(color: Colors.blue),
        child: Text('Drawer Header'),
      ),
      ListTile(
        title: const Text('Item 1'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
      ListTile(
        title: const Text('Item 2'),
        onTap: () {
          // Update the state of the app.
          // ...
        },
      ),
    ],
  ),
);
```

## 4. Abrir o drawer programaticamente

Normalmente, você não precisa escrever nenhum código para abrir um `drawer`,
porque quando o widget `leading` é null, a implementação padrão em `AppBar` é `DrawerButton`.

Mas se você quiser ter controle livre do `drawer`.
Você pode fazer isso usando o `Builder` chamando `Scaffold.of(context).openDrawer()`.

<?code-excerpt "lib/drawer.dart (DrawerOpen)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar with hamburger button'),
    leading: Builder(
      builder: (context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    ),
  ),
  drawer: Drawer(
    child: // Populate the Drawer in the last step.
  ),
);
```

## 5. Fechar o drawer programaticamente

Depois que um usuário toca em um item, você pode querer fechar o drawer.
Você pode fazer isso usando o [`Navigator`][].

Quando um usuário abre o drawer, Flutter adiciona o drawer à pilha de
navegação. Portanto, para fechar o drawer, chame `Navigator.pop(context)`.

<?code-excerpt "lib/drawer.dart (CloseDrawer)"?>
```dart
ListTile(
  title: const Text('Item 1'),
  onTap: () {
    // Update the state of the app
    // ...
    // Then close the drawer
    Navigator.pop(context);
  },
),
```

## Exemplo interativo

Este exemplo mostra um [`Drawer`][] como ele é usado dentro de um widget [`Scaffold`][].
O [`Drawer`][] tem três itens [`ListTile`][].
A função `_onItemTapped` muda o índice do item selecionado
e exibe o texto correspondente no centro do `Scaffold`.

:::note
Para mais informações sobre implementar navegação,
confira a seção [Navigation][] do cookbook.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de drawer Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Drawer Demo';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Index 0: Home', style: optionStyle),
    Text('Index 1: Business', style: optionStyle),
    Text('Index 2: School', style: optionStyle),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: Center(child: _widgetOptions[_selectedIndex]),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Update the state of the app
                _onItemTapped(0);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Business'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                _onItemTapped(1);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('School'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Update the state of the app
                _onItemTapped(2);
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/drawer.png" alt="Drawer Demo" class="site-mobile-screenshot" />
</noscript>


[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`DrawerHeader`]: {{site.api}}/flutter/material/DrawerHeader-class.html
[list recipes]: /cookbook/lists
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[Navigation]: /cookbook/navigation
