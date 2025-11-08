---
title: Normalização de temas de componentes
description: >-
  `CardTheme`, `DialogTheme` e `TabBarTheme` foram normalizados para seguir
  a convenção do Flutter para temas de componentes na biblioteca Material.
ia-translate: true
---

## Resumo

`CardTheme`, `DialogTheme` e `TabBarTheme` foram refatorados para
estar em conformidade com as convenções do Flutter para temas de componentes.
`CardThemeData`, `DialogThemeData` e `TabBarThemeData` foram adicionados para
definir substituições para os padrões das propriedades visuais do componente.
Versões do Flutter continuam a normalizar temas de componentes como estes para
uma experiência de tematização mais consistente na biblioteca material.

## Guia de migração

Em `ThemeData`:

- O tipo da propriedade `cardTheme` foi
  alterado de `CardTheme` para `CardThemeData`.
- O tipo da propriedade `dialogTheme` foi
  alterado de `DialogTheme` para `DialogThemeData`.
- O tipo da propriedade `tabBarTheme` foi
  alterado de `TabBarTheme` para `TabBarThemeData`.

O tipo de retorno dos métodos `xTheme.of()` de tema de componente e
`Theme.of().xTheme` também foram alterados para `xThemeData` de acordo.

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

* [Normalize ThemeData.cardTheme][]
* [Normalize ThemeData.dialogTheme][]
* [Normalize ThemeData.tabBarTheme][]

[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`CardTheme`]: {{site.api}}/flutter/material/CardTheme-class.html
[`DialogTheme`]: {{site.api}}/flutter/material/DialogTheme-class.html
[`TabBarTheme`]: {{site.api}}/flutter/material/TabBarTheme-class.html
[Normalize ThemeData.cardTheme]: {{site.repo.flutter}}/pull/153254
[Normalize ThemeData.dialogTheme]: {{site.repo.flutter}}/pull/155129
[Normalize ThemeData.tabBarTheme]: {{site.repo.flutter}}/pull/156253
