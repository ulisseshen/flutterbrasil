---
title: Novo CupertinoIcons tem alterações nos glifos de ícones
description: >
  Ao atualizar para cupertino_icons 1.0.0, alguns glifos antigos são
  mapeados automaticamente para os novos glifos. Considere verificar visualmente.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Os [0.1.3 icons][] existentes do cupertino_icons
são baseados na estética do iOS 11 com ângulos agudos e linhas finas.

À medida que a iconografia da Apple é atualizada com novas versões do OS,
o pacote `cupertino_icons` também é atualizado.

Geralmente, todos os glifos anteriores referenciados da
API [`CupertinoIcons`][] são automaticamente mapeados para
ícones de aparência muito semelhante no novo estilo SF Symbols
(apresentando linhas mais arredondadas e mais grossas).

Alguns ícones que não têm equivalentes no
novo estilo SF Symbols são mantidos como estão.

Alguns ícones que têm menos variação
(como espessura, aparências alternativas, etc.)
são mapeados automaticamente e colapsados para a melhor variação
correspondente no novo estilo SF Symbols, mas devem ser
verificados novamente para determinar se preservam o
efeito visual pretendido.

## Descrição da alteração

A nova fonte `cupertino_icons 1.0.0` foi criada manualmente
para melhor preservar a intenção e a estética da
simbologia durante a transição. Todos os campos estáticos
`IconData` existentes do `CupertinoIcons`
(e, portanto, todos os codepoints do `.ttf` da fonte)
continuam funcionando e apontam para um novo ícone razoável.

O novo pacote cupertino_icons 1.0.0 também tem ~1.000
ícones adicionais para escolher.

### Ícones inalterados

Não existem alternativas no estilo SF Symbols
para os ícones na lista a seguir.
Os ícones anteriores do cupertino_icons 0.1.3
foram mantidos como estão na versão 1.0.0.

* bluetooth
* bus
* car
* car_detailed
* chevron_back
* chevron_forward
* lab_flask
* lab_flask_solid
* news
* news_solid
* train_style_one
* train_style_two

### Ícones mesclados

Os ícones dentro do mesmo grupo agora são exatamente o mesmo
ícone na versão 1.0.0. Em outras palavras, as distinções
entre essas variações de ícones que existiam na versão 0.1.3 foram
perdidas e agora renderizam o mesmo ícone no estilo SF Symbols
que representa o tema do grupo.

Isso afeta os seguintes grupos de ícones:

* share, share_up
* battery_charging, battery_full, battery_75_percent
* shuffle, shuffle_medium, shuffle_thick
* delete, delete_simple
* refresh, refresh_thin, refresh_thick
* clear, clear_thick
* clear_circled_solid, clear_thick_circled
* gear, gear_alt, gear_big
* loop, loop_thick
* time_solid, clock_solid
* time, clock
* tag, tags
* tag_solid, tags_solid

Isso se deve principalmente a algumas liberdades artísticas tomadas
ao criar o conjunto original `cupertino_icons` que
não correspondem mais à diversidade de variações do
conjunto de ícones SF Symbols mais formal para alguns dos ícones.

## Guia de migração

Após atualizar para a versão 1.22,
se você também atualizar a dependência `cupertino_icons`
do pubspec de 0.1.3 para 1.0.0,
por exemplo, alterando:

```yaml
dependencies:
  ... // Other dependencies
  cupertino_icons: ^0.1.0
```

para:

```yaml
dependencies:
  ... // Other dependencies
  cupertino_icons: ^1.0.0
```

Todos os seus `CupertinoIcons` devem ser atualizados automaticamente
para a nova estética (exceto pelos
[ícones inalterados](#ícones-inalterados) listados acima).

Neste ponto, você também pode explorar [`CupertinoIcons`][]
para novos ícones a serem usados em seu aplicativo.

É recomendado verificar seu aplicativo após
a migração para garantir que os novos ícones mapeados automaticamente
sejam adequados para a estética desejada.

## Linha do tempo

Disponibilizado em: 1.22.0-10.0.pre.65<br>
Na versão estável: 1.22

## Referências

[0.1.3 icons]: https://raw.githubusercontent.com/flutter/cupertino_icons/master/map.png
[`CupertinoIcons`]: {{site.api}}/flutter/cupertino/CupertinoIcons-class.html
