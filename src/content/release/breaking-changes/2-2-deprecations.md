---
ia-translate: true
title: API Deprecada Removida Após a v2.2
description: >
  Após atingir o fim da vida útil, as seguintes APIs deprecadas foram
  removidas do Flutter.
---

## Resumo

De acordo com a [Política de Deprecação][] do Flutter,
APIs deprecadas que atingiram o fim da vida útil após o
lançamento da versão 2.2 estável foram removidas.

Todas as APIs afetadas foram compiladas nesta fonte
primária para auxiliar na migração. Uma
[folha de referência rápida][] também está disponível.

[Política de Deprecação]: {{site.repo.flutter}}/blob/master/docs/contributing/Tree-hygiene.md#deprecations
[folha de referência rápida]: /go/deprecations-removed-after-2-2

## Mudanças

Esta seção lista as deprecações, listadas pela classe afetada.

### `hasFloatingPlaceholder` de `InputDecoration` & `InputDecorationTheme`

Suportado pelo Flutter Fix: sim

`hasFloatingPlaceholder` foi deprecado na v1.13.2.
Use `floatingLabelBehavior` em vez disso.
Onde `useFloatingPlaceholder` era verdadeiro, substitua por `FloatingLabelBehavior.auto`.
Onde `useFloatingPlaceholder` era falso, substitua por `FloatingLabelBehavior.never`.
Esta alteração permite que mais comportamentos sejam especificados além da escolha binária
original, adicionando `FloatingLabelBehavior.always` como uma opção adicional.

**Guia de migração**

Código antes da migração:

```dart
// InputDecoration
// Construtor base
InputDecoration(hasFloatingPlaceholder: true);
InputDecoration(hasFloatingPlaceholder: false);

// Construtor collapsed
InputDecoration.collapsed(hasFloatingPlaceholder: true);
InputDecoration.collapsed(hasFloatingPlaceholder: false);

// Acesso ao campo
inputDecoration.hasFloatingPlaceholder;

// InputDecorationTheme
// Construtor base
InputDecorationTheme(hasFloatingPlaceholder: true);
InputDecorationTheme(hasFloatingPlaceholder: false);

// Acesso ao campo
inputDecorationTheme.hasFloatingPlaceholder;

// copyWith
inputDecorationTheme.copyWith(hasFloatingPlaceholder: false);
inputDecorationTheme.copyWith(hasFloatingPlaceholder: true);
```

Código após a migração:

```dart
// InputDecoration
// Construtor base
InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.auto);
InputDecoration(floatingLabelBehavior: FloatingLabelBehavior.never);

// Construtor collapsed
InputDecoration.collapsed(floatingLabelBehavior: FloatingLabelBehavior.auto);
InputDecoration.collapsed(floatingLabelBehavior: FloatingLabelBehavior.never);

// Acesso ao campo
inputDecoration.floatingLabelBehavior;

// InputDecorationTheme
// Construtor base
InputDecorationTheme(floatingLabelBehavior: FloatingLabelBehavior.auto);
InputDecorationTheme(floatingLabelBehavior: FloatingLabelBehavior.never);

// Acesso ao campo
inputDecorationTheme.floatingLabelBehavior;

// copyWith
inputDecorationTheme.copyWith(floatingLabelBehavior: FloatingLabelBehavior.never);
inputDecorationTheme.copyWith(floatingLabelBehavior: FloatingLabelBehavior.auto);
```

**Referências**

Documentação da API:

* [`InputDecoration`][]
* [`InputDecorationTheme`][]
* [`FloatingLabelBehavior`][]

Issues relevantes:

* [InputDecoration: option to always float label][]

PRs relevantes:

* Deprecated in [#46115][]
* Removed in [#83923][]

[`InputDecoration`]: {{site.api}}/flutter/material/InputDecoration-class.html
[`InputDecorationTheme`]: {{site.api}}/flutter/material/InputDecorationTheme-class.html
[`FloatingLabelBehavior`]: {{site.api}}/flutter/material/FloatingLabelBehavior-class.html
[InputDecoration: option to always float label]: {{site.repo.flutter}}/issues/30664
[#46115]: {{site.repo.flutter}}/pull/46115
[#83923]: {{site.repo.flutter}}/pull/83923

---

### `TextTheme`

Suportado pelo Flutter Fix: sim

Várias propriedades `TextStyle` de `TextTheme` foram deprecadas na v1.13.8. Elas
estão listadas na tabela a seguir, juntamente com a substituição apropriada na
nova API.

| Deprecação | Nova API |
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
// Construtor base
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

Código após a migração:

```dart
// TextTheme
// Construtor base
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

* [Atualizar a API TextTheme][]

Documentação da API:

* [`TextTheme`][]

Issues relevantes:

* [Migrar TextTheme para APIs de 2018][]

PRs relevantes:

* Deprecated in [#48547][]
* Removed in [#83924][]

[Atualizar a API TextTheme]: /go/update-text-theme-api
[`TextTheme`]: {{site.api}}/flutter/material/TextTheme-class.html
[Migrar TextTheme para APIs de 2018]: {{site.repo.flutter}}/issues/45745
[#48547]: {{site.repo.flutter}}/pull/48547
[#83924]: {{site.repo.flutter}}/pull/83924

---

### `Typography` padrão

Suportado pelo Flutter Fix: não

O `Typography` padrão foi deprecado na v1.13.8.
O padrão anterior retornava os estilos de texto da especificação do Material Design de 2014.
Isso agora resultará em `TextStyle`s refletindo a especificação do Material Design de 2018.
Para o anterior, use o construtor `material2014`.

**Guia de migração**

Código antes da migração:

```dart
// Anteriormente retornava a especificação TextStyle de 2014
Typography();
```

Código após a migração:

```dart
// Use a especificação TextStyle de 2018, por padrão ou explicitamente.
Typography();
Typography.material2018();

// Use a especificação de 2014 da API anterior
Typography.material2014();
```

**Referências**

Documento de design:

* [Atualizar a API TextTheme][]

Documentação da API:

* [`Typography`][]

Issues relevantes:

* [Migrar TextTheme para APIs de 2018][]

PRs relevantes:

* Deprecated in [#48547][]
* Removed in [#83924][]

[Atualizar a API TextTheme]: /go/update-text-theme-api
[`Typography`]: {{site.api}}/flutter/material/Typography-class.html
[Migrar TextTheme para APIs de 2018]: {{site.repo.flutter}}/issues/45745
[#48547]: {{site.repo.flutter}}/pull/48547
[#83924]: {{site.repo.flutter}}/pull/83924

---

## Linha do tempo

Em lançamento estável: 2.5
