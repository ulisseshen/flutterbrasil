---
ia-translate: true
title: Migração do TextSelectionTheme
description: >
  As propriedades padrão para seleção de texto estão migrando para TextSelectionTheme.
---

## Resumo

As propriedades de `ThemeData` que controlavam a aparência do texto selecionado em widgets Material foram movidas para seu próprio `TextSelectionTheme`. Essas propriedades incluem `cursorColor`, `textSelectionColor` e `textSelectionHandleColor`. Os padrões para essas propriedades também foram alterados para corresponder à especificação do Material Design.

## Contexto

Como parte das maiores [Atualizações do Tema Material][], introduzimos um novo [Tema de Seleção de Texto][] usado para especificar as propriedades do texto selecionado nos widgets `TextField` e `SelectableText`. Estes substituem várias propriedades de nível superior de `ThemeData` e atualizam seus valores padrão para corresponder à especificação do Material Design. Este documento descreve como os aplicativos podem migrar para esta nova API.

## Guia de migração

Se você estiver usando as seguintes propriedades de `ThemeData`, precisará atualizá-las para usar as novas propriedades equivalentes em `ThemeData.textSelectionTheme`:

| Antes                                   | Depois                                           |
|-----------------------------------------|--------------------------------------------------|
| `ThemeData.cursorColor`                 | `TextSelectionThemeData.cursorColor`            |
| `ThemeData.textSelectionColor`          | `TextSelectionThemeData.selectionColor`         |
| `ThemeData.textSelectionHandleColor`    | `TextSelectionThemeData.selectionHandleColor`   |

<br/>

**Código antes da migração:**

```dart
ThemeData(
  cursorColor: Colors.red,
  textSelectionColor: Colors.green,
  textSelectionHandleColor: Colors.blue,
)
```

**Código após a migração:**

```dart
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: Colors.red,
    selectionColor: Colors.green,
    selectionHandleColor: Colors.blue,
  )
)
```

**Mudanças padrão**

Se você não estivesse usando essas propriedades explicitamente, mas dependesse das cores padrão anteriores usadas para a seleção de texto, você pode adicionar um novo campo ao seu `ThemeData` para que seu aplicativo volte aos padrões antigos, como mostrado:

```dart
// Padrões antigos para um tema claro
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color.fromRGBO(66, 133, 244, 1.0),
    selectionColor: const Color(0xff90caf9),
    selectionHandleColor: const Color(0xff64b5f6),
  )
)
```

```dart
// Padrões antigos para um tema escuro
ThemeData(
  textSelectionTheme: TextSelectionThemeData(
    cursorColor: const Color.fromRGBO(66, 133, 244, 1.0),
    selectionColor: const Color(0xff64ffda),
    selectionHandleColor: const Color(0xff1de9b6),
  )
)
```

Se você estiver satisfeito com os novos padrões, mas tiver testes de arquivos golden falhando, você pode atualizar seus arquivos golden mestre usando o seguinte comando:

```console
$ flutter test --update-goldens
```

## Linha do tempo

Implementado na versão: 1.23.0-4.0.pre<br>
Na versão estável: 2.0.0

## Referências

Documentação da API:

* [`TextSelectionThemeData`][]
* [`ThemeData`][]

PRs relevantes:

* [PR 62014: Suporte a TextSelectionTheme][]

[Atualizações do Tema Material]: /go/material-theme-system-updates
[PR 62014: Suporte a TextSelectionTheme]: {{site.repo.flutter}}/pull/62014
[Tema de Seleção de Texto]: /go/text-selection-theme
[`TextSelectionThemeData`]: {{site.api}}/flutter/material/TextSelectionThemeData-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
