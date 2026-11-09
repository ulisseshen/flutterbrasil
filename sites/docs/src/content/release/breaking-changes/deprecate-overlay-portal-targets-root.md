---
title: Deprecate `OverlayPortal.targetsRootOverlay` and enforce `LookupBoundary` in `Overlay.of`
description: >-
  Saiba mais sobre as mudanças no OverlayPortal e no Overlay no Flutter.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

A propriedade `OverlayPortal.targetsRootOverlay` foi descontinuada e
substituída por `overlayLocation`.

`Overlay.of` e `Overlay.maybeOf` agora respeitam `LookupBoundary`.

## Contexto {:#context}

Um parâmetro `overlayLocation` foi adicionado ao
construtor padrão de `OverlayPortal` para
controlar onde o filho do overlay é renderizado.
Como resultado, o construtor `OverlayPortal.targetsRootOverlay`
não é mais útil.

Para evitar que um `OverlayEntry` seja inserido através de limites de múltiplas views
por engano, `Overlay.of` agora respeita `LookupBoundary`.

## Descrição da mudança {:#description-of-change}

O construtor `OverlayPortal.targetsRootOverlay` está descontinuado.

`Overlay.of` e `Overlay.maybeOf` não farão a busca além de `LookupBoundary`.

## Guia de migração {:#migration-guide}

Se você está usando `OverlayPortal.targetsRootOverlay`,
use `OverlayPortal` com `overlayLocation` em vez disso.

### Caso 1: caso trivial {:#case-1-trivial-case}

Código antes da migração:

```dart
Widget build(BuildContext context) {
  return OverlayPortal.targetsRootOverlay(
    controller: myController,
    overlayChildBuilder: _myBuilder,
    child: myChild,
  );
}
```

Código após a migração:

```dart highlightLines=3
Widget build(BuildContext context) {
  return OverlayPortal(
    overlayLocation: OverlayChildLocation.rootOverlay,
    controller: myController,
    overlayChildBuilder: _myBuilder,
    child: myChild,
  );
}
```

Se você espera que `Overlay.of` e `Overlay.maybeOf` façam a busca além de `LookupBoundary`,
use `findAncestorStateOfType` em vez disso.

Código antes da migração:

```dart
Widget build(BuildContext context) {
  Overlay.of(context);
  // ...
}
```

Código após a migração:

```dart
Widget build(BuildContext context) {
  context.findAncestorStateOfType<OverlayState>();
  // ...
}
```

## Linha do tempo {:#timeline}

Disponibilizado na versão: 3.38.0-0.1.pre<br>
Na versão stable: 3.38

## Referências {:#references}

Documentação da API:

* [`OverlayPortal`][]
* [`Overlay.of`][]
* [`Overlay.maybeOf`][]
* [`LookupBoundary`][]

Issue relevante:

* [Issue 168785][]

PR relevante:

* [PR 174239][]

[`OverlayPortal`]: {{site.api}}/flutter/widgets/OverlayPortal-class.html
[`Overlay.of`]: {{site.api}}/flutter/widgets/Overlay/of.html
[`Overlay.maybeOf`]: {{site.api}}/flutter/widgets/Overlay/maybeOf.html
[`LookupBoundary`]: {{site.api}}/flutter/widgets/LookupBoundary-class.html
[Issue 168785]: {{site.repo.flutter}}/issues/168785
[PR 174239]: {{site.repo.flutter}}/pull/174239
