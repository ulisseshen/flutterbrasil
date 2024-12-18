---
ia-translate: true
title: Container com otimização de cor
description: >
  Um container com uma cor e nenhuma outra decoração de fundo
  não constrói mais os mesmos widgets filhos.
---

## Sumário

Um novo widget `ColoredBox` foi adicionado ao framework,
e o widget `Container` foi otimizado para usá-lo
se um usuário especificar uma `color` em vez de uma `decoration`.

## Contexto

É muito comum usar o widget `Container` da seguinte forma:

```dart
return Container(color: Colors.red);
```

Anteriormente, esse código resultava em uma hierarquia de widgets que usava uma
`BoxDecoration` para realmente pintar a cor de fundo.
O widget `BoxDecoration` abrange muitos casos além de
apenas pintar uma cor de fundo,
e não é tão eficiente quanto o novo widget `ColoredBox`,
que apenas pinta uma cor de fundo.

Testes de widget que queriam fazer asserções com base na cor
de um container na árvore de widgets anteriormente teriam
que encontrar o `BoxDecoration` para realmente obter
a cor do container.
Agora, eles podem verificar a propriedade `color`
no próprio `Container`, a menos que uma `BoxDecoration`
tenha sido explicitamente fornecida como a propriedade `decoration`.
Ainda é um erro fornecer `color` e
`decoration` para `Container`.

## Guia de migração

Testes que fazem asserções sobre a cor de um `Container`
ou que esperavam que ele criasse uma
`BoxDecoration` precisam ser modificados.

Código antes da migração:

```dart
testWidgets('Container color', (WidgetTester tester) async {
  await tester.pumpWidget(Container(color: Colors.red));

  final Container container = tester.widgetList<Container>().first;
  expect(container.decoration.color, Colors.red);
  // Ou, um teste pode ter procurado especificamente pelo BoxDecoration, por exemplo:
  expect(find.byType(BoxDecoration), findsOneWidget);
});
```

Código após a migração:

```dart
testWidgets('Container color', (WidgetTester tester) async {
  await tester.pumpWidget(Container(color: Colors.red));

  final Container container = tester.widgetList<Container>().first;
  expect(container.color, Colors.red);
  // Se o seu teste precisava trabalhar diretamente com o BoxDecoration, ele deveria
  // em vez disso, procurar pelo ColoredBox, por exemplo:
  expect(find.byType(BoxDecoration), findsNothing);
  expect(find.byType(ColoredBox), findsOneWidget);
});
```

## Linha do tempo

Implementado na versão: 1.15.4<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`Container`][]
* [`ColoredBox`][]
* [`BoxDecoration`][]

Issues relevantes:

* [Issue 9672][]
* [Issue 28753][]

PR relevante:

* [Colored box and container optimization #50979][]

[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`ColoredBox`]: {{site.api}}/flutter/widgets/ColoredBox-class.html
[`BoxDecoration`]: {{site.api}}/flutter/painting/BoxDecoration-class.html
[Issue 9672]: {{site.repo.flutter}}/issues/9672
[Issue 28753]: {{site.repo.flutter}}/issues/28753
[Colored box and container optimization #50979]: {{site.repo.flutter}}/pull/50979
