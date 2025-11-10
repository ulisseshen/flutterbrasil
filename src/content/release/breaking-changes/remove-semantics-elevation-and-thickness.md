---
ia-translate: true
title: Removido elevation e thickness da semântica
description: >-
  Removido elevation e thickness das propriedades de semântica.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Ambas as propriedades de semântica elevation e thickness e suas APIs relacionadas foram removidas.

## Contexto

Ambas as propriedades de semântica elevation e thickness foram criadas para a renderização 3D do Fuchsia.
Elas nunca foram implementadas e, portanto, permaneceram não utilizadas. Também não havia outro uso conhecido
para essas propriedades. Essas propriedades adicionavam complexidade desnecessária ao código e foram removidas.

## Descrição da mudança

As seguintes propriedades foram removidas: `SemanticsConfiguration.elevation`,
`SemanticsConfiguration.thickness`,
`SemanticsNode.thickness`, `SemanticsNode.elevation` e `SemanticsNode.elevationAdjustment`.

## Guia de migração

Se você atribuiu essas propriedades anteriormente, remova as atribuições.

Código antes da migração:

```dart
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  config.label = 'my label';
  config.elevation = 1;
  config.thickness = 1;
}
```

Código após a migração:

```dart
void describeSemanticsConfiguration(SemanticsConfiguration config) {
  config.label = 'my label';
}
```

## Cronograma

Aterrissou na versão: 3.34.0-0.0.pre<br>
No lançamento estável: 3.35

## Referências

Documentação da API:

* [`SemanticsConfiguration`][]
* [`SemanticsNode`][]

Issue relevante:

* [Issue 166092][]

PR relevante:

* [PR 169382][]

[`SemanticsConfiguration`]: {{site.api}}/flutter/semantics/SemanticsConfiguration-class.html
[`SemanticsNode`]: {{site.api}}/flutter/semantics/SemanticsNode-class.html
[Issue 166092]: {{site.repo.flutter}}/issues/166092
[PR 169382]: {{site.repo.flutter}}/pull/169382
