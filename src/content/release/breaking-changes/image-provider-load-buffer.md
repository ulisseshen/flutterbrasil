---
ia-translate: true
title: Adicionando ImageProvider.loadBuffer
description: >
  ImageProviders agora devem ser implementados usando a
  nova API loadBuffer em vez da API load existente.
---

## Sumário

* `ImageProvider` agora tem um método chamado `loadBuffer` que funciona
   de forma semelhante a `load`, exceto que ele decodifica de um `ui.ImmutableBuffer`.
* `ui.ImmutableBuffer` agora pode ser criado diretamente de uma chave de asset.
* As classes `AssetBundle` agora podem carregar um `ui.ImmutableBuffer`.
* O `PaintingBinding` agora tem um método chamado
  `instantiateImageCodecFromBuffer`, que funciona de forma semelhante a
  `instantiateImageCodec`.
* `ImageProvider.load` agora está obsoleto, ele será removido em uma versão
   futura.
* `PaintingBinding.instantiateImageCodec` agora está obsoleto, ele será removido
   em uma versão futura.

## Contexto

`ImageProvider.loadBuffer` é um novo método que deve ser implementado para
carregar imagens. Esta API permite que o carregamento de imagens baseadas em
assets seja realizado de forma mais rápida e com menor impacto na memória do
aplicativo.

## Descrição da mudança

Ao carregar imagens de assets, anteriormente a API do provedor de imagens
requeria múltiplas cópias dos dados compactados. Primeiro, ao abrir o asset, os
dados eram copiados para o heap externo e expostos ao Dart como um array de
dados tipados. Então, esse array de dados tipados era eventualmente convertido
em um `ui.ImmutableBuffer`, que internamente copia os dados para uma segunda
estrutura para decodificação.

Com a adição de `ui.ImmutableBuffer.fromAsset`, os bytes de imagem
compactados podem ser carregados diretamente na estrutura usada para
decodificação. Usar esta abordagem requer mudanças no pipeline de carregamento
de bytes de `ImageProvider`. Este processo também é mais rápido, porque evita
alguns overheads de agendamento adicionais do carregador anterior baseado em
channel.

`ImageProvider.loadBuffer` tem o mesmo contrato que `ImageProvider.load`,
exceto que ele fornece um novo callback de decodificação que espera um
`ui.ImmutableBuffer` em vez de um `Uint8List`. Para as classes
`ImageProvider` que adquirem bytes de locais que não sejam assets, o método de
conveniência `ui.ImmutableBuffer.fromUint8List` pode ser usado para
compatibilidade.

## Guia de migração

As classes que são subclasses de `ImageProvider` devem implementar o método
`loadBuffer` para carregar assets. Classes que delegam ou chamam diretamente
os métodos de um `ImageProvider` devem usar `loadBuffer` em vez de `load`.

Código antes da migração:

```dart
class MyImageProvider extends ImageProvider<MyImageProvider> {
  @override
  ImageStreamCompleter load(MyImageProvider key, DecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadData(key, decode),
    );
  }

  Future<ui.Codec> _loadData(MyImageProvider key, DecoderCallback decode) async {
    final Uint8List bytes = await bytesFromSomeApi();
    return decode(bytes);
  }
}

class MyDelegatingProvider extends ImageProvider<MyDelegatingProvider> {
  MyDelegatingProvider(this.provider);

  final ImageProvder provider;

  @override
  ImageStreamCompleter load(MyDelegatingProvider key, DecoderCallback decode) {
    return provider.load(key, decode);
  }
}
```

Código após a migração:

```dart
class MyImageProvider extends ImageProvider<MyImageProvider> {
  @override
  ImageStreamCompleter loadBuffer(MyImageProvider key, DecoderBufferCallback decode) {
    return MultiFrameImageStreamCompleter(
        codec: _loadData(key, decode),
    );
  }

  Future<ui.Codec> _loadData(MyImageProvider key, DecoderBufferCallback decode) async {
    final Uint8List bytes = await bytesFromSomeApi();
    final ui.ImmutableBuffer buffer = await ui.ImmutableBuffer.fromUint8List(bytes);
    return decode(buffer);
  }
}

class MyDelegatingProvider extends ImageProvider<MyDelegatingProvider> {
  MyDelegatingProvider(this.provider);

  final ImageProvder provider;

  @override
  ImageStreamCompleter loadBuffer(MyDelegatingProvider key, DecoderCallback decode) {
    return provider.loadBuffer(key, decode);
  }
}
```

Em ambos os casos, você pode optar por manter a
implementação anterior de `ImageProvider.load`
para dar aos usuários do seu código tempo para migrar também.

## Cronograma

Implementado na versão: 3.1.0-0.0.pre.976<br>
Na versão estável: 3.3.0

## Referências

Documentação da API:

* [`ImmutableBuffer`]({{site.api}}/flutter/dart-ui/ImmutableBuffer-class.html)
* [`ImageProvider`]({{site.api}}/flutter/painting/ImageProvider-class.html)

PR relevante:

* [Usar buffer imutável para carregar imagens de assets]({{site.repo.flutter}}/pull/103496)
