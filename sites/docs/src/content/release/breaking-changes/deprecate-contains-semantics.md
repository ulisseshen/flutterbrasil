---
ia-translate: true
title: Depreciação de `containsSemantics` em favor de `isSemantics`
description: >-
  O matcher `containsSemantics` foi depreciado em favor dos matchers
  `isSemantics` e `matchesSemantics`.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O matcher parcial `containsSemantics` está depreciado e foi substituído por
`isSemantics` para deixar a intenção mais clara e padronizar as convenções dos matchers.

## Contexto {:#context}

O prefixo `contains` dos matchers parciais, como `containsSemantics`, foi
substituído por `is` para seguir as convenções de nomenclatura:

* **Matchers parciais** (como `isSemantics`) verificam apenas
  as propriedades informadas explicitamente.
  Os argumentos não informados são ignorados.
* **Matchers exatos** (como `matchesSemantics`) verificam todos os valores.
  Os argumentos não informados devem
  corresponder aos valores padrão do objeto.

## Guia de migração {:#migration-guide}

Para migrar o seu código automaticamente, execute o seguinte comando:

```console
$ dart fix --apply
```

Como alternativa, substitua `containsSemantics` por `isSemantics` para
comparação parcial (caso mais comum), ou por `matchesSemantics` se você precisar
verificar valores exatos de propriedades (incluindo os padrões dos argumentos omitidos).

Código antes da migração:

```dart
expect(
  tester.getSemantics(find.byType(MyWidget)),
  containsSemantics(
    label: 'My Widget',
    isButton: true,
  ),
);
```

Código após a migração:

```dart
expect(
  tester.getSemantics(find.byType(MyWidget)),
  isSemantics(
    label: 'My Widget',
    isButton: true,
  ),
);
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.40.0-1.0.pre<br>
Na versão estável: 3.41

## Referências {:#references}

Documentação da API:

* [`isSemantics`][`isSemantics`]
* [`matchesSemantics`][`matchesSemantics`]

Issues relevantes:

* [Issue 180534][Issue 180534]
* [Issue 107859][Issue 107859]

PR relevante:

* [PR 180538][PR 180538]

[`isSemantics`]: {{site.api}}/flutter/flutter_test/isSemantics.html
[`matchesSemantics`]: {{site.api}}/flutter/flutter_test/matchesSemantics.html
[Issue 180534]: {{site.repo.flutter}}/issues/180534
[Issue 107859]: {{site.repo.flutter}}/issues/107859
[PR 180538]: {{site.repo.flutter}}/pull/180538
