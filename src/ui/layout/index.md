---
title: Layouts em Flutter
short-title: Layout
description: Aprenda como funciona o mecanismo de layout do Flutter e como construir um layout.
diff2html: true
show_translate: true
---

{% assign api = site.api | append: '/flutter' -%}
{% capture code -%} {{site.repo.this}}/tree/{{site.branch}}/src/_includes/code {%- endcapture -%}
{% capture examples -%} {{site.repo.this}}/tree/{{site.branch}}/examples {%- endcapture -%}
{% capture demo -%} {{site.repo.gallery}}/tree/{{site.branch}}/lib/demos {%- endcapture -%}

<?code-excerpt path-base=""?>

<style>dl, dd { margin-bottom: 0; }</style>

{{site.alert.secondary}}
  <h4 class="no_toc">Qual é o objetivo?</h4>

  * Widgets são classes usadas para construir UIs.
  * Widgets são usados ​​para elementos de layout e UI.
  * Componha widgets simples para construir widgets complexos.
{{site.alert.end}}

O core do mecanismo de layout do Flutter são os widgets. No Flutter, quase tudo é um widget - até modelos de layout são widgets. As imagens, ícones e textos que você vê em um aplicativo Flutter são todos widgets. Mas as coisas que você não vê também são widgets, como as rows, columns e grids que organizam, restringem e alinham os widgets visíveis.

Você cria um layout compondo widgets para construir widgets mais complexos. 
Por exemplo, a primeira captura de tela abaixo mostra 3 ícones com uma legenda abaixo de cada um: 


<div class="row mb-4">
  <div class="col-12 text-center">
    <img src='/assets/images/docs/ui/layout/lakes-icons.png' class="border mt-1 mb-1 mw-100" alt="Sample layout">
    <img src='/assets/images/docs/ui/layout/lakes-icons-visual.png' class="border mt-1 mb-1 mw-100" alt="Sample layout with visual debugging">
  </div>
</div>

A segunda captura de tela exibe o layout visual, mostrando uma linha de 
3 colunas em que cada coluna contém um ícone e uma legenda.

{{site.alert.note}}
  A maioria das capturas de tela neste tutorial é exibida com
  `debugPaintSizeEnabled` definido como verdadeiro para que você possa ver o layout visual.
  Para obter mais informações, consulte 
  [Depurando problemas de layout visualmente][], uma seção em 
  [Usando o Flutter inspector][].
{{site.alert.end}}

Aqui está um diagrama da árvore de widgets para esta IU:


<img src='/assets/images/docs/ui/layout/sample-flutter-layout.png' class="mw-100" alt="Node tree">
{:.text-center}

A maioria disso deve parecer como você espera, mas você pode estar se perguntando sobre os containers (mostrados em rosa). [`Container`][] é uma classe de widget que permite personalizar seu widget filho. Use um `Container` quando quiser adicionar padding, margens, bordas ou background, para citar algumas de suas capacidades.

Neste exemplo, cada widget [`Text`][] é colocado em um `Container` para adicionar margens. A [`Row`][] inteira também é colocada em um `Container` para adicionar padding ao redor da linha.

O restante da UI neste exemplo é controlado por propriedades. Defina a cor de um ícone [`Icon`][] usando sua propriedade `color`. Use a propriedade `Text.style` para definir a fonte, sua cor, peso, etc. As colunas e linhas têm propriedades que permitem especificar como seus filhos são alinhados vertical ou horizontalmente e quanto espaço os filhos devem ocupar.


## Posicionando (Lay out) um widget

Como posicionar (lay out) um único widget no Flutter? Esta seção mostra como criar e exibir um widget simples. Também mostra todo o código de um simples aplicativo Olá Mundo.

No Flutter, são necessários apenas alguns passos para colocar texto, um ícone ou uma imagem na tela.

### 1. Selecionar um widget de layout 

Escolha entre uma variedade de [layout widgets][] com base em como você deseja alinhar ou restringir o widget visível, já que essas características são geralmente transmitidas para o widget filho.

Este exemplo usa o [`Center`][] que centraliza seu conteúdo horizontal e verticalmente.

### 2. Criar um widget visível

Por exemplo, crie um widget [`Text`][]: 


<?code-excerpt "layout/base/lib/main.dart (text)" replace="/child: //g"?>
```dart
Text('Hello World'),
```

Crie um widget [`Image`][]:

<?code-excerpt "layout/lakes/step5/lib/main.dart (Image-asset)" remove="/width|height/"?>
```dart
Image.asset(
  'images/lake.jpg',
  fit: BoxFit.cover,
),
```

Crie um widget [`Icon`][]:

<?code-excerpt "layout/lakes/step5/lib/main.dart (Icon)"?>
```dart
Icon(
  Icons.star,
  color: Colors.red[500],
),
```

### 3. Adicione o widget visível ao widget de layout

<?code-excerpt path-base="layout/base"?>

Todos os widgets de layout possuem um dos seguintes:

* Uma propriedade `child` se eles receberem um único widget filho - por exemplo, `Center` ou `Container`
* Uma propriedade `children` se eles receberem uma lista de widgets - por exemplo, `Row`, `Column`, `ListView` ou `Stack`.

Adicione o widget `Text` ao widget `Center`:


<?code-excerpt "lib/main.dart (centered-text)" replace="/body: //g"?>
```dart
const Center(
  child: Text('Hello World'),
),
```

### 4. Adicionar o widget de layout à página

Um aplicativo Flutter é, em si, um widget, e a maioria dos widgets tem um método [`build()`] [].
Instanciar e retornar um widget no método `build()` do aplicativo exibe o widget.

#### Aplicativos Material

Para um aplicativo `Material`, você pode usar um widget [`Scaffold`] [];
ele fornece um banner padrão, cor de fundo
e tem uma API para adicionar gavetas, barras de lanche e folhas inferiores.
Então você pode adicionar o widget `Center` diretamente à propriedade `body`
para a página inicial.

<?code-excerpt path-base="layout/base"?>
<?code-excerpt "lib/main.dart (MyApp)" title?>
```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter layout demo',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter layout demo'),
        ),
        body: const Center(
          child: Text('Hello World'),
        ),
      ),
    );
  }
}
```

{{site.alert.note}}
  A biblioteca [Biblioteca Material][] implementa widgets que seguem os princípios do [Material Design][]. Ao projetar sua IU, você pode usar exclusivamente
  widgets da biblioteca padrão de [widgets library][], ou pode usar
  widgets da biblioteca Material. Você pode misturar widgets de ambas
  bibliotecas, pode personalizar widgets existentes,
  ou pode construir seu próprio conjunto de widgets personalizados.
{{site.alert.end}}

#### Aplicativos não-Material

Para um aplicativo não-Material, você pode adicionar o widget `Center` no método `build()` do aplicativo:

<?code-excerpt path-base="layout/non_material"?>
<?code-excerpt "lib/main.dart (MyApp)" title?>
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
          style: TextStyle(
            fontSize: 32,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
```

Por padrão, um aplicativo não-Material não inclui um `AppBar`, um título ou uma cor de fundo. Se você deseja ter esses recursos em um aplicativo não-Material, precisará construí-los você mesmo. Este aplicativo altera a cor de fundo para branco e o texto para cinza escuro para imitar um aplicativo Material.

<div class="row">
<div class="col-md-6" markdown="1">
  Pronto! Quando você executar o aplicativo, deve ver _Hello World_.

  Código-fonte do aplicativo:
  - [Material app]({{examples}}/layout/base)
  - [Non-Material app]({{examples}}/layout/non_material)
</div>
<div class="col-md-6">
  {% include docs/app-figure.md img-class="site-mobile-screenshot border w-75"
      image="ui/layout/hello-world.png" alt="Hello World" %}
</div>
</div>

<hr>

## Organizar múltiplos widgets vertical e horizontalmente

<?code-excerpt path-base=""?>

Um dos padrões de layout mais comuns é organizar
widgets vertical ou horizontalmente. Você pode usar um
widget `Row` para organizar widgets horizontalmente,
e um widget `Column` para organizar widgets verticalmente.

{{site.alert.secondary}}
  <h4 class="no_toc">Qual é o ponto aqui?</h4>

  * `Row` e `Column` são dois dos padrões de layout mais comumente usados.
  * `Row` e `Column` cada um recebe uma lista de widgets filhos.
  * Um widget filho pode em si ser um `Row`, `Column`, ou outro widget complexo.
  * Você pode especificar como um `Row` ou `Column` alinha seus filhos, tanto vertical quanto horizontalmente.
  * Você pode esticar ou limitar widgets filhos específicos.
  * Você pode especificar como widgets filhos usam o espaço disponível do `Row` ou do `Column`.
{{site.alert.end}}

Para criar uma linha ou coluna no Flutter, você adiciona uma lista de widgets 
filhos a um widget [`Row`][] ou [`Column`][]. Por sua vez,
cada filho pode em si ser uma row(linha) ou column(coluna), e assim por diante.
O exemplo a seguir mostra como é possível aninhar rows ou 
columns dentro de rows ou columns.

Este layout é organizado como uma `Row`. A linha contém dois filhos:
uma coluna à esquerda e uma imagem à direita:


<img src='/assets/images/docs/ui/layout/pavlova-diagram.png' class="mw-100"
    alt="Screenshot with callouts showing the row containing two children">

A árvore de widgets da coluna da esquerda contém linhas e colunas aninhadas.

<img src='/assets/images/docs/ui/layout/pavlova-left-column-diagram.png' class="mw-100"
    alt="Diagram showing a left column broken down to its sub-rows and sub-columns">

Você irá implementar parte do código de layout da Pavlova em [Aninhando linhas e colunas](#nesting-rows-and-columns).

{{site.alert.note}}
`Row` e `Column` são widgets primitivos básicos para layouts horizontais 
e verticais - esses widgets de baixo nível permitem a máxima personalização. O Flutter também oferece widgets especializados de nível mais alto que podem ser suficientes para suas necessidades. Por exemplo, em vez de `Row`, você pode preferir [`ListTile`][], um widget fácil de usar com propriedades para ícones de liderança e de rastreamento e até 3 linhas de texto. Em vez de `Column`, você pode preferir [`ListView`][], um layout semelhante a uma coluna que rola automaticamente se o conteúdo for muito longo para caber no espaço disponível. Para mais informações, consulte [Widgets comuns de layout][].

{{site.alert.end}}

### Alinhando widgets

Você controla como uma linha ou coluna alinha seus filhos usando as propriedades `mainAxisAlignment` e `crossAxisAlignment`.
Para uma linha, o eixo principal é executado horizontalmente e o eixo cruzado é executado verticalmente. Para uma coluna, o eixo principal é executado verticalmente e o eixo cruzado é executado horizontalmente.

<div class="mb-2 text-center">
  <img src='/assets/images/docs/ui/layout/row-diagram.png' class="mb-2 mw-100"
      alt="Diagram showing the main axis and cross axis for a row">
  <img src='/assets/images/docs/ui/layout/column-diagram.png' class="mb-2 mr-2 ml-2 mw-100"
      alt="Diagram showing the main axis and cross axis for a column">
</div>

Os enums [`MainAxisAlignment`][] e [`CrossAxisAlignment`][] oferecem uma variedade de constantes para controlar o alinhamento.

{{site.alert.note}}
  Ao adicionar imagens ao seu projeto, 
  você precisa atualizar o arquivo `pubspec.yaml` para 
  acessá-las&mdash;este exemplo usa `Image.asset` para 
  exibir as imagens. Para mais informações, consulte o 
  [arquivo `pubspec.yaml`][] deste exemplo 
  ou [Adicionando recursos e imagens][]. 
  Você não precisa fazer isso se estiver referenciando imagens online   usando `Image.network`.
{{site.alert.end}}

No exemplo a seguir, cada uma das 3 imagens tem 100 pixels de largura.
A caixa de renderização (neste caso, toda a tela) 
tem mais de 300 pixels de largura, então definir o alinhamento do eixo principal 
como `spaceEvenly` divide o espaço horizontal 
livre igualmente entre, antes e depois de cada imagem.

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/row_column/lib/main.dart (Row)" replace="/Row/[!$&!]/g"?>
  {% prettify dart context="html" %}
  [!Row!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  <img src='/assets/images/docs/ui/layout/row-spaceevenly-visual.png' class="mw-100" alt="Row with 3 evenly spaced images">

  **Código Fonte:** [row_column]({{examples}}/layout/row_column)
</div>
</div>

As colunas funcionam da mesma maneira que as linhas. O exemplo a seguir mostra uma coluna 
de 3 imagens, cada uma com 100 pixels de altura. A altura do espaço de renderização 
(neste caso, a tela inteira) é superior a 300 pixels, portanto, 
definir o alinhamento do eixo principal como `spaceEvenly` divide o espaço vertical 
livre igualmente entre, acima e abaixo de cada imagem.

<div class="row">
<div class="col-lg-8" markdown="1">
  <?code-excerpt "layout/row_column/lib/main.dart (Column)" replace="/Column/[!$&!]/g"?>
  {% prettify dart context="html" %}
  [!Column!](
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Image.asset('images/pic1.jpg'),
      Image.asset('images/pic2.jpg'),
      Image.asset('images/pic3.jpg'),
    ],
  );
  {% endprettify %}

  **Código Fonte:** [row_column]({{examples}}/layout/row_column)
</div>
<div class="col-lg-4 text-center">
  <img src='/assets/images/docs/ui/layout/column-visual.png' class="mb-4" height="250px"
      alt="Column showing 3 images spaced evenly">
</div>
</div>

### Dimensionando widgets

Quando um layout é muito grande para caber em um dispositivo, um padrão amarelo 
e preto listrado aparece ao longo da borda afetada. 
Aqui está um [exemplo][sizing] de uma linha que é muito larga:

<img src='/assets/images/docs/ui/layout/layout-too-large.png' class="mw-100" alt="Overly-wide row">
{:.text-center}

"Widgets" podem ser dimensionados para caber em uma linha ou coluna usando o widget
[`Expanded`][]. Para corrigir o exemplo anterior onde a
linha de imagens é muito larga para sua "render box" (área de renderização),
envolva cada imagem com um widget `Expanded`. 

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images)" replace="/Expanded/[!$&!]/g"?>
  {% prettify dart context="html" %}
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      [!Expanded!](
        child: Image.asset('images/pic1.jpg'),
      ),
      [!Expanded!](
        child: Image.asset('images/pic2.jpg'),
      ),
      [!Expanded!](
        child: Image.asset('images/pic3.jpg'),
      ),
    ],
  );
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  <img src='/assets/images/docs/ui/layout/row-expanded-2-visual.png' class="mw-100"
      alt="Row of 3 images that are too wide, but each is constrained to take only 1/3 of the space">

  **Código Fonte:** [sizing]({{examples}}/layout/sizing)
</div>
</div>

Talvez você queira que um widget ocupe o dobro do espaço de seus
irmãos. Para isso, use a propriedade `flex` do widget `Expanded`,
um "inteiro" que determina o fator flex para um widget.
O fator flex padrão é 1. O código a seguir define
o fator flex da imagem do meio para 2:

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/sizing/lib/main.dart (expanded-images-with-flex)" replace="/flex.*/[!$&!]/g"?>
  {% prettify dart context="html" %}
  Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Expanded(
        child: Image.asset('images/pic1.jpg'),
      ),
      Expanded(
        [!flex: 2,!]
        child: Image.asset('images/pic2.jpg'),
      ),
      Expanded(
        child: Image.asset('images/pic3.jpg'),
      ),
    ],
  );
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  <img src='/assets/images/docs/ui/layout/row-expanded-visual.png' class="mw-100"
      alt="Row of 3 images with the middle image twice as wide as the others">

  **Código Fonte:** [sizing]({{examples}}/layout/sizing)
</div>
</div>

[sizing]: {{examples}}/layout/sizing

### Empacotando widgets

Por padrão, uma linha ou coluna ocupa tanto espaço ao longo de seu eixo principal
quanto possível, mas se você quiser agrupar os filhos mais próximos,
defina seu `mainAxisSize` como `MainAxisSize.min`. O exemplo a seguir
usa essa propriedade para agrupar os ícones de estrela.

<div class="row">
<div class="col-lg-8">
  <?code-excerpt "layout/pavlova/lib/main.dart (stars)" replace="/mainAxisSize.*/[!$&!]/g; /\w+ \w+ = //g; /;//g"?>
  {% prettify dart context="html" %}
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
  {% endprettify %}
</div>
<div class="col-lg-4" markdown="1">
  <img src='/assets/images/docs/ui/layout/packed.png' class="border mw-100"
      alt="Row of 5 stars, packed together in the middle of the row">

  **Código Fonte:** [pavlova]({{examples}}/layout/pavlova)
</div>
</div>

### Aninhando linhas e colunas

O framework de layout permite que você aninhe linhas e colunas
dentro de linhas e colunas tão profundamente quanto você precisar.
Vamos dar uma olhada no código da seção contornada
do seguinte layout:

<img src='/assets/images/docs/ui/layout/pavlova-large-annotated.png' class="border mw-100"
    alt="Screenshot of the pavlova app, with the ratings and icon rows outlined in red">
{:.text-center}

A seção contornada é implementada como duas linhas. A linha de classificações contém
cinco estrelas e o número de avaliações. A linha de ícones contém três
colunas de ícones e texto.

A árvore de widgets para a linha de classificações:

<img src='/assets/images/docs/ui/layout/widget-tree-pavlova-rating-row.png' class="mw-100" alt="Ratings row widget tree">
{:.text-center}

A variável `ratings` cria uma linha contendo uma linha menor
de 5 ícones de estrela e texto:

<?code-excerpt "layout/pavlova/lib/main.dart (ratings)" replace="/ratings/[!$&!]/g"?>
```dart
var stars = Row(
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

{{site.alert.tip}}
  Para minimizar a confusão visual que pode resultar de
  código de layout fortemente aninhado, implemente partes da IU
  em variáveis e funções.
{{site.alert.end}}

A linha de ícones, abaixo da linha de classificações, contém 3 colunas;
cada coluna contém um ícone e duas linhas de texto,
como você pode ver em sua árvore de widgets:

<img src='/assets/images/docs/ui/layout/widget-tree-pavlova-icon-row.png' class="mw-100" alt="Icon widget tree">
{:.text-center}

A variável `iconList` define a linha de ícones:

<?code-excerpt "layout/pavlova/lib/main.dart (iconList)" replace="/iconList/[!$&!]/g"?>
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

A variável `leftColumn` contém as linhas de classificações e ícones,
bem como o título e o texto que descrevem o Pavlova:

<?code-excerpt "layout/pavlova/lib/main.dart (leftColumn)" replace="/leftColumn/[!$&!]/g"?>
```dart
final [!leftColumn!] = Container(
  padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
  child: Column(
    children: [
      titleText,
      subTitle,
      ratings,
      iconList,
    ],
  ),
);
```

A coluna esquerda é colocada em um `SizedBox` para restringir sua largura.
Finalmente, a IU é construída com a linha inteira (contendo o
coluna esquerda e a imagem) dentro de um `Card`.

A [imagem Pavlova][] é do [Pixabay][].
Você pode incorporar uma imagem da rede usando `Image.network()` mas,
para este exemplo, a imagem é salva em um diretório de imagens no projeto,
adicionado ao [arquivo pubspec][], e acessado usando `Images.asset()`.
Para obter mais informações, consulte [Adicionando recursos e imagens][].

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
          SizedBox(
            width: 440,
            child: leftColumn,
          ),
          mainImage,
        ],
      ),
    ),
  ),
),
```

{{site.alert.tip}}
  O exemplo Pavlova funciona melhor horizontalmente em um dispositivo largo,
  como um tablet.  Se você estiver executando este exemplo no simulador iOS,
  você pode selecionar um dispositivo diferente usando o menu **Hardware > Device**.
  Para este exemplo, recomendamos o iPad Pro.
  Você pode alterar sua orientação para o modo paisagem usando
  **Hardware > Rotate**. Você também pode alterar o tamanho do
  janela do simulador (sem alterar o número de pixels lógicos)
  usando **Window > Scale**.
{{site.alert.end}}

**Código Fonte:** [pavlova]({{examples}}/layout/pavlova)

[imagem Pavlova]: https://pixabay.com/en/photos/pavlova
[Pixabay]: https://pixabay.com/en/photos/pavlova

<hr>

## Widgets de layout comuns

O Flutter possui uma rica biblioteca de widgets de layout.
Aqui estão alguns dos mais comumente usados.
A intenção é fazer você começar a trabalhar o mais rápido possível,
em vez de sobrecarregá-lo com uma lista completa.
Para obter informações sobre outros widgets disponíveis,
consulte o [Catálogo de widgets][],
ou use a caixa de pesquisa nos [Documentação de referência da API][].
Além disso, as páginas de widgets nos documentos da API geralmente fazem sugestões
sobre widgets semelhantes que podem atender melhor às suas necessidades.

Os seguintes widgets se dividem em duas categorias: widgets padrão
da [widgets library][], e widgets especializados da
[Biblioteca Material][].
Qualquer aplicativo pode usar a biblioteca de widgets, mas
apenas aplicativos Material podem usar a biblioteca de Componentes Material.

### Widgets padrão

* [`Container`](#container): Adiciona padding, margens, bordas,
  cor de fundo ou outras decorações a um widget.
* [`GridView`](#gridview): Organiza widgets em uma grade com scroll.
* [`ListView`](#listview): Organiza widgets em uma lista com scroll.
* [`Stack`](#stack): Sobreposiciona um widget sobre outro.

### Widgets Material

* [`Card`](#card): Organiza informações relacionadas em uma caixa com
  cantos arredondados e uma sombra projetada.
* [`ListTile`](#listtile): Organiza até 3 linhas de texto,
  e ícones opcionais à esquerda e à direita, em uma linha.

### Container

Muitos layouts usam [`Container`]s liberalmente para separar
widgets usando padding ou para adicionar bordas ou margens.
Você pode alterar o plano de fundo do dispositivo, colocando o
layout inteiro em um `Container` e alterando sua cor de fundo ou imagem.

<div class="row">
<div class="col-lg-6" markdown="1">
  <h4 class="no_toc">Resumo (Container)</h4>

  * Adicionar padding, margens, bordas
  * Alterar cor de fundo ou imagem
  * Contém um único widget filho, mas esse filho pode ser uma linha,
    coluna ou mesmo a raiz de uma árvore de widgets
</div>
<div class="col-lg-6 text-center">
  <img src='/assets/images/docs/ui/layout/margin-padding-border.png' class="mb-4 mw-100"
      width="230px"
      alt="Diagram showing: margin, border, padding, and content">
</div>
</div>

#### Examplos (Container)
{:.no_toc}

Este layout consiste em uma coluna com duas linhas, cada uma contendo
2 imagens. Um [`Container`] é usado para alterar a cor de fundo
da coluna para um cinza mais claro.

<div class="row">
<div class="col-lg-7">
  <?code-excerpt "layout/container/lib/main.dart (column)" replace="/\bContainer/[!$&!]/g;"?>
  {% prettify dart context="html" %}
  Widget _buildImageColumn() {
    return [!Container!](
      decoration: const BoxDecoration(
        color: Colors.black26,
      ),
      child: Column(
        children: [
          _buildImageRow(1),
          _buildImageRow(3),
        ],
      ),
    );
  }
  {% endprettify %}
</div>
<div class="col-lg-5 text-center">
  <img src='/assets/images/docs/ui/layout/container.png' class="mb-4 mw-100" width="230px"
      alt="Screenshot showing 2 rows, each containing 2 images">
</div>
</div>

Um `Container` também é usado para adicionar uma borda arredondada e margens
para cada imagem:

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

Você pode encontrar mais exemplos de `Container` no [tutorial][]
e na Galeria Flutter ([app em execução][], [repositório][]).

**Código Fonte:** [container]({{examples}}/layout/container)

<hr>

### GridView

Use [`GridView`][] para organizar widgets como uma lista bidimensional.
`GridView` fornece duas listas pré-fabricadas,
ou você pode construir sua própria grade personalizada. Quando um `GridView`
detecta que seu conteúdo é muito longo para caber na "render box",
ele faz scroll automaticamente.

#### Resumo (GridView)
{:.no_toc}

* Organiza widgets em uma grade
* Detecta quando o conteúdo da coluna excede a "render box"
  e fornece scroll automaticamente
* Construa sua própria grade personalizada ou use uma das grades fornecidas:
  * `GridView.count` permite especificar o número de colunas
  * `GridView.extent` permite especificar a largura máxima em pixels
    de um bloco
{% comment %}
* Use `MediaQuery.of(context).orientation` para criar uma grade
  que muda seu layout dependendo se o dispositivo
  está no modo paisagem ou retrato.
{% endcomment %}

{{site.alert.note}}
  Ao exibir uma lista bidimensional onde é importante qual
  linha e coluna uma célula ocupa (por exemplo,
  é a entrada na coluna "calorias" para a linha "abacate"), use
  [`Table`][] ou [`DataTable`][].
{{site.alert.end}}

#### Examplos (GridView)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/gridview-extent.png' class="mw-100" alt="A 3-column grid of photos">
  {:.text-center}

  Usa `GridView.extent` para criar uma grade com blocos com no máximo
  150 pixels de largura.

</div>
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/gridview-count-flutter-gallery.png' class="mw-100"
      alt="A 2 column grid with footers">
  {:.text-center}

  Usa `GridView.count` para criar uma grade com 2 blocos
  de largura no modo retrato e 3 blocos de largura no modo paisagem.
  Os títulos são criados definindo a propriedade `footer` para
  cada [`GridTile`][].

  **Código Dart:** [grid_list_demo.dart]({{demo}}/material/grid_list_demo.dart)
  da [Flutter Gallery][repositório]
</div>
</div>

<?code-excerpt "layout/grid_and_list/lib/main.dart (grid)" replace="/\GridView/[!$&!]/g;"?>
```dart
Widget _buildGrid() => [!GridView!].extent(
    maxCrossAxisExtent: 150,
    padding: const EdgeInsets.all(4),
    mainAxisSpacing: 4,
    crossAxisSpacing: 4,
    children: _buildGridTileList(30));

// The images are saved with names pic0.jpg, pic1.jpg...pic29.jpg.
// The List.generate() constructor allows an easy way to create
// a list when objects have a predictable naming pattern.
List<Container> _buildGridTileList(int count) => List.generate(
    count, (i) => Container(child: Image.asset('images/pic$i.jpg')));
```

Você pode encontrar mais exemplos de `GridView` no [tutorial][]
e na Flutter Gallery ([app em execução][], [repositório][]).

**Código Fonte:** [grid_and_list]({{examples}}/layout/grid_and_list)

<hr>

### ListView

[`ListView`], um widget semelhante a uma coluna, 
fornece scroll automaticamente quando seu conteúdo é 
muito longo para sua "render box".

#### Resumo (ListView)
{:.no_toc}

* Uma [`Column`] especializada para organizar uma lista de caixas
* Pode ser disposto horizontalmente ou verticalmente
* Detecta quando seu conteúdo não cabe e fornece scroll
* Menos configurável que `Column`, mas mais fácil 
de usar e suporta scroll

#### Examplos (ListView)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/listview.png' class="border mw-100"
      alt="ListView containing movie theaters and restaurants">
  {:.text-center}

  Usa `ListView` para exibir uma lista de empresas 
  usando `ListTile`s. Um `Divider` separa 
  os cinemas dos restaurantes.

  **Código Fonte:** [grid_and_list]({{examples}}/layout/grid_and_list)
</div>
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/listview-flutter-gallery.png' class="border mw-100"
      alt="ListView containing shades of blue">
  {:.text-center}

  Usa `ListView` para exibir as [`Colors`] da 
  [paleta do Material Design] para uma determinada 
  família de cores.

  **Código Dart:** [colors_demo.dart]({{demo}}/reference/colors_demo.dart) da
  [Flutter Gallery][repositório]
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
      _tile('United Artists Stonestown Twin', '501 Buckingham Way',
          Icons.theaters),
      _tile('AMC Metreon 16', '135 4th St #3000', Icons.theaters),
      const Divider(),
      _tile('K\'s Kitchen', '757 Monterey Blvd', Icons.restaurant),
      _tile('Emmy\'s Restaurant', '1923 Ocean Ave', Icons.restaurant),
      _tile(
          'Chaiya Thai Restaurant', '272 Claremont Blvd', Icons.restaurant),
      _tile('La Ciccia', '291 30th St', Icons.restaurant),
    ],
  );
}

ListTile _tile(String title, String subtitle, IconData icon) {
  return ListTile(
    title: Text(title,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
  );
}
```

<hr>

### Stack

Use [`Stack`] para organizar widgets em cima 
de um widget base&mdash;geralmente uma imagem. 
Os widgets podem sobrepor completamente ou parcialmente o widget base.

#### Resumo (Stack)
{:.no_toc}

* Use para widgets que se sobrepõem a outro widget
* O primeiro widget na lista de filhos é o widget base; 
  os filhos subsequentes são sobrepostos no widget base
* O conteúdo de um `Stack` não pode ter scroll
* Você pode optar por recortar filhos que excedam a "render box"

#### Examplos (Stack)
{:.no_toc}

<div class="row">
<div class="col-lg-7" markdown="1">
  <img src='/assets/images/docs/ui/layout/stack.png' class="mw-100" width="200px" alt="Circular avatar image with a label">
  {:.text-center}

  Usa `Stack` para sobrepor um `Container` 
  (que exibe seu `Text` em um fundo preto translúcido) 
  em cima de um `CircleAvatar`. 
  O `Stack` desloca o texto usando a propriedade 
  `alignment` e `Alignment`s.

  **Código Fonte:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-5" markdown="1">
  <img src='/assets/images/docs/ui/layout/stack-flutter-gallery.png' class="mw-100" alt="An image with a icon overlaid on top">
  {:.text-center}

  Usa `Stack` para sobrepor um ícone em cima de uma imagem.

  **Código Dart:** [bottom_navigation_demo.dart]({{demo}}/material/bottom_navigation_demo.dart)
  do [Flutter Gallery][repositório]
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (Stack)" replace="/\bStack/[!$&!]/g;"?>
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
        decoration: const BoxDecoration(
          color: Colors.black45,
        ),
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

Um [`Card`][], da [Biblioteca Material][],
contém trechos relacionados de informações e pode
ser composto por quase qualquer widget, mas geralmente é usado com
[`ListTile`][]. `Card` tem um único filho,
mas esse filho pode ser uma coluna, linha, lista, grade,
ou outro widget que suporte múltiplos filhos.
Por padrão, um `Card` reduz seu tamanho para 0 por 0 pixels.
Você pode usar [`SizedBox`][] para restringir o tamanho de um card.

No Flutter, um `Card` possui cantos levemente arredondados
e uma sombra projetada, dando-lhe um efeito 3D.
Alterar a propriedade `elevation` de um `Card` permite controlar
o efeito de sombra projetada. Definir a elevação para 24,
por exemplo, levanta visualmente o `Card` ainda mais da
superfície e faz com que a sombra fique mais dispersa.
Para uma lista de valores de elevação suportados, consulte [Elevation][] no
[Material guidelines][Material Design].
Especificar um valor não suportado desativa a sombra projetada completamente.

#### Resumo (Card)
{:.no_toc}

* Implementa um [Material card][]
* Usado para apresentar trechos relacionados de informações
* Aceita um único filho, mas esse filho pode ser uma `Row`,
  `Column`, ou outro widget que contenha uma lista de filhos
* Exibido com cantos arredondados e uma sombra projetada
* O conteúdo de um `Card` não pode ter scroll
* Da [Biblioteca Material][]

#### Examplos (Card)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/card.png' class="mw-100" alt="Card containing 3 ListTiles">
  {:.text-center}

  Um `Card` contendo 3 ListTiles e dimensionado ao envolvê-lo
  com um `SizedBox`. Um `Divider` separa o primeiro
  e o segundo `ListTiles`.

  **Código Fonte:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/card-flutter-gallery.png' class="mw-100"
      alt="Card containing an image, text and buttons">
  {:.text-center}

  Um `Card` contendo uma imagem e texto.

  **Dart code:** [cards_demo.dart]({{demo}}/material/cards_demo.dart)
  da [Flutter Gallery][repositório]
</div>
</div>

<?code-excerpt "layout/card_and_stack/lib/main.dart (Card)" replace="/\bCard/[!$&!]/g;"?>
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
            leading: Icon(
              Icons.restaurant_menu,
              color: Colors.blue[500],
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text(
              '(408) 555-1212',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            leading: Icon(
              Icons.contact_phone,
              color: Colors.blue[500],
            ),
          ),
          ListTile(
            title: const Text('costa@example.com'),
            leading: Icon(
              Icons.contact_mail,
              color: Colors.blue[500],
            ),
          ),
        ],
      ),
    ),
  );
}
```
<hr>

### ListTile

Use [`ListTile`][], um widget de linha especializado da
[Biblioteca Material][], para uma maneira fácil de criar uma linha
contendo até 3 linhas de texto e ícones opcionais à esquerda (leading)
e à direita (trailing). `ListTile` é mais comumente usado em
[`Card`][] ou [`ListView`][], mas pode ser usado em outros lugares.

#### Resumo (ListTile)
{:.no_toc}

* Uma linha especializada que contém até 3 linhas de texto e
  ícones opcionais
* Menos configurável que `Row`, mas mais fácil de usar
* Da [Biblioteca Material][]

#### Examplos (ListTile)
{:.no_toc}

<div class="row">
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/card.png' class="mw-100" alt="Card containing 3 ListTiles">
  {:.text-center}

  Um `Card` contendo 3 `ListTile`s.

  **Código Fonte:** [card_and_stack]({{examples}}/layout/card_and_stack)
</div>
<div class="col-lg-6" markdown="1">
  <img src='/assets/images/docs/ui/layout/listtile-flutter-gallery.png' class="border mw-100" height="200px"
      alt="4 ListTiles, each containing a leading avatar">
  {:.text-center}

  Usa `ListTile` com widgets à esquerda (leading).<br>
  **Dart code:** [list_demo.dart]({{demo}}/material/list_demo.dart)
  da [Flutter Gallery][repositório]
</div>
</div>

<hr>

## Restrições (Constraints)

Para entender completamente o sistema de layout do Flutter, você precisa
aprender como o Flutter posiciona e dimensiona
os componentes em um layout. Para mais informações,
veja [Entendendo constraints][].

## Vídeos

Os seguintes vídeos, parte da
série [Flutter em Foco][] series,
explicam os widgets `Stateless` e `Stateful`.

<iframe width="560" height="315" src="{{site.youtube-site}}/embed/wE7khGHVkYY?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> <iframe width="560" height="315" src="{{site.youtube-site}}/embed/AqCMFXEmf3w?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
[Flutter em Foco playlist]({{site.youtube-site}}/watch?v=wgTBLj7rMPM&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2)

---

Cada episódio da série
[Widget da semana][]
foca em um widget. Vários deles incluem widgets de layout.

<iframe width="560" height="315" src="{{site.youtube-site}}/embed/b_sQ9bMltGU?rel=0" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
 [Flutter playlist Widget da Semana][]

## Outros recursos

Os seguintes recursos podem ajudar ao escrever código de layout.

* [Layout tutorial][]
: Aprenda a construir um layout.

* [Catálogo de widgets][]
: Descreve muitos dos widgets disponíveis no Flutter.

* [Análogos HTML/CSS no Flutter][]
: Para aqueles familiarizados com a programação web,
  esta página mapeia funcionalidades HTML/CSS para recursos do Flutter.

* Flutter Gallery [app em execução][], [repositório][]
: Aplicativo de demonstração apresentando muitos widgets Material Design e outros
  recursos do Flutter.

* [Documentação de referência da API][]
: Documentação de referência para todas as bibliotecas do Flutter.

* [Trabalhando com restrições de Tamanho e Posição (Box) no Flutter][]
: Discute como os widgets são limitados por suas caixas de renderização (render boxes).

* [Adicionando recursos e imagens][]
: Explica como adicionar imagens e outros recursos ao pacote do seu aplicativo.

* [Do zero ao primeiro aplicativo com Flutter][]
: A experiência de uma pessoa escrevendo seu primeiro aplicativo Flutter.


[Adicionando recursos e imagens]: {{site.url}}/ui/assets-and-images
[Documentação de referência da API]: {{api}}
[`build()`]: {{api}}/widgets/StatelessWidget/build.html
[`Card`]: {{api}}/material/Card-class.html
[`Center`]: {{api}}/widgets/Center-class.html
[`Column`]: {{api}}/widgets/Column-class.html
[Widgets comuns de layout]: #common-layout-widgets
[`Colors`]: {{api}}/material/Colors-class.html
[`Container`]: {{api}}/widgets/Container-class.html
[`CrossAxisAlignment`]: {{api}}/rendering/CrossAxisAlignment.html
[`DataTable`]: {{api}}/material/DataTable-class.html
[Dealing with Box Constraints in Flutter]: {{site.url}}/ui/layout/box-constraints
[Elevation]: {{site.material}}/design/environment/elevation.html
[`Expanded`]: {{api}}/widgets/Expanded-class.html
[Flutter em Foco]: {{site.youtube-site}}/watch?v=wgTBLj7rMPM&list=PLjxrf2q8roU2HdJQDjJzOeO6J3FoFLWr2
[`GridView`]: {{api}}/widgets/GridView-class.html
[`GridTile`]: {{api}}/material/GridTile-class.html
[Análogos HTML/CSS no Flutter]: {{site.url}}/get-started/flutter-for/web-devs
[`Icon`]: {{api}}/material/Icons-class.html
[`Image`]: {{api}}/widgets/Image-class.html
[Layout tutorial]: {{site.url}}/ui/layout/tutorial
[layout widgets]: {{site.url}}/ui/widgets/layout
[`ListTile`]: {{api}}/material/ListTile-class.html
[`ListView`]: {{api}}/widgets/ListView-class.html
[`MainAxisAlignment`]: {{api}}/rendering/MainAxisAlignment.html
[Material card]: {{site.material}}/components/cards
[Material Design]: {{site.material}}/styles
[paleta do Material Design]: {{site.material2}}/design/color/the-color-system.html#tools-for-picking-colors
[Biblioteca Material]: {{api}}/material/material-library.html
[arquivo pubspec]: {{examples}}/layout/pavlova/pubspec.yaml
[arquivo `pubspec.yaml`]: {{examples}}/layout/row_column/pubspec.yaml
[repositório]: {{site.repo.gallery}}/tree/main
[`Row`]: {{api}}/widgets/Row-class.html
[app em execução]: {{site.gallery}}
[`Scaffold`]: {{api}}/material/Scaffold-class.html
[`SizedBox`]: {{api}}/widgets/SizedBox-class.html
[`Stack`]: {{api}}/widgets/Stack-class.html
[`Table`]: {{api}}/widgets/Table-class.html
[`Text`]: {{api}}/widgets/Text-class.html
[tutorial]: {{site.url}}/ui/layout/tutorial
[widgets library]: {{api}}/widgets/widgets-library.html
[Catálogo de widgets]: {{site.url}}/ui/widgets
[Depurando problemas de layout visualmente]: {{site.url}}/tools/devtools/inspector#debugging-layout-issues-visually
[Entendendo constraints]: {{site.url}}/ui/layout/constraints
[Usando o Flutter inspector]: {{site.url}}/tools/devtools/inspector
[Widget da semana]: {{site.youtube-site}}/playlist?list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG
[Do zero ao primeiro aplicativo com Flutter]: {{site.medium}}/@mravn/zero-to-one-with-flutter-43b13fd7b354
[Flutter playlist Widget da Semana]: {{site.youtube-site}}/watch?v=yI-8QHpGIP4&index=5&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG
