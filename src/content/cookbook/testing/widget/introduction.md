---
ia-translate: true
title: Uma introdução a testes de widget
description: Saiba mais sobre testes de widget no Flutter.
short-title: Introdução
---

<?code-excerpt path-base="cookbook/testing/widget/introduction/"?>

{% assign api = site.api | append: '/flutter' -%}

Na receita de [introdução a testes unitários][],
você aprendeu como testar classes Dart usando o pacote `test`.
Para testar classes de widget, você precisa de algumas ferramentas adicionais fornecidas pelo
pacote [`flutter_test`][], que acompanha o SDK do Flutter.

O pacote `flutter_test` fornece as seguintes ferramentas para
testar widgets:

  * O [`WidgetTester`][] permite construir e interagir
    com widgets em um ambiente de teste.
  * A função [`testWidgets()`][] cria automaticamente um novo `WidgetTester` para cada caso de teste,
    e é usada no lugar da função `test()` normal.
  * As classes [`Finder`][] permitem procurar por widgets
    no ambiente de teste.
  * As constantes [`Matcher`][] específicas de widget ajudam a verificar
   se um `Finder` localiza um widget ou
    múltiplos widgets no ambiente de teste.

Se isso soa assustador, não se preocupe. Aprenda como todas essas peças se encaixam
ao longo desta receita, que usa os seguintes passos:

  1. Adicione a dependência `flutter_test`.
  2. Crie um widget para testar.
  3. Crie um teste `testWidgets`.
  4. Construa o widget usando o `WidgetTester`.
  5. Procure o widget usando um `Finder`.
  6. Verifique o widget usando um `Matcher`.

## 1. Adicione a dependência `flutter_test`

Antes de escrever testes, inclua a dependência `flutter_test`
na seção `dev_dependencies` do arquivo `pubspec.yaml`.
Ao criar um novo projeto Flutter com as ferramentas de linha de comando ou
um editor de código, essa dependência já deve estar no local.

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
```

## 2. Crie um widget para testar

Em seguida, crie um widget para testar. Para esta receita,
crie um widget que exibe um `title` (título) e `message` (mensagem).

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

## 3. Crie um teste `testWidgets`

Com um widget para testar, comece escrevendo seu primeiro teste.
Use a função [`testWidgets()`][] fornecida pelo
pacote `flutter_test` para definir um teste.
A função `testWidgets` permite que você defina um
teste de widget e cria um `WidgetTester` para trabalhar.

Este teste verifica se `MyWidget` exibe um título e mensagem fornecidos.
Ele é intitulado adequadamente e será preenchido na próxima seção.

<?code-excerpt "test/main_step3_test.dart (main)"?>
```dart
void main() {
  // Define um teste. A função TestWidgets também fornece um WidgetTester
  // para trabalhar. O WidgetTester permite construir e interagir
  // com widgets no ambiente de teste.
  testWidgets('MyWidget has a title and message', (tester) async {
    // O código de teste vai aqui.
  });
}
```

## 4. Construa o widget usando o `WidgetTester`

Em seguida, construa `MyWidget` dentro do ambiente de teste usando o
método [`pumpWidget()`][] fornecido por `WidgetTester`.
O método `pumpWidget` constrói e renderiza o widget fornecido.

Crie uma instância de `MyWidget` que exiba "T" como título
e "M" como mensagem.

<?code-excerpt "test/main_step4_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    // Crie o widget dizendo ao testador para construí-lo.
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
: Agenda um frame e dispara uma reconstrução do widget.
  Se um `Duration` for especificado, ele avança o relógio pela
  quantidade e agenda um frame. Ele não agenda
  vários frames, mesmo que a duração seja maior que um
  único frame.

:::note
Para iniciar a animação, você precisa chamar `pump()`
uma vez (sem duração especificada) para iniciar o ticker.
Sem ele, a animação não começa.
:::

[`tester.pumpAndSettle()`][]
: Chama repetidamente `pump()` com a duração fornecida até
  que não haja mais frames agendados.
  Isso, essencialmente, espera que todas as animações sejam concluídas.

Esses métodos fornecem controle refinado sobre o ciclo de vida da construção,
o que é particularmente útil durante o teste.

## 5. Procure nosso widget usando um `Finder`

Com um widget no ambiente de teste, procure
na árvore de widgets pelos widgets `Text` de `title` e `message`
usando um `Finder`. Isso permite verificar se
os widgets estão sendo exibidos corretamente.

Para este propósito, use o método de nível superior [`find()`][]
fornecido pelo pacote `flutter_test` para criar os `Finders`.
Já que você sabe que está procurando por widgets `Text`, use o
método [`find.text()`][].

Para mais informações sobre classes `Finder`, veja a receita
[Encontrando widgets em um teste de widget][].

<?code-excerpt "test/main_step5_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Crie os Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');
  });
}
```

## 6. Verifique o widget usando um `Matcher`

Finalmente, verifique se os widgets `Text` de título e mensagem aparecem na tela
usando as constantes `Matcher` fornecidas por `flutter_test`.
As classes `Matcher` são uma parte fundamental do pacote `test`,
e fornecem uma maneira comum de verificar se um determinado
valor atende às expectativas.

Certifique-se de que os widgets apareçam na tela exatamente uma vez.
Para este propósito, use o `Matcher` [`findsOneWidget`][].

<?code-excerpt "test/main_step6_test.dart (main)"?>
```dart
void main() {
  testWidgets('MyWidget has a title and message', (tester) async {
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use o matcher `findsOneWidget` fornecido por flutter_test para verificar
    // se os widgets Text aparecem exatamente uma vez na árvore de widgets.
    expect(titleFinder, findsOneWidget);
    expect(messageFinder, findsOneWidget);
  });
}
```

### Matchers Adicionais

Além de `findsOneWidget`, `flutter_test` fornece matchers adicionais
para casos comuns.

[`findsNothing`][]
: Verifica se nenhum widget é encontrado.

[`findsWidgets`][]
: Verifica se um ou mais widgets são encontrados.

[`findsNWidgets`][]
: Verifica se um número específico de widgets é encontrado.

[`matchesGoldenFile`][]
: Verifica se a renderização de um widget corresponde a uma imagem bitmap específica ("teste de arquivo dourado").

## Exemplo completo

<?code-excerpt "test/main_test.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Define um teste. A função TestWidgets também fornece um WidgetTester
  // para trabalhar. O WidgetTester permite construir e interagir
  // com widgets no ambiente de teste.
  testWidgets('MyWidget has a title and message', (tester) async {
    // Crie o widget dizendo ao testador para construí-lo.
    await tester.pumpWidget(const MyWidget(title: 'T', message: 'M'));

    // Crie os Finders.
    final titleFinder = find.text('T');
    final messageFinder = find.text('M');

    // Use o matcher `findsOneWidget` fornecido por flutter_test para
    // verificar se os widgets Text aparecem exatamente uma vez na árvore de widgets.
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
[Encontrando widgets em um teste de widget]: /cookbook/testing/widget/finders
[`flutter_test`]: {{api}}/flutter_test/flutter_test-library.html
[introdução a testes unitários]: /cookbook/testing/unit/introduction
[`Matcher`]: {{api}}/package-matcher_matcher/Matcher-class.html
[`pumpWidget()`]: {{api}}/flutter_test/WidgetTester/pumpWidget.html
[`tester.pump(Duration duration)`]: {{api}}/flutter_test/TestWidgetsFlutterBinding/pump.html
[`tester.pumpAndSettle()`]: {{api}}/flutter_test/WidgetTester/pumpAndSettle.html
[`testWidgets()`]: {{api}}/flutter_test/testWidgets.html
[`WidgetTester`]: {{api}}/flutter_test/WidgetTester-class.html
