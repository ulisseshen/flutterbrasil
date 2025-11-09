---
ia-translate: true
title: Flutter para desenvolvedores Xamarin.Forms
description: Aprenda como aplicar o conhecimento de desenvolvedor Xamarin.Forms ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/xamarin_devs"?>

Este documento é destinado a desenvolvedores Xamarin.Forms
que desejam aplicar seus conhecimentos existentes
para construir apps mobile com Flutter.
Se você entende os fundamentos do framework Xamarin.Forms,
então você pode usar este documento como um ponto de partida para o desenvolvimento Flutter.

Seu conhecimento e habilidades em Android e iOS
são valiosos ao construir com Flutter,
porque Flutter depende das configurações nativas do sistema operacional,
similar a como você configuraria seus projetos nativos Xamarin.Forms.
O Flutter Frameworks também é similar a como você cria uma única UI,
que é usada em múltiplas plataformas.

Este documento pode ser usado como um guia de referência pulando entre
as questões que são mais relevantes para suas necessidades.

## Configuração do projeto

### Como o app inicia?

Para cada plataforma no Xamarin.Forms,
você chama o método `LoadApplication`,
que cria uma nova aplicação e inicia seu app.

```csharp
LoadApplication(new App());
```

No Flutter, o ponto de entrada main padrão é
`main` onde você carrega seu app Flutter.

<?code-excerpt "lib/main.dart (main)"?>
```dart
void main() {
  runApp(const MyApp());
}
```

No Xamarin.Forms, você atribui uma `Page` à
propriedade `MainPage` na classe `Application`.

```csharp
public class App : Application
{
    public App()
    {
        MainPage = new ContentPage
        {
            Content = new Label
            {
                Text = "Hello World",
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };
    }
}
```

No Flutter, "tudo é um widget", até mesmo a aplicação em si.
O exemplo a seguir mostra `MyApp`, um `Widget` de aplicação simples.

<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  /// This widget is the root of your application.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Hello World!', textDirection: TextDirection.ltr),
    );
  }
}
```

### Como criar uma página?

Xamarin.Forms tem muitos tipos de páginas;
`ContentPage` é o mais comum.
No Flutter, você especifica um widget de aplicação que contém sua página raiz.
Você pode usar um widget [`MaterialApp`][], que suporta [Material Design][],
ou você pode usar um widget [`CupertinoApp`][], que suporta um app estilo iOS,
ou você pode usar o [`WidgetsApp`][] de nível mais baixo,
que você pode personalizar da maneira que quiser.

[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html

O código a seguir define a página inicial, um stateful widget.
No Flutter, todos os widgets são imutáveis,
mas dois tipos de widgets são suportados: _Stateful_ e _Stateless_.
Exemplos de um stateless widget são títulos, ícones ou imagens.

O exemplo a seguir usa `MaterialApp`,
que mantém sua página raiz na propriedade `home`.

<?code-excerpt "lib/page.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  /// This widget is the root of your application.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
```

A partir daqui, sua primeira página real é outro `Widget`,
no qual você cria seu estado.

Um widget _Stateful_, como `MyHomePage` abaixo, consiste de duas partes.
A primeira parte, que é imutável, cria um objeto `State`
que mantém o estado do objeto. O objeto `State` persiste durante
a vida do widget.

<?code-excerpt "lib/page.dart (my-home-page)"?>
```dart
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
```

O objeto `State` implementa o método `build()` para o stateful widget.

Quando o estado da árvore de widgets muda, chame `setState()`,
que aciona uma reconstrução daquela porção da UI.
Certifique-se de chamar `setState()` apenas quando necessário,
e apenas na parte da árvore de widgets que mudou,
ou pode resultar em desempenho de UI ruim.

<?code-excerpt "lib/page.dart (my-home-page-state)"?>
```dart
class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set the appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

No Flutter, a UI (também conhecida como árvore de widgets), é imutável,
o que significa que você não pode mudar seu estado uma vez que ela é construída.
Você muda campos em sua classe `State`, então chama `setState()`
para reconstruir toda a árvore de widgets novamente.

Esta forma de gerar UI é diferente do Xamarin.Forms,
mas há muitos benefícios para esta abordagem.

## Views

### Qual é o equivalente de uma Page ou Element no Flutter?

:::secondary
Como é a programação no estilo react, ou _declarativa_, diferente do
estilo imperativo tradicional?
Para uma comparação, veja [Introdução à UI declarativa][Introduction to declarative UI].
:::

`ContentPage`, `TabbedPage`, `FlyoutPage` são todos tipos de páginas
que você pode usar em uma aplicação Xamarin.Forms.
Estas páginas então contêm `Element`s para exibir os vários controles.
No Xamarin.Forms uma `Entry` ou `Button` são exemplos de um `Element`.

No Flutter, quase tudo é um widget.
Uma `Page`, chamada de `Route` no Flutter, é um widget.
Botões, barras de progresso e controladores de animação são todos widgets.
Ao construir uma rota, você cria uma árvore de widgets.

Flutter inclui a biblioteca [Material Components][].
Estes são widgets que implementam as [diretrizes do Material Design][Material Design guidelines].
Material Design é um sistema de design flexível
[otimizado para todas as plataformas][optimized for all platforms], incluindo iOS.

Mas Flutter é flexível e expressivo o suficiente
para implementar qualquer linguagem de design.
Por exemplo, no iOS, você pode usar os [widgets Cupertino][Cupertino widgets]
para produzir uma interface que parece com a [linguagem de design iOS da Apple][Apple's iOS design language].

### Como atualizar widgets?

No Xamarin.Forms, cada `Page` ou `Element` é uma classe com estado,
que tem propriedades e métodos.
Você atualiza seu `Element` atualizando uma propriedade,
e isso é propagado para o controle nativo.

No Flutter, `Widget`s são imutáveis e você não pode atualizá-los diretamente
mudando uma propriedade, em vez disso você tem que trabalhar com o estado do widget.

É aqui que vem o conceito de widgets Stateful vs Stateless.
Um `StatelessWidget` é exatamente o que parece&mdash;
um widget sem informação de estado.

`StatelessWidgets` são úteis quando a parte da interface do usuário
que você está descrevendo não depende de nada
além das informações de configuração no objeto.

Por exemplo, no Xamarin.Forms, isso é similar
a colocar uma `Image` com seu logotipo.
O logotipo não vai mudar durante o tempo de execução,
então use um `StatelessWidget` no Flutter.

Se você quiser mudar dinamicamente a UI com base em dados recebidos
após fazer uma chamada HTTP ou uma interação do usuário,
então você tem que trabalhar com `StatefulWidget`
e dizer ao framework Flutter que
o `State` do widget foi atualizado,
para que ele possa atualizar aquele widget.

A coisa importante a notar aqui é que no núcleo
tanto stateless quanto stateful widgets se comportam da mesma forma.
Eles reconstroem a cada frame, a diferença é
que o `StatefulWidget` tem um objeto `State`
que armazena dados de estado entre frames e os restaura.

Se você estiver em dúvida, então sempre lembre desta regra: se um widget muda
(por causa de interações do usuário, por exemplo) ele é stateful.
No entanto, se um widget reage à mudança, o widget pai que o contém ainda pode
ser stateless se ele mesmo não reagir à mudança.

O exemplo a seguir mostra como usar um `StatelessWidget`.
Um `StatelessWidget` comum é o widget `Text`.
Se você olhar a implementação do widget `Text`
você vai encontrar que ele é uma subclasse de `StatelessWidget`.

<?code-excerpt "lib/views.dart (text)" replace="/return //g"?>
```dart
const Text(
  'I like Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Como você pode ver, o widget `Text` não tem informação de estado associada a ele,
ele renderiza o que é passado em seus construtores e nada mais.

Mas, e se você quiser fazer "I Like Flutter" mudar dinamicamente,
por exemplo, ao clicar em um `FloatingActionButton`?

Para conseguir isso, envolva o widget `Text` em um `StatefulWidget`
e atualize-o quando o usuário clicar no botão,
como mostrado no exemplo a seguir:

<?code-excerpt "lib/views_stateful.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  /// Default placeholder text
  String textToShow = 'I Like Flutter';

  void _updateText() {
    setState(() {
      // Update the text
      textToShow = 'Flutter is Awesome!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: Center(child: Text(textToShow)),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

### Como faço o layout dos meus widgets? Qual é o equivalente de um arquivo XAML?

No Xamarin.Forms, a maioria dos desenvolvedores escreve layouts em XAML,
embora às vezes em C#.
No Flutter, você escreve seus layouts com uma árvore de widgets em código.

O exemplo a seguir mostra como exibir um widget simples com padding:

<?code-excerpt "lib/padding.dart (padding)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Sample App')),
    body: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(left: 20, right: 30),
        ),
        onPressed: () {},
        child: const Text('Hello'),
      ),
    ),
  );
}
```

Você pode visualizar os layouts que o Flutter tem a oferecer no
[catálogo de widgets][widget catalog].

### Como adicionar ou remover um Element do meu layout?

No Xamarin.Forms, você tinha que remover ou adicionar um `Element` em código.
Isso envolvia definir a propriedade `Content` ou chamar
`Add()` ou `Remove()` se fosse uma lista.

No Flutter, porque widgets são imutáveis não há equivalente direto.
Em vez disso, você pode passar uma função para o pai que retorna um widget,
e controlar a criação daquele filho com uma flag booleana.

O exemplo a seguir mostra como alternar entre dois widgets
quando o usuário clica no `FloatingActionButton`:

<?code-excerpt "lib/views.dart (add-remove-element)"?>
```dart
class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  /// Default value for toggle
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  Widget _getToggleChild() {
    if (toggle) {
      return const Text('Toggle One');
    }
    return CupertinoButton(onPressed: () {}, child: const Text('Toggle Two'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: Center(child: _getToggleChild()),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

### Como animar um widget?

No Xamarin.Forms, você cria animações simples usando ViewExtensions que
incluem métodos como `FadeTo` e `TranslateTo`.
Você usaria esses métodos em uma view
para realizar as animações necessárias.

```xml
<Image Source="{Binding MyImage}" x:Name="myImage" />
```

Então no code behind, ou um behavior, isso faria fade in da imagem,
durante um período de 1 segundo.

```csharp
myImage.FadeTo(0, 1000);
```

No Flutter, você anima widgets usando a biblioteca de animação
envolvendo widgets dentro de um widget animado.
Use um `AnimationController`, que é uma `Animation<double>`
que pode pausar, buscar, parar e reverter a animação.
Ele requer um `Ticker` que sinaliza quando vsync acontece,
e produz uma interpolação linear entre 0 e 1
em cada frame enquanto está executando.
Você então cria uma ou mais `Animation`s e as anexa ao controller.

Por exemplo, você pode usar `CurvedAnimation`
para implementar uma animação ao longo de uma curva interpolada.
Neste sentido, o controller é a fonte "mestre" do progresso da animação
e a `CurvedAnimation` calcula a curva
que substitui o movimento linear padrão do controller.
Como widgets, animações no Flutter trabalham com composição.

Ao construir a árvore de widgets, você atribui a `Animation`
a uma propriedade animada de um widget,
como a opacidade de um `FadeTransition`,
e diz ao controller para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que faz
fade do widget em um logotipo quando você pressiona o `FloatingActionButton`:

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
  /// This widget is the root of your application.
  const FadeAppTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Fade Demo',
      home: MyFadeTest(title: 'Fade Demo'),
    );
  }
}

class MyFadeTest extends StatefulWidget {
  const MyFadeTest({super.key, required this.title});

  final String title;

  @override
  State<MyFadeTest> createState() => _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: FadeTransition(
          opacity: curve,
          child: const FlutterLogo(size: 100),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          controller.forward();
        },
        tooltip: 'Fade',
        child: const Icon(Icons.brush),
      ),
    );
  }
}
```

Para mais informações, veja [widgets de Animação e Movimento][Animation & Motion widgets],
o [tutorial de Animações][Animations tutorial] e a [visão geral de Animações][Animations overview].

### Como desenhar/pintar na tela?

Xamarin.Forms nunca teve uma maneira integrada de desenhar diretamente na tela.
Muitos usariam SkiaSharp, se precisassem de uma imagem customizada desenhada.
No Flutter, você tem acesso direto ao Skia Canvas
e pode facilmente desenhar na tela.

Flutter tem duas classes que ajudam você a desenhar na tela: `CustomPaint`
e `CustomPainter`, sendo que a última implementa seu algoritmo para desenhar na
tela.

Para aprender como implementar um signature painter no Flutter,
veja a resposta de Collin em [Custom Paint][].

[Custom Paint]: {{site.so}}/questions/46241071/create-signature-area-for-mobile-app-in-dart-flutter


<?code-excerpt "lib/draw.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: DemoApp()));
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Signature());
}

class Signature extends StatefulWidget {
  const Signature({super.key});

  @override
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset?> _points = <Offset?>[];

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      final RenderBox referenceBox = context.findRenderObject() as RenderBox;
      final Offset localPosition = referenceBox.globalToLocal(
        details.globalPosition,
      );
      _points = List.from(_points)..add(localPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _onPanUpdate,
      onPanEnd: (details) => _points.add(null),
      child: CustomPaint(
        painter: SignaturePainter(_points),
        size: Size.infinite,
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  const SignaturePainter(this.points);

  final List<Offset?> points;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) =>
      oldDelegate.points != points;
}
```

### Onde está a opacidade do widget?

No Xamarin.Forms, todos os `VisualElement`s têm uma Opacity.
No Flutter, você precisa envolver um widget em um
[widget `Opacity`][`Opacity` widget] para conseguir isso.

### Como construir widgets customizados?

No Xamarin.Forms, você normalmente faz subclasse de `VisualElement`,
ou usa um `VisualElement` pré-existente, para sobrescrever e
implementar métodos que alcançam o comportamento desejado.

No Flutter, construa um widget customizado [compondo][composing]
widgets menores (em vez de estendê-los).
É um pouco similar a implementar um controle customizado
baseado em um `Grid` com vários `VisualElement`s adicionados,
enquanto estende com lógica customizada.

Por exemplo, como você constrói um `CustomButton`
que recebe um label no construtor?
Crie um CustomButton que compõe um `ElevatedButton`
com um label, em vez de estender `ElevatedButton`:

<?code-excerpt "lib/custom_button.dart (custom-button)"?>
```dart
class CustomButton extends StatelessWidget {
  const CustomButton(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {}, child: Text(label));
  }
}
```

Então use `CustomButton`, assim como você usaria qualquer outro widget Flutter:

<?code-excerpt "lib/custom_button.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(child: CustomButton('Hello'));
}
```

## Navegação

### Como navegar entre páginas?

No Xamarin.Forms, a classe `NavigationPage`
fornece uma experiência de navegação hierárquica
onde o usuário pode navegar através de páginas,
para frente e para trás.

Flutter tem uma implementação similar,
usando um `Navigator` e `Routes`.
Uma `Route` é uma abstração para uma `Page` de um app,
e um `Navigator` é um [widget][] que gerencia rotas.

Uma rota mapeia aproximadamente para uma `Page`.
O navigator funciona de maneira similar ao `NavigationPage` do Xamarin.Forms,
na medida em que pode fazer `push()` e `pop()` de rotas dependendo de
se você quer navegar para, ou voltar de, uma view.

Para navegar entre páginas, você tem algumas opções:

* Especificar um `Map` de nomes de rotas. (`MaterialApp`)
* Navegar diretamente para uma rota. (`WidgetsApp`)

O exemplo a seguir constrói um `Map`.

<?code-excerpt "lib/navigation.dart (main)"?>
```dart
void main() {
  runApp(
    MaterialApp(
      home: const MyAppHome(), // becomes the route named '/'
      routes: <String, WidgetBuilder>{
        '/a': (context) => const MyPage(title: 'page A'),
        '/b': (context) => const MyPage(title: 'page B'),
        '/c': (context) => const MyPage(title: 'page C'),
      },
    ),
  );
}
```

Navegue para uma rota enviando seu nome para o `Navigator`.

<?code-excerpt "lib/navigation.dart (push-named)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

O `Navigator` é uma pilha que gerencia as rotas do seu app.
Empurrar uma rota para a pilha move para aquela rota.
Desempilhar uma rota da pilha, retorna para a rota anterior.
Isso é feito aguardando no `Future` retornado por `push()`.

`async`/`await` é muito similar à implementação .NET
e é explicado em mais detalhes em [Async UI][].

Por exemplo, para iniciar uma rota `location`
que permite ao usuário selecionar sua localização,
você pode fazer o seguinte:

<?code-excerpt "lib/navigation.dart (await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro da sua rota 'location', uma vez que o usuário tenha selecionado sua
localização, desempilhe a pilha com o resultado:

<?code-excerpt "lib/navigation.dart (pop-location)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

### Como navegar para outro app?

No Xamarin.Forms, para enviar o usuário para outra aplicação,
você usa um esquema URI específico, usando `Device.OpenUrl("mailto://")`.

Para implementar esta funcionalidade no Flutter,
crie uma integração de plataforma nativa, ou use um [plugin existente][existing plugin],
como [`url_launcher`][], disponível com muitos outros pacotes em [pub.dev][].

## Async UI

### Qual é o equivalente de Device.BeginOnMainThread() no Flutter?

Dart tem um modelo de execução single-threaded,
com suporte para `Isolate`s (uma forma de executar códigos Dart em outra thread),
um event loop e programação assíncrona.
A menos que você spawne um `Isolate`,
seu código Dart executa na thread principal de UI
e é dirigido por um event loop.

O modelo single-threaded do Dart não significa que você precisa executar tudo
como uma operação bloqueante que causa o congelamento da UI.
Muito parecido com Xamarin.Forms, você precisa manter a thread de UI livre.
Você usaria `async`/`await` para realizar tarefas,
onde você deve esperar pela resposta.

No Flutter, use as facilidades assíncronas que a linguagem Dart fornece,
também chamadas de `async`/`await`, para realizar trabalho assíncrono.
Isso é muito similar ao C# e deve ser muito fácil de usar
para qualquer desenvolvedor Xamarin.Forms.

Por exemplo, você pode executar código de rede sem fazer a UI travar usando
`async`/`await` e deixando Dart fazer o trabalho pesado:

<?code-excerpt "lib/data.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

Uma vez que a chamada de rede aguardada está concluída,
atualize a UI chamando `setState()`,
que aciona uma reconstrução da subárvore de widgets e atualiza os dados.

O exemplo a seguir carrega dados assincronamente
e os exibe em um `ListView`:

<?code-excerpt "lib/data.dart"?>
```dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Map<String, Object?>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final http.Response response = await http.get(dataURL);
    setState(() {
      data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
    });
  }

  Widget getRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text('Row ${data[index]['title']}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return getRow(index);
        },
      ),
    );
  }
}
```

Consulte a próxima seção para mais informações
sobre como fazer trabalho em segundo plano,
e como Flutter difere do Android.

### Como mover trabalho para uma thread de segundo plano?

Como Flutter é single threaded e executa um event loop,
você não precisa se preocupar com gerenciamento de threads
ou spawning de threads de segundo plano.
Isso é muito similar ao Xamarin.Forms.
Se você está fazendo trabalho I/O-bound, como acesso a disco ou uma chamada de rede,
então você pode usar com segurança `async`/`await` e está tudo pronto.

Se, por outro lado, você precisa fazer trabalho computacionalmente intensivo
que mantém a CPU ocupada,
você quer movê-lo para um `Isolate` para evitar bloquear o event loop,
como você manteria _qualquer_ tipo de trabalho fora da thread principal.
Isso é similar a quando você move coisas para uma thread diferente
via `Task.Run()` no Xamarin.Forms.

Para trabalho I/O-bound, declare a função como uma função `async`,
e faça `await` em tarefas de longa execução dentro da função:

<?code-excerpt "lib/data.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

Isso é como você normalmente faria chamadas de rede ou banco de dados,
que são ambas operações de I/O.

No entanto, há momentos em que você pode estar processando
uma grande quantidade de dados e sua UI trava.
No Flutter, use `Isolate`s para tirar vantagem de múltiplos núcleos de CPU
para fazer tarefas de longa execução ou computacionalmente intensivas.

Isolates são threads de execução separadas que
não compartilham nenhuma memória com o heap de memória de execução principal.
Esta é uma diferença entre `Task.Run()`.
Isso significa que você não pode acessar variáveis da thread principal,
ou atualizar sua UI chamando `setState()`.

O exemplo a seguir mostra, em um isolate simples,
como compartilhar dados de volta para a thread principal para atualizar a UI.

<?code-excerpt "lib/isolates.dart (simple-isolate)"?>
```dart
Future<void> loadData() async {
  final ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // The 'echo' isolate sends its SendPort as the first message
  final SendPort sendPort = await receivePort.first as SendPort;
  final List<Map<String, dynamic>> msg = await sendReceive(
    sendPort,
    'https://jsonplaceholder.typicode.com/posts',
  );
  setState(() {
    data = msg;
  });
}

// The entry point for the isolate
static Future<void> dataLoader(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  final ReceivePort port = ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);
  await for (final dynamic msg in port) {
    final String url = msg[0] as String;
    final SendPort replyTo = msg[1] as SendPort;

    final Uri dataURL = Uri.parse(url);
    final http.Response response = await http.get(dataURL);
    // Lots of JSON to parse
    replyTo.send(jsonDecode(response.body) as List<Map<String, dynamic>>);
  }
}

Future<List<Map<String, dynamic>>> sendReceive(SendPort port, String msg) {
  final ReceivePort response = ReceivePort();
  port.send(<dynamic>[msg, response.sendPort]);
  return response.first as Future<List<Map<String, dynamic>>>;
}
```

Aqui, `dataLoader()` é o `Isolate` que executa em
sua própria thread de execução separada.
No isolate, você pode realizar processamento mais intensivo de CPU
(fazendo parse de um JSON grande, por exemplo),
ou realizar matemática computacionalmente intensiva,
como criptografia ou processamento de sinal.

Você pode executar o exemplo completo abaixo:

<?code-excerpt "lib/isolates.dart"?>
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Map<String, Object?>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool get showLoadingDialog => data.isEmpty;

  Future<void> loadData() async {
    final ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    final SendPort sendPort = await receivePort.first as SendPort;
    final List<Map<String, dynamic>> msg = await sendReceive(
      sendPort,
      'https://jsonplaceholder.typicode.com/posts',
    );
    setState(() {
      data = msg;
    });
  }

  // The entry point for the isolate
  static Future<void> dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    final ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);
    await for (final dynamic msg in port) {
      final String url = msg[0] as String;
      final SendPort replyTo = msg[1] as SendPort;

      final Uri dataURL = Uri.parse(url);
      final http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      replyTo.send(jsonDecode(response.body) as List<Map<String, dynamic>>);
    }
  }

  Future<List<Map<String, dynamic>>> sendReceive(SendPort port, String msg) {
    final ReceivePort response = ReceivePort();
    port.send(<dynamic>[msg, response.sendPort]);
    return response.first as Future<List<Map<String, dynamic>>>;
  }

  Widget getBody() {
    if (showLoadingDialog) {
      return getProgressDialog();
    }
    return getListView();
  }

  Widget getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return getRow(index);
      },
    );
  }

  Widget getRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text('Row ${data[index]['title']}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: getBody(),
    );
  }
}
```

### Como fazer requisições de rede?

No Xamarin.Forms você usaria `HttpClient`.
Fazer uma chamada de rede no Flutter é fácil
quando você usa o popular [pacote `http`][`http` package].
Isso abstrai muito da rede
que você normalmente implementaria você mesmo,
tornando simples fazer chamadas de rede.

Para usar o pacote `http`, adicione-o às suas dependências em `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.4.0
```

Para fazer uma requisição de rede,
chame `await` na função `async` `http.get()`:

<?code-excerpt "lib/data.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

### Como mostrar o progresso para uma tarefa de longa execução?

No Xamarin.Forms você normalmente criaria um indicador de carregamento,
diretamente em XAML ou através de um plugin de terceiros como AcrDialogs.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando
quando ele é renderizado através de uma flag booleana.
Diga ao Flutter para atualizar seu estado antes de sua tarefa de longa execução começar,
e esconda-o depois que ela termina.

No exemplo abaixo, a função build é separada em três funções diferentes.
Se `showLoadingDialog` é `true`
(quando `widgets.length == 0`), então renderize o `ProgressIndicator`.
Caso contrário, renderize o `ListView` com os dados retornados de uma chamada de rede.

<?code-excerpt "lib/loading.dart"?>
```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Map<String, Object?>> data = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  bool get showLoadingDialog => data.isEmpty;

  Future<void> loadData() async {
    final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final http.Response response = await http.get(dataURL);
    setState(() {
      data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
    });
  }

  Widget getBody() {
    if (showLoadingDialog) {
      return getProgressDialog();
    }
    return getListView();
  }

  Widget getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return getRow(index);
      },
    );
  }

  Widget getRow(int index) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text('Row ${data[index]['title']}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: getBody(),
    );
  }
}
```

## Estrutura do projeto e recursos

### Onde armazeno meus arquivos de imagem?

Xamarin.Forms não tem uma maneira independente de plataforma de armazenar imagens,
você tinha que colocar imagens na pasta `xcasset` do iOS,
ou no Android nas várias pastas `drawable`.

Embora Android e iOS tratem recursos e assets como itens distintos,
apps Flutter têm apenas assets.
Todos os recursos que viveriam nas
pastas `Resources/drawable-*` no Android,
são colocados em uma pasta de assets para Flutter.

Flutter segue um formato simples baseado em densidade como iOS.
Assets podem ser `1.0x`, `2.0x`, `3.0x`, ou qualquer outro multiplicador.
Flutter não tem `dp`s, mas há pixels lógicos,
que são basicamente o mesmo que pixels independentes de dispositivo.
O [`devicePixelRatio`][] do Flutter expressa a razão
de pixels físicos em um único pixel lógico.

O equivalente aos buckets de densidade do Android são:

| Qualificador de densidade Android | Razão de pixels Flutter |
|---------------------------|---------------------|
| `ldpi`                    | `0.75x`             |
| `mdpi`                    | `1.0x`              |
| `hdpi`                    | `1.5x`              |
| `xhdpi`                   | `2.0x`              |
| `xxhdpi`                  | `3.0x`              |
| `xxxhdpi`                 | `4.0x`              |

Assets estão localizados em qualquer pasta arbitrária&mdash;
Flutter não tem estrutura de pastas predefinida.
Você declara os assets (com localização)
no arquivo `pubspec.yaml`, e o Flutter os pega.

Para adicionar um novo asset de imagem chamado `my_icon.png` ao nosso projeto Flutter,
por exemplo, e decidindo que ele deve viver em uma pasta que
arbitrariamente chamamos de `images`, você colocaria a imagem base (1.0x)
na pasta `images`, e todas as outras variantes em subpastas
chamadas com o multiplicador de razão apropriado:

```plaintext
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

Em seguida, você precisará declarar essas imagens em seu arquivo `pubspec.yaml`:

```yaml
assets:
 - images/my_icon.png
```

Você pode acessar diretamente suas imagens em um widget `Image.asset`:

<?code-excerpt "lib/images.dart (image-asset)"?>
```dart
@override
Widget build(BuildContext context) {
  return Image.asset('images/my_icon.png');
}
```

ou usando `AssetImage`:

<?code-excerpt "lib/images.dart (asset-image)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Image(image: AssetImage('images/my_image.png'));
}
```

Informações mais detalhadas podem ser encontradas em [Adicionando assets e imagens][Adding assets and images].

### Onde armazeno strings? Como lidar com localização?

Diferente do .NET que tem arquivos `resx`,
Flutter atualmente não tem um sistema dedicado para lidar com strings.
No momento, a melhor prática é declarar seu texto de cópia
em uma classe como campos estáticos e acessá-los de lá. Por exemplo:

<?code-excerpt "lib/strings.dart (strings-class)"?>
```dart
class Strings {
  static const String welcomeMessage = 'Welcome To Flutter';
}
```

Você pode acessar suas strings assim:

<?code-excerpt "lib/strings.dart (access-string)" replace="/return const //g"?>
```dart
Text(Strings.welcomeMessage);
```

Por padrão, Flutter suporta apenas inglês dos EUA para suas strings.
Se você precisar adicionar suporte para outros idiomas,
inclua o pacote `flutter_localizations`.
Você também pode precisar adicionar o pacote [`intl`][] do Dart
para usar maquinário i10n, como formatação de data/hora.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any # Use version of intl from flutter_localizations.
```

Para usar o pacote `flutter_localizations`,
especifique os `localizationsDelegates` e
`supportedLocales` no widget do app:

<?code-excerpt "lib/strings.dart (localization)"?>
```dart
import 'package:flutter_localizations/flutter_localizations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        // Add app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('en', 'US'), // English
        Locale('he', 'IL'), // Hebrew
        // ... other locales the app supports
      ],
    );
  }
}
```

Os delegates contêm os valores localizados reais,
enquanto os `supportedLocales` definem quais locales o app suporta.
O exemplo acima usa um `MaterialApp`,
então ele tem tanto um `GlobalWidgetsLocalizations`
para os valores localizados dos widgets base,
quanto um `MaterialWidgetsLocalizations` para as localizações dos widgets Material.
Se você usar `WidgetsApp` para seu app, você não precisa do último.
Note que esses dois delegates contêm valores "padrão",
mas você precisará fornecer um ou mais delegates
para a cópia localizável do seu próprio app,
se você quiser que aqueles também sejam localizados.

Quando inicializado, o `WidgetsApp` (ou `MaterialApp`)
cria um widget [`Localizations`][] para você,
com os delegates que você especifica.
O locale atual para o dispositivo está sempre acessível
do widget `Localizations` do contexto atual
(na forma de um objeto `Locale`), ou usando o [`Window.locale`][].

Para acessar recursos localizados, use o método `Localizations.of()`
para acessar uma classe de localizações específica que é fornecida por um dado delegate.
Use o pacote [`intl_translation`][] para extrair cópia traduzível
para arquivos [arb][] para tradução, e importá-los de volta para o app
para usá-los com `intl`.

Para mais detalhes sobre internacionalização e localização no Flutter,
veja o [guia de internacionalização][internationalization guide], que tem código de exemplo
com e sem o pacote `intl`.

### Onde está meu arquivo de projeto?

No Xamarin.Forms você terá um arquivo `csproj`.
O equivalente mais próximo no Flutter é pubspec.yaml,
que contém dependências de pacotes e vários detalhes do projeto.
Similar ao .NET Standard,
arquivos dentro do mesmo diretório são considerados parte do projeto.

### Qual é o equivalente do Nuget? Como adiciono dependências?

No ecossistema .NET, projetos nativos Xamarin e projetos Xamarin.Forms
tinham acesso ao Nuget e ao sistema de gerenciamento de pacotes integrado.
Apps Flutter contêm um app Android nativo, app iOS nativo e app Flutter.

No Android, você adiciona dependências adicionando ao seu script de build Gradle.
No iOS, você adiciona dependências adicionando ao seu `Podfile`.

Flutter usa o próprio sistema de build do Dart, e o gerenciador de pacotes Pub.
As ferramentas delegam a construção dos apps wrapper nativos Android e iOS
aos respectivos sistemas de build.

Em geral, use `pubspec.yaml` para declarar
dependências externas para usar no Flutter.
Um bom lugar para encontrar pacotes Flutter é em [pub.dev][].

## Ciclo de vida da aplicação

### Como escuto eventos do ciclo de vida da aplicação?

No Xamarin.Forms, você tem uma `Application`
que contém `OnStart`, `OnResume` e `OnSleep`.
No Flutter, você pode escutar eventos de ciclo de vida similares
se conectando ao observer `WidgetsBinding` e escutando
o evento de mudança `didChangeAppLifecycleState()`.

Os eventos de ciclo de vida observáveis são:

`inactive`
: A aplicação está em um estado inativo e não está recebendo entrada do usuário.
  Este evento é apenas para iOS.

`paused`
: A aplicação não está atualmente visível para o usuário,
  não está respondendo à entrada do usuário, mas está executando em segundo plano.

`resumed`
: A aplicação está visível e respondendo à entrada do usuário.

`suspending`
: A aplicação está suspensa momentaneamente.
  Este evento é apenas para Android.

Para mais detalhes sobre o significado desses estados,
veja a [documentação `AppLifecycleStatus`][`AppLifecycleStatus` documentation].

[`AppLifecycleStatus` documentation]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html

## Layouts

### Qual é o equivalente de um StackLayout?

No Xamarin.Forms você pode criar um `StackLayout`
com uma `Orientation` de horizontal ou vertical.
Flutter tem uma abordagem similar,
no entanto você usaria os widgets `Row` ou `Column`.

Se você notar que os dois exemplos de código são idênticos
exceto pelos widgets `Row` e `Column`.
Os filhos são os mesmos e este recurso
pode ser explorado para desenvolver layouts ricos
que podem mudar ao longo do tempo com os mesmos filhos.

<?code-excerpt "lib/layouts.dart (row)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('Row One'),
      Text('Row Two'),
      Text('Row Three'),
      Text('Row Four'),
    ],
  );
}
```

<?code-excerpt "lib/layouts.dart (column)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('Column One'),
      Text('Column Two'),
      Text('Column Three'),
      Text('Column Four'),
    ],
  );
```

### Qual é o equivalente de um Grid?

O equivalente mais próximo de um `Grid` seria um `GridView`.
Isso é muito mais poderoso do que você está acostumado no Xamarin.Forms.
Um `GridView` fornece scroll automático quando o
conteúdo excede seu espaço visível.

<?code-excerpt "lib/layouts.dart (grid)"?>
```dart
@override
Widget build(BuildContext context) {
  return GridView.count(
    // Create a grid with 2 columns. If you change the scrollDirection to
    // horizontal, this would produce 2 rows.
    crossAxisCount: 2,
    // Generate 100 widgets that display their index in the list.
    children: List<Widget>.generate(100, (index) {
      return Center(
        child: Text(
          'Item $index',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      );
    }),
  );
}
```

Você pode ter usado um `Grid` no Xamarin.Forms
para implementar widgets que sobrepõem outros widgets.
No Flutter, você consegue isso com o widget `Stack`.

Este exemplo cria dois ícones que se sobrepõem.

<?code-excerpt "lib/layouts.dart (stack)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Stack(
    children: <Widget>[
      Icon(Icons.add_box, size: 24, color: Colors.black),
      Positioned(
        left: 10,
        child: Icon(Icons.add_circle, size: 24, color: Colors.black),
      ),
    ],
  );
}
```

### Qual é o equivalente de um ScrollView?

No Xamarin.Forms, um `ScrollView` envolve um `VisualElement`,
e se o conteúdo for maior que a tela do dispositivo, ele rola.

No Flutter, a correspondência mais próxima é o widget `SingleChildScrollView`.
Você simplesmente preenche o Widget com o conteúdo que você quer que seja rolável.

<?code-excerpt "lib/layouts.dart (scroll-view)"?>
```dart
@override
Widget build(BuildContext context) {
  return const SingleChildScrollView(child: Text('Long Content'));
}
```

Se você tem muitos itens que você quer envolver em um scroll,
mesmo de tipos de `Widget` diferentes, você pode querer usar um `ListView`.
Isso pode parecer exagero, mas no Flutter isso é
muito mais otimizado e menos intensivo do que um `ListView` do Xamarin.Forms,
que está apoiado em controles específicos de plataforma.

<?code-excerpt "lib/layouts.dart (list-view)"?>
```dart
@override
Widget build(BuildContext context) {
  return ListView(
    children: const <Widget>[
      Text('Row One'),
      Text('Row Two'),
      Text('Row Three'),
      Text('Row Four'),
    ],
  );
}
```

### Como lidar com transições de paisagem no Flutter?

As transições de paisagem podem ser manipuladas automaticamente definindo a
propriedade `configChanges` no AndroidManifest.xml:

```xml
<activity android:configChanges="orientation|screenSize" />
```

## Detecção de gestos e manipulação de eventos de toque

### Como adiciono GestureRecognizers a um widget no Flutter?

No Xamarin.Forms, `Element`s podem conter um evento de clique ao qual você pode anexar.
Muitos elementos também contêm um `Command` que está vinculado a este evento.
Alternativamente você usaria o `TapGestureRecognizer`.
No Flutter existem duas maneiras muito similares:

1. Se o widget suporta detecção de eventos, passe uma função para ele e
   manipule-a na função. Por exemplo, o ElevatedButton tem um
   parâmetro `onPressed`:

   <?code-excerpt "lib/gestures.dart (elevated-button)"?>
   ```dart
   @override
   Widget build(BuildContext context) {
     return ElevatedButton(
       onPressed: () {
         developer.log('click');
       },
       child: const Text('Button'),
     );
   }
   ```

2. Se o widget não suporta detecção de eventos, envolva o
   widget em um `GestureDetector` e passe uma função
   para o parâmetro `onTap`.

   <?code-excerpt "lib/gestures.dart (gesture-detector)"?>
   ```dart
   class SampleApp extends StatelessWidget {
     const SampleApp({super.key});

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         body: Center(
           child: GestureDetector(
             onTap: () {
               developer.log('tap');
             },
             child: const FlutterLogo(size: 200),
           ),
         ),
       );
     }
   }
   ```

### Como lidar com outros gestos em widgets?

No Xamarin.Forms você adicionaria um `GestureRecognizer` à `View`.
Você normalmente seria limitado a `TapGestureRecognizer`,
`PinchGestureRecognizer`, `PanGestureRecognizer`, `SwipeGestureRecognizer`,
`DragGestureRecognizer` e `DropGestureRecognizer` a menos que você construísse o seu próprio.

No Flutter, usando o GestureDetector,
você pode escutar uma ampla gama de Gestos como:

* Tap

`onTapDown`
: Um ponteiro que pode causar um tap
  contatou a tela em uma localização particular.

`onTapUp`
: Um ponteiro que aciona um tap
  parou de contatar a tela em uma localização particular.

`onTap`
: Um tap ocorreu.

`onTapCancel`
: O ponteiro que anteriormente acionou o `onTapDown`
  não causará um tap.

* Double tap

`onDoubleTap`
: O usuário tocou a tela na mesma localização duas vezes
  em rápida sucessão.

* Long press

`onLongPress`
: Um ponteiro permaneceu em contato com a tela
  na mesma localização por um longo período de tempo.

* Vertical drag

`onVerticalDragStart`
: Um ponteiro contatou a tela e pode começar a se mover verticalmente.

`onVerticalDragUpdate`
: Um ponteiro em contato com a tela
  se moveu mais na direção vertical.

`onVerticalDragEnd`
: Um ponteiro que estava previamente em contato com a
  tela e se movendo verticalmente não está mais em contato
  com a tela e estava se movendo a uma velocidade específica
  quando parou de contatar a tela.

* Horizontal drag

`onHorizontalDragStart`
: Um ponteiro contatou a tela e pode começar a se mover horizontalmente.

`onHorizontalDragUpdate`
: Um ponteiro em contato com a tela
  se moveu mais na direção horizontal.

`onHorizontalDragEnd`
: Um ponteiro que estava previamente em contato com a
  tela e se movendo horizontalmente não está mais em contato
  com a tela e estava se movendo a uma velocidade específica
  quando parou de contatar a tela.

O exemplo a seguir mostra um `GestureDetector`
que rotaciona o logotipo Flutter em um double tap:

<?code-excerpt "lib/gestures.dart (rotating-flutter-detector)"?>
```dart
class RotatingFlutterDetector extends StatefulWidget {
  const RotatingFlutterDetector({super.key});

  @override
  State<RotatingFlutterDetector> createState() =>
      _RotatingFlutterDetectorState();
}

class _RotatingFlutterDetectorState extends State<RotatingFlutterDetector>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    curve = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onDoubleTap: () {
            if (controller.isCompleted) {
              controller.reverse();
            } else {
              controller.forward();
            }
          },
          child: RotationTransition(
            turns: curve,
            child: const FlutterLogo(size: 200),
          ),
        ),
      ),
    );
  }
}
```

## Listviews e adapters

### Qual é o equivalente a um ListView no Flutter?

O equivalente a um `ListView` no Flutter é … um `ListView`!

Em um `ListView` do Xamarin.Forms, você cria um `ViewCell`
e possivelmente um `DataTemplateSelector` e passa-o para o `ListView`,
que renderiza cada linha com o que seu
`DataTemplateSelector` ou `ViewCell` retorna.
No entanto, você geralmente tem que certificar-se de ativar a Reciclagem de Células
caso contrário você terá problemas de memória e velocidades de scroll lentas.

Devido ao padrão de widget imutável do Flutter,
você passa uma lista de widgets para seu `ListView`,
e o Flutter cuida de garantir que o scroll seja rápido e suave.

<?code-excerpt "lib/listview.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatelessWidget {
  const SampleAppPage({super.key});

  List<Widget> _getListData() {
    return List<Widget>.generate(
      100,
      (index) =>
          Padding(padding: const EdgeInsets.all(10), child: Text('Row $index')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: ListView(children: _getListData()),
    );
  }
}
```

### Como saber qual item da lista foi clicado?

No Xamarin.Forms, o ListView tem um método `ItemTapped`
para descobrir qual item foi clicado.
Há muitas outras técnicas que você pode ter usado
como verificar quando `SelectedItem` ou behaviors `EventToCommand`
mudam.

No Flutter, use o tratamento de toque fornecido pelos widgets passados.

<?code-excerpt "lib/listview_item_clicked.dart"?>
```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Widget> _getListData() {
    return List<Widget>.generate(
      100,
      (index) => GestureDetector(
        onTap: () {
          developer.log('Row $index tapped');
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text('Row $index'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: ListView(children: _getListData()),
    );
  }
}
```

### Como atualizo um ListView dinamicamente?

No Xamarin.Forms, se você vinculou a
propriedade `ItemsSource` a uma `ObservableCollection`,
você simplesmente atualizaria a lista em seu ViewModel.
Alternativamente, você poderia atribuir uma nova `List` à propriedade `ItemSource`.

No Flutter, as coisas funcionam um pouco diferente.
Se você atualizar a lista de widgets dentro de um método `setState()`,
você rapidamente veria que seus dados não mudariam visualmente.
Isso ocorre porque quando `setState()` é chamado,
o motor de renderização do Flutter olha para a árvore de widgets
para ver se algo mudou.
Quando ele chega ao seu `ListView`, ele executa uma verificação `==`,
e determina que os dois `ListView`s são os mesmos.
Nada mudou, então nenhuma atualização é necessária.

Para uma maneira simples de atualizar seu `ListView`,
crie uma nova `List` dentro de `setState()`,
e copie os dados da lista antiga para a nova lista.
Embora esta abordagem seja simples, ela não é recomendada para grandes conjuntos de dados,
como mostrado no próximo exemplo.

<?code-excerpt "lib/dynamic_listview.dart"?>
```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Widget> widgets = <Widget>[];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  Widget getRow(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets = List<Widget>.from(widgets);
          widgets.add(getRow(widgets.length));
          developer.log('Row $index');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $index'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: ListView(children: widgets),
    );
  }
}
```

A maneira recomendada, eficiente e eficaz de construir uma lista
usa um `ListView.Builder`.
Este método é ótimo quando você tem uma lista dinâmica
ou uma lista com quantidades muito grandes de dados.
Isso é essencialmente o equivalente a RecyclerView no Android,
que recicla automaticamente elementos da lista para você:

<?code-excerpt "lib/listview_builder.dart"?>
```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  Widget getRow(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets.add(getRow(widgets.length));
          developer.log('Row $index');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $index'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, index) {
          return getRow(index);
        },
      ),
    );
  }
}
```

Em vez de criar um `ListView`, crie um `ListView.builder`
que recebe dois parâmetros chave: o comprimento inicial da lista,
e uma função de construção de item.

A função de construção de item é similar à função `getView`
em um adapter do Android; ela recebe uma posição,
e retorna a linha que você quer renderizada naquela posição.

Finalmente, mas o mais importante, note que a função `onTap()`
não recria mais a lista, mas em vez disso adiciona a ela.

Para mais informações, veja
o codelab [Seu primeiro app Flutter][first_codelab].

## Trabalhando com texto

### Como definir fontes customizadas nos meus widgets de texto?

No Xamarin.Forms, você teria que adicionar uma fonte customizada em cada projeto nativo.
Então, em seu `Element` você atribuiria este nome de fonte
ao atributo `FontFamily` usando `filename#fontname`
e apenas `fontname` para iOS.

No Flutter, coloque o arquivo de fonte em uma pasta e referencie-o
no arquivo `pubspec.yaml`, similar a como você importa imagens.

```yaml
fonts:
  - family: MyCustomFont
    fonts:
      - asset: fonts/MyCustomFont.ttf
      - style: italic
```

Então atribua a fonte ao seu widget `Text`:

<?code-excerpt "lib/strings.dart (custom-font)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Sample App')),
    body: const Center(
      child: Text(
        'This is a custom font text',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
```

### Como estilizar meus widgets de texto?

Junto com fontes, você pode customizar outros elementos de estilo em um widget `Text`.
O parâmetro style de um widget `Text` recebe um objeto `TextStyle`,
onde você pode customizar muitos parâmetros, como:

* `color`
* `decoration`
* `decorationColor`
* `decorationStyle`
* `fontFamily`
* `fontSize`
* `fontStyle`
* `fontWeight`
* `hashCode`
* `height`
* `inherit`
* `letterSpacing`
* `textBaseline`
* `wordSpacing`

## Entrada de formulário

### Como recupero a entrada do usuário?

`element`s do Xamarin.Forms permitem que você consulte diretamente o `element`
para determinar o estado de suas propriedades,
ou se está vinculado a uma propriedade em um `ViewModel`.

Recuperar informações no Flutter é tratado por widgets especializados
e é diferente de como você está acostumado.
Se você tem um `TextField` ou um `TextFormField`,
você pode fornecer um [`TextEditingController`][]
para recuperar a entrada do usuário:

<?code-excerpt "lib/form.dart"?>
```dart
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  /// Create a text controller and use it to retrieve the current value
  /// of the TextField.
  final TextEditingController myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when disposing of the widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Retrieve Text Input')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(controller: myController),
      ),
      floatingActionButton: FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // text that the user has typed into our text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text that the user has entered using the
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
```

Você pode encontrar mais informações e a listagem de código completa em
[Recuperar o valor de um campo de texto][Retrieve the value of a text field].

### Qual é o equivalente de um Placeholder em uma Entry?

No Xamarin.Forms, alguns `Elements` suportam uma propriedade `Placeholder`
à qual você pode atribuir um valor. Por exemplo:

```xml
<Entry Placeholder="This is a hint">
```

No Flutter, você pode facilmente mostrar um "hint" ou um texto placeholder
para sua entrada adicionando um objeto `InputDecoration`
ao parâmetro construtor `decoration` para o widget de texto.

<?code-excerpt "lib/input_decoration.dart (hint-text)" replace="/child: //g"?>
```dart
TextField(decoration: InputDecoration(hintText: 'This is a hint')),
```

### Como mostro erros de validação?

Com Xamarin.Forms, se você desejasse fornecer uma dica visual de um
erro de validação, você precisaria criar novas propriedades e
`VisualElement`s em torno dos `Element`s que tinham erros de validação.

No Flutter, você passa através de um objeto InputDecoration para o
construtor decoration para o widget de texto.

No entanto, você não quer começar mostrando um erro.
Em vez disso, quando o usuário tiver inserido dados inválidos,
atualize o estado e passe um novo objeto `InputDecoration`.

<?code-excerpt "lib/validation.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Sample App', home: SampleAppPage());
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  String? _errorText;

  String? _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    const String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
        r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
        r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    final RegExp regExp = RegExp(emailRegexp);
    return regExp.hasMatch(em);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: Center(
        child: TextField(
          onSubmitted: (text) {
            setState(() {
              if (!isEmail(text)) {
                _errorText = 'Error: This is not an email';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'This is a hint',
            errorText: _getErrorText(),
          ),
        ),
      ),
    );
  }
}
```

## Plugins Flutter

## Interagindo com hardware, serviços de terceiros e a plataforma

### Como interajo com a plataforma e com código nativo da plataforma?

Flutter não executa código diretamente na plataforma subjacente;
em vez disso, o código Dart que compõe um app Flutter é executado nativamente
no dispositivo, "contornando" o SDK fornecido pela plataforma.
Isso significa, por exemplo, quando você executa uma requisição de rede em Dart,
ela é executada diretamente no contexto Dart.
Você não usa as APIs Android ou iOS
que você normalmente aproveita ao escrever apps nativos.
Seu app Flutter ainda está hospedado em um
`ViewController` ou `Activity` de um app nativo como uma view,
mas você não tem acesso direto a isso, ou ao framework nativo.

Isso não significa que apps Flutter não podem interagir com aquelas APIs nativas,
ou com qualquer código nativo que você tenha. Flutter fornece [canais de plataforma][platform channels]
que se comunicam e trocam dados com o
`ViewController` ou `Activity` que hospeda sua view Flutter.
Canais de plataforma são essencialmente um mecanismo de mensagens assíncrono
que faz a ponte do código Dart com o `ViewController`
ou `Activity` host e o framework iOS ou Android em que ele é executado.
Você pode usar canais de plataforma para executar um método no lado nativo,
ou para recuperar alguns dados dos sensores do dispositivo, por exemplo.

Além de usar diretamente canais de plataforma,
você pode usar uma variedade de [plugins][] pré-fabricados
que encapsulam o código nativo e Dart para um objetivo específico.
Por exemplo, você pode usar um plugin para acessar
o rolo de câmera e a câmera do dispositivo diretamente do Flutter,
sem ter que escrever sua própria integração.
Plugins são encontrados em [pub.dev][],
repositório de pacotes de código aberto Dart e Flutter.
Alguns pacotes podem suportar integrações nativas no iOS,
ou Android, ou ambos.

Se você não conseguir encontrar um plugin em pub.dev que atenda às suas necessidades,
você pode [escrever o seu próprio][write your own] e [publicá-lo em pub.dev][publish it on pub.dev].

### Como acesso o sensor GPS?

Use o plugin da comunidade [`geolocator`][].

### Como acesso a câmera?

O plugin [`camera`][] é popular para acessar a câmera.

### Como faço login com Facebook?

Para fazer login com Facebook, use o
plugin da comunidade [`flutter_facebook_login`][].

### Como uso recursos do Firebase?

A maioria das funções do Firebase são cobertas por [plugins de primeira parte][first party plugins].
Estes plugins são integrações de primeira parte, mantidas pela equipe Flutter:

 * [`google_mobile_ads`][] para Google Mobile Ads para Flutter
 * [`firebase_analytics`][] para Firebase Analytics
 * [`firebase_auth`][] para Firebase Auth
 * [`firebase_database`][] para Firebase RTDB
 * [`firebase_storage`][] para Firebase Cloud Storage
 * [`firebase_messaging`][] para Firebase Messaging (FCM)
 * [`flutter_firebase_ui`][] para integrações rápidas de Firebase Auth
   (Facebook, Google, Twitter e email)
 * [`cloud_firestore`][] para Firebase Cloud Firestore

Você também pode encontrar alguns plugins Firebase de terceiros em pub.dev
que cobrem áreas não cobertas diretamente pelos plugins de primeira parte.

### Como construo minhas próprias integrações nativas customizadas?

Se houver funcionalidade específica de plataforma que o Flutter
ou seus plugins da comunidade estão faltando,
você pode construir sua própria seguindo a
página [desenvolvendo pacotes e plugins][developing packages and plugins].

A arquitetura de plugin do Flutter, resumidamente,
é muito parecida com usar um Event bus no Android:
você dispara uma mensagem e deixa o receptor processar e emitir um resultado
de volta para você. Neste caso, o receptor é código executando no lado nativo
no Android ou iOS.

## Themes (Estilos)

### Como eu tematizo meu app?

Flutter vem com uma bela implementação integrada de Material Design,
que lida com muitas das necessidades de estilo e tematização
que você normalmente faria.

Xamarin.Forms tem um `ResourceDictionary` global
onde você pode compartilhar estilos em todo o seu app.
Alternativamente, há suporte a Theme atualmente em preview.

No Flutter, você declara temas no widget de nível superior.

Para tirar total vantagem dos Material Components em seu app,
você pode declarar um widget de nível superior `MaterialApp`
como o ponto de entrada para sua aplicação.
`MaterialApp` é um widget de conveniência
que envolve vários widgets que são comumente requeridos
para aplicações implementando Material Design.
Ele constrói sobre um `WidgetsApp` adicionando funcionalidade específica de Material.

Você também pode usar um `WidgetsApp` como seu widget de app,
que fornece algumas das mesmas funcionalidades,
mas não é tão rico quanto `MaterialApp`.

Para customizar as cores e estilos de quaisquer componentes filhos,
passe um objeto `ThemeData` para o widget `MaterialApp`.
Por exemplo, no código a seguir,
o esquema de cores da seed é definido como deepPurple e a cor de seleção de texto é vermelho.

<?code-excerpt "lib/theme.dart (theme)"?>
```dart
class SampleApp extends StatelessWidget {
  /// This widget is the root of your application.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.red,
        ),
      ),
      home: const SampleAppPage(),
    );
  }
}
```

## Bancos de dados e armazenamento local

### Como acesso shared preferences ou UserDefaults?

Desenvolvedores Xamarin.Forms provavelmente estarão familiarizados com o
plugin `Xam.Plugins.Settings`.

No Flutter, acesse funcionalidade equivalente usando o
plugin [`shared_preferences`][]. Este plugin envolve a
funcionalidade de ambos `UserDefaults` e o
equivalente do Android, `SharedPreferences`.

### Como acesso SQLite no Flutter?

No Xamarin.Forms a maioria das aplicações usaria o plugin `sqlite-net-pcl`
para acessar bancos de dados SQLite.

No Flutter, no macOS, Android e iOS,
acesse esta funcionalidade usando o
plugin [`sqflite`][].

## Depuração

### Quais ferramentas posso usar para depurar meu app no Flutter?

Use o conjunto [DevTools][] para depurar apps Flutter ou Dart.

DevTools inclui suporte para perfilamento, examinando o heap,
inspecionando a árvore de widgets, registrando diagnósticos, depurando,
observando linhas de código executadas,
depurando vazamentos de memória e fragmentação de memória.
Para mais informações, confira a documentação [DevTools][].

## Notificações

### Como configuro push notifications?

No Android, você usa Firebase Cloud Messaging para configurar
push notifications para seu app.

No Flutter, acesse esta funcionalidade usando o
plugin [`firebase_messaging`][].
Para mais informações sobre como usar a API Firebase Cloud Messaging, veja a
documentação do plugin [`firebase_messaging`][].


[Adding assets and images]: /ui/assets/assets-and-images
[Animation & Motion widgets]: /ui/widgets/animation
[Animations overview]: /ui/animations
[Animations tutorial]: /ui/animations/tutorial
[Apple's iOS design language]: {{site.apple-dev}}/design/resources/
[arb]: {{site.github}}/google/app-resource-bundle
[Async UI]: #async-ui
[`cloud_firestore`]: {{site.pub}}/packages/cloud_firestore
[composing]: /resources/architectural-overview#composition
[Cupertino widgets]: /ui/widgets/cupertino
[`devicePixelRatio`]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[developing packages and plugins]: /packages-and-plugins/developing-packages
[DevTools]: /tools/devtools
[existing plugin]: {{site.pub}}/flutter
[`google_mobile_ads`]: {{site.pub}}/packages/google_mobile_ads
[`firebase_analytics`]: {{site.pub}}/packages/firebase_analytics
[`firebase_auth`]: {{site.pub}}/packages/firebase_auth
[`firebase_database`]: {{site.pub}}/packages/firebase_database
[`firebase_messaging`]: {{site.pub}}/packages/firebase_messaging
[`firebase_storage`]: {{site.pub}}/packages/firebase_storage
[first party plugins]: {{site.pub}}/flutter/packages?q=firebase
[`flutter_facebook_login`]: {{site.pub}}/packages/flutter_facebook_login
[`flutter_firebase_ui`]: {{site.pub}}/packages/flutter_firebase_ui
[`geolocator`]: {{site.pub}}/packages/geolocator
[`camera`]: {{site.pub-pkg}}/camera
[`http` package]: {{site.pub}}/packages/http
[internationalization guide]: /ui/internationalization
[`intl`]: {{site.pub}}/packages/intl
[`intl_translation`]: {{site.pub}}/packages/intl_translation
[Introduction to declarative UI]: /get-started/flutter-for/declarative
[`Localizations`]: {{site.api}}/flutter/widgets/Localizations-class.html
[Material Components]: /ui/widgets/material
[Material Design]: {{site.material}}/styles
[Material Design guidelines]: {{site.material}}/styles
[`Opacity` widget]: {{site.api}}/flutter/widgets/Opacity-class.html
[optimized for all platforms]: {{site.material2}}/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines
[platform channels]: /platform-integration/platform-channels
[plugins]: /packages-and-plugins/using-packages
[pub.dev]: {{site.pub}}
[publish it on pub.dev]: /packages-and-plugins/developing-packages#publish
[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[`shared_preferences`]: {{site.pub}}/packages/shared_preferences
[`sqflite`]: {{site.pub}}/packages/sqflite
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`url_launcher`]: {{site.pub}}/packages/url_launcher
[widget]: /resources/architectural-overview#widgets
[widget catalog]: /ui/widgets/layout
[`Window.locale`]: {{site.api}}/flutter/dart-ui/Window/locale.html
[first_codelab]: {{site.codelabs}}/codelabs/flutter-codelab-first
[write your own]: /packages-and-plugins/developing-packages
