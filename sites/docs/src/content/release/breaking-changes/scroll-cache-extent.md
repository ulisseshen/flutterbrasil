---
ia-translate: true
title: '`cacheExtent` e `cacheExtentStyle` descontinuados'
description: >-
  As propriedades `cacheExtent` e `cacheExtentStyle` estão descontinuadas.
  Elas são substituídas por `scrollCacheExtent` com um objeto `ScrollCacheExtent`.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O Flutter 3.44 descontinua `cacheExtent` e `cacheExtentStyle`
em widgets relacionados a rolagem, como
`ListView`, `GridView`, `CustomScrollView` e `Viewport`,
e em seus render objects correspondentes, como `RenderViewport`.
A nova propriedade `scrollCacheExtent` encapsula
tanto o valor quanto a estratégia de cache (pixels ou viewport).

## Contexto {:#background}

Anteriormente, `cacheExtent` era um `double` e
`cacheExtentStyle` determinava como esse `double` era interpretado
(como pixels ou como uma fração da viewport).
Essa separação tornava a configuração mais difícil de entender.

A nova propriedade `scrollCacheExtent` usa um objeto `ScrollCacheExtent` que
encapsula explicitamente tanto o valor quanto
a estratégia de cache (pixels ou viewport),
o que oferece segurança de tipos e uma intenção mais clara.

## Guia de migração {:#migration-guide}

### Camada de widgets {:#widget-layer}

#### `cacheExtent` (pixels)

Se o seu código usa `cacheExtent`,
que usa pixels por padrão,
use `scrollCacheExtent` com `ScrollCacheExtent.pixels`.

**Antes:**

```dart
ListView(
  cacheExtent: 500.0,
  children: // ...
)
```

**Depois:**

```dart
ListView(
  scrollCacheExtent: const ScrollCacheExtent.pixels(500.0),
  children: // ...
)
```

#### `cacheExtentStyle` (viewport)

Se o seu código usa `cacheExtent` com `CacheExtentStyle.viewport`,
o que é comum em `Viewport`,
use `scrollCacheExtent` com `ScrollCacheExtent.viewport`.

**Antes:**

```dart
Viewport(
  cacheExtent: 0.5,
  cacheExtentStyle: CacheExtentStyle.viewport,
  slivers: // ...
)
```

**Depois:**

```dart
Viewport(
  scrollCacheExtent: const ScrollCacheExtent.viewport(0.5),
  slivers: // ...
)
```

### Camada de render objects {:#render-object-layer}

Se o seu código define propriedades manualmente em
`RenderViewport` ou em um render object semelhante,
use `scrollCacheExtent`.

**Antes:**

```dart
renderViewport.cacheExtent = 500.0;
renderViewport.cacheExtentStyle = CacheExtentStyle.pixel;
```

**Depois:**

```dart
renderViewport.scrollCacheExtent = const ScrollCacheExtent.pixels(500.0);
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.41.0-0.0.pre<br>
Na versão estável: 3.44

## Referências {:#references}

Documentação da API:

* [`ScrollCacheExtent`][]
* [`ScrollView.scrollCacheExtent`][]
* [`RenderViewportBase.scrollCacheExtent`][]

PRs relevantes:

* [Introduce ScrollCacheExtent][pr-181092]

[`ScrollCacheExtent`]: {{site.api}}/flutter/rendering/ScrollCacheExtent-class.html
[`ScrollView.scrollCacheExtent`]: {{site.api}}/flutter/widgets/ScrollView/scrollCacheExtent.html
[`RenderViewportBase.scrollCacheExtent`]: {{site.api}}/flutter/rendering/RenderViewportBase/scrollCacheExtent.html

[pr-181092]: {{site.repo.flutter}}/pull/181092
