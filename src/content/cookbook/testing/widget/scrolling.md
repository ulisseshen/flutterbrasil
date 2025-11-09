---
ia-translate: true
title: Lidar com rolagem
description: Como lidar com rolagem em um teste de widget.
---

<?code-excerpt path-base="cookbook/testing/widget/scrolling/"?>

Muitos apps apresentam listas de conteúdo,
desde clientes de email até apps de música e além.
Para verificar que as listas contêm o conteúdo esperado
usando testes de widget,
você precisa de uma maneira de rolar pelas listas para procurar por itens específicos.

Para rolar por listas via testes de integração,
use os métodos fornecidos pela classe [`WidgetTester`][`WidgetTester`],
que está incluída no pacote [`flutter_test`][`flutter_test`]:

Nesta receita, aprenda como rolar por uma lista de itens para
verificar que um widget específico está sendo exibido,
e os prós e contras de diferentes abordagens.

Esta receita usa os seguintes passos:

1. Crie um app com uma lista de itens.
2. Escreva um teste que rola pela lista.
3. Execute o teste.

## 1. Crie um app com uma lista de itens

Esta receita constrói um app que mostra uma longa lista de itens.
Para manter esta receita focada em testes, use o app criado na
receita [Trabalhar com listas longas][Work with long lists].
Se você não tem certeza de como trabalhar com listas longas,
consulte essa receita para uma introdução.

Adicione keys aos widgets com os quais você quer interagir
dentro dos testes de integração.

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(items: List<String>.generate(10000, (i) => 'Item $i')));
}

class MyApp extends StatelessWidget {
  final List<String> items;

  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Long List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(title: const Text(title)),
        body: ListView.builder(
          // Add a key to the ListView. This makes it possible to
          // find the list and scroll through it in the tests.
          key: const Key('long_list'),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index],
                // Add a key to the Text widget for each item. This makes
                // it possible to look for a particular item in the list
                // and verify that the text is correct
                key: Key('item_${index}_text'),
              ),
            );
          },
        ),
      ),
    );
  }
}
```


## 2. Escreva um teste que rola pela lista

Agora, você pode escrever um teste. Neste exemplo, role pela lista de itens e
verifique que um item específico existe na lista. A classe [`WidgetTester`][`WidgetTester`]
fornece o método [`scrollUntilVisible()`][`scrollUntilVisible()`], que rola por uma lista
até que um widget específico esteja visível. Isso é útil porque a altura dos
itens na lista pode mudar dependendo do dispositivo.

Em vez de assumir que você conhece a altura de todos os itens
em uma lista, ou que um widget específico é renderizado em todos os dispositivos,
o método `scrollUntilVisible()` rola repetidamente por
uma lista de itens até encontrar o que está procurando.

O código a seguir mostra como usar o método `scrollUntilVisible()`
para procurar pela lista por um item específico. Este código fica em um
arquivo chamado `test/widget_test.dart`.

<?code-excerpt "test/widget_test.dart (ScrollWidgetTest)"?>
```dart

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scrolling/main.dart';

void main() {
  testWidgets('finds a deep item in a long list', (tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MyApp(items: List<String>.generate(10000, (i) => 'Item $i')),
    );

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byKey(const ValueKey('item_50_text'));

    // Scroll until the item to be found appears.
    await tester.scrollUntilVisible(itemFinder, 500.0, scrollable: listFinder);

    // Verify that the item contains the correct text.
    expect(itemFinder, findsOneWidget);
  });
}
```

## 3. Execute o teste

Execute o teste usando o seguinte comando a partir da raiz do projeto:

```console
flutter test test/widget_test.dart
```

[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`scrollUntilVisible()`]: {{site.api}}/flutter/flutter_test/WidgetController/scrollUntilVisible.html
[Work with long lists]: /cookbook/lists/long-lists
