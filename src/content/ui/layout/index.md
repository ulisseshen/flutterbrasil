---
ia-translate: true
title: Layouts no Flutter
shortTitle: Layout
description: >-
  Aprenda como o mecanismo de layout do Flutter funciona e como construir o layout do seu app.
---

## Visão geral

:::secondary Qual é a ideia?
* Layouts no Flutter são construídos com widgets.
* Widgets são classes usadas para construir UIs.
* Widgets também são usados para construir elementos de UI.
* Componha widgets simples para construir widgets complexos.
:::

O núcleo do mecanismo de layout do Flutter são os widgets.
No Flutter, quase tudo é um widget&mdash;até
mesmo os modelos de layout são widgets. As imagens, ícones
e texto que você vê em um app Flutter são todos widgets.
Mas coisas que você não vê também são widgets,
como as rows, columns e grids que organizam,
restringem e alinham os widgets visíveis.
Você cria um layout compondo widgets para construir
widgets mais complexos.

## Exemplo conceitual

No exemplo a seguir, a primeira captura de tela exibe
três ícones com rótulos e a segunda captura de tela inclui
o layout visual para rows e columns. Na segunda
captura de tela, `debugPaintSizeEnabled` está definido como `true` para que você
possa ver o layout visual.

<div class="side-by-side">
  <div class="centered-rows">
    <img src='/assets/images/docs/ui/layout/lakes-icons.png' alt="Sample layout">
  </div>
  <div class="centered-rows">
    <img src='/assets/images/docs/ui/layout/lakes-icons-visual.png' alt="Sample layout with visual debugging">
  </div>
</div>

Aqui está um diagrama da árvore de widgets para o
exemplo anterior:

<img src='/assets/images/docs/ui/layout/sample-flutter-layout.png' class="text-center diagram-wrap" alt="Node tree">

A maior parte disso deve parecer como você esperaria, mas você pode estar se perguntando
sobre os containers (mostrados em rosa). [`Container`][`Container`] é uma classe de widget
que permite customizar seu widget filho. Use um `Container` quando
você quiser adicionar padding, margens, bordas ou cor de fundo,
para citar algumas de suas capacidades.

Cada widget [`Text`][`Text`] é colocado em um `Container`
para adicionar margens. Toda a [`Row`][`Row`] também é colocada em um
`Container` para adicionar padding ao redor da row.

O resto da UI é controlado por propriedades.
Defina a cor de um [`Icon`][`Icon`] usando sua propriedade `color`.
Use a propriedade `Text.style` para definir a fonte, sua cor, peso, e assim por diante.
Columns e rows têm propriedades que permitem especificar como seus
filhos são alinhados vertical ou horizontalmente, e quanto espaço
os filhos devem ocupar.

:::note
A maioria das capturas de tela neste tutorial são exibidas com
`debugPaintSizeEnabled` definido como `true` para que você possa ver o
layout visual. Para mais informações, veja
[Depurando problemas de layout visualmente][Debugging layout issues visually].
:::

[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[Debugging layout issues visually]: /tools/devtools/inspector#debugging-layout-issues-visually
[`Icon`]: {{site.api}}/flutter/material/Icons-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html

## Organizar um widget em layout

Como você organiza um único widget em layout no Flutter? Esta seção
mostra como criar e exibir um widget simples.
Ela também mostra o código completo para um app Hello World simples.

No Flutter, são necessários apenas alguns passos para colocar texto, um ícone
ou uma imagem na tela.

### 1. Selecione um widget de layout

Escolha entre uma variedade de [widgets de layout][layout widgets] com base
em como você quer alinhar ou restringir um widget visível,
já que essas características são tipicamente passadas para o
widget contido.

Por exemplo, você poderia usar o
widget de layout [`Center`][`Center`] para centralizar um widget visível
horizontal e verticalmente:

```dart
Center(
  // Content to be centered here.
)
```

[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[layout widgets]: /ui/widgets/layout

### 2. Crie um widget visível

Escolha um [widget visível][visible widget] para seu app conter
elementos visíveis, como [text][text], [images][images], ou
[icons][icons].

Por exemplo, você poderia usar o widget [`Text`][`Text`] para exibir
algum texto:

```dart
Text('Hello World')
```

[icons]: {{site.api}}/flutter/material/Icons-class.html
[images]: {{site.api}}/flutter/widgets/Image-class.html
[text]: {{site.api}}/flutter/widgets/Text-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[visible widget]: /ui/widgets

### 3. Adicione o widget visível ao widget de layout

<?code-excerpt path-base="layout/base"?>

Todos os widgets de layout têm um dos seguintes:

* Uma propriedade `child` se eles recebem um único filho&mdash;por exemplo,
  `Center` ou `Container`
* Uma propriedade `children` se eles recebem uma lista de widgets&mdash;por exemplo,
  `Row`, `Column`, `ListView`, ou `Stack`.

Adicione o widget `Text` ao widget `Center`:

<?code-excerpt "lib/main.dart (centered-text)" replace="/body: //g"?>
```dart
const Center(
  child: Text('Hello World'),
),
```

### 4. Adicione o widget de layout à página

Um app Flutter é em si um widget, e a maioria dos widgets tem um método [`build()`][`build()`].
Instanciar e retornar um widget no método `build()` do app
exibe o widget.

<a id="non-material-apps" aria-hidden="true"></a>
<a id="material-apps" aria-hidden="true"></a>
<a id="cupertino-apps" aria-hidden="true"></a>

<Tabs key="app-type-tabs" wrapped="true">

<Tab name="Standard apps">

Para um app geral, você pode adicionar o widget `Container` ao
método `build()` do app:

<?code-excerpt path-base="layout/non_material"?>
<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: const Center(
        child: Text(
          'Hello World',
          textDirection: TextDirection.ltr,
          style: TextStyle(fontSize: 32, color: Colors.black87),
        ),
      ),
    );
  }
}
```

Por padrão, um app geral não inclui um `AppBar`,
título ou cor de fundo. Se você quiser esses recursos em um
app geral, você tem que construí-los você mesmo. Este app
muda a cor de fundo para branco e o texto para
cinza escuro para imitar um app Material.

</Tab>

<Tab name="Material apps">

Para um app `Material`, você pode usar um widget [`Scaffold`][`Scaffold`];
ele fornece um banner padrão, cor de fundo
e tem API para adicionar drawers, snack bars e bottom sheets.
Então você pode adicionar o widget `Center` diretamente à propriedade `body`
para a página inicial.

<?code-excerpt path-base="layout/base"?>
<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String appTitle = 'Flutter layout demo';
    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(title: const Text(appTitle)),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

:::note
A [biblioteca Material][Material library] implementa widgets que seguem os princípios de [Material
Design][Material Design]. Ao projetar sua UI, você pode usar exclusivamente
widgets da [biblioteca de widgets padrão][widgets library], ou você pode usar
widgets da biblioteca Material. Você pode misturar widgets de ambas
as bibliotecas, você pode customizar widgets existentes,
ou você pode construir seu próprio conjunto de widgets customizados.
:::

</Tab>

<Tab name="Cupertino apps">

Para criar um app `Cupertino`,
use os widgets `CupertinoApp` e [`CupertinoPageScaffold`][`CupertinoPageScaffold`].

Diferente de `Material`, ele não fornece um banner padrão ou cor de fundo.
Você precisa definir isso você mesmo.

* Para definir cores padrão, passe um [`CupertinoThemeData`][`CupertinoThemeData`]
  configurado para a propriedade `theme` do seu app.
* Para adicionar uma barra de navegação estilo iOS ao topo do seu app, adicione um
  widget [`CupertinoNavigationBar`][`CupertinoNavigationBar`] à propriedade `navigationBar`
  do seu scaffold.
  Você pode usar as cores que [`CupertinoColors`][`CupertinoColors`] fornece para
  configurar seus widgets para combinar com o design iOS.

* Para organizar o corpo do seu app em layout, defina a propriedade `child` do seu scaffold
  com o widget desejado como seu valor, como `Center` ou `Column`.

Para saber quais outros componentes de UI você pode adicionar, confira a
[biblioteca Cupertino][Cupertino library].

<?code-excerpt "lib/cupertino.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Flutter layout demo',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemGrey,
          middle: Text('Flutter layout demo'),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [Text('Hello World')],
          ),
        ),
      ),
    );
  }
}
```

:::note
A [biblioteca Cupertino][Cupertino library] implementa widgets que seguem
as [Diretrizes de Interface Humana da Apple para iOS][Apple's Human Interface Guidelines for iOS].
Ao projetar sua UI, você pode usar
widgets da [biblioteca de widgets padrão][widgets library] ou da biblioteca Cupertino.
Você pode misturar widgets de ambas as bibliotecas, você pode customizar widgets existentes,
ou você pode construir seu próprio conjunto de widgets customizados.
:::

</Tab>

</Tabs>

[`CupertinoColors`]: {{site.api}}/flutter/cupertino/CupertinoColors-class.html
[`CupertinoPageScaffold`]: {{site.api}}/flutter/cupertino/CupertinoPageScaffold-class.html
[`CupertinoThemeData`]: {{site.api}}/flutter/cupertino/CupertinoThemeData-class.html
[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[Cupertino library]: {{site.api}}/flutter/cupertino/cupertino-library.html
[Apple's Human Interface Guidelines for iOS]: {{site.apple-dev}}/design/human-interface-guidelines/designing-for-ios
[`build()`]: {{site.api}}/flutter/widgets/StatelessWidget/build.html
[Material library]: {{site.api}}/flutter/material/material-library.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[widgets library]: {{site.api}}/flutter/widgets/widgets-library.html
[Material Design]: https://m3.material.io

### 5. Execute seu app

<div class="side-by-side">
<div>

Depois de ter adicionado seus widgets, execute seu app. Quando você executar
o app, você deve ver _Hello World_.

Código fonte do app:

* [App Material]({{site.repo.this}}/tree/main/examples/layout/base)
* [App não-Material]({{site.repo.this}}/tree/main/examples/layout/non_material)

</div>
<DashImage figure image="ui/layout/hello-world.png" alt="Screenshot of app displaying Hello World" img-style="max-height: 400px;"  />
</div>
<hr>

## Organizar múltiplos widgets vertical e horizontalmente

<?code-excerpt path-base=""?>

Um dos padrões de layout mais comuns é organizar
widgets vertical ou horizontalmente. Você pode usar um
widget `Row` para organizar widgets horizontalmente,
e um widget `Column` para organizar widgets verticalmente.

:::secondary Qual é a ideia?
* `Row` e `Column` são dois dos padrões de layout mais comumente usados.
* `Row` e `Column` cada um recebe uma lista de widgets filhos.
* Um widget filho pode ser em si uma `Row`, `Column`,
    ou outro widget complexo.
* Você pode especificar como uma `Row` ou `Column` alinha seus filhos,
    tanto vertical quanto horizontalmente.
* Você pode esticar ou restringir widgets filhos específicos.
* Você pode especificar como widgets filhos usam o espaço
    disponível da `Row` ou `Column`.
:::

Para criar uma row ou column no Flutter, você adiciona uma lista de widgets filhos
a um widget [`Row`][`Row`] ou [`Column`][`Column`]. Por sua vez,
cada filho pode ser em si uma row ou column, e assim por diante.
O exemplo a seguir mostra como é possível aninhar rows ou
columns dentro de rows ou columns.

Este layout é organizado como uma `Row`. A row contém dois filhos:
uma column à esquerda e uma imagem à direita:

<img src='/assets/images/docs/ui/layout/pavlova-diagram.png' class="diagram-wrap" alt="Screenshot with callouts showing the row containing two children">

A árvore de widgets da column à esquerda aninha rows e columns.

<img src='/assets/images/docs/ui/layout/pavlova-left-column-diagram.png' class="diagram-wrap" alt="Diagram showing a left column broken down to its sub-rows and sub-columns">

Você implementará parte do código de layout da Pavlova em
[Aninhando rows e columns](#nesting-rows-and-columns).

:::note
`Row` e `Column` são widgets primitivos básicos para layouts horizontais
e verticais&mdash;esses widgets de baixo nível permitem o máximo de
customização. Flutter também oferece widgets especializados de nível mais alto
que podem ser suficientes para suas necessidades. Por exemplo,
em vez de `Row` você pode preferir [`ListTile`][`ListTile`],
um widget fácil de usar com propriedades para ícones leading e trailing,
e até 3 linhas de texto. Em vez de Column, você pode preferir
[`ListView`][`ListView`], um layout tipo column que automaticamente rola
se seu conteúdo for muito longo para caber no espaço disponível.
Para mais informações, veja [Widgets de layout comuns][Common layout widgets].
:::

[Common layout widgets]: #common-layout-widgets
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html

### Alinhando widgets

Você controla como uma row ou column alinha seus filhos usando as
propriedades `mainAxisAlignment` e `crossAxisAlignment`.
Para uma row, o eixo principal corre horizontalmente e o eixo cruzado corre
verticalmente. Para uma column, o eixo principal corre verticalmente e o eixo cruzado
corre horizontalmente.

<div class="side-by-side">
  <div class="centered-rows">
    <img src='/assets/images/docs/ui/layout/row-diagram.png' class="diagram-wrap" alt="Diagram showing the main axis and cross axis for a row">
  </div>
  <div class="centered-rows">
    <img src='/assets/images/docs/ui/layout/column-diagram.png' class="diagram-wrap" alt="Diagram showing the main axis and cross axis for a column">
  </div>
</div>

Os enums [`MainAxisAlignment`][`MainAxisAlignment`] e [`CrossAxisAlignment`][`CrossAxisAlignment`]
oferecem uma variedade de constantes para controlar o alinhamento.

:::note
Quando você adiciona imagens ao seu projeto,
você precisa atualizar o arquivo `pubspec.yaml` para acessá-las&mdash;este exemplo usa `Image.asset` para exibir
as imagens. Para mais informações, veja o
[arquivo `pubspec.yaml`][`pubspec.yaml` file] deste exemplo ou [Adicionando assets e imagens][Adding assets and images].
Você não precisa fazer isso se estiver referenciando imagens online
usando `Image.network`.
:::

No exemplo a seguir, cada uma das 3 imagens tem 100 pixels de largura.
A render box (neste caso, a tela inteira)
tem mais de 300 pixels de largura, então definir o alinhamento do eixo principal
para `spaceEvenly` divide o espaço horizontal livre
uniformemente entre, antes e depois de cada imagem.

<div class="code-and-content">
<div>

<?code-excerpt "layout/row_column/lib/main.dart (row)" replace="/Row/[!$&!]/g"?>
```dart
[!Row!](
  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  children: [
    Image.asset('images/pic1.jpg'),
    Image.asset('images/pic2.jpg'),
    Image.asset('images/pic3.jpg'),
  ],
);
```

</div>
<div>
  <img src='/assets/images/docs/ui/layout/row-spaceevenly-visual.png' class="small-diagram-wrap" alt="Row with 3 evenly spaced images">

  **Código fonte do app:** [row_column]({{site.repo.this}}/tree/main/examples/layout/row_column)
</div>
</div>

Columns funcionam da mesma forma que rows. O exemplo a seguir mostra uma column
de 3 imagens, cada uma com 100 pixels de altura. A altura da render box
(neste caso, a tela inteira) tem mais de 300 pixels, então
definir o alinhamento do eixo principal para `spaceEvenly` divide o espaço vertical livre
uniformemente entre, acima e abaixo de cada imagem.

<div class="code-and-content">
<div>

  <?code-excerpt "layout/row_column/lib/main.dart (column)" replace="/Column/[!$&!]/g"?>
  ```dart
  [!Column!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  ```

</div>
<div class="text-center">
  <img src='/assets/images/docs/ui/layout/column-visual.png' height="250px" class="small-diagram-wrap" alt="Column showing 3 images spaced evenly">

  **Código fonte do app:** [row_column]({{site.repo.this}}/tree/main/examples/layout/row_column)
</div>
</div>

[`CrossAxisAlignment`]: {{site.api}}/flutter/rendering/CrossAxisAlignment.html
[`MainAxisAlignment`]: {{site.api}}/flutter/rendering/MainAxisAlignment.html
[`pubspec.yaml` file]: {{site.repo.this}}/tree/main/examples/layout/row_column/pubspec.yaml
[Adding assets and images]: /ui/assets/assets-and-images

### Dimensionando widgets

Quando um layout é muito grande para caber em um dispositivo, um
padrão listrado amarelo e preto aparece ao longo da borda afetada.
Aqui está um [exemplo][sizing] de uma row que é muito larga:

<img src='/assets/images/docs/ui/layout/layout-too-large.png' class="text-center" style="max-height: 15rem;" alt="Overly-wide row">

Widgets podem ser dimensionados para caber dentro de uma row ou column usando o
widget [`Expanded`][`Expanded`]. Para corrigir o exemplo anterior onde a
row de imagens é muito larga para sua render box,
envolva cada imagem com um widget `Expanded`.

<div class="code-and-content">
<div>

  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images)" replace="/Expanded/[!$&!]/g"?>
  ```dart
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      [!Expanded!](child: Image.asset('images/pic1.jpg')),
      [!Expanded!](child: Image.asset('images/pic2.jpg')),
      [!Expanded!](child: Image.asset('images/pic3.jpg')),
    ],
  );
  ```

</div>
<div>
  <img src='/assets/images/docs/ui/layout/row-expanded-2-visual.png' class="small-diagram-wrap" alt="Row of 3 images that are too wide, but each is constrained to take only 1/3 of the space">

  **Código fonte do app:** [sizing]({{site.repo.this}}/tree/main/examples/layout/sizing)
</div>
</div>

Talvez você queira que um widget ocupe duas vezes mais espaço do que seus
irmãos. Para isso, use a propriedade `flex` do widget `Expanded`,
um inteiro que determina o fator flex para um widget.
O fator flex padrão é 1. O código a seguir define
o fator flex da imagem do meio como 2:

<div class="code-and-content">
<div>

  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images-with-flex)" replace="/flex.*/[!$&!]/g"?>
  ```dart
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(child: Image.asset('images/pic1.jpg')),
      Expanded([!flex: 2, child: Image.asset('images/pic2.jpg')),!]
      Expanded(child: Image.asset('images/pic3.jpg')),
    ],
  );
  ```

</div>
<div>
  <img src='/assets/images/docs/ui/layout/row-expanded-visual.png' class="small-diagram-wrap" alt="Row of 3 images with the middle image twice as wide as the others">

  **Código fonte do app:** [sizing]({{site.repo.this}}/tree/main/examples/layout/sizing)
</div>
</div>

[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[sizing]: {{site.repo.this}}/tree/main/examples/layout/sizing

### Empacotando widgets

Por padrão, uma row ou column ocupa o máximo de espaço possível ao longo de seu eixo principal
mas se você quiser empacotar os filhos juntos,
defina seu `mainAxisSize` como `MainAxisSize.min`. O exemplo a seguir
usa essa propriedade para empacotar os ícones de estrela juntos.

<div class="code-and-content">
<div>

  <?code-excerpt "layout/pavlova/lib/main.dart (stars)" replace="/mainAxisSize.*/[!$&!]/g; /\w+ \w+ = //g; /;//g"?>
  ```dart
  Row(
    [!mainAxisSize: MainAxisSize.min,!]
    children: [
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.green[500]),
      Icon(Icons.star, color: Colors.green[500]),
      const Icon(Icons.star, color: Colors.black),
      const Icon(Icons.star, color: Colors.black),
    ],
  )
  ```

</div>
<div>
  <img src='/assets/images/docs/ui/layout/packed.png' class="small-diagram-wrap" alt="Row of 5 stars, packed together in the middle of the row">

  **Código fonte do app:** [pavlova]({{site.repo.this}}/tree/main/examples/layout/pavlova)
</div>
</div>

### Aninhando rows e columns

O framework de layout permite aninhar rows e columns
dentro de rows e columns tão profundamente quanto você precisar.
Vamos ver o código para a seção destacada
do seguinte layout:

<img src='/assets/images/docs/ui/layout/pavlova-large-annotated.png' class="border text-center" alt="Screenshot of the pavlova app, with the ratings and icon rows outlined in red">

A seção destacada é implementada como duas rows. A row de avaliações contém
cinco estrelas e o número de avaliações. A row de ícones contém três
columns de ícones e texto.

A árvore de widgets para a row de avaliações:

<img src='/assets/images/docs/ui/layout/widget-tree-pavlova-rating-row.png' class="text-center diagram-wrap" alt="Ratings row widget tree">

A variável `ratings` cria uma row contendo uma row menor
de ícones de 5 estrelas, e texto:

<?code-excerpt "layout/pavlova/lib/main.dart (ratings)" replace="/ratings/[!$&!]/g"?>
```dart
final stars = Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    Icon(Icons.star, color: Colors.green[500]),
    const Icon(Icons.star, color: Colors.black),
    const Icon(Icons.star, color: Colors.black),
  ],
);

final [!ratings!] = Container(
  padding: const EdgeInsets.all(20),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      stars,
      const Text(
        '170 Reviews',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w800,
          fontFamily: 'Roboto',
          letterSpacing: 0.5,
          fontSize: 20,
        ),
      ),
    ],
  ),
);
```

:::tip
Para minimizar a confusão visual que pode resultar de
código de layout profundamente aninhado, implemente partes da UI
em variáveis e funções.
:::

A row de ícones, abaixo da row de avaliações, contém 3 columns;
cada column contém um ícone e duas linhas de texto,
como você pode ver em sua árvore de widgets:

<img src='/assets/images/docs/ui/layout/widget-tree-pavlova-icon-row.png' class="text-center diagram-wrap" alt="Icon widget tree">

A variável `iconList` define a row de ícones:

<?code-excerpt "layout/pavlova/lib/main.dart (icon-list)" replace="/iconList/[!$&!]/g"?>
```dart
const descTextStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.w800,
  fontFamily: 'Roboto',
  letterSpacing: 0.5,
  fontSize: 18,
  height: 2,
);

// DefaultTextStyle.merge() allows you to create a default text
// style that is inherited by its child and all subsequent children.
final [!iconList!] = DefaultTextStyle.merge(
  style: descTextStyle,
  child: Container(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Icon(Icons.kitchen, color: Colors.green[500]),
            const Text('PREP:'),
            const Text('25 min'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.timer, color: Colors.green[500]),
            const Text('COOK:'),
            const Text('1 hr'),
          ],
        ),
        Column(
          children: [
            Icon(Icons.restaurant, color: Colors.green[500]),
            const Text('FEEDS:'),
            const Text('4-6'),
          ],
        ),
      ],
    ),
  ),
);
```

A variável `leftColumn` contém as rows de avaliações e ícones,
assim como o título e o texto que descrevem a Pavlova:

<?code-excerpt "layout/pavlova/lib/main.dart (left-column)" replace="/leftColumn/[!$&!]/g"?>
```dart
final [!leftColumn!] = Container(
  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
  child: Column(children: [titleText, subTitle, ratings, iconList]),
);
```

A column à esquerda é colocada em um `SizedBox` para restringir sua largura.
Finalmente, a UI é construída com toda a row (contendo a
column à esquerda e a imagem) dentro de um `Card`.

A [imagem da Pavlova][Pavlova image] é do [Pixabay][Pixabay].
Você pode incorporar uma imagem da rede usando `Image.network()` mas,
para este exemplo, a imagem é salva em um diretório de imagens no projeto,
adicionada ao [arquivo pubspec][pubspec file], e acessada usando `Images.asset()`.
Para mais informações, veja [Adicionando assets e imagens][Adding assets and images].

<?code-excerpt "layout/pavlova/lib/main.dart (body)"?>
```dart
body: Center(
  child: Container(
    margin: const EdgeInsets.fromLTRB(0, 40, 0, 30),
    height: 600,
    child: Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 440, child: leftColumn),
          mainImage,
        ],
      ),
    ),
  ),
),
```

:::tip
O exemplo da Pavlova funciona melhor horizontalmente em um dispositivo largo,
como um tablet. Se você estiver executando este exemplo no simulador iOS,
você pode selecionar um dispositivo diferente usando o menu **Hardware > Device**.
Para este exemplo, recomendamos o iPad Pro.
Você pode mudar sua orientação para modo paisagem usando
**Hardware > Rotate**. Você também pode mudar o tamanho da
janela do simulador (sem mudar o número de pixels lógicos)
usando **Window > Scale**.
:::

**Código fonte do app:** [pavlova]({{site.repo.this}}/tree/main/examples/layout/pavlova)

<hr>

[Pavlova image]: https://pixabay.com/en/photos/pavlova
[Pixabay]: https://pixabay.com/en/photos/pavlova
[pubspec file]: {{site.repo.this}}/tree/main/examples/layout/pavlova/pubspec.yaml

## Widgets de layout comuns

Flutter tem uma rica biblioteca de widgets de layout.
Aqui estão alguns dos mais comumente usados.
A intenção é colocá-lo em funcionamento o mais rápido possível,
ao invés de sobrecarregá-lo com uma lista completa.
Para informações sobre outros widgets disponíveis,
consulte o [Catálogo de widgets][Widget catalog],
ou use a caixa de pesquisa nos [documentos de referência da API][API reference docs].
Além disso, as páginas de widgets nos documentos da API frequentemente fazem sugestões
sobre widgets similares que podem atender melhor às suas necessidades.

Os seguintes widgets se dividem em duas categorias: widgets padrão
da [biblioteca de widgets][widgets library], e widgets especializados da
[biblioteca Material][Material library]. Qualquer app pode usar a biblioteca de widgets mas
apenas apps Material podem usar a biblioteca Material Components.

<a id="standard-widgets" aria-hidden="true"></a>
<a id="materials-widgets" aria-hidden="true"></a>

<Tabs key="widget-types-tabs" wrapped="true">

<Tab name="Standard widgets">

[`Container`](#container)
: Adiciona padding, margens, bordas,
  cor de fundo ou outras decorações a um widget.

[`GridView`](#gridview)
: Organiza widgets em uma grade rolável.

[`ListView`](#listview)
: Organiza widgets em uma lista rolável.

[`Stack`](#stack)
: Sobrepõe um widget em cima de outro.

</Tab>

<Tab name="Material widgets">

[`Scaffold`][`Scaffold`]
: Fornece um framework de layout estruturado
  com slots para elementos comuns de apps Material Design.

[`AppBar`][`AppBar`]
: Cria uma barra horizontal que tipicamente
  é exibida no topo de uma tela.

[`Card`](#card)
: Organiza informações relacionadas em uma caixa com
  cantos arredondados e uma sombra.

[`ListTile`](#listtile)
: Organiza até 3 linhas de texto,
  e ícones leading e trailing opcionais, em uma row.

</Tab>

<Tab name="Cupertino widgets">

[`CupertinoPageScaffold`][`CupertinoPageScaffold`]
: Fornece a estrutura básica de layout para uma página estilo iOS.

[`CupertinoNavigationBar`][`CupertinoNavigationBar`]
: Cria uma barra de navegação estilo iOS no topo da tela.

[`CupertinoSegmentedControl`][`CupertinoSegmentedControl`]
: Cria um controle segmentado para seleção.

[`CupertinoTabBar`][`CupertinoTabBar`] e [`CupertinoTabScaffold`][`CupertinoTabScaffold`]
: Cria a barra de abas inferior característica do iOS.

</Tab>

</Tabs>

[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`CupertinoPageScaffold`]: {{site.api}}/flutter/cupertino/CupertinoPageScaffold-class.html
[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[`CupertinoSegmentedControl`]: {{site.api}}/flutter/cupertino/CupertinoSegmentedControl-class.html
[`CupertinoTabBar`]: {{site.api}}/flutter/cupertino/CupertinoTabBar-class.html
[`CupertinoTabScaffold`]: {{site.api}}/flutter/cupertino/CupertinoTabScaffold-class.html
[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[Material library]: {{site.api}}/flutter/material/material-library.html
[widgets library]: {{site.api}}/flutter/widgets/widgets-library.html
[Widget catalog]: /ui/widgets
[API reference docs]: {{site.api}}/flutter

### Container

Muitos layouts fazem uso liberal de [`Container`][`Container`]s para separar
widgets usando padding, ou para adicionar bordas ou margens.
Você pode mudar o plano de fundo do dispositivo colocando o
layout inteiro em um `Container` e mudando sua cor de fundo
ou imagem.

<div class="side-by-side">
<div>

[`Container`]: {{site.api}}/flutter/widgets/Container-class.html

#### Resumo (Container)

* Adiciona padding, margens, bordas
* Muda cor de fundo ou imagem
* Contém um único widget filho, mas esse filho pode ser uma `Row`,
  `Column`, ou até a raiz de uma árvore de widgets

</div>
<div class="text-center">
  <img src='/assets/images/docs/ui/layout/margin-padding-border.png' class="diagram-wrap" alt="Diagram showing: margin, border, padding, and content">
</div>
</div>

#### Exemplos (Container)

Este layout consiste em uma column com duas rows, cada uma contendo
2 imagens. Um [`Container`][`Container`] é usado para mudar a cor de fundo
da column para um cinza mais claro.

<div class="code-and-content">
<div>

  <?code-excerpt "layout/container/lib/main.dart (column)" replace="/\bContainer/[!$&!]/g;"?>
  ```dart
  Widget _buildImageColumn() {
    return [!Container!](
      decoration: const BoxDecoration(color: Colors.black26),
      child: Column(children: [_buildImageRow(1), _buildImageRow(3)]),
    );
  }
  ```

</div>
<div class="text-center">
  <img src='/assets/images/docs/ui/layout/container.png' class="mb-4" width="230px" alt="Screenshot showing 2 rows, each containing 2 images">
</div>
</div>

Um `Container` também é usado para adicionar uma borda arredondada e margens
a cada imagem:

<?code-excerpt "layout/container/lib/main.dart (row)" replace="/\bContainer/[!$&!]/g;"?>
```dart
Widget _buildDecoratedImage(int imageIndex) => Expanded(
  child: [!Container!](
    decoration: BoxDecoration(
      border: Border.all(width: 10, color: Colors.black38),
      borderRadius: const BorderRadius.all(Radius.circular(8)),
    ),
    margin: const EdgeInsets.all(4),
    child: Image.asset('images/pic$imageIndex.jpg'),
  ),
);

Widget _buildImageRow(int imageIndex) => Row(
  children: [
    _buildDecoratedImage(imageIndex),
    _buildDecoratedImage(imageIndex + 1),
  ],
);
```

Você pode encontrar mais exemplos de `Container` no [tutorial][tutorial].

**Código fonte do app:** [container]({{site.repo.this}}/tree/main/examples/layout/container)

<hr>

[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[tutorial]: /ui/layout/tutorial

### GridView

Use [`GridView`][`GridView`] para organizar widgets em uma lista
bidimensional. `GridView` fornece duas listas pré-fabricadas,
ou você pode construir sua própria grade customizada. Quando um `GridView`
detecta que seu conteúdo é muito longo para caber na render box,
ele automaticamente rola.

[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html

#### Resumo (GridView)

* Organiza widgets em uma grade
* Detecta quando o conteúdo da column excede a render box
  e automaticamente fornece rolagem
* Construa sua própria grade customizada, ou use uma das grades fornecidas:
  * `GridView.count` permite que você especifique o número de columns
  * `GridView.extent` permite que você especifique a largura máxima
  em pixels de um tile
{% comment %}
* Use `MediaQuery.of(context).orientation` para criar uma grade
  que muda seu layout dependendo se o dispositivo
  está em modo paisagem ou retrato.
{% endcomment %}

:::note
Ao exibir uma lista bidimensional onde é importante qual
row e column uma célula ocupa (por exemplo,
é a entrada na column "calorie" para a row "avocado"), use
[`Table`][`Table`] ou [`DataTable`][`DataTable`].
:::

[`DataTable`]: {{site.api}}/flutter/material/DataTable-class.html
[`Table`]: {{site.api}}/flutter/widgets/Table-class.html

#### Exemplos (GridView)

<div class="side-by-side">
<div>
  <img src='/assets/images/docs/ui/layout/gridview-extent.png' class="text-center" alt="A 3-column grid of photos" height="440px">

  Usa `GridView.extent` para criar uma grade com tiles com largura máxima
  de 150 pixels.

  **Código fonte do app:** [grid_and_list]({{site.repo.this}}/tree/main/examples/layout/grid_and_list)
</div>
<div>
  <img src='/assets/images/docs/ui/layout/gridview-count-flutter-gallery.png' class="text-center" alt="A 2 column grid with footers" height="440px">

  Usa `GridView.count` para criar uma grade que tem 2 tiles
  de largura em modo retrato, e 3 tiles de largura em modo paisagem.
  Os títulos são criados definindo a propriedade `footer` para
  cada [`GridTile`][`GridTile`].

  **Código Dart:**
  [`grid_list_demo.dart`]({{site.repo.this}}/tree/main/examples/layout/gallery/lib/grid_list_demo.dart)
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (grid)" replace="/\GridView/[!$&!]/g;"?>
```dart
Widget _buildGrid() => [!GridView!].extent(
  maxCrossAxisExtent: 150,
  padding: const EdgeInsets.all(4),
  mainAxisSpacing: 4,
  crossAxisSpacing: 4,
  children: _buildGridTileList(30),
);

// The images are saved with names pic0.jpg, pic1.jpg...pic29.jpg.
// The List.generate() constructor allows an easy way to create
// a list when objects have a predictable naming pattern.
List<Widget> _buildGridTileList(int count) =>
    List.generate(count, (i) => Image.asset('images/pic$i.jpg'));
```

<hr>

[`GridTile`]: {{site.api}}/flutter/material/GridTile-class.html

### ListView

[`ListView`][`ListView`], um widget tipo column, automaticamente
fornece rolagem quando seu conteúdo é muito longo para
sua render box.

[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html

#### Resumo (ListView)

* Uma [`Column`][`Column`] especializada para organizar uma lista de boxes
* Pode ser organizada horizontal ou verticalmente
* Detecta quando seu conteúdo não cabe e fornece rolagem
* Menos configurável que `Column`, mas mais fácil de usar e
  suporta rolagem

[`Column`]: {{site.api}}/flutter/widgets/Column-class.html

#### Exemplos (ListView)

<div class="side-by-side">
<div>
  <img src='/assets/images/docs/ui/layout/listview.png' height="400px" class="simple-border text-center" alt="ListView containing movie theaters and restaurants">

  Usa `ListView` para exibir uma lista de negócios usando
  `ListTile`s. Um `Divider` separa os cinemas dos
  restaurantes.

  **Código fonte do app:** [grid_and_list]({{site.repo.this}}/tree/main/examples/layout/grid_and_list)
</div>
<div>
  <img src='/assets/images/docs/ui/layout/listview-color-gallery.png' height="400px" class="simple-border text-center" alt="ListView containing shades of blue">

  Usa `ListView` para exibir as [`Colors`][`Colors`] da
  [paleta Material 2 Design][Material 2 Design palette]
  para uma família de cores específica.

  **Código Dart:**
  [`colors_demo.dart`]({{site.repo.this}}/tree/main/examples/layout/gallery/lib/colors_demo.dart)
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (list)" replace="/\ListView/[!$&!]/g;"?>
```dart
Widget _buildList() {
  return [!ListView!](
    children: [
      _tile('CineArts at the Empire', '85 W Portal Ave', Icons.theaters),
      _tile('The Castro Theater', '429 Castro St', Icons.theaters),
      _tile('Alamo Drafthouse Cinema', '2550 Mission St', Icons.theaters),
      _tile('Roxie Theater', '3117 16th St', Icons.theaters),
      _tile(
        'United Artists Stonestown Twin',
        '501 Buckingham Way',
        Icons.theaters,
      ),
      _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
      const Divider(),
      _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
      _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
      _tile('Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
      _tile('La Ciccia', '291 30th St', Icons.restaurant),
    ],
  );
}

ListTile _tile(String title, String subtitle, IconData icon) {
  return ListTile(
    title: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
    ),
    subtitle: Text(subtitle),
    leading: Icon(icon, color: Colors.blue[500]),
  );
}
```

<hr>

[`Colors`]: {{site.api}}/flutter/material/Colors-class.html
[Material 2 Design palette]: {{site.material2}}/design/color/the-color-system.html#tools-for-picking-colors

### Stack

Use [`Stack`][`Stack`] para organizar widgets em cima de um widget
base&mdash;frequentemente uma imagem. Os widgets podem completamente
ou parcialmente sobrepor o widget base.

[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html

#### Resumo (Stack)

* Use para widgets que se sobrepõem a outro widget
* O primeiro widget na lista de filhos é o widget base;
  filhos subsequentes são sobrepostos em cima desse widget base
* O conteúdo de um `Stack` não pode rolar
* Você pode escolher cortar filhos que excedem a render box

#### Exemplos (Stack)

<div class="side-by-side">
<div>
  <img src='/assets/images/docs/ui/layout/stack.png' class="text-center" height="200px" alt="Circular avatar image with a label">

  Usa `Stack` para sobrepor um `Container`
  (que exibe seu `Text` em um plano de fundo
  preto translúcido) em cima de um `CircleAvatar`.
  O `Stack` desloca o texto usando a propriedade `alignment` e
  `Alignment`s.

  **Código fonte do app:** [card_and_stack]({{site.repo.this}}/tree/main/examples/layout/card_and_stack)
</div>
<div>
  <img src='/assets/images/docs/ui/layout/stack-flutter-gallery.png' class="text-center" height="200px" alt="An image with a icon overlaid on top">

  Usa `Stack` para sobrepor um ícone em cima de uma imagem.

  **Código Dart:**
  [`bottom_navigation_demo.dart`]({{site.repo.this}}/tree/main/examples/layout/gallery/lib/bottom_navigation_demo.dart)
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (stack)" replace="/\bStack/[!$&!]/g;"?>
```dart
Widget _buildStack() {
  return [!Stack!](
    alignment: const Alignment(0.6, 0.6),
    children: [
      const CircleAvatar(
        backgroundImage: AssetImage('images/pic.jpg'),
        radius: 100,
      ),
      Container(
        decoration: const BoxDecoration(color: Colors.black45),
        child: const Text(
          'Mia B',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
```

<hr>

### Card

Um [`Card`][`Card`], da [biblioteca Material][Material library],
contém nuggets relacionados de informação e pode
ser composto de quase qualquer widget, mas é frequentemente usado com
[`ListTile`][`ListTile`]. `Card` tem um único filho,
mas seu filho pode ser uma column, row, list, grid,
ou outro widget que suporta múltiplos filhos.
Por padrão, um `Card` diminui seu tamanho para 0 por 0 pixels.
Você pode usar [`SizedBox`][`SizedBox`] para restringir o tamanho de um card.

No Flutter, um `Card` apresenta cantos levemente arredondados
e uma sombra, dando-lhe um efeito 3D.
Mudar a propriedade `elevation` de um `Card` permite que você controle
o efeito de sombra. Definir a elevation como 24,
por exemplo, eleva visualmente o `Card` mais da
superfície e faz com que a sombra se torne mais dispersa.
Para uma lista de valores de elevation suportados, veja [Elevation][Elevation] nas
[diretrizes Material][Material Design].
Especificar um valor não suportado desabilita a sombra completamente.

[`Card`]: {{site.api}}/flutter/material/Card-class.html
[Elevation]: {{site.material}}/styles/elevation
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[Material Design]: {{site.material}}/styles
[`SizedBox`]: {{site.api}}/flutter/widgets/SizedBox-class.html
[Material library]: {{site.api}}/flutter/material/material-library.html

#### Resumo (Card)

* Implementa um [card Material][Material card]
* Usado para apresentar nuggets relacionados de informação
* Aceita um único filho, mas esse filho pode ser uma `Row`,
  `Column`, ou outro widget que contém uma lista de filhos
* Exibido com cantos arredondados e uma sombra
* O conteúdo de um `Card` não pode rolar
* Da [biblioteca Material][Material library]

[Material card]: {{site.material}}/components/cards
[Material library]: {{site.api}}/flutter/material/material-library.html

#### Exemplos (Card)

<div class="side-by-side">
<div>
  <img src='/assets/images/docs/ui/layout/card.png' height="200px" class="text-center" alt="Card containing 3 ListTiles">

  Um `Card` contendo 3 ListTiles e dimensionado envolvendo-o
  com um `SizedBox`. Um `Divider` separa o primeiro
  e o segundo `ListTiles`.

  **Código fonte do app:** [card_and_stack]({{site.repo.this}}/tree/main/examples/layout/card_and_stack)
</div>
<div>
  <img src='/assets/images/docs/ui/layout/card-flutter-gallery.png' height="200px" class="text-center" alt="Tappable card containing an image and multiple forms of text">

  Um `Card` contendo uma imagem e texto.

  **Código Dart:**
  [`cards_demo.dart`]({{site.repo.this}}/tree/main/examples/layout/gallery/lib/cards_demo.dart)
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (card)" replace="/\bCard/[!$&!]/g;"?>
```dart
Widget _buildCard() {
  return SizedBox(
    height: 210,
    child: [!Card!](
      child: Column(
        children: [
          ListTile(
            title: const Text(
              '1625 Main Street',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            subtitle: const Text('My City, CA 99984'),
            leading: Icon(Icons.restaurant_menu, color: Colors.blue[500]),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              '(408) 555-1212',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(Icons.contact_phone, color: Colors.blue[500]),
          ),
          ListTile(
            title: const Text('costa@example.com'),
            leading: Icon(Icons.contact_mail, color: Colors.blue[500]),
          ),
        ],
      ),
    ),
  );
}
```

<hr>

### ListTile

Use [`ListTile`][`ListTile`], um widget de row especializado da
[biblioteca Material][Material library], para uma maneira fácil de criar uma row
contendo até 3 linhas de texto e ícones leading
e trailing opcionais. `ListTile` é mais comumente usado em
[`Card`][`Card`] ou [`ListView`][`ListView`], mas pode ser usado em outro lugar.

[`Card`]: {{site.api}}/flutter/material/Card-class.html
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[Material library]: {{site.api}}/flutter/material/material-library.html

#### Resumo (ListTile)

* Uma row especializada que contém até 3 linhas de texto e
  ícones opcionais
* Menos configurável que `Row`, mas mais fácil de usar
* Da [biblioteca Material][Material library]

[Material library]: {{site.api}}/flutter/material/material-library.html

#### Exemplos (ListTile)

<div class="side-by-side">
<div>
  <img src='/assets/images/docs/ui/layout/card.png' class="text-center" alt="Card containing 3 ListTiles">

  Um `Card` contendo 3 `ListTile`s.

  **Código fonte do app:** [card_and_stack]({{site.repo.this}}/tree/main/examples/layout/card_and_stack)
</div>
<div>
  <img src='/assets/images/docs/ui/layout/listtile-flutter-gallery.png' height="200px" class="simple-border text-center" alt="4 ListTiles, each containing a leading avatar">

  Usa `ListTile` com widgets leading.

  **Código Dart:**
  [`list_demo.dart`]({{site.repo.this}}/tree/main/examples/layout/gallery/lib/list_demo.dart)
</div>
</div>

<hr>

## Constraints

Para entender completamente o sistema de layout do Flutter, você precisa
aprender como o Flutter posiciona e dimensiona
os componentes em um layout. Para mais informações,
veja [Entendendo constraints][Understanding constraints].

[Understanding constraints]: /ui/layout/constraints

## Vídeos

Os vídeos a seguir, parte da
série [Flutter in Focus][Flutter in Focus],
explicam widgets `Stateless` e `Stateful`.

<YouTubeEmbed id="wE7khGHVkYY" title="How to create stateless widgets"></YouTubeEmbed>

<YouTubeEmbed id="AqCMFXEmf3w" title="How and when stateful widgets are best used"></YouTubeEmbed>

[Playlist Flutter in Focus]({{site.yt.playlist}}PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2)

---

Cada episódio da [série Widget of the Week][Widget of the Week series] foca em um widget.
Vários deles incluem widgets de layout.

<YouTubeEmbed id="b_sQ9bMltGU" title="Introducing widget of the week"></YouTubeEmbed>

[Playlist Flutter Widget of the Week]({{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG)

[Widget of the Week series]: {{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG
[Flutter in Focus]: {{site.yt.watch}}?v=wgTBLj7rMPM&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2

## Outros recursos

Os recursos a seguir podem ajudar ao escrever código de layout.

[Tutorial de layout][Layout tutorial]
: Aprenda como construir um layout.

[Catálogo de widgets][Widget catalog]
: Descreve muitos dos widgets disponíveis no Flutter.

[Análogos HTML/CSS no Flutter][HTML/CSS Analogs in Flutter]
: Para aqueles familiarizados com programação web,
  esta página mapeia funcionalidade HTML/CSS para recursos do Flutter.

[Documentos de referência da API][API reference docs]
: Documentação de referência para todas as bibliotecas do Flutter.

[Adicionando assets e imagens][Adding assets and images]
: Explica como adicionar imagens e outros assets ao pacote do seu app.

[Zero to One with Flutter][Zero to One with Flutter]
: Experiência de uma pessoa escrevendo seu primeiro app Flutter.

[Layout tutorial]: /ui/layout/tutorial
[Widget catalog]: /ui/widgets
[HTML/CSS Analogs in Flutter]: /get-started/flutter-for/web-devs
[API reference docs]: {{site.api}}/flutter
[Adding assets and images]: /ui/assets/assets-and-images
[Zero to One with Flutter]: {{site.medium}}/@mravn/zero-to-one-with-flutter-43b13fd7b354
