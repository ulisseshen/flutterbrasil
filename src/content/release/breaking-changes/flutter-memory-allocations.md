---
ia-translate: true
title: Depreciar MemoryAllocations em favor de FlutterMemoryAllocations
description: >-
  MemoryAllocations foi renomeado para FlutterMemoryAllocations.
---

## Resumo

Disposables em projetos Dart puros não podem usar `MemoryAllocations` no Flutter.
Então, para serem rastreáveis quanto a vazamentos de memória, eles precisam de uma classe somente-Dart.
`MemoryAllocations` no Flutter foi renomeado para disponibilizar o nome
para um projeto Dart não-Flutter.

## Guia de migração

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

Adicionado na versão: 3.19.0-2.0.pre<br>
Na versão stable: 3.22.0

## Referências

Issues relevantes:

* [Rename MemoryAllocations to FlutterMemoryAllocations (Issue 140622)][]

[Rename MemoryAllocations to FlutterMemoryAllocations (Issue 140622)]: {{site.repo.flutter}}/issues/140622
