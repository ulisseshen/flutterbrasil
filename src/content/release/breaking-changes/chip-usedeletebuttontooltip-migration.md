---
title: Migrar useDeleteButtonTooltip para deleteButtonTooltipMessage de Chips
description: >
  useDeleteButtonTooltip de chips que têm
  um botão delete depreciado em favor de deleteButtonTooltipMessage.
ia-translate: true
---

## Resumo

Usar `useDeleteButtonTooltip` de qualquer chip que tem um botão delete dá um
aviso de depreciação, ou não existe mais quando referenciado. Isso inclui os
widgets `Chip`, `InputChip` e `RawChip`.

## Contexto

O `useDeleteButtonTooltip` dos widgets `Chip`, `InputChip` e `RawChip` está
depreciado em favor de `deleteButtonTooltipMessage`, já que o último pode ser usado
para desabilitar o tooltip do botão delete do chip.

## Descrição da mudança

A propriedade `deleteButtonTooltipMessage` fornece uma mensagem para o
tooltip no botão delete dos widgets chip.
Subsequentemente, foi feita uma mudança de forma que fornecer uma string vazia para esta
propriedade desabilita o tooltip.

Para evitar redundância da API, esta mudança depreciou `useDeleteButtonTooltip`,
que foi introduzido para exatamente esta funcionalidade. Um [Flutter fix][] está
disponível para ajudá-lo a migrar código existente de `useDeleteButtonTooltip` para
`deleteButtonTooltipMessage`, se você desabilitou explicitamente o tooltip.

## Guia de migração

Por padrão, o tooltip do botão delete está sempre habilitado.
Para desabilitar explicitamente o tooltip, forneça uma string vazia para a
propriedade `deleteButtonTooltipMessage`.
Os seguintes trechos de código mostram as mudanças de migração, que são aplicáveis para
widgets `Chip`, `InputChip` e `RawChip`:

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

## Linha do tempo

Implementado na versão: 2.11.0-0.1.pre<br>
Na versão estável: 3.0.0

## Referências

Documentação da API:

* [`Chip`][]
* [`InputChip`][]
* [`RawChip`][]

PR relevante:

* [Deprecate `useDeleteButtonTooltip` for Chips][]

[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`InputChip`]: {{site.api}}/flutter/material/InputChip-class.html
[`RawChip`]: {{site.api}}/flutter/material/RawChip-class.html

[Deprecate `useDeleteButtonTooltip` for Chips]: {{site.repo.flutter}}/pull/96174
[Flutter fix]: /tools/flutter-fix
