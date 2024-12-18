---
ia-translate: true
title: Fontes e tipografia no Flutter
description: Saiba mais sobre o suporte do Flutter para tipografia.
---

[_Tipografia_][] abrange o estilo e a aparência do
tipo ou fontes: especifica a espessura da fonte,
a inclinação da fonte, o espaçamento entre
as letras e outros aspectos visuais do texto.

Nem todas as fontes são criadas da mesma forma.

Um estilo de fonte é definido, no mínimo, por um tipo de letra, representando o conjunto de
regras de caracteres comuns que descrevem fontes na mesma família de tipos, como
**Roboto** ou **Noto**, um peso de fonte (por exemplo, Regular, Negrito ou um
valor numérico) e um estilo (como Regular, _Itálico_, etc.). Todos estes
e atributos predefinidos adicionais se juntam para formar
o que chamaríamos de uma fonte estática.

Fontes variáveis permitem que alguns desses atributos sejam modificados em tempo de execução e
armazenem o que normalmente seriam várias fontes estáticas em um único arquivo.

[_Tipografia_]: https://en.wikipedia.org/wiki/Typography

## Escala Tipográfica

Uma escala tipográfica é um conjunto de estilos de texto relacionados para fornecer equilíbrio,
coesão e variedade visual em seus aplicativos.

A escala de tipo comum no Flutter, fornecida por [`TextTheme`][], inclui cinco
categorias de texto que indicam a função:

* Display
* Headline
* Título
* Rótulo
* Corpo

Há também três variações de tamanho para cada:

* Pequeno
* Médio
* Grande

Cada uma dessas quinze combinações de uma categoria e tamanho de texto é representada
por um único [`TextStyle`][].

<img src='/assets/images/docs/development/ui/typography/typographical-scale.png'
class="mw-100" alt="Lista da escala tipográfica para Material TextTheme">

Todas as escalas tipográficas específicas da plataforma que o Flutter expõe estão
contidas na classe [`Typography`][]. Normalmente, você não precisará
referenciar esta classe diretamente, pois o `TextTheme` será localizado para sua plataforma de destino.

[`TextTheme`]: https://api.flutter.dev/flutter/material/TextTheme-class.html
[`TextStyle`]: https://api.flutter.dev/flutter/painting/TextStyle-class.html
[`Typography`]: https://api.flutter.dev/flutter/material/Typography-class.html

## Fontes variáveis

[Fontes variáveis][]
permitem que você controle aspectos predefinidos do estilo do texto.
Fontes variáveis suportam eixos específicos, como largura,
peso, inclinação (para citar alguns).
O usuário pode selecionar _qualquer valor ao longo do eixo contínuo_
ao especificar o tipo.

[Fontes variáveis]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts

### Usando o testador de tipo do Google Fonts

Um número crescente de fontes no Google Fonts oferece alguns recursos de fontes variáveis.
Você pode ver a gama de opções usando o Type Tester e ver como você
pode variar uma única fonte.

<img src='/assets/images/docs/development/ui/typography/google-fonts-type-tester.png'
class="mw-100" alt="Demonstração de variação de aspectos para Noto Sans com texto Lorem ipsum">

Em tempo real, mova o controle deslizante em qualquer um dos eixos para
ver como isso afeta a fonte. Ao programar uma fonte variável,
use a classe [`FontVariation`][] para modificar os eixos de design da fonte.
A classe `FontVariation` está em conformidade com a
[especificação de variáveis de fontes OpenType][].

[`FontVariation`]: {{site.api}}/flutter/dart-ui/FontVariation-class.html
[Google Fonts]: https://fonts.google.com/
[especificação de variáveis de fontes OpenType]: https://learn.microsoft.com/en-us/typography/opentype/spec/otvaroverview

## Fontes estáticas

O Google Fonts também contém fontes estáticas. Como nas fontes variáveis,
você precisa saber como a fonte foi projetada para saber quais opções
estão disponíveis para você.
Mais uma vez, o site do Google Fonts pode ajudar.

### Usando o pacote Google Fonts

Embora você possa baixar fontes do site e instalá-las manualmente em seus aplicativos,
você pode optar por usar o tema diretamente do pacote [google_fonts][] em [pub.dev][].

Eles podem ser usados como estão, referenciando simplesmente o nome da fonte:

```dart
Text(
  'This is Google Fonts',
  style: GoogleFonts.lato(),
),
```

ou personalizados definindo propriedades no `TextStyle` resultante:

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
* [`FontStyle`][] para itálico
* [`FontVariation`][] para especificar um intervalo de valores para uma propriedade específica.

Um `FontFeature` corresponde a uma [tag de recurso OpenType][]
e pode ser considerado como um sinalizador booleano para ativar ou desativar
um recurso de uma determinada fonte.

[`FontFeature`]: {{site.api}}/flutter/dart-ui/FontFeature-class.html
[`FontStyle`]: {{site.api}}/flutter/dart-ui/FontStyle.html
[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[tag de recurso OpenType]: https://learn.microsoft.com/en-us/typography/opentype/spec/featuretags
[pub.dev]: https://pub.dev
[google_fonts]: https://pub.dev/packages/google_fonts

## Outros recursos

O vídeo a seguir mostra algumas das capacidades
da tipografia do Flutter e combina-o com o Material
_e_ a aparência do Cupertino (dependendo da plataforma
em que o aplicativo é executado), animação e sombreadores de fragmentos personalizados:

{% ytEmbed 'sA5MRFFUuOU', 'Prototipando designs bonitos com Flutter' %}

Para ler a experiência de um engenheiro
personalizando fontes variáveis e animando-as enquanto elas
se transformam (e foi a base para o vídeo acima),
confira [Tipografia divertida com Flutter][article],
um artigo gratuito no Medium. O exemplo associado também
usa um sombreador personalizado.

[article]: {{site.flutter-medium}}/playful-typography-with-flutter-f030385058b4
