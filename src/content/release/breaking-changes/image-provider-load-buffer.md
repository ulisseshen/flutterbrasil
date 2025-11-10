---
ia-translate: true
title: Adicionando ImageProvider.loadBuffer
description: >
  ImageProviders agora devem ser implementados usando a
  nova API loadBuffer em vez da API load existente.
---

{% render "docs/breaking-changes.md" %}

## Resumo

* `ImageProvider` agora tem um método chamado `loadBuffer` que funciona
   de forma similar ao `load`, exceto que ele decodifica de um `ui.ImmutableBuffer`.
* `ui.ImmutableBuffer` agora pode ser criado diretamente de uma chave de asset.
* As classes `AssetBundle` agora podem carregar um `ui.ImmutableBuffer`.
* O `PaintingBinding` agora tem um método chamado
  `instantiateImageCodecFromBuffer`, que funciona de forma similar ao
  `instantiateImageCodec`.
* `ImageProvider.load` agora está depreciado, será removido em uma versão
   futura.
* `PaintingBinding.instantiateImageCodec` agora está depreciado, será removido
   em uma versão futura.

## Contexto

`ImageProvider.loadBuffer` é um novo método que deve ser implementado para
carregar imagens. Esta API permite que o carregamento de imagens baseadas em assets seja realizado mais rapidamente
e com menos impacto de memória na aplicação.

## Descrição da mudança

Ao carregar imagens de assets, anteriormente a API do image provider exigia múltiplas
cópias dos dados comprimidos. Primeiro, ao abrir o asset os dados eram
copiados para o heap externo e expostos ao Dart como um array de dados tipados. Então
esse array de dados tipados era eventualmente convertido em um `ui.ImmutableBuffer`,
que internamente copia os dados em uma segunda estrutura para decodificação.

Com a adição de `ui.ImmutableBuffer.fromAsset`, bytes de imagem comprimidos podem
ser carregados diretamente na estrutura usada para decodificação. Usar essa abordagem
requer mudanças no pipeline de carregamento de bytes do `ImageProvider`. Este processo
também é mais rápido, porque ignora algum overhead de agendamento adicional do
método anterior baseado em method channel.

`ImageProvider.loadBuffer` tem o mesmo contrato que
`ImageProvider.load`, exceto que fornece um novo callback de decodificação que espera
um `ui.ImmutableBuffer` em vez de um `Uint8List`. Para classes `ImageProvider`
que adquirem bytes de lugares diferentes de assets, o método de conveniência
`ui.ImmutableBuffer.fromUint8List` pode ser usado para compatibilidade.

## Guia de migração

Classes que fazem subclasse de `ImageProvider` devem implementar o método `loadBuffer` para
carregar assets. Classes que delegam ou chamam os métodos de um
`ImageProvider` diretamente devem usar `loadBuffer` em vez de `load`.

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

Em ambos os casos você pode optar por manter a
implementação anterior de `ImageProvider.load`
para dar aos usuários do seu código tempo para migrar também.

## Cronograma

Landed in version: 3.1.0-0.0.pre.976<br>
In stable release: 3.3.0

## Referências

Documentação da API:

* [`ImmutableBuffer`]({{site.api}}/flutter/dart-ui/ImmutableBuffer-class.html)
* [`ImageProvider`]({{site.api}}/flutter/painting/ImageProvider-class.html)

PR relevante:

* [Use immutable buffer for loading asset images]({{site.repo.flutter}}/pull/103496)
