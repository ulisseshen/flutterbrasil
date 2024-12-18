---
ia-translate: true
title: Construindo um Layout Flutter
short-title: Tutorial de Layout
description: Aprenda como construir um layout no Flutter.
---

{% assign examples = site.repo.this | append: "/tree/" | append: site.branch | append: "/examples" -%}

:::secondary O que você vai aprender
* Como dispor widgets lado a lado.
* Como adicionar espaço entre widgets.
* Como adicionar e aninhar widgets resulta em um layout Flutter.
:::

Este tutorial explica como projetar e construir layouts no Flutter.

Se você usar o código de exemplo fornecido, poderá construir o seguinte aplicativo.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/layout-demo-app.png", caption:"O aplicativo finalizado.", width:"50%" %}

<figcaption class="figure-caption">

Foto por [Dino Reichmuth][ch-photo] em [Unsplash][].
Texto por [Switzerland Tourism][].

</figcaption>

Para obter uma visão geral melhor do mecanismo de layout, comece com
a [abordagem do Flutter para layout][].

[Switzerland Tourism]: https://www.myswitzerland.com/en-us/destinations/lake-oeschinen
[abordagem do Flutter para layout]: /ui/layout

## Diagramar o layout

Nesta seção, considere que tipo de experiência do usuário você deseja para
os usuários do seu aplicativo.

Considere como posicionar os componentes da sua interface do usuário.
Um layout consiste no resultado final total desses posicionamentos.
Considere planejar seu layout para acelerar sua codificação.
Usar pistas visuais para saber onde algo vai na tela pode ser de grande ajuda.

Use qualquer método que preferir, como uma ferramenta de design de interface ou um lápis
e uma folha de papel. Descubra onde você deseja colocar os elementos na sua
tela antes de escrever o código. É a versão de programação do ditado:
"Meça duas vezes, corte uma vez."

<ol>
<li>

Faça estas perguntas para decompor o layout em seus elementos básicos.

* Você consegue identificar as linhas e colunas?
* O layout inclui uma grade?
* Existem elementos sobrepostos?
* A interface do usuário precisa de abas?
* O que você precisa alinhar, preencher ou bordar?

</li>

<li>

Identifique os elementos maiores. Neste exemplo, você organiza a imagem, o título,
os botões e a descrição em uma coluna.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/layout-sketch-intro.svg", caption:"Elementos principais no layout: imagem, linha, linha e bloco de texto", width:"50%" %}

</li>
<li>

Diagrama cada linha.

<ol type="a">

<li>

Linha 1, a seção **Título**, tem três filhos:
uma coluna de texto, um ícone de estrela e um número.
Seu primeiro filho, a coluna, contém duas linhas de texto.
Essa primeira coluna pode precisar de mais espaço.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-title-block.svg", caption:"Seção de título com blocos de texto e um ícone" -%}

</li>

<li>

Linha 2, a seção **Botão**, tem três filhos: cada filho contém
uma coluna que então contém um ícone e texto.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-button-block.svg", caption:"A seção Botão com três botões etiquetados", width:"50%" %}

  </li>

</ol>

</li>
</ol>

Após diagramar o layout, considere como você o codificaria.

Você escreveria todo o código em uma classe?
Ou você criaria uma classe para cada parte do layout?

Para seguir as melhores práticas do Flutter, crie uma classe, ou Widget,
para conter cada parte do seu layout.
Quando o Flutter precisa renderizar novamente parte de uma UI,
ele atualiza a menor parte que muda.
É por isso que o Flutter faz "tudo um widget".
Se apenas o texto muda em um widget `Text`, o Flutter redesenha apenas esse texto.
O Flutter altera a menor quantidade possível da UI em resposta à entrada do usuário.

Para este tutorial, escreva cada elemento que você identificou como seu próprio widget.

## Criar o código base do aplicativo

Nesta seção, inicie o código básico do aplicativo Flutter para iniciar seu aplicativo.

<?code-excerpt path-base="layout/base"?>

1. [Configure seu ambiente Flutter][].

1. [Crie um novo aplicativo Flutter][new-flutter-app].

1. Substitua o conteúdo de `lib/main.dart` pelo seguinte código.
   Este aplicativo usa um parâmetro para o título do aplicativo e o título exibido
   na `appBar` do aplicativo. Essa decisão simplifica o código.

   <?code-excerpt "lib/main.dart (all)"?>
   ```dart
   import 'package:flutter/material.dart';
   
   void main() => runApp(const MyApp());
   
   class MyApp extends StatelessWidget {
     const MyApp({super.key});
   
     @override
     Widget build(BuildContext context) {
       const String appTitle = 'Demonstração de layout do Flutter';
       return MaterialApp(
         title: appTitle,
         home: Scaffold(
           appBar: AppBar(
             title: const Text(appTitle),
           ),
           body: const Center(
             child: Text('Olá Mundo'),
           ),
         ),
       );
     }
   }
   ```

[Configure seu ambiente Flutter]: /get-started/install
[Crie um novo aplicativo Flutter]: /get-started/test-drive

## Adicionar a seção Título

Nesta seção, crie um widget `TitleSection` que se assemelhe
ao seguinte layout.

<?code-excerpt path-base="layout/lakes"?>

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-title-block-unlabeled.svg", caption:"A seção Título como esboço e protótipo de UI" %}

### Adicionar o Widget `TitleSection`

Adicione o seguinte código após a classe `MyApp`.

<?code-excerpt "step2/lib/main.dart (title-section)"?>
```dart
class TitleSection extends StatelessWidget {
  const TitleSection({
    super.key,
    required this.name,
    required this.location,
  });

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
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  location,
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          /*3*/
          Icon(
            Icons.star,
            color: Colors.red[500],
          ),
          const Text('41'),
        ],
      ),
    );
  }
}
```

{:.numbered-code-notes}

1. Para usar todo o espaço livre restante na linha, use o widget `Expanded` para
   esticar o widget `Column`.
   Para colocar a coluna no início da linha,
   defina a propriedade `crossAxisAlignment` para `CrossAxisAlignment.start`.
2. Para adicionar espaço entre as linhas de texto, coloque essas linhas em um widget `Padding`.
3. A linha de título termina com um ícone de estrela vermelha e o texto `41`.
    Toda a linha está dentro de um widget `Padding` e preenche cada borda
    por 32 pixels.

### Alterar o corpo do aplicativo para uma visualização com rolagem

Na propriedade `body`, substitua o widget `Center` por um
widget `SingleChildScrollView`.
Dentro do widget [`SingleChildScrollView`][], substitua o widget `Text` por um
widget `Column`.

```dart diff
- body: const Center(
-   child: Text('Olá Mundo'),
+ body: const SingleChildScrollView(
+   child: Column(
+     children: [
```

Essas atualizações de código alteram o aplicativo das seguintes maneiras.

* Um widget `SingleChildScrollView` pode rolar.
  Isso permite que os elementos que não cabem na tela atual sejam exibidos.
* Um widget `Column` exibe quaisquer elementos dentro de sua propriedade `children`
  na ordem listada.
  O primeiro elemento listado na lista `children` é exibido em
  o topo da lista. Os elementos na lista `children` são exibidos
  em ordem de array na tela de cima para baixo.

[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html

### Atualizar o aplicativo para exibir a seção de título

Adicione o widget `TitleSection` como o primeiro elemento na lista `children`.
Isso o coloca na parte superior da tela.
Passe o nome e o local fornecidos para o construtor `TitleSection`.

```dart diff
+ children: [
+   TitleSection(
+     name: 'Camping no Lago Oeschinen',
+     location: 'Kandersteg, Suíça',
+   ),
+ ],
```

:::tip
* Ao colar código em seu aplicativo, o recuo pode ficar distorcido.
  Para corrigir isso em seu editor Flutter, use o [suporte de reformatação automática][].
* Para acelerar seu desenvolvimento, experimente o recurso [hot reload][] do Flutter.
* Se você tiver problemas, compare seu código com [`lib/main.dart`][].
:::

[suporte de reformatação automática]: /tools/formatting
[hot reload]: /tools/hot-reload
[`lib/main.dart`]: {{examples}}/layout/lakes/step2/lib/main.dart

## Adicionar a seção Botão

Nesta seção, adicione os botões que adicionarão funcionalidade ao seu aplicativo.

<?code-excerpt path-base="layout/lakes/step3"?>

A seção **Botão** contém três colunas que usam o mesmo layout:
um ícone sobre uma linha de texto.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-button-block-unlabeled.svg", caption:"A seção Botão como esboço e protótipo de UI" %}

Planeje distribuir essas colunas em uma linha para que cada uma ocupe o mesmo
quantidade de espaço. Pinte todo o texto e ícones com a cor primária.

### Adicionar o widget `ButtonSection`

Adicione o seguinte código após o widget `TitleSection` para conter o código
para construir a linha de botões.

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

### Criar um widget para fazer botões

Como o código para cada coluna pode usar a mesma sintaxe,
crie um widget chamado `ButtonWithText`.
O construtor do widget aceita uma cor, dados do ícone e um rótulo para o botão.
Usando esses valores, o widget constrói uma `Column` com um `Icon` e um estilizado
widget `Text` como seus filhos.
Para ajudar a separar esses filhos, um widget `Padding` e o widget `Text`
é envolvido com um widget `Padding`.

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

### Posicionar os botões com um widget `Row`

Adicione o seguinte código no widget `ButtonSection`.

1. Adicione três instâncias do widget `ButtonWithText`, uma para cada botão.
1. Passe a cor, `Icon` e texto para esse botão específico.
1. Alinhe as colunas ao longo do eixo principal com o
   valor `MainAxisAlignment.spaceEvenly`.
   O eixo principal para um widget `Row` é horizontal e o eixo principal para um
   widget `Column` é vertical.
   Este valor, então, diz ao Flutter para organizar o espaço livre em quantidades iguais
   antes, entre e depois de cada coluna ao longo da `Row`.

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
          ButtonWithText(
            color: color,
            icon: Icons.call,
            label: 'LIGAR',
          ),
          ButtonWithText(
            color: color,
            icon: Icons.near_me,
            label: 'ROTA',
          ),
          ButtonWithText(
            color: color,
            icon: Icons.share,
            label: 'COMPARTILHAR',
          ),
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

### Atualizar o aplicativo para exibir a seção de botões

Adicione a seção de botões à lista `children`.

<?code-excerpt path-base="layout/lakes"?>

```dart diff
    TitleSection(
      name: 'Camping no Lago Oeschinen',
      location: 'Kandersteg, Suíça',
    ),
+   ButtonSection(),
  ],
```

## Adicionar a seção de texto

Nesta seção, adicione a descrição do texto a este aplicativo.

{% render docs/app-figure.md, image:"ui/layout/layout-sketch-add-text-block.svg", caption:"O bloco de texto como esboço e protótipo de UI" %}

<?code-excerpt path-base="layout/lakes"?>

### Adicionar o widget `TextSection`

Adicione o seguinte código como um widget separado após o widget `ButtonSection`.

<?code-excerpt "step4/lib/main.dart (text-section)"?>
```dart
class TextSection extends StatelessWidget {
  const TextSection({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        description,
        softWrap: true,
      ),
    );
  }
}
```

Ao definir [`softWrap`][] como `true`, as linhas de texto preenchem a largura da coluna antes
de quebrar em um limite de palavra.

[`softWrap`]: {{site.api}}/flutter/widgets/Text/softWrap.html

### Atualizar o aplicativo para exibir a seção de texto

Adicione um novo widget `TextSection` como filho após o `ButtonSection`.
Ao adicionar o widget `TextSection`, defina sua propriedade `description` para
o texto da descrição do local.

```dart diff
      location: 'Kandersteg, Suíça',
    ),
    ButtonSection(),
+   TextSection(
+     description:
+         'O Lago Oeschinen fica no sopé do Blüemlisalp nos '
+         'Alpes Berneses. Situado a 1.578 metros acima do nível do mar, é '
+         'um dos maiores lagos alpinos. Um passeio de gôndola de '
+         'Kandersteg, seguido por uma caminhada de meia hora através de pastagens '
+         'e pinhais, leva você ao lago, que aquece até 20 '
+         'graus Celsius no verão. As atividades desfrutadas aqui '
+         'incluem remo e passeios na pista de tobogã de verão.',
+   ),
  ], 
```

## Adicionar a seção de Imagem

Nesta seção, adicione o arquivo de imagem para completar seu layout.

### Configurar seu aplicativo para usar imagens fornecidas

Para configurar seu aplicativo para referenciar imagens, modifique seu arquivo `pubspec.yaml`.

1. Crie um diretório `images` na parte superior do projeto.

1. Baixe a imagem [`lake.jpg`][] e adicione-a ao novo diretório `images`.

   :::note
   Você não pode usar `wget` para salvar este arquivo binário.
   Você pode baixar a [imagem][ch-photo] de [Unsplash][]
   sob a Licença Unsplash. O tamanho pequeno chega a 94,4 kB.
   :::

1. Para incluir imagens, adicione uma tag `assets` ao arquivo `pubspec.yaml`
   no diretório raiz do seu aplicativo.
   Quando você adiciona `assets`, ele serve como o conjunto de ponteiros para as imagens
   disponível para seu código.

   ```yaml title="pubspec.yaml" diff
     flutter:
       uses-material-design: true
   +   assets:
   +     - images/lake.jpg
   ```

:::tip
O texto em `pubspec.yaml` respeita espaços em branco e letras maiúsculas/minúsculas.
Escreva as alterações no arquivo conforme fornecido no exemplo anterior.

Essa alteração pode exigir que você reinicie o programa em execução para
exibir a imagem.
:::

[`lake.jpg`]: https://raw.githubusercontent.com/flutter/website/main/examples/layout/lakes/step5/images/lake.jpg

### Criar o widget `ImageSection`

Defina o seguinte widget `ImageSection` após as outras declarações.

<?code-excerpt "step5/lib/main.dart (image-section)"?>
```dart
class ImageSection extends StatelessWidget {
  const ImageSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      image,
      width: 600,
      height: 240,
      fit: BoxFit.cover,
    );
  }
}
```

O valor `BoxFit.cover` diz ao Flutter para exibir a imagem com
duas restrições. Primeiro, exiba a imagem o menor possível.
Segundo, cubra todo o espaço que o layout alocou, chamado de caixa de renderização.

### Atualizar o aplicativo para exibir a seção de imagem

Adicione um widget `ImageSection` como o primeiro filho na lista `children`.
Defina a propriedade `image` para o caminho da imagem que você adicionou em
[Configure seu aplicativo para usar imagens fornecidas](#configure-seu-aplicativo-para-usar-imagens-fornecidas).

```dart diff
  children: [
+   ImageSection(
+     image: 'images/lake.jpg',
+   ),
    TitleSection(
      name: 'Camping no Lago Oeschinen',
      location: 'Kandersteg, Suíça',
```

## Parabéns

É isso! Quando você recarregar o aplicativo, seu aplicativo deve ficar assim.

{% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"ui/layout/layout-demo-app.png", caption:"O aplicativo finalizado", width:"50%" %}

## Recursos

Você pode acessar os recursos usados neste tutorial nestes locais:

**Código Dart:** [`main.dart`][]<br>
**Imagem:** [ch-photo][]<br>
**Pubspec:** [`pubspec.yaml`][]<br>

[`main.dart`]: {{examples}}/layout/lakes/step6/lib/main.dart
[ch-photo]: https://unsplash.com/photos/red-and-gray-tents-in-grass-covered-mountain-5Rhl-kSRydQ
[`pubspec.yaml`]: {{examples}}/layout/lakes/step6/pubspec.yaml

## Próximos Passos

Para adicionar interatividade a este layout, siga o
[tutorial de interatividade][].

[tutorial de interatividade]: /ui/interactivity
[Unsplash]: https://unsplash.com
