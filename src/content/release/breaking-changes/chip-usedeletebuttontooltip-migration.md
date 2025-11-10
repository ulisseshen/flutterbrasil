---
ia-translate: true
title: Migrar useDeleteButtonTooltip para deleteButtonTooltipMessage dos Chips
description: >
  O useDeleteButtonTooltip dos chips que possuem um botão de exclusão
  foi descontinuado em favor de deleteButtonTooltipMessage.
---

{% render "docs/breaking-changes.md" %}

## Resumo

Usar `useDeleteButtonTooltip` em qualquer chip que tenha um botão de exclusão gera um
aviso de descontinuação, ou não existe mais quando referenciado. Isso inclui os
widgets `Chip`, `InputChip` e `RawChip`.

## Contexto

O `useDeleteButtonTooltip` dos widgets `Chip`, `InputChip` e `RawChip` foi
descontinuado em favor de `deleteButtonTooltipMessage`, já que este último pode ser usado
para desabilitar a tooltip do botão de exclusão do chip.

## Descrição da mudança

A propriedade `deleteButtonTooltipMessage` fornece uma mensagem para a
tooltip no botão de exclusão dos widgets chip.
Posteriormente, foi feita uma mudança de modo que fornecer uma string vazia para esta
propriedade desabilita a tooltip.

Para evitar redundância na API, esta mudança descontinuou `useDeleteButtonTooltip`,
que foi introduzido para exatamente essa funcionalidade. Um [Flutter fix][Flutter fix] está
disponível para ajudá-lo a migrar código existente de `useDeleteButtonTooltip` para
`deleteButtonTooltipMessage`, se você desabilitou explicitamente a tooltip.

## Guia de migração

Por padrão, a tooltip do botão de exclusão está sempre habilitada.
Para desabilitar explicitamente a tooltip, forneça uma string vazia para a
propriedade `deleteButtonTooltipMessage`.
Os trechos de código a seguir mostram as mudanças de migração, que são aplicáveis para
os widgets `Chip`, `InputChip` e `RawChip`:

Código antes da migração:

```dart
Chip(
  label: const Text('Disabled delete button tooltip'),
  onDeleted: _handleDeleteChip,
  useDeleteButtonTooltip: false,
);

RawChip(
  label: const Text('Enabled delete button tooltip'),
  onDeleted: _handleDeleteChip,
  useDeleteButtonTooltip: true,
);
```

Código após a migração:

```dart
Chip(
  label: const Text('Disabled delete button tooltip'),
  onDeleted: _handleDeleteChip,
  deleteButtonTooltipMessage: '',
);

RawChip(
  label: const Text('Enabled delete button tooltip'),
  onDeleted: _handleDeleteChip,
);
```

## Cronograma

Incluído na versão: 2.11.0-0.1.pre<br>
Na versão estável: 3.0.0

## Referências

Documentação da API:

* [`Chip`][`Chip`]
* [`InputChip`][`InputChip`]
* [`RawChip`][`RawChip`]

PR relevante:

* [Deprecate `useDeleteButtonTooltip` for Chips][Deprecate `useDeleteButtonTooltip` for Chips]

[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`InputChip`]: {{site.api}}/flutter/material/InputChip-class.html
[`RawChip`]: {{site.api}}/flutter/material/RawChip-class.html

[Deprecate `useDeleteButtonTooltip` for Chips]: {{site.repo.flutter}}/pull/96174
[Flutter fix]: /tools/flutter-fix
