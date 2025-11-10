---
title: Customizando alinhamento de tabs usando a nova propriedade TabBar.tabAlignment
description: Apresentando a propriedade TabBar.tabAlignment.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Usando `TabBar.tabAlignment` para customizar o alinhamento de tabs em um `TabBar`.

## Context

A propriedade `TabBar.tabAlignment` define onde um `TabBar` Material 3 coloca tabs.
O enum `TabAlignment` tem os seguintes valores:

* `TabAlignment.start`: Alinha as tabs ao início do `TabBar` scrollable.
* `TabAlignment.startOffset`: Alinha as tabs ao início do
   `TabBar` scrollable com um offset de `52.0` pixels.
* `TabAlignment.center`: Alinha as tabs ao centro do `TabBar`.
* `TabAlignment.fill`: Alinha as tabs ao início e estica as tabs
   para preencher o `TabBar` fixo.

O `TabBar` scrollable suporta os seguintes alinhamentos:

* `TabAlignment.start`
* `TabAlignment.startOffset`
* `TabAlignment.center`

O `TabBar` fixo suporta os seguintes alinhamentos:

* `TabAlignment.fill`
* `TabAlignment.center`

Quando você define `ThemeData.useMaterial3` como `true`,
um `TabBar` scrollable alinha tabs como `TabAlignment.startOffset` por padrão.
Para mudar este alinhamento, defina a
propriedade `TabBar.tabAlignment` para customização em nível de widget.
Ou, defina a propriedade `TabBarThemeData.tabAlignment` para customização em nível de aplicação.

## Description of change

Quando você define `TabBar.isScrollable` e `ThemeData.useMaterial3` como `true`,
as tabs em um `TabBar` scrollable têm como padrão `TabAlignment.startOffset`.
Isso alinha as tabs ao início do
`TabBar` scrollable com um offset de `52.0` pixels.
Isso muda o comportamento anterior.
As tabs eram alinhadas ao início do `TabBar` scrollable
quando mais tabs precisavam ser exibidas do que a largura permitia.

## Migration guide

Um `TabBar` scrollable Material 3 usa `TabAlignment.startOffset` como
o alinhamento de tab padrão.
Isso alinha as tabs ao início do
`TabBar` scrollable com um offset de `52.0` pixels.

Para alinhar as tabs ao início do
`TabBar` scrollable, defina `TabBar.tabAlignment` como `TabAlignment.start`.
Esta mudança também removeu o offset de `52.0` pixels.
Os seguintes snippets de código mostram como usar `TabBar.tabAlignment` para
alinhar tabs ao início do `TabBar` scrollable:

Code before migration:

```dart
TabBar(
  isScrollable: true,
  tabs: List<Tab>.generate(
    count,
    (int index) => Tab(text: 'Tab $index'),
  ).toList(),
);
```

Code after migration:

```dart
TabBar(
  tabAlignment: TabAlignment.start,
  isScrollable: true,
  tabs: List<Tab>.generate(
    count,
    (int index) => Tab(text: 'Tab $index'),
  ).toList(),
);
```

## Timeline

Landed in version: 3.13.0-17.0.pre<br>
In stable release: 3.16

## References

API documentation:

* [`TabBar`][]
* [`TabBar.tabAlignment`][]
* [`TabAlignment`][]

Relevant PRs:

* [Introduce `TabBar.tabAlignment`][]
* [Fix Material 3 Scrollable `TabBar`][]

[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBar.tabAlignment`]: {{site.api}}/flutter/material/TabBar/tabAlignment.html
[`TabAlignment`]: {{site.api}}/flutter/material/TabAlignment.html

[Introduce `TabBar.tabAlignment`]: {{site.repo.flutter}}/pull/125036
[Fix Material 3 Scrollable `TabBar`]: {{site.repo.flutter}}/pull/131409
