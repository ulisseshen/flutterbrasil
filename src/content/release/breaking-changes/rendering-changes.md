---
title: Mudanças notáveis de renderização e layout após v3.7
description: Mudanças de quebra não relacionadas à API feitas após o Flutter v3.7.
ia-translate: true
---

## Mudanças

Esta seção lista as mudanças de quebra notáveis não relacionadas à API.

### (Afeta apenas testes) `FlutterTest` agora é a fonte de teste padrão

A fonte `FlutterTest` substituiu `Ahem` como a fonte padrão em testes: quando
`fontFamily` não é especificada, ou as famílias de fontes especificadas não estão registradas,
os testes usam a fonte `FlutterTest` para renderizar texto. A fonte `Ahem` ainda está
disponível em testes se especificada como a `fontFamily` a ser usada.

A fonte `FlutterTest` produz métricas de fonte e glifo mais precisas do que `Ahem`,
e as métricas são geralmente agnósticas ao motor de fontes.
Confira a página wiki [Flutter Test Fonts][]
para mais detalhes sobre a fonte de teste.

**Diferenças**

A fonte `FlutterTest` parece quase idêntica à antiga padrão `Ahem`: o
glifo para a maioria dos caracteres é uma caixa que preenche o quadrado em. As diferenças
notáveis entre a fonte `FlutterTest` e a fonte `Ahem` são:

**1. Localização da linha de base diferente**

A ascensão e descida da fonte `FlutterTest` são 0.75 em e 0.25 em, enquanto
as da `Ahem` são 0.8 em e 0.2 em, respectivamente.

No exemplo de mudança de imagem golden abaixo, os blocos brancos são texto renderizado
usando `Ahem` e `FlutterTest`. O segundo caractere é mais alto na nova fonte
já que tem uma descida maior.

| Before (`Ahem`) | After | Animated Diff |
| :---: | :---: | :---: |
| ![before](assets/material.ink_sparkle.bottom_right.0_masterImage.png) | ![after](assets/material.ink_sparkle.bottom_right.0_testImage.png) | ![baseline_animated](assets/baseline.gif) |

**2. Posição de decoração diferente**

A localização do sublinhado é ligeiramente mais alta em `FlutterTest` do que em `Ahem`.

No exemplo de mudança de imagem golden abaixo, as 3 linhas de blocos brancos são texto
renderizado usando `Ahem` e `FlutterTest`. As linhas tracejadas azuis indicam as
posições de [TextDecoration.overline]/[TextDecoration.lineThrough]/[TextDecoration.underline]
para cada linha.

| Before (`Ahem`) | After | Animated Diff |
| :---: | :---: | :---: |
| ![before](assets/widgets.text_golden.Decoration.1_masterImage.png) | ![after](assets/widgets.text_golden.Decoration.1_testImage.png) |  ![baseline_animated](assets/underline.gif) |

**3. O glifo usado para caracteres não mapeados é ligeiramente diferente**

Caracteres não mapeados são renderizados como caixas vazias em ambas as fontes, com
uma pequena diferença:

| Before (`Ahem`) | After | Diff |
| :---: | :---: | :---: |
| ![before](assets/material.floating_action_button_test.clip_masterImage.png) | ![after](assets/material.floating_action_button_test.clip_testImage.png) | ![not_def_animated](assets/not_def.gif) |

## Referências

PRs relevantes:

* A fonte `FlutterTest` foi adicionada em: [Add new test font]({{site.repo.engine}}/pull/39809)
* A fonte `FlutterTest` foi tornada padrão em: [Make FlutterTest the default test font]({{site.repo.engine}}/pull/40188)

Página wiki:

* [Flutter Test Fonts][]

[Flutter Test Fonts]: {{site.repo.flutter}}/blob/main/docs/contributing/testing/Flutter-Test-Fonts.md
[TextDecoration.underline]: {{site.api}}/flutter/dart-ui/TextDecoration/underline-constant.html
[TextDecoration.overline]: {{site.api}}/flutter/dart-ui/TextDecoration/overline-constant.html
[TextDecoration.lineThrough]: {{site.api}}/flutter/dart-ui/TextDecoration/lineThrough-constant.html
