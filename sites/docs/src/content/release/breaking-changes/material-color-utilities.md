---
ia-translate: true
title: Atualização do Material Color Utilities no Flutter
description: >-
  As versões mais recentes do Material Color Utilities foram
  aplicadas à biblioteca Material do Flutter.
---

{% render "docs/breaking-changes.md" %}

## Resumo {:#summary}

Esta versão atualiza o `package:material_color_utilities` de
`v0.11.1` para `0.13.0`.
Este pacote atualizado inclui mudanças de algoritmo que
alinham com a [atualização de tokens do Material 3][Material 3 tokens update].

As mudanças de algoritmo afetam as mesmas propriedades:

* `onPrimaryContainer`
* `onSecondaryContainer`
* `onTertiaryContainer`
* `onErrorContainer`

As mudanças serão refletidas ao gerar um esquema usando

* `ColorScheme.fromSeed`
* `ColorScheme.fromImageProvider`
* `ThemeData(colorScheme:..)`

[Material 3 tokens update]: /release/breaking-changes/material-design-3-token-update

## Guia de migração {:#migration-guide}

De modo geral, acreditamos que as cores geradas serão mais legíveis e visualmente
agradáveis, mas, se você quiser manter as cores anteriores ao atualizar,
terá que definir manualmente essas propriedades com a cor desejada após
a geração.

## Linha do tempo {:#timeline}

Incluído na versão: 3.39.0-1.0.pre-250<br>
Na versão estável: 3.41

## Referências {:#references}

* [Atualize manualmente o material_color_utilities][Manually roll material_color_utilities]

[Manually roll material_color_utilities]: {{site.repo.flutter}}/pull/170000
