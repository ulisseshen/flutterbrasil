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
Você usará Flutter DevTools (também
chamado de Dart DevTools) para entender como
Flutter está criando seu layout.
Finalmente, você encontrará e depurará um dos
erros de layout mais comuns do Flutter,
o temido erro de "unbounded constraints".

## Entendendo layout no Flutter

O núcleo do mecanismo de layout do Flutter são os widgets.
No Flutter, quase tudo é um widget — até mesmo
os modelos de layout são widgets.
As imagens, ícones e texto que você vê em um
app Flutter são todos widgets.
Coisas que você não vê também são widgets,
como as rows, columns e grids que organizam,
restringem e alinham os widgets visíveis.

Você cria um layout compondo widgets para
construir widgets mais complexos. Por exemplo,
o diagrama abaixo mostra 3 ícones com um rótulo sob
cada um, e a árvore de widgets correspondente:

<img src='/assets/images/docs/fwe/layout/simple_row_column_widget_tree.png' alt="A diagram that shows widget composition with a series of lines and nodes.">

Neste exemplo, há uma row de 3 columns onde
cada column contém um ícone e um rótulo.
Todos os layouts, não importa quão complexos,
são criados compondo esses widgets de layout.

### Constraints

Entender constraints no Flutter é uma
parte importante de entender
como o layout funciona no Flutter.

Layout, em um sentido geral, refere-se ao tamanho dos
widgets e suas posições na tela.
O tamanho e a posição de qualquer widget são
restritos por seu pai;
ele não pode ter qualquer tamanho que queira,
e ele não decide seu próprio lugar na tela.
Em vez disso, tamanho e posição são determinados por
uma conversa entre um widget e seu pai.

No exemplo mais simples,
a conversa de layout se parece com isso:

 1. Um widget recebe suas constraints de seu pai.
 2. Uma constraint é apenas um conjunto de 4 doubles:
    uma largura mínima e máxima,
    e uma altura mínima e máxima.
 3. O widget determina qual tamanho ele deve ter
    dentro dessas constraints, e passa sua
    largura e altura de volta ao pai.
 4. O pai olha para o tamanho que ele quer ter e
    como ele deve ser alinhado,
    e define a posição do widget de acordo.
    O alinhamento pode ser definido explicitamente,
    usando uma variedade de widgets como `Center`,
    e as propriedades de alinhamento em `Row` e `Column`.

No Flutter, esta conversa de layout é frequentemente
expressa com a frase simplificada,
"Constraints go down. Sizes go up.
Parent sets the position."

### Tipos de Box

No Flutter, widgets são renderizados por seus
objetos [`RenderBox`][] subjacentes.
Esses objetos determinam como lidar com as
constraints que são passadas.

Geralmente, há três tipos de boxes:
* Aquelas que tentam ser o maior possível.
Por exemplo, as boxes usadas por
[`Center`][] e [`ListView`][].
* Aquelas que tentam ser do mesmo tamanho que seus
filhos. Por exemplo, as boxes usadas por
[`Transform`][] e [`Opacity`][]
* Aquelas que tentam ter um tamanho específico.
Por exemplo, as boxes usadas por
[`Image`][] e [`Text`][].

Alguns widgets, por exemplo [`Container`][],
variam de tipo para tipo com base em seus
argumentos do construtor.
O construtor `Container` por padrão tenta
ser o maior possível, mas se você der a ele uma largura,
por exemplo, ele tenta honrar isso e
ter esse tamanho específico.

Outros, por exemplo [`Row`][] e [`Column`][] (flex boxes)
variam com base nas constraints que recebem.
Leia mais sobre flex boxes e constraints no
[artigo Understanding Constraints][Understanding Constraints article].

## Layout de um único widget

Para fazer o layout de um único widget no Flutter,
envolva um widget visível,
como `Text` ou `Image` com um widget que
possa mudar sua posição na tela,
como um widget `Center`.

:::note Nota
Os exemplos nesta página usam um widget chamado
`BorderedImage`. Este é um widget customizado,
e é usado aqui para ocultar
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

Todos os widgets de layout têm uma das seguintes opções:
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
Há também um widget `Padding`
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

## Layout de múltiplos widgets vertical ou horizontalmente

Um dos padrões de layout mais comuns é
organizar widgets vertical ou horizontalmente.
Você pode usar um widget `Row` para organizar widgets
horizontalmente,
e um widget `Column` para organizar widgets verticalmente.
A primeira figura nesta página usou ambos.

Este é o exemplo mais básico de uso de um widget `Row`.

{% render docs/code-and-image.md,
image:"fwe/layout/row.png",
caption: "Esta figura mostra um widget row com três filhos."
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
rows e columns eles mesmos,
combinando para criar um layout complexo.
Por exemplo, você poderia adicionar rótulos a cada
uma das imagens no exemplo acima usando columns.


{% render docs/code-and-image.md,
image:"fwe/layout/nested_row_column.png",
caption: "Esta figura mostra um widget row com três filhos, cada um dos quais é uma column."
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


### Alinhar widgets dentro de rows e columns

No exemplo a seguir,
os widgets têm cada um 200 pixels de largura,
e a viewport tem 700 pixels de largura.
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
antes e depois de cada imagem.

{% render docs/code-and-image.md,
image:"fwe/layout/space_evenly.png",
caption: "Esta figura mostra um widget row com três filhos, que são alinhados com a constante MainAxisAlignment.spaceEvenly."
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
cada uma com 100 pixels de altura. A altura da
render box (neste caso, a tela inteira)
é mais de 300 pixels,
então definir o alinhamento do eixo principal como `spaceEvenly`
divide o espaço vertical livre uniformemente entre,
acima e abaixo de cada imagem.

<img src='/assets/images/docs/fwe/layout/col_space_evenly.png' alt="A screenshot of a three widgets laid out vertically, using a column widget.">

Os enums [`MainAxisAlignment`][] e [`CrossAxisAlignment`][]
oferecem uma variedade de constantes para
controlar o alinhamento.

Flutter inclui outros widgets que podem ser usados
para alinhamento, notavelmente o widget `Align`.

### Dimensionando widgets dentro de rows e columns

Quando um layout é muito grande para caber em um dispositivo,
um padrão listrado amarelo e preto aparece
ao longo da borda afetada.
Neste exemplo, a viewport tem 400 pixels de largura,
e cada filho tem 150 pixels de largura.

<img src='/assets/images/docs/fwe/layout/overflowing_row.png' alt="A screenshot of a row of widgets that are wider than their viewport.">

Widgets podem ser dimensionados para caber dentro de uma
row ou column usando o widget `Expanded`.
Para corrigir o exemplo anterior onde a row de
imagens é muito larga para sua render box,
envolva cada imagem com um widget [`Expanded`][].

{% render docs/code-and-image.md,
image:"fwe/layout/expanded_row.png",
caption: "Esta figura mostra um widget row com três filhos que estão envolvidos com widgets `Expanded`."
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
do espaço de seus irmãos.
Para isso, use a propriedade `flex` do widget `Expanded`,
um inteiro que determina o fator flex
para um widget. O fator flex padrão é 1.
O código a seguir define o fator flex da
imagem do meio como 2:

{% render docs/code-and-image.md,
image:"fwe/layout/flex_2_row.png",
caption: "Esta figura mostra um widget row com três filhos que estão envolvidos com widgets `Expanded`. O filho central tem sua propriedade `flex` definida como 2."
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

## DevTools e depuração de layout

Em certas situações,
a constraint de uma box é unbounded, ou infinita.
Isso significa que ou a largura máxima ou a
altura máxima está definida como [`double.infinity`][].
Uma box que tenta ser o maior possível não
funcionará utilmente quando receber uma
constraint unbounded e, em modo debug,
lança uma exceção.

O caso mais comum onde uma render box acaba
com uma constraint unbounded é dentro de uma
flex box ([`Row`][] ou [`Column`][]),
e dentro de uma região scrollable
(como [`ListView`][] e outras subclasses de [`ScrollView`][]).
`ListView`, por exemplo, tenta expandir para
caber no espaço disponível em sua direção cruzada
(talvez seja um bloco com rolagem vertical
e tenta ser tão largo quanto seu pai).
Se você aninhar um `ListView` com rolagem vertical
dentro de um `ListView` com rolagem horizontal,
a lista interna tenta ser o mais larga possível,
o que é infinitamente largo, pois a externa é
scrollable naquela direção.

Talvez o erro mais comum que você encontrará
ao construir uma aplicação Flutter seja devido ao
uso incorreto de widgets de layout,
e é referido como o erro de "unbounded constraints".

Se houvesse apenas um tipo de erro que você deveria estar
preparado para enfrentar quando começar a construir
apps Flutter, seria este.

{% ytEmbed 'jckqXR5CrPI', 'Decoding Flutter: Unbounded height and width' %}

:::note O Widget inspector
Flutter tem um conjunto robusto de DevTools que
ajudam você a trabalhar com qualquer número de aspectos do
desenvolvimento Flutter.
A ferramenta "Widget Inspector" é particularmente
útil ao construir e depurar layouts (e trabalhar com widgets em geral).

[Aprenda mais sobre o Flutter inspector][Learn more about the Flutter inspector].
:::

##  Widgets de rolagem

Flutter tem muitos widgets integrados que
fazem rolagem automaticamente e também oferece uma variedade de
widgets que você pode customizar para
criar comportamento de rolagem específico.
Nesta página, você verá como usar o widget mais comum para
tornar qualquer página scrollable,
assim como um widget para criar listas scrollable.

### ListView

`ListView` é um widget similar a column que
fornece rolagem automaticamente quando seu
conteúdo é mais longo que sua render box.
A maneira mais básica de usar um `ListView` é
muito similar a usar um `Column` ou `Row`.
Diferente de uma column ou row,
um `ListView` requer que seus filhos ocupem
todo o espaço disponível no eixo cruzado,
como mostrado no exemplo abaixo. 

{% render docs/code-and-image.md,
image:"fwe/layout/basic_listview.png",
caption: "Esta figura mostra um widget ListView com três filhos."
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

`ListView`s são comumente usados quando você tem um
número desconhecido ou muito grande (ou infinito) de itens de lista.
Quando este é o caso,
é melhor usar o construtor `ListView.builder`.
O construtor builder apenas constrói os
filhos que estão atualmente visíveis na tela.

No exemplo a seguir,
o `ListView` está exibindo uma lista de itens de tarefas.
Os itens de tarefas estão sendo buscados de um repositório,
e portanto o número de tarefas é desconhecido.


{% render docs/code-and-image.md,
image:"fwe/layout/listview_builder.png",
caption: "Esta figura mostra o construtor ListView.builder para exibir um número desconhecido de filhos."
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

## Layouts adaptativos

Porque Flutter é usado para criar apps mobile,
tablet, desktop, _e_ web,
é provável que você precise ajustar sua
aplicação para se comportar de forma diferente dependendo de
coisas como tamanho de tela ou dispositivo de entrada.
Isso é referido como tornar um app
_adaptativo_ e _responsivo_.

Um dos widgets mais úteis para fazer
layouts adaptativos é o widget [`LayoutBuilder`][].
`LayoutBuilder` é um dos muitos widgets que usa
o padrão "builder" no Flutter.

### O padrão builder

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
problemas diferentes. Por exemplo,
o construtor `ListView.builder` é usado principalmente
para renderizar preguiçosamente itens em uma lista,
enquanto o widget `Builder` é útil para ganhar
acesso ao `BuildContext` em código de widget profundo.

Apesar de seus casos de uso diferentes,
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
no tamanho da viewport. O corpo do callback builder
recebe as [`BoxConstraints`][] que ele recebe
de seu pai, junto com o 'BuildContext' do widget.
Com essas constraints, você pode retornar um widget diferente
baseado no espaço disponível.

{% ytEmbed 'IYDVcriKjsw', 'LayoutBuilder (Flutter Widget of the Week)' %}

No exemplo a seguir,
o widget retornado pelo `LayoutBuilder`
muda baseado em se a viewport é
menor ou igual a 600 pixels,
ou maior que 600 pixels.


{% render docs/code-and-image.md,
image:"fwe/layout/layout_builder.png",
caption: "Esta figura mostra um layout estreito, que organiza seus filhos verticalmente, e um layout mais largo, que organiza seus filhos em um grid."
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
quando Flutter está construindo a UI,
o int passado para a função é 0,
a segunda vez é 1, e assim por diante.

Isso permite que você forneça configuração específica
baseada no índice. Lembre-se do exemplo acima usando
o construtor `ListView.builder`:

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
passado para o builder para pegar a tarefa
correta da lista de itens,
e então exibe os dados dessa tarefa no
widget que é retornado do builder.

Para exemplificar isso,
o exemplo a seguir muda a
cor de fundo de cada segundo item da lista.

{% render docs/code-and-image.md,
image:"fwe/layout/alternating_list_items.png"
caption:"Esta figura mostra um `ListView`, no qual seus filhos têm cores de fundo alternadas. As cores de fundo foram determinadas programaticamente com base no índice do filho dentro do `ListView`."
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

## Recursos adicionais

* Widgets de layout comuns e conceitos
  * Vídeo: [OverlayPortal—Flutter Widget of the Week][]
  * Vídeo: [Stack—Flutter Widget of the Week][]
  * Tutorial: [Layouts in Flutter][]
  * Documentação: [Stack documentation][]
* Dimensionamento e posicionamento de widgets
  * Vídeo: [Expanded—Flutter Widget of the Week][]
  * Vídeo: [Flexible—Flutter Widget of the Week][]
  * Vídeo: [Intrinsic widgets—Decoding Flutter][]
* Widgets scrollable
  * Código de exemplo: [Work with long lists][]
  * Código de exemplo: [Create a horizontal list][]
  * Código de exemplo: [Create a grid list][]
  * Vídeo: [ListView—Flutter Widget of the Week][]
* Apps adaptativos
  * Tutorial: [Adaptive Apps codelab][]
  * Vídeo: [MediaQuery—Flutter Widget of the Week][]
  * Vídeo: [Building platform adaptive apps][]
  * Vídeo: [Builder—Flutter Widget of the Week][]

### Referência da API

Os seguintes recursos explicam APIs individuais.

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

À medida que esta seção do site evolui,
[recebemos bem seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="layout"
