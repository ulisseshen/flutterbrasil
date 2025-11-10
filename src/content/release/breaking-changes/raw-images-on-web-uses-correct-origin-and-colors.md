---
title: Imagens raw na Web usam origem e cores corretas
description: >
  Imagens raw decodificadas diretamente chamando as funções do motor Web agora
  usam o formato de pixel correto e começam do canto superior esquerdo.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Summary

Como imagens raw são renderizadas na Web foi corrigido
e agora é consistente com o de outras plataformas.
Isso quebra aplicações legadas que tinham que fornecer dados incorretos
para `ui.ImageDescriptor.raw` ou `ui.decodeImageFromPixels`,
fazendo com que as imagens resultantes ficassem de cabeça para baixo
e com cores incorretas
(cujos canais vermelho e azul são trocados.)

## Context

O "pixel stream" que o Flutter usa internamente
sempre foi definido no mesmo formato:
para cada pixel, quatro canais de 8 bits são empacotados na ordem definida
por um argumento `format`, então agrupados em uma linha,
da esquerda para a direita, depois linhas de cima para baixo.

No entanto, Flutter para Web, ou mais especificamente, o renderer HTML,
costumava implementá-lo de forma errada
devido a uma compreensão incorreta da especificação do formato BMP.
Como resultado, se a aplicação ou biblioteca usa
`ui.ImageDescriptor.raw` ou `ui.decodeImageFromPixels`,
ela tinha que fornecer pixels de baixo para cima e trocar seus canais vermelho e azul
(por exemplo, com o formato `ui.PixelFormat.rgba8888`,
os primeiros 4 bytes dos dados eram considerados os canais azul, verde,
vermelho e alfa do primeiro pixel.)

Este bug foi corrigido por [engine#29593][],
mas aplicações e bibliotecas precisam corrigir como seus dados são gerados.

## Description of change

O argumento `pixels` de `ui.ImageDescriptor.raw` ou `ui.decodeImageFromPixels`
agora usa a ordem de pixel correta descrita por `format`,
e se origina do canto superior esquerdo.

Imagens renderizadas chamando diretamente essas duas funções
Código legado que invoca essas funções diretamente pode
encontrar suas imagens de cabeça para baixo e coloridas incorretamente.

## Migration guide

Se a aplicação usa a versão mais recente do Flutter e experimenta esta situação,
a solução mais direta é inverter manualmente a imagem, e usar o formato de
pixel alternativo. No entanto, esta provavelmente não é a solução mais otimizada,
já que tais dados de pixel são geralmente construídos de outras fontes,
permitindo a inversão durante o processo de construção.

Code before migration:

```dart
import 'dart:typed_data';
import 'dart:ui' as ui;

// Parse `image` as a displayable image.
//
// Each byte in `image` is a pixel channel, in the order of blue, green, red,
// and alpha, starting from the bottom left corner and going row first.
Future<ui.Image> parseMyImage(Uint8List image, int width, int height) async {
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    await ui.ImmutableBuffer.fromUint8List(image),
    width: width,
    height: height,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  return (await (await descriptor.instantiateCodec()).getNextFrame()).image;
}
```

Code after migration:

```dart
import 'dart:typed_data';
import 'dart:ui' as ui;

Uint8List verticallyFlipImage(Uint8List sourceBytes, int width, int height) {
  final Uint32List source = Uint32List.sublistView(ByteData.sublistView(sourceBytes));
  final Uint32List result = Uint32List(source.length);
  int sourceOffset = 0;
  int resultOffset = 0;
  for (final int row = height - 1; row >= 0; row -= 1) {
    sourceOffset = width * row;
    for (final int col = 0; col < width; col += 1) {
      result[resultOffset] = source[sourceOffset];
      resultOffset += 1;
      sourceOffset += 1;
    }
  }
  return Uint8List.sublistView(ByteData.sublistView(sourceBytes))
}

Future<ui.Image> parseMyImage(Uint8List image, int width, int height) async {
  final Uint8List correctedImage = verticallyFlipImage(image, width, height);
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    await ui.ImmutableBuffer.fromUint8List(correctedImage),
    width: width,
    height: height,
    pixelFormat: ui.PixelFormat.rgba8888,
  );
  return (await (await descriptor.instantiateCodec()).getNextFrame()).image;
}
```

Uma situação mais complicada é quando você está escrevendo uma biblioteca,
e você quer que esta biblioteca funcione tanto no Flutter mais recente
quanto em um pré-patch. Nesse caso, você pode decidir se o comportamento foi alterado
deixando-o decodificar um único pixel primeiro.

Code after migration:

```dart
Uint8List verticallyFlipImage(Uint8List sourceBytes, int width, int height) {
  // Same as the example above.
}

late Future<bool> imageRawUsesCorrectBehavior = (() async {
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    await ui.ImmutableBuffer.fromUint8List(Uint8List.fromList(<int>[0xED, 0, 0, 0xFF])),
    width: 1, height: 1, pixelFormat: ui.PixelFormat.rgba8888);
  final ui.Image image = (await (await descriptor.instantiateCodec()).getNextFrame()).image;
  final Uint8List resultPixels = Uint8List.sublistView(
    (await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba))!);
  return resultPixels[0] == 0xED;
})();

Future<ui.Image> parseMyImage(Uint8List image, int width, int height) async {
  final Uint8List correctedImage = (await imageRawUsesCorrectBehavior) ?
    verticallyFlipImage(image, width, height) : image;
  final ui.ImageDescriptor descriptor = ui.ImageDescriptor.raw(
    await ui.ImmutableBuffer.fromUint8List(correctedImage), // Use the corrected image
    width: width,
    height: height,
    pixelFormat: ui.PixelFormat.bgra8888, // Use the alternate format
  );
  return (await (await descriptor.instantiateCodec()).getNextFrame()).image;
}
```

## Timeline

Landed in version: 2.9.0-0.0.pre<br>
In stable release: 2.10

## References

API documentation:

* [`decodeImageFromPixels`][]
* [`ImageDescriptor.raw`][]

Relevant issues:

* [Web: Regression in Master - PDF display distorted due to change in BMP Encoder][]
* [Web: ImageDescriptor.raw flips and inverts images (partial reason included)][]

Relevant PRs:

* [Web: Reland: Fix BMP encoder][]
* [Clarify ImageDescriptor.raw pixel order and add version detector][]

[`decodeImageFromPixels`]: {{site.api}}/flutter/dart-ui/decodeImageFromPixels.html
[`ImageDescriptor.raw`]: {{site.api}}/flutter/dart-ui/ImageDescriptor/ImageDescriptor.raw.html

[Web: Regression in Master - PDF display distorted due to change in BMP Encoder]: {{site.repo.flutter}}/issues/93615
[Web: ImageDescriptor.raw flips and inverts images (partial reason included)]: {{site.repo.flutter}}/issues/89610

[engine#29593]: {{site.repo.engine}}/pull/29593
[Web: Reland: Fix BMP encoder]: {{site.repo.engine}}/pull/29593
[Clarify ImageDescriptor.raw pixel order and add version detector]: {{site.repo.engine}}/pull/30343
