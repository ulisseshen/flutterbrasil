---
ia-translate: true
title: Atualizações do sistema de tema Material
description: >-
  `CardTheme`, `DialogTheme` e `TabBarTheme` foram normalizados para seguir
  a convenção do Flutter para temas de componentes na biblioteca Material. Em
  `ThemeData`, o tipo dessas propriedades também mudou de acordo.
---

{% render "docs/breaking-changes.md" %}

## Resumo

`CardTheme`, `DialogTheme` e `TabBarTheme` foram refatorados para
se adequarem às convenções do Flutter para temas de componentes. `CardThemeData`,
`DialogThemeData` e `TabBarThemeData` foram adicionados para definir sobrescritas
para os padrões das propriedades visuais do componente.

Durante a normalização do tema de card, o tipo de `ThemeData.cardTheme` foi alterado
para `Object?` para aceitar tanto `CardTheme` quanto `CardThemeData`, a fim de ter
uma transição suave para as mudanças disruptivas. A mesma abordagem foi usada para
`dialogTheme` e `tabBarTheme`.

Para completar a transição e se adequar totalmente à convenção de `ThemeData`, o
tipo de `ThemeData.cardTheme` foi alterado para `CardThemeData?`; o tipo de
`ThemeData.dialogTheme` foi alterado para `DialogThemeData?`; e o tipo de
`ThemeData.tabBarTheme` foi alterado para `TabBarThemeData?`.

## Guia de migração

Anteriormente, o tipo de `ThemeData.cardTheme` era `Object?` para aceitar tanto
`CardTheme` quanto `CardThemeData`. Agora que o tipo foi alterado para
`CardThemeData?`, uma migração é necessária se `ThemeData.cardTheme` for usado.
Da mesma forma, os tipos de `ThemeData.dialogTheme` e `ThemeData.tabBarTheme`
devem ser migrados para `DialogThemeData` e `TabBarThemeData`, respectivamente.

Código antes da migração:

```dart
final ThemeData theme = ThemeData(
    cardTheme: CardTheme(),
    dialogTheme: DialogTheme(),
    tabBarTheme: TabBarTheme(),
);
```

Código após a migração:

```dart
final ThemeData theme = ThemeData(
    cardTheme: CardThemeData(),
    dialogTheme: DialogThemeData(),
    tabBarTheme: TabBarThemeData(),
);
```

## Cronograma

Lançado na versão: 3.31.0-0.0.pre<br>
Na versão estável: 3.32

## Referências

Documentação da API:

* [`ThemeData`][ThemeData]
* [`CardTheme`][CardTheme]
* [`DialogTheme`][DialogTheme]
* [`TabBarTheme`][TabBarTheme]

PRs relevantes:

* [Change cardTheme, dialogTheme, and tabBarTheme type to xxxThemeData][PR 157292]

[PR 157292]: {{site.github}}/flutter/flutter/pull/157292
[ThemeData]: {{site.api}}/flutter/material/ThemeData-class.html
[CardTheme]: {{site.api}}/flutter/material/CardTheme-class.html
[DialogTheme]: {{site.api}}/flutter/material/DialogTheme-class.html
[TabBarTheme]: {{site.api}}/flutter/material/TabBarTheme-class.html
