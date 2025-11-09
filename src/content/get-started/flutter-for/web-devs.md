---
ia-translate: true
title: Flutter para desenvolvedores web
description: >-
  Aprenda como aplicar conhecimentos de desenvolvimento Web ao criar apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/web_devs"?>

Esta página é para usuários que estão familiarizados com a sintaxe HTML
e CSS para organizar componentes da UI de uma aplicação.
Ela mapeia trechos de código HTML/CSS para seus equivalentes em Flutter/Dart.

Flutter é um framework para construir aplicações multiplataforma
que usa a linguagem de programação Dart.
Para entender algumas diferenças entre programar com Dart
e programar com Javascript,
veja [Learning Dart as a JavaScript Developer][Learning Dart as a JavaScript Developer].

Uma das diferenças fundamentais entre
projetar um layout web e um layout Flutter,
é aprender como as constraints funcionam,
e como widgets são dimensionados e posicionados.
Para saber mais, veja [Understanding constraints][Understanding constraints].

Os exemplos assumem:

* O documento HTML começa com `<!DOCTYPE html>`, e o modelo de caixa CSS
  para todos os elementos HTML está definido como [`border-box`][`border-box`],
  para consistência com o modelo Flutter.

  ```css
  {
      box-sizing: border-box;
  }
  ```
* No Flutter, o estilo padrão do texto 'Lorem ipsum'
  é definido pela variável `bold24Roboto` da seguinte forma,
  para manter a sintaxe simples:

  <?code-excerpt "lib/main.dart (text-style)"?>
  ```dart
  TextStyle bold24Roboto = const TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );
  ```

:::secondary
Como a programação no estilo react, ou _declarativa_, é diferente do
estilo imperativo tradicional?
Para uma comparação, veja [Introduction to declarative UI][Introduction to declarative UI].
:::

## Performing basic layout operations

Os exemplos a seguir mostram como realizar as tarefas mais comuns de layout de UI.

### Styling and aligning text

Estilo de fonte, tamanho e outros atributos de texto que o CSS
manipula com as propriedades font e color são propriedades individuais
de um [`TextStyle`][`TextStyle`] filho de um widget [`Text`][`Text`].

Para a propriedade text-align no CSS que é usada para alinhar texto,
há uma propriedade textAlign de um widget [`Text`][`Text`].

Em HTML e Flutter, os elementos ou widgets filhos
são ancorados no canto superior esquerdo, por padrão.

```css highlightLines=9
<div class="grey-box">
  Lorem ipsum
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Georgia;
}
```

```dart highlightLines=8-13
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: const Text(
    'Lorem ipsum',
    style: TextStyle(
      fontFamily: 'Georgia',
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    textAlign: TextAlign.center,
  ),
);
```

### Setting background color

No Flutter, você define a cor de fundo usando a propriedade `color`
ou a propriedade `decoration` de um [`Container`][`Container`].
No entanto, você não pode fornecer ambas, pois isso potencialmente
resultaria na decoration desenhando sobre a cor de fundo.
A propriedade `color` deve ser preferida
quando o fundo for uma cor simples.
Para outros casos, como gradientes ou imagens,
use a propriedade `decoration`.

Os exemplos CSS usam os equivalentes em cor hexadecimal para a paleta de cores Material.

```css highlightLines=6
<div class="grey-box">
  Lorem ipsum
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
}
```

```dart highlightLines=5
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Text(
    'Lorem ipsum',
    style: bold24Roboto,
  ),
);
```

```dart highlightLines=5-7
final container = Container(
  // grey box
  width: 320,
  height: 240,
  decoration: BoxDecoration(
    color: Colors.grey[300],
  ),
  child: Text(
    'Lorem ipsum',
    style: bold24Roboto,
  ),
);
```

### Centering components

Um widget [`Center`][`Center`] centraliza seu filho tanto horizontalmente
quanto verticalmente.

Para realizar um efeito similar em CSS, o elemento pai usa um comportamento
de exibição flex ou table-cell. Os exemplos nesta página mostram o comportamento
flex.

```css highlightLines=10-12
<div class="grey-box">
  Lorem ipsum
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
```

```dart highlightLines=6-7
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Text(
      'Lorem ipsum',
      style: bold24Roboto,
    ),
  ),
);
```

### Setting container width

Para especificar a largura de um widget [`Container`][`Container`],
use sua propriedade `width`.
Esta é uma largura fixa, diferente da propriedade max-width do CSS
que ajusta a largura do container até um valor máximo.
Para imitar esse efeito no Flutter,
use a propriedade `constraints` do Container.
Crie um novo widget [`BoxConstraints`][`BoxConstraints`] com `minWidth` ou `maxWidth`.

Para Containers aninhados, se a largura do pai for menor que a largura do filho,
o Container filho se dimensiona para corresponder ao pai.

```css highlightLines=9,20-21
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    width: 100%;
    max-width: 240px;
}
```

```dart highlightLines=3,9
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      width: 240, // max-width is 240
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      child: Text(
        'Lorem ipsum',
        style: bold24Roboto,
      ),
    ),
  ),
);
```

## Manipulating position and size

Os exemplos a seguir mostram como realizar operações mais complexas
na posição, tamanho e fundo do widget.

### Setting absolute position

Por padrão, widgets são posicionados relativos aos seus pais.

Para especificar uma posição absoluta para um widget como coordenadas x-y,
aninhe-o em um widget [`Positioned`][`Positioned`] que está,
por sua vez, aninhado em um widget [`Stack`][`Stack`].

```css highlightLines=8,18-20
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    position: relative;
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    position: absolute;
    top: 24px;
    left: 24px;
}
```

```dart highlightLines=6-7,10-11
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Stack(
    children: [
      Positioned(
        // red box
        left: 24,
        top: 24,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red[400],
          ),
          child: Text(
            'Lorem ipsum',
            style: bold24Roboto,
          ),
        ),
      ),
    ],
  ),
);
```

### Rotating components

Para rotacionar um widget, aninhe-o em um widget [`Transform`][`Transform`].
Use as propriedades `alignment` e `origin` do widget Transform
para especificar a origem da transformação (ponto de apoio) em termos relativos e absolutos,
respectivamente.

Para uma rotação 2D simples, na qual o widget é rotacionado no eixo Z,
crie um novo objeto de identidade [`Matrix4`][`Matrix4`]
e use seu método `rotateZ()` para especificar o fator de rotação
usando radianos (graus × π / 180).

```css highlightLines=20
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    transform: rotate(15deg);
}
```

```dart highlightLines=7-10,
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateZ(15 * 3.1415927 / 180),
      child: Container(
        // red box
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[400],
        ),
        child: Text(
          'Lorem ipsum',
          style: bold24Roboto,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);
```

### Scaling components

Para escalar um widget para cima ou para baixo, aninhe-o em um widget [`Transform`][`Transform`].
Use as propriedades `alignment` e `origin` do widget Transform
para especificar a origem da transformação (ponto de apoio) em termos relativos ou absolutos,
respectivamente.

Para uma operação de escala simples ao longo do eixo x,
crie um novo objeto de identidade [`Matrix4`][`Matrix4`]
e use seu método `scale()` para especificar o fator de escala.

Quando você escala um widget pai,
seus widgets filhos são escalados de acordo.

```css highlightLines=20
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    transform: scale(1.5);
}
```

```dart highlightLines=7-10
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..scaleByDouble(1.5, 1.5, 1.5, 1.5),
      child: Container(
        // red box
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[400],
        ),
        child: Text(
          'Lorem ipsum',
          style: bold24Roboto,
          textAlign: TextAlign.center,
        ),
      ),
    ),
  ),
);
```

### Applying a linear gradient

Para aplicar um gradiente linear ao fundo de um widget,
aninhe-o em um widget [`Container`][`Container`].
Em seguida, use a propriedade `decoration` do widget Container para criar um
objeto [`BoxDecoration`][`BoxDecoration`], e use a propriedade `gradient`
de BoxDecoration para transformar o preenchimento de fundo.

O "ângulo" do gradiente é baseado nos valores de Alignment (x, y):

* Se os valores x inicial e final forem iguais,
  o gradiente é vertical (0° | 180°).
* Se os valores y inicial e final forem iguais,
  o gradiente é horizontal (90° | 270°).

#### Vertical gradient

```css highlightLines=19
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    padding: 16px;
    color: #ffffff;
    background: linear-gradient(180deg, #ef5350, rgba(0, 0, 0, 0) 80%);
}
```

```dart highlightLines=9-18
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.0, 0.6),
          colors: <Color>[
            Color(0xffef5350),
            Color(0x00ef5350),
          ],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        'Lorem ipsum',
        style: bold24Roboto,
      ),
    ),
  ),
);
```

#### Horizontal gradient

```css highlightLines=19
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    padding: 16px;
    color: #ffffff;
    background: linear-gradient(90deg, #ef5350, rgba(0, 0, 0, 0) 80%);
}
```

```dart highlightLines=10-19
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-1.0, 0.0),
          end: Alignment(0.6, 0.0),
          colors: <Color>[
            Color(0xffef5350),
            Color(0x00ef5350),
          ],
        ),
      ),
      child: Text(
        'Lorem ipsum',
        style: bold24Roboto,
      ),
    ),
  ),
);
```

## Manipulating shapes

Os exemplos a seguir mostram como criar e customizar formas.

### Rounding corners

Para arredondar os cantos de uma forma retangular,
use a propriedade `borderRadius` de um objeto [`BoxDecoration`][`BoxDecoration`].
Crie um novo objeto [`BorderRadius`][`BorderRadius`]
que especifica o raio para arredondar cada canto.

```css highlightLines=20
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    border-radius: 8px;
}
```

```dart highlightLines=12-14
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red circle
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
        borderRadius: const BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Text(
        'Lorem ipsum',
        style: bold24Roboto,
      ),
    ),
  ),
);
```

### Adding box shadows

No CSS, você pode especificar o deslocamento e o desfoque da sombra de forma abreviada,
usando a propriedade box-shadow. Este exemplo mostra duas box shadows,
com propriedades:

* `xOffset: 0px, yOffset: 2px, blur: 4px, color: black @80% alpha`
* `xOffset: 0px, yOffset: 06x, blur: 20px, color: black @50% alpha`

No Flutter, cada propriedade e valor é especificado separadamente.
Use a propriedade `boxShadow` de `BoxDecoration` para criar uma lista de
widgets [`BoxShadow`][`BoxShadow`]. Você pode definir um ou múltiplos
widgets `BoxShadow`, que podem ser empilhados
para customizar a profundidade da sombra, cor e assim por diante.

```css highlightLines=20-21
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.8),
              0 6px 20px rgba(0, 0, 0, 0.5);
}
```

```dart highlightLines=15-26
final container = Container(
  // grey box
  width: 320,
  height: 240,
  margin: const EdgeInsets.only(bottom: 16),
  decoration: BoxDecoration(
    color: Colors.grey[300],
  ),
  child: Center(
    child: Container(
      // red box
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0xcc000000),
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: Color(0x80000000),
            offset: Offset(0, 6),
            blurRadius: 20,
          ),
        ],
      ),
      child: Text(
        'Lorem ipsum',
        style: bold24Roboto,
      ),
    ),
  ),
);
```

### Making circles and ellipses

Fazer um círculo em CSS requer uma solução alternativa de aplicar um
border-radius de 50% em todos os quatro lados de um retângulo,
embora existam [basic shapes][basic shapes].

Embora essa abordagem seja suportada
com a propriedade `borderRadius` de [`BoxDecoration`][`BoxDecoration`],
o Flutter fornece uma propriedade `shape`
com enum [`BoxShape` enum][`BoxShape` enum] para este propósito.

```css highlightLines=20-23
<div class="grey-box">
  <div class="red-circle">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-circle {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    text-align: center;
    width: 160px;
    height: 160px;
    border-radius: 50%;
}
```

```dart highlightLines=11,14-15,19
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red circle
      decoration: BoxDecoration(
        color: Colors.red[400],
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(16),
      width: 160,
      height: 160,
      child: Text(
        'Lorem ipsum',
        style: bold24Roboto,
        textAlign: TextAlign.center,
      ),
    ),
  ),
);
```

## Manipulating text

Os exemplos a seguir mostram como especificar fontes e outros
atributos de texto. Eles também mostram como transformar strings de texto,
customizar espaçamento e criar trechos.

### Adjusting text spacing

No CSS, você especifica a quantidade de espaço em branco
entre cada letra ou palavra fornecendo um valor de comprimento
para as propriedades letter-spacing e word-spacing, respectivamente.
A quantidade de espaço pode ser em px, pt, cm, em, etc.

No Flutter, você especifica o espaço em branco como pixels lógicos
(valores negativos são permitidos)
para as propriedades `letterSpacing` e `wordSpacing`
de um [`TextStyle`][`TextStyle`] filho de um widget `Text`.

```css highlightLines=20
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    letter-spacing: 4px;
}
```

```dart highlightLines=19
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      child: const Text(
        'Lorem ipsum',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: 4,
        ),
      ),
    ),
  ),
);
```

### Making inline formatting changes

Um widget [`Text`][`Text`] permite que você exiba texto
com algumas características de formatação.
Para exibir texto que usa múltiplos estilos
(neste exemplo, uma única palavra com ênfase),
use um widget [`RichText`][`RichText`] em vez disso.
Sua propriedade `text` pode especificar um ou mais
objetos [`TextSpan`][`TextSpan`] que podem ser individualmente estilizados.

No exemplo a seguir, "Lorem" está em um `TextSpan`
com o estilo de texto padrão (herdado),
e "ipsum" está em um `TextSpan` separado com estilo customizado.

```css highlightLines=3,11,21-4
<div class="grey-box">
  <div class="red-box">
    Lorem <em>ipsum</em>
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
}
.red-box em {
    font: 300 48px Roboto;
    font-style: italic;
}
```

```dart highlightLines=13-28
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      padding: const EdgeInsets.all(16),
      child: RichText(
        text: TextSpan(
          style: bold24Roboto,
          children: const <TextSpan>[
            TextSpan(text: 'Lorem '),
            TextSpan(
              text: 'ipsum',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontStyle: FontStyle.italic,
                fontSize: 48,
              ),
            ),
          ],
        ),
      ),
    ),
  ),
);
```

### Creating text excerpts

Um trecho exibe a(s) linha(s) inicial(is) de texto em um parágrafo,
e lida com o texto de transbordamento, frequentemente usando reticências.

No Flutter, use a propriedade `maxLines` de um widget [`Text`][`Text`]
para especificar o número de linhas a incluir no trecho,
e a propriedade `overflow` para lidar com o texto de transbordamento.

```css highlightLines=20-23
<div class="grey-box">
  <div class="red-box">
    Lorem ipsum dolor sit amet, consec etur
  </div>
</div>

.grey-box {
    background-color: #e0e0e0; /* grey 300 */
    width: 320px;
    height: 240px;
    font: 900 24px Roboto;
    display: flex;
    align-items: center;
    justify-content: center;
}
.red-box {
    background-color: #ef5350; /* red 400 */
    padding: 16px;
    color: #ffffff;
    overflow: hidden;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
}
```

```dart highlightLines=16-17
final container = Container(
  // grey box
  width: 320,
  height: 240,
  color: Colors.grey[300],
  child: Center(
    child: Container(
      // red box
      decoration: BoxDecoration(
        color: Colors.red[400],
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        'Lorem ipsum dolor sit amet, consec etur',
        style: bold24Roboto,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    ),
  ),
);
```


[basic shapes]: https://developer.mozilla.org/en-US/docs/Web/CSS/basic-shape
[`border-box`]: https://css-tricks.com/box-sizing/
[`BorderRadius`]: {{site.api}}/flutter/painting/BorderRadius-class.html
[`BoxDecoration`]: {{site.api}}/flutter/painting/BoxDecoration-class.html
[`BoxConstraints`]: {{site.api}}/flutter/rendering/BoxConstraints-class.html
[`BoxShape` enum]: {{site.api}}/flutter/painting/BoxShape.html
[`BoxShadow`]: {{site.api}}/flutter/painting/BoxShadow-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[Introduction to declarative UI]: /get-started/flutter-for/declarative
[Learning Dart as a JavaScript Developer]: {{site.dart-site}}/guides/language/coming-from/js-to-dart
[`Matrix4`]: {{site.api}}/flutter/vector_math_64/Matrix4-class.html
[`Positioned`]: {{site.api}}/flutter/widgets/Positioned-class.html
[`RichText`]: {{site.api}}/flutter/widgets/RichText-class.html
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`TextSpan`]: {{site.api}}/flutter/painting/TextSpan-class.html
[`TextStyle`]: {{site.api}}/flutter/painting/TextStyle-class.html
[`Transform`]: {{site.api}}/flutter/widgets/Transform-class.html
[Understanding constraints]: /ui/layout/constraints
