---
title: API descontinuada removida após v2.2
description: >
  Após atingir o fim da vida útil, as seguintes APIs descontinuadas
  foram removidas do Flutter.
ia-translate: true
---

## Resumo {:#summary}

De acordo com a [Política de descontinuação do Flutter][Deprecation Policy],
APIs descontinuadas que atingiram o fim da vida útil após a versão
estável 2.2 foram removidas.

Todas as APIs afetadas foram reunidas nesta fonte principal para auxiliar
na migração. Também está disponível uma
[folha de referência rápida][quick reference sheet].

[Deprecation Policy]: {{site.repo.flutter}}/blob/main/docs/contributing/Tree-hygiene.md#deprecations
[quick reference sheet]: /go/deprecations-removed-after-2-2

## Mudanças {:#changes}

Esta seção lista as descontinuações, agrupadas pela classe afetada.

### `hasFloatingPlaceholder` de `InputDecoration` e `InputDecorationTheme` {:#hasfloatingplaceholder-of-inputdecoration-inputdecorationtheme}

Suportado pelo Flutter Fix: sim

`hasFloatingPlaceholder` foi descontinuado na v1.13.2.
Use `floatingLabelBehavior` no lugar.
Onde `useFloatingPlaceholder` era `true`, substitua por `FloatingLabelBehavior.auto`.
Onde `useFloatingPlaceholder` era `false`, substitua por `FloatingLabelBehavior.never`.
Essa mudança permite especificar mais comportamentos além da escolha binária
original, com a adição de `FloatingLabelBehavior.always` como opção extra.

**Guia de migração**

Código antes da migração:

```dart
// InputDecoration
// Base constructor
InputDecoration(hasFloatingPlaceholder: true);
InputDecoration(hasFloatingPlaceholder: false);

// collapsed constructor
InputDecoration.collapsed(hasFloatingPlaceholder: true);
InputDecoration.collapsed(hasFloatingPlaceholder: false);

// Field access
inputDecoration.hasFloatingPlaceholder;

// InputDecorationTheme
// Base constructor
InputDecorationTheme(hasFloatingPlaceholder: true);
InputDecorationTheme(hasFloatingPlaceholder: false);

// Field access
inputDecorationTheme.hasFloatingPlaceholder;

// copyWith
inputDecorationTheme.copyWith(hasFloatingPlaceholder: false);
inputDecorationTheme.copyWith(hasFloatingPlaceholder: true);
```

Código depois da migração:

```dart
// InputDecoration
// Base constructor
InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.auto);
InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never);

// collapsed constructor
InputDecoration.collapsed(floatingLabelBehavior: FloatingLabelBehavior.auto);
InputDecoration.collapsed(floatingLabelBehavior: FloatingLabelBehavior.never);

// Field access
inputDecoration.floatingLabelBehavior;

// InputDecorationTheme
// Base constructor
InputDecorationTheme(floatingLabelBehavior: FloatingLabelBehavior.auto);
InputDecorationTheme(floatingLabelBehavior: FloatingLabelBehavior.never);

// Field access
inputDecorationTheme.floatingLabelBehavior;

// copyWith
inputDecorationTheme.copyWith(floatingLabelBehavior: FloatingLabelBehavior.never);
inputDecorationTheme.copyWith(floatingLabelBehavior: FloatingLabelBehavior.auto);
```

**Referências**

Documentação da API:

* [`InputDecoration`][`InputDecoration`]
* [`InputDecorationTheme`][`InputDecorationTheme`]
* [`FloatingLabelBehavior`][`FloatingLabelBehavior`]

Issues relevantes:

* [InputDecoration: opção para sempre flutuar o label][InputDecoration: option to always float label]

PRs relevantes:

* Descontinuado em [#46115][]
* Removido em [#83923][]

[`InputDecoration`]: {{site.material_ui}}/InputDecoration-class.html
[`InputDecorationTheme`]: {{site.material_ui}}/InputDecorationTheme-class.html
[`FloatingLabelBehavior`]: {{site.material_ui}}/FloatingLabelBehavior-class.html
[InputDecoration: option to always float label]: {{site.repo.flutter}}/issues/30664
[#46115]: {{site.repo.flutter}}/pull/46115
[#83923]: {{site.repo.flutter}}/pull/83923

---

### `TextTheme`

Suportado pelo Flutter Fix: sim

Várias propriedades de `TextStyle` do `TextTheme` foram descontinuadas na
v1.13.8. Elas estão listadas na tabela a seguir, junto com a substituição
apropriada na nova API.

| Descontinuação | Nova API |
|---|---|
| display4 | headline1 |
| display3 | headline2 |
| display2 | headline3 |
| display1 | headline4 |
| headline | headline5 |
| title | headline6 |
| subhead | subtitle1 |
| body2 | bodyText1 |
| body1 | bodyText2 |
| subtitle | subtitle2 |

**Guia de migração**

Código antes da migração:

```dart
// TextTheme
// Base constructor
TextTheme(
  display4: displayStyle4,
  display3: displayStyle3,
  display2: displayStyle2,
  display1: displayStyle1,
  headline: headlineStyle,
  title: titleStyle,
  subhead: subheadStyle,
  body2: body2Style,
  body1: body1Style,
  caption: captionStyle,
  button: buttonStyle,
  subtitle: subtitleStyle,
  overline: overlineStyle,
);

// copyWith
TextTheme.copyWith(
  display4: displayStyle4,
  display3: displayStyle3,
  display2: displayStyle2,
  display1: displayStyle1,
  headline: headlineStyle,
  title: titleStyle,
  subhead: subheadStyle,
  body2: body2Style,
  body1: body1Style,
  caption: captionStyle,
  button: buttonStyle,
  subtitle: subtitleStyle,
  overline: overlineStyle,
);

// Getters
TextStyle style;
style = textTheme.display4;
style = textTheme.display3;
style = textTheme.display2;
style = textTheme.display1;
style = textTheme.headline;
style = textTheme.title;
style = textTheme.subhead;
style = textTheme.body2;
style = textTheme.body1;
style = textTheme.caption;
style = textTheme.button;
style = textTheme.subtitle;
style = textTheme.overline;
```

Código depois da migração:

```dart
// TextTheme
// Base constructor
TextTheme(
  headline1: displayStyle4,
  headline2: displayStyle3,
  headline3: displayStyle2,
  headline4: displayStyle1,
  headline5: headlineStyle,
  headline6: titleStyle,
  subtitle1: subheadStyle,
  bodyText1: body2Style,
  bodyText2: body1Style,
  caption: captionStyle,
  button: buttonStyle,
  subtitle2: subtitleStyle,
  overline: overlineStyle,
);

TextTheme.copyWith(
  headline1: displayStyle4,
  headline2: displayStyle3,
  headline3: displayStyle2,
  headline4: displayStyle1,
  headline5: headlineStyle,
  headline6: titleStyle,
  subtitle1: subheadStyle,
  bodyText1: body2Style,
  bodyText2: body1Style,
  caption: captionStyle,
  button: buttonStyle,
  subtitle2: subtitleStyle,
  overline: overlineStyle,
);

TextStyle style;
style = textTheme.headline1;
style = textTheme.headline2;
style = textTheme.headline3;
style = textTheme.headline4;
style = textTheme.headline5;
style = textTheme.headline6;
style = textTheme.subtitle1;
style = textTheme.bodyText1;
style = textTheme.bodyText2;
style = textTheme.caption;
style = textTheme.button;
style = textTheme.subtitle2;
style = textTheme.overline;
```

**Referências**

Documento de design:

* [Atualização da API do TextTheme][Update the TextTheme API]

Documentação da API:

* [`TextTheme`][`TextTheme`]

Issues relevantes:

* [Migrar o TextTheme para as APIs de 2018][Migrate TextTheme to 2018 APIs]

PRs relevantes:

* Descontinuado em [#48547][]
* Removido em [#83924][]

[Update the TextTheme API]: /go/update-text-theme-api
[`TextTheme`]: {{site.material_ui}}/TextTheme-class.html
[Migrate TextTheme to 2018 APIs]: {{site.repo.flutter}}/issues/45745
[#48547]: {{site.repo.flutter}}/pull/48547
[#83924]: {{site.repo.flutter}}/pull/83924

---

### `Typography` padrão {:#default-typography}

Suportado pelo Flutter Fix: não

O `Typography` padrão foi descontinuado na v1.13.8.
O padrão anterior retornava os estilos de texto da especificação
Material Design de 2014. Agora, isso resulta em `TextStyle`s que refletem
a especificação Material Design de 2018. Para o comportamento anterior,
use o construtor `material2014`.

**Guia de migração**

Código antes da migração:

```dart
// Formerly returned 2014 TextStyle spec
Typography();
```

Código depois da migração:

```dart
// Use 2018 TextStyle spec, either by default or explicitly.
Typography();
Typography.material2018();

// Use 2014 spec from former API
Typography.material2014();
```

**Referências**

Documento de design:

* [Atualização da API do TextTheme][Update the TextTheme API]

Documentação da API:

* [`Typography`][`Typography`]

Issues relevantes:

* [Migrar o TextTheme para as APIs de 2018][Migrate TextTheme to 2018 APIs]

PRs relevantes:

* Descontinuado em [#48547][]
* Removido em [#83924][]

[Update the TextTheme API]: /go/update-text-theme-api
[`Typography`]: {{site.material_ui}}/Typography-class.html
[Migrate TextTheme to 2018 APIs]: {{site.repo.flutter}}/issues/45745
[#48547]: {{site.repo.flutter}}/pull/48547
[#83924]: {{site.repo.flutter}}/pull/83924

---

## Linha do tempo {:#timeline}

Na versão estável: 2.5
