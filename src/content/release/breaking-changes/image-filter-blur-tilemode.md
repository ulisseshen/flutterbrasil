---
title: Seleção automática do modo de tile padrão do ImageFilter.blur.
description: >-
  Se um modo de tile não foi especificado no construtor, ImageFilter.blur
  selecionará um baseado no contexto de renderização.
ia-translate: true
---

## Resumo

O modo de tile padrão do `ui.ImageFilter.blur` agora é
automaticamente selecionado pelo backend.
Anteriormente `TileMode.clamp` era usado a menos que um modo de tile diferente fosse especificado.
Agora, o padrão é `null` e especifica seleção automática a menos que
um modo de tile específico seja especificado.

## Contexto

O _modo de tile_ do `ImageFilter.blur` especifica o que acontece com
pixels de borda para o filtro aplicado.
Existem quatro opções:

- `TileMode.clamp` (o padrão anterior)
- `Tilemode.repeated`
- `TileMode.mirror`
- `TileMode.decal`

Anteriormente, se o comportamento não fosse especificado,
`ImageFilter` usava o modo `clamp` por padrão.
Isso às vezes surpreendia desenvolvedores, pois nem sempre correspondia às expectativas.

A partir desta mudança, o filtro seleciona automaticamente os
seguintes modos de tile baseados no contexto:

* `decal` com save layers e quando aplicado a desenhos de formas individuais
          (como com `drawRect` e `drawPath`).
* `mirror` com backdrop filters.
* `clamp` para `drawImage`.

## Guia de migração

Apenas filtros de imagem blur que não especificam um modo de tile explícito são
impactados por esta mudança.

Acreditamos que os novos padrões são geralmente
melhores e recomendaríamos remover quaisquer modos de tile blur especificados.

Código antes da migração:

```dart
final filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4, tileMode: TileMode.decal);
```

Código após a migração:

```dart
final filter = ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4);
```

## Linha do tempo

Implementado na versão: 3.28.0-0.1.pre<br>
Na versão estável: Ainda não

## Referências

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
