---
ia-translate: true
title: Construa um layout Flutter
shortTitle: Tutorial de layout
description: Aprenda como construir um layout no Flutter.
---

{% assign examples = site.repo.this | append: "/tree/" | append: site.branch | append: "/examples" -%}

:::secondary O que você vai aprender
* Como organizar widgets lado a lado.
* Como adicionar espaço entre widgets.
* Como adicionar e aninhar widgets resulta em um layout Flutter.
:::

Este tutorial explica como projetar e construir layouts no Flutter.

Se você usar o código de exemplo fornecido, você pode construir o seguinte app.

<DashImage figure img-class="site-mobile-screenshot border" image="ui/layout/layout-demo-app.png" caption="O app finalizado." width="50%" />

<figcaption class="figure-caption">

Foto por [Dino Reichmuth][ch-photo] no [Unsplash][Unsplash].
Texto por [Switzerland Tourism][Switzerland Tourism].

</figcaption>

Para obter uma melhor visão geral do mecanismo de layout, comece com
[a abordagem do Flutter para layout][Flutter's approach to layout].

[Switzerland Tourism]: https://www.myswitzerland.com/en-us/destinations/lake-oeschinen
[Flutter's approach to layout]: /ui/layout

## Diagramar o layout

Nesta seção, considere que tipo de experiência de usuário você deseja para
os usuários do seu app.

Considere como posicionar os componentes da sua interface de usuário.
Um layout consiste no resultado final total desses posicionamentos.
Considere planejar seu layout para acelerar sua codificação.
Usar dicas visuais para saber onde algo vai na tela pode ser uma grande ajuda.

Use o método que você preferir, como uma ferramenta de design de interface ou um lápis
e uma folha de papel. Descubra onde você quer colocar elementos na sua
tela antes de escrever código. É a versão de programação do ditado:
"Meça duas vezes, corte uma vez."

<ol>
<li>

Faça estas perguntas para dividir o layout em seus elementos básicos.

* Você consegue identificar as rows e columns?
* O layout inclui uma grid?
* Existem elementos sobrepostos?
* A UI precisa de tabs?
* O que você precisa alinhar, adicionar padding ou borda?

</li>

<li>

Identifique os elementos maiores. Neste exemplo, você organiza a imagem, título,
botões e descrição em uma column.

<DashImage figure img-class="site-mobile-screenshot border" image="ui/layout/layout-sketch-intro.svg" caption="Elementos principais no layout: imagem, row, row, e bloco de texto" width="50%" />

</li>
<li>

Diagramar cada row.

<ol type="a">

<li>

Row 1, a seção **Title**, tem três filhos:
uma column de texto, um ícone de estrela e um número.
Seu primeiro filho, a column, contém duas linhas de texto.
Essa primeira column pode precisar de mais espaço.

<DashImage figure image="ui/layout/layout-sketch-title-block.svg" caption="Seção de título com blocos de texto e um ícone" />

</li>

<li>

Row 2, a seção **Button**, tem três filhos: cada filho contém
uma column que então contém um ícone e texto.

<DashImage figure image="ui/layout/layout-sketch-button-block.svg" caption="A seção Button com três botões rotulados" width="50%" />

  </li>

</ol>

</li>
</ol>

Depois de diagramar o layout, considere como você o codificaria.

Você escreveria todo o código em uma classe?
Ou, você criaria uma classe para cada parte do layout?

Para seguir as melhores práticas do Flutter, crie uma classe, ou Widget,
para conter cada parte do seu layout.
Quando o Flutter precisa re-renderizar parte de uma UI,
ele atualiza a menor parte que muda.
É por isso que o Flutter faz "tudo ser um widget".
Se apenas o texto muda em um widget `Text`, o Flutter redesenha apenas esse texto.
O Flutter muda a menor quantidade possível da UI em resposta à entrada do usuário.

Para este tutorial, escreva cada elemento que você identificou como seu próprio widget.

## Criar o código base do app

Nesta seção, crie o esqueleto do código básico do app Flutter para iniciar seu app.

<?code-excerpt path-base="layout/base"?>

1. [Configure seu ambiente Flutter][Set up your Flutter environment].

1. [Crie um novo app Flutter][new-flutter-app].

1. Substitua o conteúdo de `lib/main.dart` com o seguinte código.
   Este app usa um parâmetro para o título do app e o título mostrado
   na `appBar` do app. Esta decisão simplifica o código.

   <?code-excerpt "lib/main.dart (all)"?>
   ```dart
   import 'package:flutter/material.dart';

   void main() => runApp(const MyApp());

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

[Set up your Flutter environment]: /get-started
[new-flutter-app]: /reference/create-new-app

## Adicionar a seção Title

Nesta seção, crie um widget `TitleSection` que se pareça com
o seguinte layout.

<?code-excerpt path-base="layout/lakes"?>

<DashImage figure image="ui/layout/layout-sketch-title-block-unlabeled.svg" caption="A seção Title como esboço e protótipo de UI" />

### Adicione o Widget `TitleSection`

Adicione o seguinte código após a classe `MyApp`.

<?code-excerpt "step2/lib/main.dart (title-section)"?>
```dart
class TitleSection extends StatelessWidget {
  const TitleSection({super.key, required this.name, required this.location});

  final String name;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(location, style: TextStyle(color: Colors.grey[500])),
              ],
            ),
          ),
          /*3*/
          Icon(Icons.star, color: Colors.red[500]),
          const Text('41'),
        ],
      ),
    );
  }
}
```

{:.numbered-code-notes}

1. Para usar todo o espaço livre restante na row, use o widget `Expanded` para
   esticar o widget `Column`.
   Para colocar a column no início da row,
   defina a propriedade `crossAxisAlignment` como `CrossAxisAlignment.start`.
2. Para adicionar espaço entre as rows de texto, coloque essas rows em um widget `Padding`.
3. A row de título termina com um ícone de estrela vermelha e o texto `41`.
    Toda a row fica dentro de um widget `Padding` e adiciona padding em cada borda
    de 32 pixels.

### Mude o body do app para uma visualização rolável

Na propriedade `body`, substitua o widget `Center` por um
widget `SingleChildScrollView`.
Dentro do widget [`SingleChildScrollView`][`SingleChildScrollView`], substitua o widget `Text` por um
widget `Column`.

```dart diff
- body: const Center(
-   child: Text('Hello World'),
+ body: const SingleChildScrollView(
+   child: Column(
+     children: [
```

Essas atualizações de código mudam o app das seguintes maneiras.

* Um widget `SingleChildScrollView` pode rolar.
  Isso permite que elementos que não cabem na tela atual sejam exibidos.
* Um widget `Column` exibe quaisquer elementos dentro de sua propriedade `children`
  na ordem listada.
  O primeiro elemento listado na lista `children` é exibido no
  topo da lista. Elementos na lista `children` são exibidos
  em ordem de array na tela de cima para baixo.

[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

### Atualize o app para exibir a seção de título

Adicione o widget `TitleSection` como o primeiro elemento na lista `children`.
Isso o coloca no topo da tela.
Passe o nome e localização fornecidos para o construtor `TitleSection`.

```dart diff
+ children: [
+   TitleSection(
+     name: 'Oeschinen Lake Campground',
+     location: 'Kandersteg, Switzerland',
+   ),
+ ],
```

:::tip
* Ao colar código no seu app, a indentação pode ficar distorcida.
  Para corrigir isso no seu editor Flutter, use [suporte de reformatação automática][automatic reformatting support].
* Para acelerar seu desenvolvimento, experimente o recurso de [hot reload][hot reload] do Flutter.
* Se você tiver problemas, compare seu código com [`lib/main.dart`][`lib/main.dart`].
:::

[automatic reformatting support]: /tools/formatting
[hot reload]: /tools/hot-reload
[`lib/main.dart`]: {{examples}}/layout/lakes/step2/lib/main.dart

## Adicionar a seção Button

Nesta seção, adicione os botões que adicionarão funcionalidade ao seu app.

<?code-excerpt path-base="layout/lakes/step3"?>

A seção **Button** contém três columns que usam o mesmo layout:
um ícone sobre uma row de texto.

<DashImage figure image="ui/layout/layout-sketch-button-block-unlabeled.svg" caption="A seção Button como esboço e protótipo de UI" />

Planeje distribuir essas columns em uma row para que cada uma ocupe a mesma
quantidade de espaço. Pinte todo o texto e ícones com a cor primária.

### Adicione o widget `ButtonSection`

Adicione o seguinte código após o widget `TitleSection` para conter o código
para construir a row de botões.

<?code-excerpt "lib/main.dart (button-start)"?>
```dart
class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    // ···
  }

}
```

### Crie um widget para fazer botões

Como o código para cada column poderia usar a mesma sintaxe,
crie um widget chamado `ButtonWithText`.
O construtor do widget aceita uma cor, dados de ícone e um rótulo para o botão.
Usando esses valores, o widget constrói uma `Column` com um `Icon` e um
widget `Text` estilizado como seus filhos.
Para ajudar a separar esses filhos, um widget `Padding` envolve o widget `Text`
com um widget `Padding`.

Adicione o seguinte código após a classe `ButtonSection`.

<?code-excerpt "lib/main.dart (button-with-text)"?>
```dart
class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});
  // ···
}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
```

### Posicione os botões com um widget `Row`

Adicione o seguinte código no widget `ButtonSection`.

1. Adicione três instâncias do widget `ButtonWithText`, uma para cada botão.
1. Passe a cor, `Icon` e texto para esse botão específico.
1. Alinhe as columns ao longo do eixo principal com o
   valor `MainAxisAlignment.spaceEvenly`.
   O eixo principal para um widget `Row` é horizontal e o eixo principal para um
   widget `Column` é vertical.
   Este valor, então, diz ao Flutter para organizar o espaço livre em quantidades iguais
   antes, entre e depois de cada column ao longo da `Row`.

<?code-excerpt "lib/main.dart (button-section)"?>
```dart
class ButtonSection extends StatelessWidget {
  const ButtonSection({super.key});

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).primaryColor;
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ButtonWithText(color: color, icon: Icons.call, label: 'CALL'),
          ButtonWithText(color: color, icon: Icons.near_me, label: 'ROUTE'),
          ButtonWithText(color: color, icon: Icons.share, label: 'SHARE'),
        ],
      ),
    );
  }

}

class ButtonWithText extends StatelessWidget {
  const ButtonWithText({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      // ···
    );
  }

}
```

### Atualize o app para exibir a seção de botões

Adicione a seção de botões à lista `children`.

<?code-excerpt path-base="layout/lakes"?>

```dart diff
    TitleSection(
      name: 'Oeschinen Lake Campground',
      location: 'Kandersteg, Switzerland',
    ),
+   ButtonSection(),
  ],
```

## Adicionar a seção Text

Nesta seção, adicione a descrição de texto a este app.

<DashImage figure image="ui/layout/layout-sketch-add-text-block.svg" caption="O bloco de texto como esboço e protótipo de UI" />

<?code-excerpt path-base="layout/lakes"?>

### Adicione o widget `TextSection`

Adicione o seguinte código como um widget separado após o widget `ButtonSection`.

<?code-excerpt "step4/lib/main.dart (text-section)"?>
```dart
class TextSection extends StatelessWidget {
  const TextSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(description, softWrap: true),
    );
  }
}
```

Ao definir [`softWrap`][`softWrap`] como `true`, linhas de texto preenchem a largura da column antes
de quebrar em um limite de palavra.

[`softWrap`]: {{site.api}}/flutter/widgets/Text/softWrap.html

### Atualize o app para exibir a seção de texto

Adicione um novo widget `TextSection` como filho após o `ButtonSection`.
Ao adicionar o widget `TextSection`, defina sua propriedade `description` para
o texto da descrição do local.

```dart diff
      location: 'Kandersteg, Switzerland',
    ),
    ButtonSection(),
+   TextSection(
+     description:
+         'Lake Oeschinen lies at the foot of the Blüemlisalp in the '
+         'Bernese Alps. Situated 1,578 meters above sea level, it '
+         'is one of the larger Alpine Lakes. A gondola ride from '
+         'Kandersteg, followed by a half-hour walk through pastures '
+         'and pine forest, leads you to the lake, which warms to 20 '
+         'degrees Celsius in the summer. Activities enjoyed here '
+         'include rowing, and riding the summer toboggan run.',
+   ),
  ],
```

## Adicionar a seção Image

Nesta seção, adicione o arquivo de imagem para completar seu layout.

### Configure seu app para usar imagens fornecidas

Para configurar seu app para referenciar imagens, modifique seu arquivo `pubspec.yaml`.

1. Crie um diretório `images` no topo do projeto.

1. Baixe a imagem [`lake.jpg`][`lake.jpg`] e adicione-a ao novo diretório `images`.

   :::note
   Você não pode usar `wget` para salvar este arquivo binário.
   Você pode baixar a [imagem][ch-photo] do [Unsplash][Unsplash]
   sob a Licença Unsplash. O tamanho pequeno vem em 94.4 kB.
   :::

1. Para incluir imagens, adicione uma tag `assets` ao arquivo `pubspec.yaml`
   no diretório raiz do seu app.
   Quando você adiciona `assets`, ele serve como o conjunto de ponteiros para as imagens
   disponíveis para seu código.

   ```yaml title="pubspec.yaml" diff
     flutter:
       uses-material-design: true
   +   assets:
   +     - images/lake.jpg
   ```

:::tip
Texto no `pubspec.yaml` respeita espaços em branco e maiúsculas/minúsculas.
Escreva as mudanças no arquivo como dado no exemplo anterior.

Esta mudança pode exigir que você reinicie o programa em execução para
exibir a imagem.
:::

[`lake.jpg`]: https://raw.githubusercontent.com/flutter/website/main/examples/layout/lakes/step5/images/lake.jpg

### Crie o widget `ImageSection`

Defina o seguinte widget `ImageSection` após as outras declarações.

<?code-excerpt "step5/lib/main.dart (image-section)"?>
```dart
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(image, width: 600, height: 240, fit: BoxFit.cover);
  }
}
```

O valor `BoxFit.cover` diz ao Flutter para exibir a imagem com
duas restrições. Primeiro, exibir a imagem o menor possível.
Segundo, cobrir todo o espaço que o layout alocou, chamado de render box.

### Atualize o app para exibir a seção de imagem

Adicione um widget `ImageSection` como o primeiro filho na lista `children`.
Defina a propriedade `image` para o caminho da imagem que você adicionou em
[Configure seu app para usar imagens fornecidas](#configure-seu-app-para-usar-imagens-fornecidas).

```dart diff
  children: [
+   ImageSection(
+     image: 'images/lake.jpg',
+   ),
    TitleSection(
      name: 'Oeschinen Lake Campground',
      location: 'Kandersteg, Switzerland',
```

## Parabéns

É isso! Quando você fizer hot reload do app, seu app deve parecer com isto.

<DashImage figure img-class="site-mobile-screenshot border" image="ui/layout/layout-demo-app.png" caption="O app finalizado" width="50%" />

## Recursos

Você pode acessar os recursos usados neste tutorial destes locais:

**Código Dart:** [`main.dart`][`main.dart`]<br>
**Imagem:** [ch-photo][ch-photo]<br>
**Pubspec:** [`pubspec.yaml`][`pubspec.yaml`]<br>

[`main.dart`]: {{examples}}/layout/lakes/step6/lib/main.dart
[ch-photo]: https://unsplash.com/photos/red-and-gray-tents-in-grass-covered-mountain-5Rhl-kSRydQ
[`pubspec.yaml`]: {{examples}}/layout/lakes/step6/pubspec.yaml

## Próximos Passos

Para adicionar interatividade a este layout, siga o
[tutorial de interatividade][interactivity tutorial].

[interactivity tutorial]: /ui/interactivity
[Unsplash]: https://unsplash.com
