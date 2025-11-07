---
ia-translate: true
title: Flutter para desenvolvedores UIKit
description: Aprenda como aplicar conhecimento de desenvolvimento iOS e UIKit ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/ios_devs"?>

Desenvolvedores iOS com experiência usando UIKit
que querem escrever apps mobile usando Flutter
devem revisar este guia.
Ele explica como aplicar conhecimento existente de UIKit ao Flutter.

:::note
Se você tem experiência construindo apps com SwiftUI,
confira [Flutter for SwiftUI developers][] ao invés.
:::

Flutter é um framework para construir aplicações cross-platform
que usa a linguagem de programação Dart.
Para entender algumas diferenças entre programar com Dart
e programar com Swift,
confira [Learning Dart as a Swift Developer][]
e [Flutter concurrency for Swift developers][].

Seu conhecimento e experiência com iOS e UIKit
são altamente valiosos ao construir com Flutter.
{% comment %}
  TODO: Add talk about plugin system for interacting with OS and hardware
  when [iOS and Apple hardware interactions with Flutter][] is released.
{% endcomment -%}

Flutter também faz uma série de adaptações
ao comportamento do app quando rodando no iOS.
Para aprender como, veja [Platform adaptations][].

:::tip
Para integrar código Flutter em um app iOS **existente**,
confira [Add Flutter to existing app][].
:::

Use este guia como um livro de receitas.
Pule por aí e encontre questões que abordem suas necessidades mais relevantes.

## Overview

Como introdução, assista ao seguinte vídeo.
Ele delineia como o Flutter funciona no iOS e como usar Flutter para construir apps iOS.

{% ytEmbed 'ceMsPBbcEGg', 'Flutter for iOS developers', false, true %}

### Views vs. Widgets

:::secondary
Como a programação estilo-react, ou _declarativa_,
é diferente do estilo imperativo tradicional?
Para uma comparação, veja [Introduction to declarative UI][].
:::

No UIKit, a maior parte do que você cria na UI é feita usando objetos view,
que são instâncias da classe `UIView`.
Estas podem atuar como contêineres para outras classes `UIView`,
que formam seu layout.

No Flutter, o equivalente aproximado de uma `UIView` é um `Widget`.
Widgets não mapeiam exatamente para views iOS,
mas enquanto você está se familiarizando com como o Flutter funciona
você pode pensar neles como "a maneira como você declara e constrói UI".

No entanto, estes têm algumas diferenças em relação a uma `UIView`.
Para começar, widgets têm um ciclo de vida diferente: eles são imutáveis
e só existem até que precisem ser alterados.
Sempre que widgets ou seu estado mudam,
o framework do Flutter cria uma nova árvore de instâncias de widget.
Em comparação, uma view UIKit não é recriada quando muda,
mas sim é uma entidade mutável que é desenhada uma vez
e não redesenha até ser invalidada usando `setNeedsDisplay()`.

Além disso, diferente de `UIView`, os widgets do Flutter são leves,
em parte devido à sua imutabilidade.
Porque eles não são views por si mesmos,
e não estão desenhando nada diretamente,
mas sim são uma descrição da UI e sua semântica
que são "inflados" em objetos view reais nos bastidores.

Flutter inclui a biblioteca [Material Components][].
Estes são widgets que implementam as
[Material Design guidelines][].
Material Design é um sistema de design flexível
[optimized for all platforms][], incluindo iOS.

Mas Flutter é flexível e expressivo o suficiente
para implementar qualquer linguagem de design.
No iOS, você pode usar a biblioteca [Cupertino widgets][]
para produzir uma interface que se parece com a
[Apple's iOS design language][].

### Atualizando widgets

Para atualizar suas views no UIKit, você as muta diretamente.
No Flutter, widgets são imutáveis e não são atualizados diretamente.
Ao invés, você tem que manipular o estado do widget.

É aqui que entra o conceito de widgets Stateful vs Stateless.
Um `StatelessWidget` é exatamente o que parece&mdash;um widget sem estado anexado.

`StatelessWidgets` são úteis quando a parte da interface de usuário que você está
descrevendo não depende de nada além das informações de configuração inicial
no widget.

Por exemplo, com UIKit, isso é similar a colocar uma `UIImageView`
com seu logo como a `image`. Se o logo não está mudando durante runtime,
use um `StatelessWidget` no Flutter.

Se você quer mudar dinamicamente a UI baseado em dados recebidos
após fazer uma chamada HTTP, use um `StatefulWidget`.
Após a chamada HTTP ter completado, diga ao framework Flutter
que o `State` do widget foi atualizado, para que ele possa atualizar a UI.

A diferença importante entre widgets stateless e
stateful é que `StatefulWidget`s têm um objeto `State`
que armazena dados de estado e os carrega através de reconstruções da árvore,
para que não sejam perdidos.

Se você estiver em dúvida, lembre-se desta regra:
se um widget muda fora do método `build`
(por causa de interações de usuário em runtime, por exemplo),
ele é stateful.
Se o widget nunca muda, uma vez construído, ele é stateless.
No entanto, mesmo se um widget é stateful, o widget pai contêiner
ainda pode ser stateless se ele mesmo não está reagindo àquelas mudanças
(ou outras entradas).

O exemplo seguinte mostra como usar um `StatelessWidget`.
Um `StatelessWidget` comum é o widget `Text`.
Se você olhar a implementação do widget `Text`,
você verá que ele faz subclasse de `StatelessWidget`.

<?code-excerpt "lib/text_widget.dart (text-widget)" replace="/return const //g"?>
```dart
Text(
  'I like Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Se você olhar o código acima, você pode notar que o widget `Text`
não carrega nenhum estado explícito com ele. Ele renderiza o que é passado em seus
construtores e nada mais.

Mas, e se você quiser fazer "I Like Flutter" mudar dinamicamente,
por exemplo ao clicar em um `FloatingActionButton`?

Para alcançar isso, envolva o widget `Text` em um `StatefulWidget` e
atualize-o quando o usuário clicar no botão.

Por exemplo:

<?code-excerpt "lib/text_widget.dart (stateful-widget)"?>
```dart

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
para organizar suas views e definir constraints,
ou pode definir suas constraints programaticamente em seus view controllers.
No Flutter, declare seu layout em código compondo uma árvore de widgets.

O exemplo seguinte mostra como exibir um widget simples com padding:

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
o que imita a funcionalidade de constraints no iOS.

Você pode visualizar os layouts que o Flutter tem a oferecer
no [widget catalog][].

### Removendo Widgets

No UIKit, você chama `addSubview()` no pai,
ou `removeFromSuperview()` em uma view filha
para adicionar ou remover views filhas dinamicamente.
No Flutter, porque widgets são imutáveis,
não há equivalente direto para `addSubview()`.
Ao invés, você pode passar uma função ao pai
que retorna um widget, e controlar a criação daquele filho
com uma flag booleana.

O exemplo seguinte mostra como alternar entre dois widgets
quando o usuário clica no `FloatingActionButton`:

<?code-excerpt "lib/layout.dart (toggle-widget)"?>
```dart
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

    return CupertinoButton(
      onPressed: () {},
      child: const Text('Toggle Two'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: Center(
        child: _getToggleChild(),
      ),
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
entre 0 e 1 em cada frame enquanto está rodando.
Você então cria uma ou mais
`Animation`s e as anexa ao controller.

Por exemplo, você pode usar `CurvedAnimation`
para implementar uma animação ao longo de uma curva interpolada.
Neste sentido, o controller é a fonte "mestre"
do progresso da animação
e o `CurvedAnimation` computa a curva
que substitui o movimento linear padrão do controller.
Como widgets, animações no Flutter funcionam com composição.

Ao construir a árvore de widgets você atribui a `Animation` a uma propriedade
animada de um widget, como a opacidade de um `FadeTransition`,
e diz ao controller para iniciar a animação.

O exemplo seguinte mostra como escrever um `FadeTransition` que
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
    curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
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

Para mais informações, veja [Animation & Motion widgets][],
o [Animations tutorial][], e a [Animations overview][].

### Desenhando na tela

No UIKit, você usa `CoreGraphics` para desenhar linhas e formas na
tela. Flutter tem uma API diferente baseada na classe `Canvas`,
com duas outras classes que ajudam você a desenhar: `CustomPaint` e `CustomPainter`,
sendo a última que implementa seu algoritmo para desenhar no canvas.

Para aprender como implementar um signature painter no Flutter,
veja a resposta do Collin no [StackOverflow][].

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
          Offset localPosition =
              referenceBox.globalToLocal(details.globalPosition);
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

### Widgets Personalizados

No UIKit, você tipicamente faz subclasse de `UIView`, ou usa uma view pré-existente,
para sobrescrever e implementar métodos que alcançam o comportamento desejado.
No Flutter, construa um widget personalizado [composing][] widgets menores
(ao invés de estendê-los).

Por exemplo, como você constrói um `CustomButton`
que recebe um label no construtor?
Crie um CustomButton que compõe um `ElevatedButton` com um label,
ao invés de estender `ElevatedButton`:

<?code-excerpt "lib/custom.dart (custom-button)"?>
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

Então use `CustomButton`,
assim como você usaria qualquer outro widget Flutter:

<?code-excerpt "lib/custom.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(
    child: CustomButton('Hello'),
  );
}
```

### Gerenciando dependências

No iOS, você adiciona dependências com CocoaPods adicionando ao seu `Podfile`.
Flutter usa o sistema de build do Dart e o gerenciador de pacotes Pub
para lidar com dependências. As ferramentas delegam a construção dos
apps wrapper nativos Android e iOS para os
respectivos sistemas de build.

Embora exista um Podfile na pasta iOS no seu
projeto Flutter, use-o apenas se você estiver adicionando
dependências nativas necessárias para integração por plataforma.
Em geral, use `pubspec.yaml` para declarar dependências externas no Flutter.
Um bom lugar para encontrar ótimos pacotes para Flutter é no [pub.dev][].

## Navegação

Esta seção do documento discute navegação
entre páginas de um app, o mecanismo de push e pop, e mais.

### Navegando entre páginas

No UIKit, para viajar entre view controllers, você pode usar um
`UINavigationController` que gerencia a pilha de view controllers
para exibir.

Flutter tem uma implementação similar,
usando um `Navigator` e `Routes`.
Uma `Route` é uma abstração para uma "screen" ou "page" de um app,
e um `Navigator` é um [widget][]
que gerencia routes. Uma route mapeia aproximadamente para um
`UIViewController`. O navigator funciona de maneira similar ao
`UINavigationController` do iOS, em que ele pode fazer `push()` e `pop()`
de routes dependendo se você quer navegar para, ou voltar de, uma view.

Para navegar entre páginas, você tem algumas opções:

* Especificar um `Map` de nomes de route.
* Navegar diretamente para uma route.

O exemplo seguinte constrói um `Map.`

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

Navegue para uma route fazendo `push` do seu nome para o `Navigator`.

<?code-excerpt "lib/intent.dart (push)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

A classe `Navigator` lida com roteamento no Flutter e é usada para obter
um resultado de volta de uma route que você fez push na pilha.
Isso é feito fazendo `await` no `Future` retornado por `push()`.

Por exemplo, para iniciar uma route `location` que permite ao usuário selecionar sua
localização, você pode fazer o seguinte:

<?code-excerpt "lib/intent.dart (push-await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro de sua route `location`, uma vez que o usuário selecionou sua
localização, faça `pop()` na pilha com o resultado:

<?code-excerpt "lib/intent.dart (pop)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

### Navegando para outro app

No UIKit, para enviar o usuário para outra aplicação,
você usa um esquema de URL específico.
Para apps de nível de sistema, o esquema depende do app.
Para implementar esta funcionalidade no Flutter,
crie uma integração de plataforma nativa, ou use um
[existing plugin][], como [`url_launcher`][].

### Fazendo pop back manualmente

Chamar `SystemNavigator.pop()` do seu código Dart
invoca o seguinte código iOS:

```objc
UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
if ([viewController isKindOfClass:[UINavigationController class]]) {
  [((UINavigationController*)viewController) popViewControllerAnimated:NO];
}
```

Se isso não fizer o que você quer, você pode criar seu próprio
[platform channel][] para invocar código iOS arbitrário.

### Lidando com localização

Diferente do iOS, que tem o arquivo `Localizable.strings`,
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

Por padrão, Flutter suporta apenas inglês americano para suas strings.
Se você precisa adicionar suporte para outras línguas,
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
`supportedLocales` no widget app:

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

The delegates contain the actual localized values,
while the `supportedLocales` defines which locales the app supports.
The above example uses a `MaterialApp`,
so it has both a `GlobalWidgetsLocalizations`
for the base widgets localized values,
and a `MaterialWidgetsLocalizations` for the Material widgets localizations.
If you use `WidgetsApp` for your app, you don't need the latter.
Note that these two delegates contain "default" values,
but you'll need to provide one or more delegates
for your own app's localizable copy,
if you want those to be localized too.

When initialized, the `WidgetsApp` (or `MaterialApp`)
creates a [`Localizations`][] widget for you,
with the delegates you specify.
The current locale for the device is always accessible
from the `Localizations` widget from the current context
(in the form of a `Locale` object), or using the [`Window.locale`][].

To access localized resources, use the `Localizations.of()` method
to access a specific localizations class that is provided by a given delegate.
Use the [`intl_translation`][] package to extract translatable copy
to [arb][] files for translating, and importing them back into the app
for using them with `intl`.

For further details on internationalization and localization in Flutter,
see the [internationalization guide][], which has sample code
with and without the `intl` package.

## ViewControllers

This section of the document discusses the equivalent
of ViewController in Flutter and how to listen to
lifecycle events.

### Equivalent of ViewController in Flutter

In UIKit, a `ViewController` represents a portion of user interface,
most commonly used for a screen or section.
These are composed together to build complex user interfaces,
and help scale your application's UI.
In Flutter, this job falls to Widgets.
As mentioned in the Navigation section,
screens in Flutter are represented by Widgets since
"everything is a widget!"
Use a `Navigator` to move between different `Route`s
that represent different screens or pages,
or maybe different states or renderings of the same data.

### Listening to lifecycle events

In UIKit, you can override methods to the `ViewController`
to capture lifecycle methods for the view itself,
or register lifecycle callbacks in the `AppDelegate`.
In Flutter, you have neither concept, but you can instead
listen to lifecycle events by hooking into
the `WidgetsBinding` observer and listening to
the `didChangeAppLifecycleState()` change event.

The observable lifecycle events are:

**`inactive`**
: The application is in an inactive state and is not receiving
user input. This event only works on iOS,
as there is no equivalent event on Android.

**`paused`**
: The application is not currently visible to the user,
is not responding to user input, but is running in the background.

**`resumed`**
: The application is visible and responding to user input.

**`suspending`**
: The application is suspended momentarily.
The iOS platform has no equivalent event.

For more details on the meaning of these states, see
[`AppLifecycleState` documentation][].

## Layouts

This section discusses different layouts in Flutter
and how they compare with UIKit.

### Displaying a list view

In UIKit, you might show a list in
either a `UITableView` or a `UICollectionView`.
In Flutter, you have a similar implementation using a `ListView`.
In UIKit, these views have delegate methods
for deciding the number of rows,
the cell for each index path, and the size of the cells.

Due to Flutter's immutable widget pattern,
you pass a list of widgets to your `ListView`,
and Flutter takes care of making sure that
scrolling is fast and smooth.

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
    final List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $i'),
      ));
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: ListView(children: _getListData()),
    );
  }
}
```

### Detecting what was clicked

In UIKit, you implement the delegate method,
`tableView:didSelectRowAtIndexPath:`.
In Flutter, use the touch handling provided by the passed-in widgets.

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
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: ListView(children: _getListData()),
    );
  }
}
```

### Dynamically updating ListView

In UIKit, you update the data for the list view,
and notify the table or collection view using the
`reloadData` method.

In Flutter, if you update the list of widgets inside a `setState()`,
you quickly see that your data doesn't change visually.
This is because when `setState()` is called,
the Flutter rendering engine looks at the widget tree
to see if anything has changed.
When it gets to your `ListView`, it performs an `==` check,
and determines that the two `ListView`s are the same.
Nothing has changed, so no update is required.

For a simple way to update your `ListView`,
create a new `List` inside of `setState()`,
and copy the data from the old list to the new list.
While this approach is simple,
it is not recommended for large data sets,
as shown in the next example.

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

  Widget getRow(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets = List.from(widgets);
          widgets.add(getRow(widgets.length));
          developer.log('row $i');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $i'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: ListView(children: widgets),
    );
  }
}
```

The recommended, efficient,
and effective way to build a list uses a `ListView.Builder`.
This method is great when you have a dynamic
list or a list with very large amounts of data.

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

  Widget getRow(int i) {
    return GestureDetector(
      onTap: () {
        setState(() {
          widgets.add(getRow(widgets.length));
          developer.log('row $i');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $i'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
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

Instead of creating a `ListView`, create a `ListView.builder`
that takes two key parameters: the initial length of the list,
and an `ItemBuilder` function.

The `ItemBuilder` function is similar to the `cellForItemAt`
delegate method in an iOS table or collection view,
as it takes a position, and returns the
cell you want rendered at that position.

Finally, but most importantly, notice that the `onTap()` function
doesn't recreate the list anymore, but instead `.add`s to it.

### Creating a scroll view

In UIKit, you wrap your views in a `ScrollView` that
allows a user to scroll your content if needed.

In Flutter the easiest way to do this is using the `ListView` widget.
This acts as both a `ScrollView` and an iOS `TableView`,
as you can lay out widgets in a vertical format.

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

For more detailed docs on how to lay out widgets in Flutter,
see the [layout tutorial][].

## Gesture detection and touch event handling

This section discusses how to detect gestures
and handle different events in Flutter,
and how they compare with UIKit.

### Adding a click listener

In UIKit, you attach a `GestureRecognizer` to a view to
handle click events.
In Flutter, there are two ways of adding touch listeners:

1. If the widget supports event detection, pass a function to it,
   and handle the event in the function. For example, the
   `ElevatedButton` widget has an `onPressed` parameter:

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

2. If the Widget doesn't support event detection,
   wrap the widget in a GestureDetector and pass a function
   to the `onTap` parameter.

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
            child: const FlutterLogo(
              size: 200,
            ),
          ),
        ),
      );
    }
  }
   ```

### Handling other gestures

Using `GestureDetector` you can listen
to a wide range of gestures such as:

* **Tapping**

  **`onTapDown`**
  : A pointer that might cause a tap has contacted the
  screen at a particular location.

  **`onTapUp`**
  : A pointer that triggers a tap has stopped contacting the
  screen at a particular location.

  **`onTap`**
  : A tap has occurred.

  **`onTapCancel`**
  : The pointer that previously triggered the `onTapDown`
  won't cause a tap.

* **Double tapping**

  **`onDoubleTap`**
  : The user tapped the screen at the same location twice in
  quick succession.

* **Long pressing**

  **`onLongPress`**
  : A pointer has remained in contact with the screen
  at the same location for a long period of time.

* **Vertical dragging**

  **`onVerticalDragStart`**
  : A pointer has contacted the screen and might begin to
  move vertically.

  **`onVerticalDragUpdate`**
  : A pointer in contact with the screen
  has moved further in the vertical direction.

  **`onVerticalDragEnd`**
  : A pointer that was previously in contact with the
  screen and moving vertically is no longer in contact
  with the screen and was moving at a specific velocity
  when it stopped contacting the screen.

* **Horizontal dragging**

  **`onHorizontalDragStart`**
  : A pointer has contacted the screen and might begin
  to move horizontally.

  **`onHorizontalDragUpdate`**
  : A pointer in contact with the screen
  has moved further in the horizontal direction.

  **`onHorizontalDragEnd`**
  : A pointer that was previously in contact with the
  screen and moving horizontally is no longer in
  contact with the screen.

The following example shows a `GestureDetector`
that rotates the Flutter logo on a double tap:

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
    curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
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
            child: const FlutterLogo(
              size: 200,
            ),
          ),
        ),
      ),
    );
  }
}
```

## Themes, styles, and media

Flutter applications are easy to style; you can switch
between light and dark themes,
change the style of your text and UI components,
and more. This section covers aspects of styling your Flutter apps
and compares how you might do the same in UIKit.

### Using a theme

Out of the box, Flutter comes with a beautiful implementation
of Material Design, which takes care of a lot of styling and
theming needs that you would typically do.

To take full advantage of Material Components in your app,
declare a top-level widget, `MaterialApp`,
as the entry point to your application.
`MaterialApp` is a convenience widget that wraps a number
of widgets that are commonly required for applications
implementing Material Design.
It builds upon a `WidgetsApp` by adding Material specific functionality.

But Flutter is flexible and expressive enough to implement
any design language. On iOS, you can use the
[Cupertino library][] to produce an interface that adheres to the
[Human Interface Guidelines][].
For the full set of these widgets,
see the [Cupertino widgets][] gallery.

You can also use a `WidgetsApp` as your app widget,
which provides some of the same functionality,
but is not as rich as `MaterialApp`.

To customize the colors and styles of any child components,
pass a `ThemeData` object to the `MaterialApp` widget.
For example, in the code below,
the color scheme from seed is set to deepPurple and divider color is grey.

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

### Using custom fonts

In UIKit, you import any `ttf` font files into your project
and create a reference in the `info.plist` file.
In Flutter, place the font file in a folder
and reference it in the `pubspec.yaml` file,
similar to how you import images.

```yaml
fonts:
  - family: MyCustomFont
    fonts:
      - asset: fonts/MyCustomFont.ttf
      - style: italic
```

Then assign the font to your `Text` widget:

<?code-excerpt "lib/text.dart (custom-font)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sample App'),
    ),
    body: const Center(
      child: Text(
        'This is a custom font text',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
```

### Styling text

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

### Bundling images in apps

While iOS treats images and assets as distinct items,
Flutter apps have only assets. Resources that are
placed in the `Images.xcasset` folder on iOS,
are placed in an assets' folder for Flutter.
As with iOS, assets are any type of file, not just images.
For example, you might have a JSON file located in the `my-assets` folder:

```plaintext
my-assets/data.json
```

Declare the asset in the `pubspec.yaml` file:

```yaml
assets:
 - my-assets/data.json
```

And then access it from code using an [`AssetBundle`][]:

<?code-excerpt "lib/asset_bundle.dart"?>
```dart
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
```

For images, Flutter follows a simple density-based format like iOS.
Image assets might be `1.0x`, `2.0x`, `3.0x`, or any other multiplier.
Flutter's [`devicePixelRatio`][] expresses the ratio
of physical pixels in a single logical pixel.

Assets are located in any arbitrary folder&mdash;
Flutter has no predefined folder structure.
You declare the assets (with location) in
the `pubspec.yaml` file, and Flutter picks them up.

For example, to add an image called `my_icon.png` to your Flutter
project, you might decide to store it in a folder arbitrarily called `images`.
Place the base image (1.0x) in the `images` folder, and the
other variants in sub-folders named after the appropriate ratio multiplier:

```plaintext
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

Next, declare these images in the `pubspec.yaml` file:

```yaml
assets:
 - images/my_icon.png
```

You can now access your images using `AssetImage`:

<?code-excerpt "lib/images.dart (asset-image)"?>
```dart
image: AssetImage('images/a_dot_burr.png'),
```

or directly in an `Image` widget:

<?code-excerpt "lib/images.dart (image-asset)"?>
```dart
@override
Widget build(BuildContext context) {
  return Image.asset('images/my_image.png');
}
```

For more details, see
[Adding Assets and Images in Flutter][].

## Form input

This section discusses how to use forms in Flutter
and how they compare with UIKit.

### Retrieving user input

Given how Flutter uses immutable widgets with a separate state,
you might be wondering how user input fits into the picture.
In UIKit, you usually query the widgets for their current values
when it's time to submit the user input, or action on it.
How does that work in Flutter?

In practice forms are handled, like everything in Flutter,
by specialized widgets. If you have a `TextField` or a
`TextFormField`, you can supply a [`TextEditingController`][]
to retrieve user input:

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

You can find more information and the full code listing in
[Retrieve the value of a text field][],
from the [Flutter cookbook][].

### Placeholder in a text field

In Flutter, you can easily show a "hint" or a placeholder text
for your field by adding an `InputDecoration` object
to the decoration constructor parameter for the `Text` widget:

<?code-excerpt "lib/form.dart (input-hint)" replace="/return const //g;/;//g"?>
```dart
Center(
  child: TextField(
    decoration: InputDecoration(hintText: 'This is a hint'),
  ),
)
```

### Showing validation errors

Just as you would with a "hint", pass an `InputDecoration` object
to the decoration constructor for the `Text` widget.

However, you don't want to start off by showing an error.
Instead, when the user has entered invalid data,
update the state, and pass a new `InputDecoration` object.

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
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
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

## Threading & asynchronicity

This section discusses concurrency in Flutter and
how it compares with UIKit.

### Writing asynchronous code

Dart has a single-threaded execution model,
with support for `Isolate`s
(a way to run Dart code on another thread),
an event loop, and asynchronous programming.
Unless you spawn an `Isolate`,
your Dart code runs in the main UI thread and is
driven by an event loop. Flutter's event loop is
equivalent to the iOS main loop&mdash;that is,
the `Looper` that is attached to the main thread.

Dart's single-threaded model doesn't mean you are
required to run everything as a blocking operation
that causes the UI to freeze. Instead,
use the asynchronous facilities that the Dart language provides,
such as `async`/`await`, to perform asynchronous work.

For example, you can run network code without causing the
UI to hang by using `async`/`await` and letting Dart do
the heavy lifting:

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

Once the `await`ed network call is done,
update the UI by calling `setState()`,
which triggers a rebuild of the widget subtree
and updates the data.

The following example loads data asynchronously and
displays it in a `ListView`:

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
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
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

Refer to the next section for more information on doing work
in the background, and how Flutter differs from iOS.

### Moving to the background thread

Since Flutter is single threaded and runs an event loop
(like Node.js), you don't have to worry about
thread management or spawning background threads.
If you're doing I/O-bound work,
such as disk access or a network call,
then you can safely use `async`/`await` and you're done.
If, on the other hand, you need to do computationally intensive
work that keeps the CPU busy, you want to move it to an
`Isolate` to avoid blocking the event loop.

For I/O-bound work, declare the function as an `async` function,
and `await` on long-running tasks inside the function:

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

This is how you typically do network or database calls,
which are both I/O operations.

However, there are times when you might be processing
a large amount of data and your UI hangs.
In Flutter, use `Isolate`s to take advantage of
multiple CPU cores to do long-running or
computationally intensive tasks.

Isolates are separate execution threads that do not share
any memory with the main execution memory heap.
This means you can't access variables from the main thread,
or update your UI by calling `setState()`.
Isolates are true to their name, and cannot share memory
(in the form of static fields, for example).

The following example shows, in a simple isolate,
how to share data back to the main thread to update the UI.

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

Here, `dataLoader()` is the `Isolate` that runs in
its own separate execution thread.
In the isolate, you can perform more CPU intensive
processing (parsing a big JSON, for example),
or perform computationally intensive math,
such as encryption or signal processing.

You can run the full example below:

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
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: getBody(),
    );
  }
}
```

### Making network requests

Making a network call in Flutter is easy when you
use the popular [`http` package][]. This abstracts
away a lot of the networking that you might normally
implement yourself, making it simple to make network calls.

To add the `http` package as a dependency, run `flutter pub add`:

```console
flutter pub add http
```

To make a network call,
call `await` on the `async` function `http.get()`:

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

### Showing the progress on long-running tasks

In UIKit, you typically use a `UIProgressView`
while executing a long-running task in the background.

In Flutter, use a `ProgressIndicator` widget.
Show the progress programmatically by controlling
when it's rendered through a boolean flag.
Tell Flutter to update its state before your long-running task starts,
and hide it after it ends.

In the example below, the build function is separated into three different
functions. If `showLoadingDialog` is `true`
(when `widgets.length == 0`), then render the `ProgressIndicator`.
Otherwise, render the `ListView` with the data returned from a network call.

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
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
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
[Flutter cookbook]: /cookbook
[`http` package]: {{site.pub-pkg}}/http
[Human Interface Guidelines]: {{site.apple-dev}}/ios/human-interface-guidelines/overview/themes/
[internationalization guide]: /ui/accessibility-and-internationalization/internationalization
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
