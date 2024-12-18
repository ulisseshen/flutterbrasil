---
ia-translate: true
title: Imagens brutas na Web usam origem e cores corretas
description: >
  Imagens brutas decodificadas diretamente chamando as funções do mecanismo Web
  agora usam o formato de pixel correto e começam do canto superior esquerdo.
---

## Resumo

A forma como as imagens brutas são renderizadas na Web foi corrigida
e agora está consistente com a de outras plataformas.
Isso quebra aplicativos legados que tinham que alimentar dados incorretos
para `ui.ImageDescriptor.raw` ou `ui.decodeImageFromPixels`,
fazendo com que as imagens resultantes ficassem de cabeça para baixo
e com cores incorretas
(cujos canais vermelho e azul são trocados).

## Contexto

O "fluxo de pixels" que o Flutter usa internamente
sempre foi definido como o mesmo formato:
para cada pixel, quatro canais de 8 bits são empacotados na ordem definida
por um argumento `format`, depois agrupados em uma linha,
da esquerda para a direita, depois as linhas de cima para baixo.

No entanto, o Flutter para Web, ou mais especificamente, o renderizador HTML,
costumava implementá-lo de forma errada
devido à compreensão incorreta da especificação do formato BMP.
Como resultado, se o aplicativo ou biblioteca usa
`ui.ImageDescriptor.raw` ou `ui.decodeImageFromPixels`,
ele tinha que alimentar os pixels de baixo para cima e trocar seus canais vermelho e azul
(por exemplo, com o formato `ui.PixelFormat.rgba8888`,
os primeiros 4 bytes dos dados eram considerados os canais azul, verde,
vermelho e alfa do primeiro pixel.)

Este bug foi corrigido por [engine#29593][],
mas aplicativos e bibliotecas têm que corrigir como seus dados são gerados.

## Descrição da mudança

O argumento `pixels` de `ui.ImageDescriptor.raw` ou `ui.decodeImageFromPixels`
agora usa a ordem de pixel correta descrita por `format`,
e tem origem no canto superior esquerdo.

Imagens renderizadas chamando diretamente essas duas funções
Código legado que invoca essas funções diretamente pode
encontrar suas imagens de cabeça para baixo e com cores incorretas.

## Guia de migração

Se o aplicativo usa a versão mais recente do Flutter e passa por essa situação,
a solução mais direta é inverter manualmente a imagem e usar o formato
de pixel alternativo. No entanto, esta dificilmente é a solução mais otimizada,
já que esses dados de pixel geralmente são construídos a partir de outras fontes,
permitindo a inversão durante o processo de construção.

Código antes da migração:

```dart
import 'dart:typed_data';
import 'dart:ui' as ui;

// Analisa `image` como uma imagem exibível.
//
// Cada byte em `image` é um canal de pixel, na ordem azul, verde, vermelho,
// e alfa, começando do canto inferior esquerdo e indo primeiro por linha.
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

Código após a migração:

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
quanto em um pré-patch.
Nesse caso, você pode decidir se o comportamento foi alterado
deixando-o decodificar um único pixel primeiro.

Código após a migração:

```dart
Uint8List verticallyFlipImage(Uint8List sourceBytes, int width, int height) {
  // Igual ao exemplo acima.
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
    await ui.ImmutableBuffer.fromUint8List(correctedImage), // Use a imagem corrigida
    width: width,
    height: height,
    pixelFormat: ui.PixelFormat.bgra8888, // Use o formato alternativo
  );
  return (await (await descriptor.instantiateCodec()).getNextFrame()).image;
}
```

## Linha do tempo

Implementado na versão: 2.9.0-0.0.pre<br>
Na versão estável: 2.10

## Referências

Documentação da API:

* [`decodeImageFromPixels`][]
* [`ImageDescriptor.raw`][]

Problemas relevantes:

* [Web: Regressão no Master - Exibição de PDF distorcida devido a mudança no Codificador BMP][]
* [Web: ImageDescriptor.raw inverte e troca cores de imagens (motivo parcial incluso)][]

PRs relevantes:

* [Web: Reland: Corrigir codificador BMP][]
* [Esclarecer a ordem dos pixels de ImageDescriptor.raw e adicionar detector de versão][]

[`decodeImageFromPixels`]: {{site.api}}/flutter/dart-ui/decodeImageFromPixels.html
[`ImageDescriptor.raw`]: {{site.api}}/flutter/dart-ui/ImageDescriptor/ImageDescriptor.raw.html

[Web: Regressão no Master - Exibição de PDF distorcida devido a mudança no Codificador BMP]: {{site.repo.flutter}}/issues/93615
[Web: ImageDescriptor.raw inverte e troca cores de imagens (motivo parcial incluso)]: {{site.repo.flutter}}/issues/89610

[engine#29593]: {{site.repo.engine}}/pull/29593
[Web: Reland: Corrigir codificador BMP]: {{site.repo.engine}}/pull/29593
[Esclarecer a ordem dos pixels de ImageDescriptor.raw e adicionar detector de versão]: {{site.repo.engine}}/pull/30343
