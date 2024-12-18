---
ia-translate: true
title: Incorporando conteúdo web em um aplicativo Flutter web
short-title: Conteúdo web no Flutter
description: Aprenda como carregar e exibir imagens na web.
---

Em alguns casos, aplicativos Flutter web precisam incorporar conteúdo da web não
renderizado pelo Flutter. Por exemplo, incorporar uma view `google_maps_flutter`
(que usa o SDK JavaScript do Google Maps) ou um `video_player`
(que usa um elemento `video` padrão).

O Flutter web pode renderizar conteúdo web arbitrário dentro dos limites de um `Widget`,
e as primitivas usadas para implementar os pacotes de exemplo mencionados anteriormente,
estão disponíveis para todos os aplicativos Flutter web.

## `HtmlElementView`

O widget Flutter `HtmlElementView` reserva um espaço no layout para ser
preenchido com qualquer Elemento HTML. Ele possui dois construtores:

*   `HtmlElementView.fromTagName`.
*   `HtmlElementView` e `registerViewFactory`.

### `HtmlElementView.fromTagName`

O [`construtor HtmlElementView.fromTagName`][] cria um Elemento HTML a partir de
sua `tagName` e fornece um método `onElementCreated` para configurar esse
elemento antes que ele seja injetado no DOM:

```dart
// Cria uma tag `video` e define seu `src` e algumas propriedades `style`...
HtmlElementView.fromTag('video', onElementCreated: (Object video) {
  video as web.HTMLVideoElement;
  video.src = 'https://interactive-examples.mdn.mozilla.net/media/cc0-videos/flower.mp4';
  video.style.width = '100%';
  video.style.height = '100%';
  // outras customizações do elemento...
});
```

Para saber mais sobre a forma de interagir com as APIs do DOM,
confira a [`classe HTMLVideoElement`] em [`package:web`][].

Para saber mais sobre o objeto `video` que é convertido para `web.HTMLVideoElement`,
confira a documentação de [Interoperabilidade JS][] do Dart.

[`construtor HtmlElementView.fromTagName`]: {{site.api}}/flutter/widgets/HtmlElementView/HtmlElementView.fromTagName.html
[`classe HTMLVideoElement`]: {{site.pub}}/documentation/web/latest/web/HTMLVideoElement-extension-type.html
[`package:web`]: {{site.pub-pkg}}/web

### `HtmlElementView` e `registerViewFactory`

Se você precisar de mais controle sobre a geração do código HTML que você injeta, você pode usar
as primitivas que o Flutter usa para implementar o construtor `fromTagName`. Neste
cenário, registre sua própria fábrica de Elementos HTML para cada tipo de HTML
conteúdo que precisa ser adicionado ao seu aplicativo.

O código resultante é mais verboso e tem duas etapas por tipo de visualização de plataforma:

1.  Registre a Fábrica de Elementos HTML usando
    `platformViewRegistry.registerViewFactory` fornecido por `dart:ui_web`.
2.  Coloque o widget com o `viewType` desejado com
    `HtmlElementView('viewType')` na árvore de widgets do seu aplicativo.

Para mais detalhes sobre esta abordagem, confira
a documentação do [`widget HtmlElementView`][].

[`widget HtmlElementView`]: {{site.api}}/flutter/widgets/HtmlElementView-class.html

## `package:webview_flutter`

Incorporar uma página HTML completa dentro de um aplicativo Flutter é um recurso tão comum, que
a equipe do Flutter oferece um plugin para isso:

*   [`package:webview_flutter`][]

[Interoperabilidade JS]: {{site.dart-site}}/interop/js-interop
[`package:webview_flutter`]: {{site.pub}}/packages/webview_flutter
[`package:webview_flutter_web`]: {{site.pub}}/packages/webview_flutter_web
