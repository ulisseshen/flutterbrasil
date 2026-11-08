---
ia-translate: true
title: Incorporando conteúdo web em um app web Flutter
shortTitle: Conteúdo web no Flutter
description: >-
  Aprenda como incorporar conteúdo web, entender a sobreposição de slots do DOM
  e lidar com eventos de ponteiro em apps web Flutter.
---

Em alguns casos, aplicações web Flutter precisam incorporar conteúdo web não
renderizado pelo Flutter. Por exemplo, incorporar uma view `google_maps_flutter`
(que usa o SDK JavaScript do Google Maps) ou um `video_player`
(que usa um elemento `video` padrão).

Flutter web pode renderizar conteúdo web arbitrário
dentro dos limites de um `Widget`,
e as primitivas usadas para implementar os pacotes de exemplo mencionados anteriormente
estão disponíveis para todas as aplicações web Flutter.

## HtmlElementView

O widget Flutter `HtmlElementView` reserva um espaço no layout para ser
preenchido com qualquer elemento HTML. Ele tem dois construtores:

* `HtmlElementView.fromTagName`
* `HtmlElementView` e `registerViewFactory`

### `HtmlElementView.fromTagName`

O [construtor `HtmlElementView.fromTagName`][`HtmlElementView.fromTagName` constructor] cria um elemento HTML a partir de
sua `tagName`, e fornece um método `onElementCreated` para configurar esse
elemento antes de ser injetado no DOM:

```dart
// Create a `video` tag, and set its `src` and some `style` properties...
HtmlElementView.fromTagName(
  tagName: 'video',
  onElementCreated: (Object video) {
    video as web.HTMLVideoElement;
    video.src =
        'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
    video.style.width = '100%';
    video.style.height = '100%';
    // other customizations to the element...
  },
);
```

Para saber mais sobre como interagir com APIs DOM,
confira a [classe `HTMLVideoElement`][`HTMLVideoElement` class] no [`package:web`][`package:web`].

Para saber mais sobre o `Object` video que é convertido para `web.HTMLVideoElement`,
confira a documentação [JS Interoperability][JS Interoperability] do Dart.

### `HtmlElementView` e `registerViewFactory`

Se você precisa de mais controle sobre a geração do código HTML que você injeta,
pode usar as primitivas que o Flutter usa para implementar
o construtor `fromTagName`.
Neste cenário, registre sua própria factory de elemento HTML
para cada tipo de conteúdo HTML que você adiciona ao seu app.

O código resultante tem duas etapas por tipo de view de plataforma:

1. Registre a factory de elemento HTML usando
   `platformViewRegistry.registerViewFactory` fornecido por `dart:ui_web`.
1. Coloque o widget com o `viewType` desejado usando
   `HtmlElementView(viewType: 'viewType')` na árvore de widgets do seu app.

Para mais detalhes sobre esta abordagem, confira
a documentação do [widget `HtmlElementView`][`HtmlElementView` widget].

## Corrigindo problemas de hit testing {:#fixing-hit-testing-issues}

Por causa da forma como o Flutter web realiza o hit testing,
platform views subjacentes podem às vezes capturar
eventos de ponteiro antes que eles cheguem ao Flutter.

Para evitar a perda de eventos de ponteiro destinados a widgets Flutter,
use o pacote [`package:pointer_interceptor`][].

O widget [`PointerInterceptor`][] cria
uma platform view vazia e transparente
e a posiciona diretamente atrás do seu widget filho na ordem de pintura.
Esse elemento transparente captura os eventos de ponteiro do navegador
antes que eles cheguem ao `HtmlElementView` subjacente,
permitindo que o framework de gestos do Flutter trate a interação como esperado.

### Adicione a dependência {:#add-the-dependency}

Adicione `pointer_interceptor` ao seu arquivo `pubspec.yaml`:

```yaml
dependencies:
  pointer_interceptor: ^0.10.1+2
```

### Envolva widgets interativos {:#wrap-interactive-widgets}

Para tornar um widget interativo individual clicável sobre um `HtmlElementView`
(como um [`FloatingActionButton`][] ou [`ElevatedButton`][]),
envolva o widget com `PointerInterceptor`:

```dart
PointerInterceptor(
  child: FloatingActionButton(
    onPressed: () {
      // Handle button press
    },
    child: const Icon(Icons.add),
  ),
)
```

### Envolva containers de layout e de sobreposição {:#wrap-layout-and-overlay-containers}

Quando você usa componentes de sobreposição que cobrem uma platform view,
como um [`Drawer`][], um diálogo ou um menu popup,
envolva o widget container em um `PointerInterceptor`:

```dart
Scaffold(
  drawer: PointerInterceptor(
    child: Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Home'),
            onTap: () {
              // Handle navigation
            },
          ),
        ],
      ),
    ),
  ),
  body: HtmlElementView.fromTagName(tagName: 'iframe'),
)
```

### Intercepte eventos condicionalmente {:#conditionally-intercept-events}

A propriedade `intercepting` permite habilitar ou desabilitar a interceptação de ponteiro
com base em uma condição booleana:

```dart
PointerInterceptor(
  intercepting: isOverlayVisible,
  child: ElevatedButton(
    onPressed: () {
      // Handle button press
    },
    child: const Text('Submit'),
  ),
)
```

Quando `intercepting` é `false`, o `PointerInterceptor` renderiza seu `child`
diretamente, sem criar uma platform view extra no DOM.

### Depure os limites do interceptor {:#debug-interceptor-bounds}

O widget `PointerInterceptor` inclui uma propriedade `debug`.
Definir `debug: true` renderiza uma sobreposição colorida visível
sobre a área do interceptor,
ajudando você a verificar o tamanho e a posição da região interceptada:

```dart
PointerInterceptor(
  debug: true,
  child: ElevatedButton(
    onPressed: () {},
    child: const Text('Click me'),
  ),
)
```

## `package:webview_flutter`

Incorporar uma página HTML completa dentro de um app Flutter é uma necessidade comum.
A equipe Flutter oferece um plugin para esse propósito:

* [`package:webview_flutter`][`package:webview_flutter`]

[JS Interoperability]: {{site.dart-site}}/interop/js-interop
[`Drawer`]: {{site.material_ui}}/Drawer-class.html
[`ElevatedButton`]: {{site.material_ui}}/ElevatedButton-class.html
[`FloatingActionButton`]: {{site.material_ui}}/FloatingActionButton-class.html
[`HtmlElementView.fromTagName` constructor]: {{site.api}}/flutter/widgets/HtmlElementView/HtmlElementView.fromTagName.html
[`HtmlElementView` widget]: {{site.api}}/flutter/widgets/HtmlElementView-class.html
[`HTMLVideoElement` class]: {{site.pub}}/documentation/web/latest/web/HTMLVideoElement-extension-type.html
[`package:pointer_interceptor`]: {{site.pub-pkg}}/pointer_interceptor
[`package:web`]: {{site.pub-pkg}}/web
[`package:webview_flutter`]: {{site.pub-pkg}}/webview_flutter
[`package:webview_flutter_web`]: {{site.pub-pkg}}/webview_flutter_web
[`PointerInterceptor`]: {{site.pub-api}}/pointer_interceptor/latest/pointer_interceptor/PointerInterceptor-class.html
