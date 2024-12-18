---
ia-translate: true
title: Descontinuar `ButtonBar` em favor de `OverflowBar`
description: >-
  O widget ButtonBar foi substituído por um widget mais eficiente, OverflowBar.
---

## Sumário

O widget `ButtonBar` foi descontinuado em favor do widget `OverflowBar`,
que é mais eficiente. Como resultado, `ThemeData.buttonBarTheme` e
`ButtonBarTheme` também foram descontinuados.

## Contexto

O widget `ButtonBar` organiza seus filhos em uma linha e
em uma coluna se não houver espaço horizontal suficiente.
O widget `OverflowBar` faz o mesmo, mas não está
vinculado à biblioteca Material e faz parte da biblioteca principal `widgets.dart`.

## Descrição da mudança

- Substitua o widget `ButtonBar` pelo widget `OverflowBar`.
- Por padrão, `ButtonBar` alinha seus filhos ao final do layout, enquanto
  `OverflowBar` alinha seus filhos ao início.
  Para alinhar os filhos de `OverflowBar` ao final, defina
  a propriedade `OverflowBar.alignment` para `MainAxisAlignment.end`.
- `ButtonBar.buttonPadding` fornece espaçamento
  entre os botões e preenchimento em volta dos botões.
  Substitua-o por `OverflowBar.spacing`, que fornece espaçamento entre os botões.
  Envolva o widget `OverflowBar` com o widget `Padding` para
  fornecer preenchimento em volta dos botões.
- Substitua `ButtonBar.overflowButtonSpacing` por `OverflowBar.overflowSpacing`,
  que fornece espaçamento entre os botões quando os botões são dispostos em uma
  coluna quando não há espaço horizontal suficiente.
- Se especificado, remova `ButtonBarThemeData` de `ThemeData`.

## Guia de migração

Substitua `ButtonBar` por `OverflowBar`, sobrescreva o alinhamento padrão se
necessário, substitua `ButtonBar.buttonPadding` pelo widget `Padding` e
`OverflowBar.spacing` para espaçamento entre e em volta dos botões, e substitua
`ButtonBar.overflowButtonSpacing` por `OverflowBar.overflowSpacing` para
espaçamento entre os botões quando os botões são dispostos em uma coluna quando não há
espaço horizontal suficiente.

Antes:

```dart
ButtonBar(
  buttonPadding: const EdgeInsets.all(8.0),
  overflowButtonSpacing: 8.0,
  children: <Widget>[
    TextButton(child: const Text('Botão 1'), onPressed: () {}),
    TextButton(child: const Text('Botão 2'), onPressed: () {}),
    TextButton(child: const Text('Botão 3'), onPressed: () {}),
  ],
),
```

Depois:

```dart
Padding(
  padding: const EdgeInsets.all(8.0),
  child: OverflowBar(
    alignment: MainAxisAlignment.end,
    spacing: 8.0,
    overflowSpacing: 8.0,
    children: <Widget>[
      TextButton(child: const Text('Botão 1'), onPressed: () {}),
      TextButton(child: const Text('Botão 2'), onPressed: () {}),
      TextButton(child: const Text('Botão 3'), onPressed: () {}),
    ],
  ),
),
```

Se você especificar um `ThemeData.buttonBarTheme`, remova-o e
use as propriedades do widget `OverflowBar` para personalizar o widget `OverflowBar`.

Antes:

```dart
ThemeData(
  buttonBarTheme: ButtonBarThemeData(
    alignment: MainAxisAlignment.center,
  ),
),
```

Depois:

```dart
ThemeData(
  // ...
),
```

Se você usar o widget `ButtonBarTheme`, remova-o e
use as propriedades do widget `OverflowBar` para personalizar o widget `OverflowBar`.

Antes:

```dart
ButtonBarTheme(
  data: ButtonBarThemeData(
    alignment: MainAxisAlignment.center,
  ),
  child: ButtonBar(
    children: <Widget>[
      // ...
    ],
  ),
),
```

Depois:

```dart
OverflowBar(
  alignment: MainAxisAlignment.center,
  children: <Widget>[
    // ...
  ],
),
```

## Linha do tempo

Implementado na versão: 3.22.0-2.0.pre<br>
Na versão estável: 3.24.0

## Referências

Documentação da API:

- [`OverflowBar`][]
- [`ButtonBar`][]

Issues relevantes:

- [Issue #127955][]

PRs relevantes:

- [Descontinuar `ButtonBar`, `ButtonBarThemeData` e `ThemeData.buttonBarTheme`][]

[`OverflowBar`]: {{site.api}}/flutter/widgets/OverflowBar-class.html
[`ButtonBar`]: {{site.api}}/flutter/material/ButtonBar-class.html
[Issue #127955]: {{site.repo.flutter}}/issues/127955
[Descontinuar `ButtonBar`, `ButtonBarThemeData` e `ThemeData.buttonBarTheme`]: {{site.repo.flutter}}/pull/145523
