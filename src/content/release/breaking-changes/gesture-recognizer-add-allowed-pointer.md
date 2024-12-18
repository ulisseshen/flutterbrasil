---
ia-translate: true
title: Limpeza de GestureRecognizer
description: >
  Subclasses de `OneSequenceGestureRecognizer` devem
  sobrescrever `addAllowedPointer` para receber um `PointerDownEvent`
---

## Sumário

`OneSequenceGestureRecognizer.addAllowedPointer()` foi alterado para receber um
`PointerDownEvent`, como sua superclasse. Anteriormente, aceitava o tipo mais
geral `PointerEvent`, o que estava incorreto.

## Contexto

O framework sempre passa objetos `PointerDownEvent` para
`addAllowedPointer()`. Declarar
`OneSequenceGestureRecognizer.addAllowedPointer()` para receber o tipo mais geral
era confuso e fazia com que as subclasses de `OneSequenceGestureRecognizer`
tivessem que converter seu argumento para a classe correta.

## Descrição da alteração

A declaração anterior forçava os descendentes de `OneSequenceGestureRecognizer` a
sobrescrever `addAllowedPointer()` da seguinte forma:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerEvent event) {
    // insira o tratamento personalizado de evento aqui...
    super.addAllowedPointer(event);
  }
}
```

A nova declaração de método fará com que este código falhe com a seguinte
mensagem de erro:

```plaintext
super.addAllowedPointer(event); O tipo de argumento 'PointerEvent' não pode ser atribuído ao tipo de parâmetro 'PointerDownEvent'.
                                #argument_type_not_assignable

```

## Guia de migração

Código antes da migração:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerEvent event) {
    // insira o tratamento personalizado de evento aqui...
    super.addAllowedPointer(event);
  }
}
```

Código após a migração:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    // insira o tratamento personalizado de evento aqui...
    super.addAllowedPointer(event);
  }
}
```

## Cronologia

Implementado na versão: 2.3.0-13.0.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`OneSequenceGestureRecognizer`][]

PR relevante:

* [Correção de sobrescritas de addAllowedPointer()][]

[`OneSequenceGestureRecognizer`]: {{site.api}}/flutter/gestures/OneSequenceGestureRecognizer-class.html
[Correção de sobrescritas de addAllowedPointer()]: {{site.repo.flutter}}/pull/82834
