---
ia-translate: true
title: Normalização do tema de componentes
description: >-
  `CardTheme`, `DialogTheme` e `TabBarTheme` foram normalizados para seguir a
  convenção do Flutter para temas de componentes na biblioteca Material.
---

## Resumo

`CardTheme`, `DialogTheme` e `TabBarTheme` foram refatorados para
conformar com as convenções do Flutter para temas de componentes.
`CardThemeData`, `DialogThemeData` e `TabBarThemeData` foram adicionados para
definir overrides para os valores padrão das propriedades visuais do componente.
Versões futuras continuarão a normalizar temas de componentes como esses para uma
experiência de temas mais consistente na biblioteca Material.

## Guia de migração

Em `ThemeData`, o tipo da propriedade `cardTheme` foi alterado de
`CardTheme` para `CardThemeData`; o tipo da propriedade `dialogTheme` foi
alterado de `DialogTheme` para `DialogThemeData`; o tipo da propriedade
`tabBarTheme` foi alterado de `TabBarTheme` para `TabBarThemeData`.

O tipo de retorno do método `xTheme.of()` do tema do componente e
`Theme.of().xTheme` agora também foi alterado para `xThemeData` de acordo.

Código antes da migração:

```dart
final CardTheme cardTheme = Theme.of(context).cardTheme;
final CardTheme cardTheme = CardTheme.of(context);

final DialogTheme dialogTheme = Theme.of(context).dialogTheme;
final DialogTheme dialogTheme = DialogTheme.of(context);

final TabBarTheme tabBarTheme = Theme.of(context).tabBarTheme;
final TabBarTheme tabBarTheme = TabBarTheme.of(context);
```

Código após a migração:

```dart
final CardThemeData cardTheme = Theme.of(context).cardTheme;
final CardThemeData cardTheme = CardTheme.of(context);

final DialogThemeData dialogTheme = Theme.of(context).dialogTheme;
final DialogThemeData dialogTheme = DialogTheme.of(context);

final TabBarThemeData tabBarTheme = Theme.of(context).tabBarTheme;
final TabBarThemeData tabBarTheme = TabBarTheme.of(context);
```

## Linha do tempo

Implementado na versão: 3.27.0-0.0.pre<br>
Versão estável: 3.27

## Referências

Documentação da API:

* [`ThemeData`][]
* [`CardTheme`][]
* [`DialogTheme`][]
* [`TabBarTheme`][]

PRs relevantes:

* [Normalizar ThemeData.cardTheme][]
* [Normalizar ThemeData.dialogTheme][]
* [Normalizar ThemeData.tabBarTheme][]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`CardTheme`]: {{site.api}}/flutter/material/CardTheme-class.html
[`DialogTheme`]: {{site.api}}/flutter/material/DialogTheme-class.html
[`TabBarTheme`]: {{site.api}}/flutter/material/TabBarTheme-class.html
[Normalizar ThemeData.cardTheme]: {{site.repo.flutter}}/pull/153254
[Normalizar ThemeData.dialogTheme]: {{site.repo.flutter}}/pull/155129
[Normalizar ThemeData.tabBarTheme]: {{site.repo.flutter}}/pull/156253

