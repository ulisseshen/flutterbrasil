---
ia-translate: true
title: ImageCache para imagens grandes
description: >
  Pare de aumentar o maxByteSize do ImageCache para acomodar imagens grandes.
---

## Sumário

O `maxByteSize` do `ImageCache` não é mais
automaticamente aumentado para acomodar imagens grandes.

## Contexto

Anteriormente, ao carregar imagens no `ImageCache`
que tinham tamanhos de byte maiores do que o `maxByteSize` do `ImageCache`,
o Flutter aumentava permanentemente o valor `maxByteSize`
para acomodar essas imagens.
Essa lógica às vezes levava a valores `maxByteSize` inchados que
dificultavam o trabalho em sistemas com memória limitada.

## Descrição da mudança

O seguinte pseudocódigo "antes" e "depois" demonstra
as mudanças feitas no algoritmo `ImageCache`:

```dart
// Pseudocódigo da lógica antiga
void onLoadImage(Image image) {
  if (image.byteSize > _cache.maxByteSize) {
    _cache.maxByteSize = image.byteSize + 1000;
  }
  _cache.add(image);
  while (_cache.count > _cache.maxCount
      || _cache.byteSize > _cache.maxByteSize) {
    _cache.discardOldestImage();
  }
}
```

```dart
// Pseudocódigo da nova lógica
void onLoadImage(Image image) {
  if (image.byteSize < _cache.maxByteSize) {
    _cache.add(image);
    while (_cache.count > _cache.maxCount
        || _cache.byteSize > cache.maxByteSize) {
      cache.discardOldestImage();
    }
  }
}
```

## Guia de migração

Pode haver situações em que o `ImageCache`
esteja "thrashing" com a nova lógica onde não estava anteriormente,
especificamente se você carregar imagens que são maiores do que o seu
valor `cache.maxByteSize`.
Isso pode ser resolvido por uma das seguintes abordagens:

1. Aumente o valor `ImageCache.maxByteSize`
   para acomodar imagens maiores.
1. Ajuste sua lógica de carregamento de imagem para garantir que
   as imagens se encaixem bem no valor `ImageCache.maxByteSize`
   de sua escolha.
1. Crie uma subclasse de `ImageCache`, implemente a lógica desejada
   e crie um novo binding que forneça sua subclasse
   de `ImageCache` (veja o código fonte em [`image_cache.dart`][]).

## Cronograma

O algoritmo antigo não é mais suportado.

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`ImageCache`][]

Problema relevante:

* [Issue 45643][]

PR relevante:

* [Stopped increasing the cache size to accommodate large images][]

Outros:

* Código fonte do [`ImageCache`][]

[Stopped increasing the cache size to accommodate large images]: {{site.repo.flutter}}/pull/47387
[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`image_cache.dart`]: {{site.repo.flutter}}/blob/72a3d914ee5db0033332711224e728b8a5281d89/packages/flutter/lib/src/painting/image_cache.dart#L34
[`ImageCache` source]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/painting/image_cache.dart
[Issue 45643]: {{site.repo.flutter}}/issues/45643
