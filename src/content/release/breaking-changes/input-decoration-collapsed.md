---
title: Remover parâmetros inválidos para `InputDecoration.collapsed`
description: >
  Os parâmetros do construtor 'InputDecoration.collapsed'
  'floatingLabelBehavior' e 'floatingLabelAlignment' foram descontinuados sem
  substituição porque não têm efeito.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Os parâmetros inválidos `floatingLabelBehavior` e
`floatingLabelAlignment` de `InputDecoration.collapsed` foram descontinuados.

## Contexto {:#background}

O construtor `InputDecoration.collapsed` é usado para
criar uma decoração mínima sem um label.

Os parâmetros `floatingLabelAlignment` e `floatingLabelBehavior` não têm
efeito porque uma decoração de input criada usando
`InputDecoration.collapsed` não tem label.

## Guia de migração {:#migration-guide}

Para migrar, remova o uso dos parâmetros `floatingLabelBehavior` e `floatingLabelAlignment`
ao chamar o construtor `InputDecoration.collapsed`.
Esses parâmetros não tinham efeito.

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

## Linha do tempo {:#timeline}

Incluído na versão: 3.24.0-0.1.pre<br>
No lançamento estável: 3.27.0

## Referências {:#references}

Documentação da API:

* [`InputDecoration.collapsed`][]
* [`InputDecoration.floatingLabelAlignment`][]
* [`InputDecoration.floatingLabelBehavior`][]

Issues relevantes:

* [Add prefixIcon and suffixIcon parameters to InputDecoration.collapsed][]

PRs relevantes:

* [Deprecate invalid InputDecoration.collapsed parameters][]
* [Cleanup InputDecoration.collapsed constructor][]

[`InputDecoration.collapsed`]: {{site.api}}/flutter/material/InputDecoration/InputDecoration.collapsed.html
[`InputDecoration.floatingLabelAlignment`]: {{site.api}}/flutter/material/InputDecoration/floatingLabelAlignment.html
[`InputDecoration.floatingLabelBehavior`]: {{site.api}}/flutter/material/InputDecoration/floatingLabelBehavior.html

[Add prefixIcon and suffixIcon parameters to InputDecoration.collapsed]: {{site.repo.flutter}}/issues/61331
[Deprecate invalid InputDecoration.collapsed parameters]: {{site.repo.flutter}}/pull/152486
[Cleanup InputDecoration.collapsed constructor]: {{site.repo.flutter}}/pull/152165
