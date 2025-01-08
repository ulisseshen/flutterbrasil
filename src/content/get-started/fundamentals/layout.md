---
ia-translate: true
title: Layouts
description: Aprenda como criar layouts no Flutter.
prev:
  title: Widgets
  path: /get-started/fundamentals/widgets
next:
  title: Gerenciamento de estado
  path: /get-started/fundamentals/state-management
---

Dado que o Flutter é um kit de ferramentas de UI,
você passará muito tempo criando layouts
com widgets do Flutter. Nesta seção,
você aprenderá como construir layouts com alguns dos
widgets de layout mais comuns.
Você usará o Flutter DevTools (também
chamado de Dart DevTools) para entender como
o Flutter está criando seu layout.
Finalmente, você encontrará e depurará um dos
erros de layout mais comuns do Flutter,
o temido erro de "restrições ilimitadas".

## Entendendo o layout no Flutter

O núcleo do mecanismo de layout do Flutter são os widgets.
No Flutter, quase tudo é um widget — até mesmo
os modelos de layout são widgets.
As imagens, ícones e texto que você vê em um
aplicativo Flutter são todos widgets.
As coisas que você não vê também são widgets,
como as linhas, colunas e grids que organizam,
restringem e alinham os widgets visíveis.

Você cria um layout compondo widgets para
construir widgets mais complexos. Por exemplo,
o diagrama abaixo mostra 3 ícones com um rótulo embaixo
de cada um e a árvore de widgets correspondente:

<img src='/assets/images/docs/fwe/layout/simple_row_column_widget_tree.png' alt="Um diagrama que mostra a composição de widgets com uma série de linhas e nós.">

Neste exemplo, há uma linha de 3 colunas onde
cada coluna contém um ícone e um rótulo.
Todos os layouts, não importa quão complexos,
são criados compondo esses widgets de layout.

### Restrições

Entender as restrições no Flutter é uma
parte importante para entender
como o layout funciona no Flutter.

Layout, em um sentido geral, refere-se ao tamanho dos
widgets e suas posições na tela.
O tamanho e a posição de qualquer widget são
restringidos por seu pai;
ele não pode ter o tamanho que quiser,
e não decide seu próprio lugar na tela.
Em vez disso, o tamanho e a posição são determinados por
uma conversa entre um widget e seu pai.

No exemplo mais simples,
a conversa de layout se parece com isso:

 1. Um widget recebe suas restrições de seu pai.
 2. Uma restrição é apenas um conjunto de 4 doubles:
    uma largura mínima e máxima,
    e uma altura mínima e máxima.
 3. O widget determina qual tamanho deve ter
    dentro dessas restrições e passa sua
    largura e altura de volta para o pai.
 4. O pai olha para o tamanho que ele quer ter e
    como ele deve ser alinhado,
    e define a posição do widget de acordo.
    O alinhamento pode ser definido explicitamente,
    usando uma variedade de widgets como `Center`,
    e as propriedades de alinhamento em `Row` e `Column`.

No Flutter, essa conversa de layout é frequentemente
expressa com a frase simplificada:
"As restrições descem. Os tamanhos sobem.
O pai define a posição."

### Tipos de box

No Flutter, os widgets são renderizados por seus
objetos [`RenderBox`][] subjacentes.
Esses objetos determinam como lidar com as
restrições que lhes são passadas.

Geralmente, existem três tipos de boxes:
* Aquelas que tentam ser o maior possível.
Por exemplo, os boxes usados por
[`Center`][] e [`ListView`][].
* Aquelas que tentam ter o mesmo tamanho de seus
filhos. Por exemplo, os boxes usados por
[`Transform`][] e [`Opacity`][]
* Aquelas que tentam ter um tamanho específico.
Por exemplo, os boxes usados por
[`Image`][] e [`Text`][].

Alguns widgets, por exemplo [`Container`][],
variam de tipo para tipo com base em seus
argumentos do construtor.
O construtor `Container` tenta ser o maior possível por padrão,
mas se você der uma largura,
por exemplo, ele tenta honrar isso e
ter esse tamanho específico.

Outros, por exemplo, [`Row`][] e [`Column`][] (flex boxes)
variam com base nas restrições que recebem.
Leia mais sobre flex boxes e restrições no
[artigo sobre como entender as restrições][].

## Organizar um único widget

Para organizar um único widget no Flutter,
envolva um widget visível,
como `Text` ou `Image` com um widget que
pode alterar sua posição em uma tela,
como um widget `Center`.

:::note Note
Os exemplos na página usam um widget chamado
`BorderedImage`. Este é um widget personalizado,
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

<img src='/assets/images/docs/fwe/layout/center.png' alt="Uma captura de tela de um widget centralizado e uma captura de tela de um widget que não foi centralizado.">

Todos os widgets de layout têm um dos seguintes:
* Uma propriedade `child` se eles recebem um único
filho — por exemplo, `Center`, `Container` ou
`Padding`.
* Uma propriedade `children` se eles recebem uma lista
de widgets — por exemplo,
`Row`, `Column`, `ListView` ou `Stack`.

### Container

`Container` é um widget de conveniência que é
composto por vários widgets responsáveis pelo layout,
pintura, posicionamento e dimensionamento.
Em relação ao layout,
ele pode ser usado para adicionar padding e
margins a um widget.
Há também um widget `Padding`
que pode ser usado aqui com o mesmo efeito.
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

<img src='/assets/images/docs/fwe/layout/padding.png' alt="Uma captura de tela de um widget com padding e uma captura de tela de um widget sem padding.">

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

## Organizar vários widgets verticalmente ou horizontalmente

Um dos padrões de layout mais comuns é
organizar widgets verticalmente ou horizontalmente.
Você pode usar um widget `Row` para organizar widgets
horizontalmente,
e um widget `Column` para organizar widgets verticalmente.
A primeira figura desta página usou ambos.

Este é o exemplo mais básico de uso de um widget `Row`.

{% render docs/code-and-image.md,
image:"fwe/layout/row.png",
caption: "Esta figura mostra um widget de linha com três filhos.",
alt: "Uma captura de tela de um widget de linha com três filhos"
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
linhas e colunas em si,
combinando para formar um layout complexo.
Por exemplo, você pode adicionar rótulos a cada
uma das imagens no exemplo acima usando colunas.


{% render docs/code-and-image.md,
image:"fwe/layout/nested_row_column.png",
caption: "Esta figura mostra um widget de linha com três filhos, cada um dos quais é uma coluna.",
alt: "Uma captura de tela de uma linha de três widgets, cada um dos quais tem um rótulo embaixo."
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


### Alinhar widgets dentro de linhas e colunas

No exemplo a seguir,
os widgets têm cada um 200 pixels de largura,
e a viewport tem 700 pixels de largura.
Os widgets são consequentemente alinhados à esquerda,
um após o outro,
com todo o espaço extra à direita.

<img src='/assets/images/docs/fwe/layout/left_alignment.png' alt="Um diagrama que mostra três widgets dispostos em uma linha. Cada widget filho é rotulado como 200px de largura, e o espaço em branco à direita é rotulado como 100px de largura.">

Você controla como uma linha ou coluna alinha seus
filhos usando as propriedades `mainAxisAlignment` e
`crossAxisAlignment`.
Para uma linha, o eixo principal corre horizontalmente e
o eixo cruzado corre verticalmente. Para uma coluna,
o eixo principal corre
verticalmente e o eixo cruzado corre horizontalmente.

<img src='/assets/images/docs/fwe/layout/axes_diagram.png' alt="Um diagrama que mostra a direção do eixo principal e do eixo cruzado em linhas e colunas">

Definir o alinhamento do eixo principal para `spaceEvenly`
divide o espaço horizontal livre uniformemente entre,
antes e depois de cada imagem.

{% render docs/code-and-image.md,
image:"fwe/layout/space_evenly.png",
caption: "Esta figura mostra um widget de linha com três filhos, que são alinhados com a constante MainAxisAlignment.spaceEvenly.",
alt: "Uma captura de tela de três widgets, espaçados uniformemente uns dos outros."
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

Colunas funcionam da mesma forma que as linhas.
O exemplo a seguir mostra uma coluna de 3 imagens,
cada uma com 100 pixels de altura. A altura da
render box (neste caso, a tela inteira)
é mais do que 300 pixels,
então definir o alinhamento do eixo principal para `spaceEvenly`
divide o espaço vertical livre uniformemente entre,
acima e abaixo de cada imagem.

<img src='/assets/images/docs/fwe/layout/col_space_evenly.png' alt="Uma captura de tela de três widgets dispostos verticalmente, usando um widget de coluna.">

Os enums [`MainAxisAlignment`][] e [`CrossAxisAlignment`][]
oferecem uma variedade de constantes para
controlar o alinhamento.

O Flutter inclui outros widgets que podem ser usados
para alinhamento, notavelmente o widget `Align`.

### Dimensionar widgets dentro de linhas e colunas

Quando um layout é muito grande para caber em um dispositivo,
um padrão listrado amarelo e preto aparece
ao longo da borda afetada.
Neste exemplo, a viewport tem 400 pixels de largura,
e cada filho tem 150 pixels de largura.

<img src='/assets/images/docs/fwe/layout/overflowing_row.png' alt="Uma captura de tela de uma linha de widgets que são mais largos do que sua viewport.">

Os widgets podem ser dimensionados para caber em uma
linha ou coluna usando o widget `Expanded`.
Para corrigir o exemplo anterior onde a linha de
imagens é muito larga para sua render box,
envolva cada imagem com um widget [`Expanded`][].

{% render docs/code-and-image.md,
image:"fwe/layout/expanded_row.png",
caption: "Esta figura mostra um widget de linha com três filhos que são envolvidos com widgets `Expanded`.",
alt: "Uma captura de tela de três widgets, que ocupam exatamente a quantidade de espaço disponível no eixo principal. Todos os três widgets têm a mesma largura."
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
a seus irmãos. Por exemplo,
talvez você queira que um widget ocupe o dobro
do espaço de seus irmãos.
Para isso, use a propriedade `flex` dos widgets `Expanded`,
um número inteiro que determina o fator de flexibilidade
para um widget. O fator de flexibilidade padrão é 1.
O código a seguir define o fator de flexibilidade da
imagem do meio para 2:

{% render docs/code-and-image.md,
image:"fwe/layout/flex_2_row.png",
caption: "Esta figura mostra um widget de linha com três filhos que são envolvidos com widgets `Expanded`. O filho central tem sua propriedade `flex` definida como 2.",
alt: "Uma captura de tela de três widgets, que ocupam exatamente a quantidade de espaço disponível no eixo principal. O widget no centro tem o dobro da largura dos widgets à esquerda e à direita."
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
a restrição de uma box é ilimitada ou infinita.
Isso significa que a largura máxima ou a
altura máxima está definida como [`double.infinity`][].
Uma box que tenta ser o maior possível não
funcionará de forma útil quando receber uma
restrição ilimitada e, no modo de depuração,
lança uma exceção.

O caso mais comum em que uma render box acaba
com uma restrição ilimitada é dentro de uma
flex box ([`Row`][] ou [`Column`][]),
e dentro de uma região rolável
(como [`ListView`][] e outras subclasses de [`ScrollView`][]).
`ListView`, por exemplo, tenta se expandir para
caber no espaço disponível em sua direção cruzada
(talvez seja um bloco de rolagem vertical
e tente ser o mais largo possível que seu pai).
Se você aninhar uma `ListView` de rolagem vertical
dentro de uma `ListView` de rolagem horizontal,
a lista interna tenta ser o mais larga possível,
que é infinitamente larga, já que a externa é
rolável nessa direção.

Talvez o erro mais comum que você encontrará
ao construir um aplicativo Flutter seja devido ao
uso incorreto de widgets de layout,
e é referido como o erro de
"restrições ilimitadas".

Se houvesse apenas um tipo de erro que você deveria estar
preparado para enfrentar quando você começar a construir
aplicativos Flutter pela primeira vez, seria esse.

{% ytEmbed 'jckqXR5CrPI', 'Decodificando Flutter: Altura e largura ilimitadas' %}

:::note O inspetor de widgets
O Flutter tem um conjunto robusto de DevTools que
ajudam você a trabalhar com vários aspectos de
desenvolvimento Flutter.
A ferramenta "Inspetor de widgets" é particularmente
útil ao construir e depurar layouts (e trabalhar com widgets em geral).

[Saiba mais sobre o inspetor Flutter][].
:::

##  Widgets de rolagem {:#scrolling-widgets}

O Flutter tem muitos widgets integrados que
rolam automaticamente e também oferece uma variedade de
widgets que você pode personalizar para
criar um comportamento de rolagem específico.
Nesta página, você verá como usar o widget mais comum para
tornar qualquer página rolável,
assim como um widget para criar listas roláveis.

### ListView

`ListView` é um widget semelhante a uma coluna que
fornece automaticamente a rolagem quando seu
conteúdo é mais longo do que sua render box.
A maneira mais básica de usar uma `ListView` é
muito semelhante ao uso de uma `Column` ou `Row`.
Ao contrário de uma coluna ou linha,
uma `ListView` exige que seus filhos ocupem
todo o espaço disponível no eixo cruzado,
como mostrado no exemplo abaixo.

{% render docs/code-and-image.md,
image:"fwe/layout/basic_listview.png",
caption: "Esta figura mostra um widget ListView com três filhos.",
alt: "Uma captura de tela de três widgets dispostos verticalmente. Eles se expandiram para ocupar todo o espaço disponível no eixo cruzado."
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

As `ListView`s são comumente usadas quando você tem um
número desconhecido ou muito grande (ou infinito) de itens de lista.
Quando este for o caso,
é melhor usar o construtor `ListView.builder`.
O construtor builder constrói apenas os
filhos que estão atualmente visíveis na tela.

No exemplo a seguir,
a `ListView` está exibindo uma lista de itens de tarefas pendentes.
Os itens de tarefas pendentes estão sendo buscados de um repositório,
e, portanto, o número de tarefas pendentes é desconhecido.


{% render docs/code-and-image.md,
image:"fwe/layout/listview_builder.png",
caption: "Esta figura mostra o construtor ListView.builder para exibir um número desconhecido de filhos.",
alt: "Uma captura de tela de vários widgets dispostos verticalmente. Eles se expandiram para ocupar todo o espaço disponível no eixo cruzado."
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

Como o Flutter é usado para criar aplicativos para celular,
tablet, desktop, _e_ web,
é provável que você precise ajustar seu
aplicativo para se comportar de forma diferente, dependendo de
coisas como tamanho da tela ou dispositivo de entrada.
Isso é chamado de tornar um aplicativo
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
diferentes problemas. Por exemplo,
o construtor `ListView.builder` é usado principalmente
para renderizar preguiçosamente os itens em uma lista,
enquanto o widget `Builder` é útil para obter
acesso ao `BuildContext` em código de widget profundo.

Apesar de seus diferentes casos de uso,
esses builders são unificados por como eles funcionam.
Widgets builder e construtores builder têm todos
argumentos chamados 'builder'
(ou algo semelhante,
como `itemBuilder` no caso de `ListView.builder`),
e o argumento builder sempre aceita um
callback.
Este callback é uma __função builder__.
Funções builder são callbacks que passam dados para
o widget pai,
e o widget pai usa esses argumentos para
construir e retornar o widget filho.
Funções builder sempre passam pelo menos
um argumento — o contexto de construção —
e geralmente pelo menos um outro argumento.

Por exemplo, o widget `LayoutBuilder` é usado
para criar layouts responsivos com base
no tamanho da viewport. O corpo do callback builder
recebe o [`BoxConstraints`][] que recebe
de seu pai, junto com o 'BuildContext' dos widgets.
Com essas restrições, você pode retornar um widget diferente
com base no espaço disponível.

{% ytEmbed 'IYDVcriKjsw', 'LayoutBuilder (Widget da Semana do Flutter)' %}

No exemplo a seguir,
o widget retornado pelo `LayoutBuilder`
muda com base em se a viewport é
menor ou igual a 600 pixels,
ou maior que 600 pixels.


{% render docs/code-and-image.md,
image:"fwe/layout/layout_builder.png",
caption: "Esta figura mostra um layout estreito, que organiza seus filhos verticalmente, e um layout mais amplo, que organiza seus filhos em uma grid.",
alt: "Duas capturas de tela, nas quais uma mostra um layout estreito e a outra mostra um layout amplo."
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
contexto de construção e um `int`.
Este callback é chamado uma vez para cada item
na lista,
e o argumento int representa o índice do item da lista.
A primeira vez que o callback itemBuilder é chamado
quando o Flutter está construindo a UI,
o int passado para a função é 0,
a segunda vez é 1, e assim por diante.

Isso permite que você forneça configurações específicas
com base no índice. Lembre-se do exemplo acima usando
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
passado para o builder para obter a tarefa pendente correta
da lista de itens,
e então exibe os dados dessa tarefa pendente no
widget que é retornado do builder.

Para exemplificar isso,
o exemplo a seguir altera a
cor de fundo de todos os outros itens da lista.

{% render docs/code-and-image.md,
image:"fwe/layout/alternating_list_items.png"
caption:"Esta figura mostra um `ListView`, na qual seus filhos têm cores de fundo alternadas. As cores de fundo foram determinadas programaticamente com base no índice do filho dentro do `ListView`."
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

* Widgets e conceitos de layout comuns
  * Vídeo: [OverlayPortal — Widget da Semana do Flutter][]
  * Vídeo: [Stack — Widget da Semana do Flutter][]
  * Tutorial: [Layouts no Flutter][]
  * Documentação: [Documentação do Stack][]
* Dimensionamento e posicionamento de widgets
  * Vídeo: [Expanded — Widget da Semana do Flutter][]
  * Vídeo: [Flexible — Widget da Semana do Flutter][]
  * Vídeo: [Widgets Intrinsic — Decodificando o Flutter][]
* Widgets roláveis
  * Código de exemplo: [Trabalhar com listas longas][]
  * Código de exemplo: [Criar uma lista horizontal][]
  * Código de exemplo: [Criar uma lista em grid][]
  * Vídeo: [ListView — Widget da Semana do Flutter][]
* Aplicativos Adaptativos
  * Tutorial: [Codelab de Aplicativos Adaptativos][]
  * Vídeo: [MediaQuery — Widget da Semana do Flutter][]
  * Vídeo: [Construindo aplicativos adaptativos de plataforma][]
  * Vídeo: [Builder — Widget da Semana do Flutter][]

### Referência da API

Os recursos a seguir explicam APIs individuais.

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

[Layouts no Flutter]: /ui/layout
[artigo sobre como entender as restrições]: /ui/layout/constraints
[`RenderBox`]: {{site.api}}/flutter/rendering/RenderBox-class.html
[Expanded — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=_rnZaagadyo
[Flexible — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=CI7x0mAZiY0
[Widgets Intrinsic — Decodificando o Flutter]: {{site.youtube-site}}/watch?v=Si5XJ_IocEs
[Construir um Layout do Flutter]: /ui/layout/tutorial
[Rolagem básica]: /ui/layout/scrolling#basic-scrolling
[Builder — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=xXNOkIuSYuA
[ListView — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=KJpkjHGiI5A
[Trabalhar com listas longas]: /cookbook/lists/long-lists
[Criar uma lista horizontal]: /cookbook/lists/horizontal-list
[Criar uma lista em grid]: /cookbook/lists/grid-lists
[PageView — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=J1gE9xvph-A
[Stack — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=liEGSeD3Zt8
[Documentação do Stack]: /ui/layout#stack
[OverlayPortal — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=S0Ylpa44OAQ
[LayoutBuilder — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=IYDVcriKjsw
[MediaQuery — Widget da Semana do Flutter]: {{site.youtube-site}}/watch?v=A3WrA4zAaPw
[Codelab de aplicativos adaptativos]: {{site.codelabs}}/codelabs/flutter-adaptive-app
[Construindo aplicativos adaptativos de plataforma]: {{site.youtube-site}}/watch?v=RCdeSKVt7LI
[Saiba mais sobre o inspetor Flutter]: /tools/devtools/inspector
[Altura e largura ilimitadas — Decodificando o Flutter]: {{site.youtube-site}}/watch?v=jckqXR5CrPI
[Rolagem 2D]: {{site.youtube-site}}/watch?v=ppEdTo-VGcg
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

Como esta seção do site está evoluindo,
[agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="layout"
