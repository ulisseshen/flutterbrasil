---
ia-translate: true
title: DevTools
description: Aprenda a usar o Dart DevTools ao desenvolver apps Flutter.
layout: tutorial
---

Aprenda a usar o widget inspector e o property editor para depurar problemas de layout
e experimentar com propriedades em tempo real.

<YouTubeEmbed id="CIfLE0CShbg" title="Intro to Flutter and Dart DevTools"
  fullWidth="true"></YouTubeEmbed>

<SummaryCard>
title: O que você vai realizar
items:
  - title: Explorar a árvore de widgets do seu app com o widget inspector
    icon: account_tree
  - title: Aprender a depurar problemas de layout como restrições ilimitadas
    icon: bug_report
  - title: Experimentar com propriedades em tempo real
    icon: tune
</SummaryCard>

---

### Introdução {:#introduction}

À medida que seu app Flutter cresce em complexidade, torna-se mais importante
entender como cada uma das propriedades dos widgets afeta a UI.
O [Dart e Flutter DevTools][Dart and Flutter DevTools] oferece a você
dois recursos particularmente úteis:
o **widget inspector** e o **property editor**.

Primeiro, inicie o DevTools executando os seguintes comandos enquanto
seu app está rodando em modo debug.
Execute este comando em uma **janela de terminal separada**
daquela em que seu app está rodando:

```console
$ dart devtools
```

Executar este comando inicia o servidor do DevTools e
abre a interface em um navegador.

Para conectar o DevTools ao seu app em execução:

1. Encontre a URL do DevTools impressa no terminal
   em que seu app está rodando (por exemplo:
   `Serving DevTools at http://127.0.0.1:9101`).
2. Copie essa URL.
3. Cole-a na barra de conexão da página do DevTools no navegador.

:::note Execute na sua IDE

Desde que você tenha o plugin Flutter apropriado instalado,
você também pode executar o DevTools diretamente dentro de
editores baseados no Code OSS, como o [VS Code][], assim como no
[IntelliJ e Android Studio][IntelliJ and Android Studio].
As capturas de tela nesta lição são do VS Code.
:::

[Dart and Flutter DevTools]: /tools/devtools
[VS Code]: /tools/vs-code
[IntelliJ and Android Studio]: /tools/android-studio

### O widget inspector {:#the-widget-inspector}

O widget inspector permite que você visualize e explore sua árvore de widgets.
Ele ajuda você a entender o layout da sua UI e
identifica quais widgets são responsáveis por diferentes partes da tela.
Executando no app que você construiu até agora, o inspector se parece com isto:

<img src='/assets/images/docs/tutorial/widget_inspector.png'
  width="320px" alt="Uma captura de tela da ferramenta widget inspector do Flutter.">

Considere o widget `GamePage` que você criou nesta seção:

```dart
class GamePage extends StatelessWidget {
  GamePage({super.key});

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
                for (var letter in guess) Tile(letter.char, letter.type)
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

No widget inspector, você deve ver uma árvore exatamente dos
mesmos widgets que estão no seu código:
`MaterialApp` como a raiz, com `Scaffold` como seu `home`,
um `AppBar` como seu `appBar`, e assim por diante descendo toda a árvore até
os widgets `Row` com filhos `Tile`.
Você pode selecionar qualquer widget na árvore para ver suas propriedades e
até mesmo ir ao seu código-fonte na sua IDE.

### Depurando problemas de layout {:#debugging-layout-issues}

O widget inspector é talvez mais útil para depurar problemas de layout.

Em certas situações,
as [restrições][constraints] de um widget são ilimitadas, ou infinitas.
Isso significa que tanto
a largura máxima quanto a altura máxima estão definidas como [`double.infinity`][].
Um widget que tenta ser tão grande quanto possível não funcionará adequadamente quando
receber uma restrição ilimitada e, em modo debug, lança uma exceção.

O caso mais comum em que uma caixa de renderização acaba com uma restrição
ilimitada é dentro de um widget flex box ([`Row`][] ou [`Column`][]),
e dentro de uma região rolável,
como uma [`ListView`][] ou subclasses de [`ScrollView`][].

`ListView`, por exemplo, tenta expandir para
caber no espaço disponível em sua direção transversal. Por exemplo, se
for um bloco com rolagem vertical que tenta ser tão largo quanto seu pai.
Se você aninhar uma `ListView` com rolagem vertical dentro de
uma `ListView` com rolagem horizontal, a lista interna tenta
ser tão larga quanto possível, o que é infinitamente largo, já que a
externa pode rolar naquela direção.

Talvez o erro mais comum que você encontrará ao
construir uma aplicação Flutter seja devido ao uso incorreto de widgets de layout.
Esse erro é referido como o erro de "restrições ilimitadas" (unbounded constraints).

Assista ao vídeo a seguir para obter uma compreensão de como
identificar e resolver este problema.

<YouTubeEmbed id="jckqXR5CrPI"
  title="Decoding Flutter: Unbounded height and width"></YouTubeEmbed>

[constraints]: /ui/layout/constraints
[`double.infinity`]: {{site.api}}/flutter/dart-core/double/infinity-constant.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ScrollView`]: {{site.api}}/flutter/widgets/ScrollView-class.html

### O property editor {:#the-property-editor}

Quando você seleciona um widget no widget inspector,
o property editor exibe todas as propriedades daquele widget selecionado.
Esta é uma ferramenta poderosa para entender por que um widget parece da maneira que parece e
para experimentar mudanças nos valores das propriedades em tempo real.

<img src='/assets/images/docs/tutorial/property_editor.png'
  width="320px" alt="Uma captura de tela da ferramenta property editor do Flutter.">

Observe o método `build` do widget `Tile` de antes:

```dart
class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

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

Se você selecionar o widget `Container` dentro do `Tile` no widget inspector,
o property editor mostra sua `width` (60), `height` (60) e a propriedade
`decoration`.
Você pode então expandir a `BoxDecoration` para ver as propriedades `border` e
`color`.

Para muitas propriedades, você pode até
modificar seus valores diretamente no property editor.
Por exemplo, para testar rapidamente como uma `width` ou `height` diferente ficaria
para seu `Container` no widget `Tile`,
altere o valor numérico no property editor.
A ferramenta grava essa atualização diretamente no seu arquivo-fonte `.dart` no disco,
permitindo que você veja instantaneamente a atualização visual no seu app em execução
ao salvar ou disparar um hot reload.
Isso permite iteração rápida no design de UI.

### Revisão {:#review}

<SummaryCard>
title: O que você realizou
subtitle: Aqui está um resumo do que você construiu e aprendeu nesta lição.
completed: true
items:
  - title: Explorou a árvore de widgets do seu app com o widget inspector
    icon: account_tree
    details: >-
      O widget inspector permite visualizar toda a sua árvore de widgets,
      selecionar qualquer widget para ver suas propriedades e
      ir diretamente ao seu código-fonte.
      É uma ferramenta essencial para entender a estrutura do seu app.
  - title: Aprendeu sobre problemas de layout comuns
    icon: bug_report
    details: >-
      Você aprendeu sobre **restrições ilimitadas** (unbounded constraints),
      um dos erros mais comuns no desenvolvimento Flutter.
      Isso acontece quando widgets como
      `Row`, `Column` ou `ListView` recebem restrições infinitas.
      Agora você consegue reconhecer e corrigir esses problemas quando ocorrerem.
  - title: Experimentou com propriedades em tempo real
    icon: tune
    details: >-
      O property editor mostra todas as propriedades de um widget selecionado e
      permite modificar valores diretamente no disco, permitindo que você veja
      as atualizações instantaneamente ao salvar ou disparar um hot reload.
      Isso possibilita iteração rápida ao ajustar sua UI.
</SummaryCard>

### Teste seus conhecimentos {:#test-yourself}

<Quiz title="Quiz de DevTools">
- question: Qual é uma causa comum de erros de "unbounded constraints" no Flutter?
  options:
    - text: Usar StatefulWidgets demais na árvore de widgets.
      correct: false
      explanation: O uso de StatefulWidget não causa restrições ilimitadas.
    - text: Colocar um widget que tenta se expandir infinitamente dentro de um container rolável ou flex sem restrições adequadas.
      correct: true
      explanation: Widgets como ListView dentro de um Row, ou roláveis aninhados, podem receber restrições infinitas e falhar.
    - text: Esquecer de chamar setState após alterar dados.
      correct: false
      explanation: A falta de setState faz com que a UI não seja atualizada, não causa erros de restrição.
    - text: Usar Container sem especificar uma cor.
      correct: false
      explanation: A cor é opcional e não tem relação com restrições de layout.
- question: O que você pode fazer com o Widget Inspector no Flutter DevTools?
  options:
    - text: Gerar automaticamente testes unitários para seus widgets.
      correct: false
      explanation: O Widget Inspector serve para visualização e depuração, não para geração de testes.
    - text: Visualizar sua árvore de widgets, selecionar widgets para ver suas propriedades e ir ao código-fonte.
      correct: true
      explanation: O Widget Inspector permite explorar a estrutura do seu app, inspecionar propriedades de widgets e navegar até o código-fonte correspondente.
    - text: Implantar seu app diretamente na loja de apps.
      correct: false
      explanation: A implantação é feita separadamente; o Widget Inspector serve para depuração.
    - text: Editar as cores do tema e a tipografia do seu app.
      correct: false
      explanation: A edição do tema requer mudanças no código; o Widget Inspector serve para inspecionar o estado atual.
</Quiz>
