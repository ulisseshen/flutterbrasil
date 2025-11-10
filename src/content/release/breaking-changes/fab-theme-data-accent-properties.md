---
title: FloatingActionButton e as propriedades de accent do ThemeData
description: >
  Remove o uso não documentado do FloatingActionButton da
  propriedade accentTextTheme do ThemeData, e
  seu uso desnecessário de accentIconTheme.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Removida a dependência do `FloatingActionButton` (FAB) do Flutter nas
propriedades de accent do `ThemeData`.

## Contexto

Isto foi uma pequena parte do projeto [Material Theme System Updates][].

Anteriormente, a propriedade [`accentIconTheme`] do `ThemeData` era usada apenas
pelo [`FloatingActionButton`][] para determinar a cor padrão
do texto ou ícones que apareciam dentro do botão.

O `FloatingActionButton` também usava a
propriedade `ThemeData accentTextTheme`,
no entanto, essa dependência não estava documentada e era desnecessária.

Ambas as dependências eram confusas.
Por exemplo, se alguém configurasse o `accentIconTheme` do `Theme`
para alterar a aparência de todos os floating action buttons,
era difícil saber quais outros componentes seriam afetados,
ou poderiam ser afetados no futuro.

A [Material Design spec][] não inclui mais uma cor "accent".
A [secondary color][] do `ColorScheme` agora é usada no lugar.

Anteriormente, os aplicativos podiam configurar a cor do texto e dos ícones
dentro dos `FloatingActionButtons` com a propriedade `foregroundColor`
do widget, ou com o `foregroundColor` do `FloatingActionButtonTheme`.
Se nenhuma propriedade `foregroundColor` fosse especificada, a cor do
primeiro plano era padronizada para a cor do `accentIconTheme`.

Com essa alteração, o comportamento padrão usa a cor `onSecondary`
do color scheme no lugar.

## Descrição da alteração

Anteriormente, o `accentIconTheme` fornecia um padrão para a
propriedade `foregroundColor` do `FloatingActionButton`:

```dart
    final Color foregroundColor = this.foregroundColor
      ?? floatingActionButtonTheme.foregroundColor
      ?? theme.accentIconTheme.color // To be removed.
      ?? theme.colorScheme.onSecondary;
```

Aplicativos que configuram o `accentIconTheme` do seu tema
para configurar efetivamente o `foregroundColor` de todos
os floating action buttons, podem obter o mesmo efeito
configurando o `foregroundColor` do `floatingActionButtonTheme`
do seu tema.

O `foregroundColor` do `FloatingActionButton` agora é usado
para configurar o `textStyle` do `RawMaterialButton`
criado pelo `FloatingActionButton`. Anteriormente,
este estilo de texto era baseado no estilo do botão de
`ThemeData.accentTextTheme`:

```dart
// theme.accentTextTheme becomes theme.textTheme
final TextStyle textStyle = theme.accentTextTheme.button.copyWith(
  color: foregroundColor,
  letterSpacing: 1.2,
);

```

Exceto no caso em que um aplicativo configurou explicitamente o
`accentTextTheme` para tirar proveito desta dependência não documentada,
este uso de `accentTextTheme` é desnecessário.
Esta alteração substitui este uso de `accentTextTheme` por `textTheme`.

## Guia de migração

Esta alteração ocorreu em duas etapas:

1. Se o foreground de um `FloatingActionButton` for definido
   com uma cor não padrão, um aviso agora é impresso.
2. A dependência de `accentIconTheme` foi removida.
   Se você ainda não o fez, migre seus aplicativos
   conforme o padrão abaixo.

Para configurar o `foregroundColor` do `FloatingActionButton`
para todos os FABs, você pode configurar o
`floatingActionButtonTheme` do tema em vez do `accentIconTheme`.

Código antes da migração:

```dart
MaterialApp(
  theme: ThemeData(
    accentIconTheme: IconThemeData(color: Colors.red),
  ),
)
```

Código após a migração:

```dart
MaterialApp(
  theme: ThemeData(
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.red,
    ),
  ),
)
```

## Linha do tempo

Disponibilizado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [Remove FAB Accent Theme Dependency][]

Documentação da API:

* [`FloatingActionButton`][]
* [`ThemeData`][]
* [`FloatingActionButtonThemeData`][]

PRs relevantes:

* [Step 1 of 2][] Warn about Flutter's
  FloatingActionButton dependency on ThemeData accent properties
* [Step 2 of 2][] Remove Flutter's FloatingActionButton dependency
  on ThemeData accent properties

Outros:

* [Material Theme System Updates][]


[`accentIconTheme`]: {{site.api}}/flutter/material/ThemeData/accentIconTheme.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton/foregroundColor.html
[`FloatingActionButtonThemeData`]: {{site.api}}/flutter/material/FloatingActionButtonThemeData-class.html
[Material Design spec]: {{site.material}}/styles/color
[Material Theme System Updates]: /go/material-theme-system-updates
[Remove FAB Accent Theme Dependency]: /go/remove-fab-accent-theme-dependency
[secondary color]: {{site.material}}/styles/color/the-color-system/color-roles#904230ec-ae73-4f0f-8bff-4024a036ca66
[Step 1 of 2]: {{site.repo.flutter}}/pull/48435
[Step 2 of 2]: {{site.repo.flutter}}/pull/46923
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData/floatingActionButtonTheme.html
