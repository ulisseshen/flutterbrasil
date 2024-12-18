---
ia-translate: true
title: Comportamento atualizado de rolagem do EditableText para a visualização
description: >
  Melhorar o comportamento de rolagem da seleção do EditableText para a
  visualização para sempre usar a extensão da seleção atual.
---

## Resumo

O callback `Editable.onCaretChanged` é removido. Com esta alteração, o
comportamento do `EditableText` para rolar a seleção para a visualização
muda.

## Contexto

Anteriormente, ao rolar para a visualização para mostrar as atualizações do
usuário, o `EditableText` usava vários mecanismos para determinar a extensão
da seleção ou a localização do cursor.

## Descrição da alteração

Ao remover o callback `Editable.onCaretChanged`, o `EditableText` sempre
usará a localização da extensão de seleção mais atualizada ao rolar para
mostrá-la. Especificamente, isso melhora o comportamento de rolagem para a
visualização após alterar a seleção de recolhida para não recolhida usando
`userUpdateTextEditingValue()`.

## Cronograma

Incluído na versão: 3.12.0-4.0.pre<br>
Na versão estável: 3.13.0

## Referências

Documentação da API:

* [`EditableText`]({{site.api}}/flutter/widgets/EditableText-class.html)

PRs relevantes:

* [109114: Remover o callback Editable.onCaretChanged]({{site.repo.flutter}}/pull/109114)
