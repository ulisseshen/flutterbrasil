---
title: MouseTracker movido para rendering
description: MouseTracker e símbolos relacionados movidos para o pacote rendering.
ia-translate: true
---

## Resumo

[`MouseTracker`][] e símbolos relacionados foram movidos do
pacote `gestures`, resultando em mensagens de erro como
classes ou métodos indefinidos. Importe-os do pacote `rendering`
em vez disso.

## Contexto

Antes desta mudança, [`MouseTracker`][] fazia parte do
pacote `gestures`. Isso trouxe problemas quando descobrimos
que o código relacionado ao [`MouseTracker`][] frequentemente queria
importar do pacote `rendering`.

Como [`MouseTracker`][] se revelou mais conectado a
`rendering` do que a `gestures`, nós o movemos junto com seu
código relacionado para `rendering`.

## Descrição da mudança

O arquivo `mouse_tracking.dart` foi movido do
pacote `gestures` para `rendering`. Todos os símbolos no arquivo mencionado
foram movidos sem manter compatibilidade retroativa.

## Guia de migração

Se você vir erro de "Undefined class" ou "Undefined name" dos
seguintes símbolos:

* [`MouseDetectorAnnotationFinder`][]
* [`MouseTracker`][]
* [`MouseTrackerAnnotation`][]
* [`PointerEnterEventListener`][]
* [`PointerExitEventListener`][]
* [`PointerHoverEventListener`][]

Você deve adicionar o seguinte import:

```dart
import 'package:flutter/rendering.dart';
```

## Linha do tempo

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`MouseDetectorAnnotationFinder`][]
* [`MouseTracker`][]
* [`MouseTrackerAnnotation`][]
* [`PointerEnterEventListener`][]
* [`PointerExitEventListener`][]
* [`PointerHoverEventListener`][]

Issues relevantes:

* [Transform mouse events to the local coordinate system][]
* [Move annotations to a separate tree][]

PR relevante:

* [Move mouse_tracking.dart to rendering][]

[Move annotations to a separate tree]: {{site.repo.flutter}}/issues/49568
[Move mouse_tracking.dart to rendering]: {{site.repo.flutter}}/pull/52781 
[Transform mouse events to the local coordinate system]: {{site.repo.flutter}}/issues/33675
[`MouseDetectorAnnotationFinder`]: {{site.api}}/flutter/gestures/MouseDetectorAnnotationFinder.html
[`MouseTracker`]: {{site.api}}/flutter/gestures/MouseTracker-class.html
[`MouseTrackerAnnotation`]: {{site.api}}/flutter/gestures/MouseTrackerAnnotation-class.html 
[`PointerEnterEventListener`]: {{site.api}}/flutter/gestures/PointerEnterEventListener.html 
[`PointerExitEventListener`]: {{site.api}}/flutter/gestures/PointerExitEventListener.html 
[`PointerHoverEventListener`]: {{site.api}}/flutter/gestures/PointerHoverEventListener.html 
