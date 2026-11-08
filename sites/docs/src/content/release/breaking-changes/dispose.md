---
title: Adicionado `dispose()` ausente para alguns objetos descartáveis no Flutter
description: >
  'dispose()' pode falhar devido a descarte duplo.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Chamadas ausentes para 'dispose()' foram adicionadas para alguns objetos descartáveis.
Por exemplo, ContextMenuController não descartava OverlayEntry,
e EditableTextState não descartava TextSelectionOverlay.

Se algum outro código também invocar 'dispose()' para o objeto,
e o objeto estiver protegido contra descarte duplo,
o segundo 'dispose()' falhará com a seguinte mensagem de erro:

`Once you have called dispose() on a <class name>, it can no longer be used.`

## Contexto

A convenção é que o proprietário de um objeto deve descartá-lo.

Esta convenção foi quebrada em alguns lugares:
proprietários não estavam descartando os objetos descartáveis.
O problema foi corrigido adicionando uma chamada para `dispose()`.
No entanto, se o objeto estiver protegido contra descarte duplo,
isso pode causar falhas ao executar no modo debug
e `dispose()` for chamado em outro lugar no objeto.

## Guia de migração

Se você encontrar o seguinte erro, atualize seu código para
chamar `dispose()` apenas nos casos em que seu código criou o objeto.

```plaintext
Once you have called dispose() on a <class name>, it can no longer be used.
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
no seu código, este descarte está incorreto e deve ser corrigido.

Se o erro ocorrer no código Flutter, `dispose()` foi
chamado incorretamente na primeira vez.

Você pode localizar a chamada incorreta chamando temporariamente `print(StackTrace.current)`
no corpo do método `dispose` que falhou.

## Cronograma

Veja o progresso e status [no issue de acompanhamento]({{site.repo.flutter}}/issues/134787).
