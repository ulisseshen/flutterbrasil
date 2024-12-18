---
ia-translate: true
title: Guia de migração para describeEnum e EnumProperty
description: Saiba mais sobre a remoção de describeEnum e como migrar.
---

## Resumo

O método global `describeEnum` foi descontinuado. Usos anteriores de
`describeEnum(Enum.something)` devem usar `Enum.something.name` em vez disso.

A classe `EnumProperty` foi modificada para estender `<T extends Enum?>`
em vez de `<T>`. Usos existentes de `EnumProperty<NotAnEnum>` devem usar
`DiagnosticsProperty<NotAnEnum>` em vez disso.

## Contexto

O Dart 2.17 introduziu [enums aprimorados][], que adicionaram `Enum` como um tipo.
Como resultado, todos os enums obtiveram um getter `name`, o que tornou `describeEnum`
redundante. Antes disso, as classes enum eram frequentemente analisadas usando um
`EnumProperty`.

O método `describeEnum` era usado para converter um valor enum em uma string,
já que `Enum.something.toString()` produziria `Enum.something` em vez de
`something`, que muitos usuários queriam. Agora, o getter `name` faz isso.

A função `describeEnum` está sendo descontinuada, então a classe
`EnumProperty` é atualizada para aceitar apenas objetos `Enum`.

[enhanced enums]: {{site.dart-site}}/language/enums#declaring-enhanced-enums

## Descrição da mudança

Remover `describeEnum`.

- Substitua `describeEnum(Enum.something)` por `Enum.something.name`.

O `EnumProperty` agora espera null ou um `Enum`; você não pode mais
passar uma classe não-`Enum` para ele.

## Guia de migração

Se você usou anteriormente `describeEnum(Enum.field)` para acessar o valor
string de um enum, agora você pode chamar `Enum.field.name`.

Se você usou anteriormente `EnumProperty<NotAnEnum>`, agora você pode usar o
genérico `DiagnosticsProperty<NotAnEnum>`.

Código antes da migração:

```dart
enum MyEnum { paper, rock }

print(describeEnum(MyEnum.paper)); // output: paper

// TextInputType não é um Enum
properties.add(EnumProperty<TextInputType>( ... ));
```

Código após a migração:

```dart
enum MyEnum { paper, rock }

print(MyEnum.paper.name); // output: paper

// TextInputType não é um Enum
properties.add(DiagnosticsProperty<TextInputType>( ... ));
```

## Cronograma

Implementado na versão: 3.14.0-2.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

* [`describeEnum`][]
* [`EnumProperty`][]

Issues relevantes:

* [Problema de Cleanup SemanticsFlag e SemanticsAction][]

PRs relevantes:

* [PR para descontinuar `describeEnum`][]

[`describeEnum`]: {{site.api}}/flutter/lib/src/foundation/describeEnum.html
[`EnumProperty`]: {{site.api}}/flutter/lib/src/foundation/EnumProperty.html
[Problema de Cleanup SemanticsFlag e SemanticsAction]: {{site.repo.flutter}}/issues/123346
[PR para descontinuar `describeEnum`]: {{site.repo.flutter}}/pull/125016
