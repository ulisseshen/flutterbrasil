---
ia-translate: true
title: Layouts
description: Aprenda como criar layouts no Flutter.
prev:
  title: Widgets
  path: /get-started/fundamentals/widgets
next:
  title: State management
  path: /get-started/fundamentals/state-management
---

Dado que Flutter é um toolkit de UI,
você passará muito tempo criando layouts
com widgets Flutter. Nesta seção,
você aprenderá como construir layouts com alguns dos
widgets de layout mais comuns.
Você usará o Flutter DevTools (também
chamado de Dart DevTools) para entender como
o Flutter está criando seu layout.
Finalmente, você encontrará e depurará um dos
erros de layout mais comuns do Flutter,
o temido erro de "unbounded constraints".

## Understanding layout in Flutter

O núcleo do mecanismo de layout do Flutter são widgets.
No Flutter, quase tudo é um widget — até
modelos de layout são widgets.
As imagens, ícones e texto que você vê em um
app Flutter são todos widgets.
Coisas que você não vê também são widgets,
como as rows, columns e grids que organizam,
restringem e alinham os widgets visíveis.

Você cria um layout compondo widgets para
construir widgets mais complexos. Por exemplo,
o diagrama abaixo mostra 3 ícones com um label abaixo
de cada um, e a árvore de widgets correspondente:

<img src='/assets/images/docs/fwe/layout/simple_row_column_widget_tree.png' alt="A diagram that shows widget composition with a series of lines and nodes.">

Neste exemplo, há uma row de 3 columns onde
cada column contém um ícone e um label.
Todos os layouts, não importa quão complexos,
são criados compondo esses widgets de layout.

### Constraints

Entender constraints no Flutter é uma
parte importante de entender
como o layout funciona no Flutter.

Layout, em um sentido geral, refere-se ao tamanho dos
widgets e suas posições na tela.
O tamanho e posição de qualquer widget dado é
restringido por seu pai;
ele não pode ter qualquer tamanho que quiser,
e não decide seu próprio lugar na tela.
Em vez disso, tamanho e posição são determinados por
uma conversa entre um widget e seu pai.

No exemplo mais simples,
a conversa de layout se parece com isso:

 1. Um widget recebe suas constraints de seu pai.
 2. Uma constraint é apenas um conjunto de 4 doubles:
    uma largura mínima e máxima,
    e uma altura mínima e máxima.
 3. O widget determina qual tamanho deve ter
    dentro dessas constraints, e passa sua
    largura e altura de volta ao pai.
 4. O pai olha para o tamanho que quer ter e
    como deve ser alinhado,
    e define a posição do widget de acordo.
    O alinhamento pode ser definido explicitamente,
    usando uma variedade de widgets como `Center`,
    e as propriedades de alinhamento em `Row` e `Column`.

No Flutter, esta conversa de layout é frequentemente
expressa com a frase simplificada,
"Constraints go down. Sizes go up.
Parent sets the position."

### Box types

No Flutter, widgets são renderizados por seus
objetos [`RenderBox`][] subjacentes.
Esses objetos determinam como lidar com as
constraints que recebem.

Geralmente, existem três tipos de boxes:
* Aquelas que tentam ser o maior possível.
Por exemplo, as boxes usadas por
[`Center`][] e [`ListView`][].
* Aquelas que tentam ser do mesmo tamanho que seus
filhos. Por exemplo, as boxes usadas por
[`Transform`][] e [`Opacity`][]
* Aquelas que tentam ser de um tamanho particular.
Por exemplo, as boxes usadas por
[`Image`][] e [`Text`][].

Alguns widgets, por exemplo [`Container`][],
variam de tipo para tipo com base em seus
argumentos de construtor.
O construtor `Container` tenta por padrão ser
tão grande quanto possível, mas se você der a ele uma largura,
por exemplo, ele tenta honrar isso e
ser daquele tamanho particular.

Outros, por exemplo [`Row`][] e [`Column`][] (flex boxes)
variam com base nas constraints que recebem.
Leia mais sobre flex boxes e constraints no
artigo [Understanding Constraints][Understanding Constraints article].

## Lay out a single widget

Para fazer o layout de um único widget no Flutter,
envolva um widget visível,
como `Text` ou `Image` com um widget que
pode mudar sua posição na tela,
como um widget `Center`.

:::note Note
Os exemplos nesta página usam um widget chamado
`BorderedImage`. Este é um widget customizado,
e é usado aqui para esconder
o código que não é relevante para este tópico.
:::

```dart
Widget build(BuildContext context) {
  return Center(
    child: BorderedImage(),
  );
}
```

A figura a seguir mostra um widget que não está
alinhado à esquerda,
e um widget que foi centralizado à direita.

<img src='/assets/images/docs/fwe/layout/center.png' alt="A screenshot of a centered widget and a screenshot of a widget that hasn't been centered.">

Todos os widgets de layout têm uma das seguintes propriedades:
* Uma propriedade `child` se eles recebem um único
filho—por exemplo, `Center`, `Container`,
ou `Padding`.
* Uma propriedade `children` se eles recebem uma lista
de widgets—por exemplo,
`Row`, `Column`, `ListView`, ou `Stack`.

### Container

`Container` é um widget de conveniência que é
composto de vários widgets responsáveis por layout,
pintura, posicionamento e dimensionamento.
Em relação ao layout,
ele pode ser usado para adicionar padding e
margins a um widget.
Também existe um widget `Padding`
que poderia ser usado aqui com o mesmo efeito.
O exemplo a seguir usa um `Container`.

```dart
Widget build(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),
    child: BorderedImage(),
  );
}
```

A figura a seguir mostra um widget sem
padding à esquerda,
e um widget com padding à direita.

<img src='/assets/images/docs/fwe/layout/padding.png' alt="A screenshot of a widget with padding and a screenshot of a widget without padding.">

Para criar layouts mais complexos no Flutter,
você pode compor muitos widgets.
Por exemplo, você pode combinar `Container` e `Center`:

```dart
Widget build(BuildContext context) {
  return Center(
    Container(
      padding: EdgeInsets.all(16.0),
      child: BorderedImage(),
    ),
  );
}
```

## Layout multiple widgets vertically or horizontally

Um dos padrões de layout mais comuns é
organizar widgets vertical ou horizontalmente.
Você pode usar um widget `Row` para organizar widgets
horizontalmente,
e um widget `Column` para organizar widgets verticalmente.
A primeira figura nesta página usou ambos.

Este é o exemplo mais básico de uso de um widget `Row`.

{% render "docs/code-and-image.md",
image:"fwe/layout/row.png",
caption: "This figure shows a row widget with three children."
alt: "A screenshot of a row widget with three children"
code:"
```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      BorderedImage(),
      BorderedImage(),
      BorderedImage(),
    ],
  );
}
```
" %}

Cada filho de `Row` ou `Column` pode ser
rows e columns em si mesmos,
combinando para fazer um layout complexo.
Por exemplo, você poderia adicionar labels a cada
uma das imagens no exemplo acima usando columns.


{% render "docs/code-and-image.md",
image:"fwe/layout/nested_row_column.png",
caption: "This figure shows a row widget with three children, each of which is a column."
alt: "A screenshot of a row of three widgets, each of which has a label underneath it."
code:"
```dart
Widget build(BuildContext context) {
  return Row(
    children: [
      Column(
        children: [
          BorderedImage(),
          Text('Dash 1'),
        ],
      ),
      Column(
        children: [
          BorderedImage(),
          Text('Dash 2'),
        ],
      ),
      Column(
        children: [
          BorderedImage(),
          Text('Dash 3'),
        ],
      ),
    ],
  );
}
```
" %}


### Align widgets within rows and columns

No exemplo a seguir,
os widgets têm cada um 200 pixels de largura,
e o viewport tem 700 pixels de largura.
Os widgets são consequentemente alinhados à esquerda,
um após o outro,
com todo o espaço extra à direita.

<img src='/assets/images/docs/fwe/layout/left_alignment.png' alt="A diagram that shows three widgets laid out in a row. Each child widget is labeled as 200px wide, and the blank space on the right is labeled as 100px wide.">

Você controla como uma row ou column alinha seus
filhos usando as propriedades `mainAxisAlignment` e
`crossAxisAlignment`.
Para uma row, o eixo principal corre horizontalmente e
o eixo cruzado corre verticalmente. Para uma column,
o eixo principal corre
verticalmente e o eixo cruzado corre horizontalmente.

<img src='/assets/images/docs/fwe/layout/axes_diagram.png' alt="A diagram that shows the direction of the main axis and cross axis in both rows and columns">

Definir o alinhamento do eixo principal como `spaceEvenly`
divide o espaço horizontal livre uniformemente entre,
antes, e depois de cada imagem.

{% render "docs/code-and-image.md",
image:"fwe/layout/space_evenly.png",
caption: "This figure shows a row widget with three children, which are aligned with the MainAxisAlignment.spaceEvenly constant."
alt: "A screenshot of three widgets, spaced evenly from each other."
code:"
```dart
Widget build(BuildContext context) {
  return Row(
    [!mainAxisAlignment: MainAxisAlignment.spaceEvenly!],
    children: [
      BorderedImage(),
      BorderedImage(),
      BorderedImage(),
    ],
  );
}
```
" %}

Columns funcionam da mesma forma que rows.
O exemplo a seguir mostra uma column de 3 imagens,
cada uma tem 100 pixels de altura. A altura da
render box (neste caso, a tela inteira)
é mais de 300 pixels,
então definir o alinhamento do eixo principal como `spaceEvenly`
divide o espaço vertical livre uniformemente entre,
acima, e abaixo de cada imagem.

<img src='/assets/images/docs/fwe/layout/col_space_evenly.png' alt="A screenshot of a three widgets laid out vertically, using a column widget.">

Os enums [`MainAxisAlignment`][] e [`CrossAxisAlignment`][]
oferecem uma variedade de constantes para
controlar o alinhamento.

Flutter inclui outros widgets que podem ser usados
para alinhamento, notavelmente o widget `Align`.

### Sizing widgets within rows and columns

Quando um layout é muito grande para caber em um dispositivo,
um padrão listrado amarelo e preto aparece
ao longo da borda afetada.
Neste exemplo, o viewport tem 400 pixels de largura,
e cada filho tem 150 pixels de largura.

<img src='/assets/images/docs/fwe/layout/overflowing_row.png' alt="A screenshot of a row of widgets that are wider than their viewport.">

Widgets podem ser dimensionados para caber dentro de uma
row ou column usando o widget `Expanded`.
Para corrigir o exemplo anterior onde a row de
imagens é muito larga para sua render box,
envolva cada imagem com um widget [`Expanded`][].

{% render "docs/code-and-image.md",
image:"fwe/layout/expanded_row.png",
caption: "This figure shows a row widget with three children that are wrapped with `Expanded` widgets."
alt: "A screenshot of three widgets, which take up exactly the amount of space available on the main axis. All three widgets are equal width."
code:"
```dart
Widget build(BuildContext context) {
  return const Row(
    children: [
      [!Expanded!](
        child: BorderedImage(width: 150, height: 150),
      ),
      [!Expanded!](
        child: BorderedImage(width: 150, height: 150),
      ),
      [!Expanded!](
        child: BorderedImage(width: 150, height: 150),
      ),
    ],
  );
}
```
" %}

O widget `Expanded` também pode ditar quanto
espaço um widget deve ocupar em relação
aos seus irmãos. Por exemplo,
talvez você queira que um widget ocupe o dobro
de espaço que seus irmãos.
Para isso, use a propriedade `flex` do widget `Expanded`,
um inteiro que determina o fator flex
para um widget. O fator flex padrão é 1.
O código a seguir define o fator flex da
imagem do meio como 2:

{% render "docs/code-and-image.md",
image:"fwe/layout/flex_2_row.png",
caption: "This figure shows a row widget with three children which are wrapped with `Expanded` widgets. The center child has it's `flex` property set to 2."
alt: "A screenshot of three widgets, which take up exactly the amount of space available on the main axis. The widget in the center is twice as wide as the widgets on the left and right."
code:"
```dart
Widget build(BuildContext context) {
  return const Row(
    children: [
      Expanded(
        child: BorderedImage(width: 150, height: 150),
      ),
      Expanded(
        [!flex: 2!],
        child: BorderedImage(width: 150, height: 150),
      ),
      Expanded(
        child: BorderedImage(width: 150, height: 150),
      ),
    ],
  );
}
```
" %}

## DevTools and debugging layout

Em certas situações,
a constraint de uma box é unbounded, ou infinita.
Isso significa que a largura máxima ou a
altura máxima é definida como [`double.infinity`][].
Uma box que tenta ser o maior possível não
funcionará de forma útil quando receber uma
constraint unbounded e, no modo debug,
lança uma exceção.

O caso mais comum onde uma render box termina
com uma constraint unbounded é dentro de uma
flex box ([`Row`][] ou [`Column`][]),
e dentro de uma região rolável
(como [`ListView`][] e outras subclasses de [`ScrollView`][]).
`ListView`, por exemplo, tenta expandir para
caber no espaço disponível em sua direção cruzada
(talvez seja um bloco que rola verticalmente
e tenta ser tão largo quanto seu pai).
Se você aninhar uma `ListView` que rola verticalmente
dentro de uma `ListView` que rola horizontalmente,
a lista interna tenta ser tão larga quanto possível,
o que é infinitamente largo, já que a externa é
rolável naquela direção.

Talvez o erro mais comum que você encontrará
ao construir uma aplicação Flutter seja devido ao
uso incorreto de widgets de layout,
e é chamado de erro de "unbounded constraints".

Se houvesse apenas um tipo de erro que você deveria estar
preparado para enfrentar quando começar a construir
apps Flutter, seria este.

<YouTubeEmbed id="jckqXR5CrPI" title="Decoding Flutter: Unbounded height and width"></YouTubeEmbed>

:::note The Widget inspector
Flutter tem um conjunto robusto de DevTools que
ajudam você a trabalhar com qualquer número de aspectos do
desenvolvimento Flutter.
A ferramenta "Widget Inspector" é particularmente
útil ao construir e depurar layouts (e trabalhar com widgets em geral).

[Saiba mais sobre o Flutter inspector][Learn more about the Flutter inspector].
:::

##  Scrolling widgets

Flutter tem muitos widgets integrados que
automaticamente rolam e também oferece uma variedade de
widgets que você pode customizar para
criar comportamento de rolagem específico.
Nesta página, você verá como usar o widget mais comum para
tornar qualquer página rolável,
bem como um widget para criar listas roláveis.

### ListView

`ListView` é um widget tipo column que
automaticamente fornece rolagem quando seu
conteúdo é mais longo que sua render box.
A maneira mais básica de usar uma `ListView` é
muito similar a usar uma `Column` ou `Row`.
Diferente de uma column ou row,
uma `ListView` requer que seus filhos ocupem
todo o espaço disponível no eixo cruzado,
como mostrado no exemplo abaixo.

{% render "docs/code-and-image.md",
image:"fwe/layout/basic_listview.png",
caption: "This figure shows a ListView widget with three children."
alt: "A screenshot of three widgets laid out vertically. They have expanded to take up all available space on the cross axis."
code:"
```dart
Widget build(BuildContext context) {
  return [!ListView!](
    children: const [
      BorderedImage(),
      BorderedImage(),
      BorderedImage(),
    ],
  );
}
```
" %}

`ListView`s são comumente usadas quando você tem um
número desconhecido ou muito grande (ou infinito) de itens de lista.
Quando este é o caso,
é melhor usar o construtor `ListView.builder`.
O construtor builder constrói apenas os
filhos que estão atualmente visíveis na tela.

No exemplo a seguir,
a `ListView` está exibindo uma lista de itens de to-do.
Os itens de todo estão sendo buscados de um repositório,
e portanto o número de todos é desconhecido.


{% render "docs/code-and-image.md",
image:"fwe/layout/listview_builder.png",
caption: "This figure shows the ListView.builder constructor to display an unknown number of children."
alt: "A screenshot of several widgets laid out vertically. They have expanded to take up all available space on the cross axis."
code:"
```dart
final List<ToDo> items = Repository.fetchTodos();

Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, idx) {
      var item = items[idx];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Text(item.isComplete),
          ],
        ),
      );
    },
  );
}
```
" %}

## Adaptive layouts

Como Flutter é usado para criar apps mobile,
tablet, desktop, _e_ web,
é provável que você precise ajustar sua
aplicação para se comportar de forma diferente dependendo de
coisas como tamanho de tela ou dispositivo de entrada.
Isso é referido como tornar um app
_adaptativo_ e _responsivo_.

Um dos widgets mais úteis para fazer
layouts adaptativos é o widget [`LayoutBuilder`][].
`LayoutBuilder` é um dos muitos widgets que usam
o padrão "builder" no Flutter.

### The builder pattern

No Flutter, você encontrará vários widgets que usam
a palavra "builder" em seus nomes ou
em seus construtores.
A lista a seguir não é exaustiva:

* [`ListView.builder`][]
* [`GridView.builder`][]
* [`Builder`][]
* [`LayoutBuilder`][]
* [`FutureBuilder`][]

Esses diferentes "builders" são úteis para resolver
diferentes problemas. Por exemplo,
o construtor `ListView.builder` é usado principalmente
para renderizar itens em uma lista de forma lazy,
enquanto o widget `Builder` é útil para ganhar
acesso ao `BuildContext` em código de widget profundo.

Apesar de seus diferentes casos de uso,
esses builders são unificados por como funcionam.
Widgets builder e construtores builder todos têm
argumentos chamados 'builder'
(ou algo similar,
como `itemBuilder` no caso de `ListView.builder`),
e o argumento builder sempre aceita um
callback.
Este callback é uma __função builder__.
Funções builder são callbacks que passam dados para
o widget pai,
e o widget pai usa esses argumentos para
construir e retornar o widget filho.
Funções builder sempre passam pelo menos
um argumento–o build context–
e geralmente pelo menos um outro argumento.

Por exemplo, o widget `LayoutBuilder` é usado
para criar layouts responsivos baseados
no tamanho do viewport. O callback builder
recebe as [`BoxConstraints`][] que ele recebe
de seu pai, junto com o 'BuildContext' do widget.
Com essas constraints, você pode retornar um
widget diferente baseado no espaço disponível.

<YouTubeEmbed id="IYDVcriKjsw" title="LayoutBuilder (Flutter Widget of the Week)"></YouTubeEmbed>

No exemplo a seguir,
o widget retornado pelo `LayoutBuilder`
muda com base em se o viewport é
menor ou igual a 600 pixels,
ou maior que 600 pixels.


{% render "docs/code-and-image.md",
image:"fwe/layout/layout_builder.png",
caption: "This figure shows a narrow layout, which lays out its children vertically, and a wider layout, which lays out its children in a grid."
alt: "Two screenshots, in which one shows a narrow layout and the other shows a wide layout."
code:"
```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      [!if (constraints.maxWidth <= 600)!] {
        return _MobileLayout();
      } else {
        return _DesktopLayout();
      }
    },
  );
}
```
" %}

Enquanto isso, o callback `itemBuilder` no
construtor `ListView.builder` recebe o
build context e um `int`.
Este callback é chamado uma vez para cada item
na lista,
e o argumento int representa o índice do item da lista.
A primeira vez que o callback itemBuilder é chamado
quando o Flutter está construindo a UI,
o int passado para a função é 0,
a segunda vez é 1, e assim por diante.

Isso permite que você forneça configuração específica
baseada no índice. Lembre-se do exemplo acima usando
o construtor`ListView.builder`:

```dart
final List<ToDo> items = Repository.fetchTodos();

Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, idx) {
      var item = items[idx];
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Text(item.isComplete),
          ],
        ),
      );
    },
  );
}
```

Este código de exemplo usa o índice que é
passado para o builder para pegar o todo correto
da lista de itens,
e então exibe os dados daquele todo no
widget que é retornado do builder.

Para exemplificar isso,
o exemplo a seguir muda a
cor de fundo de cada outro item da lista.

{% render "docs/code-and-image.md",
image:"fwe/layout/alternating_list_items.png"
caption:"This figure shows a `ListView`, in which its children have alternating background colors. The background colors were determined programmatically based on the index of the child within the `ListView`."
code:"
```dart
final List<ToDo> items = Repository.fetchTodos();

Widget build(BuildContext context) {
  return ListView.builder(
    itemCount: items.length,
    itemBuilder: (context, idx) {
      var item = items[idx];
      return Container(
        [!color: idx % 2 == 0 ? Colors.lightBlue : Colors.transparent!],
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(item.description),
            Text(item.isComplete),
          ],
        ),
      );
    },
  );
}
```
" %}

## Additional resources

* Common layout widgets and concepts
  * Video: [OverlayPortal—Flutter Widget of the Week][]
  * Video: [Stack—Flutter Widget of the Week][]
  * Tutorial: [Layouts in Flutter][]
  * Documentation: [Stack documentation][]
* Sizing and positioning widgets
  * Video: [Expanded—Flutter Widget of the Week][]
  * Video: [Flexible—Flutter Widget of the Week][]
  * Video: [Intrinsic widgets—Decoding Flutter][]
* Scrollable widgets
  * Example code: [Work with long lists][]
  * Example code: [Create a horizontal list][]
  * Example code: [Create a grid list][]
  * Video: [ListView—Flutter Widget of the Week][]
* Adaptive Apps
  * Tutorial: [Adaptive Apps codelab][]
  * Video: [MediaQuery—Flutter Widget of the Week][]
  * Video: [Building platform adaptive apps][]
  * Video: [Builder—Flutter Widget of the Week][]

### API reference

The following resources explain individual APIs.

* [`Builder`][]
* [`Row`][]
* [`Column`][]
* [`Expanded`][]
* [`Flexible`][]
* [`ListView`][]
* [`Stack`][]
* [`Positioned`][]
* [`MediaQuery`][]
* [`LayoutBuilder`][]

[Layouts in Flutter]: /ui/layout
[Understanding Constraints article]: /ui/layout/constraints
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[Expanded—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=_rnZaagadyo
[Flexible—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=CI7x0mAZiY0
[Intrinsic widgets—Decoding Flutter]: {{site.youtube-site}}/watch?v=Si5XJ_IocEs
[Build a Flutter Layout]: /ui/layout/tutorial
[Basic scrolling]: /ui/layout/scrolling#basic-scrolling
[Builder—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=xXNOkIuSYuA
[ListView—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=KJpkjHGiI5A
[Work with long lists]: /cookbook/lists/long-lists
[Create a horizontal list]: /cookbook/lists/horizontal-list
[Create a grid list]: /cookbook/lists/grid-lists
[PageView—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=J1gE9xvph-A
[Stack—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=liEGSeD3Zt8
[Stack documentation]: /ui/layout#stack
[OverlayPortal—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=S0Ylpa44OAQ
[LayoutBuilder—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=IYDVcriKjsw
[MediaQuery—Flutter Widget of the Week]: {{site.youtube-site}}/watch?v=A3WrA4zAaPw
[Adaptive apps codelab]: {{site.codelabs}}/codelabs/flutter-adaptive-app
[Building platform adaptive apps]: {{site.youtube-site}}/watch?v=RCdeSKVt7LI
[Learn more about the Flutter inspector]: /tools/devtools/inspector
[Unbounded height and width—Decoding Flutter]: {{site.youtube-site}}/watch?v=jckqXR5CrPI
[2D Scrolling]: {{site.youtube-site}}/watch?v=ppEdTo-VGcg
[`Builder`]: {{site.api}}/flutter/widgets/Builder-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[`Flexible`]: {{site.api}}/flutter/widgets/Flexible-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`Positioned`]: {{site.api}}/flutter/widgets/Positioned-class.html
[`MediaQuery`]: {{site.api}}/flutter/widgets/MediaQuery-class.html
[`Transform`]:{{site.api}}/flutter/widgets/Transform-class.html
[`Opacity`]:{{site.api}}/flutter/widgets/Opacity-class.html
[`Center`]:{{site.api}}/flutter/widgets/Center-class.html
[`ListView`]:{{site.api}}/flutter/widgets/Listview-class.html
[`Image`]:{{site.api}}/flutter/widgets/Image-class.html
[`Text`]:{{site.api}}/flutter/widgets/Text-class.html
[`MainAxisAlignment`]: {{site.api}}/flutter/rendering/MainAxisAlignment.html
[`CrossAxisAlignment`]: {{site.api}}/flutter/rendering/CrossAxisAlignment.html
[`double.infinity`]:{{site.api}}/flutter/dart-core/double/infinity-constant.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`GridView.builder`]: {{site.api}}/flutter/widgets/GridView/GridView.builder.html
[`Builder`]: {{site.api}}/flutter/widgets/Builder-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/Scrollview-class.html
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`BoxConstraints`]:{{site.api}}/flutter/rendering/BoxConstraints-class.html
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`FutureBuilder`]: {{site.api}}/flutter/widgets/FutureBuilder-class.html
[`Container`]:{{site.api}}/flutter/widgets/Container-class.html
[`Column`]:{{site.api}}/flutter/widgets/Column-class.html
[`Row`]:{{site.api}}/flutter/widgets/Row-class.html
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html

## Feedback

À medida que esta seção do site está evoluindo,
nós [agradecemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="layout"
