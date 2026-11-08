---
title: Guia de migração para adicionar AppLifecycleState.hidden
description: AppLifecycleState teve um estado hidden adicional adicionado.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Um novo estado `hidden` foi adicionado ao enum [`AppLifecycleState`][] para denotar
quando a aplicação não está visível.

## Context

O enum `AppLifecycleState` é usado para indicar em qual estado de ciclo de vida a
aplicação está quando [`WidgetsBindingObserver.didChangeAppLifecycleState`][]
é chamado.

## Description of change

O novo estado `AppLifecycleState.hidden` foi adicionado ao enum `AppLifecycleState`
no pacote `dart:ui`.

O estado `hidden` é entrado quando todas as views da aplicação não estão mais
visíveis para o usuário. No Android e iOS, este estado é entrado brevemente sempre que
a máquina de estados atravessa de inactive para paused, ou de paused para inactive.
Ele não muda quando paused ou inactive são entrados. Em outras plataformas, ele
estará neste estado enquanto a aplicação não estiver visível.

## Migration guide

Se o código tem instruções switch que lidam com todos os casos do enum `AppLifecycleState`,
um novo caso precisará ser adicionado para lidar com o estado `AppLifecycleState.hidden`.

Code before migration:

```dart
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
    case AppLifecycleState.inactive:
      // Do something when the app is visible...
      break;
    case AppLifecycleState.paused:
    case AppLifecycleState.detached:
      // Do something when the app is not visible...
      break;
  }
}
```

Code after migration:

```dart
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
    case AppLifecycleState.inactive:
      // Do something when the app is visible...
      break;
    case AppLifecycleState.hidden:  // <-- This is the new state.
    case AppLifecycleState.paused:
    case AppLifecycleState.detached:
      // Do something when the app is not visible...
      break;
  }
}
```

Se já existe um caso `default:` na instrução switch, ou o código usa
condicionais em vez disso, então o código compilará sem mudanças, mas o
caso default ou condicional ainda precisará ser avaliado para decidir se o
estado `hidden` também deve ser tratado.

## Timeline

Landed in version: 3.11.0-16.0.pre<br>
In stable release: 3.13.0

## References

Relevant PRs:

* [PR 42418][]: Adds `AppLifecycleState.hidden` enum value

[PR 42418]: {{site.repo.engine}}/pull/42418
[`WidgetsBindingObserver.didChangeAppLifecycleState`]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html
[`AppLifecycleState`]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html
