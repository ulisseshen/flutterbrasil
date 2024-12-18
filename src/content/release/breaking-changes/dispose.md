---
ia-translate: true
title: Adicionado `dispose()` ausente para alguns objetos descartáveis no Flutter
description: >
  `dispose()` pode falhar devido a descarte duplo.
---

## Sumário

Chamadas ausentes para 'dispose()' são adicionadas para alguns objetos descartáveis.
Por exemplo, ContextMenuController não descartava OverlayEntry,
e EditableTextState não descartava TextSelectionOverlay.

Se algum outro código também invocar 'dispose()' para o objeto,
e o objeto estiver protegido contra descarte duplo,
o segundo 'dispose()' falha com a seguinte mensagem de erro:

`Uma vez que você chamou dispose() em um <nome da classe>, ele não pode mais ser usado.`

## Contexto

A convenção é que o proprietário de um objeto deve descartá-lo.

Essa convenção foi quebrada em alguns lugares:
os proprietários não estavam descartando os objetos descartáveis.
O problema foi corrigido adicionando uma chamada para `dispose()`.
No entanto, se o objeto estiver protegido contra descarte duplo,
isso pode causar falhas ao executar no modo de depuração
e `dispose()` for chamado em outro lugar no objeto.

## Guia de migração

Se você encontrar o seguinte erro, atualize seu código para
chamar `dispose()` apenas nos casos em que seu código criou o objeto.

```plaintext
Uma vez que você chamou dispose() em um <nome da classe>, ele não pode mais ser usado.
```

Código antes da migração:

```dart
x.dispose();
```

Código após a migração:

```dart
if (xIsCreatedByMe) {
  x.dispose();
}
```

Para localizar o descarte incorreto, verifique a pilha de chamadas do erro. Se a pilha de chamadas apontar para `dispose`
em seu código, este descarte está incorreto e deve ser corrigido.

Se o erro ocorrer no código do Flutter, `dispose()` foi
chamado incorretamente na primeira vez.

Você pode localizar a chamada incorreta chamando temporariamente `print(StackTrace.current)`
no corpo do método com falha `dispose`.

## Cronograma

Veja o progresso e o status [na issue de acompanhamento]({{site.repo.flutter}}/issues/134787).
