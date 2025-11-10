---
title: Deprecate `OverlayPortal.targetsRootOverlay`
description: >-
  Learn about changes to the OverlayPortal in Flutter.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

The `OverlayPortal.targetsRootOverlay` property was deprecated and
replaced with `overlayLocation`.

## Contexto

A `overlayLocation` parameter was added to
the `OverlayPortal` default constructor to
control where the overlay child renders.
As a result, the `OverlayPortal.targetsRootOverlay` constructor is
no longer useful.

## Descrição da mudança

The `OverlayPortal.targetsRootOverlay` constructor is deprecated.

## Guia de migração

If you are using `OverlayPortal.targetsRootOverlay`,
use `OverlayPortal` with `overlayLocation` instead.

### Case 1: trivial case

Code before migration:

```dart
Widget build(BuildContext context) {
  return OverlayPortal.targetsRootOverlay(
    controller: myController,
    overlayChildBuilder: _myBuilder,
    child: myChild,
  );
}
```

Code after migration:

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

## Linha do tempo

Landed in version: 3.38.0-0.1.pre<br>
In stable release: 3.38

## Referências

API documentation:

* [`OverlayPortal`][]

Relevant issue:

* [Issue 168785][]

Relevant PR:

* [PR 174239][]

[`OverlayPortal`]: {{site.api}}/flutter/widgets/OverlayPortal-class.html
[Issue 168785]: {{site.repo.flutter}}/issues/168785
[PR 174239]: {{site.repo.flutter}}/pull/174239
