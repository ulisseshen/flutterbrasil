---
ia-translate: true
title: MouseTracker movido para rendering
description: MouseTracker e símbolos relacionados movidos para o pacote rendering.
---

## Resumo

[`MouseTracker`][] e símbolos relacionados foram movidos do
pacote `gestures`, resultando em mensagens de erro como
classes ou métodos indefinidos. Importe-os do pacote `rendering`
em vez disso.

## Contexto

Antes desta mudança, [`MouseTracker`][] fazia parte do
pacote `gestures`. Isso trouxe problemas quando descobrimos
que o código relacionado a [`MouseTracker`][] frequentemente queria
importar do pacote `rendering`.

Como [`MouseTracker`][] acabou estando mais conectado a
`rendering` do que a `gestures`, nós o movemos e seu
código relacionado para `rendering`.

## Descrição da mudança

O arquivo `mouse_tracking.dart` foi movido do
pacote `gestures` para `rendering`. Todos os símbolos no referido
arquivo foram movidos sem manter compatibilidade com versões anteriores.

## Guia de migração

Se você vir um erro de "Classe indefinida" ou "Nome indefinido" dos
seguintes símbolos:

* [`MouseDetectorAnnotationFinder`][]
* [`MouseTracker`][]
* [`MouseTrackerAnnotation`][]
* [`PointerEnterEventListener`][]
* [`PointerExitEventListener`][]
* [`PointerHoverEventListener`][]

Você deve adicionar a seguinte importação:

```dart
import 'package:flutter/rendering.dart';
```

## Cronograma

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

* [Transformar eventos de mouse para o sistema de coordenadas local][]
* [Mover anotações para uma árvore separada][]

PR relevante:

* [Mover mouse_tracking.dart para rendering][]

[Transformar eventos de mouse para o sistema de coordenadas local]: {{site.repo.flutter}}/issues/33675
[Mover anotações para uma árvore separada]: {{site.repo.flutter}}/issues/49568
[Mover mouse_tracking.dart para rendering]: {{site.repo.flutter}}/pull/52781
[`MouseDetectorAnnotationFinder`]: {{site.api}}/flutter/gestures/MouseDetectorAnnotationFinder.html
[`MouseTracker`]: {{site.api}}/flutter/gestures/MouseTracker-class.html
[`MouseTrackerAnnotation`]: {{site.api}}/flutter/gestures/MouseTrackerAnnotation-class.html
[`PointerEnterEventListener`]: {{site.api}}/flutter/gestures/PointerEnterEventListener.html
[`PointerExitEventListener`]: {{site.api}}/flutter/gestures/PointerExitEventListener.html
[`PointerHoverEventListener`]: {{site.api}}/flutter/gestures/PointerHoverEventListener.html
