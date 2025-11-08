---
title: Lista com itens espaçados
description: Como criar uma lista com itens espaçados ou expandidos
js:
  - defer: true
    url: /assets/js/inject_dartpad.js
ia-translate: true
---

<?code-excerpt path-base="cookbook/lists/spaced_items/"?>

Talvez você queira criar uma lista onde todos os itens da lista
são espaçados uniformemente, para que os itens ocupem o espaço visível.
Por exemplo, os quatro itens na imagem a seguir são espaçados uniformemente,
com "Item 0" no topo, e "Item 3" na parte inferior.

![Spaced items](/assets/images/docs/cookbook/spaced-items-1.png){:.site-mobile-screenshot}

Ao mesmo tempo, você pode querer permitir que os usuários
rolem pela lista quando a lista de itens não couber,
talvez porque um dispositivo seja muito pequeno, um usuário redimensionou uma janela,
ou o número de itens excede o tamanho da tela.

![Scrollable items](/assets/images/docs/cookbook/spaced-items-2.png){:.site-mobile-screenshot}

Normalmente, você usa [`Spacer`][] para ajustar o espaçamento entre widgets,
ou [`Expanded`][] para expandir um widget para preencher o espaço disponível.
No entanto, essas soluções não são possíveis dentro de widgets roláveis,
porque eles precisam de uma restrição de altura finita.

Esta receita demonstra como usar [`LayoutBuilder`][] e [`ConstrainedBox`][]
para espaçar os itens da lista uniformemente quando há espaço suficiente, e para permitir
que os usuários rolem quando não há espaço suficiente,
usando os seguintes passos:

  1. Adicionar um [`LayoutBuilder`][] com um [`SingleChildScrollView`][].
  2. Adicionar um [`ConstrainedBox`][] dentro do [`SingleChildScrollView`][].
  3. Criar uma [`Column`][] com itens espaçados.

## 1. Adicionar um `LayoutBuilder` com um `SingleChildScrollView`

Comece criando um [`LayoutBuilder`][]. Você precisa fornecer
uma função callback `builder` com dois parâmetros:

  1. O [`BuildContext`][] fornecido pelo [`LayoutBuilder`][].
  2. As [`BoxConstraints`][] do widget pai.

Nesta receita, você não usará o [`BuildContext`][],
mas precisará das [`BoxConstraints`][] no próximo passo.

Dentro da função `builder`, retorne um [`SingleChildScrollView`][].
Este widget garante que o widget filho possa ser rolado,
mesmo quando o contêiner pai é muito pequeno.

<?code-excerpt "lib/spaced_list.dart (builder)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: Placeholder(),
  );
});
```

## 2. Adicionar um `ConstrainedBox` dentro do `SingleChildScrollView`

Neste passo, adicione um [`ConstrainedBox`][]
como filho do [`SingleChildScrollView`][].

O widget [`ConstrainedBox`][] impõe restrições adicionais ao seu filho.

Configure a restrição definindo o parâmetro `minHeight` como sendo
o `maxHeight` das restrições do [`LayoutBuilder`][].

Isso garante que o widget filho
seja restringido a ter uma altura mínima igual ao espaço disponível
fornecido pelas restrições do [`LayoutBuilder`][],
ou seja, a altura máxima das [`BoxConstraints`][].

<?code-excerpt "lib/spaced_list.dart (constrainedBox)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Placeholder(),
    ),
  );
});
```

No entanto, você não define o parâmetro `maxHeight`,
porque precisa permitir que o filho seja maior
que o tamanho do [`LayoutBuilder`][],
caso os itens não caibam na tela.

## 3. Criar uma `Column` com itens espaçados

Finalmente, adicione uma [`Column`][] como filho do [`ConstrainedBox`][].

Para espaçar os itens uniformemente,
defina o `mainAxisAlignment` como `MainAxisAlignment.spaceBetween`.

<?code-excerpt "lib/spaced_list.dart (column)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ItemWidget(text: 'Item 1'),
          ItemWidget(text: 'Item 2'),
          ItemWidget(text: 'Item 3'),
        ],
      ),
    ),
  );
});
```

Alternativamente, você pode usar o widget [`Spacer`][]
para ajustar o espaçamento entre os itens,
ou o widget [`Expanded`][], se você quiser que um widget ocupe mais espaço do que outros.

Para isso, você tem que envolver a [`Column`] com um widget [`IntrinsicHeight`][],
que força o widget [`Column`][] a ter um tamanho mínimo em altura,
em vez de expandir infinitamente.

<?code-excerpt "lib/spaced_list.dart (intrinsic)"?>
```dart
LayoutBuilder(builder: (context, constraints) {
  return SingleChildScrollView(
    child: ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: IntrinsicHeight(
        child: Column(
          children: [
            ItemWidget(text: 'Item 1'),
            Spacer(),
            ItemWidget(text: 'Item 2'),
            Expanded(
              child: ItemWidget(text: 'Item 3'),
            ),
          ],
        ),
      ),
    ),
  );
});
```

:::tip
Experimente com diferentes dispositivos, redimensionando o aplicativo,
ou redimensionando a janela do navegador, e veja como a lista de itens se adapta
ao espaço disponível.
:::

## Exemplo interativo

Este exemplo mostra uma lista de itens que são espaçados uniformemente dentro de uma coluna.
A lista pode ser rolada para cima e para baixo quando os itens não cabem na tela.
O número de itens é definido pela variável `items`,
altere este valor para ver o que acontece quando os itens não cabem na tela.

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Spaced Items hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() => runApp(const SpacedItemsList());

class SpacedItemsList extends StatelessWidget {
  const SpacedItemsList({super.key});

  @override
  Widget build(BuildContext context) {
    const items = 4;

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        cardTheme: CardThemeData(color: Colors.blue.shade50),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: List.generate(
                    items, (index) => ItemWidget(text: 'Item $index')),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class ItemWidget extends StatelessWidget {
  const ItemWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 100,
        child: Center(child: Text(text)),
      ),
    );
  }
}
```

[`BoxConstraints`]: {{site.api}}/flutter/rendering/BoxConstraints-class.html
[`BuildContext`]: {{site.api}}/flutter/widgets/BuildContext-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`ConstrainedBox`]: {{site.api}}/flutter/widgets/ConstrainedBox-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[`IntrinsicHeight`]: {{site.api}}/flutter/widgets/IntrinsicHeight-class.html
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html
[`Spacer`]: {{site.api}}/flutter/widgets/Spacer-class.html
