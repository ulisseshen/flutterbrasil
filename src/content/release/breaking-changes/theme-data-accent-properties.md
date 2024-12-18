---
ia-translate: true
title: Propriedades de acento do ThemeData foram descontinuadas
description: >
  As propriedades accentColor, accentColorBrightness, accentIconTheme e
  accentTextTheme do ThemeData foram descontinuadas.
---

## Resumo

As propriedades [accentColor][], [accentColorBrightness][],
[accentIconTheme][] e [accentTextTheme][] do ThemeData foram
descontinuadas.

A [especificação do Material Design][] não especifica ou usa mais uma
cor de "acento" para os componentes do Material. Os valores padrão
para as cores dos componentes são derivados do [esquema de cores][]
geral do tema. A [cor secundária][] do `ColorScheme` agora é
normalmente usada em vez de `accentColor` e a [cor onSecondary][] é
usada quando uma cor contrastante é necessária.

## Contexto

Esta foi uma pequena parte do projeto [Atualizações do Sistema de Temas
Material][].

A partir do Flutter 1.17, as propriedades de acento do ThemeData -
accentColor, accentColorBrightness, accentIconTheme e accentTextTheme
- não eram mais usadas pela biblioteca Material. Elas foram
substituídas por dependências das propriedades [`colorScheme`][] e
[`textTheme`][] do tema, como parte da meta de longo prazo de fazer
com que as configurações padrão dos componentes Material dependam
quase exclusivamente dessas duas propriedades.

A motivação para essas mudanças é tornar o sistema de temas mais fácil
de entender e usar. As cores padrão para todos os componentes devem
ser definidas pelos próprios componentes e com base no esquema de
cores. Os padrões para tipos de componentes específicos podem ser
substituídos com temas específicos de componentes, como
[`FloatingActionButtonThemeData`][] ou [`CheckBoxTheme`][].
Anteriormente, propriedades como accentColor eram usadas por alguns
tipos de componentes e apenas em algumas situações, o que dificultava
a compreensão das implicações de substituí-las.

## Descrição da mudança

As propriedades accentColor, accentColorBrightness, accentIconTheme e
accentTextTheme do ThemeData foram descontinuadas porque a biblioteca
Material não as usa mais.

## Guia de migração

### Tema do aplicativo

Os valores de [`ThemeData`][] não precisam mais especificar
accentColor, accentColorBrightness, accentIconTheme ou accentTextTheme.

Para configurar a aparência dos componentes Material da mesma forma
que antes, especifique a cor secundária do esquema de cores em vez
de accentColor.

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

A cor [`ColorScheme`][] mais compatível com versões anteriores é
[`ColorScheme.secondary`][]. Para seguir mais de perto as diretrizes
mais recentes do Material Design, pode-se substituir
`ColorScheme.primary`. Se uma cor contrastante for necessária, use
[`ColorScheme.onSecondary`][].

Componentes personalizados que costumavam procurar a accentColor do
tema podem procurar o `ColorScheme.secondary` em vez disso.

Código antes da migração:

```dart
Color myColor = Theme.of(context).accentColor;
```

Código após a migração:

```dart
Color myColor = Theme.of(context).colorScheme.secondary;
```

### `accentColorBrightness`

O método estático [`ThemeData.estimateBrightnessForColor()`][] pode
ser usado para calcular o brilho de qualquer cor.

### `accentTextTheme`

Este era [`TextStyle`] branco para temas escuros, `TextStyles`
pretos para temas claros. Na maioria dos casos, textTheme pode ser
usado em vez disso. Um idioma comum era referir-se a um TextStyle de
accentTextTheme, já que a cor do estilo de texto tinha garantia de
contrastar bem com a cor de acento (agora `ColorScheme.secondaryColor`).
Para obter o mesmo resultado agora, especifique a cor do estilo de
texto como `ColorScheme.onSecondary`:

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

Esta propriedade só era usada para configurar a cor dos ícones em
um [`FloatingActionButton`][]. Agora é possível configurar a cor do
ícone diretamente ou com o [`FloatingActionButtonThemeData`][]. Veja
[FloatingActionButton e propriedades de acento do ThemeData][].

## Linha do tempo

Implementado na versão: 2.3.0-0.1.pre<br>
Na versão estável: 2.5

## Referências

Documentação da API:

*   [`ColorScheme`][]
*   [`FloatingActionButton`][]
*   [`FloatingActionButtonThemeData`][]
*   [`TextStyle`][]
*   [`TextTheme`][]
*   [`Theme`][]
*   [`ThemeData`][]

Problemas relevantes:

*   [Issue #56918][]

PRs relevantes:

*   [PR #81336][]

Outros:

*   [Atualizações do Sistema de Temas Material][]

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
[FloatingActionButton e propriedades de acento do ThemeData]: /release/breaking-changes/fab-theme-data-accent-properties
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[`FloatingActionButtonThemeData`]: {{site.api}}/flutter/material/FloatingActionButtonThemeData-class.html
[Material Design spec]: {{site.material}}/styles/color
[Atualizações do Sistema de Temas Material]: /go/material-theme-system-updates
[cor secundária]: {{site.api}}/flutter/material/ColorScheme/secondary.html
[cor onSecondary]: {{site.api}}/flutter/material/ColorScheme/onSecondary.html
[PR #81336]: {{site.repo.flutter}}/pull/81336
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[text-scheme-prop]: {{site.api}}/flutter/material/ThemeData/textTheme.html
[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html
[`Theme`]: {{site.api}}/flutter/material/Theme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`ThemeData.estimateBrightnessForColor()`]: {{site.api}}/flutter/material/ThemeData/estimateBrightnessForColor.html
