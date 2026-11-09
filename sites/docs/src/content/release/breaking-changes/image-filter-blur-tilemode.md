---
title: Seleção automática do tile mode padrão de `ImageFilter.blur`.
description: >-
  Se um tile mode não for especificado no construtor, `ImageFilter.blur` vai
  escolher um com base no contexto de renderização.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

O tile mode padrão de `ui.ImageFilter.blur` agora é selecionado
automaticamente pelo backend. Antes, `TileMode.clamp` era usado, a menos que
outro tile mode fosse especificado. Agora, o padrão é `null` e especifica
seleção automática, a menos que um tile mode específico seja informado.

## Contexto {:#background}

O _tile mode_ de `ImageFilter.blur` especifica o que acontece com os pixels
das bordas para o filtro aplicado. Existem quatro opções:

- `TileMode.clamp` (o padrão anterior)
- `TileMode.repeated`
- `TileMode.mirror`
- `TileMode.decal`

Antes, se o comportamento não fosse especificado, o `ImageFilter` usava o modo
`clamp` por padrão. Isso às vezes surpreendia os desenvolvedores, pois nem
sempre correspondia às expectativas.

Com esta mudança, o filtro seleciona automaticamente os seguintes tile modes
com base no contexto:

* `decal` com save layers e quando aplicado a desenhos de formas individuais
          (como `drawRect` e `drawPath`).
* `mirror` com backdrop filters.
* `clamp` para `drawImage`.

## Guia de migração {:#migration-guide}

Apenas filtros de imagem blur que não especificam um tile mode explícito são
afetados por esta mudança.

Acreditamos que os novos padrões são geralmente melhores e recomendamos remover
quaisquer tile modes de blur especificados.

Código antes da migração:

```dart
final filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4, tileMode: TileMode.decal);
```

Código depois da migração:

```dart
final filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4);
```

## Linha do tempo {:#timeline}

Incluído na versão: 3.28.0-0.1.pre<br>
Na versão estável: 3.29

## Referências {:#references}

Documentação da API:

* [`ImageFilter`][]
* [`TileMode`][]

Issues relevantes:

* [Issue #154935][]
* [Issue #110318][]
* [Issue #157693][]

PRs relevantes:

* [Change default TileMode for blur ImageFilter objects to null][]

[`ImageFilter`]: {{site.api}}/flutter/dart-ui/ImageFilter-class.html
[`ImageFilter.blur`]: {{site.api}}/flutter/dart-ui/ImageFilter/ImageFilter.blur.html
[`TileMode`]: {{site.api}}/flutter/dart-ui/TileMode.html
[Issue #154935]: {{site.repo.flutter}}/issues/154935
[Issue #110318]: {{site.repo.flutter}}/issues/110318
[Issue #157693]: {{site.repo.flutter}}/issues/157693
[Change default TileMode for blur ImageFilter objects to null]: {{site.repo.engine}}/pull/55552
