---
title: Imagens grandes no ImageCache
description: >
  Parar de aumentar o maxByteSize do ImageCache para acomodar imagens grandes.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O `maxByteSize` do `ImageCache` não é mais
automaticamente aumentado para acomodar imagens grandes.

## Contexto {:#context}

Anteriormente, ao carregar imagens no `ImageCache`
que tinham tamanhos em bytes maiores que o `maxByteSize` do `ImageCache`,
o Flutter aumentava permanentemente o valor de `maxByteSize`
para acomodar essas imagens.
Esta lógica às vezes levava a valores de `maxByteSize` inflados que
tornavam o trabalho em sistemas com memória limitada mais difícil.

## Descrição da mudança {:#description-of-change}

O pseudocódigo "antes" e "depois" a seguir demonstra
as mudanças feitas no algoritmo do `ImageCache`:

```dart
// Old logic pseudocode
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
// New logic pseudocode
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

## Guia de migração {:#migration-guide}

Pode haver situações em que o `ImageCache`
está fazendo muitas operações com a nova lógica quando não fazia anteriormente,
especificamente se você carregar imagens maiores que o valor de
`cache.maxByteSize`.
Isso pode ser resolvido por uma das seguintes abordagens:

1. Aumentar o valor de `ImageCache.maxByteSize`
   para acomodar imagens maiores.
1. Ajustar sua lógica de carregamento de imagens para garantir que
   as imagens se encaixem bem no valor de `ImageCache.maxByteSize`
   de sua escolha.
1. Estender `ImageCache`, implementar sua lógica desejada,
   e criar uma nova binding que forneça sua subclasse
   de `ImageCache` (veja o código-fonte de [`image_cache.dart`][]).

## Cronograma {:#timeline}

O algoritmo antigo não é mais suportado.

Implementado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências {:#references}

Documentação da API:

* [`ImageCache`][]

Issue relevante:

* [Issue 45643][]

PR relevante:

* [Stopped increasing the cache size to accommodate large images][]

Outros:

* [`ImageCache` source][]


[Stopped increasing the cache size to accommodate large images]: {{site.repo.flutter}}/pull/47387
[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`image_cache.dart`]: {{site.repo.flutter}}/blob/72a3d914ee5db0033332711224e728b8a5281d89/packages/flutter/lib/src/painting/image_cache.dart#L34
[`ImageCache` source]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/painting/image_cache.dart
[Issue 45643]: {{site.repo.flutter}}/issues/45643
