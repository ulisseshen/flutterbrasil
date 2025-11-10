---
title: Migração de TextSelectionTheme
description: >
  As propriedades padrão para seleção de texto estão migrando para TextSelectionTheme.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

As propriedades `ThemeData` que controlavam a aparência de
texto selecionado em widgets Material foram movidas para
seu próprio `TextSelectionTheme`. Essas propriedades incluem
`cursorColor`, `textSelectionColor`, e
`textSelectionHandleColor`. Os padrões para essas
propriedades também foram alterados para corresponder à
especificação de Material Design.

## Context

Como parte das [Material Theme Updates][] maiores,
introduzimos um novo [Text Selection Theme][]
usado para especificar as propriedades de texto selecionado em
widgets `TextField` e `SelectableText`.
Eles substituem várias propriedades de nível superior de `ThemeData`
e atualizam seus valores padrão para corresponder à
especificação de Material Design. Este documento descreve como
aplicações podem migrar para esta nova API.

## Migration guide

Se você está atualmente usando as seguintes propriedades de
`ThemeData`, você precisa atualizá-las para usar as novas
propriedades equivalentes em `ThemeData.textSelectionTheme`:

| Before                               | After                                         |
|--------------------------------------|-----------------------------------------------|
| `ThemeData.cursorColor`              | `TextSelectionThemeData.cursorColor`          |
| `ThemeData.textSelectionColor`       | `TextSelectionThemeData.selectionColor`       |
| `ThemeData.textSelectionHandleColor` | `TextSelectionThemeData.selectionHandleColor` |

<br/>

**Code before migration:**

```dart
ThemeData(
  cursorColor: Colors.red,
  textSelectionColor: Colors.green,
  textSelectionHandleColor: Colors.blue,
)
```

**Code after migration:**

```dart
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.red,
    selectionColor: Colors.green,
    selectionHandleColor: Colors.blue,
  )
)
```

**Default changes**

Se você não estava usando essas propriedades explicitamente,
mas dependia das cores padrão anteriores usadas
para seleção de texto, você pode adicionar um novo campo ao seu
`ThemeData` para sua aplicação retornar aos padrões antigos
como mostrado:

```dart
// Old defaults for a light theme
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color.fromRGBO(66, 133, 244, 1.0),
    selectionColor: const Color(0xff90caf9),
    selectionHandleColor: const Color(0xff64b5f6),
  )
)
```

```dart
// Old defaults for a dark theme
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color.fromRGBO(66, 133, 244, 1.0),
    selectionColor: const Color(0xff64ffda),
    selectionHandleColor: const Color(0xff1de9b6),
  )
)
```

Se você está bem com os novos padrões,
mas tem testes de golden file falhando, você
pode atualizar seus arquivos golden master usando o
seguinte comando:

```console
$ flutter test --update-goldens
```

## Timeline

Landed in version: 1.23.0-4.0.pre<br>
In stable release: 2.0.0

## References

API documentation:

* [`TextSelectionThemeData`][]
* [`ThemeData`][]

Relevant PRs:

* [PR 62014: TextSelectionTheme support][]

[Material Theme Updates]: /go/material-theme-system-updates
[PR 62014: TextSelectionTheme support]: {{site.repo.flutter}}/pull/62014
[Text Selection Theme]: /go/text-selection-theme
[`TextSelectionThemeData`]: {{site.api}}/flutter/material/TextSelectionThemeData-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
