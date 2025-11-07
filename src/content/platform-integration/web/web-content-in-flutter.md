---
ia-translate: true
title: Incorporando conteúdo web em um app Flutter web
short-title: Conteúdo web no Flutter
description: Aprenda como carregar e exibir imagens na web.
---

Em alguns casos, aplicações Flutter web precisam incorporar conteúdo web não
renderizado pelo Flutter. Por exemplo, incorporar uma view `google_maps_flutter`
(que usa o SDK JavaScript do Google Maps) ou um `video_player`
(que usa um elemento `video` padrão).

Flutter web pode renderizar conteúdo web arbitrário dentro dos limites de um `Widget`,
e as primitivas usadas para implementar os pacotes de exemplo mencionados anteriormente,
estão disponíveis para todas as aplicações Flutter web.

## `HtmlElementView`

O widget Flutter `HtmlElementView` reserva um espaço no layout para ser
preenchido com qualquer HTML Element. Ele tem dois construtores:

* `HtmlElementView.fromTagName`.
* `HtmlElementView` e `registerViewFactory`.

### `HtmlElementView.fromTagName`

O [construtor `HtmlElementView.fromTagName`][`HtmlElementView.fromTagName` constructor] cria um HTML Element a partir de
seu `tagName`, e fornece um método `onElementCreated` para configurar esse
elemento antes de ser injetado no DOM:

```dart
// Create a `video` tag, and set its `src` and some `style` properties...
HtmlElementView.fromTag('video', onElementCreated: (Object video) {
  video as web.HTMLVideoElement;
  video.src = 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
  video.style.width = '100%';
  video.style.height = '100%';
  // other customizations to the element...
});
```

Para aprender mais sobre a maneira de interagir com APIs DOM,
confira a [classe `HTMLVideoElement`][`HTMLVideoElement` class] em [`package:web`][].

Para aprender mais sobre o objeto `video` que é convertido para `web.HTMLVideoElement`,
confira a documentação de [JS Interoperability][] do Dart.

[`HtmlElementView.fromTagName` constructor]: {{site.api}}/flutter/widgets/HtmlElementView/HtmlElementView.fromTagName.html
[`HTMLVideoElement` class]: {{site.pub}}/documentation/web/latest/web/HTMLVideoElement-extension-type.html
[`package:web`]: {{site.pub-pkg}}/web

### `HtmlElementView` e `registerViewFactory`

Se você precisar de mais controle sobre a geração do código HTML que injeta, você pode usar
as primitivas que o Flutter usa para implementar o construtor `fromTagName`. Neste
cenário, registre sua própria factory de HTML Element para cada tipo de conteúdo HTML
que precisa ser adicionado ao seu app.

O código resultante é mais verboso, e tem duas etapas por tipo de platform view:

1. Registre a HTML Element Factory usando
`platformViewRegistry.registerViewFactory` fornecido por `dart:ui_web.`
2. Coloque o widget com o `viewType` desejado com
`HtmlElementView('viewType')` na árvore de widgets do seu app.

Para mais detalhes sobre esta abordagem, confira
a documentação do [widget `HtmlElementView`][`HtmlElementView` widget].

[`HtmlElementView` widget]: {{site.api}}/flutter/widgets/HtmlElementView-class.html

## `package:webview_flutter`

Incorporar uma página HTML completa dentro de um app Flutter é um recurso tão comum, que
a equipe Flutter oferece um plugin para fazer isso:

* [`package:webview_flutter`][]

[JS Interoperability]: {{site.dart-site}}/interop/js-interop
[`package:webview_flutter`]: {{site.pub}}/packages/webview_flutter
[`package:webview_flutter_web`]: {{site.pub}}/packages/webview_flutter_web
