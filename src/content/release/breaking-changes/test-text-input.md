---
ia-translate: true
title: Redefinição do estado do TestTextInput
description: O estado do TestTextInput agora é redefinido entre os testes.
---

## Resumo

O estado de uma instância de `TestTextInput`, um stub para o teclado na tela do sistema, agora é redefinido entre os testes.

## Contexto

O framework de teste do Flutter usa uma classe chamada `TestTextInput` para rastrear e manipular o estado de edição em um teste de widgets. Testes individuais podem fazer chamadas que modificam o estado interno desse objeto, às vezes indiretamente (como ao definir seus próprios manipuladores em `SystemChannels.textInput`). Testes subsequentes podem então verificar o estado de `WidgetTester.testTextInput` e obter valores inesperados.

## Descrição da mudança

O estado de `WidgetTester.testTextInput` agora é redefinido antes de executar um teste `testWidgets`.

## Guia de migração

Testes que dependiam do estado sujo de um teste executado anteriormente devem ser atualizados. Por exemplo, o seguinte teste, de `packages/flutter/test/material/text_field_test.dart` no teste `'Controller can update server'`, passou anteriormente devido a uma combinação de estado sujo de testes anteriores e uma falha em realmente definir o estado em casos onde deveria ter sido definido.

Código antes da migração:

Em um `widgetsTest`, antes de realmente alterar o texto em um widget de edição de texto, esta chamada poderia ter sido bem-sucedida:

```dart
    expect(tester.testTextInput.editingState['text'], isEmpty);
```

Código após a migração:

Remova a chamada completamente ou considere usar o seguinte para afirmar que o estado ainda não foi modificado:

```dart
    expect(tester.testTextInput.editingState, isNull);
```

## Linha do tempo

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`TestTextInput`][]
* [`WidgetTester`][]

Problema relevante:

* [Randomize test order to avoid global state][]

PR relevante:

* [Reset state between tests][]

[Randomize test order to avoid global state]: {{site.repo.flutter}}/issues/47233
[Reset state between tests]: {{site.repo.flutter}}/pull/47464
[`TestTextInput`]: {{site.api}}/flutter/flutter_test/TestTextInput-class.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
