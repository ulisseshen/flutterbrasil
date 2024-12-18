---
ia-translate: true
title: Encontrar widgets
description: Como usar as classes `Finder` para testar widgets.
---

<?code-excerpt path-base="cookbook/testing/widget/finders/"?>

{% assign api = site.api | append: '/flutter' -%}

Para localizar widgets em um ambiente de teste, use as classes [`Finder`][]. Embora seja possível escrever suas próprias classes `Finder`, geralmente é mais conveniente localizar widgets usando as ferramentas fornecidas pelo pacote [`flutter_test`][].

Durante uma sessão `flutter run` em um teste de widget, você também pode tocar interativamente em partes da tela para que a ferramenta Flutter imprima o `Finder` sugerido.

Esta receita examina a constante [`find`][] fornecida pelo pacote `flutter_test` e demonstra como trabalhar com alguns dos `Finders` que ela fornece. Para obter uma lista completa dos finders disponíveis, consulte a [documentação do `CommonFinders`][].

Se você não estiver familiarizado com testes de widget e o papel das classes `Finder`, revise a receita [Introdução ao teste de widget][].

Esta receita usa os seguintes passos:

  1. Encontrar um widget `Text`.
  2. Encontrar um widget com uma `Key` específica.
  3. Encontrar uma instância de widget específica.

## 1. Encontrar um widget `Text`

Em testes, muitas vezes você precisa encontrar widgets que contêm texto específico. É exatamente para isso que serve o método `find.text()`. Ele cria um `Finder` que procura widgets que exibem uma `String` de texto específica.

<?code-excerpt "test/finders_test.dart (test1)"?>
```dart
testWidgets('encontra um widget Text', (tester) async {
  // Constrói um App com um widget Text que exibe a letra 'H'.
  await tester.pumpWidget(const MaterialApp(
    home: Scaffold(
      body: Text('H'),
    ),
  ));

  // Encontra um widget que exibe a letra 'H'.
  expect(find.text('H'), findsOneWidget);
});
```

## 2. Encontrar um widget com uma `Key` específica

Em alguns casos, você pode querer encontrar um widget com base na `Key` que foi fornecida a ele. Isso pode ser útil se você estiver exibindo várias instâncias do mesmo widget. Por exemplo, um `ListView` pode exibir vários widgets `Text` que contêm o mesmo texto.

Nesse caso, forneça uma `Key` para cada widget na lista. Isso permite que um aplicativo identifique exclusivamente um widget específico, facilitando a localização do widget no ambiente de teste.

<?code-excerpt "test/finders_test.dart (test2)"?>
```dart
testWidgets('encontra um widget usando uma Key', (tester) async {
  // Define a chave de teste.
  const testKey = Key('K');

  // Constrói um MaterialApp com a testKey.
  await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

  // Encontra o widget MaterialApp usando a testKey.
  expect(find.byKey(testKey), findsOneWidget);
});
```

## 3. Encontrar uma instância de widget específica

Finalmente, você pode estar interessado em localizar uma instância específica de um widget. Por exemplo, isso pode ser útil ao criar widgets que usam uma propriedade `child` e você deseja garantir que está renderizando o widget `child`.

<?code-excerpt "test/finders_test.dart (test3)"?>
```dart
testWidgets('encontra uma instância específica', (tester) async {
  const childWidget = Padding(padding: EdgeInsets.zero);

  // Fornece o childWidget ao Container.
  await tester.pumpWidget(Container(child: childWidget));

  // Procura pelo childWidget na árvore e verifica se ele existe.
  expect(find.byWidget(childWidget), findsOneWidget);
});
```

## Resumo

A constante `find` fornecida pelo pacote `flutter_test` oferece várias maneiras de localizar widgets no ambiente de teste. Esta receita demonstrou três desses métodos, e vários outros métodos existem para diferentes finalidades.

Se os exemplos acima não funcionarem para um caso de uso específico, consulte a [documentação do `CommonFinders`][] para revisar todos os métodos disponíveis.

## Exemplo completo

<?code-excerpt "test/finders_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('encontra um widget Text', (tester) async {
    // Constrói um App com um widget Text que exibe a letra 'H'.
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: Text('H'),
      ),
    ));

    // Encontra um widget que exibe a letra 'H'.
    expect(find.text('H'), findsOneWidget);
  });

  testWidgets('encontra um widget usando uma Key', (tester) async {
    // Define a chave de teste.
    const testKey = Key('K');

    // Constrói um MaterialApp com a testKey.
    await tester.pumpWidget(MaterialApp(key: testKey, home: Container()));

    // Encontra o widget MaterialApp usando a testKey.
    expect(find.byKey(testKey), findsOneWidget);
  });

  testWidgets('encontra uma instância específica', (tester) async {
    const childWidget = Padding(padding: EdgeInsets.zero);

    // Fornece o childWidget ao Container.
    await tester.pumpWidget(Container(child: childWidget));

    // Procura pelo childWidget na árvore e verifica se ele existe.
    expect(find.byWidget(childWidget), findsOneWidget);
  });
}
```

[`Finder`]: {{api}}/flutter_test/Finder-class.html
[`CommonFinders` documentation]: {{api}}/flutter_test/CommonFinders-class.html
[`find`]: {{api}}/flutter_test/find-constant.html
[`flutter_test`]: {{api}}/flutter_test/flutter_test-library.html
[Introdução ao teste de widget]: /cookbook/testing/widget/introduction
