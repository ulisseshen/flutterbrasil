---
ia-translate: true
title: Descontinuar MemoryAllocations em favor de FlutterMemoryAllocations
description: >-
  MemoryAllocations é renomeado para FlutterMemoryAllocations.
---

## Resumo

Disposables em projetos Dart puros não podem usar `MemoryAllocations` no Flutter.
Então, para serem rastreáveis quanto a vazamentos, eles precisam de uma classe
exclusivamente Dart. `MemoryAllocations` no Flutter é renomeado para tornar o nome
disponível para um projeto Dart não-Flutter.

## Guia de Migração

Antes:

```dart
if (kFlutterMemoryAllocationsEnabled) {
  MemoryAllocations.instance.dispatchObjectCreated(
    library: 'package:flutter/gestures.dart',
    className: '$MultiDragPointerState',
    object: this,
  );
}
```

Depois:

```dart
if (kFlutterMemoryAllocationsEnabled) {
  FlutterMemoryAllocations.instance.dispatchObjectCreated(
    library: 'package:flutter/gestures.dart',
    className: '$MultiDragPointerState',
    object: this,
  );
}
```

## Cronograma

Implementado na versão: 3.19.0-2.0.pre<br>
Implementado na versão estável: 3.22.0

## Referências

Issues relevantes:

* [Renomear MemoryAllocations para FlutterMemoryAllocations (Issue 140622)][]

[Renomear MemoryAllocations para FlutterMemoryAllocations (Issue 140622)]: {{site.repo.flutter}}/issues/140622
