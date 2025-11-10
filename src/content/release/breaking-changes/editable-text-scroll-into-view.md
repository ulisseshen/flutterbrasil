---
ia-translate: true
title: Comportamento atualizado de scroll into view do EditableText
description: >
  Melhorar o comportamento de scroll into view da seleção do EditableText para sempre
  usar o extent da seleção atual.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O callback `Editable.onCaretChanged` foi removido. Com esta mudança,
o comportamento do `EditableText` para rolar a seleção para a visualização
muda.

## Contexto

Anteriormente, ao rolar para a visualização para mostrar atualizações do usuário, `EditableText`
usava múltiplos mecanismos para determinar o extent da seleção ou a
localização do caret.

## Descrição da mudança

Ao remover o callback `Editable.onCaretChanged`, `EditableText` sempre
usará a localização do extent de seleção mais atualizada ao rolar para mostrá-la.
Especificamente, isso melhora o comportamento de scroll into view após
alterar a seleção de recolhida para não recolhida usando
`userUpdateTextEditingValue()`.

## Cronograma

Landed in version: 3.12.0-4.0.pre<br>
In stable release: 3.13.0

## Referências

Documentação da API:

* [`EditableText`]({{site.api}}/flutter/widgets/EditableText-class.html)

PRs relevantes:

* [109114: Remove Editable.onCaretChanged callback]({{site.repo.flutter}}/pull/109114)
