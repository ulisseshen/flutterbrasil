---
ia-translate: true
title: Guia de migração para adicionar AppLifecycleState.hidden
description: AppLifecycleState teve um estado hidden adicional adicionado.
---

## Resumo

Um novo estado `hidden` foi adicionado ao enum [`AppLifecycleState`][] para
indicar quando o aplicativo não está visível.

## Contexto

O enum `AppLifecycleState` é usado para indicar em qual estado do ciclo de vida
o aplicativo está quando [`WidgetsBindingObserver.didChangeAppLifecycleState`][]
é chamado.

## Descrição da mudança

O novo estado `AppLifecycleState.hidden` foi adicionado ao enum `AppLifecycleState`
no pacote `dart:ui`.

O estado `hidden` é inserido quando todas as visualizações do aplicativo não estão
mais visíveis para o usuário. No Android e no iOS, esse estado é inserido
brevemente sempre que a máquina de estados atravessa de inativo para pausado ou de
pausado para inativo. Ele não muda quando pausado ou inativo são inseridos. Em
outras plataformas, ele estará neste estado enquanto o aplicativo não estiver
visível.

## Guia de migração

Se o código tiver instruções switch que lidam com todos os casos do enum
`AppLifecycleState`, um novo caso precisará ser adicionado para lidar com o
estado `AppLifecycleState.hidden`.

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

Se já houver um caso `default:` na instrução switch, ou se o código usar
condicionais, o código será compilado sem alterações, mas o caso default ou o
condicional ainda precisará ser avaliado para decidir se o estado `hidden`
também deve ser tratado.

## Cronograma

Incluído na versão: 3.11.0-16.0.pre<br>
Na versão estável: 3.13.0

## Referências

PRs relevantes:

* [PR 42418][]: Adiciona o valor de enum `AppLifecycleState.hidden`

[PR 42418]: {{site.repo.engine}}/pull/42418
[`WidgetsBindingObserver.didChangeAppLifecycleState`]: {{site.api}}/flutter/widgets/WidgetsBindingObserver/didChangeAppLifecycleState.html
[`AppLifecycleState`]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html
