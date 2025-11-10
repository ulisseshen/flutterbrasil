---
title: Pelo menos uma variante de dados da área de transferência deve ser fornecida
description: >
  Em preparação para suportar múltiplas variantes de dados da área de transferência,
  pelo menos uma variante de dados da área de transferência deve ser fornecida.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

O argumento `text` do [`ClipboardData constructor`][`ClipboardData constructor`] não é mais anulável.
Código que fornece `null` para o argumento `text` deve ser migrado para fornecer
uma string vazia `''`.

## Contexto

Em preparação para suportar múltiplas variantes de dados da área de transferência, o
construtor `ClipboardData` agora requer que pelo menos uma variante de dados seja
fornecida.

Anteriormente, as plataformas eram inconsistentes em como lidavam com `null`.
O comportamento agora é consistente entre plataformas. Se você está interessado
nos detalhes de baixo nível, veja [PR 122446][PR 122446].

## Descrição da mudança

O argumento `text` do [`ClipboardData constructor`][`ClipboardData constructor`] não é mais anulável.

## Guia de migração

Para redefinir a área de transferência de texto, use uma string vazia `''` em vez de `null`.

Código antes da migração:

```dart
void resetClipboard() {
  Clipboard.setData(ClipboardData(text: null));
}
```

Código após a migração:

```dart
void resetClipboard() {
  Clipboard.setData(ClipboardData(text: ''));
}
```

## Cronograma

Adicionado na versão: 3.10.0-9.0.pre<br>
Na versão estável: 3.10.0

## Referências

Documentação da API:

* [`Clipboard.setData`][`Clipboard.setData`]
* [`ClipboardData constructor`][`ClipboardData constructor`]

PRs relevantes:

* [Assert at least one clipboard data variant is provided][Assert at least one clipboard data variant is provided]

[`ClipboardData constructor`]: {{site.api}}/flutter/services/ClipboardData/ClipboardData.html
[`Clipboard.setData`]: {{site.api}}/flutter/services/Clipboard/setData.html
[PR 122446]: {{site.repo.flutter}}/pull/122446
[Assert at least one clipboard data variant is provided]: {{site.repo.flutter}}/pull/122446
