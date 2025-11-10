---
ia-translate: true
title: SnackBar com action não fecha mais automaticamente
description: >-
  SnackBars com um botão de action agora têm como padrão não fechar automaticamente, a menos que
  sejam manualmente descartados pelo usuário.
---

{% render "docs/breaking-changes.md" %}

## Resumo

O comportamento padrão de um [`SnackBar`][] com uma action mudou.
Anteriormente, um `SnackBar` com uma action não fecharia
automaticamente se o talkback estivesse ativado.
Agora, todos os widgets `SnackBar` com uma action têm como padrão
um estado não descartável até que o usuário interaja com o botão de action.

## Contexto

Um `SnackBar` com um botão de action agora é tratado como
uma notificação mais persistente que requer interação do usuário.
Esta mudança melhora a acessibilidade e a experiência do usuário, garantindo que
notificações críticas permaneçam na tela até serem reconhecidas.

## Descrição da mudança

Esta mudança se alinha com a especificação de design do Material 3 para
o componente `SnackBar`:

* Comportamento antigo: Um `SnackBar` com um botão de action fecharia automaticamente após uma
  duração, a menos que o talkback estivesse ativado.
* Novo comportamento: Um `SnackBar` com um botão de action não fecha automaticamente;
  ele permanece na tela até ser descartado pelo usuário.

Para sobrescrever este comportamento, uma propriedade `persist` opcional foi
adicionada ao `SnackBar`.
Quando `persist` é `true`, o `SnackBar` não fecha automaticamente e
permanece na tela até ser manualmente descartado pelo usuário.
Quando `false`, o `SnackBar` fecha automaticamente após sua duração padrão,
independentemente da presença de uma action.
Quando `null`, o `SnackBar` segue o comportamento padrão,
que não fecha automaticamente se uma action estiver presente.

## Guia de migração

Para restaurar o comportamento antigo de fechamento automático para um SnackBar com uma action, defina
`persist` como `false`.

Código antes da migração:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('This is a snackbar with an action.'),
    action: SnackBarAction(
      label: 'Action',
      onPressed: () {
        // Perform some action
      },
    ),
  ),
);
```

Código após a migração:

```dart highlightLines=4
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: const Text('This is a snackbar with an action.'),
    persist: false, // Add this line to restore auto-dismiss behavior
    action: SnackBarAction(
      label: 'Action',
      onPressed: () {
        // Perform some action
      },
    ),
  ),
);
```

## Cronograma

Aterrissou na versão: 3.37.0-0.0.pre
No lançamento estável: 3.38

## Referências

Documentação da API:

* [`SnackBar`][]

PRs relevantes:

* [SnackBar with action no longer auto-dismisses][]

[`SnackBar`]: {{site.api}}/flutter/material/SnackBar-class.html

[SnackBar with action no longer auto-dismisses]: {{site.repo.flutter}}/pull/173084
