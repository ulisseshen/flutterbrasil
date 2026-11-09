---
title: Descontinuar MemoryAllocations em favor de FlutterMemoryAllocations
description: >-
  MemoryAllocations é renomeado para FlutterMemoryAllocations.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Descartáveis em projetos Dart puros não podem usar `MemoryAllocations` no Flutter.
Portanto, para serem rastreáveis quanto a vazamentos, eles precisam de uma classe somente Dart.
`MemoryAllocations` no Flutter é renomeado para disponibilizar o nome
para um projeto Dart não-Flutter.

## Guia de migração {:#migration-guide}

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

## Linha do tempo {:#timeline}

Disponibilizado na versão: 3.19.0-2.0.pre<br>
Disponibilizado na estável: 3.22.0

## Referências {:#references}

Issues relevantes:

* [Rename MemoryAllocations to FlutterMemoryAllocations (Issue 140622)][]

[Rename MemoryAllocations to FlutterMemoryAllocations (Issue 140622)]: {{site.repo.flutter}}/issues/140622
