---
ia-translate: true
title: Migrando de flutter_driver
description: >-
  Aprenda como migrar testes existentes do flutter_driver para integration_test.
---

<?code-excerpt path-base="integration_test_migration/"?>

Esta página descreve como migrar um projeto existente usando
`flutter_driver` para o pacote `integration_test`,
para executar testes de integração.

Testes com `integration_test` usam os mesmos métodos que são
usados em [testes de widget][].

Para uma introdução ao pacote `integration_test`,
confira o guia [Testes de integração][].

## Projeto de exemplo inicial

O projeto neste guia é um pequeno exemplo de aplicativo de desktop com esta
funcionalidade:

* À esquerda, há uma lista de plantas que o usuário pode rolar,
  tocar e selecionar.
* À direita, há uma tela de detalhes que exibe o nome da planta
  e a espécie.
* Ao iniciar o aplicativo, quando nenhuma planta é selecionada, um texto
  pedindo ao usuário para selecionar uma planta é exibido.
* A lista de plantas é carregada de um arquivo JSON local localizado na
  pasta `/assets`.

<img src='/assets/images/docs/integration-test/migration-1.png' class="mw-100" alt="Captura de tela do projeto inicial">

Você pode encontrar o código de exemplo completo na pasta [Projeto de Exemplo][].

## Testes existentes

O projeto contém três testes `flutter_driver`
realizando as seguintes verificações:

* Verificando o status inicial do aplicativo.
* Selecionando o primeiro item na lista de plantas.
* Rolando e selecionando o último item na lista de plantas.

Os testes estão contidos na pasta `test_driver`,
dentro do arquivo `main_test.dart`.

Nesta pasta, há também um arquivo chamado `main.dart`,
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
`integration_test/`, crie seus arquivos de teste lá
com o formato: `<nome>_test.dart`.

## Migração de teste

Esta seção contém exemplos diferentes de como migrar testes
`flutter_driver` existentes para testes `integration_test`.

### Exemplo: Verificando se um widget é exibido

Quando o aplicativo é iniciado, a tela à direita exibe
um texto pedindo ao usuário para selecionar uma das plantas da lista.

Este teste verifica se o texto é exibido.

**flutter_driver**

Em `flutter_driver`, o teste usa `waitFor`,
que espera até que o `finder` possa localizar o widget.
O teste falha se o widget não puder ser encontrado.

<?code-excerpt "test_driver/main_test.dart (wait-for)"?>
```dart
test('não selecione nenhum item, verifique se o texto de por favor selecione é exibido',
    () async {
  // Espere até que o texto 'por favor selecione' seja exibido
  await driver.waitFor(find.text('Por favor, selecione uma planta da lista.'));
});
```

**integration_test**

Em `integration_test`, você deve executar duas etapas:

1. Primeiro, carregue o widget principal do aplicativo usando
   o método `tester.pumpWidget`.

2. Em seguida, use `expect` com o matcher `findsOneWidget` para verificar
   se o widget é exibido.

<?code-excerpt "integration_test/main_test.dart (finds-one)"?>
```dart
testWidgets('não selecione nenhum item, verifique se o texto de por favor selecione é exibido',
    (tester) async {
  // carrega o widget PlantsApp
  await tester.pumpWidget(const PlantsApp());

  // espere os dados serem carregados
  await tester.pumpAndSettle();

  // Encontra o widget com 'por favor selecione'
  final finder = find.text('Por favor, selecione uma planta da lista.');

  // Verifica se o widget é exibido
  expect(finder, findsOneWidget);
});
```

### Exemplo: Ações de toque

Este teste executa uma ação de toque no primeiro item da lista,
que é um `ListTile` com o texto "Alder".

Após o toque, o teste espera que os detalhes apareçam.
Neste caso, ele espera que o widget com o texto "Alnus" seja
exibido.

Além disso, o teste verifica se o texto
"Por favor, selecione uma planta da lista."
não é mais exibido.

**flutter_driver**

Em `flutter_driver`, use o método `driver.tap` para executar
um toque sobre um widget usando um finder.

Para verificar se um widget não é exibido,
use o método `waitForAbsent`.

<?code-excerpt "test_driver/main_test.dart (wait-for-absent)"?>
```dart
test('toque no primeiro item (Alder), verifique se foi selecionado', () async {
  // encontra o item por texto
  final item = find.text('Alder');

  // Espere que o item da lista apareça.
  await driver.waitFor(item);

  // Simula um toque no item do bloco.
  await driver.tap(item);

  // Espere que o nome da espécie seja exibido
  await driver.waitFor(find.text('Alnus'));

  // O texto 'por favor selecione' não deve ser exibido
  await driver
      .waitForAbsent(find.text('Por favor, selecione uma planta da lista.'));
});
```

**integration_test**

Em `integration_test`, use `tester.tap` para executar as ações de toque.

Após a ação de toque, você deve chamar `tester.pumpAndSettle` para esperar
até que a ação seja concluída e todas as alterações da UI tenham acontecido.

Para verificar se um widget não é exibido, use a mesma função `expect`
com o matcher `findsNothing`.

<?code-excerpt "integration_test/main_test.dart (finds-nothing)"?>
```dart
testWidgets('toque no primeiro item (Alder), verifique se foi selecionado', (tester) async {
  await tester.pumpWidget(const PlantsApp());

  // espere os dados serem carregados
  await tester.pumpAndSettle();

  // encontra o item por texto
  final item = find.text('Alder');

  // afirma que o item foi encontrado
  expect(item, findsOneWidget);

  // Simula um toque no item do bloco.
  await tester.tap(item);
  await tester.pumpAndSettle();

  // O nome da espécie deve ser exibido
  expect(find.text('Alnus'), findsOneWidget);

  // O texto 'por favor selecione' não deve ser exibido
  expect(find.text('Por favor, selecione uma planta da lista.'), findsNothing);
});
```

### Exemplo: Rolagem

Este teste é semelhante ao teste anterior,
mas rola para baixo e toca no último item, em vez disso.

**flutter_driver**

Para rolar para baixo com `flutter_driver`,
use o método `driver.scroll`.

Você deve fornecer o widget para executar a ação de rolagem,
bem como uma duração para a rolagem.

Você também deve fornecer o deslocamento total para a ação de rolagem.

<?code-excerpt "test_driver/main_test.dart (scroll)"?>
```dart
test('role, toque no último item (Zedoary), verifique se foi selecionado', () async {
  // encontra a lista de plantas, por Key
  final listFinder = find.byValueKey('listOfPlants');

  // Role para a última posição da lista
  // um -100.000 pixels é o suficiente para chegar ao final da lista
  await driver.scroll(
    listFinder,
    0,
    -100000,
    const Duration(milliseconds: 500),
  );

  // encontra o item por texto
  final item = find.text('Zedoary');

  // Espere que o item da lista apareça.
  await driver.waitFor(item);

  // Simula um toque no item do bloco.
  await driver.tap(item);

  // Espere que o nome da espécie seja exibido
  await driver.waitFor(find.text('Curcuma zedoaria'));

  // O texto 'por favor selecione' não deve ser exibido
  await driver
      .waitForAbsent(find.text('Por favor, selecione uma planta da lista.'));
});
```

**integration_test**

Com `integration_test`, pode usar o método `tester.scrollUntilVisible`.

Em vez de fornecer o widget para rolar,
forneça o item que você está procurando.
Neste caso, você está procurando o
item com o texto "Zedoary",
que é o último item da lista.

O método procura qualquer widget `Scrollable`
e executa a ação de rolagem usando o deslocamento fornecido.
A ação se repete até que o item esteja visível.

<?code-excerpt "integration_test/main_test.dart (scroll)"?>
```dart
testWidgets('role, toque no último item (Zedoary), verifique se foi selecionado',
    (tester) async {
  await tester.pumpWidget(const PlantsApp());

  // espere os dados serem carregados
  await tester.pumpAndSettle();

  // encontra o item por texto
  final item = find.text('Zedoary');

  // encontra o widget Scrollable e rola até que o item esteja visível
  // 100.000 pixels são suficientes para chegar ao final da lista
  await tester.scrollUntilVisible(
    item,
    100000,
  );

  // afirma que o item foi encontrado
  expect(item, findsOneWidget);

  // Simula um toque no item do bloco.
  await tester.tap(item);
  await tester.pumpAndSettle();

  // Espere que o nome da espécie seja exibido
  expect(find.text('Curcuma zedoaria'), findsOneWidget);

  // O texto 'por favor selecione' não deve ser exibido
  expect(find.text('Por favor, selecione uma planta da lista.'), findsNothing);
});
```

[Testes de integração]: /testing/integration-tests
[testes de widget]: /testing/overview#widget-tests
[Projeto de Exemplo]: {{site.repo.this}}/tree/{{site.branch}}/examples/integration_test_migration
