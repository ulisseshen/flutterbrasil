---
ia-translate: true
title: Tornar PageView.controller nullable
description: >-
  PageView.controller agora é nullable.
---

## Resumo

Se um controller não for fornecido no construtor,
o membro `controller` é `null`. Isso torna
`PageView` e sua propriedade `controller` consistentes com outros widgets.

## Guia de migração

Antes:

```dart
pageView.controller.page
```

Depois:

```dart
pageView.controller!.page
```

## Cronograma

Adicionado na versão: 3.19.0-12.0.pre<br>
Na versão stable: 3.22.0

## Referências

Issues relevantes:

* [PageView uses global controller, that is never disposed. (Issue 141119)][]

[PageView uses global controller, that is never disposed. (Issue 141119)]: {{site.repo.flutter}}/issues/141119
