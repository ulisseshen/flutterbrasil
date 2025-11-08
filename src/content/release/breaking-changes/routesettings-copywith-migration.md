---
ia-translate: true
title: Guia de migração para copyWith de RouteSettings
description: Remoção de RouteSettings copyWith e como migrar
---

## Resumo

O método `RouteSettings.copyWith` foi removido, e apps que o usam
precisam usar o construtor para criar uma nova instância `RouteSettings`
em vez disso.

## Contexto

Com a introdução da classe [`Page`][],
o `RouteSettings.copyWith` não era mais uma API viável.

## Descrição da mudança

`RouteSettings.copyWith` foi removido

## Guia de migração

Código antes da migração:

```dart
RouteSettings newSettings = oldSettings.copyWith(name: 'new name');
```

Código após a migração:

```dart
RouteSettings newSettings = RouteSettings(name: 'new name', arguments: oldSettings.arguments);
```

## Cronograma

Adicionado na versão: 3.5.0-9.0.pre-137-gc6f6095acd<br>
Na versão stable: 3.7

## Referências

PRs relevantes:

* [PR 113860][]: Removes RouteSetting.copyWith.

[PR 113860]: {{site.repo.flutter}}/pull/113860
[`Page`]: {{site.api}}/flutter/widgets/Page-class.html
