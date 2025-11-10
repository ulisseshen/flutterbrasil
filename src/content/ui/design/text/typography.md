---
ia-translate: true
title: Fontes e tipografia do Flutter
description: Aprenda sobre o suporte do Flutter para tipografia.
---

[_Typography_][_Typography_] cobre o estilo e a aparência de
tipos ou fontes: ela especifica o quão pesada a fonte é,
a inclinação da fonte, o espaçamento entre
as letras e outros aspectos visuais do texto.

Nem todas as fontes são criadas da mesma forma.

Um estilo de fonte é definido por, no mínimo, uma tipografia, representando o conjunto de
regras comuns de caracteres que descrevem fontes na mesma família de tipos, como
**Roboto** ou **Noto**, um peso de fonte (por exemplo, Regular, Bold, ou um
valor numérico), e um estilo (como Regular, _Italic_, etc). Todos esses
e atributos pré-definidos adicionais se unem para formar
o que chamaríamos de uma fonte estática.

Fontes variáveis permitem que alguns desses atributos sejam modificados em tempo de execução e
armazenam o que normalmente seriam várias fontes estáticas em um único arquivo.

[_Typography_]: https://en.wikipedia.org/wiki/Typography

## Escala Tipográfica

Uma escala tipográfica é um conjunto de estilos de texto relacionados para fornecer equilíbrio,
coesão e variedade visual nos seus apps.

A escala de tipo comum no Flutter, fornecida por [`TextTheme`][`TextTheme`], inclui cinco
categorias de texto indicando a função:

* Display
* Headline
* Title
* Label
* Body

Também há três variações de tamanho para cada:

* Small
* Medium
* Large

Cada uma dessas quinze combinações de uma categoria e tamanho de texto são representadas
por um único [`TextStyle`][`TextStyle`].

<img src='/assets/images/docs/development/ui/typography/typographical-scale.png' alt="Listagem da escala tipográfica para Material TextTheme">

Todas as escalas tipográficas específicas de plataforma que o Flutter expõe estão
contidas na classe [`Typography`][`Typography`]. Normalmente, você não precisará
referenciar esta classe diretamente, pois o `TextTheme` será localizado para sua plataforma de destino.

[`TextTheme`]: https://api.flutterbrasil.dev/flutter/material/TextTheme-class.html
[`TextStyle`]: https://api.flutterbrasil.dev/flutter/painting/TextStyle-class.html
[`Typography`]: https://api.flutterbrasil.dev/flutter/material/Typography-class.html

## Fontes variáveis

[Fontes variáveis][Variable fonts]
permitem que você controle aspectos pré-definidos do estilo de texto.
Fontes variáveis suportam eixos específicos, como largura,
peso, inclinação (para citar alguns).
O usuário pode selecionar _qualquer valor ao longo do eixo contínuo_
ao especificar o tipo.

[Variable fonts]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts

### Usando o testador de tipos do Google Fonts

Um número crescente de fontes no Google Fonts oferece algumas capacidades de fonte variável.
Você pode ver a variedade de opções usando o Type Tester e ver como você
pode variar uma única fonte.

<img src='/assets/images/docs/development/ui/typography/google-fonts-type-tester.png' alt="Demonstração de aspectos variados para Noto Sans com texto Lorem ipsum">

Em tempo real, mova o controle deslizante em qualquer um dos eixos para
ver como isso afeta a fonte. Ao programar uma fonte variável,
use a classe [`FontVariation`][`FontVariation`] para modificar os eixos de design da fonte.
A classe `FontVariation` está em conformidade com a
[especificação de variáveis de fonte OpenType][OpenType font variables spec].

[`FontVariation`]: {{site.api}}/flutter/dart-ui/FontVariation-class.html
[Google Fonts]: https://fonts.google.com/
[OpenType font variables spec]: https://learn.microsoft.com/en-us/typography/opentype/spec/otvaroverview

## Fontes estáticas

O Google Fonts também contém fontes estáticas. Assim como nas fontes variáveis,
você precisa saber como a fonte é projetada para saber quais opções
estão disponíveis para você.
Mais uma vez, o site do Google Fonts pode ajudar.

### Usando o pacote Google Fonts

Embora você possa baixar fontes do site e instalá-las manualmente em seus apps,
você pode optar por usar o tema diretamente do pacote [google_fonts][google_fonts] no [pub.dev][pub.dev].

Elas podem ser usadas como estão, referenciando simplesmente o nome da fonte:

```dart
Text(
  'This is Google Fonts',
  style: GoogleFonts.lato(),
),
```

ou personalizadas definindo propriedades no `TextStyle` resultante:

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

* [`FontFeature`][`FontFeature`] para selecionar glifos
* [`FontWeight`][`FontWeight`] para modificar o peso
* [`FontStyle`][`FontStyle`] para italicar
* [`FontVariation`][`FontVariation`] para especificar uma faixa de valores para uma propriedade específica.

Um `FontFeature` corresponde a uma [tag de recurso OpenType][OpenType feature tag]
e pode ser pensado como uma flag booleana para habilitar ou desabilitar
um recurso de uma determinada fonte.

[`FontFeature`]: {{site.api}}/flutter/dart-ui/FontFeature-class.html
[`FontStyle`]: {{site.api}}/flutter/dart-ui/FontStyle.html
[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[OpenType feature tag]: https://learn.microsoft.com/en-us/typography/opentype/spec/featuretags
[pub.dev]: https://pub.dev
[google_fonts]: https://pub.dev/packages/google_fonts

## Outros recursos

O vídeo a seguir mostra algumas das capacidades
da tipografia do Flutter e combina isso com a aparência
Material _e_ Cupertino (dependendo da plataforma
em que o app é executado), animação e custom fragment shaders:

<YouTubeEmbed id="sA5MRFFUuOU" title="Prototyping beautiful designs with Flutter"></YouTubeEmbed>

Para ler a experiência de um engenheiro
personalizando fontes variáveis e animando-as enquanto
se transformam (e foi a base para o vídeo acima),
confira [Playful typography with Flutter][article],
um artigo gratuito no Medium. O exemplo associado também
usa um custom shader.

[article]: {{site.flutter-blog}}/playful-typography-with-flutter-f030385058b4
