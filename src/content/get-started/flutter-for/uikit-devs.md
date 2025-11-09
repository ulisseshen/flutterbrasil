---
ia-translate: true
title: Flutter para desenvolvedores UIKit
description: Aprenda a aplicar o conhecimento de desenvolvedor iOS e UIKit ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/ios_devs"?>

Desenvolvedores iOS com experiência usando UIKit
que querem escrever aplicações móveis usando Flutter
devem revisar este guia.
Ele explica como aplicar o conhecimento existente de UIKit ao Flutter.

:::note
Se você tem experiência construindo apps com SwiftUI,
confira [Flutter para desenvolvedores SwiftUI][Flutter for SwiftUI developers] em vez disso.
:::

Flutter é um framework para construir aplicações multiplataforma
que usa a linguagem de programação Dart.
Para entender algumas diferenças entre programar com Dart
e programar com Swift,
confira [Aprendendo Dart como desenvolvedor Swift][Learning Dart as a Swift Developer]
e [Concorrência Flutter para desenvolvedores Swift][Flutter concurrency for Swift developers].

Seu conhecimento e experiência em iOS e UIKit
são altamente valiosos ao construir com Flutter.
{% comment %}
  TODO: Add talk about plugin system for interacting with OS and hardware
  when iOS and Apple hardware interactions with Flutter is released.
{% endcomment -%}

Flutter também faz uma série de adaptações
ao comportamento do app quando executado no iOS.
Para aprender como, veja [Adaptações de plataforma][Platform adaptations].

:::tip
Para integrar código Flutter em um app iOS **existente**,
confira [Adicionar Flutter a um app existente][Add Flutter to existing app].
:::

Use este guia como um cookbook.
Navegue e encontre perguntas que abordem suas necessidades mais relevantes.

## Visão geral

Como introdução, assista ao vídeo a seguir.
Ele descreve como Flutter funciona no iOS e como usar Flutter para construir apps iOS.

<YouTubeEmbed id="ceMsPBbcEGg" title="Flutter for iOS developers"></YouTubeEmbed>

### Views vs. Widgets

:::secondary
Como a programação estilo React, ou _declarativa_,
é diferente do estilo imperativo tradicional?
Para uma comparação, veja [Introdução à UI declarativa][Introduction to declarative UI].
:::

No UIKit, a maior parte do que você cria na UI é feito usando objetos view,
que são instâncias da classe `UIView`.
Estas podem atuar como contêineres para outras classes `UIView`,
que formam seu layout.

No Flutter, o equivalente aproximado a uma `UIView` é um `Widget`.
Widgets não mapeiam exatamente para views do iOS,
mas enquanto você está se familiarizando com como Flutter funciona
você pode pensar neles como "a forma como você declara e constrói UI".

No entanto, estes têm algumas diferenças em relação a uma `UIView`.
Para começar, widgets têm um ciclo de vida diferente: eles são imutáveis
e só existem até que precisem ser mudados.
Sempre que widgets ou seu estado mudam,
o framework do Flutter cria uma nova árvore de instâncias de widget.
Em comparação, uma view UIKit não é recriada quando muda,
mas sim é uma entidade mutável que é desenhada uma vez
e não redesenha até ser invalidada usando `setNeedsDisplay()`.

Além disso, ao contrário de `UIView`, os widgets do Flutter são leves,
em parte devido à sua imutabilidade.
Porque eles não são views em si,
e não estão desenhando nada diretamente,
mas sim são uma descrição da UI e sua semântica
que são "infladas" em objetos view reais por baixo dos panos.

Flutter inclui a biblioteca [Material Components][Material Components].
Estes são widgets que implementam as
[diretrizes Material Design][Material Design guidelines].
Material Design é um sistema de design flexível
[otimizado para todas as plataformas][optimized for all platforms], incluindo iOS.

Mas Flutter é flexível e expressivo o suficiente
para implementar qualquer linguagem de design.
No iOS, você pode usar a biblioteca [Cupertino widgets][Cupertino widgets]
para produzir uma interface que se parece com
[a linguagem de design iOS da Apple][Apple's iOS design language].

### Atualizando widgets

Para atualizar suas views no UIKit, você as modifica diretamente.
No Flutter, widgets são imutáveis e não são atualizados diretamente.
Em vez disso, você precisa manipular o estado do widget.

É aí que entra o conceito de Stateful vs Stateless widgets.
Um `StatelessWidget` é exatamente o que parece
&mdash;um widget sem estado anexado.

`StatelessWidgets` são úteis quando a parte da interface do usuário que você está
descrevendo não depende de nada além das informações de configuração inicial
no widget.

Por exemplo, com UIKit, isso é similar a colocar uma `UIImageView`
com seu logo como a `image`. Se o logo não está mudando durante a execução,
use um `StatelessWidget` no Flutter.

Se você quiser mudar dinamicamente a UI com base em dados recebidos
após fazer uma chamada HTTP, use um `StatefulWidget`.
Depois que a chamada HTTP for concluída, diga ao framework do Flutter
que o `State` do widget foi atualizado, para que ele possa atualizar a UI.

A diferença importante entre widgets stateless e
stateful é que `StatefulWidget`s têm um objeto `State`
que armazena dados de estado e os transporta através de reconstruções de árvore,
então não é perdido.

Se você está em dúvida, lembre-se desta regra:
se um widget muda fora do método `build`
(por causa de interações do usuário em tempo de execução, por exemplo),
ele é stateful.
Se o widget nunca muda, uma vez construído, ele é stateless.
No entanto, mesmo que um widget seja stateful, o widget pai que contém
ainda pode ser stateless se não estiver reagindo a essas mudanças
(ou outras entradas).

O exemplo a seguir mostra como usar um `StatelessWidget`.
Um `StatelessWidget` comum é o widget `Text`.
Se você olhar para a implementação do widget `Text`,
você verá que ele é subclasse de `StatelessWidget`.

<?code-excerpt "lib/text_widget.dart (text-widget)" replace="/return const //g"?>
```dart
Text(
  'I like Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Se você olhar o código acima, pode notar que o widget `Text`
não carrega nenhum estado explícito com ele. Ele renderiza o que é passado em seus
construtores e nada mais.

Mas, e se você quiser fazer "I Like Flutter" mudar dinamicamente,
por exemplo, ao clicar em um `FloatingActionButton`?

Para conseguir isso, envolva o widget `Text` em um `StatefulWidget` e
atualize-o quando o usuário clicar no botão.

Por exemplo:

<?code-excerpt "lib/text_widget.dart (stateful-widget)"?>
```dart

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
  // Default placeholder text
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

### Layout de widget

No UIKit, você pode usar um arquivo Storyboard
para organizar suas views e definir restrições,
ou pode definir suas restrições programaticamente em seus view controllers.
No Flutter, declare seu layout em código compondo uma árvore de widgets.

O exemplo a seguir mostra como exibir um widget simples com padding:

<?code-excerpt "lib/layout.dart (simple-widget)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Sample App')),
    body: Center(
      child: CupertinoButton(
        onPressed: () {},
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: const Text('Hello'),
      ),
    ),
  );
}
```

Você pode adicionar padding a qualquer widget,
o que imita a funcionalidade de restrições no iOS.

Você pode ver os layouts que Flutter tem a oferecer
no [catálogo de widgets][widget catalog].

### Removendo Widgets

No UIKit, você chama `addSubview()` no pai,
ou `removeFromSuperview()` em uma view filha
para adicionar ou remover views filhas dinamicamente.
No Flutter, porque widgets são imutáveis,
não há equivalente direto a `addSubview()`.
Em vez disso, você pode passar uma função para o pai
que retorna um widget, e controlar a criação desse filho
com uma flag booleana.

O exemplo a seguir mostra como alternar entre dois widgets
quando o usuário clica no `FloatingActionButton`:

<?code-excerpt "lib/layout.dart (toggle-widget)"?>
```dart
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
  // Default value for toggle.
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

### Animações

No UIKit, você cria uma animação chamando o
método `animate(withDuration:animations:)` em uma view.
No Flutter, use a biblioteca de animação
para envolver widgets dentro de um widget animado.

No Flutter, use um `AnimationController`, que é um `Animation<double>`
que pode pausar, buscar, parar e reverter a animação.
Ele requer um `Ticker` que sinaliza quando vsync acontece
e produz uma interpolação linear
entre 0 e 1 em cada frame enquanto está executando.
Você então cria uma ou mais
`Animation`s e as anexa ao controller.

Por exemplo, você pode usar `CurvedAnimation`
para implementar uma animação ao longo de uma curva interpolada.
Nesse sentido, o controller é a fonte "mestre"
do progresso da animação
e a `CurvedAnimation` calcula a curva
que substitui o movimento linear padrão do controller.
Como widgets, animações no Flutter funcionam com composição.

Ao construir a árvore de widgets, você atribui o `Animation` a uma propriedade animada
de um widget, como a opacidade de um `FadeTransition`,
e diz ao controller para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que
faz fade do widget para um logo quando você pressiona o `FloatingActionButton`:

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  const SampleApp({super.key});

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

class _MyFadeTest extends State<MyFadeTest>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation curve;

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
  void dispose() {
    controller.dispose();
    super.dispose();
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

Para mais informações, veja [Widgets de Animação & Movimento][Animation & Motion widgets],
o [tutorial de Animações][Animations tutorial], e a [visão geral de Animações][Animations overview].

### Desenhando na tela

No UIKit, você usa `CoreGraphics` para desenhar linhas e formas para a
tela. Flutter tem uma API diferente baseada na classe `Canvas`,
com duas outras classes que ajudam você a desenhar: `CustomPaint` e `CustomPainter`,
sendo que a última implementa seu algoritmo para desenhar no canvas.

Para aprender como implementar um signature painter no Flutter,
veja a resposta de Collin no [StackOverflow][StackOverflow].

[StackOverflow]: {{site.so}}/questions/46241071/create-signature-area-for-mobile-app-in-dart-flutter

<?code-excerpt "lib/canvas.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: DemoApp()));

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(body: Signature());
}

class Signature extends StatefulWidget {
  const Signature({super.key});

  @override
  State<Signature> createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset?> _points = <Offset?>[];
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          RenderBox? referenceBox = context.findRenderObject() as RenderBox;
          Offset localPosition = referenceBox.globalToLocal(
            details.globalPosition,
          );
          _points = List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (details) => _points.add(null),
      child: CustomPaint(
        painter: SignaturePainter(_points),
        size: Size.infinite,
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

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

### Opacidade de widget

No UIKit, tudo tem `.opacity` ou `.alpha`.
No Flutter, na maioria das vezes você precisa
envolver um widget em um widget `Opacity` para conseguir isso.

### Widgets customizados

No UIKit, você tipicamente faz subclasse de `UIView`, ou usa uma view pré-existente,
para sobrescrever e implementar métodos que alcançam o comportamento desejado.
No Flutter, construa um widget customizado [compondo][composing] widgets menores
(em vez de estendê-los).

Por exemplo, como você constrói um `CustomButton`
que recebe um label no construtor?
Crie um CustomButton que compõe um `ElevatedButton` com um label,
em vez de estender `ElevatedButton`:

<?code-excerpt "lib/custom.dart (custom-button)"?>
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

Então use `CustomButton`,
assim como você usaria qualquer outro widget Flutter:

<?code-excerpt "lib/custom.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(child: CustomButton('Hello'));
}
```

### Gerenciando dependências

No iOS, você adiciona dependências com CocoaPods adicionando ao seu `Podfile`.
Flutter usa o sistema de build do Dart e o gerenciador de pacotes Pub
para lidar com dependências. As ferramentas delegam a construção dos
apps wrapper nativos Android e iOS aos
respectivos sistemas de build.

Embora haja um Podfile na pasta iOS no seu
projeto Flutter, use-o apenas se estiver adicionando
dependências nativas necessárias para integração por plataforma.
Em geral, use `pubspec.yaml` para declarar dependências externas no Flutter.
Um bom lugar para encontrar pacotes excelentes para Flutter é no [pub.dev][pub.dev].

## Navegação

Esta seção do documento discute navegação
entre páginas de um app, o mecanismo push e pop, e mais.

### Navegando entre páginas

No UIKit, para viajar entre view controllers, você pode usar um
`UINavigationController` que gerencia a pilha de view controllers
a serem exibidos.

Flutter tem uma implementação similar,
usando um `Navigator` e `Routes`.
Um `Route` é uma abstração para uma "tela" ou "página" de um app,
e um `Navigator` é um [widget][widget]
que gerencia routes. Um route mapeia aproximadamente para um
`UIViewController`. O navigator funciona de maneira similar ao
`UINavigationController` do iOS, pois pode fazer `push()` e `pop()`
routes dependendo se você quer navegar para, ou voltar de, uma view.

Para navegar entre páginas, você tem algumas opções:

* Especificar um `Map` de nomes de routes.
* Navegar diretamente para um route.

O exemplo a seguir constrói um `Map.`

<?code-excerpt "lib/intent.dart (map)"?>
```dart
void main() {
  runApp(
    CupertinoApp(
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

Navegue para um route fazendo `push` de seu nome para o `Navigator`.

<?code-excerpt "lib/intent.dart (push)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

A classe `Navigator` lida com roteamento no Flutter e é usada para obter
um resultado de volta de um route que você fez push na pilha.
Isso é feito aguardando (`await`ing) o `Future` retornado por `push()`.

Por exemplo, para iniciar um route `location` que permite ao usuário selecionar sua
localização, você pode fazer o seguinte:

<?code-excerpt "lib/intent.dart (push-await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro do seu route `location`, uma vez que o usuário tenha selecionado sua
localização, faça `pop()` da pilha com o resultado:

<?code-excerpt "lib/intent.dart (pop)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

### Navegando para outro app

No UIKit, para enviar o usuário para outra aplicação,
você usa um esquema de URL específico.
Para os apps de nível de sistema, o esquema depende do app.
Para implementar essa funcionalidade no Flutter,
crie uma integração de plataforma nativa, ou use um
[plugin existente][existing plugin], como [`url_launcher`][`url_launcher`].

### Pop manual de volta

Chamar `SystemNavigator.pop()` do seu código Dart
invoca o seguinte código iOS:

```objc
UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
if ([viewController isKindOfClass:[UINavigationController class]]) {
  [((UINavigationController*)viewController) popViewControllerAnimated:NO];
}
```

Se isso não faz o que você quer, você pode criar seu próprio
[canal de plataforma][platform channel] para invocar código iOS arbitrário.

### Lidando com localização

Ao contrário do iOS, que tem o arquivo `Localizable.strings`,
Flutter atualmente não tem um sistema dedicado para lidar com strings.
No momento, a melhor prática é declarar seu texto de cópia
em uma classe como campos estáticos e acessá-los de lá. Por exemplo:

<?code-excerpt "lib/string_examples.dart (strings)"?>
```dart
class Strings {
  static const String welcomeMessage = 'Welcome To Flutter';
}
```

Você pode acessar suas strings assim:

<?code-excerpt "lib/string_examples.dart (access-string)" replace="/const //g; /return //g;"?>
```dart
Text(Strings.welcomeMessage);
```

Por padrão, Flutter só suporta inglês americano para suas strings.
Se você precisa adicionar suporte para outras línguas,
inclua o pacote `flutter_localizations`.
Você também pode precisar adicionar o pacote [`intl`][`intl`] do Dart
para usar maquinaria i10n, como formatação de data/hora.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any # Use version of intl from flutter_localizations.
```

Para usar o pacote `flutter_localizations`,
especifique os `localizationsDelegates` e
`supportedLocales` no widget do app:

<?code-excerpt "lib/localizations_example.dart"?>
```dart
import 'package:flutter/material.dart';
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
enquanto `supportedLocales` define quais locales o app suporta.
O exemplo acima usa um `MaterialApp`,
então ele tem tanto um `GlobalWidgetsLocalizations`
para os valores localizados de widgets base,
quanto um `MaterialWidgetsLocalizations` para as localizações de widgets Material.
Se você usa `WidgetsApp` para seu app, você não precisa do último.
Note que esses dois delegates contêm valores "padrão",
mas você precisará fornecer um ou mais delegates
para a cópia localizável do seu próprio app,
se quiser que eles também sejam localizados.

Quando inicializado, o `WidgetsApp` (ou `MaterialApp`)
cria um widget [`Localizations`][`Localizations`] para você,
com os delegates que você especifica.
O locale atual para o dispositivo está sempre acessível
do widget `Localizations` do contexto atual
(na forma de um objeto `Locale`), ou usando o [`Window.locale`][`Window.locale`].

Para acessar recursos localizados, use o método `Localizations.of()`
para acessar uma classe de localizações específica que é fornecida por um dado delegate.
Use o pacote [`intl_translation`][`intl_translation`] para extrair cópia traduzível
para arquivos [arb][arb] para traduzir, e importá-los de volta ao app
para usá-los com `intl`.

Para mais detalhes sobre internacionalização e localização no Flutter,
veja o [guia de internacionalização][internationalization guide], que tem código de exemplo
com e sem o pacote `intl`.

## ViewControllers

Esta seção do documento discute o equivalente
de ViewController no Flutter e como ouvir
eventos de ciclo de vida.

### Equivalente de ViewController no Flutter

No UIKit, um `ViewController` representa uma porção da interface do usuário,
mais comumente usado para uma tela ou seção.
Estes são compostos juntos para construir interfaces de usuário complexas,
e ajudam a escalar a UI da sua aplicação.
No Flutter, esse trabalho cabe aos Widgets.
Como mencionado na seção Navegação,
telas no Flutter são representadas por Widgets já que
"tudo é um widget!"
Use um `Navigator` para se mover entre diferentes `Route`s
que representam diferentes telas ou páginas,
ou talvez diferentes estados ou renderizações dos mesmos dados.

### Ouvindo eventos de ciclo de vida

No UIKit, você pode sobrescrever métodos do `ViewController`
para capturar métodos de ciclo de vida para a view em si,
ou registrar callbacks de ciclo de vida no `AppDelegate`.
No Flutter, você não tem nenhum desses conceitos, mas você pode
ouvir eventos de ciclo de vida conectando-se ao
observador `WidgetsBinding` e ouvindo o
evento de mudança `didChangeAppLifecycleState()`.

Os eventos de ciclo de vida observáveis são:

**`inactive`**
: A aplicação está em um estado inativo e não está recebendo
entrada do usuário. Este evento só funciona no iOS,
pois não há evento equivalente no Android.

**`paused`**
: A aplicação não está visível atualmente para o usuário,
não está respondendo à entrada do usuário, mas está executando em segundo plano.

**`resumed`**
: A aplicação está visível e respondendo à entrada do usuário.

**`suspending`**
: A aplicação está suspensa momentaneamente.
A plataforma iOS não tem evento equivalente.

Para mais detalhes sobre o significado desses estados, veja
[documentação de `AppLifecycleState`][`AppLifecycleState` documentation].

## Layouts

Esta seção discute diferentes layouts no Flutter
e como eles se comparam com UIKit.

### Exibindo uma list view

No UIKit, você pode mostrar uma lista em
uma `UITableView` ou uma `UICollectionView`.
No Flutter, você tem uma implementação similar usando uma `ListView`.
No UIKit, essas views têm métodos delegate
para decidir o número de linhas,
a célula para cada index path, e o tamanho das células.

Devido ao padrão de widget imutável do Flutter,
você passa uma lista de widgets para sua `ListView`,
e o Flutter cuida de garantir que
a rolagem seja rápida e suave.

<?code-excerpt "lib/listview.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  // This widget is the root of your application.
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
    final List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(
        Padding(padding: const EdgeInsets.all(10), child: Text('Row $i')),
      );
    }
    return widgets;
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

### Detectando o que foi clicado

No UIKit, você implementa o método delegate,
`tableView:didSelectRowAtIndexPath:`.
No Flutter, use o tratamento de toque fornecido pelos widgets passados.

<?code-excerpt "lib/list_item_tapped.dart"?>
```dart
import 'dart:developer' as developer;
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  // This widget is the root of your application.
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
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(
        GestureDetector(
          onTap: () {
            developer.log('row tapped');
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text('Row $i'),
          ),
        ),
      );
    }
    return widgets;
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

### Atualizando ListView dinamicamente

No UIKit, você atualiza os dados para a list view,
e notifica a table ou collection view usando o
método `reloadData`.

No Flutter, se você atualizar a lista de widgets dentro de um `setState()`,
você verá rapidamente que seus dados não mudam visualmente.
Isso ocorre porque quando `setState()` é chamado,
o motor de renderização do Flutter olha para a árvore de widgets
para ver se algo mudou.
Quando chega à sua `ListView`, ele executa uma verificação `==`,
e determina que as duas `ListView`s são as mesmas.
Nada mudou, então nenhuma atualização é necessária.

Para uma maneira simples de atualizar sua `ListView`,
crie uma nova `List` dentro de `setState()`,
e copie os dados da lista antiga para a nova lista.
Embora essa abordagem seja simples,
não é recomendada para grandes conjuntos de dados,
como mostrado no próximo exemplo.

<?code-excerpt "lib/listview_dynamic.dart"?>
```dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  // This widget is the root of your application.
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

  Widget getRow(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets = List.from(widgets);
          widgets.add(getRow(widgets.length));
          developer.log('row $i');
        });
      },
      child: Padding(padding: const EdgeInsets.all(10), child: Text('Row $i')),
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

A maneira recomendada, eficiente,
e eficaz de construir uma lista usa um `ListView.Builder`.
Este método é ótimo quando você tem uma lista dinâmica
ou uma lista com grandes quantidades de dados.

<?code-excerpt "lib/listview_builder.dart"?>
```dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  // This widget is the root of your application.
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

  Widget getRow(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets.add(getRow(widgets.length));
          developer.log('row $i');
        });
      },
      child: Padding(padding: const EdgeInsets.all(10), child: Text('Row $i')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
      body: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, position) {
          return getRow(position);
        },
      ),
    );
  }
}
```

Em vez de criar uma `ListView`, crie um `ListView.builder`
que recebe dois parâmetros chave: o tamanho inicial da lista,
e uma função `ItemBuilder`.

A função `ItemBuilder` é similar ao método delegate `cellForItemAt`
em uma table ou collection view do iOS,
pois recebe uma posição, e retorna a
célula que você quer renderizar nessa posição.

Finalmente, mas mais importante, note que a função `onTap()`
não recria mais a lista, mas em vez disso faz `.add` a ela.

### Criando uma scroll view

No UIKit, você envolve suas views em uma `ScrollView` que
permite ao usuário rolar seu conteúdo se necessário.

No Flutter, a maneira mais fácil de fazer isso é usando o widget `ListView`.
Ele atua tanto como uma `ScrollView` quanto como uma `TableView` do iOS,
pois você pode dispor widgets em um formato vertical.

<?code-excerpt "lib/layout.dart (list-view)"?>
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

Para documentação mais detalhada sobre como dispor widgets no Flutter,
veja o [tutorial de layout][layout tutorial].

## Detecção de gestos e tratamento de eventos de toque

Esta seção discute como detectar gestos
e lidar com diferentes eventos no Flutter,
e como eles se comparam com UIKit.

### Adicionando um listener de clique

No UIKit, você anexa um `GestureRecognizer` a uma view para
lidar com eventos de clique.
No Flutter, existem duas maneiras de adicionar listeners de toque:

1. Se o widget suporta detecção de evento, passe uma função para ele,
   e trate o evento na função. Por exemplo, o
   widget `ElevatedButton` tem um parâmetro `onPressed`:

  <?code-excerpt "lib/events.dart (on-pressed)"?>
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

2. Se o Widget não suporta detecção de evento,
   envolva o widget em um GestureDetector e passe uma função
   para o parâmetro `onTap`.

  <?code-excerpt "lib/events.dart (on-tap)"?>
   ```dart
  class SampleTapApp extends StatelessWidget {
    const SampleTapApp({super.key});

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

### Tratando outros gestos

Usando `GestureDetector` você pode ouvir
uma ampla gama de gestos como:

* **Tapping**

  **`onTapDown`**
  : Um ponteiro que pode causar um tap contactou a
  tela em uma localização particular.

  **`onTapUp`**
  : Um ponteiro que dispara um tap parou de contactar a
  tela em uma localização particular.

  **`onTap`**
  : Um tap ocorreu.

  **`onTapCancel`**
  : O ponteiro que previamente disparou o `onTapDown`
  não causará um tap.

* **Double tapping**

  **`onDoubleTap`**
  : O usuário tocou na tela na mesma localização duas vezes em
  rápida sucessão.

* **Long pressing**

  **`onLongPress`**
  : Um ponteiro permaneceu em contato com a tela
  na mesma localização por um longo período de tempo.

* **Vertical dragging**

  **`onVerticalDragStart`**
  : Um ponteiro contactou a tela e pode começar a
  se mover verticalmente.

  **`onVerticalDragUpdate`**
  : Um ponteiro em contato com a tela
  se moveu mais na direção vertical.

  **`onVerticalDragEnd`**
  : Um ponteiro que estava previamente em contato com a
  tela e se movendo verticalmente não está mais em contato
  com a tela e estava se movendo a uma velocidade específica
  quando parou de contactar a tela.

* **Horizontal dragging**

  **`onHorizontalDragStart`**
  : Um ponteiro contactou a tela e pode começar
  a se mover horizontalmente.

  **`onHorizontalDragUpdate`**
  : Um ponteiro em contato com a tela
  se moveu mais na direção horizontal.

  **`onHorizontalDragEnd`**
  : Um ponteiro que estava previamente em contato com a
  tela e se movendo horizontalmente não está mais em
  contato com a tela.

O exemplo a seguir mostra um `GestureDetector`
que rotaciona o logo Flutter em um double tap:

<?code-excerpt "lib/events.dart (sample-app)"?>
```dart
class SampleApp extends StatefulWidget {
  const SampleApp({super.key});

  @override
  State<SampleApp> createState() => _SampleAppState();
}

class _SampleAppState extends State<SampleApp>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late CurvedAnimation curve;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
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

## Temas, estilos e mídia

Aplicações Flutter são fáceis de estilizar; você pode alternar
entre temas claros e escuros,
mudar o estilo do seu texto e componentes UI,
e mais. Esta seção cobre aspectos de estilização dos seus apps Flutter
e compara como você poderia fazer o mesmo no UIKit.

### Usando um tema

Pronto para uso, Flutter vem com uma implementação bonita
do Material Design, que cuida de muitas necessidades de estilização e
tematização que você normalmente faria.

Para tirar total vantagem dos Material Components no seu app,
declare um widget de nível superior, `MaterialApp`,
como o ponto de entrada para sua aplicação.
`MaterialApp` é um widget de conveniência que envolve vários
widgets que são comumente necessários para aplicações
implementando Material Design.
Ele constrói sobre um `WidgetsApp` adicionando funcionalidade específica do Material.

Mas Flutter é flexível e expressivo o suficiente para implementar
qualquer linguagem de design. No iOS, você pode usar a
[biblioteca Cupertino][Cupertino library] para produzir uma interface que adere às
[Diretrizes de Interface Humana][Human Interface Guidelines].
Para o conjunto completo desses widgets,
veja a galeria de [widgets Cupertino][Cupertino widgets].

Você também pode usar um `WidgetsApp` como seu widget de app,
que fornece algumas das mesmas funcionalidades,
mas não é tão rico quanto `MaterialApp`.

Para customizar as cores e estilos de qualquer componente filho,
passe um objeto `ThemeData` para o widget `MaterialApp`.
Por exemplo, no código abaixo,
o esquema de cores da semente é definido como deepPurple e a cor do divisor é cinza.

<?code-excerpt "lib/theme.dart (theme)"?>
```dart
import 'package:flutter/material.dart';

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        dividerColor: Colors.grey,
      ),
      home: const SampleAppPage(),
    );
  }
}
```

### Usando fontes customizadas

No UIKit, você importa quaisquer arquivos de fonte `ttf` no seu projeto
e cria uma referência no arquivo `info.plist`.
No Flutter, coloque o arquivo de fonte em uma pasta
e faça referência a ele no arquivo `pubspec.yaml`,
similar a como você importa imagens.

```yaml
fonts:
  - family: MyCustomFont
    fonts:
      - asset: fonts/MyCustomFont.ttf
      - style: italic
```

Então atribua a fonte ao seu widget `Text`:

<?code-excerpt "lib/text.dart (custom-font)"?>
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

### Estilizando texto

Junto com fontes, você pode customizar outros elementos de estilização em um widget `Text`.
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

### Empacotando imagens em apps

Enquanto iOS trata imagens e assets como itens distintos,
apps Flutter têm apenas assets. Recursos que são
colocados na pasta `Images.xcasset` no iOS,
são colocados em uma pasta de assets para Flutter.
Assim como no iOS, assets são qualquer tipo de arquivo, não apenas imagens.
Por exemplo, você pode ter um arquivo JSON localizado na pasta `my-assets`:

```plaintext
my-assets/data.json
```

Declare o asset no arquivo `pubspec.yaml`:

```yaml
assets:
 - my-assets/data.json
```

E então acesse-o do código usando um [`AssetBundle`][`AssetBundle`]:

<?code-excerpt "lib/asset_bundle.dart"?>
```dart
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
```

Para imagens, Flutter segue um formato simples baseado em densidade como iOS.
Assets de imagem podem ser `1.0x`, `2.0x`, `3.0x`, ou qualquer outro multiplicador.
O [`devicePixelRatio`][`devicePixelRatio`] do Flutter expressa a razão
de pixels físicos em um único pixel lógico.

Assets estão localizados em qualquer pasta arbitrária&mdash;
Flutter não tem estrutura de pastas predefinida.
Você declara os assets (com localização) no
arquivo `pubspec.yaml`, e o Flutter os pega.

Por exemplo, para adicionar uma imagem chamada `my_icon.png` ao seu projeto
Flutter, você pode decidir armazená-la em uma pasta arbitrariamente chamada `images`.
Coloque a imagem base (1.0x) na pasta `images`, e as
outras variantes em subpastas nomeadas após o multiplicador de razão apropriado:

```plaintext
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

Em seguida, declare essas imagens no arquivo `pubspec.yaml`:

```yaml
assets:
 - images/my_icon.png
```

Você agora pode acessar suas imagens usando `AssetImage`:

<?code-excerpt "lib/images.dart (asset-image)"?>
```dart
image: AssetImage('images/a_dot_burr.png'),
```

ou diretamente em um widget `Image`:

<?code-excerpt "lib/images.dart (image-asset)"?>
```dart
@override
Widget build(BuildContext context) {
  return Image.asset('images/my_image.png');
}
```

Para mais detalhes, veja
[Adicionando Assets e Imagens no Flutter][Adding Assets and Images in Flutter].

## Entrada de formulário

Esta seção discute como usar formulários no Flutter
e como eles se comparam com UIKit.

### Recuperando entrada do usuário

Dado como Flutter usa widgets imutáveis com um estado separado,
você pode estar se perguntando como a entrada do usuário se encaixa na imagem.
No UIKit, você geralmente consulta os widgets por seus valores atuais
quando é hora de enviar a entrada do usuário, ou agir sobre ela.
Como isso funciona no Flutter?

Na prática, formulários são tratados, como tudo no Flutter,
por widgets especializados. Se você tem um `TextField` ou um
`TextFormField`, você pode fornecer um [`TextEditingController`][`TextEditingController`]
para recuperar a entrada do usuário:

<?code-excerpt "lib/form.dart (my-form-state)"?>
```dart
class _MyFormState extends State<MyForm> {
  // Create a text controller and use it to retrieve the current value.
  // of the TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when disposing of the Widget.
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
        // text the user has typed into our text field.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Retrieve the text the user has typed in using our
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

Você pode encontrar mais informações e a listagem completa de código em
[Recuperar o valor de um campo de texto][Retrieve the value of a text field].

### Placeholder em um campo de texto

No Flutter, você pode facilmente mostrar uma "dica" ou um texto placeholder
para seu campo adicionando um objeto `InputDecoration`
ao parâmetro construtor decoration para o widget `Text`:

<?code-excerpt "lib/form.dart (input-hint)" replace="/return const //g;/;//g"?>
```dart
Center(
  child: TextField(decoration: InputDecoration(hintText: 'This is a hint')),
)
```

### Mostrando erros de validação

Assim como você faria com uma "dica", passe um objeto `InputDecoration`
ao construtor decoration para o widget `Text`.

No entanto, você não quer começar mostrando um erro.
Em vez disso, quando o usuário inseriu dados inválidos,
atualize o estado, e passe um novo objeto `InputDecoration`.

<?code-excerpt "lib/validation_errors.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  // This widget is the root of your application.
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

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
        r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
        r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

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
            errorText: _errorText,
          ),
        ),
      ),
    );
  }
}
```

## Threading & assincronia

Esta seção discute concorrência no Flutter e
como ela se compara com UIKit.

### Escrevendo código assíncrono

Dart tem um modelo de execução single-threaded,
com suporte para `Isolate`s
(uma maneira de executar código Dart em outra thread),
um loop de eventos, e programação assíncrona.
A menos que você spawne um `Isolate`,
seu código Dart executa na thread principal de UI e é
dirigido por um loop de eventos. O loop de eventos do Flutter é
equivalente ao main loop do iOS&mdash;ou seja,
o `Looper` que está anexado à thread principal.

O modelo single-threaded do Dart não significa que você seja
obrigado a executar tudo como uma operação bloqueante
que causa o congelamento da UI. Em vez disso,
use as facilidades assíncronas que a linguagem Dart fornece,
como `async`/`await`, para realizar trabalho assíncrono.

Por exemplo, você pode executar código de rede sem causar
o travamento da UI usando `async`/`await` e deixando Dart fazer
o trabalho pesado:

<?code-excerpt "lib/async.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

Uma vez que a chamada de rede aguardada (`await`ed) está concluída,
atualize a UI chamando `setState()`,
que dispara uma reconstrução da subárvore de widgets
e atualiza os dados.

O exemplo a seguir carrega dados assincronamente e
os exibe em uma `ListView`:

<?code-excerpt "lib/async.dart"?>
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

Consulte a próxima seção para mais informações sobre fazer trabalho
em segundo plano, e como Flutter difere do iOS.

### Movendo para a thread de segundo plano

Como Flutter é single threaded e executa um loop de eventos
(como Node.js), você não precisa se preocupar com
gerenciamento de threads ou spawning de threads de segundo plano.
Se você está fazendo trabalho bound a I/O,
como acesso a disco ou uma chamada de rede,
então você pode usar `async`/`await` com segurança e está pronto.
Se, por outro lado, você precisa fazer trabalho computacionalmente intensivo
que mantém a CPU ocupada, você quer movê-lo para um
`Isolate` para evitar bloquear o loop de eventos.

Para trabalho bound a I/O, declare a função como uma função `async`,
e faça `await` em tarefas de longa duração dentro da função:

<?code-excerpt "lib/async.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

É assim que você tipicamente faz chamadas de rede ou banco de dados,
que são ambas operações de I/O.

No entanto, há momentos em que você pode estar processando
uma grande quantidade de dados e sua UI trava.
No Flutter, use `Isolate`s para tirar proveito de
múltiplos núcleos de CPU para fazer tarefas de longa duração ou
computacionalmente intensivas.

Isolates são threads de execução separadas que não compartilham
nenhuma memória com o heap de memória de execução principal.
Isso significa que você não pode acessar variáveis da thread principal,
ou atualizar sua UI chamando `setState()`.
Isolates são verdadeiros ao seu nome, e não podem compartilhar memória
(na forma de campos estáticos, por exemplo).

O exemplo a seguir mostra, em um isolate simples,
como compartilhar dados de volta para a thread principal para atualizar a UI.

<?code-excerpt "lib/isolates.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // The 'echo' isolate sends its SendPort as the first message.
  final SendPort sendPort = await receivePort.first as SendPort;

  final List<Map<String, dynamic>> msg = await sendReceive(
    sendPort,
    'https://jsonplaceholder.typicode.com/posts',
  );

  setState(() {
    data = msg;
  });
}

// The entry point for the isolate.
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
(analisando um JSON grande, por exemplo),
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

    // The 'echo' isolate sends its SendPort as the first message.
    final SendPort sendPort = await receivePort.first as SendPort;

    final List<Map<String, dynamic>> msg = await sendReceive(
      sendPort,
      'https://jsonplaceholder.typicode.com/posts',
    );

    setState(() {
      data = msg;
    });
  }

  // The entry point for the isolate.
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
    bool showLoadingDialog = data.isEmpty;

    if (showLoadingDialog) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  Widget getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, position) {
        return getRow(position);
      },
    );
  }

  Widget getRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Row ${data[i]["title"]}"),
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

### Fazendo requisições de rede

Fazer uma chamada de rede no Flutter é fácil quando você
usa o popular [pacote `http`][`http` package]. Isto abstrai
muito do trabalho de rede que você normalmente
implementaria você mesmo, tornando simples fazer chamadas de rede.

Para adicionar o pacote `http` como uma dependência, execute `flutter pub add`:

```console
flutter pub add http
```

Para fazer uma chamada de rede,
chame `await` na função `async` `http.get()`:

<?code-excerpt "lib/progress.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

### Mostrando o progresso em tarefas de longa duração

No UIKit, você tipicamente usa uma `UIProgressView`
enquanto executa uma tarefa de longa duração em segundo plano.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando
quando ele é renderizado através de uma flag booleana.
Diga ao Flutter para atualizar seu estado antes que sua tarefa de longa duração comece,
e esconda-o após terminar.

No exemplo abaixo, a função build é separada em três funções diferentes.
Se `showLoadingDialog` é `true`
(quando `widgets.length == 0`), então renderize o `ProgressIndicator`.
Caso contrário, renderize a `ListView` com os dados retornados de uma chamada de rede.

<?code-excerpt "lib/progress.dart"?>
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

  Widget getRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Row ${data[i]["title"]}"),
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

[Flutter for SwiftUI developers]: /get-started/flutter-for/swiftui-devs
[Add Flutter to existing app]: /add-to-app
[Adding Assets and Images in Flutter]: /ui/assets/assets-and-images
[Animation & Motion widgets]: /ui/widgets/animation
[Animations overview]: /ui/animations
[Animations tutorial]: /ui/animations/tutorial
[Apple's iOS design language]: {{site.apple-dev}}/design/resources
[`AppLifecycleState` documentation]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html
[arb]: {{site.github}}/googlei18n/app-resource-bundle
[`AssetBundle`]: {{site.api}}/flutter/services/AssetBundle-class.html
[composing]: /resources/architectural-overview#composition
[Cupertino library]: {{site.api}}/flutter/cupertino/cupertino-library.html
[Cupertino widgets]: /ui/widgets/cupertino
[`devicePixelRatio`]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[existing plugin]: {{site.pub}}/flutter
[Flutter concurrency for Swift developers]: /get-started/flutter-for/dart-swift-concurrency
[`http` package]: {{site.pub-pkg}}/http
[Human Interface Guidelines]: {{site.apple-dev}}/ios/human-interface-guidelines/overview/themes/
[internationalization guide]: /ui/internationalization
[`intl`]: {{site.pub-pkg}}/intl
[`intl_translation`]: {{site.pub-pkg}}/intl_translation
[Introduction to declarative UI]: /get-started/flutter-for/declarative
[layout tutorial]: /ui/widgets/layout
[`Localizations`]: {{site.api}}/flutter/widgets/Localizations-class.html
[Material Components]: {{site.material}}/develop/flutter/
[Material Design guidelines]: {{site.material}}/styles/
[optimized for all platforms]: {{site.material2}}/design/platform-guidance/cross-platform-adaptation.html#cross-platform-guidelines
[Platform adaptations]: /platform-integration/platform-adaptations
[platform channel]: /platform-integration/platform-channels
[pub.dev]: {{site.pub}}/flutter/packages
[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[widget]: /resources/architectural-overview#widgets
[widget catalog]: /ui/widgets/layout
[`Window.locale`]: {{site.api}}/flutter/dart-ui/Window/locale.html
[Learning Dart as a Swift Developer]: {{site.dart-site}}/guides/language/coming-from/swift-to-dart
