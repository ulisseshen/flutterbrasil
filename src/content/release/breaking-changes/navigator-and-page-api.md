---
ia-translate: true
title: Mudança na API de página do Navigator
description: >-
  Substitua a propriedade 'onPopPage' do Navigator pela propriedade 'onDidRemovePage'.
---

## Resumo

As APIs de página do [`Navigator`][] foram refatoradas para que
possam se integrar com outros mecanismos de pop do Flutter.

## Contexto

A propriedade `onPopPage` foi adicionada para limpar páginas após
uma página estar prestes a ser removida (popped).
Para vetar o pop, você retornaria `false` no callback.
Isso não funcionava bem com outros mecanismos de pop no framework,
como [`PopScope`][] e gestos de voltar do iOS.

Para integrar os mecanismos de pop do framework,
as APIs de página precisavam ser refatoradas.

## Descrição da mudança

A propriedade `onDidRemovePage` substitui a propriedade `onPopPage`.
Você não pode mais vetar um pop na propriedade `onDidRemovePage`.
Em vez disso, você é o único responsável por atualizar as [`pages`][].

O mecanismo de veto agora é gerenciado com as
propriedades `Page.canPop` e `Page.onPopInvoked`.
Elas funcionam de maneira similar a como você usa o widget `PopScope`.

[`pages`]: {{site.api}}/flutter/widgets/Navigator/pages.html

## Guia de migração

Código antes da migração:

```dart
import 'package:flutter/material.dart';

final MaterialPage<void> page1 = MaterialPage<void>(child: Placeholder());
final MaterialPage<void> page2 = MaterialPage<void>(child: Placeholder());
final MaterialPage<void> page3 = MaterialPage<void>(child: Placeholder());

void main() {
  final List<Page<void>> pages = <Page<void>>[page1, page2, page3];
  runApp(
    MaterialApp(
      home: Navigator(
        pages: pages,
        onPopPage: (Route<Object?> route, Object? result) {
          if (route.settings == page2) {
            return false;
          }
          if (route.didPop) {
            pages.remove(route.settings);
            return true;
          }
          return false;
        },
      ),
    ),
  );
}
```

Código após a migração:

```dart
import 'package:flutter/material.dart';

final MaterialPage<void> page1 = MaterialPage<void>(child: Placeholder());
final MaterialPage<void> page2 = MaterialPage<void>(canPop: false, child: Placeholder());
final MaterialPage<void> page3 = MaterialPage<void>(child: Placeholder());

void main() {
  final List<Page<void>> pages = <Page<void>>[page1, page2, page3];
  runApp(
    MaterialApp(
      home: Navigator(
        pages: pages,
        onDidRemovePage: (Page<Object?> page) {
          pages.remove(page);
        },
      ),
    ),
  );
}
```

## Cronograma

Implementado na versão: 3.22.0-32.0.pre<br>
Na versão estável: 3.24.0

## Referências

Documentação da API:

* [`Navigator`][]
* [`PopScope`][]

Issue relevante:

* [Issue 137458][]

PR relevante:

* [Refactors page API][]

[Refactors page API]: {{site.repo.flutter}}/pull/137792
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`PopScope`]: {{site.api}}/flutter/widgets/PopScope-class.html
[Issue 137458]: {{site.repo.flutter}}/issues/137458
