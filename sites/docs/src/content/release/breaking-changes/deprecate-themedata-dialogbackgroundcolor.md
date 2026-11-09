---
title: Descontinuar `ThemeData.dialogBackgroundColor` em favor de
  `DialogThemeData.backgroundColor`
description: >-
  O parâmetro `ThemeData.dialogBackgroundColor` foi substituído por
  `DialogThemeData.backgroundColor`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O parâmetro [`ThemeData.dialogBackgroundColor`][`ThemeData.dialogBackgroundColor`] foi descontinuado em favor do
parâmetro [`DialogThemeData.backgroundColor`][`DialogThemeData.backgroundColor`].

## Contexto {:#context}

Os padrões para os widgets [`Dialog`][`Dialog`] e [`AlertDialog`][`AlertDialog`] podem ser
sobrescritos com um tema específico do componente como [`DialogThemeData`][`DialogThemeData`].
Anteriormente, o parâmetro `ThemeData.dialogBackgroundColor` era usado para
sobrescrever a cor de fundo padrão do diálogo,
o que foi tornado redundante por [`DialogThemeData`][`DialogThemeData`].

## Descrição da mudança {:#description-of-change}

O [`ThemeData.dialogBackgroundColor`][`ThemeData.dialogBackgroundColor`] está descontinuado em
favor de um tema específico do componente.
Use [`DialogThemeData`][`DialogThemeData`] para sobrescrever a cor de fundo padrão.

## Guia de migração {:#migration-guide}

Substitua [`ThemeData.dialogBackgroundColor`][`ThemeData.dialogBackgroundColor`] por
[`DialogThemeData.backgroundColor`][`DialogThemeData.backgroundColor`] para sobrescrever a
cor de fundo padrão do diálogo.

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

## Cronograma {:#timeline}

Adicionado na versão: 3.28.0-0.1.pre<br>
Na versão estável: 3.29

## Referências {:#references}

Documentação da API:

- [`ThemeData.dialogBackgroundColor`][`ThemeData.dialogBackgroundColor`]
- [`DialogThemeData.backgroundColor`][`DialogThemeData.backgroundColor`]
- [`DialogThemeData`][`DialogThemeData`]
- [`Dialog`][`Dialog`]
- [`AlertDialog`][`AlertDialog`]

Issues relevantes:

- [Issue #91772][Issue #91772]

PRs relevantes:

- [Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogTheme.backgroundColor`][Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogTheme.backgroundColor`]

[`ThemeData.dialogBackgroundColor`]: {{site.material_ui}}/ThemeData/dialogBackgroundColor.html
[`DialogThemeData.backgroundColor`]: {{site.material_ui}}/DialogThemeData/backgroundColor.html
[`DialogThemeData`]: {{site.material_ui}}/DialogThemeData-class.html
[`Dialog`]: {{site.material_ui}}/Dialog-class.html
[`AlertDialog`]: {{site.material_ui}}/AlertDialog-class.html
[Issue #91772]: {{site.repo.flutter}}/issues/91772
[Deprecate `ThemeData.dialogBackgroundColor` in favor of `DialogTheme.backgroundColor`]: {{site.repo.flutter}}/pull/155072
