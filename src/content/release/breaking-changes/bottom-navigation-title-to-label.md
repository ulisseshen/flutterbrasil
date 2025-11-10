---
title: Título de Bottom Navigation para Label
description: >
  Descontinuado o title (um Widget) do BottomNavigationBarItem
  em favor de label (uma String).
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

`BottomNavigationBarItem.title` emite um aviso de descontinuação,
ou não existe mais quando referenciado no código.

## Contexto

O parâmetro `title` do `BottomNavigationBarItem` foi descontinuado
em favor de `label`. Esta mudança foi necessária para melhorar
a experiência do usuário de `BottomNavigationBar`s quando o fator
de escala de texto é aumentado. Os itens em um `BottomNavigationBar`
agora mostram tooltips ao pressionar longamente. Para realizar isso
é necessário um parâmetro `String` nos `BottomNavigationBarItem`s.

## Descrição da mudança

A classe `BottomNavigationBarItem` tem um parâmetro `title`,
que é um `Widget`. Isso tornava impossível para o
`BottomNavigationBar` exibir widgets `Tooltip`,
uma mudança que foi necessária para melhorar a experiência de acessibilidade.
Agora, em vez de construir o widget `BottomNavigationBarItem.title`,
o BottomNavigationBar envolve o
`BottomNavigationBarItem.label` em um widget Text e constrói isso.

## Guia de migração

Código antes da migração:

```dart
BottomNavigationBarItem(
  icon: Icons.add,
  title: Text('add'),
)
```

Código após a migração:

```dart
BottomNavigationBarItem(
  icon: Icons.add,
  label: 'add',
)
```

## Cronograma

Aplicado na versão: 1.22.0<br>
Em versão estável: 2.0.0

## Referências

Documentação da API:

* [`BottomNavigationBarItem`][]

PRs relevantes:

* [PR 60655][]: Clean up hero controller scope
* [PR 59127][]: Update BottomNavigationBar to show tooltips on long press.

Proposta de breaking change:

* [Breaking Change: Bottom Navigation Item Title][]


[`BottomNavigationBarItem`]: {{site.api}}/flutter/widgets/BottomNavigationBarItem-class.html
[Breaking Change: Bottom Navigation Item Title]: /go/bottom-navigation-bar-title-deprecation
[PR 59127]: {{site.repo.flutter}}/pull/59127
[PR 60655]: {{site.repo.flutter}}/pull/60655
