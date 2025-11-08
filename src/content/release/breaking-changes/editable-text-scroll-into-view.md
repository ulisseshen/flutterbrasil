---
ia-translate: true
title: Comportamento atualizado de scroll into view do EditableText
description: >
  Melhorar o comportamento de scroll into view da seleção do EditableText para sempre
  usar a extensão de seleção atual.
---

## Resumo

O callback `Editable.onCaretChanged` foi removido. Com esta mudança,
o comportamento do `EditableText` para fazer scroll da seleção para a visualização
é alterado.

## Contexto

Anteriormente, ao fazer scroll para a visualização para mostrar atualizações do usuário, `EditableText`
usava múltiplos mecanismos para determinar a extensão da seleção ou a
localização do cursor.

## Descrição da mudança

Ao remover o callback `Editable.onCaretChanged`, `EditableText` sempre
usará a localização mais atualizada da extensão da seleção ao fazer scroll para mostrá-la.
Especificamente, isso melhora o comportamento de scroll into view após
alterar a seleção de colapsada para não-colapsada usando
`userUpdateTextEditingValue()`.

## Cronograma

Adicionado na versão: 3.12.0-4.0.pre<br>
Na versão stable: 3.13.0

## Referências

Documentação da API:

* [`EditableText`]({{site.api}}/flutter/widgets/EditableText-class.html)

PRs relevantes:

* [109114: Remove Editable.onCaretChanged callback]({{site.repo.flutter}}/pull/109114)
