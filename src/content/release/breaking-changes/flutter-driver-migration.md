---
title: Migrando de flutter_driver
description: >-
  Aprenda como migrar testes flutter_driver existentes para integration_test.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

<?code-excerpt path-base="integration_test_migration/"?>

Esta página descreve como migrar um projeto existente usando
`flutter_driver` para o pacote `integration_test`,
a fim de executar testes de integração.

Testes com `integration_test` usam os mesmos métodos que são
usados em [widget testing][].

Para uma introdução ao pacote `integration_test`,
confira o guia de [Integration testing][].

## Projeto de exemplo inicial

O projeto neste guia é um pequeno aplicativo desktop de exemplo com esta
funcionalidade:

* À esquerda, há uma lista de plantas que o usuário pode rolar,
  tocar e selecionar.
* À direita, há uma tela de detalhes que exibe o nome da planta
  e a espécie.
* Na inicialização do aplicativo, quando nenhuma planta está selecionada, um texto pedindo ao usuário para selecionar
  uma planta é exibido
* A lista de plantas é carregada de um arquivo JSON local localizado na
  pasta `/assets`.

<img src='/assets/images/docs/integration-test/migration-1.png' alt="Starter project screenshot">

Você pode encontrar o exemplo de código completo na pasta [Example Project][].

## Testes existentes

O projeto contém os três testes `flutter_driver`
executando as seguintes verificações:

* Verificando o status inicial do aplicativo.
* Selecionando o primeiro item na lista de plantas.
* Rolando e selecionando o último item na lista de plantas.

Os testes estão contidos na pasta `test_driver`,
dentro do arquivo `main_test.dart`.

Nesta pasta também há um arquivo chamado `main.dart`,
que contém uma chamada para o método `enableFlutterDriverExtension()`.
Este arquivo não será mais necessário ao usar `integration_test`.

## Configuração

Para começar a usar o pacote `integration_test`,
adicione o `integration_test` ao
seu arquivo `pubspec.yaml` se ainda não o fez:

```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
```

Em seguida, em seu projeto, crie um novo diretório
`integration_test/`, crie seus arquivos de testes lá
com o formato: `<name>_test.dart`.

## Migração de teste

Esta seção contém diferentes exemplos de como migrar testes
`flutter_driver` existentes para testes `integration_test`.

### Exemplo: Verificando se um widget está exibido

Quando o aplicativo inicia, a tela à direita exibe
um texto pedindo ao usuário para selecionar uma das plantas na lista.

Este teste verifica se o texto está exibido.

**flutter_driver**

No `flutter_driver`, o teste usa `waitFor`,
que aguarda até que o `finder` possa localizar o widget.
O teste falha se o widget não puder ser encontrado.

<?code-excerpt "test_driver/main_test.dart (wait-for)"?>
```dart
test(
  'do not select any item, verify please select text is displayed',
  () async {
    // Wait for 'please select' text is displayed
    await driver.waitFor(find.text('Please select a plant from the list.'));
  },
);
```

**integration_test**

No `integration_test` você deve executar duas etapas:

1. Primeiro, carregue o widget principal do aplicativo usando
   o método `tester.pumpWidget`.

2. Em seguida, use `expect` com o matcher `findsOneWidget` para verificar
   que o widget está exibido.

<?code-excerpt "integration_test/main_test.dart (finds-one)"?>
```dart
testWidgets(
  'do not select any item, verify please select text is displayed',
  (tester) async {
    // load the PlantsApp widget
    await tester.pumpWidget(const PlantsApp());

    // wait for data to load
    await tester.pumpAndSettle();

    // Find widget with 'please select'
    final finder = find.text('Please select a plant from the list.');

    // Check if widget is displayed
    expect(finder, findsOneWidget);
  },
);
```

### Exemplo: Ações de toque

Este teste executa uma ação de toque no primeiro item da lista,
que é um `ListTile` com o texto "Alder".

Após o toque, o teste aguarda os detalhes aparecerem.
Neste caso, ele aguarda o widget com o texto "Alnus" ser
exibido.

Além disso, o teste verifica que o texto
"Please select a plant from the list."
não está mais exibido.

**flutter_driver**

No `flutter_driver`, use o método `driver.tap` para executar
um toque sobre um widget usando um finder.

Para verificar que um widget não está exibido,
use o método `waitForAbsent`.

<?code-excerpt "test_driver/main_test.dart (wait-for-absent)"?>
```dart
test('tap on the first item (Alder), verify selected', () async {
  // find the item by text
  final item = find.text('Alder');

  // Wait for the list item to appear.
  await driver.waitFor(item);

  // Emulate a tap on the tile item.
  await driver.tap(item);

  // Wait for species name to be displayed
  await driver.waitFor(find.text('Alnus'));

  // 'please select' text should not be displayed
  await driver.waitForAbsent(
    find.text('Please select a plant from the list.'),
  );
});
```

**integration_test**

No `integration_test`, use `tester.tap` para executar as ações de toque.

Após a ação de toque, você deve chamar `tester.pumpAndSettle` para aguardar
até que a ação tenha terminado, e todas as mudanças de UI tenham acontecido.

Para verificar que um widget não está exibido, use a mesma função `expect`
com o matcher `findsNothing`.

<?code-excerpt "integration_test/main_test.dart (finds-nothing)"?>
```dart
testWidgets('tap on the first item (Alder), verify selected', (tester) async {
  await tester.pumpWidget(const PlantsApp());

  // wait for data to load
  await tester.pumpAndSettle();

  // find the item by text
  final item = find.text('Alder');

  // assert item is found
  expect(item, findsOneWidget);

  // Emulate a tap on the tile item.
  await tester.tap(item);
  await tester.pumpAndSettle();

  // Species name should be displayed
  expect(find.text('Alnus'), findsOneWidget);

  // 'please select' text should not be displayed
  expect(find.text('Please select a plant from the list.'), findsNothing);
});
```

### Exemplo: Rolagem

Este teste é semelhante ao teste anterior,
mas ele rola para baixo e toca no último item em vez disso.

**flutter_driver**

Para rolar para baixo com `flutter_driver`,
use o método `driver.scroll`.

Você deve fornecer o widget para executar a ação de rolagem,
bem como uma duração para a rolagem.

Você também deve fornecer o deslocamento total para a ação de rolagem.

<?code-excerpt "test_driver/main_test.dart (scroll)"?>
```dart
test('scroll, tap on the last item (Zedoary), verify selected', () async {
  // find the list of plants, by Key
  final listFinder = find.byValueKey('listOfPlants');

  // Scroll to the last position of the list
  // a -100,000 pixels is enough to reach the bottom of the list
  await driver.scroll(
    listFinder,
    0,
    -100000,
    const Duration(milliseconds: 500),
  );

  // find the item by text
  final item = find.text('Zedoary');

  // Wait for the list item to appear.
  await driver.waitFor(item);

  // Emulate a tap on the tile item.
  await driver.tap(item);

  // Wait for species name to be displayed
  await driver.waitFor(find.text('Curcuma zedoaria'));

  // 'please select' text should not be displayed
  await driver.waitForAbsent(
    find.text('Please select a plant from the list.'),
  );
});
```

**integration_test**

Com `integration_test`, pode usar o método `tester.scrollUntilVisible`.

Em vez de fornecer o widget para rolar,
forneça o item que você está procurando.
Neste caso, você está procurando o
item com o texto "Zedoary",
que é o último item na lista.

O método procura por qualquer widget `Scrollable`
e executa a ação de rolagem usando o deslocamento fornecido.
A ação se repete até que o item esteja visível.

<?code-excerpt "integration_test/main_test.dart (scroll)"?>
```dart
testWidgets('scroll, tap on the last item (Zedoary), verify selected', (
  tester,
) async {
  await tester.pumpWidget(const PlantsApp());

  // wait for data to load
  await tester.pumpAndSettle();

  // find the item by text
  final item = find.text('Zedoary');

  // finds Scrollable widget and scrolls until item is visible
  // a 100,000 pixels is enough to reach the bottom of the list
  await tester.scrollUntilVisible(item, 100000);

  // assert item is found
  expect(item, findsOneWidget);

  // Emulate a tap on the tile item.
  await tester.tap(item);
  await tester.pumpAndSettle();

  // Wait for species name to be displayed
  expect(find.text('Curcuma zedoaria'), findsOneWidget);

  // 'please select' text should not be displayed
  expect(find.text('Please select a plant from the list.'), findsNothing);
});
```

[Integration testing]: /testing/integration-tests
[widget testing]: /testing/overview#widget-tests
[Example Project]: {{site.repo.this}}/tree/{{site.branch}}/examples/integration_test_migration
