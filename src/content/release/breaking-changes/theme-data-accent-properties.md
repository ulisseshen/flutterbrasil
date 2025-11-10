---
title: As propriedades accent do ThemeData foram descontinuadas
description: >
  As propriedades accentColor, accentColorBrightness, accentIconTheme e
  accentTextTheme do ThemeData foram descontinuadas.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

As propriedades [accentColor][], [accentColorBrightness][], [accentIconTheme][]
e [accentTextTheme][] do ThemeData foram descontinuadas.

A [especificação Material Design][Material Design spec] não especifica ou usa mais uma cor "accent"
para os componentes Material. Os valores padrão para cores de componentes
são derivados do [color scheme][color-scheme-prop] geral do tema.
A [cor secondary][secondary color] do `ColorScheme` é agora normalmente usada em vez de
`accentColor` e a [cor onSecondary][onSecondary color] é usada quando uma cor contrastante
é necessária.

## Contexto

Isso foi uma pequena parte do projeto [Material Theme System Updates][].

A partir do Flutter 1.17, as propriedades accent do ThemeData - accentColor,
accentColorBrightness, accentIconTheme e accentTextTheme - não eram
mais usadas pela biblioteca Material. Elas foram substituídas por
dependências nas propriedades [`colorScheme`][color-scheme-prop] e
[`textTheme`][text-scheme-prop] do tema como parte do objetivo de longo prazo de
fazer as configurações padrão dos componentes material dependerem
quase exclusivamente dessas duas propriedades.

A motivação para essas mudanças é tornar o sistema de temas mais fácil de
entender e usar. As cores padrão para todos os componentes devem ser
definidas pelos próprios componentes e baseadas no color
scheme. Os padrões para tipos de componentes específicos podem ser sobrescritos
com temas específicos de componente como [`FloatingActionButtonThemeData`][] ou
[`CheckBoxTheme`][]. Anteriormente, propriedades como accentColor eram usadas por um
punhado de tipos de componentes e apenas em algumas situações, o que tornava
difícil entender as implicações de sobrescrevê-las.

## Descrição da mudança

As propriedades accentColor, accentColorBrightness, accentIconTheme e
accentTextTheme do ThemeData foram descontinuadas porque a biblioteca
Material não as usa mais.

## Guia de migração

### Tema da aplicação

Valores de [`ThemeData`][] não precisam mais especificar accentColor,
accentColorBrightness, accentIconTheme, ou accentTextTheme.

Para configurar a aparência dos componentes material aproximadamente da
mesma forma que antes, especifique a cor secondary do color scheme
em vez de accentColor.

Código antes da migração:

```dart
MaterialApp(
  theme: ThemeData(accentColor: myColor),
  // ...
);
```

Código após a migração:

```dart
final ThemeData theme = ThemeData();
MaterialApp(
  theme: theme.copyWith(
    colorScheme: theme.colorScheme.copyWith(secondary: myColor),
  ),
  //...
)
```

### `accentColor`

A cor [`ColorScheme`][] mais próxima compatível com versões anteriores é
[`ColorScheme.secondary`][]. Para aderir mais proximamente às diretrizes de Material
Design mais recentes, pode-se substituir por `ColorScheme.primary` em vez disso.
Se uma cor contrastante for necessária, então use [`ColorScheme.onSecondary`][].

Componentes personalizados que costumavam buscar o accentColor do tema, podem buscar
o `ColorScheme.secondary` em vez disso.

Código antes da migração:

```dart
Color myColor = Theme.of(context).accentColor;
```

Código após a migração:

```dart
Color myColor = Theme.of(context).colorScheme.secondary;
```

### `accentColorBrightness`

O método estático [`ThemeData.estimateBrightnessForColor()`][] pode ser usado
para calcular o brilho de qualquer cor.

### `accentTextTheme`

Isso era [`TextStyle`]s brancos para temas escuros, TextStyles
pretos para temas claros. Na maioria dos casos textTheme pode ser usado
em vez disso. Um idioma comum era se referir a um TextStyle do
accentTextTheme, já que a cor do estilo de texto era garantida para contrastar
bem com a cor accent (agora `ColorScheme.secondaryColor`).
Para obter o mesmo resultado agora, especifique a cor do estilo de texto como
`ColorScheme.onSecondary`:

Código antes da migração:

```dart
TextStyle style = Theme.of(context).accentTextTheme.headline1;
```

Código após a migração:

```dart
final ThemeData theme = Theme.of(context);
TextStyle style = theme.textTheme.headline1.copyWith(
  color: theme.colorScheme.onSecondary,
)
```

### `accentIconTheme`

Esta propriedade havia sido usada apenas para configurar a cor de ícones
dentro de um [`FloatingActionButton`][]. Agora é possível configurar a cor do ícone
diretamente ou com o [`FloatingActionButtonThemeData`][]. Veja
[FloatingActionButton e as propriedades accent do ThemeData][FloatingActionButton and ThemeData's accent properties].

## Linha do tempo

Lançado na versão: 2.3.0-0.1.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

* [`ColorScheme`][]
* [`FloatingActionButton`][]
* [`FloatingActionButtonThemeData`][]
* [`TextStyle`][]
* [`TextTheme`][]
* [`Theme`][]
* [`ThemeData`][]

Issues relevantes:

* [Issue #56918][]

PRs relevantes:

* [PR #81336][]

Outros:

* [Material Theme System Updates][]


[accentColor]: {{site.api}}/flutter/material/ThemeData/accentColor.html
[accentColorBrightness]: {{site.api}}/flutter/material/ThemeData/accentColorBrightness.html
[accentIconTheme]: {{site.api}}/flutter/material/ThemeData/accentIconTheme.html
[accentTextTheme]: {{site.api}}/flutter/material/ThemeData/accentTextTheme.html
[`CheckboxTheme`]: {{site.api}}/flutter/material/CheckboxTheme-class.html
[color-scheme-prop]: {{site.api}}/flutter/material/ThemeData/colorScheme.html
[`colorScheme.onSecondary`]: {{site.api}}/flutter/material/ColorScheme/onSecondary.html
[`colorScheme.secondary`]: {{site.api}}/flutter/material/ColorScheme/secondary.html
[`ColorScheme`]: {{site.api}}/flutter/material/ColorScheme-class.html
[Issue #56918]: {{site.repo.flutter}}/issues/56918
[FloatingActionButton and ThemeData's accent properties]: /release/breaking-changes/fab-theme-data-accent-properties
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[`FloatingActionButtonThemeData`]: {{site.api}}/flutter/material/FloatingActionButtonThemeData-class.html
[Material Design spec]: {{site.material}}/styles/color
[Material Theme System Updates]: /go/material-theme-system-updates
[secondary color]: {{site.api}}/flutter/material/ColorScheme/secondary.html
[onSecondary color]: {{site.api}}/flutter/material/ColorScheme/onSecondary.html
[PR #81336]: {{site.repo.flutter}}/pull/81336
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[text-scheme-prop]: {{site.api}}/flutter/material/ThemeData/textTheme.html
[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html
[`Theme`]: {{site.api}}/flutter/material/Theme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`ThemeData.estimateBrightnessForColor()`]: {{site.api}}/flutter/material/ThemeData/estimateBrightnessForColor.html
