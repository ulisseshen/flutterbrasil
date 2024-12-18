---
ia-translate: true
title: Lidar com rolagem
description: Como lidar com rolagem em um teste de widget.
---

<?code-excerpt path-base="cookbook/testing/widget/scrolling/"?>

Muitos aplicativos apresentam listas de conteúdo,
de clientes de e-mail a aplicativos de música e muito mais.
Para verificar se as listas contêm o conteúdo esperado
usando testes de widget,
você precisa de uma maneira de percorrer as listas para procurar itens específicos.

Para percorrer listas por meio de testes de integração,
use os métodos fornecidos pela classe [`WidgetTester`][],
que está incluída no pacote [`flutter_test`][]:

Nesta receita, aprenda como percorrer uma lista de itens para
verificar se um widget específico está sendo exibido,
e os prós e contras de diferentes abordagens.

Esta receita usa as seguintes etapas:

1. Crie um aplicativo com uma lista de itens.
2. Escreva um teste que percorra a lista.
3. Execute o teste.

## 1. Crie um aplicativo com uma lista de itens

Esta receita cria um aplicativo que mostra uma longa lista de itens.
Para manter esta receita focada em testes, use o aplicativo criado na
receita [Trabalhar com listas longas][].
Se você não tem certeza de como trabalhar com listas longas,
consulte essa receita para uma introdução.

Adicione keys aos widgets com os quais você deseja interagir
dentro dos testes de integração.

<?code-excerpt "lib/main.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<String>.generate(10000, (i) => 'Item $i'),
  ));
}

class MyApp extends StatelessWidget {
  final List<String> items;

  const MyApp({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    const title = 'Lista Longa';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: ListView.builder(
          // Adicione uma key ao ListView. Isso possibilita
          // encontrar a lista e percorre-la nos testes.
          key: const Key('long_list'),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                items[index],
                // Adicione uma key ao widget Text para cada item. Isso torna
                // possível procurar um item específico na lista
                // e verificar se o texto está correto
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

## 2. Escreva um teste que percorra a lista

Agora, você pode escrever um teste. Neste exemplo, percorra a lista de itens e
verifique se um item específico existe na lista. A classe [`WidgetTester`][]
fornece o método [`scrollUntilVisible()`][], que percorre uma lista
até que um widget específico esteja visível. Isso é útil porque a altura do
itens na lista podem mudar dependendo do dispositivo.

Em vez de assumir que você conhece a altura de todos os itens
em uma lista, ou que um widget específico é renderizado em todos os dispositivos,
o método `scrollUntilVisible()` percorre repetidamente
uma lista de itens até encontrar o que procura.

O código a seguir mostra como usar o método `scrollUntilVisible()`
para procurar na lista um item específico. Este código reside em um
arquivo chamado `test/widget_test.dart`.

<?code-excerpt "test/widget_test.dart (ScrollWidgetTest)"?>
```dart

// Este é um teste de widget básico do Flutter.
//
// Para realizar uma interação com um widget em seu teste, use o WidgetTester
// utilitário que o Flutter fornece. Por exemplo, você pode enviar toques e rolagens
// gestos. Você também pode usar WidgetTester para encontrar widgets filhos no widget
// árvore, leia o texto e verifique se os valores das propriedades do widget estão corretos.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scrolling/main.dart';

void main() {
  testWidgets('encontra um item profundo em uma lista longa', (tester) async {
    // Construa nosso aplicativo e acione um frame.
    await tester.pumpWidget(MyApp(
      items: List<String>.generate(10000, (i) => 'Item $i'),
    ));

    final listFinder = find.byType(Scrollable);
    final itemFinder = find.byKey(const ValueKey('item_50_text'));

    // Role até que o item a ser encontrado apareça.
    await tester.scrollUntilVisible(
      itemFinder,
      500.0,
      scrollable: listFinder,
    );

    // Verifique se o item contém o texto correto.
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
[Trabalhar com listas longas]: /cookbook/lists/long-lists
