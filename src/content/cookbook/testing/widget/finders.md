---
ia-translate: true
title: Encontrar widgets
description: Como usar as classes Finder para testar widgets.
---

<?code-excerpt path-base="cookbook/testing/widget/finders/"?>

Para localizar widgets em um ambiente de teste, use as classes [`Finder`][`Finder`].
Embora seja possível escrever suas próprias classes `Finder`,
geralmente é mais conveniente localizar widgets usando as ferramentas
fornecidas pelo pacote [`flutter_test`][`flutter_test`].

Durante uma sessão `flutter run` em um teste de widget, você também pode
tocar interativamente em partes da tela para que a ferramenta Flutter
imprima o `Finder` sugerido.

Esta receita examina a constante [`find`][`find`] fornecida pelo
pacote `flutter_test`, e demonstra como
trabalhar com alguns dos `Finders` que ela fornece.
Para uma lista completa de finders disponíveis,
consulte a [documentação `CommonFinders`][`CommonFinders` documentation].

Se você não está familiarizado com testes de widget e o papel das
classes `Finder`,
revise a receita [Introdução a testes de widget][Introduction to widget testing].

Esta receita usa os seguintes passos:

  1. Encontrar um widget `Text`.
  2. Encontrar um widget com uma `Key` específica.
  3. Encontrar uma instância específica de widget.

## 1. Encontrar um widget `Text`

Em testes, você frequentemente precisa encontrar widgets que contenham texto específico.
Isso é exatamente para o que o método `find.text()` serve. Ele cria um
`Finder` que busca widgets que exibem uma `String` específica de texto.

<?code-excerpt "test/finders_test.dart (test1)"?>
```dart
testWidgets('finds a Text widget', (tester) async {
  // Build an App with a Text widget that displays the letter 'H'.
  await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('H'))));

  // Find a widget that displays the letter 'H'.
  expect(find.text('H'), findsOneWidget);
});
```

## 2. Encontrar um widget com uma `Key` específica

Em alguns casos, você pode querer encontrar um widget com base na Key que foi
fornecida a ele. Isso pode ser útil ao exibir múltiplas instâncias do
mesmo widget. Por exemplo, uma `ListView` pode exibir vários
widgets `Text` que contêm o mesmo texto.

Neste caso, forneça uma `Key` para cada widget na lista. Isso permite
que um app identifique exclusivamente um widget específico, tornando mais fácil encontrar
o widget no ambiente de teste.

<?code-excerpt "test/finders_test.dart (test2)"?>
```dart
testWidgets('finds a widget using a Key', (tester) async {
  // Define the test key.
  const testKey = Key('K');

  // Build a MaterialApp with the testKey.
  await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

  // Find the MaterialApp widget using the testKey.
  expect(find.byKey(testKey), findsOneWidget);
});
```

## 3. Encontrar uma instância específica de widget

Finalmente, você pode estar interessado em localizar uma instância específica de um widget.
Por exemplo, isso pode ser útil ao criar widgets que recebem uma propriedade `child`
e você quer garantir que está renderizando o widget `child`.

<?code-excerpt "test/finders_test.dart (test3)"?>
```dart
testWidgets('finds a specific instance', (tester) async {
  const childWidget = Padding(padding: EdgeInsets.zero);

  // Provide the childWidget to the Container.
  await tester.pumpWidget(Container(child: childWidget));

  // Search for the childWidget in the tree and verify it exists.
  expect(find.byWidget(childWidget), findsOneWidget);
});
```

## Resumo

A constante `find` fornecida pelo pacote `flutter_test` oferece
várias maneiras de localizar widgets no ambiente de teste. Esta receita
demonstrou três desses métodos, e vários outros métodos existem
para diferentes propósitos.

Se os exemplos acima não funcionarem para um caso de uso específico,
consulte a [documentação `CommonFinders`][`CommonFinders` documentation]
para revisar todos os métodos disponíveis.

## Exemplo completo

<?code-excerpt "test/finders_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('finds a Text widget', (tester) async {
    // Build an App with a Text widget that displays the letter 'H'.
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('H'))));

    // Find a widget that displays the letter 'H'.
    expect(find.text('H'), findsOneWidget);
  });

  testWidgets('finds a widget using a Key', (tester) async {
    // Define the test key.
    const testKey = Key('K');

    // Build a MaterialApp with the testKey.
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

    // Find the MaterialApp widget using the testKey.
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('finds a specific instance', (tester) async {
    const childWidget = Padding(padding: EdgeInsets.zero);

    // Provide the childWidget to the Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Search for the childWidget in the tree and verify it exists.
    expect(find.byWidget(childWidget), findsOneWidget);
  });
}
```

[`Finder`]: {{site.api}}/flutter/flutter_test/Finder-class.html
[`CommonFinders` documentation]: {{site.api}}/flutter/flutter_test/CommonFinders-class.html
[`find`]: {{site.api}}/flutter/flutter_test/find-constant.html
[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[Introduction to widget testing]: /cookbook/testing/widget/introduction
