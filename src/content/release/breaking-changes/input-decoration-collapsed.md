---
ia-translate: true
title: Remover parâmetros inválidos para `InputDecoration.collapsed`
description: >
  Parâmetros do construtor 'InputDecoration.collapsed'
  'floatingLabelBehavior' e 'floatingLabelAlignment' estão
  obsoletos sem substituição porque não têm efeito.
---

## Resumo

Parâmetros inválidos de `InputDecoration.collapsed` `floatingLabelBehavior` e
`floatingLabelAlignment` estão obsoletos.

## Contexto

O construtor `InputDecoration.collapsed` é usado para criar uma decoração mínima
sem rótulo.

Os parâmetros `floatingLabelAlignment` e `floatingLabelBehavior` não têm
efeito porque uma decoração de entrada criada usando `InputDecoration.collapsed`
não tem rótulo.

## Guia de migração

Para migrar, remova o uso dos parâmetros `floatingLabelBehavior` e
`floatingLabelAlignment` ao chamar o construtor `InputDecoration.collapsed`.
Esses parâmetros não tiveram efeito.

Código antes da migração:

```dart
InputDecoration.collapsed(
  hintText: 'Hint',
  floatingLabelAlignment: FloatingLabelAlignment.center,
  floatingLabelBehavior: FloatingLabelBehavior.auto,
),
```

Código após a migração:

```dart
InputDecoration.collapsed(
  hintText: 'Hint',
),
```

## Cronograma

Implementado na versão: v3.24.0-0.1.pre<br>
Em lançamento estável: Ainda não

## Referências

Documentação da API:

* [`InputDecoration.collapsed`][]
* [`InputDecoration.floatingLabelAlignment`][]
* [`InputDecoration.floatingLabelBehavior`][]

Issues relevantes:

* [Adicionar parâmetros prefixIcon e suffixIcon a InputDecoration.collapsed][]

PRs relevantes:

* [Depreciar parâmetros inválidos de InputDecoration.collapsed][]
* [Limpeza do construtor InputDecoration.collapsed][]

[`InputDecoration.collapsed`]: {{site.api}}/flutter/material/InputDecoration/InputDecoration.collapsed.html
[`InputDecoration.floatingLabelAlignment`]: {{site.api}}/flutter/material/InputDecoration/floatingLabelAlignment.html
[`InputDecoration.floatingLabelBehavior`]: {{site.api}}/flutter/material/InputDecoration/floatingLabelBehavior.html

[Adicionar parâmetros prefixIcon e suffixIcon a InputDecoration.collapsed]: {{site.repo.flutter}}/issues/61331
[Depreciar parâmetros inválidos de InputDecoration.collapsed]: {{site.repo.flutter}}/pull/152486
[Limpeza do construtor InputDecoration.collapsed]: {{site.repo.flutter}}/pull/152165
