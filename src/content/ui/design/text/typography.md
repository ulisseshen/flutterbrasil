---
title: Fontes e tipografia do Flutter
description: Aprenda sobre o suporte do Flutter para tipografia.
ia-translate: true
---

[_Typography_][] cobre o estilo e a aparência de
tipos ou fontes: especifica o peso da fonte,
a inclinação da fonte, o espaçamento entre
as letras e outros aspectos visuais do texto.

Nem todas as fontes são _criadas_ da mesma forma.

Um estilo de fonte é definido por, no mínimo, uma tipografia, representando o conjunto de
regras comuns de caracteres que descrevem fontes na mesma família de tipos, como
**Roboto** ou **Noto**, um peso de fonte (por exemplo, Regular, Bold, ou um
valor numérico), e um estilo (como Regular, _Italic_, etc). Todos esses
e atributos pré-definidos adicionais se unem para compor
o que chamaríamos de fonte estática.

Fontes variáveis permitem que alguns desses atributos sejam modificados em tempo de execução e
armazenam o que normalmente seriam múltiplas fontes estáticas em um único arquivo.

[_Typography_]: https://en.wikipedia.org/wiki/Typography

## Escala tipográfica

Uma escala tipográfica é um conjunto de estilos de texto relacionados para fornecer equilíbrio,
coesão e variedade visual em seus aplicativos.

A escala de tipos comum no Flutter, fornecida pelo [`TextTheme`][], inclui cinco
categorias de texto indicando a função:

* Display
* Headline
* Title
* Label
* Body

Há também três variações de tamanho para cada:

* Small
* Medium
* Large

Cada uma dessas quinze combinações de uma categoria e tamanho de texto são representadas
por um único [`TextStyle`][].

<img src='/assets/images/docs/development/ui/typography/typographical-scale.png'
class="mw-100" alt="Listing of typographical scale for Material TextTheme">

Todas as escalas tipográficas específicas da plataforma que o Flutter expõe estão
contidas na classe [`Typography`][]. Geralmente, você não precisará
referenciar essa classe diretamente, pois o `TextTheme` será localizado para sua plataforma de destino.

[`TextTheme`]: https://api.flutterbrasil.dev/flutter/material/TextTheme-class.html
[`TextStyle`]: https://api.flutterbrasil.dev/flutter/painting/TextStyle-class.html
[`Typography`]: https://api.flutterbrasil.dev/flutter/material/Typography-class.html

## Fontes variáveis

[Variable fonts][]
permitem que você controle aspectos pré-definidos do estilo de texto.
Fontes variáveis suportam eixos específicos, como largura,
peso, inclinação (para citar alguns).
O usuário pode selecionar _qualquer valor ao longo do eixo contínuo_
ao especificar o tipo.

[Variable fonts]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts

### Usando o testador de tipos do Google Fonts

Um número crescente de fontes no Google Fonts oferece algumas capacidades de fontes variáveis.
Você pode ver a gama de opções usando o Type Tester e ver como você
pode variar uma única fonte.

<img src='/assets/images/docs/development/ui/typography/google-fonts-type-tester.png'
class="mw-100" alt="Demonstration of varying aspects for Noto Sans with Lorem ipsum text">

Em tempo real, mova o controle deslizante em qualquer um dos eixos para
ver como isso afeta a fonte. Ao programar uma fonte variável,
use a classe [`FontVariation`][] para modificar os eixos de design da fonte.
A classe `FontVariation` está em conformidade com a
[especificação de variáveis de fonte OpenType][OpenType font variables spec].

[`FontVariation`]: {{site.api}}/flutter/dart-ui/FontVariation-class.html
[Google Fonts]: https://fonts.google.com/
[OpenType font variables spec]: https://learn.microsoft.com/en-us/typography/opentype/spec/otvaroverview

## Fontes estáticas

O Google Fonts também contém fontes estáticas. Assim como com fontes variáveis,
você precisa saber como a fonte é projetada para saber quais opções
estão disponíveis para você.
Mais uma vez, o site do Google Fonts pode ajudar.

### Usando o pacote Google Fonts

Embora você possa baixar fontes do site e instalá-las manualmente em seus aplicativos,
você pode optar por usar o tema diretamente do pacote [google_fonts][] no [pub.dev][].

Elas podem ser usadas como estão, referenciando simplesmente o nome da fonte:

```dart
Text(
  'This is Google Fonts',
  style: GoogleFonts.lato(),
),
```

ou customizadas definindo propriedades no `TextStyle` resultante:

```dart
Text(
  'This is Google Fonts',
  style: GoogleFonts.lato(
    textStyle: Theme.of(context).textTheme.displayLarge,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
  ),
),
```

### Modificando fontes

Use a seguinte API para alterar programaticamente uma fonte estática
(mas lembre-se de que isso só funciona se a fonte foi _projetada_
para suportar o recurso):

* [`FontFeature`][] para selecionar glifos
* [`FontWeight`][] para modificar o peso
* [`FontStyle`][] para italicizar
* [`FontVariation`][] para especificar uma faixa de valores para uma propriedade específica.

Um `FontFeature` corresponde a uma [tag de recurso OpenType][OpenType feature tag]
e pode ser pensado como uma flag booleana para ativar ou desativar
um recurso de uma determinada fonte.

[`FontFeature`]: {{site.api}}/flutter/dart-ui/FontFeature-class.html
[`FontStyle`]: {{site.api}}/flutter/dart-ui/FontStyle.html
[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[OpenType feature tag]: https://learn.microsoft.com/en-us/typography/opentype/spec/featuretags
[pub.dev]: https://pub.dev
[google_fonts]: https://pub.dev/packages/google_fonts

## Outros recursos

O vídeo a seguir mostra algumas das capacidades
da tipografia do Flutter e a combina com a aparência
e sensação Material _e_ Cupertino (dependendo da plataforma
em que o aplicativo é executado), animação e fragment shaders customizados:

{% ytEmbed 'sA5MRFFUuOU', 'Prototyping beautiful designs with Flutter' %}

Para ler a experiência de um engenheiro
customizando fontes variáveis e animando-as conforme elas
se transformam (e foi a base do vídeo acima),
confira [Playful typography with Flutter][article],
um artigo gratuito no Medium. O exemplo associado também
usa um shader customizado.

[article]: {{site.flutter-medium}}/playful-typography-with-flutter-f030385058b4
