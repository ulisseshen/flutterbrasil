---
ia-translate: true
title: Guia de Migração para RouteSettings copyWith
description: Remoção de RouteSettings copyWith e como migrar
---

## Sumário

O método `RouteSettings.copyWith` foi removido, e aplicativos que o
utilizam precisam usar o construtor para criar uma nova instância de
`RouteSettings`.

## Contexto

Com a introdução da classe [`Page`][], o `RouteSettings.copyWith` não
era mais uma API viável.

## Descrição da Mudança

`RouteSettings.copyWith` foi removido.

## Guia de Migração

Código antes da migração:

```dart
RouteSettings newSettings = oldSettings.copyWith(name: 'new name');
```

Código após a migração:

```dart
RouteSettings newSettings = RouteSettings(name: 'new name', arguments: oldSettings.arguments);
```

## Cronograma

Implementado na versão: 3.5.0-9.0.pre-137-gc6f6095acd<br>
Na versão estável: 3.7

## Referências

PRs relevantes:

* [PR 113860][]: Remove RouteSetting.copyWith.

[PR 113860]: {{site.repo.flutter}}/pull/113860
[`Page`]: {{site.api}}/flutter/widgets/Page-class.html
