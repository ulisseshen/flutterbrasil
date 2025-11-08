---
title: Rebuild optimization for OverlayEntries and Routes
description: OverlayEntries only rebuild on explicit state changes.
ia-translate: true
---

## Resumo

This optimization improves performance for route transitions,
but it may uncover missing calls to `setState` in your app.

## Contextoo

Prior to this change, an `OverlayEntry` would rebuild when
a new opaque entry was added on top of it or removed above it.
These rebuilds were unnecessary because they were not triggered
by a change in state of the affected `OverlayEntry`. This
breaking change optimized how we handle the addition and removal of
`OverlayEntry`s, and removes unnecessary rebuilds
to improve performance.

Since the `Navigator` internally puts each `Route` into an
`OverlayEntry` this change also applies to `Route` transitions:
If an opaque `Route` is pushed on top or removed from above another
`Route`, the `Route`s below the opaque `Route`
no longer rebuilds unnecessarily.

## Descrição da mudança

In most cases, this change doesn't require any changes to your code.
However, if your app was erroneously relying on the implicit
rebuilds you may see issues, which can be resolved by wrapping
any state change in a `setState` call.

Furthermore, this change slightly modified the shape of the
widget tree: Prior to this change,
the `OverlayEntry`s were wrapped in a `Stack` widget.
The explicit `Stack` widget was removed from the widget hierarchy.

## Guia de migração

If you're seeing issues after upgrading to a Flutter version
that included this change, audit your code for missing calls to
`setState`. In the example below, assigning the return value of
`Navigator.pushNamed` to `buttonLabel` is
implicitly modifying the state and it should be wrapped in an
explicit `setState` call.

Código antes da migração:

```dart
class FooState extends State<Foo> {
  String buttonLabel = 'Click Me';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Illegal state modification that should be wrapped in setState.
        buttonLabel = await Navigator.pushNamed(context, '/bar');
      },
      child: Text(buttonLabel),
    );
  }
}
```

Código após a migração:

```dart
class FooState extends State<Foo> {
  String buttonLabel = 'Click Me';
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final newLabel = await Navigator.pushNamed(context, '/bar');
        setState(() {
          buttonLabel = newLabel;
        });
      },
      child: Text(buttonLabel),
    );
  }
}
```

## Linha do tempo

Lançado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`setState`][]
* [`OverlayEntry`][]
* [`Overlay`][]
* [`Navigator`][]
* [`Route`][]
* [`OverlayRoute`][]

Issues relevantes:

* [Issue 45797][]

PRs relevantes:

* [Do not rebuild Routes when a new opaque Route is pushed on top][]
* [Reland "Do not rebuild Routes when a new opaque Route is pushed on top"][]


[Do not rebuild Routes when a new opaque Route is pushed on top]: {{site.repo.flutter}}/pull/48900
[Issue 45797]: {{site.repo.flutter}}/issues/45797
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Overlay`]: {{site.api}}/flutter/widgets/Overlay-class.html
[`OverlayEntry`]: {{site.api}}/flutter/widgets/OverlayEntry-class.html
[`OverlayRoute`]: {{site.api}}/flutter/widgets/OverlayRoute-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[Reland "Do not rebuild Routes when a new opaque Route is pushed on top"]: {{site.repo.flutter}}/pull/49376
