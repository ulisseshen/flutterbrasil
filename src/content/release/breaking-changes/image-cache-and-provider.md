---
ia-translate: true
title: Mudanças em ImageCache e ImageProvider
description: >
  ImageCache exige que implementadores sobrescrevam containsKey, e
  ImageProvider marcou resolve como @nonVirtual.
---

## Resumo

`ImageCache` agora tem um método chamado `containsKey`.
Subclasses de `ImageProvider` não devem sobrescrever `resolve`,
mas, em vez disso, devem implementar novos métodos em `ImageProvider`.
Essas mudanças foram submetidas como um único commit ao framework.

## Descrição da mudança

As seções abaixo descrevem as mudanças em `containsKey`
e `ImageProvider`.

### Mudança em containsKey

Clientes do `ImageCache`, como um `ImageProvider` customizado,
podem querer saber se o cache já está rastreando uma imagem.
Adicionar o método `containsKey` permite que os chamadores descubram
isso sem chamar um método como `putIfAbsent`,
que pode acionar uma chamada indesejada para `ImageProvider.load`.

A implementação padrão verifica os buckets de imagens
pendentes e em cache.

```dart
  bool containsKey(Object key) {
    return _pendingImages[key] != null || _cache[key] != null;
  }
```

### Mudanças em ImageProvider

O método `ImageProvider.resolve` realiza um trabalho complicado
de tratamento de erros que normalmente não deve ser sobrescrito.
Ele também anteriormente realizava o trabalho de carregar a imagem
no cache de imagens, por meio de `ImageProvider.obtainKey` e
`ImageProvider.load`. As subclasses não tinham oportunidade de
sobrescrever esse comportamento sem sobrescrever `resolve`,
e a capacidade de compor `ImageProvider`s é limitada
se vários `ImageProvider`s esperam sobrescrever `resolve`.

Para resolver este problema, `resolve` agora está marcado como não virtual,
e dois novos métodos protegidos foram adicionados: `createStream()`
e `resolveStreamForKey()`.
Esses métodos permitem que as subclasses controlem a maior parte do comportamento
de `resolve`, sem ter que duplicar todo o trabalho de tratamento de erros.
Também permite que subclasses que compõem `ImageProvider`s
tenham mais confiança de que existe apenas um ponto de entrada público
para os vários provedores encadeados.

## Guia de migração

### Mudança em ImageCache

Antes da migração, o código não teria uma sobrescrita de `containsKey`.

Código após a migração:

```dart
class MyImageCache implements ImageCache {
  @override
  bool containsKey(Object key) {
    // Verifique se seu cache customizado está rastreando esta chave.
  }

  ...
}
```

### Mudança em ImageProvider

Código antes da migração:

```dart
class MyImageProvider extends ImageProvider<Object> {
  @override
  ImageStream resolve(ImageConfiguration configuration) {
    // criar stream
    // configurar o tratamento de erros
    // interagir com ImageCache
    // chamar obtainKey/load, etc.
  }
  ...
}
```

Código após a migração:

```dart
class MyImageProvider extends ImageProvider<Object> {
  @override
  ImageStream createStream(ImageConfiguration configuration) {
    // Retornar stream, ou usar super.createStream(),
    // que retorna um novo ImageStream.
  }

  @override
  void resolveStreamForKey(
    ImageConfiguration configuration,
    ImageStream stream,
    Object key,
    ImageErrorListener handleError,
  ) {
    // Interagir com o cache, usar a chave, potencialmente chamar `load`,
    // e relatar quaisquer erros de volta através de `handleError`.
  }
  ...
}

```

## Cronograma

Incluído na versão: 1.16.3<br>
Na versão estável: 1.17

## Referências

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
