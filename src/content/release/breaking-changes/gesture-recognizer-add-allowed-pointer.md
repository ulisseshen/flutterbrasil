---
title: Limpeza do GestureRecognizer
description: >
  Subclasses de OneSequenceGestureRecognizer devem
  sobrescrever `addAllowedPointer` para aceitar um `PointerDownEvent`
ia-translate: true
---

## Resumo

`OneSequenceGestureRecognizer.addAllowedPointer()` foi alterado para aceitar um
`PointerDownEvent`, como sua superclasse. Anteriormente, aceitava o tipo
`PointerEvent` mais geral, o que estava incorreto.

## Contexto

O framework apenas passa objetos `PointerDownEvent` para
`addAllowedPointer()`. Declarar
`OneSequenceGestureRecognizer.addAllowedPointer()` para aceitar o tipo mais geral
era confuso, e causava que subclasses de `OneSequenceGestureRecognizer`
tivessem que converter seu argumento para a classe correta.

## Descrição da mudança

A declaração anterior forçava descendentes de `OneSequenceGestureRecognizer` a
sobrescrever `addAllowedPointer()` assim:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerEvent event) {
    // insert custom handling of event here...
    super.addAllowedPointer(event);
  }
}
```

A nova declaração de método fará este código falhar com a seguinte
mensagem de erro:

```plaintext
super.addAllowedPointer(event); The argument type 'PointerEvent' can't be assigned to the parameter type 'PointerDownEvent'.
                                #argument_type_not_assignable

```

## Guia de migração

Código antes da migração:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerEvent event) {
    // insira tratamento customizado do evento aqui...
    super.addAllowedPointer(event);
  }
}
```

Código após a migração:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    // insira tratamento customizado do evento aqui...
    super.addAllowedPointer(event);
  }
}
```

## Linha do tempo

Implementado na versão: 2.3.0-13.0.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`OneSequenceGestureRecognizer`][]

PR relevante:

* [Fix addAllowedPointer() overrides][]

[`OneSequenceGestureRecognizer`]: {{site.api}}/flutter/gestures/OneSequenceGestureRecognizer-class.html
[Fix addAllowedPointer() overrides]: {{site.repo.flutter}}/pull/82834
