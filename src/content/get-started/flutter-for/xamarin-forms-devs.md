---
ia-translate: true
title: Flutter para desenvolvedores Xamarin.Forms
description: Aprenda como aplicar o conhecimento de desenvolvedor Xamarin.Forms ao criar aplicativos Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/xamarin_devs"?>

Este documento é destinado a desenvolvedores Xamarin.Forms que buscam aplicar seus conhecimentos existentes para criar aplicativos móveis com Flutter. Se você entende os fundamentos do framework Xamarin.Forms, você pode usar este documento como um pontapé inicial para o desenvolvimento em Flutter.

Seu conhecimento e habilidades em Android e iOS são valiosos ao construir com Flutter, porque o Flutter depende das configurações nativas do sistema operacional, semelhante a como você configuraria seus projetos nativos Xamarin.Forms. O framework Flutter também é semelhante à forma como você cria uma única UI, que é usada em várias plataformas.

Este documento pode ser usado como um livro de receitas, saltando entre as seções e encontrando as perguntas mais relevantes para suas necessidades.

## Configuração do Projeto

### Como o aplicativo é iniciado?

Para cada plataforma no Xamarin.Forms, você chama o método `LoadApplication`, que cria um novo aplicativo e inicia seu app.

```csharp
LoadApplication(new App());
```

Em Flutter, o ponto de entrada principal padrão é `main`, onde você carrega seu aplicativo Flutter.

<?code-excerpt "lib/main.dart (main)"?>
```dart
void main() {
  runApp(const MyApp());
}
```

No Xamarin.Forms, você atribui uma `Page` à propriedade `MainPage` na classe `Application`.

```csharp
public class App : Application
{
    public App()
    {
        MainPage = new ContentPage
        {
            Content = new Label
            {
                Text = "Olá Mundo",
                HorizontalOptions = LayoutOptions.Center,
                VerticalOptions = LayoutOptions.Center
            }
        };
    }
}
```

Em Flutter, "tudo é um widget", até mesmo o próprio aplicativo. O exemplo a seguir mostra `MyApp`, um `Widget` de aplicativo simples.

<?code-excerpt "lib/main.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Olá Mundo!',
        textDirection: TextDirection.ltr,
      ),
    );
  }
}
```

### Como você cria uma página?

Xamarin.Forms tem muitos tipos de páginas; `ContentPage` é a mais comum. Em Flutter, você especifica um widget de aplicativo que contém sua página raiz. Você pode usar um widget [`MaterialApp`][], que suporta o [Material Design][], ou pode usar um widget [`CupertinoApp`][], que suporta um aplicativo no estilo iOS, ou pode usar o [`WidgetsApp`][] de nível inferior, que você pode personalizar da maneira que quiser.

[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`WidgetsApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html

O código a seguir define a página inicial, um widget _stateful_. No Flutter, todos os widgets são imutáveis, mas dois tipos de widgets são suportados: _Stateful_ e _Stateless_. Exemplos de um widget stateless são títulos, ícones ou imagens.

O exemplo a seguir usa `MaterialApp`, que mantém sua página raiz na propriedade `home`.

<?code-excerpt "lib/page.dart (my-app)"?>
```dart
class MyApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Página Inicial do Flutter Demo'),
    );
  }
}
```

A partir daqui, sua primeira página real é outro `Widget`, no qual você cria seu estado.

Um widget _Stateful_, como `MyHomePage` abaixo, consiste em duas partes. A primeira parte, que é imutável, cria um objeto `State` que mantém o estado do objeto. O objeto `State` persiste durante a vida útil do widget.

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

Quando o estado da árvore de widgets muda, chame `setState()`, que aciona a construção dessa parte da UI. Certifique-se de chamar `setState()` apenas quando necessário e apenas na parte da árvore de widgets que foi alterada, ou pode resultar em baixo desempenho da UI.

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
        // Obtém o valor do objeto MyHomePage que foi criado pelo
        // método App.build e usa-o para definir o título da appbar.
        title: Text(widget.title),
      ),
      body: Center(
        // Center é um widget de layout. Ele pega um único filho e o posiciona
        // no meio do pai.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Você pressionou o botão estas vezes:',
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
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

Em Flutter, a UI (também conhecida como árvore de widgets), é imutável, o que significa que você não pode mudar seu estado uma vez que ela é construída. Você altera os campos em sua classe `State` e, em seguida, chama `setState()` para reconstruir toda a árvore de widgets novamente.

Essa forma de gerar UI é diferente do Xamarin.Forms, mas há muitos benefícios nessa abordagem.

## Views

### Qual é o equivalente de uma Página ou Elemento em Flutter?

:::secondary
Como a programação no estilo react, ou _declarativa_, é diferente do estilo imperativo tradicional? Para uma comparação, veja [Introdução à UI declarativa][].
:::

`ContentPage`, `TabbedPage`, `FlyoutPage` são todos os tipos de páginas que você pode usar em um aplicativo Xamarin.Forms. Essas páginas então conteriam `Element`s para exibir os vários controles. No Xamarin.Forms, um `Entry` ou `Button` são exemplos de um `Element`.

Em Flutter, quase tudo é um widget. Uma `Page`, chamada de `Route` em Flutter, é um widget. Botões, barras de progresso e controladores de animação são todos widgets. Ao construir uma rota, você cria uma árvore de widgets.

O Flutter inclui a biblioteca [Componentes Material][]. Estes são widgets que implementam as [diretrizes do Material Design][]. O Material Design é um sistema de design flexível [otimizado para todas as plataformas][], incluindo iOS.

Mas o Flutter é flexível e expressivo o suficiente para implementar qualquer linguagem de design. Por exemplo, no iOS, você pode usar os [widgets Cupertino][] para produzir uma interface semelhante à [linguagem de design iOS da Apple][].

### Como faço para atualizar widgets?

No Xamarin.Forms, cada `Page` ou `Element` é uma classe _stateful_, que possui propriedades e métodos. Você atualiza seu `Element` atualizando uma propriedade e isso é propagado para o controle nativo.

Em Flutter, os `Widget`s são imutáveis ​​e você não pode atualizá-los diretamente alterando uma propriedade, em vez disso, você tem que trabalhar com o estado do widget.

É daí que vem o conceito de widgets _Stateful_ vs _Stateless_. Um `StatelessWidget` é exatamente o que parece — um widget sem informações de estado.

`StatelessWidgets` são úteis quando a parte da interface do usuário que você está descrevendo não depende de nada além das informações de configuração no objeto.

Por exemplo, no Xamarin.Forms, isso é semelhante a colocar uma `Image` com seu logotipo. O logotipo não vai mudar durante o tempo de execução, então use um `StatelessWidget` em Flutter.

Se você quiser alterar dinamicamente a UI com base nos dados recebidos após fazer uma chamada HTTP ou uma interação do usuário, você terá que trabalhar com `StatefulWidget` e informar ao framework Flutter que o `State` do widget foi atualizado, para que possa atualizar esse widget.

O importante a observar aqui é que, no núcleo, widgets stateless e stateful se comportam da mesma forma. Eles são reconstruídos a cada quadro, a diferença é que o `StatefulWidget` tem um objeto `State` que armazena dados de estado entre os quadros e os restaura.

Se você estiver em dúvida, lembre-se sempre desta regra: se um widget muda (por causa das interações do usuário, por exemplo), ele é stateful. No entanto, se um widget reage à mudança, o widget pai contendo ainda pode ser stateless se ele próprio não reage à mudança.

O exemplo a seguir mostra como usar um `StatelessWidget`. Um `StatelessWidget` comum é o widget `Text`. Se você olhar a implementação do widget `Text`, você descobrirá que ele é uma subclasse de `StatelessWidget`.

<?code-excerpt "lib/views.dart (text)" replace="/return //g"?>
```dart
const Text(
  'Eu gosto do Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Como você pode ver, o widget `Text` não tem informações de estado associadas a ele, ele renderiza o que é passado em seus construtores e nada mais.

Mas, e se você quiser fazer com que "Eu gosto do Flutter" mude dinamicamente, por exemplo, ao clicar em um `FloatingActionButton`?

Para conseguir isso, encapsule o widget `Text` em um `StatefulWidget` e atualize-o quando o usuário clicar no botão, conforme mostrado no exemplo a seguir:

<?code-excerpt "lib/views_stateful.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Aplicativo de Exemplo',
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
  /// Texto de espaço reservado padrão
  String textToShow = 'Eu gosto do Flutter';

  void _updateText() {
    setState(() {
      // Atualiza o texto
      textToShow = 'Flutter é incrível!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicativo de Exemplo')),
      body: Center(child: Text(textToShow)),
      floatingActionButton: FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Atualizar Texto',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

### Como faço para apresentar meus widgets? Qual é o equivalente de um arquivo XAML?

No Xamarin.Forms, a maioria dos desenvolvedores escreve layouts em XAML, embora às vezes em C#. Em Flutter, você escreve seus layouts com uma árvore de widgets em código.

O exemplo a seguir mostra como exibir um widget simples com preenchimento:

<?code-excerpt "lib/padding.dart (padding)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Aplicativo de Exemplo')),
    body: Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.only(left: 20, right: 30),
        ),
        onPressed: () {},
        child: const Text('Olá'),
      ),
    ),
  );
}
```

Você pode ver os layouts que o Flutter tem a oferecer no [catálogo de widgets][].

### Como faço para adicionar ou remover um Elemento do meu layout?

No Xamarin.Forms, você tinha que remover ou adicionar um `Element` em código. Isso envolvia definir a propriedade `Content` ou chamar `Add()` ou `Remove()` se fosse uma lista.

Em Flutter, como os widgets são imutáveis, não há equivalente direto. Em vez disso, você pode passar uma função para o pai que retorna um widget e controlar a criação desse filho com uma flag booleana.

O exemplo a seguir mostra como alternar entre dois widgets quando o usuário clica no `FloatingActionButton`:

<?code-excerpt "lib/views.dart (add-remove-element)"?>
```dart
class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Aplicativo de Exemplo',
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
  /// Valor padrão para alternar
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  Widget _getToggleChild() {
    if (toggle) {
      return const Text('Alternar Um');
    }
    return CupertinoButton(
      onPressed: () {},
      child: const Text('Alternar Dois'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicativo de Exemplo')),
      body: Center(child: _getToggleChild()),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Atualizar Texto',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

### Como faço para animar um widget?

No Xamarin.Forms, você cria animações simples usando ViewExtensions que incluem métodos como `FadeTo` e `TranslateTo`. Você usaria esses métodos em uma view para executar as animações necessárias.

```xml
<Image Source="{Binding MyImage}" x:Name="myImage" />
```

Então, no código por trás ou em um behavior, isso faria o fade in da imagem, durante um período de 1 segundo.

```csharp
myImage.FadeTo(0, 1000);
```

Em Flutter, você anima widgets usando a biblioteca de animação, encapsulando widgets dentro de um widget animado. Use um `AnimationController`, que é um `Animation<double>` que pode pausar, procurar, parar e reverter a animação. Ele requer um `Ticker` que sinaliza quando o vsync acontece e produz uma interpolação linear entre 0 e 1 em cada quadro enquanto está em execução. Em seguida, você cria uma ou mais `Animation`s e as anexa ao controlador.

Por exemplo, você pode usar `CurvedAnimation` para implementar uma animação ao longo de uma curva interpolada. Nesse sentido, o controlador é a fonte "mestra" do progresso da animação e o `CurvedAnimation` calcula a curva que substitui o movimento linear padrão do controlador. Como os widgets, as animações no Flutter funcionam com composição.

Ao construir a árvore de widgets, você atribui a `Animation` a uma propriedade animada de um widget, como a opacidade de um `FadeTransition`, e diz ao controlador para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que faz o fade do widget em um logotipo quando você pressiona o `FloatingActionButton`:

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
  const FadeAppTest({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Demonstração de Fade',
      home: MyFadeTest(title: 'Demonstração de Fade'),
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

Para mais informações, veja [Widgets de Animação & Movimento][], o [tutorial de Animações][], e a [visão geral de Animações][].

### Como faço para desenhar/pintar na tela?

Xamarin.Forms nunca teve uma maneira integrada de desenhar diretamente na tela. Muitos usariam SkiaSharp, se precisassem de uma imagem personalizada desenhada. Em Flutter, você tem acesso direto ao Skia Canvas e pode desenhar facilmente na tela.

Flutter tem duas classes que ajudam você a desenhar na canvas: `CustomPaint` e `CustomPainter`, o último dos quais implementa seu algoritmo para desenhar na canvas.

Para aprender como implementar um painter de assinatura em Flutter, veja a resposta de Collin em [Custom Paint][].

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

No Xamarin.Forms, todos os `VisualElement`s têm uma Opacidade. Em Flutter, você precisa encapsular um widget em um [`widget Opacity`][] para conseguir isso.

### Como faço para construir widgets personalizados?

No Xamarin.Forms, você normalmente cria uma subclasse de `VisualElement` ou usa um `VisualElement` pré-existente para substituir e implementar métodos que alcançam o comportamento desejado.

Em Flutter, crie um widget personalizado por meio de [composição][] de widgets menores (em vez de estendê-los). É um tanto semelhante à implementação de um controle personalizado com base em um `Grid` com vários `VisualElement`s adicionados, enquanto se estende com lógica personalizada.

Por exemplo, como você cria um `CustomButton` que recebe um rótulo no construtor? Crie um `CustomButton` que compõe um `ElevatedButton` com um rótulo, em vez de estender `ElevatedButton`:

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
    child: CustomButton('Olá'),
  );
}
```

## Navegação

### Como faço para navegar entre as páginas?

No Xamarin.Forms, a classe `NavigationPage` fornece uma experiência de navegação hierárquica onde o usuário pode navegar pelas páginas, para frente e para trás.

Flutter tem uma implementação semelhante, usando um `Navigator` e `Routes`. Uma `Route` é uma abstração para uma `Page` de um aplicativo, e um `Navigator` é um [widget][] que gerencia rotas.

Uma rota mapeia aproximadamente para uma `Page`. O navegador funciona de forma semelhante ao `NavigationPage` do Xamarin.Forms, pois pode `push()` e `pop()` rotas, dependendo se você deseja navegar para, ou voltar de, uma view.

Para navegar entre páginas, você tem algumas opções:

* Especificar um `Map` de nomes de rotas. (`MaterialApp`)
* Navegar diretamente para uma rota. (`WidgetsApp`)

O exemplo a seguir constrói um `Map`.

<?code-excerpt "lib/navigation.dart (main)"?>
```dart
void main() {
  runApp(
    MaterialApp(
      home: const MyAppHome(), // se torna a rota nomeada '/'
      routes: <String, WidgetBuilder>{
        '/a': (context) => const MyPage(title: 'página A'),
        '/b': (context) => const MyPage(title: 'página B'),
        '/c': (context) => const MyPage(title: 'página C'),
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

O `Navigator` é uma pilha que gerencia as rotas do seu aplicativo. Empurrar uma rota para a pilha move para essa rota. Retirar uma rota da pilha, retorna à rota anterior. Isso é feito aguardando o `Future` retornado por `push()`.

`async`/`await` é muito semelhante à implementação .NET e é explicado com mais detalhes em [Async UI][].

Por exemplo, para iniciar uma rota `location` que permite ao usuário selecionar sua localização, você pode fazer o seguinte:

<?code-excerpt "lib/navigation.dart (await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro de sua rota 'location', uma vez que o usuário selecionou sua localização, retire a pilha com o resultado:

<?code-excerpt "lib/navigation.dart (pop-location)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

### Como faço para navegar para outro aplicativo?

No Xamarin.Forms, para enviar o usuário para outro aplicativo, você usa um esquema de URI específico, usando `Device.OpenUrl("mailto://")`.

Para implementar esta funcionalidade em Flutter, crie uma integração de plataforma nativa ou use um [plugin existente][], como [`url_launcher`][], disponível com muitos outros pacotes no [pub.dev][].

## UI Assíncrona

### Qual é o equivalente de Device.BeginOnMainThread() no Flutter?

Dart tem um modelo de execução de thread único, com suporte para `Isolate`s (uma maneira de executar códigos Dart em outro thread), um loop de eventos e programação assíncrona. A menos que você gere um `Isolate`, seu código Dart é executado no thread principal da UI e é acionado por um loop de eventos.

O modelo de thread único do Dart não significa que você precisa executar tudo como uma operação de bloqueio que faz com que a UI congele. Assim como o Xamarin.Forms, você precisa manter o thread da UI livre. Você usaria `async`/`await` para realizar tarefas, onde você deve esperar pela resposta.

Em Flutter, use as facilidades assíncronas que a linguagem Dart fornece, também denominadas `async`/`await`, para realizar trabalho assíncrono. Isso é muito semelhante ao C# e deve ser muito fácil de usar para qualquer desenvolvedor Xamarin.Forms.

Por exemplo, você pode executar o código de rede sem fazer com que a UI trave, usando `async`/`await` e deixando o Dart fazer o trabalho pesado:

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

Assim que a chamada de rede aguardada for concluída, atualize a UI chamando `setState()`, o que aciona uma reconstrução da subárvore de widgets e atualiza os dados.

O exemplo a seguir carrega dados de forma assíncrona e os exibe em uma `ListView`:

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
      title: 'Aplicativo de Exemplo',
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
      child: Text('Linha ${data[index]['title']}'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aplicativo de Exemplo')),
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

Consulte a próxima seção para obter mais informações sobre como trabalhar em segundo plano e como o Flutter difere do Android.
### Como você move o trabalho para uma thread em segundo plano?

Como o Flutter é de thread única e executa um loop de eventos,
você não precisa se preocupar com o gerenciamento de threads
ou com a geração de threads em segundo plano.
Isso é muito semelhante ao Xamarin.Forms.
Se você estiver fazendo um trabalho vinculado a E/S, como acesso a disco ou uma chamada de rede,
você pode usar `async`/`await` com segurança e está tudo certo.

Se, por outro lado, você precisar fazer um trabalho computacionalmente intensivo
que mantenha a CPU ocupada,
você vai querer movê-lo para um `Isolate` para evitar bloquear o loop de eventos,
como você manteria _qualquer_ tipo de trabalho fora da thread principal.
Isso é semelhante a quando você move as coisas para uma thread diferente
por meio de `Task.Run()` no Xamarin.Forms.

Para trabalhos vinculados a E/S, declare a função como uma função `async`,
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

É assim que você normalmente faria chamadas de rede ou de banco de dados,
que são ambas operações de E/S.

No entanto, há momentos em que você pode estar processando
uma grande quantidade de dados e sua UI trava.
No Flutter, use `Isolate`s para aproveitar vários núcleos de CPU
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

  // O isolate 'echo' envia seu SendPort como a primeira mensagem
  final SendPort sendPort = await receivePort.first as SendPort;
  final List<Map<String, dynamic>> msg = await sendReceive(
    sendPort,
    'https://jsonplaceholder.typicode.com/posts',
  );
  setState(() {
    data = msg;
  });
}

// O ponto de entrada para o isolate
static Future<void> dataLoader(SendPort sendPort) async {
  // Abre o ReceivePort para mensagens recebidas.
  final ReceivePort port = ReceivePort();

  // Notifica qualquer outro isolate para qual porta este isolate está escutando.
  sendPort.send(port.sendPort);
  await for (final dynamic msg in port) {
    final String url = msg[0] as String;
    final SendPort replyTo = msg[1] as SendPort;

    final Uri dataURL = Uri.parse(url);
    final http.Response response = await http.get(dataURL);
    // Muitos JSONs para analisar
    replyTo.send(jsonDecode(response.body) as List<Map<String, dynamic>>);
  }
}

Future<List<Map<String, dynamic>>> sendReceive(SendPort port, String msg) {
  final ReceivePort response = ReceivePort();
  port.send(<dynamic>[msg, response.sendPort]);
  return response.first as Future<List<Map<String, dynamic>>>;
}
```

Aqui, `dataLoader()` é o `Isolate` que é executado em
sua própria thread de execução separada.
No isolate, você pode executar um processamento mais intensivo de CPU
(analisar um JSON grande, por exemplo),
ou executar cálculos matemáticos computacionalmente intensivos,
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

    // O isolate 'echo' envia seu SendPort como a primeira mensagem
    final SendPort sendPort = await receivePort.first as SendPort;
    final List<Map<String, dynamic>> msg = await sendReceive(
      sendPort,
      'https://jsonplaceholder.typicode.com/posts',
    );
    setState(() {
      data = msg;
    });
  }

  // O ponto de entrada para o isolate
  static Future<void> dataLoader(SendPort sendPort) async {
    // Abre o ReceivePort para mensagens recebidas.
    final ReceivePort port = ReceivePort();

    // Notifica qualquer outro isolate para qual porta este isolate está escutando.
    sendPort.send(port.sendPort);
    await for (final dynamic msg in port) {
      final String url = msg[0] as String;
      final SendPort replyTo = msg[1] as SendPort;

      final Uri dataURL = Uri.parse(url);
      final http.Response response = await http.get(dataURL);
      // Muitos JSONs para analisar
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
      child: Text('Linha ${data[index]['title']}'),
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

### Como faço requisições de rede?

No Xamarin.Forms, você usaria o `HttpClient`.
Fazer uma chamada de rede no Flutter é fácil
quando você usa o popular [`http` package][].
Isso abstrai muito do trabalho de rede
que você normalmente implementaria sozinho,
tornando simples fazer chamadas de rede.

Para usar o pacote `http`, adicione-o às suas dependências em `pubspec.yaml`:

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

### Como mostro o progresso de uma tarefa de longa duração?

No Xamarin.Forms, você normalmente criaria um indicador de carregamento,
diretamente em XAML ou por meio de um plugin de terceiros, como AcrDialogs.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando
quando ele é renderizado por meio de um flag booleano.
Diga ao Flutter para atualizar seu estado antes que sua tarefa de longa duração comece,
e o oculte depois que ela terminar.

No exemplo abaixo, a função de construção é separada em três funções diferentes.
Se `showLoadingDialog` for `true`
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
      child: Text('Linha ${data[index]['title']}'),
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

## Estrutura e recursos do projeto

### Onde armazeno meus arquivos de imagem?

O Xamarin.Forms não tem uma maneira independente de plataforma de armazenar imagens,
você tinha que colocar as imagens na pasta `xcasset` do iOS,
ou no Android nas várias pastas `drawable`.

Enquanto Android e iOS tratam recursos e ativos como itens distintos,
os aplicativos Flutter têm apenas ativos.
Todos os recursos que estariam nas
pastas `Resources/drawable-*` no Android,
são colocados em uma pasta de ativos para o Flutter.

O Flutter segue um formato simples baseado em densidade como o iOS.
Os ativos podem ser `1.0x`, `2.0x`, `3.0x` ou qualquer outro multiplicador.
O Flutter não tem `dp`s, mas existem pixels lógicos,
que são basicamente os mesmos que pixels independentes de dispositivo.
O [`devicePixelRatio`][] do Flutter expressa a razão
de pixels físicos em um único pixel lógico.

O equivalente aos buckets de densidade do Android são:

| Qualificador de densidade do Android | Taxa de pixel do Flutter |
|---------------------------|---------------------|
| `ldpi`                    | `0.75x`             |
| `mdpi`                    | `1.0x`              |
| `hdpi`                    | `1.5x`              |
| `xhdpi`                   | `2.0x`              |
| `xxhdpi`                  | `3.0x`              |
| `xxxhdpi`                 | `4.0x`              |

Os ativos estão localizados em qualquer pasta arbitrária&mdash;
O Flutter não tem uma estrutura de pastas predefinida.
Você declara os ativos (com localização)
no arquivo `pubspec.yaml`, e o Flutter os coleta.

Para adicionar um novo ativo de imagem chamado `my_icon.png` ao nosso projeto Flutter,
por exemplo, e decidindo que ele deve estar em uma pasta que nós
arbitrariamente chamamos de `images`, você colocaria a imagem base (1.0x)
na pasta `images` e todas as outras variantes em subpastas
chamadas com o multiplicador de taxa apropriado:

```plaintext
images/my_icon.png       // Base: imagem 1.0x
images/2.0x/my_icon.png  // imagem 2.0x
images/3.0x/my_icon.png  // imagem 3.0x
```

Em seguida, você precisará declarar essas imagens no seu arquivo `pubspec.yaml`:

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

Informações mais detalhadas podem ser encontradas em [Adicionando ativos e imagens][].

### Onde armazeno strings? Como eu gerencio a localização?

Ao contrário do .NET que tem arquivos `resx`,
o Flutter não tem atualmente um sistema dedicado para o gerenciamento de strings.
No momento, a melhor prática é declarar seu texto de cópia
em uma classe como campos estáticos e acessá-los de lá. Por exemplo:

<?code-excerpt "lib/strings.dart (strings-class)"?>
```dart
class Strings {
  static const String welcomeMessage = 'Bem-vindo ao Flutter';
}
```

Você pode acessar suas strings assim:

<?code-excerpt "lib/strings.dart (access-string)" replace="/return const //g"?>
```dart
Text(Strings.welcomeMessage);
```

Por padrão, o Flutter oferece suporte apenas ao inglês dos EUA para suas strings.
Se você precisar adicionar suporte para outros idiomas,
inclua o pacote `flutter_localizations`.
Você também pode precisar adicionar o pacote [`intl`][] do Dart
para usar mecanismos i10n, como formatação de data/hora.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any # Use a versão do intl do flutter_localizations.
```

Para usar o pacote `flutter_localizations`,
especifique os `localizationsDelegates` e
`supportedLocales` no widget do aplicativo:

<?code-excerpt "lib/strings.dart (localization)"?>
```dart
import 'package:flutter_localizations/flutter_localizations.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>[
        // Adicione aqui os delegates de localização específicos do aplicativo
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: <Locale>[
        Locale('en', 'US'), // Inglês
        Locale('he', 'IL'), // Hebraico
        // ... outros locais que o aplicativo suporta
      ],
    );
  }
}
```

Os delegates contêm os valores localizados reais,
enquanto os `supportedLocales` definem quais locais o aplicativo suporta.
O exemplo acima usa um `MaterialApp`,
então ele tem um `GlobalWidgetsLocalizations`
para os valores localizados dos widgets base,
e um `MaterialWidgetsLocalizations` para as localizações dos widgets Material.
Se você usar `WidgetsApp` para seu aplicativo, não precisará do último.
Observe que esses dois delegates contêm valores "padrão",
mas você precisará fornecer um ou mais delegates
para a cópia localizável do seu próprio aplicativo,
se você quiser que eles também sejam localizados.

Quando inicializado, o `WidgetsApp` (ou `MaterialApp`)
cria um widget [`Localizations`][] para você,
com os delegates que você especificar.
O local atual do dispositivo está sempre acessível
a partir do widget `Localizations` do contexto atual
(na forma de um objeto `Locale`), ou usando o [`Window.locale`][].

Para acessar recursos localizados, use o método `Localizations.of()`
para acessar uma classe de localizações específica que é fornecida por um determinado delegate.
Use o pacote [`intl_translation`][] para extrair a cópia traduzível
para arquivos [arb][] para tradução e importá-los de volta para o aplicativo
para usá-los com `intl`.

Para mais detalhes sobre internacionalização e localização no Flutter,
consulte o [guia de internacionalização][], que tem código de exemplo
com e sem o pacote `intl`.

### Onde está meu arquivo de projeto?

No Xamarin.Forms, você terá um arquivo `csproj`.
O equivalente mais próximo no Flutter é o pubspec.yaml,
que contém dependências de pacotes e vários detalhes do projeto.
Semelhante ao .NET Standard,
os arquivos dentro do mesmo diretório são considerados parte do projeto.

### Qual é o equivalente ao Nuget? Como adiciono dependências?

No ecossistema .NET, projetos Xamarin nativos e projetos Xamarin.Forms
tinham acesso ao Nuget e ao sistema de gerenciamento de pacotes integrado.
Os aplicativos Flutter contêm um aplicativo Android nativo, um aplicativo iOS nativo e um aplicativo Flutter.

No Android, você adiciona dependências adicionando ao seu script de build do Gradle.
No iOS, você adiciona dependências adicionando ao seu `Podfile`.

O Flutter usa o próprio sistema de compilação do Dart e o gerenciador de pacotes Pub.
As ferramentas delegam a construção dos aplicativos wrappers nativos do Android e iOS
para os respectivos sistemas de construção.

Em geral, use `pubspec.yaml` para declarar
dependências externas a serem usadas no Flutter.
Um bom lugar para encontrar pacotes Flutter é no [pub.dev][].

## Ciclo de vida do aplicativo

### Como escuto os eventos do ciclo de vida do aplicativo?

No Xamarin.Forms, você tem um `Application`
que contém `OnStart`, `OnResume` e `OnSleep`.
No Flutter, você pode, em vez disso, escutar eventos de ciclo de vida semelhantes
conectando-se ao observador `WidgetsBinding` e escutando o
evento de mudança `didChangeAppLifecycleState()`.

Os eventos de ciclo de vida observáveis são:

`inactive`
: O aplicativo está em um estado inativo e não está recebendo entrada do usuário.
Este evento é exclusivo do iOS.

`paused`
: O aplicativo não está visível para o usuário atualmente,
não está respondendo à entrada do usuário, mas está em execução em segundo plano.

`resumed`
: O aplicativo está visível e respondendo à entrada do usuário.

`suspending`
: O aplicativo é suspenso momentaneamente.
Este evento é exclusivo do Android.

Para obter mais detalhes sobre o significado desses estados,
consulte a documentação [`AppLifecycleStatus`][].

[`AppLifecycleStatus` documentation]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html

## Layouts

### Qual é o equivalente a um StackLayout?

No Xamarin.Forms, você pode criar um `StackLayout`
com uma `Orientation` horizontal ou vertical.
O Flutter tem uma abordagem semelhante,
no entanto, você usaria os widgets `Row` ou `Column`.

Se você observar, os dois exemplos de código são idênticos
exceto pelo widget `Row` e `Column`.
Os filhos são os mesmos e esse recurso
pode ser explorado para desenvolver layouts ricos
que podem mudar ao longo do tempo com os mesmos filhos.

<?code-excerpt "lib/layouts.dart (row)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Text('Linha Um'),
      Text('Linha Dois'),
      Text('Linha Três'),
      Text('Linha Quatro'),
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
      Text('Coluna Um'),
      Text('Coluna Dois'),
      Text('Coluna Três'),
      Text('Coluna Quatro'),
    ],
  );
}
```

### Qual é o equivalente a um Grid?

O equivalente mais próximo de um `Grid` seria um `GridView`.
Isso é muito mais poderoso do que você está acostumado no Xamarin.Forms.
Um `GridView` fornece rolagem automática quando o
conteúdo excede seu espaço visível.

<?code-excerpt "lib/layouts.dart (grid)"?>
```dart
@override
Widget build(BuildContext context) {
  return GridView.count(
    // Cria um grid com 2 colunas. Se você alterar o scrollDirection para
    // horizontal, isso produziria 2 linhas.
    crossAxisCount: 2,
    // Gera 100 widgets que exibem seu índice na lista.
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

Você pode ter usado um `Grid` no Xamarin.Forms
para implementar widgets que sobrepõem outros widgets.
No Flutter, você realiza isso com o widget `Stack`.

Este exemplo cria dois ícones que se sobrepõem.

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

### Qual é o equivalente a um ScrollView?

No Xamarin.Forms, um `ScrollView` envolve um `VisualElement`,
e se o conteúdo for maior do que a tela do dispositivo, ele rola.

No Flutter, a correspondência mais próxima é o widget `SingleChildScrollView`.
Você simplesmente preenche o Widget com o conteúdo que você deseja que seja rolável.

<?code-excerpt "lib/layouts.dart (scroll-view)"?>
```dart
@override
Widget build(BuildContext context) {
  return const SingleChildScrollView(
    child: Text('Conteúdo Longo'),
  );
}
```

Se você tiver muitos itens que deseja envolver em uma rolagem,
mesmo de diferentes tipos de `Widget`, talvez queira usar um `ListView`.
Isso pode parecer exagero, mas no Flutter isso é
muito mais otimizado e menos intensivo do que um `ListView` do Xamarin.Forms,
que está se baseando em controles específicos da plataforma.

<?code-excerpt "lib/layouts.dart (list-view)"?>
```dart
@override
Widget build(BuildContext context) {
  return ListView(
    children: const <Widget>[
      Text('Linha Um'),
      Text('Linha Dois'),
      Text('Linha Três'),
      Text('Linha Quatro'),
    ],
  );
}
```

### Como eu gerencio as transições de paisagem no Flutter?

As transições de paisagem podem ser gerenciadas automaticamente definindo a
propriedade `configChanges` no AndroidManifest.xml:

```xml
<activity android:configChanges="orientation|screenSize" />
```

## Detecção de gestos e tratamento de eventos de toque

### Como adiciono GestureRecognizers a um widget no Flutter?

No Xamarin.Forms, os `Element`s podem conter um evento de clique ao qual você pode se conectar.
Muitos elementos também contêm um `Command` que está vinculado a este evento.
Alternativamente, você usaria o `TapGestureRecognizer`.
No Flutter, existem duas maneiras muito semelhantes:

1. Se o widget suporta detecção de eventos, passe uma função para ele e
   trate-o na função. Por exemplo, o ElevatedButton tem um
   parâmetro `onPressed`:

   <?code-excerpt "lib/gestures.dart (elevated-button)"?>
   ```dart
   @override
   Widget build(BuildContext context) {
     return ElevatedButton(
       onPressed: () {
         developer.log('click');
       },
       child: const Text('Botão'),
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

### Como gerencio outros gestos em widgets?

No Xamarin.Forms, você adicionaria um `GestureRecognizer` à `View`.
Você normalmente estaria limitado a `TapGestureRecognizer`,
`PinchGestureRecognizer`, `PanGestureRecognizer`, `SwipeGestureRecognizer`,
`DragGestureRecognizer` e `DropGestureRecognizer`, a menos que você construísse o seu próprio.

No Flutter, usando o GestureDetector,
você pode escutar uma ampla gama de gestos, como:

* Tap

`onTapDown`
: Um ponteiro que pode causar um toque
entrou em contato com a tela em um local específico.

`onTapUp`
: Um ponteiro que aciona um toque
parou de entrar em contato com a tela em um local específico.

`onTap`
: Ocorreu um toque.

`onTapCancel`
: O ponteiro que acionou anteriormente o `onTapDown`
não causará um toque.

* Double tap

`onDoubleTap`
: O usuário tocou na tela no mesmo local duas vezes
em rápida sucessão.

* Long press

`onLongPress`
: Um ponteiro permaneceu em contato com a tela
no mesmo local por um longo período de tempo.

* Arrastar verticalmente

`onVerticalDragStart`
: Um ponteiro entrou em contato com a tela e pode começar a se mover verticalmente.

`onVerticalDragUpdate`
: Um ponteiro em contato com a tela
se moveu ainda mais na direção vertical.

`onVerticalDragEnd`
: Um ponteiro que estava anteriormente em contato com a
tela e movendo-se verticalmente não está mais em contato
com a tela e estava se movendo em uma velocidade específica
quando parou de entrar em contato com a tela.

* Arrastar horizontalmente

`onHorizontalDragStart`
: Um ponteiro entrou em contato com a tela e pode começar a se mover horizontalmente.

`onHorizontalDragUpdate`
: Um ponteiro em contato com a tela
se moveu ainda mais na direção horizontal.

`onHorizontalDragEnd`
: Um ponteiro que estava anteriormente em contato com a
tela e movendo-se horizontalmente não está mais em contato
com a tela e estava se movendo em uma velocidade específica
quando parou de entrar em contato com a tela.

O exemplo a seguir mostra um `GestureDetector`
que gira o logotipo do Flutter com um toque duplo:

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

## Listviews e adaptadores

### Qual é o equivalente a um ListView no Flutter?

O equivalente a um `ListView` no Flutter é … um `ListView`!

Em um `ListView` do Xamarin.Forms, você cria um `ViewCell`
e possivelmente um `DataTemplateSelector` e o passa para o `ListView`,
que renderiza cada linha com o que seu
`DataTemplateSelector` ou `ViewCell` retorna.
No entanto, você geralmente tem que se certificar de que ativa a reciclagem de células,
caso contrário, você terá problemas de memória e velocidades de rolagem lentas.

Devido ao padrão de widget imutável do Flutter,
você passa uma lista de widgets para seu `ListView`,
e o Flutter se encarrega de garantir que a rolagem seja rápida e suave.

<?code-excerpt "lib/listview.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
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
        child: Text('Linha $index'),
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
### Como sei qual item da lista foi clicado?

Em Xamarin.Forms, o ListView tem um método `ItemTapped` para
descobrir qual item foi clicado. Existem muitas outras técnicas que você
pode ter usado, como verificar quando os comportamentos `SelectedItem`
ou `EventToCommand` mudam.

No Flutter, use o tratamento de toque fornecido pelos widgets passados.

```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  // Este widget é a raiz do seu aplicativo.
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
          developer.log('Linha $index clicada');
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Text('Linha $index'),
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

Em Xamarin.Forms, se você vinculasse a propriedade `ItemsSource` a um
`ObservableCollection`, você apenas atualizaria a lista em seu
ViewModel. Alternativamente, você pode atribuir uma nova `List` à
propriedade `ItemSource`.

No Flutter, as coisas funcionam um pouco diferente. Se você atualizar a
lista de widgets dentro de um método `setState()`, você verá rapidamente
que seus dados não mudaram visualmente. Isso ocorre porque quando
`setState()` é chamado, o mecanismo de renderização do Flutter examina
a árvore de widgets para ver se algo mudou. Quando chega ao seu
`ListView`, ele executa uma verificação `==` e determina que os dois
`ListView`s são os mesmos. Nada mudou, então nenhuma atualização é
necessária.

Para uma maneira simples de atualizar seu `ListView`, crie uma nova
`List` dentro de `setState()`, e copie os dados da lista antiga para a
nova lista. Embora esta abordagem seja simples, ela não é recomendada
para grandes conjuntos de dados, como mostrado no próximo exemplo.

```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
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
          developer.log('Linha $index');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Linha $index'),
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

A maneira recomendada, eficiente e eficaz de construir uma lista usa um
`ListView.Builder`. Este método é ótimo quando você tem uma lista
dinâmica ou uma lista com grandes quantidades de dados. Isso é
essencialmente o equivalente ao RecyclerView no Android, que recicla
automaticamente os elementos da lista para você:

```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
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
          developer.log('Linha $index');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Linha $index'),
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

Em vez de criar um `ListView`, crie um `ListView.builder` que aceita
dois parâmetros principais: o comprimento inicial da lista e uma função
de construtor de itens.

A função de construtor de itens é semelhante à função `getView` em um
adaptador Android; ele pega uma posição e retorna a linha que você
deseja renderizar nessa posição.

Finalmente, mas o mais importante, observe que a função `onTap()` não
recria mais a lista, mas adiciona a ela.

Para obter mais informações, consulte o codelab
[Seu primeiro aplicativo Flutter][first_codelab].

## Trabalhando com texto

### Como defino fontes personalizadas em meus widgets de texto?

Em Xamarin.Forms, você teria que adicionar uma fonte personalizada em
cada projeto nativo. Então, em seu `Element`, você atribuiria este nome
de fonte ao atributo `FontFamily` usando `filename#fontname` e apenas
`fontname` para iOS.

No Flutter, coloque o arquivo de fonte em uma pasta e faça referência a
ele no arquivo `pubspec.yaml`, semelhante a como você importa imagens.

```yaml
fonts:
  - family: MyCustomFont
    fonts:
      - asset: fonts/MyCustomFont.ttf
      - style: italic
```

Em seguida, atribua a fonte ao seu widget `Text`:

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Sample App')),
    body: const Center(
      child: Text(
        'Este é um texto de fonte personalizada',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
```

### Como estilizo meus widgets de texto?

Juntamente com as fontes, você pode personalizar outros elementos de
estilo em um widget `Text`. O parâmetro de estilo de um widget `Text`
recebe um objeto `TextStyle`, onde você pode personalizar vários
parâmetros, como:

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

Os `element`s do Xamarin.Forms permitem que você consulte diretamente
o `element` para determinar o estado de suas propriedades, ou se ele
está vinculado a uma propriedade em um `ViewModel`.

A recuperação de informações no Flutter é tratada por widgets
especializados e é diferente de como você está acostumado. Se você
tiver um `TextField` ou um `TextFormField`, você pode fornecer um
[`TextEditingController`][] para recuperar a entrada do usuário:

```dart
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  /// Crie um controlador de texto e use-o para recuperar o valor atual
  /// do TextField.
  final TextEditingController myController = TextEditingController();

  @override
  void dispose() {
    // Limpe o controlador ao descartar o widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar Entrada de Texto')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(controller: myController),
      ),
      floatingActionButton: FloatingActionButton(
        // Quando o usuário pressionar o botão, exiba um diálogo de alerta
        // com o texto que o usuário digitou em nosso campo de texto.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Recupere o texto que o usuário inseriu usando o
                // TextEditingController.
                content: Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Mostre-me o valor!',
        child: const Icon(Icons.text_fields),
      ),
    );
  }
}
```

Você pode encontrar mais informações e o código completo em
[Recuperar o valor de um campo de texto][], do [livro de receitas do
Flutter][].

### Qual é o equivalente a um Placeholder em um Entry?

Em Xamarin.Forms, alguns `Elements` suportam uma propriedade
`Placeholder` à qual você pode atribuir um valor. Por exemplo:

```xml
<Entry Placeholder="Esta é uma dica">
```

No Flutter, você pode mostrar facilmente uma "dica" ou um texto de
espaço reservado para sua entrada, adicionando um objeto
`InputDecoration` ao parâmetro do construtor `decoration` para o widget
de texto.

```dart
TextField(
  decoration: InputDecoration(hintText: 'Esta é uma dica'),
),
```

### Como mostro erros de validação?

Com Xamarin.Forms, se você quisesse fornecer uma dica visual de um erro
de validação, você precisaria criar novas propriedades e `VisualElement`s
em torno dos `Element`s que tinham erros de validação.

No Flutter, você passa por um objeto InputDecoration para o construtor
de decoration do widget de texto.

No entanto, você não quer começar mostrando um erro. Em vez disso,
quando o usuário inseriu dados inválidos, atualize o estado e passe um
novo objeto `InputDecoration`.

```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
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
                _errorText = 'Erro: Este não é um email';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'Esta é uma dica',
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

### Como interajo com a plataforma e com o código nativo da plataforma?

O Flutter não executa código diretamente na plataforma subjacente; em
vez disso, o código Dart que compõe um aplicativo Flutter é executado
nativamente no dispositivo, "contornando" o SDK fornecido pela
plataforma. Isso significa, por exemplo, que quando você executa uma
solicitação de rede no Dart, ela é executada diretamente no contexto
Dart. Você não usa as APIs do Android ou iOS que normalmente aproveita
ao escrever aplicativos nativos. Seu aplicativo Flutter ainda está
hospedado no `ViewController` ou `Activity` de um aplicativo nativo
como uma view, mas você não tem acesso direto a isso ou à estrutura
nativa.

Isso não significa que os aplicativos Flutter não possam interagir com
essas APIs nativas ou com qualquer código nativo que você tenha. O
Flutter fornece [canais de plataforma][] que se comunicam e trocam dados
com o `ViewController` ou `Activity` que hospeda sua view do Flutter.
Os canais de plataforma são essencialmente um mecanismo de mensagens
assíncronas que une o código Dart com o `ViewController` ou `Activity`
host e a estrutura iOS ou Android na qual ele é executado. Você pode
usar canais de plataforma para executar um método no lado nativo ou para
recuperar alguns dados dos sensores do dispositivo, por exemplo.

Além de usar diretamente os canais de plataforma, você pode usar uma
variedade de [plugins][] pré-fabricados que encapsulam o código nativo e
Dart para um objetivo específico. Por exemplo, você pode usar um plugin
para acessar o rolo da câmera e a câmera do dispositivo diretamente do
Flutter, sem ter que escrever sua própria integração. Os plugins são
encontrados em [pub.dev][], o repositório de pacotes de código aberto do
Dart e do Flutter. Alguns pacotes podem suportar integrações nativas no
iOS, ou Android, ou ambos.

Se você não conseguir encontrar um plugin no pub.dev que atenda às suas
necessidades, você pode [escrever o seu próprio][], e [publicá-lo no
pub.dev][].

### Como acesso o sensor GPS?

Use o plugin da comunidade [`geolocator`][].

### Como acesso a câmera?

O plugin [`camera`][] é popular para acessar a câmera.

### Como faço login com o Facebook?

Para fazer login com o Facebook, use o plugin da comunidade
[`flutter_facebook_login`][].

### Como uso os recursos do Firebase?

A maioria das funções do Firebase são cobertas por [plugins de
primeiros][]. Esses plugins são integrações de primeira parte, mantidas
pela equipe Flutter:

 * [`google_mobile_ads`][] para Google Mobile Ads para Flutter
 * [`firebase_analytics`][] para Firebase Analytics
 * [`firebase_auth`][] para Firebase Auth
 * [`firebase_database`][] para Firebase RTDB
 * [`firebase_storage`][] para Firebase Cloud Storage
 * [`firebase_messaging`][] para Firebase Messaging (FCM)
 * [`flutter_firebase_ui`][] para integrações rápidas do Firebase Auth
   (Facebook, Google, Twitter e e-mail)
 * [`cloud_firestore`][] para Firebase Cloud Firestore

Você também pode encontrar alguns plugins do Firebase de terceiros no
pub.dev que cobrem áreas não cobertas diretamente pelos plugins de
primeiros.

### Como construo minhas próprias integrações nativas personalizadas?

Se houver funcionalidades específicas da plataforma que o Flutter ou seus
plugins da comunidade estão faltando, você pode construir seu próprio
seguindo a página [desenvolvimento de pacotes e plugins][].

A arquitetura de plugin do Flutter, em poucas palavras, é muito parecida
com o uso de um barramento de eventos no Android: você dispara uma
mensagem e deixa o receptor processar e emitir um resultado de volta
para você. Neste caso, o receptor é o código em execução no lado nativo
no Android ou iOS.

## Temas (Estilos)

### Como eu tema meu aplicativo?

O Flutter vem com uma bela implementação integrada do Material Design,
que lida com muitas das necessidades de estilo e tema que você
normalmente faria.

O Xamarin.Forms tem um `ResourceDictionary` global onde você pode
compartilhar estilos em seu aplicativo. Alternativamente, há suporte para
temas atualmente em pré-visualização.

No Flutter, você declara temas no widget de nível superior.

Para aproveitar ao máximo os Componentes Material em seu aplicativo,
você pode declarar um widget de nível superior `MaterialApp` como o
ponto de entrada para seu aplicativo. `MaterialApp` é um widget de
conveniência que envolve vários widgets que são comumente necessários
para aplicativos que implementam o Material Design. Ele se baseia em um
`WidgetsApp` adicionando funcionalidades específicas do Material.

Você também pode usar um `WidgetsApp` como seu widget de aplicativo, que
fornece algumas das mesmas funcionalidades, mas não é tão rico quanto
`MaterialApp`.

Para personalizar as cores e estilos de qualquer componente filho, passe
um objeto `ThemeData` para o widget `MaterialApp`. Por exemplo, no
código a seguir, o esquema de cores da seed é definido como deepPurple
e a cor de seleção de texto é vermelha.

```dart
class SampleApp extends StatelessWidget {
  /// Este widget é a raiz do seu aplicativo.
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

## Bancos de dados e armazenamento local

### Como acesso preferências compartilhadas ou UserDefaults?

Os desenvolvedores Xamarin.Forms provavelmente estarão familiarizados com o
plugin `Xam.Plugins.Settings`.

No Flutter, acesse a funcionalidade equivalente usando o plugin
[`shared_preferences`][]. Este plugin envolve a funcionalidade de
`UserDefaults` e o equivalente Android, `SharedPreferences`.

### Como acesso o SQLite no Flutter?

Em Xamarin.Forms, a maioria dos aplicativos usaria o plugin
`sqlite-net-pcl` para acessar bancos de dados SQLite.

No Flutter, no macOS, Android e iOS, acesse esta funcionalidade usando
o plugin [`sqflite`][].

## Depuração

### Quais ferramentas posso usar para depurar meu aplicativo no Flutter?

Use o conjunto [DevTools][] para depurar aplicativos Flutter ou Dart.

O DevTools inclui suporte para criação de perfil, exame do heap,
inspeção da árvore de widgets, registro de diagnósticos, depuração,
observação de linhas de código executadas, depuração de vazamentos de
memória e fragmentação de memória. Para obter mais informações, consulte
a documentação do [DevTools][].

## Notificações

### Como configuro notificações push?

No Android, você usa o Firebase Cloud Messaging para configurar
notificações push para seu aplicativo.

No Flutter, acesse esta funcionalidade usando o plugin
[`firebase_messaging`][]. Para obter mais informações sobre como usar a
API do Firebase Cloud Messaging, consulte a documentação do plugin
[`firebase_messaging`][].

[Adicionando assets e imagens]: /ui/assets/assets-and-images
[Widgets de Animação e Movimento]: /ui/widgets/animation
[Visão geral de animações]: /ui/animations
[Tutorial de animações]: /ui/animations/tutorial
[Linguagem de design iOS da Apple]: {{site.apple-dev}}/design/resources/
[arb]: {{site.github}}/google/app-resource-bundle
[UI Assíncrona]: #async-ui
[`cloud_firestore`]: {{site.pub}}/packages/cloud_firestore
[compondo]: /resources/architectural-overview#composition
[Widgets Cupertino]: /ui/widgets/cupertino
[`devicePixelRatio`]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[desenvolvimento de pacotes e plugins]: /packages-and-plugins/developing-packages
[DevTools]: /tools/devtools
[plugin existente]: {{site.pub}}/flutter
[`google_mobile_ads`]: {{site.pub}}/packages/google_mobile_ads
[`firebase_analytics`]: {{site.pub}}/packages/firebase_analytics
[`firebase_auth`]: {{site.pub}}/packages/firebase_auth
[`firebase_database`]: {{site.pub}}/packages/firebase_database
[`firebase_messaging`]: {{site.pub}}/packages/firebase_messaging
[`firebase_storage`]: {{site.pub}}/packages/firebase_storage
[plugins de primeiros]: {{site.pub}}/flutter/packages?q=firebase
[livro de receitas do Flutter]: /cookbook
[`flutter_facebook_login`]: {{site.pub}}/packages/flutter_facebook_login
[`flutter_firebase_ui`]: {{site.pub}}/packages/flutter_firebase_ui
[`geolocator`]: {{site.pub}}/packages/geolocator
[`camera`]: {{site.pub-pkg}}/camera
[`http` package]: {{site.pub}}/packages/http
[guia de internacionalização]: /ui/accessibility-and-internationalization/internationalization
[`intl`]: {{site.pub}}/packages/intl
[`intl_translation`]: {{site.pub}}/packages/intl_translation
[Introdução à UI Declarativa]: /get-started/flutter-for/declarative
[`Localizations`]: {{site.api}}/flutter/widgets/Localizations-class.html
[Componentes Material]: /ui/widgets/material
[Material Design]: {{site.material}}/styles
[diretrizes de Material Design]: {{site.material}}/styles
[`Opacity` widget]: {{site.api}}/flutter/widgets/Opacity-class.html
[otimizado para todas as plataformas]: {{site.material2}}/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines
[canais de plataforma]: /platform-integration/platform-channels
[plugins]: /packages-and-plugins/using-packages
[pub.dev]: {{site.pub}}
[publicá-lo no pub.dev]: /packages-and-plugins/developing-packages#publish
[Recuperar o valor de um campo de texto]: /cookbook/forms/retrieve-input
[`shared_preferences`]: {{site.pub}}/packages/shared_preferences
[`sqflite`]: {{site.pub}}/packages/sqflite
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`url_launcher`]: {{site.pub}}/packages/url_launcher
[widget]: /resources/architectural-overview#widgets
[catálogo de widgets]: /ui/widgets/layout
[`Window.locale`]: {{site.api}}/flutter/dart-ui/Window/locale.html
[first_codelab]: {{site.codelabs}}/codelabs/flutter-codelab-first
[escreva o seu próprio]: /packages-and-plugins/developing-packages
