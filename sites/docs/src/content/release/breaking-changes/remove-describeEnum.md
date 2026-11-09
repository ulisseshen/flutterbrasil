---
ia-translate: true
title: Remove describeEnum
description: >-
  O método `describeEnum` foi removido do framework Flutter.
  Desde o Dart 2.14, os enums têm um getter `name` que faz a mesma coisa.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O método `describeEnum` foi removido do framework porque é redundante com o getter `name`
de `Enum`, introduzido no `Dart 2.14`.

## Contexto {:#context}

Historicamente, o Flutter usava `describeEnum` para retornar uma descrição `String` de um valor de enum.
Isso se tornou redundante quando o getter `name` de `Enum` foi introduzido no `Dart 2.14`.

## Guia de migração {:#migration-guide}

Se o seu código usava anteriormente o método `describeEnum` para obter o nome do valor de um membro de enum,
migre o código para usar o getter `name` da própria instância.

```dart diff
  enum Theme { light, dark }

- final theme = describeEnum(Theme.light);

+ Theme.light.name;
```

:::important
Esta migração não é suportada pelo `dart fix`.
:::

## Linha do tempo {:#timeline}

Incluído na versão: TBD<br>
Na versão estável: TBD

## Referências {:#references}

Documentação da API:

* [`enums`][]


PRs relevantes:

* [PR 94496][]
* [PR 190076][]

[`enums`]: {{site.dart-site}}/language/enums
[PR 94496]: {{site.repo.flutter}}/pull/94496
[PR 190076]: {{site.repo.flutter}}/pull/190076

