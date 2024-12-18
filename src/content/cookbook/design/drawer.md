---
ia-translate: true
title: Adicionar uma gaveta a uma tela
description: Como implementar uma gaveta do Material.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/design/drawer"?>

Em aplicativos que usam o Material Design,
existem duas opções principais para navegação: abas e gavetas.
Quando não há espaço suficiente para suportar abas,
as gavetas fornecem uma alternativa útil.

No Flutter, use o widget [`Drawer`][] em combinação com um
[`Scaffold`][] para criar um layout com uma gaveta do Material Design.
Esta receita usa os seguintes passos:

  1. Crie um `Scaffold`.
  2. Adicione uma gaveta.
  3. Preencha a gaveta com itens.
  4. Feche a gaveta programaticamente.

## 1. Crie um `Scaffold`

Para adicionar uma gaveta ao aplicativo, envolva-o em um widget [`Scaffold`][].
O widget `Scaffold` fornece uma estrutura visual consistente para aplicativos que
seguem as Diretrizes de Material Design.
Ele também oferece suporte a componentes especiais do Material Design,
como Gavetas, AppBars e SnackBars.

Neste exemplo, crie um `Scaffold` com uma `drawer`:

<?code-excerpt "lib/drawer.dart (DrawerStart)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar sem botão de menu'),
  ),
  drawer: // Adicione uma Gaveta aqui no próximo passo.
);
```

## 2. Adicione uma gaveta

Agora adicione uma gaveta ao `Scaffold`. Uma gaveta pode ser qualquer widget,
mas geralmente é melhor usar o widget `Drawer` da
[biblioteca material][],
que adere à especificação do Material Design.

<?code-excerpt "lib/drawer.dart (DrawerEmpty)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar com botão de menu'),
  ),
  drawer: Drawer(
    child: // Preencha a Gaveta no próximo passo.
  ),
);
```

## 3. Preencha a gaveta com itens

Agora que você tem um `Drawer` no lugar, adicione conteúdo a ele.
Para este exemplo, use um [`ListView`][].
Embora você possa usar um widget `Column`,
`ListView` é útil porque permite que os usuários rolem
pela gaveta se o
conteúdo ocupar mais espaço do que a tela suporta.

Preencha o `ListView` com um [`DrawerHeader`][]
e dois widgets [`ListTile`][].
Para obter mais informações sobre como trabalhar com Listas,
consulte as [receitas de lista][].

<?code-excerpt "lib/drawer.dart (DrawerListView)"?>
```dart
Drawer(
  // Adicione uma ListView à gaveta. Isso garante que o usuário possa rolar
  // pelas opções na gaveta se não houver espaço vertical suficiente
  // para caber tudo.
  child: ListView(
    // Importante: Remova qualquer preenchimento da ListView.
    padding: EdgeInsets.zero,
    children: [
      const DrawerHeader(
        decoration: BoxDecoration(
          color: Colors.blue,
        ),
        child: Text('Cabeçalho da Gaveta'),
      ),
      ListTile(
        title: const Text('Item 1'),
        onTap: () {
          // Atualize o estado do aplicativo.
          // ...
        },
      ),
      ListTile(
        title: const Text('Item 2'),
        onTap: () {
          // Atualize o estado do aplicativo.
          // ...
        },
      ),
    ],
  ),
);
```

## 4. Abra a gaveta programaticamente

Normalmente, você não precisa escrever nenhum código para abrir uma `drawer`,
porque quando o widget `leading` é nulo, a implementação padrão em `AppBar` é `DrawerButton`.

Mas se você quiser ter controle livre da `drawer`.
Você pode fazer isso usando a chamada `Builder` `Scaffold.of(context).openDrawer()`.

<?code-excerpt "lib/drawer.dart (DrawerOpen)" replace="/null, //g"?>
```dart
Scaffold(
  appBar: AppBar(
    title: const Text('AppBar com botão de menu'),
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
    child: // Preencha a Gaveta no último passo.
  ),
);
```

## 5. Feche a gaveta programaticamente

Depois que um usuário toca em um item, você pode querer fechar a gaveta.
Você pode fazer isso usando o [`Navigator`][].

Quando um usuário abre a gaveta, o Flutter adiciona a gaveta à pilha de navegação.
Portanto, para fechar a gaveta, chame `Navigator.pop(context)`.

<?code-excerpt "lib/drawer.dart (CloseDrawer)"?>
```dart
ListTile(
  title: const Text('Item 1'),
  onTap: () {
    // Atualize o estado do aplicativo
    // ...
    // Então feche a gaveta
    Navigator.pop(context);
  },
),
```

## Exemplo interativo

Este exemplo mostra um [`Drawer`][] como é usado dentro de um widget [`Scaffold`][].
O [`Drawer`][] tem três itens [`ListTile`][].
A função `_onItemTapped` altera o índice do item selecionado
e exibe o texto correspondente no centro do `Scaffold`.

:::note
Para obter mais informações sobre como implementar a navegação,
confira a seção [Navegação][] do cookbook.
:::

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de gaveta Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'Demonstração de Gaveta';

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
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Índice 0: Início',
      style: optionStyle,
    ),
    Text(
      'Índice 1: Negócios',
      style: optionStyle,
    ),
    Text(
      'Índice 2: Escola',
      style: optionStyle,
    ),
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
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        // Adicione uma ListView à gaveta. Isso garante que o usuário possa rolar
        // pelas opções na gaveta se não houver espaço vertical suficiente
        // para caber tudo.
        child: ListView(
          // Importante: Remova qualquer preenchimento da ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Cabeçalho da Gaveta'),
            ),
            ListTile(
              title: const Text('Início'),
              selected: _selectedIndex == 0,
              onTap: () {
                // Atualize o estado do aplicativo
                _onItemTapped(0);
                // Então feche a gaveta
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Negócios'),
              selected: _selectedIndex == 1,
              onTap: () {
                // Atualize o estado do aplicativo
                _onItemTapped(1);
                // Então feche a gaveta
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Escola'),
              selected: _selectedIndex == 2,
              onTap: () {
                // Atualize o estado do aplicativo
                _onItemTapped(2);
                // Então feche a gaveta
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
  <img src="/assets/images/docs/cookbook/drawer.png" alt="Demonstração de Gaveta" class="site-mobile-screenshot" />
</noscript>


[`Drawer`]: {{site.api}}/flutter/material/Drawer-class.html
[`DrawerHeader`]: {{site.api}}/flutter/material/DrawerHeader-class.html
[list recipes]: /cookbook#lists
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[material library]: {{site.api}}/flutter/material/material-library.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[Navigation]: /cookbook#navigation
