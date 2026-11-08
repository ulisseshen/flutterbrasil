---
title: Otimização de Container com color
description: >
  Um container com uma cor e nenhuma outra decoração de fundo
  não constrói mais os mesmos widgets filhos.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Um novo widget `ColoredBox` foi adicionado ao framework,
e o widget `Container` foi otimizado para usá-lo
se um usuário especificar uma `color` em vez de uma `decoration`.

## Context

É muito comum usar o widget `Container` da seguinte forma:

```dart
return Container(color: Colors.red);
```

Anteriormente, este código resultava em uma hierarquia de widgets que usava uma
`BoxDecoration` para realmente pintar a cor de fundo.
O widget `BoxDecoration` cobre muitos casos além de
apenas pintar uma cor de fundo,
e não é tão eficiente quanto o novo widget `ColoredBox`,
que apenas pinta uma cor de fundo.

Testes de widgets que queriam fazer assertions baseadas na cor
de um container na árvore de widgets anteriormente teriam
que encontrar a `BoxDecoration` para realmente obter
a cor do container.
Agora, eles são capazes de verificar a propriedade `color`
no próprio `Container`, a menos que uma `BoxDecoration`
tenha sido explicitamente fornecida como a propriedade `decoration`.
Ainda é um erro fornecer tanto `color` quanto
`decoration` para `Container`.

## Migration guide

Testes que fazem assertions na cor de um `Container`
ou que esperavam que ele criasse uma
`BoxDecoration` precisam ser modificados.

Código antes da migração:

```dart
testWidgets('Container color', (WidgetTester tester) async {
  await tester.pumpWidget(Container(color: Colors.red));

  final Container container = tester.widgetList<Container>().first;
  expect(container.decoration.color, Colors.red);
  // Or, a test may have specifically looked for the BoxDecoration, e.g.:
  expect(find.byType(BoxDecoration), findsOneWidget);
});
```

Código após a migração:

```dart
testWidgets('Container color', (WidgetTester tester) async {
  await tester.pumpWidget(Container(color: Colors.red));

  final Container container = tester.widgetList<Container>().first;
  expect(container.color, Colors.red);
  // If your test needed to work directly with the BoxDecoration, it should
  // instead look for the ColoredBox, e.g.:
  expect(find.byType(BoxDecoration), findsNothing);
  expect(find.byType(ColoredBox), findsOneWidget);
});
```

## Timeline

Adicionado na versão: 1.15.4<br>
Na versão estável: 1.17

## References

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
