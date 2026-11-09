---
title: Alterar o método enterText para mover o cursor para o final do texto de entrada
description: >
  WidgetTester.enterText e TestTextInput.enterText agora
  movem o cursor para o final do texto de entrada.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Os métodos `WidgetTester.enterText` e `TestTextInput.enterText`
agora movem o cursor para o final do texto de entrada.

## Context

O cursor indica o ponto de inserção dentro do texto atual em um
campo de entrada ativo. Normalmente, quando um novo caractere é inserido, o
cursor permanece imediatamente após ele. No Flutter, a posição do cursor é
representada por uma seleção colapsada. Quando a seleção é inválida,
geralmente o usuário não conseguirá modificar ou adicionar texto até que ele
altere a seleção para um valor válido.

`WidgetTester.enterText` e `TestTextInput.enterText` são 2 métodos
usados em testes para substituir o conteúdo do campo de texto alvo. Antes
desta mudança, `WidgetTester.enterText` e `TestTextInput.enterText`
definiam a seleção para um intervalo inválido (-1, -1), indicando que não há
seleção ou cursor. Isso contradiz o comportamento típico de um
campo de entrada.

## Description of change

Além de substituir o texto pelo texto fornecido,
`WidgetTester.enterText` e `TestTextInput.enterText` agora definem a
seleção como `TextSelection.collapsed(offset: text.length)`, em vez de
`TextSelection.collapsed(offset: -1)`.

## Migration guide

Deve ser muito incomum que testes tenham que depender do
comportamento anterior de `enterText`, já que geralmente a seleção
não deve ser inválida. **Considere alterar os valores esperados dos
seus testes para adotar a mudança de `enterText`.**

Falhas de teste comuns que esta mudança pode introduzir incluem:

- Falhas de testes Golden:

  O cursor aparece no final do texto, em vez de antes do
  texto antes da mudança.

- `TextEditingValue.selection` diferente após chamar `enterText`:

  O `TextEditingValue` do campo de texto agora tem uma
  seleção colapsada com um offset não negativo, em vez de
  `TextSelection.collapsed(offset: -1)` antes da mudança.
  Por exemplo, você pode ver
  `expect(controller.value.selection.baseOffset, -1);`
  falhando após chamadas de `enterText`.

Se seus testes precisam depender de definir a seleção como inválida,
o comportamento anterior pode ser alcançado usando `updateEditingValue`:

### `TestTextInput.enterText`

Código antes da migração:

```dart
await testTextInput.enterText(text);
```

Código após a migração:

```dart
await testTextInput.updateEditingValue(TextEditingValue(
  text: text,
));
```

### `WidgetTester.enterText`

Código antes da migração:

```dart
await tester.enterText(finder, text);
```

Código após a migração:

```dart
await tester.showKeyboard(finder);
await tester.updateEditingValue(TextEditingValue(
  text: text,
));
await tester.idle();
```

## Timeline

Adicionado na versão: 2.1.0-13.0.pre<br>
Na versão estável: 2.5

## References

Documentação da API:

* [`WidgetTester.enterText`][]
* [`TestTextInput.enterText`][]

Issues relevantes:

* [Issue 79494][]

PR relevante:

* [enterText to move the caret to the end][]


[`WidgetTester.enterText`]: {{site.api}}/flutter/flutter_test/WidgetTester/enterText.html
[`TestTextInput.enterText`]: {{site.api}}/flutter/flutter_test/TestTextInput/enterText.html

[Issue 79494]: {{site.repo.flutter}}/issues/79494
[enterText to move the caret to the end]: {{site.repo.flutter}}/pull/79506
