---
ia-translate: true
title: Flutter para desenvolvedores Xamarin.Forms
description: Aprenda como aplicar conhecimento de desenvolvedor Xamarin.Forms ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/xamarin_devs"?>

Este documento é destinado para desenvolvedores Xamarin.Forms
que buscam aplicar seu conhecimento existente
para construir apps móveis com Flutter.
Se você entende os fundamentos do framework Xamarin.Forms,
então você pode usar este documento como um ponto de partida para o desenvolvimento Flutter.

Seu conhecimento e conjunto de habilidades Android e iOS
são valiosos ao construir com Flutter,
porque o Flutter depende das configurações nativas do sistema operacional,
similar a como você configuraria seus projetos nativos Xamarin.Forms.
O Flutter Frameworks também é similar a como você cria uma única UI,
que é usada em múltiplas plataformas.

Este documento pode ser usado como um livro de receitas pulando
e encontrando questões que são mais relevantes para suas necessidades.

## Configuração de projeto

### Como o app inicia?

Para cada plataforma no Xamarin.Forms,
você chama o método `LoadApplication`,
que cria uma nova aplicação e inicia seu app.

```csharp
LoadApplication(new App());
```

No Flutter, o ponto de entrada principal padrão é
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

No Flutter, "tudo é um widget", até a aplicação em si.
O exemplo a seguir mostra `MyApp`, um `Widget` de aplicação simples.

<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  /// This widget is the root of your application.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Hello World!',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
```

### Como você cria uma página?

Xamarin.Forms tem muitos tipos de páginas;
`ContentPage` é a mais comum.
No Flutter, você especifica um widget de aplicação que contém sua página raiz.
Você pode usar um widget [`MaterialApp`][], que suporta [Material Design][],
ou você pode usar um widget [`CupertinoApp`][], que suporta um app estilo iOS,
ou você pode usar o [`WidgetsApp`][] de nível mais baixo,
que você pode personalizar da maneira que quiser.

[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html

O código a seguir define a página inicial, um widget stateful.
No Flutter, todos os widgets são imutáveis,
mas dois tipos de widgets são suportados: _Stateful_ e _Stateless_.
Exemplos de um widget stateless são títulos, ícones ou imagens.

O exemplo a seguir usa `MaterialApp`,
que contém sua página raiz na propriedade `home`.

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

Um widget _Stateful_, como o `MyHomePage` abaixo, consiste de duas partes.
A primeira parte, que é ela mesma imutável, cria um objeto `State`
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

O objeto `State` implementa o método `build()` para o widget stateful.

Quando o estado da árvore de widgets muda, chame `setState()`,
que dispara uma reconstrução daquela porção da UI.
Certifique-se de chamar `setState()` apenas quando necessário,
e apenas na parte da árvore de widgets que mudou,
ou isso pode resultar em desempenho de UI ruim.

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
            const Text(
              'You have pushed the button this many times:',
            ),
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
significando que você não pode mudar seu estado uma vez que é construída.
Você muda campos na sua classe `State`, então chama `setState()`
para reconstruir toda a árvore de widgets novamente.

Esta forma de gerar UI é diferente do Xamarin.Forms,
mas existem muitos benefícios para esta abordagem.

## Views

### Qual é o equivalente de uma Page ou Element no Flutter?

:::secondary
Como a programação estilo-react, ou _declarativa_, é diferente do
estilo imperativo tradicional?
Para uma comparação, veja [Introdução à UI declarativa][Introduction to declarative UI].
:::

`ContentPage`, `TabbedPage`, `FlyoutPage` são todos tipos de páginas
que você pode usar em uma aplicação Xamarin.Forms.
Estas páginas então contêm `Element`s para exibir os vários controles.
No Xamarin.Forms um `Entry` ou `Button` são exemplos de um `Element`.

No Flutter, quase tudo é um widget.
Uma `Page`, chamada de `Route` no Flutter, é um widget.
Botões, barras de progresso, e controladores de animação são todos widgets.
Ao construir uma route, você cria uma árvore de widgets.

O Flutter inclui a biblioteca [Material Components][].
Estes são widgets que implementam as [diretrizes do Material Design][Material Design guidelines].
Material Design é um sistema de design flexível
[otimizado para todas as plataformas][optimized for all platforms], incluindo iOS.

Mas o Flutter é flexível e expressivo o suficiente
para implementar qualquer linguagem de design.
Por exemplo, no iOS, você pode usar os [widgets Cupertino][Cupertino widgets]
para produzir uma interface que parece com a [linguagem de design iOS da Apple][Apple's iOS design language].

### Como eu atualizo widgets?

No Xamarin.Forms, cada `Page` ou `Element` é uma classe stateful,
que tem propriedades e métodos.
Você atualiza seu `Element` atualizando uma propriedade,
e isso é propagado para o controle nativo.

No Flutter, `Widget`s são imutáveis e você não pode atualizá-los diretamente
mudando uma propriedade, ao invés disso você tem que trabalhar com o estado do widget.

É aqui que o conceito de widgets Stateful vs Stateless vem.
Um `StatelessWidget` é exatamente o que parece&mdash;
um widget sem informação de estado.

`StatelessWidgets` são úteis quando a parte da interface de usuário
que você está descrevendo não depende de nada
além da informação de configuração no objeto.

Por exemplo, no Xamarin.Forms, isso é similar
a colocar uma `Image` com seu logo.
O logo não vai mudar durante a execução,
então use um `StatelessWidget` no Flutter.

Se você quer mudar dinamicamente a UI baseado em dados recebidos
após fazer uma chamada HTTP ou uma interação do usuário,
então você tem que trabalhar com `StatefulWidget`
e dizer ao framework Flutter que
o `State` do widget foi atualizado,
então ele pode atualizar aquele widget.

A coisa importante a notar aqui é que no núcleo
ambos widgets stateless e stateful se comportam da mesma forma.
Eles reconstruem a cada frame, a diferença é
que o `StatefulWidget` tem um objeto `State`
que armazena dados de estado entre frames e os restaura.

Se você está em dúvida, então sempre lembre desta regra: se um widget muda
(por causa de interações do usuário, por exemplo) ele é stateful.
Entretanto, se um widget reage à mudança, o widget pai que o contém pode
ainda ser stateless se ele próprio não reage à mudança.

O exemplo a seguir mostra como usar um `StatelessWidget`.
Um `StatelessWidget` comum é o widget `Text`.
Se você olhar a implementação do widget `Text`
você verá que ele faz subclasse de `StatelessWidget`.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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

### Como eu faço o layout dos meus widgets? Qual é o equivalente de um arquivo XAML?

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

### Como eu adiciono ou removo um Element do meu layout?

No Xamarin.Forms, você tinha que remover ou adicionar um `Element` em código.
Isso envolvia configurar a propriedade `Content` ou chamar
`Add()` ou `Remove()` se fosse uma lista.

No Flutter, como widgets são imutáveis não existe equivalente direto.
Ao invés disso, você pode passar uma função para o pai que retorna um widget,
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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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
    return CupertinoButton(
      onPressed: () {},
      child: const Text('Toggle Two'),
    );
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

### Como eu animo um widget?

No Xamarin.Forms, você cria animações simples usando ViewExtensions que
incluem métodos como `FadeTo` e `TranslateTo`.
Você usaria esses métodos em uma view
para executar as animações necessárias.

```xml
<Image Source="{Binding MyImage}" x:Name="myImage" />
```

Então em code behind, ou um behavior, isso faria o fade in da imagem,
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
em cada frame enquanto está rodando.
Você então cria uma ou mais `Animation`s e as anexa ao controller.

Por exemplo, você pode usar `CurvedAnimation`
para implementar uma animação ao longo de uma curva interpolada.
Neste sentido, o controller é a fonte "mestre" do progresso da animação
e a `CurvedAnimation` computa a curva
que substitui o movimento linear padrão do controller.
Como widgets, animações no Flutter trabalham com composição.

Ao construir a árvore de widgets, você atribui a `Animation`
a uma propriedade animada de um widget,
como a opacidade de um `FadeTransition`,
e diz ao controller para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que faz fade
do widget para um logo quando você pressiona o `FloatingActionButton`:

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
    curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
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

Para mais informações, veja [widgets de Animação & Movimento][Animation & Motion widgets],
o [tutorial de Animações][Animations tutorial], e a [visão geral de Animações][Animations overview].

### Como eu desenho/pinto na tela?

O Xamarin.Forms nunca teve uma forma built-in de desenhar diretamente na tela.
Muitos usariam SkiaSharp, se precisassem de uma imagem customizada desenhada.
No Flutter, você tem acesso direto ao Skia Canvas
e pode facilmente desenhar na tela.

O Flutter tem duas classes que ajudam você a desenhar no canvas: `CustomPaint`
e `CustomPainter`, sendo que o último implementa seu algoritmo para desenhar no
canvas.

Para aprender como implementar um signature painter no Flutter,
veja a resposta do Collin em [Custom Paint][].

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

### Como eu construo widgets customizados?

No Xamarin.Forms, você tipicamente faz subclasse de `VisualElement`,
ou usa um `VisualElement` pré-existente, para sobrescrever e
implementar métodos que alcançam o comportamento desejado.

No Flutter, construa um widget customizado [compondo][composing]
widgets menores (ao invés de estendê-los).
É de certa forma similar a implementar um controle customizado
baseado em um `Grid` com numerosos `VisualElement`s adicionados,
enquanto estende com lógica customizada.

Por exemplo, como você constrói um `CustomButton`
que recebe um label no construtor?
Crie um CustomButton que compõe um `ElevatedButton`
com um label, ao invés de estender `ElevatedButton`:

<?code-excerpt "lib/custom_button.dart (custom-button)"?>
```dart
class CustomButton extends StatelessWidget {
  const CustomButton(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      child: Text(label),
    );
  }
}
```

Então use `CustomButton`, assim como você usaria qualquer outro widget Flutter:

<?code-excerpt "lib/custom_button.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(
    child: CustomButton('Hello'),
  );
}
```

## Navegação

### Como eu navego entre páginas?

No Xamarin.Forms, a classe `NavigationPage`
fornece uma experiência de navegação hierárquica
onde o usuário é capaz de navegar através de páginas,
para frente e para trás.

O Flutter tem uma implementação similar,
usando um `Navigator` e `Routes`.
Uma `Route` é uma abstração para uma `Page` de um app,
e um `Navigator` é um [widget][] que gerencia routes.

Uma route mapeia aproximadamente para uma `Page`.
O navigator funciona de forma similar ao `NavigationPage` do Xamarin.Forms,
no sentido de que ele pode dar `push()` e `pop()` em routes dependendo de
se você quer navegar para, ou voltar de, uma view.

Para navegar entre páginas, você tem algumas opções:

* Especificar um `Map` de nomes de route. (`MaterialApp`)
* Navegar diretamente para uma route. (`WidgetsApp`)

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

Navegue para uma route empurrando seu nome para o `Navigator`.

<?code-excerpt "lib/navigation.dart (push-named)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

O `Navigator` é uma pilha que gerencia as routes do seu app.
Empurrar uma route para a pilha move para aquela route.
Retirar uma route da pilha, retorna para a route anterior.
Isso é feito aguardando o `Future` retornado por `push()`.

`async`/`await` é muito similar à implementação .NET
e é explicado em mais detalhes em [Async UI][].

Por exemplo, para iniciar uma route `location`
que deixa o usuário selecionar sua localização,
você poderia fazer o seguinte:

<?code-excerpt "lib/navigation.dart (await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro da sua route 'location', uma vez que o usuário tenha selecionado sua
localização, retire da pilha com o resultado:

<?code-excerpt "lib/navigation.dart (pop-location)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

### Como eu navego para outro app?

No Xamarin.Forms, para enviar o usuário para outra aplicação,
você usa um esquema de URI específico, usando `Device.OpenUrl("mailto://")`.

Para implementar esta funcionalidade no Flutter,
crie uma integração de plataforma nativa, ou use um [plugin existente][existing plugin],
como o [`url_launcher`][], disponível com muitos outros packages em [pub.dev][].

## Async UI

### Qual é o equivalente de Device.BeginOnMainThread() no Flutter?

O Dart tem um modelo de execução single-threaded,
com suporte para `Isolate`s (uma forma de executar código Dart em outra thread),
um event loop, e programação assíncrona.
A menos que você spawne um `Isolate`,
seu código Dart roda na thread principal da UI
e é dirigido por um event loop.

O modelo single-threaded do Dart não significa que você precisa executar tudo
como uma operação bloqueante que causa o congelamento da UI.
Assim como no Xamarin.Forms, você precisa manter a thread da UI livre.
Você usaria `async`/`await` para executar tarefas,
onde você deve esperar pela resposta.

No Flutter, use as facilidades assíncronas que a linguagem Dart fornece,
também chamadas `async`/`await`, para executar trabalho assíncrono.
Isso é muito similar ao C# e deve ser muito fácil de usar
para qualquer desenvolvedor Xamarin.Forms.

Por exemplo, você pode executar código de rede sem causar travamento na UI
usando `async`/`await` e deixando o Dart fazer o trabalho pesado:

<?code-excerpt "lib/data.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

Uma vez que a chamada de rede aguardada está completa,
atualize a UI chamando `setState()`,
que dispara uma reconstrução da subárvore de widgets e atualiza os dados.

O exemplo a seguir carrega dados assincronamente
e os exibe em uma `ListView`:

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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
    final Uri dataURL = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts',
    );
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
sobre fazer trabalho em background,
e como o Flutter difere do Android.

### Como você move trabalho para uma thread de background?

Como o Flutter é single threaded e executa um event loop,
você não precisa se preocupar com gerenciamento de threads
ou spawnar threads de background.
Isso é muito similar ao Xamarin.Forms.
Se você está fazendo trabalho I/O-bound, como acesso a disco ou uma chamada de rede,
então você pode usar `async`/`await` com segurança e está tudo pronto.

Se, por outro lado, você precisa fazer trabalho computacionalmente intensivo
que mantém a CPU ocupada,
você quer movê-lo para um `Isolate` para evitar bloquear o event loop,
como você manteria _qualquer_ tipo de trabalho fora da thread principal.
Isso é similar a quando você move coisas para uma thread diferente
via `Task.Run()` no Xamarin.Forms.

Para trabalho I/O-bound, declare a função como uma função `async`,
e `await` em tarefas de longa duração dentro da função:

<?code-excerpt "lib/data.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

É assim que você tipicamente faria chamadas de rede ou banco de dados,
que são ambas operações I/O.

Entretanto, há momentos em que você pode estar processando
uma grande quantidade de dados e sua UI trava.
No Flutter, use `Isolate`s para tirar vantagem de múltiplos núcleos de CPU
para fazer tarefas de longa duração ou computacionalmente intensivas.

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

Aqui, `dataLoader()` é o `Isolate` que roda em
sua própria thread de execução separada.
No isolate, você pode executar processamento
mais intensivo de CPU (parsear um JSON grande, por exemplo),
ou executar matemática computacionalmente intensiva,
como criptografia ou processamento de sinais.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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

### Como eu faço requisições de rede?

No Xamarin.Forms você usaria `HttpClient`.
Fazer uma chamada de rede no Flutter é fácil
quando você usa o popular [package `http`][`http` package].
Isso abstrai muito do networking
que você normalmente implementaria você mesmo,
tornando simples fazer chamadas de rede.

Para usar o package `http`, adicione-o às suas dependências em `pubspec.yaml`:

```yaml
dependencies:
  http: ^1.1.0
```

Para fazer uma requisição de rede,
chame `await` na função `async` `http.get()`:

<?code-excerpt "lib/data.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse(
    'https://jsonplaceholder.typicode.com/posts',
  );
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

### Como eu mostro o progresso para uma tarefa de longa duração?

No Xamarin.Forms você tipicamente criaria um indicador de carregamento,
seja diretamente em XAML ou através de um plugin de 3ª parte como AcrDialogs.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando
quando ele é renderizado através de uma flag booleana.
Diga ao Flutter para atualizar seu estado antes que sua tarefa de longa duração inicie,
e esconda-o depois que terminar.

No exemplo abaixo, a função build é separada em três funções diferentes.
Se `showLoadingDialog` é `true`
(quando `widgets.length == 0`), então renderize o `ProgressIndicator`.
Caso contrário, renderize a `ListView` com os dados retornados de uma chamada de rede.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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
    final Uri dataURL = Uri.parse(
      'https://jsonplaceholder.typicode.com/posts',
    );
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

## Estrutura de projeto & recursos

### Onde eu armazeno meus arquivos de imagem?

O Xamarin.Forms não tem uma forma independente de plataforma de armazenar imagens,
você tinha que colocar imagens na pasta `xcasset` do iOS,
ou no Android nas várias pastas `drawable`.

Enquanto Android e iOS tratam recursos e assets como itens distintos,
apps Flutter têm apenas assets.
Todos os recursos que viveriam nas
pastas `Resources/drawable-*` no Android,
são colocados em uma pasta de assets para o Flutter.

O Flutter segue um formato simples baseado em densidade como o iOS.
Assets podem ser `1.0x`, `2.0x`, `3.0x`, ou qualquer outro multiplicador.
O Flutter não tem `dp`s mas há pixels lógicos,
que são basicamente o mesmo que pixels independentes de dispositivo.
O [`devicePixelRatio`][] do Flutter expressa a razão
de pixels físicos em um único pixel lógico.

O equivalente aos buckets de densidade do Android são:

| Qualificador de densidade Android | Razão de pixel Flutter |
|------------------------------------|------------------------|
| `ldpi`                             | `0.75x`                |
| `mdpi`                             | `1.0x`                 |
| `hdpi`                             | `1.5x`                 |
| `xhdpi`                            | `2.0x`                 |
| `xxhdpi`                           | `3.0x`                 |
| `xxxhdpi`                          | `4.0x`                 |

Assets estão localizados em qualquer pasta arbitrária&mdash;
o Flutter não tem estrutura de pasta predefinida.
Você declara os assets (com localização)
no arquivo `pubspec.yaml`, e o Flutter os pega.

Para adicionar um novo asset de imagem chamado `my_icon.png` ao nosso projeto Flutter,
por exemplo, e decidindo que ele deve viver em uma pasta que
arbitrariamente chamamos de `images`, você colocaria a imagem base (1.0x)
na pasta `images`, e todas as outras variantes em sub-pastas
chamadas com o multiplicador de razão apropriado:

```plaintext
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

A seguir, você precisará declarar estas imagens no seu arquivo `pubspec.yaml`:

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
  return const Image(
    image: AssetImage('images/my_image.png'),
  );
}
```

Informações mais detalhadas podem ser encontradas em [Adicionando assets e imagens][Adding assets and images].

### Onde eu armazeno strings? Como eu lido com localização?

Diferente do .NET que tem arquivos `resx`,
o Flutter atualmente não tem um sistema dedicado para lidar com strings.
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

Por padrão, o Flutter apenas suporta Inglês Americano para suas strings.
Se você precisa adicionar suporte para outros idiomas,
inclua o package `flutter_localizations`.
Você também pode precisar adicionar o package [`intl`][] do Dart
para usar maquinaria i10n, como formatação de data/hora.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any # Use version of intl from flutter_localizations.
```

Para usar o package `flutter_localizations`,
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
se você quiser que esses sejam localizados também.

Quando inicializado, o `WidgetsApp` (ou `MaterialApp`)
cria um widget [`Localizations`][] para você,
com os delegates que você especificar.
O locale atual para o dispositivo é sempre acessível
do widget `Localizations` do contexto atual
(na forma de um objeto `Locale`), ou usando o [`Window.locale`][].

Para acessar recursos localizados, use o método `Localizations.of()`
para acessar uma classe de localizações específica que é fornecida por um dado delegate.
Use o package [`intl_translation`][] para extrair cópia traduzível
para arquivos [arb][] para traduzir, e importá-los de volta para o app
para usá-los com `intl`.

Para mais detalhes sobre internacionalização e localização no Flutter,
veja o [guia de internacionalização][internationalization guide], que tem código de exemplo
com e sem o package `intl`.

### Onde está meu arquivo de projeto?

No Xamarin.Forms você terá um arquivo `csproj`.
O equivalente mais próximo no Flutter é pubspec.yaml,
que contém dependências de package e vários detalhes do projeto.
Similar ao .NET Standard,
arquivos dentro do mesmo diretório são considerados parte do projeto.

### Qual é o equivalente do Nuget? Como eu adiciono dependências?

No ecossistema .NET, projetos Xamarin nativos e projetos Xamarin.Forms
tinham acesso ao Nuget e ao sistema de gerenciamento de packages built-in.
Apps Flutter contêm um app Android nativo, app iOS nativo e app Flutter.

No Android, você adiciona dependências adicionando ao seu script de build Gradle.
No iOS, você adiciona dependências adicionando ao seu `Podfile`.

O Flutter usa o próprio sistema de build do Dart, e o gerenciador de packages Pub.
As ferramentas delegam a construção dos apps wrapper Android e iOS nativos
para os respectivos sistemas de build.

Em geral, use `pubspec.yaml` para declarar
dependências externas para usar no Flutter.
Um bom lugar para encontrar packages Flutter é em [pub.dev][].

## Ciclo de vida da aplicação

### Como eu escuto eventos de ciclo de vida da aplicação?

No Xamarin.Forms, você tem uma `Application`
que contém `OnStart`, `OnResume` e `OnSleep`.
No Flutter, você pode ao invés disso escutar eventos de ciclo de vida similares
conectando-se ao observer do `WidgetsBinding` e escutando o
evento de mudança `didChangeAppLifecycleState()`.

Os eventos de ciclo de vida observáveis são:

`inactive`
: A aplicação está em um estado inativo e não está recebendo entrada do usuário.
  Este evento é apenas para iOS.

`paused`
: A aplicação não está atualmente visível para o usuário,
  não está respondendo à entrada do usuário, mas está rodando em background.

`resumed`
: A aplicação está visível e respondendo à entrada do usuário.

`suspending`
: A aplicação está suspensa momentaneamente.
  Este evento é apenas para Android.

Para mais detalhes sobre o significado desses estados,
veja a [documentação do `AppLifecycleStatus`][`AppLifecycleStatus` documentation].

[`AppLifecycleStatus` documentation]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html

## Layouts

### Qual é o equivalente de um StackLayout?

No Xamarin.Forms você pode criar um `StackLayout`
com uma `Orientation` de horizontal ou vertical.
O Flutter tem uma abordagem similar,
porém você usaria os widgets `Row` ou `Column`.

Se você notar, as duas amostras de código são idênticas
exceto pelo widget `Row` e `Column`.
Os filhos são os mesmos e este recurso
pode ser explorado para desenvolver layouts ricos
que podem mudar com o tempo com os mesmos filhos.

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
Um `GridView` fornece rolagem automática quando o
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
    children: List<Widget>.generate(
      100,
      (index) {
        return Center(
          child: Text(
            'Item $index',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        );
      },
    ),
  );
}
```

You might have used a `Grid` in Xamarin.Forms
to implement widgets that overlay other widgets.
In Flutter, you accomplish this with the `Stack` widget.

This sample creates two icons that overlap each other.

<?code-excerpt "lib/layouts.dart (stack)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Stack(
    children: <Widget>[
      Icon(
        Icons.add_box,
        size: 24,
        color: Colors.black,
      ),
      Positioned(
        left: 10,
        child: Icon(
          Icons.add_circle,
          size: 24,
          color: Colors.black,
        ),
      ),
    ],
  );
}
```

### What is the equivalent of a ScrollView?

In Xamarin.Forms, a `ScrollView` wraps around a `VisualElement`,
and if the content is larger than the device screen, it scrolls.

In Flutter, the closest match is the `SingleChildScrollView` widget.
You simply fill the Widget with the content that you want to be scrollable.

<?code-excerpt "lib/layouts.dart (scroll-view)"?>
```dart
@override
Widget build(BuildContext context) {
  return const SingleChildScrollView(
    child: Text('Long Content'),
  );
}
```

If you have many items you want to wrap in a scroll,
even of different `Widget` types, you might want to use a `ListView`.
This might seem like overkill, but in Flutter this is
far more optimized and less intensive than a Xamarin.Forms `ListView`,
which is backing on to platform specific controls.

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

### How do I handle landscape transitions in Flutter?

Landscape transitions can be handled automatically by setting the
`configChanges` property in the AndroidManifest.xml:

```xml
<activity android:configChanges="orientation|screenSize" />
```

## Gesture detection and touch event handling

### How do I add GestureRecognizers to a widget in Flutter?

In Xamarin.Forms, `Element`s might contain a click event you can attach to.
Many elements also contain a `Command` that is tied to this event.
Alternatively you would use the `TapGestureRecognizer`.
In Flutter there are two very similar ways:

1. If the widget supports event detection, pass a function to it and
   handle it in the function. For example, the ElevatedButton has an
   `onPressed` parameter:

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

2. If the widget doesn't support event detection, wrap the
   widget in a `GestureDetector` and pass a function
   to the `onTap` parameter.

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

### How do I handle other gestures on widgets?

In Xamarin.Forms you would add a `GestureRecognizer` to the `View`.
You would normally be limited to `TapGestureRecognizer`,
`PinchGestureRecognizer`, `PanGestureRecognizer`, `SwipeGestureRecognizer`,
`DragGestureRecognizer` and `DropGestureRecognizer` unless you built your own.

In Flutter, using the GestureDetector,
you can listen to a wide range of Gestures such as:

* Tap

`onTapDown`
: A pointer that might cause a tap
  has contacted the screen at a particular location.

`onTapUp`
: A pointer that triggers a tap
  has stopped contacting the screen at a particular location.

`onTap`
: A tap has occurred.

`onTapCancel`
: The pointer that previously triggered the `onTapDown`
  won't cause a tap.

* Double tap

`onDoubleTap`
: The user tapped the screen at the same location twice
  in quick succession.

* Long press

`onLongPress`
: A pointer has remained in contact with the screen
  at the same location for a long period of time.

* Vertical drag

`onVerticalDragStart`
: A pointer has contacted the screen and might begin to move vertically.

`onVerticalDragUpdate`
: A pointer in contact with the screen
  has moved further in the vertical direction.

`onVerticalDragEnd`
: A pointer that was previously in contact with the
  screen and moving vertically is no longer in contact
  with the screen and was moving at a specific velocity
  when it stopped contacting the screen.

* Horizontal drag

`onHorizontalDragStart`
: A pointer has contacted the screen and might begin to move horizontally.

`onHorizontalDragUpdate`
: A pointer in contact with the screen
  has moved further in the horizontal direction.

`onHorizontalDragEnd`
: A pointer that was previously in contact with the
  screen and moving horizontally is no longer in contact
  with the screen and was moving at a specific velocity
  when it stopped contacting the screen.

The following example shows a `GestureDetector`
that rotates the Flutter logo on a double tap:

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

## Listviews and adapters

### What is the equivalent to a ListView in Flutter?

The equivalent to a `ListView` in Flutter is … a `ListView`!

In a Xamarin.Forms `ListView`, you create a `ViewCell`
and possibly a `DataTemplateSelector`and pass it into the `ListView`,
which renders each row with what your
`DataTemplateSelector` or `ViewCell` returns.
However, you often have to make sure you turn on Cell Recycling
otherwise you will run into memory issues and slow scrolling speeds.

Due to Flutter's immutable widget pattern,
you pass a list of widgets to your `ListView`,
and Flutter takes care of making sure that scrolling is fast and smooth.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatelessWidget {
  const SampleAppPage({super.key});

  List<Widget> _getListData() {
    return List<Widget>.generate(
      100,
      (index) => Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $index'),
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

### How do I know which list item has been clicked?

In Xamarin.Forms, the ListView has an `ItemTapped` method
to find out which item was clicked.
There are many other techniques you might have used
such as checking when `SelectedItem` or `EventToCommand`
behaviors change.

In Flutter, use the touch handling provided by the passed-in widgets.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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

### How do I update a ListView dynamically?

In Xamarin.Forms, if you bound the
`ItemsSource` property to an `ObservableCollection`,
you would just update the list in your ViewModel.
Alternatively, you could assign a new `List` to the `ItemSource` property.

In Flutter, things work a little differently.
If you update the list of widgets inside a `setState()` method,
you would quickly see that your data did not change visually.
This is because when `setState()` is called,
the Flutter rendering engine looks at the widget tree
to see if anything has changed.
When it gets to your `ListView`, it performs a `==` check,
and determines that the two `ListView`s are the same.
Nothing has changed, so no update is required.

For a simple way to update your `ListView`,
create a new `List` inside of `setState()`,
and copy the data from the old list to the new list.
While this approach is simple, it is not recommended for large data sets,
as shown in the next example.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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

The recommended, efficient, and effective way to build a list
uses a `ListView.Builder`.
This method is great when you have a dynamic list
or a list with very large amounts of data.
This is essentially the equivalent of RecyclerView on Android,
which automatically recycles list elements for you:

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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

Instead of creating a `ListView`, create a `ListView.builder`
that takes two key parameters: the initial length of the list,
and an item builder function.

The item builder function is similar to the `getView` function
in an Android adapter; it takes a position,
and returns the row you want rendered at that position.

Finally, but most importantly, notice that the `onTap()` function
doesn't recreate the list anymore, but instead adds to it.

For more information, see
[Your first Flutter app][first_codelab] codelab.

## Working with text

### How do I set custom fonts on my text widgets?

In Xamarin.Forms, you would have to add a custom font in each native project.
Then, in your `Element` you would assign this font name
to the `FontFamily` attribute using `filename#fontname`
and just `fontname` for iOS.

In Flutter, place the font file in a folder and reference it
in the `pubspec.yaml` file, similar to how you import images.

```yaml
fonts:
  - family: MyCustomFont
    fonts:
      - asset: fonts/MyCustomFont.ttf
      - style: italic
```

Then assign the font to your `Text` widget:

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

### How do I style my text widgets?

Along with fonts, you can customize other styling elements on a `Text` widget.
The style parameter of a `Text` widget takes a `TextStyle` object,
where you can customize many parameters, such as:

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

## Form input

### How do I retrieve user input?

Xamarin.Forms `element`s allow you to directly query the `element`
to determine the state of its properties,
or whether it's bound to a property in a `ViewModel`.

Retrieving information in Flutter is handled by specialized widgets
and is different from how you are used to.
If you have a `TextField`or a `TextFormField`,
you can supply a [`TextEditingController`][]
to retrieve user input:

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

You can find more information and the full code listing in
[Retrieve the value of a text field][],
from the [Flutter cookbook][].

### What is the equivalent of a Placeholder on an Entry?

In Xamarin.Forms, some `Elements` support a `Placeholder` property
that you can assign a value to. For example:

```xml
<Entry Placeholder="This is a hint">
```

In Flutter, you can easily show a "hint" or a placeholder text
for your input by adding an `InputDecoration` object
to the `decoration` constructor parameter for the text widget.

<?code-excerpt "lib/input_decoration.dart (hint-text)" replace="/child: //g"?>
```dart
TextField(
  decoration: InputDecoration(hintText: 'This is a hint'),
),
```

### How do I show validation errors?

With Xamarin.Forms, if you wished to provide a visual hint of a
validation error, you would need to create new properties and
`VisualElement`s surrounding the `Element`s that had validation errors.

In Flutter, you pass through an InputDecoration object to the
decoration constructor for the text widget.

However, you don't want to start off by showing an error.
Instead, when the user has entered invalid data,
update the state, and pass a new `InputDecoration` object.

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
    return const MaterialApp(
      title: 'Sample App',
      home: SampleAppPage(),
    );
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

## Flutter plugins

## Interacting with hardware, third party services, and the platform

### How do I interact with the platform, and with platform native code?

Flutter doesn't run code directly on the underlying platform;
rather, the Dart code that makes up a Flutter app is run natively
on the device, "sidestepping" the SDK provided by the platform.
That means, for example, when you perform a network request in Dart,
it runs directly in the Dart context.
You don't use the Android or iOS APIs
you normally take advantage of when writing native apps.
Your Flutter app is still hosted in a native app's
`ViewController` or `Activity` as a view,
but you don't have direct access to this, or the native framework.

This doesn't mean Flutter apps can't interact with those native APIs,
or with any native code you have. Flutter provides [platform channels][]
that communicate and exchange data with the
`ViewController` or `Activity` that hosts your Flutter view.
Platform channels are essentially an asynchronous messaging mechanism
that bridges the Dart code with the host `ViewController`
or `Activity` and the iOS or Android framework it runs on.
You can use platform channels to execute a method on the native side,
or to retrieve some data from the device's sensors, for example.

In addition to directly using platform channels,
you can use a variety of pre-made [plugins][]
that encapsulate the native and Dart code for a specific goal.
For example, you can use a plugin to access
the camera roll and the device camera directly from Flutter,
without having to write your own integration.
Plugins are found on [pub.dev][],
Dart and Flutter's open source package repository.
Some packages might support native integrations on iOS,
or Android, or both.

If you can't find a plugin on pub.dev that fits your needs,
you can [write your own][], and [publish it on pub.dev][].

### How do I access the GPS sensor?

Use the [`geolocator`][] community plugin.

### How do I access the camera?

The [`camera`][] plugin is popular for accessing the camera.

### How do I log in with Facebook?

To log in with Facebook, use the
[`flutter_facebook_login`][] community plugin.

### How do I use Firebase features?

Most Firebase functions are covered by [first party plugins][].
These plugins are first-party integrations, maintained by the Flutter team:

 * [`google_mobile_ads`][] for Google Mobile Ads for Flutter
 * [`firebase_analytics`][] for Firebase Analytics
 * [`firebase_auth`][] for Firebase Auth
 * [`firebase_database`][] for Firebase RTDB
 * [`firebase_storage`][] for Firebase Cloud Storage
 * [`firebase_messaging`][] for Firebase Messaging (FCM)
 * [`flutter_firebase_ui`][] for quick Firebase Auth integrations
   (Facebook, Google, Twitter and email)
 * [`cloud_firestore`][] for Firebase Cloud Firestore

You can also find some third-party Firebase plugins on pub.dev
that cover areas not directly covered by the first-party plugins.

### How do I build my own custom native integrations?

If there is platform-specific functionality that Flutter
or its community plugins are missing,
you can build your own following the
[developing packages and plugins][] page.

Flutter's plugin architecture, in a nutshell,
is much like using an Event bus in Android:
you fire off a message and let the receiver process and emit a result
back to you. In this case, the receiver is code running on the native side
on Android or iOS.

## Themes (Styles)

### How do I theme my app?

Flutter comes with a beautiful, built-in implementation of Material Design,
which handles much of the styling and theming needs
that you would typically do.

Xamarin.Forms does have a global `ResourceDictionary`
where you can share styles across your app.
Alternatively, there is Theme support currently in preview.

In Flutter, you declare themes in the top level widget.

To take full advantage of Material Components in your app,
you can declare a top level widget `MaterialApp`
as the entry point to your application.
`MaterialApp` is a convenience widget
that wraps a number of widgets that are commonly required
for applications implementing Material Design.
It builds upon a `WidgetsApp` by adding Material-specific functionality.

You can also use a `WidgetsApp` as your app widget,
which provides some of the same functionality,
but is not as rich as `MaterialApp`.

To customize the colors and styles of any child components,
pass a `ThemeData` object to the `MaterialApp` widget.
For example, in the following code,
the color scheme from seed is set to deepPurple and text selection color is red.

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
        textSelectionTheme:
            const TextSelectionThemeData(selectionColor: Colors.red),
      ),
      home: const SampleAppPage(),
    );
  }
}
```

## Databases and local storage

### How do I access shared preferences or UserDefaults?

Xamarin.Forms developers will likely be familiar with the
`Xam.Plugins.Settings` plugin.

In Flutter, access equivalent functionality using the
[`shared_preferences`][] plugin. This plugin wraps the
functionality of both `UserDefaults` and the Android
equivalent, `SharedPreferences`.

### How do I access SQLite in Flutter?

In Xamarin.Forms most applications would use the `sqlite-net-pcl`
plugin to access SQLite databases.

In Flutter, on macOS, Android, and iOS,
access this functionality using the
[`sqflite`][] plugin.

## Debugging

### What tools can I use to debug my app in Flutter?

Use the [DevTools][] suite for debugging Flutter or Dart apps.

DevTools includes support for profiling, examining the heap,
inspecting the widget tree, logging diagnostics, debugging,
observing executed lines of code,
debugging memory leaks and memory fragmentation.
For more information, check out the [DevTools][] documentation.

## Notifications

### How do I set up push notifications?

In Android, you use Firebase Cloud Messaging to set up
push notifications for your app.

In Flutter, access this functionality using the
[`firebase_messaging`][] plugin.
For more information on using the Firebase Cloud Messaging API, see the
[`firebase_messaging`][] plugin documentation.


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
[Flutter cookbook]: /cookbook
[`flutter_facebook_login`]: {{site.pub}}/packages/flutter_facebook_login
[`flutter_firebase_ui`]: {{site.pub}}/packages/flutter_firebase_ui
[`geolocator`]: {{site.pub}}/packages/geolocator
[`camera`]: {{site.pub-pkg}}/camera
[`http` package]: {{site.pub}}/packages/http
[internationalization guide]: /ui/accessibility-and-internationalization/internationalization
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
