---
ia-translate: true
title: DevTools
description: Aprenda a usar o Dart DevTools ao desenvolver apps Flutter.
permalink: /tutorial/devtools/
sitemap: false
---

{%- comment %} TODO(ewindmill) embed video {%- endcomment %}

À medida que seu app Flutter cresce em complexidade, torna-se mais importante
entender como cada uma das propriedades dos widgets afeta a UI.
[O DevTools do Dart][Dart's DevTools] ajuda você com dois recursos particularmente úteis: o
**widget inspector** e o **property editor**.

Primeiro, inicie o DevTools executando os seguintes comandos enquanto seu app está rodando em modo debug:

```shell
$ flutter pub global activate devtools  # You only need to run this once
$ devtools
```

:::note Execute na sua IDE

Você também pode executar o DevTools diretamente dentro do [VS Code][] e do [IntelliJ][],
desde que você tenha o plugin Flutter instalado. As capturas de tela nesta lição
são do VS Code.

:::

## O widget inspector

O widget inspector permite que você visualize e explore sua árvore de widgets. Ele
ajuda você a entender o layout da sua UI e identifica quais widgets são
responsáveis por diferentes partes da tela. Executando no app que você
construiu até agora, o inspector se parece com isto:

<img src='/assets/images/docs/tutorial/widget_inspector.png' alt="A screenshot of the Flutter widget inspector tool.">

Considere o widget `GamePage` que você criou nesta seção:

```dart
class GamePage extends StatelessWidget {
  const GamePage({super.key});

  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (var guess in _game.guesses)
            Row(
              spacing: 5.0,
              children: [
              for (var letter in guess) Tile(letter, )
              ]
            ),
        ],
      ),
    );
  }
}
```

E como ele é usado no `MainApp`:

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: GamePage()),
      ),
    );
  }
}
```

No widget inspector, você deve ver uma árvore exatamente dos mesmos
widgets que estão no seu código: `MaterialApp` como a raiz, com
`Scaffold` como seu `home` e um `AppBar` como seu `appBar`, e assim por
diante descendo toda a árvore até os widgets `Row` com filhos `Tile`. Você
pode selecionar qualquer widget na árvore para ver suas propriedades e até mesmo ir
ao seu código-fonte na sua IDE.

## Depurando problemas de layout

O widget inspector é talvez mais útil para depurar problemas de layout.

Em certas situações, as [restrições][constraints] de um widget são ilimitadas, ou
infinitas. Isso significa que tanto a largura máxima quanto a
altura máxima estão definidas como [`double.infinity`][]. Um widget que tenta ser tão
grande quanto possível não funcionará adequadamente quando receber uma restrição
ilimitada e, em modo debug, lança uma exceção.

O caso mais comum em que uma caixa de renderização acaba com uma restrição
ilimitada é dentro de um widget flex box ([`Row`][] ou [`Column`][]),
e dentro de uma região rolável (como [`ListView`][] e outras
subclasses de [`ScrollView`][]). `ListView`, por exemplo, tenta expandir
para caber no espaço disponível em sua direção transversal (talvez seja um
bloco com rolagem vertical e tente ser tão largo quanto seu pai). Se
você aninhar uma `ListView` com rolagem vertical dentro de uma `ListView` com rolagem horizontal,
a lista interna tenta ser tão larga quanto possível,
o que é infinitamente largo, já que a externa pode rolar naquela
direção.

Talvez o erro mais comum que você encontrará ao construir uma aplicação
Flutter seja devido ao uso incorreto de widgets de layout, e é
referido como o erro de "restrições ilimitadas".

Assista ao vídeo a seguir para obter uma compreensão de como identificar e
resolver este problema.

<YouTubeEmbed id="jckqXR5CrPI" title="Decoding Flutter: Unbounded height and width"></YouTubeEmbed>

## O property editor

Quando você seleciona um widget no widget inspector, o property editor
exibe todas as propriedades daquele widget selecionado. Esta é uma
ferramenta poderosa para entender por que um widget parece da maneira que parece e
para experimentar mudanças nos valores das propriedades em tempo real.

<img src='/assets/images/docs/tutorial/property_editor.png' alt="A screenshot of the Flutter property editor tool.">

Observe o método `build` do widget `Tile` de antes:

```dart
class Tile extends StatelessWidget {
  const Tile(required this.letter, required hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
    );
  }
}
```

Se você selecionar um widget `Tile` no Widget Inspector, o Property
Editor mostrará sua `width` (60), `height` (60) e a
propriedade `decoration`. Você pode então expandir a `BoxDecoration` para
ver as propriedades `border` e `color`.

Para muitas propriedades, você pode até modificar seus valores diretamente no
property editor. Por exemplo, para testar rapidamente como uma `width` ou
`height` diferente ficaria para seu `Container` no widget `Tile`,
altere o valor numérico no Property Editor e veja a atualização
instantaneamente no seu app em execução sem precisar recompilar ou até mesmo fazer hot reload.
Isso permite iteração rápida no design de UI.

[Dart's DevTools]: /tools/devtools
[constraints]: /ui/layout/constraints
[`double.infinity`]:{{site.api}}/flutter/dart-core/double/infinity-constant.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView-class.html
[VS Code]: /tools/vs-code
[IntelliJ]: /tools/android-studio
