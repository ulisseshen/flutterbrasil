---
title: ImageCache large images
description: >
  Stop increasing the ImageCache maxByteSize to accommodate large images.
ia-translate: true
---

## Resumo

The `maxByteSize` of the `ImageCache` is no longer
automatically made larger to accommodate large images.

## Contexto

Previously, when loading images into the `ImageCache`
that had larger byte sizes than the `ImageCache`'s `maxByteSize`,
Flutter permanently increased the `maxByteSize` value
to accommodate those images.
This logic sometimes led to bloated `maxByteSize` values that
made working in memory-limited systems more difficult.

## Descrição da mudança

The following "before" and "after" pseudocode demonstrates
the changes made to the `ImageCache` algorithm:

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

## Guia de migração

There might be situations where the `ImageCache`
is thrashing with the new logic where it wasn't previously,
specifically if you load images that are larger than your
`cache.maxByteSize` value.
This can be remedied by one of the following approaches:

1. Increase the `ImageCache.maxByteSize` value
   to accommodate larger images.
1. Adjust your image loading logic to guarantee that
   the images fit nicely into the `ImageCache.maxByteSize`
   value of your choosing.
1. Subclass `ImageCache`, implement your desired logic,
   and create a new binding that serves up your subclass
   of `ImageCache` (see the [`image_cache.dart`][] source).

## Linha do tempo

The old algorithm is no longer supported.

Lançado na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

Documentação da API:

* [`ImageCache`][]

Issues relevantes:

* [Issue 45643][]

PRs relevantes:

* [Stopped increasing the cache size to accommodate large images][]

Other:

* [`ImageCache` source][]


[Stopped increasing the cache size to accommodate large images]: {{site.repo.flutter}}/pull/47387
[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`image_cache.dart`]: {{site.repo.flutter}}/blob/72a3d914ee5db0033332711224e728b8a5281d89/packages/flutter/lib/src/painting/image_cache.dart#L34
[`ImageCache` source]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/painting/image_cache.dart
[Issue 45643]: {{site.repo.flutter}}/issues/45643
