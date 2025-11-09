---
ia-translate: true
title: Posicione uma app bar flutuante acima de uma lista
description: Como posicionar uma app bar flutuante ou barra de navegação acima de uma lista.
---

<?code-excerpt path-base="cookbook/lists/floating_app_bar/"?>

Este guia descreve como posicionar uma app bar flutuante ou
barra de navegação acima de uma lista em um app Flutter.

## Visão geral

Para facilitar a visualização de uma lista de itens pelos usuários,
você pode querer minimizar a app bar (barra de navegação) conforme
o usuário rola a lista para baixo.

Mover a app bar para um [`CustomScrollView`][`CustomScrollView`] permite
criar uma app bar que pode ser minimizada ou rolar
para fora da tela conforme você rola uma lista de itens contidos
dentro do `CustomScrollView`.

Esta receita demonstra como usar um `CustomScrollView` para
exibir uma lista de itens com uma app bar no topo que
minimiza conforme o usuário rola a lista para baixo usando os
seguintes passos:

  1. Crie um `CustomScrollView`.
  2. Adicione uma app bar flutuante ao `CustomScrollView`.
  3. Adicione uma lista de itens ao `CustomScrollView`.

## 1. Crie um `CustomScrollView`

Para criar uma app bar flutuante, posicione a app bar dentro de um
`CustomScrollView` que também contém a lista de itens.
Isso sincroniza a posição de rolagem da app bar e da
lista de itens. Você pode pensar no widget `CustomScrollView`
como um `ListView` que permite misturar e combinar
diferentes tipos de listas e widgets roláveis juntos.

As listas e widgets roláveis fornecidos ao
`CustomScrollView` são conhecidos como _slivers_. Existem vários
tipos de slivers, como `SliverList`, `SliverGrid` e
`SliverAppBar`. Na verdade, os widgets `ListView` e `GridView`
usam os widgets `SliverList` e `SliverGrid` para
implementar a rolagem.

Para este exemplo, crie um `CustomScrollView` que contém
um `SliverList`. Além disso, remova a propriedade app bar do seu
código se ela existir.

<Tabs key="device-type-tabs">

<Tab name="Material widgets">

<?code-excerpt "lib/starter_material.dart (CustomScrollView)" replace="/^return const //g"?>
```dart
MaterialApp(
  title: 'Floating App Bar',
  home: Scaffold(
    // No app bar property provided yet.
    body: CustomScrollView(
      // Add the app bar and list of items as slivers in the next steps.
      slivers: <Widget>[],
    ),
  ),
);
```

</Tab>

<Tab name="Cupertino widgets">

<?code-excerpt "lib/starter_cupertino.dart (CustomScrollView)" replace="/^return const //g"?>
```dart
CupertinoApp(
  title: 'Floating Navigation Bar',
  home: CupertinoPageScaffold(
    // No navigation bar property provided yet.
    child: CustomScrollView(
      // Add the navigation bar and list of items as slivers in the next steps.
      slivers: <Widget>[],
    ),
  ),
);
```

</Tab>

</Tabs>


## 2. Adicione uma app bar flutuante

Em seguida, adicione uma app bar ao [`CustomScrollView`][`CustomScrollView`].

<Tabs key="device-type-tabs">

<Tab name="Material widgets">

O Flutter fornece o widget [`SliverAppBar`][`SliverAppBar`] que,
assim como o widget `AppBar` normal,
usa o `SliverAppBar` para exibir um título,
abas, imagens e mais.

No entanto, o `SliverAppBar` também oferece a capacidade de
criar uma app bar "flutuante" que encolhe e flutua quando
você não está no topo da página.

Para criar este efeito:

  1. Comece com uma app bar que exibe apenas um título.
  2. Defina a propriedade `pinned` como `true`.
  3. Adicione um widget `flexibleSpace` que preenche a
     `expandedHeight` disponível.

<?code-excerpt "lib/step2_material.dart (SliverAppBar)" replace="/^body: //g;/^\),$/)/g"?>
```dart
slivers: [
  // Add the app bar to the CustomScrollView.
  SliverAppBar(
    // Provide a standard title.
    title: Text('Floating App Bar'),
    // Pin the app bar when scrolling.
    pinned: true,
    // Display a placeholder widget to visualize the shrinking size.
    flexibleSpace: Placeholder(),
    // Make the initial height of the SliverAppBar larger than normal.
    expandedHeight: 200,
  ),
],
```

:::tip
Experimente com as
[várias propriedades que você pode passar para o widget `SliverAppBar`][various properties you can pass to the `SliverAppBar` widget],
e use hot reload para ver os resultados. Por exemplo, use um
widget `Image` para a propriedade `flexibleSpace` para criar uma
imagem de fundo que encolhe conforme rola para fora da tela.
:::

</Tab>

<Tab name="Cupertino widgets">

O Flutter fornece o widget [`CupertinoSliverNavigationBar`][`CupertinoSliverNavigationBar`],
que permite ter uma barra de navegação "flutuante"
que encolhe quando você rola para baixo e flutua quando
você não está no topo da página.

Para criar este efeito:

  1. Adicione `CupertinoSliverNavigationBar` ao
     `CustomScrollView`.
  2. Comece com uma app bar que exibe apenas um título.

<?code-excerpt "lib/step2_cupertino.dart (SliverAppBar)" replace="/^body: //g;/^\),$/)/g"?>
```dart
slivers: [
  // Add the navigation bar to the CustomScrollView.
  CupertinoSliverNavigationBar(
    // Provide a standard title.
    largeTitle: Text('Floating App Bar'),
  ),
],
```

</Tab>

</Tabs>


## 3. Adicione uma lista de itens

Agora que você tem a app bar no lugar, adicione uma lista de itens
ao `CustomScrollView`. Você tem duas opções: um
[`SliverList`][`SliverList`] ou um [`SliverGrid`][`SliverGrid`]. Se você precisa
exibir uma lista de itens um após o outro, use o
widget `SliverList`. Se você precisa exibir uma lista em grade, use
o widget `SliverGrid`.

<Tabs key="device-type-tabs">

<Tab name="Material widgets">

<?code-excerpt "lib/main_material.dart (SliverList)" replace="/^\),$/)/g"?>
```dart
// Next, create a SliverList
SliverList.builder(
  // The builder function returns a ListTile with a title that
  // displays the index of the current item.
  itemBuilder: (context, index) =>
      ListTile(title: Text('Item #$index')),
  // Builds 50 ListTiles
  itemCount: 50,
)
```

</Tab>

<Tab name="Cupertino widgets">

<?code-excerpt "lib/main_cupertino.dart (SliverList)" replace="/^\),$/)/g"?>
```dart
// Next, create a SliverList
SliverList.builder(
  // The builder function returns a CupertinoListTile with a title
  // that displays the index of the current item.
  itemBuilder: (context, index) =>
      CupertinoListTile(title: Text('Item #$index')),
  // Builds 50 CupertinoListTile
  itemCount: 50,
)
```

</Tab>

</Tabs>

## Exemplo interativo

<Tabs key="device-type-tabs">

<Tab name="Material widgets">

<?code-excerpt "lib/main_material.dart"?>
```dartpad title="Flutter floating app bar hands-on example in DartPad" run="false"
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
        // No app bar provided to Scaffold, only a body with a
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Add the app bar to the CustomScrollView.
            const SliverAppBar(
              // Provide a standard title.
              title: Text(title),
              // Pin the app bar when scrolling
              pinned: true,
              // Display a placeholder widget to visualize the shrinking size.
              flexibleSpace: Placeholder(),
              // Make the initial height of the SliverAppBar larger than normal.
              expandedHeight: 200,
            ),
            // Next, create a SliverList
            SliverList.builder(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              itemBuilder: (context, index) =>
                  ListTile(title: Text('Item #$index')),
              // Builds 50 ListTiles
              itemCount: 50,
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/floating-app-bar.webp" alt="Use floating app bar demo" class="site-mobile-screenshot"/>
</noscript>

</Tab>

<Tab name="Cupertino widgets">

<?code-excerpt "lib/main_cupertino.dart"?>
```dartpad title="Flutter floating navigation bar hands-on example in DartPad" run="false"
import 'package:flutter/cupertino.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Floating Navigation Bar';

    return CupertinoApp(
      title: title,
      home: CupertinoPageScaffold(
        // No navigation bar provided to CupertinoPageScaffold,
        // only a body with a CustomScrollView.
        child: CustomScrollView(
          slivers: [
            // Add the navigation bar to the CustomScrollView.
            const CupertinoSliverNavigationBar(
              // Provide a standard title.
              largeTitle: Text(title),
            ),
            // Next, create a SliverList
            SliverList.builder(
              // The builder function returns a CupertinoListTile with a title
              // that displays the index of the current item.
              itemBuilder: (context, index) =>
                  CupertinoListTile(title: Text('Item #$index')),
              // Builds 50 CupertinoListTile
              itemCount: 50,
            ),
          ],
        ),
      ),
    );
  }
}
```

<noscript>
  <img src="/assets/images/docs/cookbook/floating-app-bar.webp" alt="Use floating nav bar demo" class="site-mobile-screenshot"/>
</noscript>

</Tab>

</Tabs>

[`CupertinoSliverNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoSliverNavigationBar-class.html
[`CustomScrollView`]: {{site.api}}/flutter/widgets/CustomScrollView-class.html
[`SliverAppBar`]: {{site.api}}/flutter/material/SliverAppBar-class.html
[`SliverChildBuilderDelegate`]: {{site.api}}/flutter/widgets/SliverChildBuilderDelegate-class.html
[`SliverChildDelegate`]: {{site.api}}/flutter/widgets/SliverChildDelegate-class.html
[`SliverGrid`]: {{site.api}}/flutter/widgets/SliverGrid-class.html
[`SliverList`]: {{site.api}}/flutter/widgets/SliverList-class.html
[various properties you can pass to the `SliverAppBar` widget]: {{site.api}}/flutter/material/SliverAppBar/SliverAppBar.html
