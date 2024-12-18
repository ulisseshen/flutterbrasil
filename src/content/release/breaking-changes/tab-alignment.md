---
ia-translate: true
title: Personalizando o alinhamento das abas usando a nova propriedade TabBar.tabAlignment
description: Apresentando a propriedade TabBar.tabAlignment.
---

## Resumo

Usando `TabBar.tabAlignment` para personalizar o alinhamento das abas em um `TabBar`.

## Contexto

A propriedade `TabBar.tabAlignment` define onde um `TabBar` Material 3 coloca as abas. O enum `TabAlignment` tem os seguintes valores:

*   `TabAlignment.start`: Alinha as abas ao início do `TabBar` rolável.
*   `TabAlignment.startOffset`: Alinha as abas ao início do `TabBar` rolável com um deslocamento de `52.0` pixels.
*   `TabAlignment.center`: Alinha as abas ao centro do `TabBar`.
*   `TabAlignment.fill`: Alinha as abas ao início e estica as abas para preencher o `TabBar` fixo.

O `TabBar` rolável suporta os seguintes alinhamentos:

*   `TabAlignment.start`
*   `TabAlignment.startOffset`
*   `TabAlignment.center`

O `TabBar` fixo suporta os seguintes alinhamentos:

*   `TabAlignment.fill`
*   `TabAlignment.center`

Quando você define `ThemeData.useMaterial3` como `true`, um `TabBar` rolável alinha as abas como `TabAlignment.startOffset` por padrão. Para alterar este alinhamento, defina a propriedade `TabBar.tabAlignment` para personalização no nível do widget. Ou, defina a propriedade `TabBarThemeData.tabAlignment` para personalização no nível do aplicativo.

## Descrição da mudança

Quando você define `TabBar.isScrollable` e `ThemeData.useMaterial3` como `true`, as abas em um `TabBar` rolável são padronizadas para `TabAlignment.startOffset`. Isso alinha as abas ao início do `TabBar` rolável com um deslocamento de `52.0` pixels. Isso altera o comportamento anterior. As abas eram alinhadas ao início do `TabBar` rolável quando mais abas precisavam ser exibidas do que a largura permitia.

## Guia de migração

Um `TabBar` rolável Material 3 usa `TabAlignment.startOffset` como o alinhamento de aba padrão. Isso alinha as abas ao início do `TabBar` rolável com um deslocamento de `52.0` pixels.

Para alinhar as abas ao início do `TabBar` rolável, defina `TabBar.tabAlignment` como `TabAlignment.start`. Essa alteração também removeu o deslocamento de `52.0` pixels. Os trechos de código a seguir mostram como usar `TabBar.tabAlignment` para alinhar as abas ao início do `TabBar` rolável:

Código antes da migração:

```dart
TabBar(
  isScrollable: true,
  tabs: List<Tab>.generate(
    count,
    (int index) => Tab(text: 'Tab $index'),
  ).toList(),
);
```

Código após a migração:

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

## Linha do tempo

Implementado na versão: 3.13.0-17.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

*   [`TabBar`][]
*   [`TabBar.tabAlignment`][]
*   [`TabAlignment`][]

PRs relevantes:

*   [Introduce `TabBar.tabAlignment`][]
*   [Fix Material 3 Scrollable `TabBar`][]

[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBar.tabAlignment`]: {{site.api}}/flutter/material/TabBar/tabAlignment.html
[`TabAlignment`]: {{site.api}}/flutter/material/TabAlignment.html

[Introduce `TabBar.tabAlignment`]: {{site.repo.flutter}}/pull/125036
[Fix Material 3 Scrollable `TabBar`]: {{site.repo.flutter}}/pull/131409
