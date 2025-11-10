---
title: Guia de migração para describeEnum e EnumProperty
description: Saiba sobre a remoção de describeEnum e como migrar.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

O método global `describeEnum` foi descontinuado. Usos anteriores
de `describeEnum(Enum.something)` devem usar
`Enum.something.name` no lugar.

A classe `EnumProperty` foi modificada para
estender `<T extends Enum?>` em vez de `<T>`.
Usos existentes de `EnumProperty<NotAnEnum>` devem
usar `DiagnosticsProperty<NotAnEnum>` no lugar.

## Contexto

O Dart 2.17 introduziu [enhanced enums][], que adicionou `Enum` como um tipo.
Como resultado, todos os enums ganharam um getter `name`, o que tornou `describeEnum`
redundante. Antes disso, classes enum eram frequentemente analisadas usando uma
`EnumProperty`.

O método `describeEnum` era usado para converter um valor enum em uma string,
já que `Enum.something.toString()` produziria `Enum.something` em vez
de `something`, o que muitos usuários queriam. Agora, o getter `name` faz isso.

A função `describeEnum` está sendo descontinuada,
então a classe `EnumProperty` foi atualizada para aceitar apenas objetos `Enum`.

[enhanced enums]: {{site.dart-site}}/language/enums#declaring-enhanced-enums

## Descrição da alteração

Remover `describeEnum`.

- Substitua `describeEnum(Enum.something)` por `Enum.something.name`.

O `EnumProperty` agora espera null ou um `Enum`;
você não pode mais passar uma classe que não seja `Enum`.

## Guia de migração

Se você usava anteriormente `describeEnum(Enum.field)` para acessar o
valor string de um enum, agora você pode chamar `Enum.field.name`.

Se você usava anteriormente `EnumProperty<NotAnEnum>`, agora você pode
usar o genérico `DiagnosticsProperty<NotAnEnum>`.

Código antes da migração:

```dart
enum MyEnum { paper, rock }

print(describeEnum(MyEnum.paper)); // output: paper

// TextInputType is not an Enum
properties.add(EnumProperty<TextInputType>( ... ));
```

Código após a migração:

```dart
enum MyEnum { paper, rock }

print(MyEnum.paper.name); // output: paper

// TextInputType is not an Enum
properties.add(DiagnosticsProperty<TextInputType>( ... ));
```

## Linha do tempo

Disponibilizado na versão: 3.14.0-2.0.pre<br>
Na versão estável: 3.16

## Referências

Documentação da API:

* [`describeEnum`][]
* [`EnumProperty`][]

Issues relevantes:

* [Cleanup SemanticsFlag and SemanticsAction issue][]

PRs relevantes:

* [Deprecate `describeEnum` PR][]

[`describeEnum`]: {{site.api}}/flutter/foundation/describeEnum.html
[`EnumProperty`]: {{site.api}}/flutter/foundation/EnumProperty-class.html

[Cleanup SemanticsFlag and SemanticsAction issue]: {{site.repo.flutter}}/issues/123346
[Deprecate `describeEnum` PR]: {{site.repo.flutter}}/pull/125016
