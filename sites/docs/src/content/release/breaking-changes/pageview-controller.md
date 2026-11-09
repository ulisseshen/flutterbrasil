---
title: Tornar PageView.controller anulável
description: >-
  PageView.controller agora é anulável.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Se um controller não for fornecido no construtor,
o membro `controller` é `null`. Isso torna
o `PageView` e sua propriedade `controller` consistentes com outros widgets.

## Guia de migração {:#migration-guide}

Antes:

```dart
pageView.controller.page
```

Depois:

```dart
pageView.controller!.page
```

## Cronograma {:#timeline}

Aplicado na versão: 3.19.0-12.0.pre<br>
Em versão estável: 3.22.0

## Referências {:#references}

Issues relevantes:

* [PageView uses global controller, that is never disposed. (Issue 141119)][]

[PageView uses global controller, that is never disposed. (Issue 141119)]: {{site.repo.flutter}}/issues/141119
