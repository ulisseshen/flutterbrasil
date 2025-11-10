---
title: Descontinuação de `SemanticsProperties.focusable` e `SemanticsConfiguration.isFocusable`
description: >
  O parâmetro `focusable` foi substituído por `isFocused`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Os parâmetros `SemanticsProperties.focusable` e `SemanticsConfiguration.isFocusable`
foram descontinuados em favor dos parâmetros `SemanticsProperties.focused` e
`SemanticsConfiguration.isFocused`.

O parâmetro `focused` agora é anulável.
Configurá-lo como `true` ou `false` automaticamente
define `isFocusable` como `true`, enquanto
configurá-lo como `null` define `isFocusable` como `false`.

## Contexto {:#context}

A propriedade `SemanticsConfiguration.isFocusable` é um booleano que
indica se o nó de semântica pode ter foco de entrada.
`SemanticsConfiguration.isFocused` é um booleano que indica se o
nó de semântica tem foco de entrada.

Esta mudança também se aplica a
`SemanticsProperties.focusable` e `SemanticsProperties.focused`.

Descontinuamos `isFocusable` porque sua funcionalidade é coberta por `isFocused`.
A propriedade `isFocused` agora é armazenada como um flag tristate no engine,
e esta mudança torna o framework consistente com o engine.

## Descrição da mudança {:#description-of-change}

A propriedade `SemanticsConfiguration.isFocusable` é
descontinuada em favor de `SemanticsConfiguration.isFocused`.
Esta propriedade é um booleano anulável; configurá-la como `true` ou `false`
automaticamente define `isFocusable` como `true`, e
configurá-la como `null` define `isFocusable` como `false`.

## Guia de migração {:#migration-guide}

Substitua `SemanticsConfiguration.isFocusable` por
`SemanticsConfiguration.isFocused`.

### Exemplo 1: Configurar `isFocused` como `true` automaticamente define `isFocusable` como `true` {:#example-1-setting-isfocused-to-true-automatically-sets-isfocusable-to-true}

Código antes da migração:

```dart
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  config.isFocusable = true;
  config.isFocused = true;
}
```

Código após a migração:

```dart
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  config.isFocused = true;
}
```

### Exemplo 2: Configurar `isFocused` como `null` automaticamente define `isFocusable` como `false` {:#example-2-setting-isfocused-to-null-automatically-sets-isfocusable-to-false}

Código antes da migração:

```dart
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  config.isFocusable = false;
  config.isFocused = false;
}
```

Código após a migração:

```dart
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  config.isFocused = null;
}
```


## Cronograma {:#timeline}

Implementado na versão: 3.37.0-0.0.pre<br>
Na versão estável: 3.38


## Referências {:#references}

Documentação da API:

* [`SemanticsConfiguration`][]
* [`SemanticsProperties`][]
* [`SemanticsNode`][]

Issue relevante:

* [Issue 166092][]

PR relevante:

* [PR 170935][]

[`SemanticsConfiguration`]: {{site.api}}/flutter/semantics/SemanticsConfiguration-class.html
[`SemanticsProperties`]: {{site.api}}/flutter/semantics/SemanticsProperties-class.html
[`SemanticsNode`]: {{site.api}}/flutter/semantics/SemanticsNode-class.html
[Issue 166092]: {{site.repo.flutter}}/issues/166092
[PR 170935]: {{site.repo.flutter}}/pull/170935
