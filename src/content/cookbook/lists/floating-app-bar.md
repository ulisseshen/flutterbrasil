---
ia-translate: true
title: Posicione uma barra de aplicativo flutuante acima de uma lista
description: Como posicionar uma barra de aplicativo flutuante acima de uma lista.
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
---

<?code-excerpt path-base="cookbook/lists/floating_app_bar/"?>

Para tornar mais fácil para os usuários visualizarem uma lista de itens,
você pode querer ocultar a barra de aplicativo à medida que o usuário rola a lista para baixo.
Isso é especialmente verdade se seu aplicativo exibir uma barra de aplicativo "alta"
que ocupa muito espaço vertical.

Normalmente, você cria uma barra de aplicativo fornecendo uma propriedade `appBar` ao
widget `Scaffold`. Isso cria uma barra de aplicativo fixa que sempre permanece acima
do `body` do `Scaffold`.

Mover a barra de aplicativo de um widget `Scaffold` para um
[`CustomScrollView`][] permite criar uma barra de aplicativo
que sai da tela enquanto você rola por uma
lista de itens contida dentro do `CustomScrollView`.

Esta receita demonstra como usar um `CustomScrollView` para exibir uma lista de
itens com uma barra de aplicativo no topo que sai da tela enquanto o usuário rola
a lista para baixo, usando as seguintes etapas:

  1. Crie um `CustomScrollView`.
  2. Use `SliverAppBar` para adicionar uma barra de aplicativo flutuante.
  3. Adicione uma lista de itens usando um `SliverList`.

## 1. Crie um `CustomScrollView`

Para criar uma barra de aplicativo flutuante, coloque a barra de aplicativo dentro de um
`CustomScrollView` que também contenha a lista de itens.
Isso sincroniza a posição de rolagem da barra de aplicativo e da lista de itens.
Você pode pensar no widget `CustomScrollView` como um `ListView`
que permite misturar e combinar diferentes tipos de listas roláveis
e widgets.

As listas roláveis e os widgets fornecidos ao
`CustomScrollView` são conhecidos como _slivers_. Existem vários tipos
de slivers, como `SliverList`, `SliverGrid` e `SliverAppBar`.
Na verdade, os widgets `ListView` e `GridView` usam os widgets `SliverList` e
`SliverGrid` para implementar a rolagem.

Para este exemplo, crie um `CustomScrollView` que contenha um
`SliverAppBar` e um `SliverList`. Além disso, remova quaisquer barras de aplicativos
que você fornecer ao widget `Scaffold`.

<?code-excerpt "lib/starter.dart (CustomScrollView)" replace="/^return //g"?>
```dart
Scaffold(
  // Nenhuma propriedade appBar fornecida, apenas o body.
  body: CustomScrollView(
      // Adicione a barra de aplicativo e a lista de itens como slivers nas próximas etapas.
      slivers: <Widget>[]),
);
```

### 2. Use `SliverAppBar` para adicionar uma barra de aplicativo flutuante

Em seguida, adicione uma barra de aplicativo ao [`CustomScrollView`][].
O Flutter fornece o widget [`SliverAppBar`][] que,
assim como o widget `AppBar` normal,
usa o `SliverAppBar` para exibir um título,
abas, imagens e muito mais.

No entanto, o `SliverAppBar` também oferece a capacidade de criar uma barra de aplicativo "flutuante"
que sai da tela à medida que o usuário rola a lista para baixo.
Além disso, você pode configurar o `SliverAppBar` para encolher e
expandir conforme o usuário rola.

Para criar este efeito:

  1. Comece com uma barra de aplicativo que exibe apenas um título.
  2. Defina a propriedade `floating` como `true`.
     Isso permite que os usuários revelem rapidamente a barra de aplicativo quando
     eles rolam a lista para cima.
  3. Adicione um widget `flexibleSpace` que preenche o
     `expandedHeight` disponível.

<?code-excerpt "lib/step2.dart (SliverAppBar)" replace="/^body: //g;/^\),$/)/g"?>
```dart
CustomScrollView(
  slivers: [
    // Adicione a barra de aplicativo ao CustomScrollView.
    const SliverAppBar(
      // Forneça um título padrão.
      title: Text(title),
      // Permite que o usuário revele a barra de aplicativo se começar a rolar
      // a lista de itens de volta para cima.
      floating: true,
      // Exiba um widget de espaço reservado para visualizar o tamanho encolhendo.
      flexibleSpace: Placeholder(),
      // Faça com que a altura inicial do SliverAppBar seja maior que o normal.
      expandedHeight: 200,
    ),
  ],
)
```

:::tip
Brinque com as
[várias propriedades que você pode passar para o widget `SliverAppBar`][],
e use o hot reload para ver os resultados. Por exemplo, use um widget `Image`
para a propriedade `flexibleSpace` para criar uma imagem de fundo que
encolhe de tamanho conforme é rolada para fora da tela.
:::

### 3. Adicione uma lista de itens usando um `SliverList`

Agora que você tem a barra de aplicativo no lugar, adicione uma lista de itens ao
`CustomScrollView`. Você tem duas opções: um [`SliverList`][]
ou um [`SliverGrid`][]. Se você precisar exibir uma lista de itens um após o outro,
use o widget `SliverList`.
Se você precisar exibir uma lista em grade, use o widget `SliverGrid`.

Os widgets `SliverList` e `SliverGrid` recebem um parâmetro obrigatório: um
[`SliverChildDelegate`][], que fornece uma lista
de widgets para `SliverList` ou `SliverGrid`.
Por exemplo, o [`SliverChildBuilderDelegate`][]
permite que você crie uma lista de itens que são construídos preguiçosamente enquanto você rola,
assim como o widget `ListView.builder`.

<?code-excerpt "lib/main.dart (SliverList)" replace="/^\),$/)/g"?>
```dart
// Em seguida, crie um SliverList
SliverList(
  // Use um delegate para construir os itens conforme eles são rolados na tela.
  delegate: SliverChildBuilderDelegate(
    // A função de builder retorna um ListTile com um título que
    // exibe o índice do item atual.
    (context, index) => ListTile(title: Text('Item #$index')),
    // Constrói 1000 ListTiles
    childCount: 1000,
  ),
)
```

## Exemplo interativo

<?code-excerpt "lib/main.dart"?>
```dartpad title="Exemplo prático de barra de aplicativo flutuante do Flutter no DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = 'Barra de Aplicativo Flutuante';

    return MaterialApp(
      title: title,
      home: Scaffold(
        // Nenhuma barra de aplicativo fornecida ao Scaffold, apenas um body com um
        // CustomScrollView.
        body: CustomScrollView(
          slivers: [
            // Adicione a barra de aplicativo ao CustomScrollView.
            const SliverAppBar(
              // Forneça um título padrão.
              title: Text(title),
              // Permite que o usuário revele a barra de aplicativo se começar a rolar
              // a lista de itens de volta para cima.
              floating: true,
              // Exiba um widget de espaço reservado para visualizar o tamanho encolhendo.
              flexibleSpace: Placeholder(),
              // Faça com que a altura inicial do SliverAppBar seja maior que o normal.
              expandedHeight: 200,
            ),
            // Em seguida, crie um SliverList
            SliverList(
              // Use um delegate para construir os itens conforme eles são rolados na tela.
              delegate: SliverChildBuilderDelegate(
                // A função de builder retorna um ListTile com um título que
                // exibe o índice do item atual.
                (context, index) => ListTile(title: Text('Item #$index')),
                // Constrói 1000 ListTiles
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
[various properties you can pass to the `SliverAppBar` widget]: {{site.api}}/flutter/material/SliverAppBar/SliverAppBar.html
