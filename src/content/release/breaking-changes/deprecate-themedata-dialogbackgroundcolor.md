---
ia-translate: true
title: Deprecar `ThemeData.dialogBackgroundColor` em favor de
  `DialogThemeData.backgroundColor`
description: >-
  O parâmetro `ThemeData.dialogBackgroundColor` foi substituído por
  `DialogThemeData.backgroundColor`.
---

## Sumário

O parâmetro [`ThemeData.dialogBackgroundColor`][] foi depreciado em favor do
parâmetro [`DialogThemeData.backgroundColor`][].

## Contexto

Os padrões para os widgets [`Dialog`][] e [`AlertDialog`][] podem ser
sobrescritos com um tema específico do componente como [`DialogThemeData`][].
Anteriormente, o parâmetro `ThemeData.dialogBackgroundColor` era usado para
sobrescrever a cor de fundo padrão do diálogo, o que foi tornado redundante por
[`DialogThemeData`][].

## Descrição da mudança

O [`ThemeData.dialogBackgroundColor`][] foi depreciado em favor de um tema
específico de componente. Use [`DialogThemeData`][] para sobrescrever a cor de
fundo padrão.

## Guia de migração

Substitua [`ThemeData.dialogBackgroundColor`][] por
[`DialogThemeData.backgroundColor`][] para sobrescrever a cor de fundo padrão
do diálogo.

Código antes da migração:

```dart
theme: ThemeData(
  dialogBackgroundColor: Colors.orange,
),
```

Código após a migração:

```dart
theme: ThemeData(
  dialogTheme: const DialogThemeData(backgroundColor: Colors.orange),
),
```

## Cronologia

Implementado na versão: v3.27.0-0.1.pre<br>
Na versão estável: A ser definido

## Referências

Documentação da API:

- [`ThemeData.dialogBackgroundColor`][]
- [`DialogThemeData.backgroundColor`][]
- [`DialogThemeData`][]
- [`Dialog`][]
- [`AlertDialog`][]

Issues relevantes:

- [Issue #91772][]

PRs relevantes:

- [Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogTheme.backgroundColor`][]

[`ThemeData.dialogBackgroundColor`]: {{site.api}}/flutter/material/ThemeData/dialogBackgroundColor.html
[`DialogThemeData.backgroundColor`]: {{site.api}}/flutter/material/DialogThemeData/backgroundColor.html
[`DialogThemeData`]: {{site.api}}/flutter/material/DialogThemeData-class.html
[`Dialog`]: {{site.api}}/flutter/material/Dialog-class.html
[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[Issue #91772]: {{site.repo.flutter}}/issues/91772
[Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogTheme.backgroundColor`]: {{site.repo.flutter}}/pull/155072
