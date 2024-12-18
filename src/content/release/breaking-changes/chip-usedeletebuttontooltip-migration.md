---
ia-translate: true
title: Migrar useDeleteButtonTooltip para deleteButtonTooltipMessage de Chips
description: >
  O uso de useDeleteButtonTooltip de chips que possuem
  um botão de exclusão foi depreciado em favor de deleteButtonTooltipMessage.
---

## Sumário

Usar `useDeleteButtonTooltip` de qualquer chip que tenha um botão de exclusão
gera um aviso de depreciação ou não existe mais quando referenciado. Isso
inclui os widgets `Chip`, `InputChip` e `RawChip`.

## Contexto

O `useDeleteButtonTooltip` dos widgets `Chip`, `InputChip` e `RawChip` está
depreciado em favor de `deleteButtonTooltipMessage`, pois o último pode ser
usado para desabilitar o tooltip do botão de exclusão do chip.

## Descrição da mudança

A propriedade `deleteButtonTooltipMessage` fornece uma mensagem para o
tooltip no botão de exclusão dos widgets chip.
Subsequentemente, uma mudança foi feita de forma que fornecer uma string
vazia para esta propriedade desabilita o tooltip.

Para evitar redundância da API, esta mudança depreciou `useDeleteButtonTooltip`,
que foi introduzido para essa funcionalidade exata. Um [Flutter fix][] está
disponível para ajudar você a migrar o código existente de `useDeleteButtonTooltip`
para `deleteButtonTooltipMessage`, caso você tenha desabilitado explicitamente
o tooltip.

## Guia de migração

Por padrão, o tooltip do botão de exclusão está sempre habilitado.
Para desabilitar explicitamente o tooltip, forneça uma string vazia para a
propriedade `deleteButtonTooltipMessage`. Os seguintes trechos de código
mostram as mudanças de migração, que são aplicáveis para os widgets `Chip`,
`InputChip` e `RawChip`:

Código antes da migração:

```dart
Chip(
  label: const Text('Tooltip do botão de exclusão desabilitado'),
  onDeleted: _handleDeleteChip,
  useDeleteButtonTooltip: false,
);

RawChip(
  label: const Text('Tooltip do botão de exclusão habilitado'),
  onDeleted: _handleDeleteChip,
  useDeleteButtonTooltip: true,
);
```

Código após a migração:

```dart
Chip(
  label: const Text('Tooltip do botão de exclusão desabilitado'),
  onDeleted: _handleDeleteChip,
  deleteButtonTooltipMessage: '',
);

RawChip(
  label: const Text('Tooltip do botão de exclusão habilitado'),
  onDeleted: _handleDeleteChip,
);
```

## Cronograma

Implementado na versão: 2.11.0-0.1.pre<br>
Na versão estável: 3.0.0

## Referências

Documentação da API:

*   [`Chip`][]
*   [`InputChip`][]
*   [`RawChip`][]

PR relevante:

*   [Deprecate `useDeleteButtonTooltip` for Chips][]

[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`InputChip`]: {{site.api}}/flutter/material/InputChip-class.html
[`RawChip`]: {{site.api}}/flutter/material/RawChip-class.html

[Deprecate `useDeleteButtonTooltip` for Chips]: {{site.repo.flutter}}/pull/96174
[Flutter fix]: /tools/flutter-fix
