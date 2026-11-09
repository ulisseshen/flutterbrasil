---
title: Mudanças em ImageCache e ImageProvider
description: >
  ImageCache exige que os implementadores sobrescrevam containsKey, e
  ImageProvider marcou resolve como @nonVirtual.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

`ImageCache` agora tem um método chamado `containsKey`.
Subclasses de `ImageProvider` não devem sobrescrever `resolve`,
e sim implementar os novos métodos em `ImageProvider`.
Essas mudanças foram enviadas como um único commit para o framework.

## Descrição da mudança {:#description-of-change}

As seções abaixo descrevem as mudanças em `containsKey`
e em `ImageProvider`.

### Mudança em containsKey {:#containskey-change}

Clientes de `ImageCache`, como um `ImageProvider` personalizado,
podem querer saber se o cache já está rastreando uma imagem.
Adicionar o método `containsKey` permite que quem chama descubra
isso sem chamar um método como `putIfAbsent`,
que pode disparar uma chamada indesejada a `ImageProvider.load`.

A implementação padrão verifica tanto os buckets de imagens
pendentes quanto os de imagens em cache.

```dart
  bool containsKey(Object key) {
    return _pendingImages[key] != null || _cache[key] != null;
  }
```

### Mudanças em ImageProvider {:#imageprovider-changes}

O método `ImageProvider.resolve` faz um tratamento de erros complicado
que normalmente não deve ser sobrescrito.
Antes, ele também carregava a imagem no
cache de imagens, por meio de `ImageProvider.obtainKey` e
`ImageProvider.load`. As subclasses não tinham como
sobrescrever esse comportamento sem sobrescrever `resolve`,
e a capacidade de compor `ImageProvider`s era limitada
quando vários `ImageProvider`s precisavam sobrescrever `resolve`.

Para resolver isso, `resolve` agora está marcado como não virtual,
e dois novos métodos protegidos foram adicionados: `createStream()`
e `resolveStreamForKey()`.
Esses métodos permitem que as subclasses controlem a maior parte do comportamento
de `resolve`, sem precisar duplicar todo o tratamento de erros.
Eles também permitem que subclasses que compõem `ImageProvider`s
tenham mais confiança de que há apenas um ponto de entrada público
para os vários providers encadeados.

## Guia de migração {:#migration-guide}

### Mudança em ImageCache {:#imagecache-change}

Antes da migração, o código não teria uma sobrescrita de `containsKey`.

Código após a migração:

```dart
class MyImageCache implements ImageCache {
  @override
  bool containsKey(Object key) {
    // Check if your custom cache is tracking this key.
  }

  ...
}
```

### Mudança em ImageProvider {:#imageprovider-change}

Código antes da migração:

```dart
class MyImageProvider extends ImageProvider<Object> {
  @override
  ImageStream resolve(ImageConfiguration configuration) {
    // create stream
    // set up error handling
    // interact with ImageCache
    // call obtainKey/load, etc.
  }
  ...
}
```

Código após a migração:

```dart
class MyImageProvider extends ImageProvider<Object> {
  @override
  ImageStream createStream(ImageConfiguration configuration) {
    // Return stream, or use super.createStream(),
    // which returns a new ImageStream.
  }

  @override
  void resolveStreamForKey(
    ImageConfiguration configuration,
    ImageStream stream,
    Object key,
    ImageErrorListener handleError,
  ) {
    // Interact with the cache, use the key, potentially call `load`,
    // and report any errors back through `handleError`.
  }
  ...
}

```

## Linha do tempo {:#timeline}

Incluído na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências {:#references}

Documentação da API:

* [`ImageCache`][]
* [`ImageProvider`][]
* [`ScrollAwareImageProvider`][]

Issues relevantes:

* [Issue #32143][]
* [Issue #44510][]
* [Issue #48305][]
* [Issue #48775][]

PRs relevantes:

* [Defer image decoding when scrolling fast #49389][]

[`ImageCache`]: {{site.api}}/flutter/painting/ImageCache-class.html
[`ImageProvider`]: {{site.api}}/flutter/painting/ImageProvider-class.html
[`ScrollAwareImageProvider`]: {{site.api}}/flutter/widgets/ScrollAwareImageProvider-class.html
[Issue #32143]: {{site.repo.flutter}}/issues/32143
[Issue #44510]: {{site.repo.flutter}}/issues/44510
[Issue #48305]: {{site.repo.flutter}}/issues/48305
[Issue #48775]: {{site.repo.flutter}}/issues/48775
[Defer image decoding when scrolling fast #49389]: {{site.repo.flutter}}/pull/49389
