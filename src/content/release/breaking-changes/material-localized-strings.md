---
title: Guia de migração para strings localizadas do material
description: >
  As strings localizadas do ReorderableListView são movidas de
  localizações material para localizações widgets.
ia-translate: true
---

## Resumo

As strings localizadas do `ReorderableListView` foram movidas de
localizações material para localizações widgets.
Essas strings foram depreciadas nas localizações material.

## Contexto

[`ReorderableListView`][] usa essas strings para anotar suas ações de semântica.
Para aplicar as mesmas anotações a [`ReorderableList`][]
e [`SliverReorderableList`][], eles precisam
acessar essas strings da biblioteca widgets.

## Descrição da mudança

As strings [`MaterialLocalizations`][] para
`reorderItemToStart`, `reorderItemToEnd`, `reorderItemUp`,
`reorderItemDown`, `reorderItemLeft` e `reorderItemRight` estão depreciadas e
substituídas pelas mesmas strings em [`WidgetsLocalizations`][].

## Guia de migração

Se você usa essas strings em seu código,
pode acessá-las de `WidgetsLocalizations` em vez disso.

Código antes da migração:

```dart
MaterialLocalizations.of(context).reorderItemToStart;
```

Código após a migração:

```dart
WidgetsLocalizations.of(context).reorderItemToStart;
```

Se você sobrescreve `MaterialLocalizations` ou `WidgetsLocalizations`,
certifique-se de remover as traduções da subclasse `MaterialLocalizations`
e movê-las para a subclasse `WidgetsLocalizations`.

Código antes da migração:

```dart
class MaterialLocalizationsMyLanguage extends MaterialLocalizationsEn {
  // ...
  @override
  String get reorderItemRight => 'my translation';
}
```

Código após a migração:

```dart
class MaterialLocalizationsMyLanguage extends MaterialLocalizationsEn {
  // ...
}

class WidgetsLocalizationsMyLanguage extends WidgetsLocalizationsEn {
  // ...
  @override
  String get reorderItemRight => 'my translation';
}
```

## Linha do tempo

Implementado na versão: v3.10.0-2.0.pre<br>
Na versão estável: 3.13.0

## Referências

PR relevante:

* [PR 124711][]: Deprecia string para
  ReorderableList em material_localizations.

[PR 124711]: {{site.repo.flutter}}/pull/124711
[`ReorderableListView`]: {{site.api}}/flutter/material/ReorderableListView-class.html
[`ReorderableList`]: {{site.api}}/flutter/widgets/ReorderableList-class.html
[`SliverReorderableList`]: {{site.api}}/flutter/widgets/SliverReorderableList-class.html
[`MaterialLocalizations`]: {{site.api}}/flutter/material/MaterialLocalizations-class.html
[`WidgetsLocalizations`]: {{site.api}}/flutter/widgets/WidgetsLocalizations-class.html
