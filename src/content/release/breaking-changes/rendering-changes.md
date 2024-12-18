---
ia-translate: true
title: Mudanças Notáveis de Renderização e Layout após a v3.7
description: Mudanças interruptivas não relacionadas à API feitas após o Flutter v3.7.
---

## Mudanças

Esta seção lista as mudanças interruptivas notáveis não relacionadas à API.

### (Afeta Apenas Testes) `FlutterTest` agora é a fonte de teste padrão

A fonte `FlutterTest` substituiu a `Ahem` como a fonte padrão em testes: quando
`fontFamily` não é especificado, ou as famílias de fontes especificadas não estão registradas,
os testes usam a fonte `FlutterTest` para renderizar o texto. A fonte `Ahem` ainda está
disponível em testes se especificada como a `fontFamily` a ser usada.

A fonte `FlutterTest` produz métricas de fonte e glifo mais precisas do que a `Ahem`,
e as métricas são geralmente agnósticas ao mecanismo de fonte.
Confira a página wiki [Fontes de Teste do Flutter][] para mais detalhes sobre a fonte de teste.

**Diferenças**

A fonte `FlutterTest` parece quase idêntica à antiga `Ahem` padrão: o
glifo para a maioria dos caracteres é uma caixa que preenche o quadrado em. As diferenças notáveis entre a fonte `FlutterTest` e a fonte `Ahem` são:

**1. Localização da linha de base diferente**

O ascendente e o descendente da fonte `FlutterTest` são 0,75 em e 0,25 em, enquanto
os de `Ahem` são 0,8 em e 0,2 em, respectivamente.

No exemplo de mudança de imagem dourada abaixo, os blocos brancos são texto renderizado
usando `Ahem` e `FlutterTest`. O segundo caractere é mais alto na nova fonte
já que tem um descendente maior.

| Antes (`Ahem`) | Depois | Diff Animado |
| :---: | :---: | :---: |
| ![antes](assets/material.ink_sparkle.bottom_right.0_masterImage.png) | ![depois](assets/material.ink_sparkle.bottom_right.0_testImage.png) | ![baseline_animated](assets/baseline.gif) |

**2. Posição de decoração diferente**

A localização do sublinhado é ligeiramente mais alta em `FlutterTest` do que em `Ahem`.

No exemplo de mudança de imagem dourada abaixo, as 3 linhas de blocos brancos são texto
renderizado usando `Ahem` e `FlutterTest`. As linhas tracejadas azuis indicam as
posições de [TextDecoration.overline]/[TextDecoration.lineThrough]/[TextDecoration.underline]
para cada linha.

| Antes (`Ahem`) | Depois | Diff Animado |
| :---: | :---: | :---: |
| ![antes](assets/widgets.text_golden.Decoration.1_masterImage.png) | ![depois](assets/widgets.text_golden.Decoration.1_testImage.png) |  ![baseline_animated](assets/underline.gif) |

**3. O glifo usado para caracteres não mapeados é ligeiramente diferente**

Caracteres não mapeados são renderizados como caixas vazias em ambas as fontes, com
uma pequena diferença:

| Antes (`Ahem`) | Depois | Diff |
| :---: | :---: | :---: |
| ![antes](assets/material.floating_action_button_test.clip_masterImage.png) | ![depois](assets/material.floating_action_button_test.clip_testImage.png) | ![not_def_animated](assets/not_def.gif) |

## Referências

PRs relevantes:

* A fonte `FlutterTest` foi adicionada em: [Adicionar nova fonte de teste]({{site.repo.engine}}/pull/39809)
* A fonte `FlutterTest` se tornou a padrão em: [Fazer FlutterTest a fonte de teste padrão]({{site.repo.engine}}/pull/40188)

Página wiki:

* [Fontes de Teste do Flutter][]

[Fontes de Teste do Flutter]: {{site.repo.flutter}}/blob/master/docs/contributing/testing/Flutter-Test-Fonts.md
[TextDecoration.underline]: {{site.api}}/flutter/dart-ui/TextDecoration/underline-constant.html
[TextDecoration.overline]: {{site.api}}/flutter/dart-ui/TextDecoration/overline-constant.html
[TextDecoration.lineThrough]: {{site.api}}/flutter/dart-ui/TextDecoration/lineThrough-constant.html
