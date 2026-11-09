---
ia-translate: true
title: O widget Visibility não é mais focalizável por padrão quando maintainState está habilitado
description: >-
  O widget Visibility por padrão não retém mais implicitamente a focusabilidade
  para seu filho quando maintainState está habilitado.
---

{% render "docs/breaking-changes.md" %}

## Resumo
Esta mudança foi introduzida para corrigir um problema
onde os filhos ocultos de um `IndexedStack` seriam focalizáveis com eventos de teclado
(veja o [issue](https://github.com/flutter/flutter/issues/114213))
devido ao comportamento padrão do widget `Visibility` subjacente.

## Descrição da mudança
A mudança principal é que o widget `Visibility` não é mais focalizável por padrão
quando `maintainState` está habilitado.
Uma nova flag, `maintainFocusability`, deve ser definida como true junto com `maintainState`
para que um widget oculto permaneça focalizável.

## Guia de migração
Se seu app tem um widget `Visibility` que não define `maintainState` como true,
então nenhuma mudança é necessária.

Se seu app tem um widget `Visibility` que define `maintainState` como true
e você dependia do comportamento padrão anterior
que permitia focalizar seu widget oculto,
você precisará definir `maintainFocusability` como true.

Código antes da migração:

```dart
child: Visibility(
    maintainState: true,
    child: SomeWidget(),
)
```

Código após a migração:

```dart
child: Visibility(
    maintainState: true,
    maintainFocusability: true,
    child: SomeWidget(),
)
```

## Linha do tempo

Lançado na versão: 3.34.0-pre<br>
No release estável: 3.35

## Referências

Documentação da API:

* [`Visibility`]({{site.api}}/flutter/widgets/Visibility-class.html)

Issues relevantes:

* [Issue 114213]({{site.repo.flutter}}/issues/114213)

PRs relevantes:

* [PR 159133: Add flag to exclude focus for hidden children in Visibility, maintainFocusability. Set maintainFocusability to false in IndexedStack]({{site.repo.flutter}}/pull/159133)
