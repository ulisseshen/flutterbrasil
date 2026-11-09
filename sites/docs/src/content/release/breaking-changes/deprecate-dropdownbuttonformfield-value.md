---
title: >-
  Descontinuado o parâmetro 'value' do
  construtor 'DropdownButtonFormField'
description: >-
  O parâmetro `value` do construtor `DropdownButtonFormField` foi
  substituído pelo parâmetro `initialValue`.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O parâmetro `value` do construtor [`DropdownButtonFormField`][`DropdownButtonFormField`] foi
descontinuado em favor do parâmetro `initialValue`.

## Contexto {:#context}

O parâmetro `value` do construtor [`DropdownButtonFormField`][`DropdownButtonFormField`] era usado
para inicializar [`DropdownButtonFormField.initialValue`][`DropdownButtonFormField.initialValue`].
Não usar o mesmo nome era confuso. Por exemplo,
desenvolvedores falsamente assumiam que definir `value` mudaria
o valor selecionado atual. Este não era o caso—ele
apenas definia o valor inicial ou quando o campo é redefinido.

## Descrição da mudança {:#description-of-change}

O parâmetro `value` do construtor [`DropdownButtonFormField`][`DropdownButtonFormField`] está
descontinuado em favor do parâmetro chamado `initialValue`.

## Guia de migração {:#migration-guide}

Substitua o parâmetro `value` do construtor [`DropdownButtonFormField`][`DropdownButtonFormField`]
pelo parâmetro `initialValue` para inicializar
[`DropdownButtonFormField.initialValue`][`DropdownButtonFormField.initialValue`].

Código antes da migração:

```dart highlightLines=2
DropdownButtonFormField(
  value: 'Yellow',
),
```

Código após a migração:

```dart highlightLines=2
DropdownButtonFormField(
  initialValue: 'Yellow',
),
```

## Cronograma {:#timeline}

Adicionado na versão: 3.35.0-0.0.pre<br>
Na versão estável: 3.35

## Referências {:#references}

Documentação da API:

- [`DropdownButtonFormField`][`DropdownButtonFormField`]
- [`DropdownButtonFormField.initialValue`][`DropdownButtonFormField.initialValue`]

Issues relevantes:

- [Issue #169983][Issue #169983]

PRs relevantes:

- [Deprecate `DropdownButtonFormField` `value` parameter in favor of `initialValue`][Deprecate `DropdownButtonFormField` `value` parameter in favor of `initialValue`]

[`DropdownButtonFormField`]: {{site.material_ui}}/DropdownButtonFormField/DropdownButtonFormField.html
[`DropdownButtonFormField.initialValue`]: {{site.main-api}}/flutter/widgets/FormField/initialValue.html
[Issue #169983]: {{site.repo.flutter}}/issues/169983
[Deprecate `DropdownButtonFormField` `value` parameter in favor of `initialValue`]: {{site.repo.flutter}}/pull/170805
