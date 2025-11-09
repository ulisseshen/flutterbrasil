---
ia-translate: true
title: Testar orientação
description: Como testar se um app está em modo retrato ou paisagem.
---

{% assign api = site.api | append: '/flutter' -%}

No Flutter, você pode construir diferentes layouts dependendo de uma dada
[orientação][orientation]. Por exemplo, você pode apresentar dados em duas colunas se o app
está em modo retrato, e três colunas se em modo paisagem.
Adicionalmente, você pode criar testes que verificam se o número correto de colunas
está sendo exibido para cada orientação.

Nesta receita, você pode aprender como verificar se a orientação de um app é
`portrait` ou `landscape`, e também quantas colunas são exibidas para cada
orientação.

Esta receita usa os seguintes passos:

  1.  Crie um app que atualiza o layout do conteúdo,
      baseado na orientação.
  1.  Crie um grupo de testes de orientação.
  1.  Crie um teste de orientação retrato.
  1.  Crie um teste de orientação paisagem.
  1.  Execute os testes.

## 1. Crie um app que atualiza baseado na orientação

Crie um app Flutter que muda quantas colunas são exibidas quando um
app está em modo retrato ou paisagem:

1.  Crie um novo projeto Flutter chamado `orientation_tests`.

    ```console
    flutter create orientation_tests
    ```

2.  Siga os passos em [Atualizar a UI baseado na orientação][Update the UI based on orientation] para
    configurar o projeto.

## 2. Crie um grupo de testes de orientação

Depois que você configurar seu projeto `orientation_tests`, complete estes passos para
agrupar seus futuros testes de orientação:

1.  No seu projeto Flutter, abra `test/widget_test.dart`.
1.  Substitua o conteúdo existente pelo seguinte:

    <?code-excerpt "cookbook/testing/widget/orientation_tests/test/widget_test.dart (scaffolding)"?>
    ```dart title="widget_test.dart"
    import 'package:flutter/material.dart';
    import 'package:flutter_test/flutter_test.dart';
    import 'package:orientation_tests/main.dart';

    void main() {
      group('Orientation', () {
        // ···
      });
    }
    ```

## 3. Crie um teste de orientação retrato

Adicione o teste de orientação retrato ao grupo `Orientation`.
Este teste garante que a orientação é `portrait` e que
apenas `2` colunas de dados aparecem no app:

1.  Em `test/widget_test.dart`, substitua `...` dentro do grupo `Orientation`
    pelo seguinte teste:

    <?code-excerpt "cookbook/testing/widget/orientation_tests/test/widget_test.dart (portrait-mode-test)"?>
    ```dart title="widget_test.dart"
    // Check if portrait mode displays correctly.
    testWidgets('Displays 2 columns in portrait mode', (tester) async {
      // Build the app.
      await tester.pumpWidget(const MyApp());

      // Change to portrait.
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
      });
      await tester.pump();

      // Verify initial orientation is portrait.
      final orientation = MediaQuery.of(
        tester.element(find.byType(OrientationList)),
      ).orientation;
      expect(orientation, Orientation.portrait);

      // Verify there are only 2 columns in portrait mode.
      final gridViewFinder = find.byType(GridView);
      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });
    ```

## 4. Crie um teste de orientação paisagem

Adicione o teste de orientação paisagem ao grupo `Orientation`.
Este teste garante que a orientação é `landscape` e que
apenas `3` colunas de dados aparecem no app:

1.  Em `test/widget_test.dart`, dentro do grupo `Orientation`,
    adicione o seguinte teste após o teste de paisagem:

    <?code-excerpt "cookbook/testing/widget/orientation_tests/test/widget_test.dart (landscape-mode-test)"?>
    ```dart title="widget_test.dart"
    // Check if landscape mode displays correctly.
    testWidgets('Displays 3 columns in landscape mode', (tester) async {
      // Build the app.
      await tester.pumpWidget(const MyApp());

      // Change to landscape.
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
      });
      await tester.pump();

      // Verify initial orientation is landscape.
      final orientation = MediaQuery.of(
        tester.element(find.byType(OrientationList)),
      ).orientation;
      expect(orientation, Orientation.landscape);

      // Verify there are only 3 columns in landscape mode.
      final gridViewFinder = find.byType(GridView);
      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3);
    });
    ```

## 5. Execute os testes

Execute os testes usando o seguinte comando a partir da raiz do projeto:

```console
flutter test test/widget_test.dart
```

## Exemplo completo

<?code-excerpt "cookbook/testing/widget/orientation_tests/test/widget_test.dart"?>
```dart title="widget_test.dart"
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:orientation_tests/main.dart';

void main() {
  group('Orientation', () {
    // Check if portrait mode displays correctly.
    testWidgets('Displays 2 columns in portrait mode', (tester) async {
      // Build the app.
      await tester.pumpWidget(const MyApp());

      // Change to portrait.
      tester.view.physicalSize = const Size(600, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
      });
      await tester.pump();

      // Verify initial orientation is portrait.
      final orientation = MediaQuery.of(
        tester.element(find.byType(OrientationList)),
      ).orientation;
      expect(orientation, Orientation.portrait);

      // Verify there are only 2 columns in portrait mode.
      final gridViewFinder = find.byType(GridView);
      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 2);
    });

    // Check if landscape mode displays correctly.
    testWidgets('Displays 3 columns in landscape mode', (tester) async {
      // Build the app.
      await tester.pumpWidget(const MyApp());

      // Change to landscape.
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
      });
      await tester.pump();

      // Verify initial orientation is landscape.
      final orientation = MediaQuery.of(
        tester.element(find.byType(OrientationList)),
      ).orientation;
      expect(orientation, Orientation.landscape);

      // Verify there are only 3 columns in landscape mode.
      final gridViewFinder = find.byType(GridView);
      final gridView = tester.widget<GridView>(gridViewFinder);
      final delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
      expect(delegate.crossAxisCount, 3);
    });
  });
}
```

<?code-excerpt "cookbook/testing/widget/orientation_tests/lib/main.dart"?>
```dart title="main.dart"
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Orientation Demo';

    return const MaterialApp(
      title: appTitle,
      home: OrientationList(title: appTitle),
    );
  }
}

class OrientationList extends StatelessWidget {
  final String title;

  const OrientationList({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.count(
            // Create a grid with 2 columns in portrait mode, or
            // 3 columns in landscape mode.
            crossAxisCount: orientation == Orientation.portrait ? 2 : 3,
            // Generate 100 widgets that display their index in the list.
            children: List.generate(100, (index) {
              return Center(
                child: Text(
                  'Item $index',
                  style: TextTheme.of(context).displayLarge,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
```

[orientation]: {{site.api}}/flutter/widgets/Orientation.html
[Update the UI based on orientation]: /cookbook/design/orientation
