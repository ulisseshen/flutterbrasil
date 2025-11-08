---
title: Guia de migração para adicionar AppLifecycleState.hidden
description: AppLifecycleState teve um estado hidden adicional adicionado.
ia-translate: true
---

## Resumo

Um novo estado `hidden` foi adicionado ao enum [`AppLifecycleState`][] para denotar
quando o aplicativo não está visível.

## Contexto

O enum `AppLifecycleState` é usado para indicar em qual estado do ciclo de vida o
aplicativo está quando [`WidgetsBindingObserver.didChangeAppLifecycleState`][]
é chamado.

## Descrição da mudança

O novo estado `AppLifecycleState.hidden` foi adicionado ao enum `AppLifecycleState`
no pacote `dart:ui`.

O estado `hidden` é entrado quando todas as views do aplicativo não estão mais
visíveis para o usuário. No Android e iOS, este estado é entrado brevemente sempre que
a máquina de estados atravessa de inactive para paused, ou de paused para inactive.
Ele não muda quando paused ou inactive são entrados. Em outras plataformas, estará
neste estado enquanto o aplicativo não estiver visível.

## Guia de migração

Se o código tem instruções switch que lidam com todos os casos do enum `AppLifecycleState`,
um novo caso precisará ser adicionado para lidar com o estado `AppLifecycleState.hidden`.

Código antes da migração:

```dart
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
    case AppLifecycleState.inactive:
      // Faça algo quando o app estiver visível...
      break;
    case AppLifecycleState.paused:
    case AppLifecycleState.detached:
      // Faça algo quando o app não estiver visível...
      break;
  }
}
```

Código após a migração:

```dart
void didChangeAppLifecycleState(AppLifecycleState state) {
  switch (state) {
    case AppLifecycleState.resumed:
    case AppLifecycleState.inactive:
      // Faça algo quando o app estiver visível...
      break;
    case AppLifecycleState.hidden:  // <-- Este é o novo estado.
    case AppLifecycleState.paused:
    case AppLifecycleState.detached:
      // Faça algo quando o app não estiver visível...
      break;
  }
}
```

Se já houver um caso `default:` na instrução switch, ou o código usar
condicionais em vez disso, então o código compilará sem mudanças, mas o
caso default ou condicional ainda precisará ser avaliado para decidir se o
estado `hidden` também deve ser tratado.

## Linha do tempo

Implementado na versão: 3.11.0-16.0.pre<br>
Na versão estável: 3.13.0

## Referências

PRs relevantes:

* [PR 42418][]: Adiciona valor enum `AppLifecycleState.hidden`

[PR 42418]: {{site.repo.engine}}/pull/42418
[`WidgetsBindingObserver.didChangeAppLifecycleState`]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html
[`AppLifecycleState`]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html
