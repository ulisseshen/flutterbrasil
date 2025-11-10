---
title: Limpeza do GestureRecognizer
description: >
  Subclasses de OneSequenceGestureRecognizer devem
  sobrescrever `addAllowedPointer` para receber um `PointerDownEvent`
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

`OneSequenceGestureRecognizer.addAllowedPointer()` foi alterado para receber um
`PointerDownEvent`, como sua superclasse. Anteriormente, ele aceitava o tipo
mais geral `PointerEvent`, o que estava incorreto.

## Contexto {:#context}

O framework sempre passa objetos `PointerDownEvent` para
`addAllowedPointer()`. Declarar
`OneSequenceGestureRecognizer.addAllowedPointer()` para receber o tipo
mais geral era confuso e fazia com que subclasses de `OneSequenceGestureRecognizer`
tivessem que converter seu argumento para a classe correta.

## Descrição da mudança {:#description-of-change}

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

A nova declaração do método fará com que esse código falhe com a seguinte
mensagem de erro:

```plaintext
super.addAllowedPointer(event); The argument type 'PointerEvent' can't be assigned to the parameter type 'PointerDownEvent'.
                                #argument_type_not_assignable

```

## Guia de migração {:#migration-guide}

Código antes da migração:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerEvent event) {
    // insert custom handling of event here...
    super.addAllowedPointer(event);
  }
}
```

Código após a migração:

```dart
class CustomGestureRecognizer extends ScaleGestureRecognizer {
  @override
  void addAllowedPointer(PointerDownEvent event) {
    // insert custom handling of event here...
    super.addAllowedPointer(event);
  }
}
```

## Linha do tempo {:#timeline}

Incluído na versão: 2.3.0-13.0.pre<br>
No lançamento estável: 2.5

## Referências {:#references}

Documentação da API:

* [`OneSequenceGestureRecognizer`][]

PR relevante:

* [Fix addAllowedPointer() overrides][]

[`OneSequenceGestureRecognizer`]: {{site.api}}/flutter/gestures/OneSequenceGestureRecognizer-class.html
[Fix addAllowedPointer() overrides]: {{site.repo.flutter}}/pull/82834
