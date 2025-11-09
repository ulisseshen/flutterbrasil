---
ia-translate: true
title: Uma introdução a testes de widget
description: Aprenda mais sobre testes de widget em Flutter.
shortTitle: Introdução
---

<?code-excerpt path-base="cookbook/testing/widget/introduction/"?>

Na receita [introdução a testes unitários][introduction to unit testing],
você aprendeu como testar classes Dart usando o pacote `test`.
Para testar classes de widget, você precisa de algumas ferramentas adicionais fornecidas pelo
pacote [`flutter_test`][`flutter_test`], que vem com o Flutter SDK.

O pacote `flutter_test` fornece as seguintes ferramentas para
testar widgets:

  * O [`WidgetTester`][`WidgetTester`] permite construir e interagir
    com widgets em um ambiente de teste.
  * A função [`testWidgets()`][`testWidgets()`] cria automaticamente
    um novo `WidgetTester` para cada caso de teste,
    e é usada no lugar da função normal `test()`.
  * As classes [`Finder`][`Finder`] permitem buscar widgets
    no ambiente de teste.
  * As constantes [`Matcher`][`Matcher`] específicas de widget ajudam a verificar
   se um `Finder` localiza um widget ou
    múltiplos widgets no ambiente de teste.

Se isso parecer demais, não se preocupe. Aprenda como todas essas peças se encaixam
ao longo desta receita, que usa os seguintes passos:

  1. Adicione a dependência `flutter_test`.
  2. Crie um widget para testar.
  3. Crie um teste `testWidgets`.
  4. Construa o widget usando o `WidgetTester`.
  5. Busque o widget usando um `Finder`.
  6. Verifique o widget usando um `Matcher`.

## 1. Adicione a dependência `flutter_test`

Antes de escrever testes, inclua a dependência `flutter_test`
na seção `dev_dependencies` do arquivo `pubspec.yaml`.
Se você criar um novo projeto Flutter com as ferramentas de linha de comando ou
um editor de código, essa dependência já deve estar no lugar.

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

## 2. Crie um widget para testar

Em seguida, crie um widget para testar. Para esta receita,
crie um widget que exibe um `title` e `message`.

<?code-excerpt "test/main_test.dart (widget)"?>
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(message)),
      ),
    );
  }
}
```

## 3. Crie um teste `testWidgets`

Com um widget para testar, comece escrevendo seu primeiro teste.
Use a função [`testWidgets()`][`testWidgets()`] fornecida pelo
pacote `flutter_test` para definir um teste.
A função `testWidgets` permite que você defina um
teste de widget e cria um `WidgetTester` para trabalhar.

Este teste verifica que `MyWidget` exibe um título e mensagem específicos.
Ele é intitulado adequadamente, e será preenchido na próxima seção.

<?code-excerpt "test/main_step3_test.dart (main)"?>
```dart
void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows you to build and interact
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Test code goes here.
  });
}
```

## 4. Construa o widget usando o `WidgetTester`

Em seguida, construa `MyWidget` dentro do ambiente de teste usando o
método [`pumpWidget()`][`pumpWidget()`] fornecido por `WidgetTester`.
O método `pumpWidget` constrói e renderiza o widget fornecido.

Crie uma instância de `MyWidget` que exibe "T" como título
e "M" como mensagem.

<?code-excerpt "test/main_step4_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
  });
}
```

### Notas sobre os métodos pump()

Após a chamada inicial para `pumpWidget()`, o `WidgetTester` fornece
maneiras adicionais de reconstruir o mesmo widget. Isso é útil se você está
trabalhando com um `StatefulWidget` ou animações.

Por exemplo, tocar em um botão chama `setState()`, mas o Flutter não
reconstruirá automaticamente seu widget no ambiente de teste.
Use um dos seguintes métodos para pedir ao Flutter que reconstrua o widget.

[`tester.pump(Duration duration)`][`tester.pump(Duration duration)`]
: Agenda um frame e dispara uma reconstrução do widget.
  Se uma `Duration` for especificada, ela avança o relógio por
  essa quantidade e agenda um frame. Ela não agenda
  múltiplos frames mesmo se a duração for maior que um
  único frame.

:::note
Para iniciar a animação, você precisa chamar `pump()`
uma vez (sem duração especificada) para iniciar o ticker.
Sem isso, a animação não inicia.
:::

[`tester.pumpAndSettle()`][`tester.pumpAndSettle()`]
: Chama repetidamente `pump()` com a duração especificada até que
  não haja mais frames agendados.
  Isso, essencialmente, espera que todas as animações sejam concluídas.

Esses métodos fornecem controle refinado sobre o ciclo de vida de construção,
o que é particularmente útil durante os testes.

## 5. Busque nosso widget usando um `Finder`

Com um widget no ambiente de teste, busque
pela árvore de widgets os widgets Text de `title` e `message`
usando um `Finder`. Isso permite verificar que
os widgets estão sendo exibidos corretamente.

Para este propósito, use o método de nível superior [`find()`][`find()`]
fornecido pelo pacote `flutter_test` para criar os `Finders`.
Como você sabe que está procurando widgets `Text`, use o
método [`find.text()`][`find.text()`].

Para mais informações sobre classes `Finder`, consulte a
receita [Encontrando widgets em um teste de widget][Finding widgets in a widget test].

<?code-excerpt "test/main_step5_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
  });
}
```

## 6. Verifique o widget usando um `Matcher`

Finalmente, verifique que os widgets Text de título e mensagem aparecem na tela
usando as constantes `Matcher` fornecidas por `flutter_test`.
As classes `Matcher` são uma parte central do pacote `test`,
e fornecem uma maneira comum de verificar que um dado
valor atende às expectativas.

Garanta que os widgets apareçam na tela exatamente uma vez.
Para este propósito, use o `Matcher` [`findsOneWidget`][`findsOneWidget`].

<?code-excerpt "test/main_step6_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to verify
    // that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
```

### Matchers Adicionais

Além de `findsOneWidget`, o `flutter_test` fornece matchers adicionais
para casos comuns.

[`findsNothing`][`findsNothing`]
: Verifica que nenhum widget foi encontrado.

[`findsWidgets`][`findsWidgets`]
: Verifica que um ou mais widgets foram encontrados.

[`findsNWidgets`][`findsNWidgets`]
: Verifica que um número específico de widgets foi encontrado.

[`matchesGoldenFile`][`matchesGoldenFile`]
: Verifica que a renderização de um widget corresponde a uma imagem bitmap específica (teste de "golden file").

## Exemplo completo

<?code-excerpt "test/main_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define a test. The TestWidgets function also provides a WidgetTester
  // to work with. The WidgetTester allows building and interacting
  // with widgets in the test environment.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Create the widget by telling the tester to build it.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Create the Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use the `findsOneWidget` matcher provided by flutter_test to
    // verify that the Text widgets appear exactly once in the widget tree.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(title: Text(title)),
        body: Center(child: Text(message)),
      ),
    );
  }
}
```


[`find()`]: {{site.api}}/flutter/flutter_test/find-constant.html
[`find.text()`]: {{site.api}}/flutter/flutter_test/CommonFinders/text.html
[`findsNothing`]: {{site.api}}/flutter/flutter_test/findsNothing-constant.html
[`findsOneWidget`]: {{site.api}}/flutter/flutter_test/findsOneWidget-constant.html
[`findsNWidgets`]: {{site.api}}/flutter/flutter_test/findsNWidgets.html
[`findsWidgets`]: {{site.api}}/flutter/flutter_test/findsWidgets-constant.html
[`matchesGoldenFile`]: {{site.api}}/flutter/flutter_test/matchesGoldenFile.html
[`Finder`]: {{site.api}}/flutter/flutter_test/Finder-class.html
[Finding widgets in a widget test]: /cookbook/testing/widget/finders
[`flutter_test`]: {{site.api}}/flutter/flutter_test/flutter_test-library.html
[introduction to unit testing]: /cookbook/testing/unit/introduction
[`Matcher`]: {{site.api}}/flutter/package-matcher_matcher/Matcher-class.html
[`pumpWidget()`]: {{site.api}}/flutter/flutter_test/WidgetTester/pumpWidget.html
[`tester.pump(Duration duration)`]: {{site.api}}/flutter/flutter_test/TestWidgetsFlutterBinding/pump.html
[`tester.pumpAndSettle()`]: {{site.api}}/flutter/flutter_test/WidgetTester/pumpAndSettle.html
[`testWidgets()`]: {{site.api}}/flutter/flutter_test/testWidgets.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
