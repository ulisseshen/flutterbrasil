---
title: Estado de TestTextInput redefinido
description: O estado de TestTextInput agora é redefinido entre os testes.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O estado de uma instância de `TestTextInput`,
um stub para o teclado virtual do sistema,
agora é redefinido entre os testes.

## Contexto {:#context}

O framework de testes do Flutter usa uma classe chamada `TestTextInput`
para rastrear e manipular o estado de edição em um teste de widgets.
Testes individuais podem fazer chamadas que modificam o estado interno
desse objeto, às vezes de forma indireta (por exemplo,
definindo os próprios handlers em `SystemChannels.textInput`).
Testes posteriores podem então verificar o estado de
`WidgetTester.testTextInput` e obter valores inesperados.

## Descrição da mudança {:#description-of-change}

O estado de `WidgetTester.testTextInput`
agora é redefinido antes da execução de um teste `testWidgets`.

## Guia de migração {:#migration-guide}

Testes que dependiam de um estado sujo deixado por outro teste
executado anteriormente devem ser atualizados. Por exemplo, o teste
a seguir, de `packages/flutter/test/material/text_field_test.dart`,
no teste `'Controller can update server'`, passava antes por causa
de uma combinação de estado sujo dos testes anteriores
e de uma falha em definir o estado nos casos em que ele deveria
ter sido definido.

Código antes da migração:

Em um `widgetsTest`, antes de alterar de fato o texto de um
widget de edição de texto, esta chamada podia ter sido bem-sucedida:

```dart
    expect(tester.testTextInput.editingState['text'], isEmpty);
```

Código após a migração:

Remova a chamada por completo ou use a seguinte verificação,
para confirmar que o estado ainda não foi modificado:

```dart
    expect(tester.testTextInput.editingState, isNull);
```

## Linha do tempo {:#timeline}

Incluído na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências {:#references}

Documentação da API:

* [`TestTextInput`][]
* [`WidgetTester`][]

Issue relevante:

* [Randomizar a ordem dos testes para evitar estado global][Randomize test order to avoid global state]

PR relevante:

* [Redefinir o estado entre os testes][Reset state between tests]


[Randomize test order to avoid global state]: {{site.repo.flutter}}/issues/47233
[Reset state between tests]: {{site.repo.flutter}}/pull/47464
[`TestTextInput`]: {{site.api}}/flutter/flutter_test/TestTextInput-class.html
[`WidgetTester`]: {{site.api}}/flutter/flutter_test/WidgetTester-class.html
