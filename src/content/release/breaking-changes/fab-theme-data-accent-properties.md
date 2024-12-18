---
ia-translate: true
title: FloatingActionButton e propriedades de accent do ThemeData
description: >
  Remove o uso não documentado do FloatingActionButton da
  propriedade accentTextTheme do ThemeData e seu uso
  desnecessário de accentIconTheme.
---

## Resumo

Removida a dependência do `FloatingActionButton` (FAB) do Flutter
das propriedades `accent` do `ThemeData`.

## Contexto

Esta foi uma pequena parte do projeto [Atualizações do Sistema de Temas Material][].

Anteriormente, a propriedade `accentIconTheme` do `ThemeData`
era usada apenas pelo [`FloatingActionButton`][] para determinar a cor
padrão do texto ou ícones que apareciam dentro do botão.

O `FloatingActionButton` também usava a propriedade
`accentTextTheme` do `ThemeData`, no entanto, essa dependência
não era documentada e desnecessária.

Ambas as dependências eram confusas. Por exemplo, se alguém
configurasse o `accentIconTheme` do `Theme` para alterar a
aparência de todos os botões de ação flutuantes, era difícil saber
quais outros componentes seriam afetados, ou poderiam ser
afetados no futuro.

A [especificação do Material Design][] não inclui mais uma cor
"accent". A [cor secundária][] do `ColorScheme` é usada agora.

Anteriormente, os aplicativos podiam configurar a cor do texto e
dos ícones dentro dos `FloatingActionButtons` com a propriedade
`foregroundColor` do widget ou com o `foregroundColor` do
`FloatingActionButtonTheme`. Se nenhuma propriedade
`foregroundColor` fosse especificada, a cor de primeiro plano
assumia como padrão a cor do `accentIconTheme`.

Com essa alteração, o comportamento padrão usa a cor `onSecondary`
do esquema de cores.

## Descrição da alteração

Anteriormente, o `accentIconTheme` fornecia um valor padrão para
a propriedade `foregroundColor` do `FloatingActionButton`:

```dart
    final Color foregroundColor = this.foregroundColor
      ?? floatingActionButtonTheme.foregroundColor
      ?? theme.accentIconTheme.color // A ser removido.
      ?? theme.colorScheme.onSecondary;
```

Aplicativos que configuram o `accentIconTheme` do seu tema para
configurar efetivamente o `foregroundColor` de todos os botões de
ação flutuantes, podem obter o mesmo efeito configurando o
`foregroundColor` do `floatingActionButtonTheme` do seu tema.

O `foregroundColor` do `FloatingActionButton` agora é usado para
configurar o `textStyle` do `RawMaterialButton` criado pelo
`FloatingActionButton`. Anteriormente, esse estilo de texto era
baseado no estilo do botão do `ThemeData.accentTextTheme`:

```dart
// theme.accentTextTheme torna-se theme.textTheme
final TextStyle textStyle = theme.accentTextTheme.button.copyWith(
  color: foregroundColor,
  letterSpacing: 1.2,
);

```

Exceto em um caso em que um aplicativo tenha configurado
explicitamente o `accentTextTheme` para tirar proveito dessa
dependência não documentada, esse uso do `accentTextTheme` é
desnecessário. Essa alteração substitui esse uso do
`accentTextTheme` por `textTheme`.

## Guia de migração

Essa alteração ocorreu em duas etapas:

1. Se o primeiro plano de um `FloatingActionButton` for definido
   para uma cor não padrão, um aviso será impresso agora.
2. A dependência do `accentIconTheme` foi removida. Se você
   ainda não o fez, migre seus aplicativos de acordo com o
   padrão abaixo.

Para configurar o `foregroundColor` do `FloatingActionButton`
para todos os FABs, você pode configurar o
`floatingActionButtonTheme` do tema em vez de seu `accentIconTheme`.

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

Incluído na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documento de design:

* [Remover Dependência do Tema Accent do FAB][]

Documentação da API:

* [`FloatingActionButton`][]
* [`ThemeData`][]
* [`FloatingActionButtonThemeData`][]

PRs relevantes:

* [Etapa 1 de 2][] Avisar sobre a dependência do FloatingActionButton
  do Flutter nas propriedades accent do ThemeData
* [Etapa 2 de 2][] Remover a dependência do FloatingActionButton do
  Flutter nas propriedades accent do ThemeData

Outro:

* [Atualizações do Sistema de Temas Material][]

[`accentIconTheme`]: {{site.api}}/flutter/material/ThemeData/accentIconTheme.html
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton/foregroundColor.html
[`FloatingActionButtonThemeData`]: {{site.api}}/flutter/material/FloatingActionButtonThemeData-class.html
[Material Design spec]: {{site.material}}/styles/color
[Atualizações do Sistema de Temas Material]: /go/material-theme-system-updates
[Remover Dependência do Tema Accent do FAB]: /go/remove-fab-accent-theme-dependency
[cor secundária]: {{site.material}}/styles/color/the-color-system/color-roles#904230ec-ae73-4f0f-8bff-4024a036ca66
[Etapa 1 de 2]: {{site.repo.flutter}}/pull/48435
[Etapa 2 de 2]: {{site.repo.flutter}}/pull/46923
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData/floatingActionButtonTheme.html
