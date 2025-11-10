---
ia-translate: true
---

## Performance

Platform views no Flutter vêm com trade-offs de performance.

Por exemplo, em um app Flutter típico, a UI Flutter é composta
em uma thread de rasterização dedicada. Isso permite que apps Flutter sejam rápidos,
já que a thread principal da plataforma raramente é bloqueada.

Enquanto uma platform view é renderizada com hybrid composition,
a UI Flutter é composta da thread da plataforma,
que compete com outras tarefas como lidar com mensagens do OS ou de plugins.

Antes do Android 10, hybrid composition copiava cada frame Flutter
da memória gráfica para a memória principal, e então copiava de volta
para uma textura GPU. Como esta cópia acontece por frame, a performance de
toda a UI Flutter pode ser impactada. No Android 10 ou superior, a
memória gráfica é copiada apenas uma vez.

Virtual display, por outro lado,
faz com que cada pixel da view nativa
flua através de buffers gráficos intermediários adicionais,
o que custa memória gráfica e performance de desenho.

Para casos complexos, há algumas técnicas que
podem ser usadas para mitigar esses problemas.

Por exemplo, você poderia usar uma textura placeholder
enquanto uma animação está acontecendo em Dart.
Em outras palavras, se uma animação está lenta enquanto uma
platform view é renderizada,
então considere tirar uma screenshot da
view nativa e renderizá-la como uma textura.

Para mais informações, veja:

* [`TextureLayer`][`TextureLayer`]
* [`TextureRegistry`][`TextureRegistry`]
* [`FlutterTextureRegistry`][`FlutterTextureRegistry`]
* [`FlutterImageView`][`FlutterImageView`]

[`FlutterImageView`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterImageView.html
[`FlutterTextureRegistry`]: {{site.api}}/ios-embedder/protocol_flutter_texture_registry-p.html
[`TextureLayer`]: {{site.api}}/flutter/rendering/TextureLayer-class.html
[`TextureRegistry`]: {{site.api}}/javadoc/io/flutter/view/TextureRegistry.html
