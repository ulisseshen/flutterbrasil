---
ia-translate: true
title: Deprecação do callback onReorder
description: >-
  O callback onReorder foi descontinuado
  em favor de um novo callback, chamado onReorderItem.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O callback `onReorder` nos widgets
`ReorderableListView`, `ReorderableListView.builder`,
`ReorderableList` e `SliverReorderableList`
foi substituído por um novo callback, `onReorderItem`,
que oferece um comportamento mais intuitivo para `newIndex`.

## Contexto {:#background}

O callback `onReorder` nos widgets
`ReorderableListView`, `ReorderableListView.builder`,
`ReorderableList` e `SliverReorderableList` exigia
uma correção manual do segundo parâmetro, `newIndex`,
quando `oldIndex` está antes de `newIndex`, porque
a lista de itens fica uma posição menor.

```dart
void handleReorder(int oldIndex, int newIndex) {
  if (oldIndex < newIndex) {
    // Removing the item at oldIndex shortens the list by 1.
    newIndex -= 1;
  }

  // Handle the actual reorder behavior...
}

ReorderableListView(
  onReorder: handleReorder,
)
```

O novo callback, `onReorderItem`, resolve esse problema
fazendo a correção automaticamente.

```dart
void handleReorder(int oldIndex, int newIndex) {
  // Handle the actual reorder behavior...
}

ReorderableListView(
  onReorderItem: handleReorder,
)
```

## Guia de migração {:#migration-guide}

Os widgets `ReorderableListView`, `ReorderableListView.builder`,
`ReorderableList` e `SliverReorderableList`
compartilham a mesma lógica de reordenação.
Os mesmos passos de migração se aplicam a cada um desses widgets.

Este guia de migração usa `ReorderableListView` como exemplo.

### Caso 1: callbacks simples {: #case-1-simple-callbacks }

Código antes da migração:

```dart
ReorderableListView(
  onReorder: (int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    // Handle reorder ...
  }
)
```

Código após a migração:

```dart diff
  ReorderableListView(
-   onReorder: (int oldIndex, int newIndex) {
-     if (oldIndex < newIndex) {
-       newIndex -= 1;
-     }
-
+   onReorderItem: (int oldIndex, int newIndex) {
      // Handle reorder ...
    }
  )
```

### Caso 2: optar por não migrar em implementações complexas de `onReorder` {: #case-2-opt-out }

Em alguns casos, como quando o callback fornecido é complexo,
a migração para o novo callback `onReorderItem` pode não ser óbvia.

Nesses casos, para optar por não usar o novo comportamento,
ajuste o `newIndex` para corresponder ao comportamento antigo.

Código antes da migração:

```dart
void handleSomeComplexReorder(int oldIndex, int newIndex) {
  // Handle reorder ...
}

ReorderableListView(
  onReorder: (int oldIndex, int newIndex) {
    handleSomeComplexReorder(oldIndex, newIndex);
  }
)
```

Código após a migração:

```dart diff
  void handleSomeComplexReorder(int oldIndex, int newIndex) {
    // Handle reorder ...
  }

  ReorderableListView(
-   onReorder: (int oldIndex, int newIndex) {
+   onReorderItem: (int oldIndex, int newIndex) {
+     // To get the equivalent of the old newIndex:
+     if (oldIndex < newIndex) {
+       newIndex += 1;
+     }
+
      return handleSomeComplexReorder(oldIndex, newIndex);
    }
  )
```

:::important
Esta migração não é suportada pelo `dart fix`,
devido à mudança de significado do segundo parâmetro do callback.
:::

## Linha do tempo {:#timeline}

Incluído na versão: 3.41.0-1.0.pre-364<br>
Na versão estável: 3.44

## Referências {:#references}

Documentação da API:

* [`ReorderCallback`][]
* [`ReorderableList`][]
* [`ReorderableListView`][]
* [`SliverReorderableList`][]

Issues relevantes:

* [The index parameter for ReorderableListView's onReorderCallback is confusing][issue-127901]
* [SliverReorderableList newIndex arg off by one on drag down list][issue-169878]

PRs relevantes:

* [Deprecação do callback onReorder][Deprecate onReorder callback]

[`ReorderCallback`]: {{site.api}}/flutter/widgets/ReorderCallback.html
[`ReorderableList`]: {{site.api}}/flutter/widgets/ReorderableList-class.html
[`ReorderableListView`]: {{site.material_ui}}/ReorderableListView-class.html
[`SliverReorderableList`]: {{site.api}}/flutter/widgets/SliverReorderableList-class.html

[issue-127901]: {{site.repo.flutter}}/issues/127901
[issue-169878]: {{site.repo.flutter}}/issues/169878
[Deprecate onReorder callback]: {{site.repo.flutter}}/pull/178242
