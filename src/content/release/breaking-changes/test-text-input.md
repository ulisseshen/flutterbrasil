---
ia-translate: true
title: Reset de estado do TestTextInput
description: O estado de TestTextInput agora é resetado entre testes.
---

## Resumo

O estado de uma instância `TestTextInput`,
um stub para o teclado na tela do sistema,
agora é resetado entre testes.

## Contexto

O framework de teste do Flutter usa uma classe chamada `TestTextInput`
para rastrear e manipular o estado de edição em um teste de widgets.
Testes individuais podem fazer chamadas que modificam o estado
interno deste objeto, às vezes indiretamente (como
ao definir seus próprios handlers em `SystemChannels.textInput`).
Testes subsequentes podem então verificar o estado de
`WidgetTester.testTextInput` e obter valores inesperados.

## Descrição da mudança

O estado de `WidgetTester.testTextInput`
agora é resetado antes de executar um teste `testWidgets`.

## Guia de migração

Testes que dependiam de estado sujo de um teste executado
anteriormente devem ser atualizados. Por exemplo, o seguinte teste,
de `packages/flutter/test/material/text_field_test.dart`
no teste `'Controller can update server'`,
anteriormente passava por causa de uma combinação de estado sujo
de testes anteriores e uma falha em realmente definir o estado
nos casos onde deveria ter sido definido.

Código antes da migração:

Em um `widgetsTest`, antes de realmente alterar texto em um
widget de edição de texto, esta chamada poderia ter sucedido:

```dart
    expect(tester.testTextInput.editingState['text'], isEmpty);
```

Código após a migração:

Remova a chamada completamente, ou considere usar o
seguinte para afirmar que o estado ainda não foi modificado:

```dart
    expect(tester.testTextInput.editingState, isNull);
```

## Cronograma

Adicionado na versão: 1.16.3<br>
Na versão stable: 1.17

## Referências

Documentação da API:

* [`TestTextInput`][]
* [`WidgetTester`][]

Issue relevante:

* [Randomize test order to avoid global state][]

PR relevante:

* [Reset state between tests][]


[Randomize test order to avoid global state]: {{site.repo.flutter}}/issues/47233
[Reset state between tests]: {{site.repo.flutter}}/pull/47464
[`TestTextInput`]: {{site.api}}/flutter/flutter_test/TestTextInput-class.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
