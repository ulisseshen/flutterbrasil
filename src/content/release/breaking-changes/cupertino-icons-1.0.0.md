---
ia-translate: true
title: Novos CupertinoIcons têm mudanças nos glifos de ícones
description: >
  Ao atualizar para cupertino_icons 1.0.0, alguns glifos antigos são
  mapeados automaticamente para os novos glifos. Considere verificar
  visualmente.
---

## Resumo

Os `cupertino_icons` [ícones 0.1.3][] existentes são
baseados na estética do iOS 11, com ângulos agudos e linhas finas.

À medida que a iconografia da Apple é atualizada com novas versões do
SO, o pacote `cupertino_icons` também é atualizado.

Geralmente, todos os glifos anteriores referenciados na
API [`CupertinoIcons`][] são mapeados automaticamente para
ícones de aparência muito semelhante no novo estilo SF Symbols
(apresentando linhas mais arredondadas e espessas).

Alguns ícones que não têm equivalentes no
novo estilo SF Symbols são deixados como estão.

Alguns ícones que têm menos variação
(como espessura, aparências alternativas e assim por diante)
são mapeados automaticamente e agrupados na variação
mais adequada no novo estilo SF Symbols, mas devem ser
verificados para determinar se preservam o efeito visual
pretendido.

## Descrição da mudança

A nova fonte `cupertino_icons 1.0.0` é feita à mão
para melhor preservar a intenção e a estética da
simbologia durante a transição. Todos os campos
`IconData` estáticos existentes de `CupertinoIcons`
(e, portanto, todos os codepoints do `.ttf` da fonte)
continuam a funcionar e apontar para um novo ícone razoável.

O novo pacote cupertino_icons 1.0.0 também tem ~1.000
ícones a mais para escolher.

### Ícones inalterados

Não existem alternativas com estilo SF Symbols para
os ícones da lista a seguir. Os ícones cupertino_icons 0.1.3
anteriores foram mantidos como estão na versão 1.0.0.

*   bluetooth
*   bus
*   car
*   car_detailed
*   chevron_back
*   chevron_forward
*   lab_flask
*   lab_flask_solid
*   news
*   news_solid
*   train_style_one
*   train_style_two

### Ícones mesclados

Ícones dentro do mesmo grupo agora são exatamente o mesmo
ícone na versão 1.0.0. Em outras palavras, as distinções
entre as variações de ícones que existiam na versão 0.1.3
são perdidas e agora renderizam o mesmo ícone com estilo
SF Symbols que representa o tema do grupo.

Isso afeta os seguintes grupos de ícones:

*   share, share_up
*   battery_charging, battery_full, battery_75_percent
*   shuffle, shuffle_medium, shuffle_thick
*   delete, delete_simple
*   refresh, refresh_thin, refresh_thick
*   clear, clear_thick
*   clear_circled_solid, clear_thick_circled
*   gear, gear_alt, gear_big
*   loop, loop_thick
*   time_solid, clock_solid
*   time, clock
*   tag, tags
*   tag_solid, tags_solid

Isso se deve principalmente a algumas liberdades artísticas
tomadas ao criar o conjunto `cupertino_icons` original que
não correspondem mais à diversidade de variações do conjunto
de ícones SF Symbols mais formal para alguns dos ícones.

## Guia de migração

Depois de atualizar para 1.22,
se você também atualizar a dependência
`cupertino_icons` do pubspec de 0.1.3 para 1.0.0,
por exemplo, alterando:

```yaml
dependencies:
  ... // Outras dependências
  cupertino_icons: ^0.1.0
```

para:

```yaml
dependencies:
  ... // Outras dependências
  cupertino_icons: ^1.0.0
```

Todos os seus `CupertinoIcons` devem atualizar
automaticamente para a nova estética (exceto para os
[ícones inalterados](#unchanged-icons) listados acima).

Neste ponto, você também pode explorar
[`CupertinoIcons`][] para novos ícones para usar em seu
aplicativo.

Você é encorajado a verificar seu aplicativo após a migração
para garantir que os novos ícones mapeados automaticamente
sejam adequados para a estética desejada.

## Cronograma

Incluído em: 1.22.0-10.0.pre.65<br>
Na versão estável: 1.22

## Referências

[ícones 0.1.3]: https://raw.githubusercontent.com/flutter/cupertino_icons/master/map.png
[`CupertinoIcons`]: {{site.api}}/flutter/cupertino/CupertinoIcons-class.html
