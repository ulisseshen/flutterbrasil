---
ia-translate: true
title: Depreciar `InputDecoration.maintainHintHeight` em favor de
  `InputDecoration.maintainHintSize`
description: >-
  O parâmetro `InputDecoration.maintainHintHeight` foi substituído por
  `InputDecoration.maintainHintSize`.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O parâmetro [`InputDecoration.maintainHintHeight`][] foi depreciado
em favor do parâmetro [`InputDecoration.maintainHintSize`][].

## Contexto

O tamanho intrínseco padrão de um decorador de input depende do tamanho do hint.
O parâmetro [`InputDecoration.maintainHintSize`][] pode ser definido como `false` para
fazer com que o tamanho intrínseco ignore o tamanho do hint quando o hint não está visível.
Anteriormente, o parâmetro `InputDecoration.maintainHintHeight` era
usado para sobrescrever a altura intrínseca padrão e não tinha impacto na
largura intrínseca.

## Descrição da mudança

O [`InputDecoration.maintainHintHeight`][] foi depreciado em
favor de [`InputDecoration.maintainHintSize`][] que faz com que tanto a largura
quanto a altura intrínsecas dependam das dimensões do hint.

## Guia de migração

Substitua [`InputDecoration.maintainHintHeight`][] por
[`InputDecoration.maintainHintSize`][] para sobrescrever o cálculo do tamanho intrínseco
padrão.

Código antes da migração:

```dart highlightLines=3
TextField(
  indicator: InputDecoration(
    maintainHintHeight: false,
  ),
),
```

Código após a migração:

```dart highlightLines=3
TextField(
  indicator: InputDecoration(
    maintainHintSize: false,
  ),
),
```

## Cronograma

Aterrissou na versão: 3.30.0-0.0.pre<br>
No lançamento estável: 3.32

## Referências

Documentação da API:

- [`InputDecoration.maintainHintHeight`][]
- [`InputDecoration.maintainHintSize`][]

Issues relevantes:

- [Issue #93337][]

PRs relevantes:

- [Fix TextField intrinsic width when hint is not visible][]

[`InputDecoration.maintainHintHeight`]: {{site.api}}/flutter/material/InputDecoration/maintainHintHeight.html
[`InputDecoration.maintainHintSize`]: {{site.main-api}}/flutter/material/InputDecoration/maintainHintSize.html
[Issue #93337]: {{site.repo.flutter}}/issues/93337
[Fix TextField intrinsic width when hint is not visible]: {{site.repo.flutter}}/pull/161235
