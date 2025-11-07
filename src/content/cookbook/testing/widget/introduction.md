---
title: Uma introdução a testes de widget
description: Aprenda mais sobre testes de widget no Flutter.
short-title: Introdução
ia-translate: true
---

<?code-excerpt path-base="cookbook/testing/widget/introduction/"?>

{% assign api = site.api | append: '/flutter' -%}

Na receita [introduction to unit testing][],
você aprendeu como testar classes Dart usando o pacote `test`.
Para testar classes de widget, você precisa de algumas ferramentas adicionais fornecidas pelo
pacote [`flutter_test`][], que vem com o Flutter SDK.

O pacote `flutter_test` fornece as seguintes ferramentas para
testar widgets:

  * O [`WidgetTester`][] permite construir e interagir
    com widgets em um ambiente de teste.
  * A função [`testWidgets()`][] cria automaticamente
    um novo `WidgetTester` para cada caso de teste,
    e é usada no lugar da função `test()` normal.
  * As classes [`Finder`][] permitem procurar por widgets
    no ambiente de teste.
  * Constantes [`Matcher`][] específicas de widget ajudam a verificar
   se um `Finder` localiza um widget ou
    múltiplos widgets no ambiente de teste.

Se isso parecer sobrecarregante, não se preocupe. Aprenda como todas essas peças se encaixam
ao longo desta receita, que usa as seguintes etapas:

  1. Adicionar a dependência `flutter_test`.
  2. Criar um widget para testar.
  3. Criar um teste `testWidgets`.
  4. Construir o widget usando o `WidgetTester`.
  5. Procurar pelo widget usando um `Finder`.
  6. Verificar o widget usando um `Matcher`.

## 1. Adicionar a dependência `flutter_test`

Antes de escrever testes, inclua a dependência `flutter_test`
na seção `dev_dependencies` do arquivo `pubspec.yaml`.
Se estiver criando um novo projeto Flutter com as ferramentas de linha de comando ou
um editor de código, esta dependência já deve estar no lugar.

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

## 2. Criar um widget para testar

Em seguida, crie um widget para testar. Para esta receita,
crie um widget que exibe um `title` e uma `message`.

<?code-excerpt "test/main_test.dart (widget)"?>
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
```

## 3. Criar um teste `testWidgets`

Com um widget para testar, comece escrevendo seu primeiro teste.
Use a função [`testWidgets()`][] fornecida pelo
pacote `flutter_test` para definir um teste.
A função `testWidgets` permite definir um
teste de widget e cria um `WidgetTester` para trabalhar.

Este teste verifica que `MyWidget` exibe um título e mensagem fornecidos.
Ele tem o título correspondente e será preenchido na próxima seção.

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

## 4. Construir o widget usando o `WidgetTester`

Em seguida, construa `MyWidget` dentro do ambiente de teste usando o
método [`pumpWidget()`][] fornecido por `WidgetTester`.
O método `pumpWidget` constrói e renderiza o widget fornecido.

Crie uma instância de `MyWidget` que exibe "T" como o título
e "M" como a mensagem.

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
maneiras adicionais de reconstruir o mesmo widget. Isso é útil se você estiver
trabalhando com um `StatefulWidget` ou animações.

Por exemplo, tocar em um botão chama `setState()`, mas o Flutter não
reconstruirá automaticamente seu widget no ambiente de teste.
Use um dos seguintes métodos para pedir ao Flutter para reconstruir o widget.

[`tester.pump(Duration duration)`][]
: Agenda um frame e aciona uma reconstrução do widget.
  Se uma `Duration` for especificada, ela avança o relógio por
  essa quantidade e agenda um frame. Não agenda
  múltiplos frames mesmo se a duração for maior que um
  único frame.

:::note
Para iniciar a animação, você precisa chamar `pump()`
uma vez (sem duração especificada) para iniciar o ticker.
Sem isso, a animação não inicia.
:::

[`tester.pumpAndSettle()`][]
: Chama repetidamente `pump()` com a duração especificada até
  que não haja mais frames agendados.
  Isso, essencialmente, espera que todas as animações sejam concluídas.

Esses métodos fornecem controle refinado sobre o ciclo de vida de build,
o que é particularmente útil durante os testes.

## 5. Procurar por nosso widget usando um `Finder`

Com um widget no ambiente de teste, procure
através da árvore de widgets pelo `title` e pela `message`
usando widgets Text com um `Finder`. Isso permite a verificação de que
os widgets estão sendo exibidos corretamente.

Para este propósito, use o método [`find()`][] de nível superior
fornecido pelo pacote `flutter_test` para criar os `Finders`.
Como você sabe que está procurando por widgets `Text`, use o
método [`find.text()`][].

Para mais informações sobre classes `Finder`, consulte a receita
[Finding widgets in a widget test][].

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

## 6. Verificar o widget usando um `Matcher`

Finalmente, verifique se os widgets Text `title` e `message` aparecem na tela
usando as constantes `Matcher` fornecidas pelo `flutter_test`.
Classes `Matcher` são uma parte central do pacote `test`,
e fornecem uma maneira comum de verificar se um determinado
valor atende às expectativas.

Garanta que os widgets apareçam na tela exatamente uma vez.
Para este propósito, use o `Matcher` [`findsOneWidget`][].

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

### Matchers adicionais

Além de `findsOneWidget`, `flutter_test` fornece matchers adicionais
para casos comuns.

[`findsNothing`][]
: Verifica que nenhum widget é encontrado.

[`findsWidgets`][]
: Verifica que um ou mais widgets são encontrados.

[`findsNWidgets`][]
: Verifica que um número específico de widgets são encontrados.

[`matchesGoldenFile`][]
: Verifica que a renderização de um widget corresponde a uma imagem bitmap específica ("teste de golden file").

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
  const MyWidget({
    super.key,
    required this.title,
    required this.message,
  });

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
          child: Text(message),
        ),
      ),
    );
  }
}
```


[`find()`]: {{api}}/flutter_test/find-constant.html
[`find.text()`]: {{api}}/flutter_test/CommonFinders/text.html
[`findsNothing`]: {{api}}/flutter_test/findsNothing-constant.html
[`findsOneWidget`]: {{api}}/flutter_test/findsOneWidget-constant.html
[`findsNWidgets`]: {{api}}/flutter_test/findsNWidgets.html
[`findsWidgets`]: {{api}}/flutter_test/findsWidgets-constant.html
[`matchesGoldenFile`]: {{api}}/flutter_test/matchesGoldenFile.html
[`Finder`]: {{api}}/flutter_test/Finder-class.html
[Finding widgets in a widget test]: /cookbook/testing/widget/finders
[`flutter_test`]: {{api}}/flutter_test/flutter_test-library.html
[introduction to unit testing]: /cookbook/testing/unit/introduction
[`Matcher`]: {{api}}/package-matcher_matcher/Matcher-class.html
[`pumpWidget()`]: {{api}}/flutter_test/WidgetTester/pumpWidget.html
[`tester.pump(Duration duration)`]: {{api}}/flutter_test/TestWidgetsFlutterBinding/pump.html
[`tester.pumpAndSettle()`]: {{api}}/flutter_test/WidgetTester/pumpAndSettle.html
[`testWidgets()`]: {{api}}/flutter_test/testWidgets.html
[`WidgetTester`]: {{api}}/flutter_test/WidgetTester-class.html
