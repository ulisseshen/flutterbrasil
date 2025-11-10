---
title: Descontinuação do parâmetro color no tema do AppBar
description: >-
  O parâmetro color em AppBarTheme e AppBarThemeData foi
  descontinuado em favor de backgroundColor para melhor consistência da API.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O parâmetro `color` nos construtores de `AppBarTheme` e `AppBarThemeData`
e seus métodos `copyWith` foram descontinuados. Use `backgroundColor`
em vez disso. Esta mudança afeta como os temas do AppBar são configurados e pode
causar avisos de descontinuação no código existente.

## Contexto {:#background}

O sistema de temas do AppBar tinha dois parâmetros que controlavam a mesma
propriedade: `color` e `backgroundColor`. Esta duplicação criava confusão
e inconsistência na API. Para melhorar a clareza e consistência, o
parâmetro `color` foi descontinuado em favor de `backgroundColor`.

A descontinuação afeta as seguintes classes e métodos:

- Construtor `AppBarTheme`
- Método `AppBarTheme.copyWith`
- Construtor `AppBarThemeData`
- Método `AppBarThemeData.copyWith`

Ao usar o parâmetro `color` descontinuado, você verá avisos como:

```txt
'color' is deprecated and shouldn't be used. Use backgroundColor instead.
This feature was deprecated after v3.33.0-0.2.pre.
```

As classes também incluem verificações de asserção para impedir o uso de ambos os parâmetros
simultaneamente:

```txt
The color and backgroundColor parameters mean the same thing. Only specify one.
```

## Guia de migração {:#migration-guide}

Substitua todos os usos do parâmetro `color` por `backgroundColor` nos
construtores de `AppBarTheme` e `AppBarThemeData` e nos métodos `copyWith`.

Código antes da migração:

```dart
// AppBarTheme constructor
AppBarTheme(
  color: Colors.blue,
  elevation: 4.0,
)

// AppBarTheme copyWith
theme.copyWith(
  color: Colors.red,
  elevation: 2.0,
)

// AppBarThemeData constructor
AppBarThemeData(
  color: Colors.green,
  elevation: 4.0,
)

// AppBarThemeData copyWith
themeData.copyWith(
  color: Colors.purple,
  elevation: 2.0,
)
```

Código após a migração:

```dart
// AppBarTheme constructor
AppBarTheme(
  backgroundColor: Colors.blue,
  elevation: 4.0,
)

// AppBarTheme copyWith
theme.copyWith(
  backgroundColor: Colors.red,
  elevation: 2.0,
)

// AppBarThemeData constructor
AppBarThemeData(
  backgroundColor: Colors.green,
  elevation: 4.0,
)

// AppBarThemeData copyWith
themeData.copyWith(
  backgroundColor: Colors.purple,
  elevation: 2.0,
)
```

## Cronograma {:#timeline}

Implementado na versão: 3.33.0-0.2.pre<br>
Na versão estável: 3.35.4

## Referências {:#references}

Documentação da API:

- [`AppBarTheme`](https://main-api.flutterbrasil.dev/flutter/material/AppBarTheme-class.html)
- [`AppBarThemeData`](https://main-api.flutterbrasil.dev/flutter/material/AppBarThemeData-class.html)

PRs relevantes:

- [AppBar theme color parameter deprecation #170624]({{site.github}}/flutter/flutter/pull/170624)
