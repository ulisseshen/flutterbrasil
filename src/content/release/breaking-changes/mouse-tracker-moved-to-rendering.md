---
ia-translate: true
title: MouseTracker movido para rendering
description: MouseTracker e símbolos relacionados movidos para o pacote rendering.
---

{% render "docs/breaking-changes.md" %}

## Resumo

[`MouseTracker`][MouseTracker] e símbolos relacionados foram movidos do
pacote `gestures`, resultando em mensagens de erro como
classes ou métodos indefinidos. Importe-os do pacote
`rendering` em vez disso.

## Contexto

Antes desta mudança, [`MouseTracker`][MouseTracker] fazia parte do
pacote `gestures`. Isso trouxe problemas quando descobrimos
que o código relacionado a [`MouseTracker`][MouseTracker] frequentemente
precisava importar do pacote `rendering`.

Como [`MouseTracker`][MouseTracker] revelou-se mais conectado a
`rendering` do que a `gestures`, nós o movemos junto com seu
código relacionado para `rendering`.

## Descrição da mudança

O arquivo `mouse_tracking.dart` foi movido do pacote
`gestures` para `rendering`. Todos os símbolos no referido
arquivo foram movidos sem manter compatibilidade retroativa.

## Guia de migração

Se você ver erro de "Undefined class" ou "Undefined name" dos
seguintes símbolos:

* [`MouseDetectorAnnotationFinder`][MouseDetectorAnnotationFinder]
* [`MouseTracker`][MouseTracker]
* [`MouseTrackerAnnotation`][MouseTrackerAnnotation]
* [`PointerEnterEventListener`][PointerEnterEventListener]
* [`PointerExitEventListener`][PointerExitEventListener]
* [`PointerHoverEventListener`][PointerHoverEventListener]

Você deve adicionar a seguinte importação:

```dart
import 'package:flutter/rendering.dart';
```

## Linha do tempo

Landed in version: 1.16.3<br>
In stable release: 1.17

## Referências

Documentação da API:

* [`MouseDetectorAnnotationFinder`][MouseDetectorAnnotationFinder]
* [`MouseTracker`][MouseTracker]
* [`MouseTrackerAnnotation`][MouseTrackerAnnotation]
* [`PointerEnterEventListener`][PointerEnterEventListener]
* [`PointerExitEventListener`][PointerExitEventListener]
* [`PointerHoverEventListener`][PointerHoverEventListener]

Issues relevantes:

* [Transform mouse events to the local coordinate system][Transform mouse events to the local coordinate system]
* [Move annotations to a separate tree][Move annotations to a separate tree]

PR relevante:

* [Move mouse_tracking.dart to rendering][Move mouse_tracking.dart to rendering]

[Move annotations to a separate tree]: {{site.repo.flutter}}/issues/49568
[Move mouse_tracking.dart to rendering]: {{site.repo.flutter}}/pull/52781
[Transform mouse events to the local coordinate system]: {{site.repo.flutter}}/issues/33675
[MouseDetectorAnnotationFinder]: {{site.api}}/flutter/gestures/MouseDetectorAnnotationFinder.html
[MouseTracker]: {{site.api}}/flutter/gestures/MouseTracker-class.html
[MouseTrackerAnnotation]: {{site.api}}/flutter/gestures/MouseTrackerAnnotation-class.html
[PointerEnterEventListener]: {{site.api}}/flutter/gestures/PointerEnterEventListener.html
[PointerExitEventListener]: {{site.api}}/flutter/gestures/PointerExitEventListener.html
[PointerHoverEventListener]: {{site.api}}/flutter/gestures/PointerHoverEventListener.html
