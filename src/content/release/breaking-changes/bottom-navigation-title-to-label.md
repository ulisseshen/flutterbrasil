---
ia-translate: true
title: Título da Navegação Inferior Para Label
description: >
  O título (um Widget) de BottomNavigationBarItem foi depreciado
  em favor de label (uma String).
---

## Sumário

`BottomNavigationBarItem.title` gera um aviso de depreciação,
ou não existe mais quando referenciado no código.

## Contexto

O parâmetro `title` de `BottomNavigationBarItem` foi depreciado
em favor de `label`. Essa mudança foi necessária para melhorar
a experiência do usuário de `BottomNavigationBar`s quando o fator
de escala de texto é aumentado. Itens em um `BottomNavigationBar`
agora mostram tooltips em um long press. Para realizar isso,
é necessário um parâmetro `String` em `BottomNavigationBarItem`s.

## Descrição da mudança

A classe `BottomNavigationBarItem` tem um parâmetro `title`,
que é um `Widget`. Isso tornava impossível para o
`BottomNavigationBar` mostrar widgets `Tooltip`,
uma mudança que foi necessária para melhorar a experiência de acessibilidade.
Agora, em vez de construir o widget `BottomNavigationBarItem.title`,
o BottomNavigationBar envolve o
`BottomNavigationBarItem.label` em um widget Text e o constrói.

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

## Linha do tempo

Implementado na versão: 1.22.0
Na versão estável: 2.0.0

## Referências

Documentação da API:

* [`BottomNavigationBarItem`][]

PRs relevantes:

* [PR 60655][]: Limpar o escopo do controlador de hero
* [PR 59127][]: Atualizar BottomNavigationBar para mostrar tooltips em long press.

Proposta de breaking change:

* [Breaking Change: Bottom Navigation Item Title][]


[`BottomNavigationBarItem`]: {{site.api}}/flutter/widgets/BottomNavigationBarItem-class.html
[Breaking Change: Bottom Navigation Item Title]: /go/bottom-navigation-bar-title-deprecation
[PR 59127]: {{site.repo.flutter}}/pull/59127
[PR 60655]: {{site.repo.flutter}}/pull/60655
