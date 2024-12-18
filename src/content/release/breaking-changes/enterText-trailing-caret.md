---
ia-translate: true
title: Altere o método enterText para mover o cursor para o final do texto de entrada
description: >
  Os métodos `WidgetTester.enterText` e `TestTextInput.enterText` agora
  movem o cursor para o final do texto de entrada.
---

## Resumo

Os métodos `WidgetTester.enterText` e `TestTextInput.enterText` agora movem o cursor para o final do texto de entrada.

## Contexto

O cursor indica o ponto de inserção dentro do texto atual em um campo de entrada ativo. Normalmente, quando um novo caractere é inserido, o cursor permanece imediatamente após ele. No Flutter, a posição do cursor é representada por uma seleção recolhida. Quando a seleção é inválida, geralmente o usuário não poderá modificar ou adicionar texto até que altere a seleção para um valor válido.

`WidgetTester.enterText` e `TestTextInput.enterText` são 2 métodos usados em testes para substituir o conteúdo do campo de texto de destino. Antes desta alteração, `WidgetTester.enterText` e `TestTextInput.enterText` definiam a seleção para um intervalo inválido (-1, -1), indicando que não há seleção ou cursor. Isso contradiz o comportamento típico de um campo de entrada.

## Descrição da alteração

Além de substituir o texto pelo texto fornecido, `WidgetTester.enterText` e `TestTextInput.enterText` agora definem a seleção para `TextSelection.collapsed(offset: text.length)`, em vez de `TextSelection.collapsed(offset: -1)`.

## Guia de migração

Deve ser muito incomum para os testes terem que depender do comportamento anterior de `enterText`, já que normalmente a seleção não deve ser inválida. **Considere alterar os valores esperados de seus testes para adotar a alteração do `enterText`.**

Falhas de teste comuns que essa mudança pode introduzir incluem:

- Falhas de teste Golden:
  
    O cursor aparece no final do texto, em vez de antes do texto anterior à alteração.
  
- Diferente `TextEditingValue.selection` depois de chamar `enterText`:

    O `TextEditingValue` do campo de texto agora tem uma seleção recolhida com um deslocamento não negativo, em vez de `TextSelection.collapsed(offset: -1)` anterior à alteração. Por exemplo, você pode ver `expect(controller.value.selection.baseOffset, -1);` falhando após chamadas `enterText`.

Se seus testes tiverem que depender da configuração da seleção para inválida, o comportamento anterior pode ser alcançado usando `updateEditingValue`:

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

## Linha do tempo

Implementado na versão: 2.1.0-13.0.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`WidgetTester.enterText`][]
* [`TestTextInput.enterText`][]

Problemas relevantes:

* [Issue 79494][]

PR relevante:

* [enterText to move the caret to the end][]


[`WidgetTester.enterText`]: {{site.api}}/flutter/flutter_test/WidgetTester/enterText.html
[`TestTextInput.enterText`]: {{site.api}}/flutter/flutter_test/TestTextInput/enterText.html

[Issue 79494]: {{site.repo.flutter}}/issues/79494
[enterText to move the caret to the end]: {{site.repo.flutter}}/pull/79506
