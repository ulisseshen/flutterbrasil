---
title: Guia de migração para RouteSettings copyWith
description: Remoção de RouteSettings copyWith e como migrar
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O método `RouteSettings.copyWith` foi removido, e apps que o utilizam
precisam usar o construtor para criar uma nova instância de `RouteSettings`
em vez disso.

## Contexto {:#context}

Com a introdução da classe [`Page`][`Page`],
o `RouteSettings.copyWith` não era mais uma API viável.

## Descrição da mudança {:#description-of-change}

`RouteSettings.copyWith` foi removido

## Guia de migração {:#migration-guide}

Código antes da migração:

```dart
RouteSettings newSettings = oldSettings.copyWith(name: 'new name');
```

Código após a migração:

```dart
RouteSettings newSettings = RouteSettings(name: 'new name', arguments: oldSettings.arguments);
```

## Cronograma {:#timeline}

Adicionado na versão: 3.5.0-9.0.pre-137-gc6f6095acd<br>
Na versão estável: 3.7

## Referências {:#references}

PRs relevantes:

* [PR 113860][PR 113860]: Remove RouteSetting.copyWith.

[PR 113860]: {{site.repo.flutter}}/pull/113860
[`Page`]: {{site.api}}/flutter/widgets/Page-class.html
