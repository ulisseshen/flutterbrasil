---
title: Colocar uma app bar flutuante acima de uma lista
description: Como colocar uma app bar flutuante acima de uma lista.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/lists/floating_app_bar/"?>

Para facilitar aos usuários visualizar uma lista de itens,
você pode querer ocultar a app bar conforme o usuário rola para baixo na lista.
Isso é especialmente verdadeiro se seu aplicativo exibe uma app bar "alta"
que ocupa muito espaço vertical.

Normalmente, você cria uma app bar fornecendo uma propriedade `appBar` ao
widget `Scaffold`. Isso cria uma app bar fixa que sempre permanece acima
do `body` do `Scaffold`.

Mover a app bar de um widget `Scaffold` para um
[`CustomScrollView`][] permite que você crie uma app bar
que rola para fora da tela conforme você rola através de uma
lista de itens contidos dentro do `CustomScrollView`.

Esta receita demonstra como usar um `CustomScrollView` para exibir uma lista de
itens com uma app bar no topo que rola para fora da tela conforme o usuário rola
para baixo na lista usando os seguintes passos:

  1. Criar um `CustomScrollView`.
  2. Usar `SliverAppBar` para adicionar uma app bar flutuante.
  3. Adicionar uma lista de itens usando uma `SliverList`.

## 1. Criar um `CustomScrollView`

Para criar uma app bar flutuante, coloque a app bar dentro de um
`CustomScrollView` que também contém a lista de itens.
Isso sincroniza a posição de rolagem da app bar e da lista de itens.
Você pode pensar no widget `CustomScrollView` como uma `ListView`
que permite misturar e combinar diferentes tipos de listas roláveis
e widgets juntos.

As listas roláveis e widgets fornecidos ao
`CustomScrollView` são conhecidos como _slivers_. Existem vários tipos
de slivers, como `SliverList`, `SliverGrid`, e `SliverAppBar`.
De fato, os widgets `ListView` e `GridView` usam os widgets `SliverList` e
`SliverGrid` para implementar rolagem.

Para este exemplo, crie um `CustomScrollView` que contém um
`SliverAppBar` e uma `SliverList`. Além disso, remova quaisquer app bars
que você fornece ao widget `Scaffold`.

<?code-excerpt "lib/starter.dart (CustomScrollView)" replace="/^return const //g"?>
```dart
Scaffold(
  // No appBar property provided, only the body.
  body: CustomScrollView(
      // Add the app bar and list of items as slivers in the next steps.
      slivers: <Widget>[]),
);
```

### 2. Usar `SliverAppBar` para adicionar uma app bar flutuante

A seguir, adicione uma app bar ao [`CustomScrollView`][].
O Flutter fornece o widget [`SliverAppBar`][] que,
muito parecido com o widget normal `AppBar`,
usa o `SliverAppBar` para exibir um título,
tabs, images e muito mais.

No entanto, o `SliverAppBar` também oferece a capacidade de criar uma
app bar "flutuante" que rola para fora da tela conforme o usuário rola para baixo na lista.
Além disso, você pode configurar o `SliverAppBar` para encolher e
expandir conforme o usuário rola.

Para criar este efeito:

  1. Comece com uma app bar que exibe apenas um título.
  2. Defina a propriedade `floating` como `true`.
     Isso permite que os usuários revelem rapidamente a app bar quando
     rolam para cima na lista.
  3. Adicione um widget `flexibleSpace` que preenche o
     `expandedHeight` disponível.

<?code-excerpt "lib/step2.dart (SliverAppBar)" replace="/^body: //g;/^\),$/)/g"?>
```dart
CustomScrollView(
  slivers: [
    // Add the app bar to the CustomScrollView.
    SliverAppBar(
      // Provide a standard title.
      title: Text(title),
      // Allows the user to reveal the app bar if they begin scrolling
      // back up the list of items.
      floating: true,
      // Display a placeholder widget to visualize the shrinking size.
      flexibleSpace: Placeholder(),
      // Make the initial height of the SliverAppBar larger than normal.
      expandedHeight: 200,
    ),
  ],
)
```

:::tip
Experimente as
[várias propriedades que você pode passar ao widget `SliverAppBar`][],
e use hot reload para ver os resultados. Por exemplo, use um widget `Image`
para a propriedade `flexibleSpace` para criar uma imagem de fundo que
encolhe em tamanho conforme é rolada para fora da tela.
:::


### 3. Adicionar uma lista de itens usando uma `SliverList`

Agora que você tem a app bar no lugar, adicione uma lista de itens ao
`CustomScrollView`. Você tem duas opções: uma [`SliverList`][]
ou uma [`SliverGrid`][].  Se você precisa exibir uma lista de itens um após o outro,
use o widget `SliverList`.
Se você precisa exibir uma lista em grade, use o widget `SliverGrid`.

Os widgets `SliverList` e `SliverGrid` recebem um parâmetro obrigatório: um
[`SliverChildDelegate`][], que fornece uma lista
de widgets para `SliverList` ou `SliverGrid`.
Por exemplo, o [`SliverChildBuilderDelegate`][]
permite que você crie uma lista de itens que são construídos preguiçosamente conforme você rola,
assim como o widget `ListView.builder`.

<?code-excerpt "lib/main.dart (SliverList)" replace="/^\),$/)/g"?>
```dart
// Next, create a SliverList
SliverList(
  // Use a delegate to build items as they're scrolled on screen.
  delegate: SliverChildBuilderDelegate(
    // The builder function returns a ListTile with a title that
    // displays the index of the current item.
    (context, index) => ListTile(title: Text('Item #$index')),
    // Builds 1000 ListTiles
    childCount: 1000,
  ),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Floating AppBar hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Floating App Bar';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // No appbar provided to the Scaffold, only a body with a
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Add the app bar to the CustomScrollView.
            const SliverAppBar(
              // Provide a standard title.
              title: Text(title),
              // Allows the user to reveal the app bar if they begin scrolling
              // back up the list of items.
              floating: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 200,
            ),
            // Next, create a SliverList
            SliverList(
              // Use a delegate to build items as they're scrolled on screen.
              delegate: SliverChildBuilderDelegate(
                // The builder function returns a ListTile with a title that
                // displays the index of the current item.
                (context, index) => ListTile(title: Text('Item #$index')),
                // Builds 1000 ListTiles
                childCount: 1000,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/floating-app-bar.gif" alt="Use list demo" class="site-mobile-screenshot"/>
</noscript>


[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[`SliverAppBar`]: {{site.api}}/flutter/material/SliverAppBar-class.html
[`SliverChildBuilderDelegate`]: {{site.api}}/flutter/widgets/SliverChildBuilderDelegate-class.html
[`SliverChildDelegate`]: {{site.api}}/flutter/widgets/SliverChildDelegate-class.html
[`SliverGrid`]: {{site.api}}/flutter/widgets/SliverGrid-class.html
[`SliverList`]: {{site.api}}/flutter/widgets/SliverList-class.html
[várias propriedades que você pode passar ao widget `SliverAppBar`]: {{site.api}}/flutter/material/SliverAppBar/SliverAppBar.html
