---
ia-translate: true
title: Tornar PageView.controller anulável
description: >-
  PageView.controller agora é anulável.
---

## Sumário

Se um controller não for fornecido no construtor, o membro `controller` é `null`. Isso torna `PageView` e sua propriedade `controller` consistentes com outros widgets.

## Guia de migração

Antes:

```dart
pageView.controller.page
```

Depois:

```dart
pageView.controller!.page
```

## Cronologia

Incluído na versão: 3.19.0-12.0.pre<br>
Na versão estável: 3.22.0

## Referências

Issues relevantes:

* [PageView usa controller global, que nunca é descartado. (Issue 141119)][]

[PageView usa controller global, que nunca é descartado. (Issue 141119)]: {{site.repo.flutter}}/issues/141119
