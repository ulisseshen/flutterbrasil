---
title: Guia de migração para strings localizadas do Material
description: >
  As strings localizadas do ReorderableListView foram movidas das
  localizações do material para as localizações de widgets.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

As strings localizadas do `ReorderableListView` foram movidas das
localizações do material para as localizações de widgets.
Essas strings foram obsoletas nas localizações do material.

## Contexto {:#context}

[`ReorderableListView`][] usa essas strings para anotar suas ações de
semântica. Para aplicar as mesmas anotações ao
[`ReorderableList`][] e ao [`SliverReorderableList`][], eles precisam
acessar essas strings a partir da biblioteca de widgets.

## Descrição da mudança {:#description-of-the-change}

As strings de [`MaterialLocalizations`][] `reorderItemToStart`,
`reorderItemToEnd`, `reorderItemUp`, `reorderItemDown`, `reorderItemLeft` e
`reorderItemRight` estão obsoletas e foram substituídas pelas mesmas strings em
[`WidgetsLocalizations`][].

## Guia de migração {:#migration-guide}

Se você usa essas strings no seu código,
pode acessá-las a partir de `WidgetsLocalizations`.

Código antes da migração:

```dart
MaterialLocalizations.of(context).reorderItemToStart;
```

Código após a migração:

```dart
WidgetsLocalizations.of(context).reorderItemToStart;
```

Se você sobrescreve `MaterialLocalizations` ou `WidgetsLocalizations`,
remova as traduções da subclasse de `MaterialLocalizations`
e mova-as para a subclasse de `WidgetsLocalizations`.

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

## Linha do tempo {:#timeline}

Incluído na versão: v3.10.0-2.0.pre<br>
Na versão estável: 3.13.0

## Referências {:#references}

PR relevante:

* [PR 124711][]: obsoleta a string para
  ReorderableList em material_localizations.

[PR 124711]: {{site.repo.flutter}}/pull/124711
[`ReorderableListView`]: {{site.material_ui}}/ReorderableListView-class.html
[`ReorderableList`]: {{site.api}}/flutter/widgets/ReorderableList-class.html
[`SliverReorderableList`]: {{site.api}}/flutter/widgets/SliverReorderableList-class.html
[`MaterialLocalizations`]: {{site.material_ui}}/MaterialLocalizations-class.html
[`WidgetsLocalizations`]: {{site.api}}/flutter/widgets/WidgetsLocalizations-class.html
