---
ia-translate: true
title: Seleção automática do modo de repetição padrão de ImageFilter.blur.
description: >-
  Se um modo de repetição não foi especificado no construtor, ImageFilter.blur
  irá selecionar um com base no contexto de renderização.
---

## Resumo

  O modo de repetição padrão de `ui.ImageFilter.blur` agora é selecionado
  automaticamente pelo backend. Anteriormente, `TileMode.clamp` era usado, a
  menos que um modo de repetição diferente fosse especificado. Agora, o padrão é
  `null` e especifica a seleção automática, a menos que um modo de repetição
  específico seja definido.

## Contexto

  O _modo de repetição_ de `ImageFilter.blur` especifica o que acontece com os
  pixels da borda para o filtro aplicado. Existem quatro opções:
  `TileMode.clamp` (o padrão anterior), `Tilemode.repeated`, `TileMode.mirror` e
  `TileMode.decal`. Anteriormente, `ImageFilter` usava por padrão o modo
  `clamp` se o comportamento não fosse especificado, o que às vezes
  surpreendia os desenvolvedores, pois nem sempre correspondia às expectativas.

  A partir desta alteração, o filtro seleciona automaticamente os seguintes
  modos de repetição com base no contexto:

  * `decal` com save layers e quando aplicado a desenhos de formas
            individuais (drawRect, drawPath, ...)
  * `mirror` com filtros de cenário (backdrop filters).
  * `clamp` para drawImage.

## Guia de migração

  Apenas filtros de imagem de desfoque que não especificam um modo de repetição
  explícito são afetados por essa mudança. Acreditamos que os novos padrões
  são geralmente melhores e recomendamos a remoção de quaisquer modos de
  repetição de desfoque especificados.

Código antes da migração:

```dart
var filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4, tileMode: TileMode.decal);
```

Código após a migração:

```dart
var filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4);
```

## Cronograma

Incluído na versão: 3.27.0-1.0.pre.30
Em lançamento estável: Ainda não

## Referências

{% include docs/main-api.md %}

Documentação da API:

* [`ImageFilter`][]
* [`TileMode`][]

Issues relevantes:

* [Issue #154935][]
* [Issue #110318][]
* [Issue #157693][]

PRs relevantes:

* [Change default TileMode for blur ImageFilter objects to null][]


[`ImageFilter`]: https://api.flutter.dev/flutter/dart-ui/ImageFilter-class.html
[`ImageFilter.blur`]: https://api.flutter.dev/flutter/dart-ui/ImageFilter/ImageFilter.blur.html
[`TileMode`]: https://api.flutter.dev/flutter/dart-ui/TileMode.html
[Issue #154935]: https://github.com/flutter/flutter/issues/154935
[Issue #110318]: https://github.com/flutter/flutter/issues/110318
[Issue #157693]: https://github.com/flutter/flutter/issues/157693
[Change default TileMode for blur ImageFilter objects to null]: https://github.com/flutter/engine/pull/55552
