---
ia-translate: true
title: Flutter para desenvolvedores Android
description: Aprenda como aplicar conhecimento de desenvolvimento Android ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/android_devs"?>

Este documento é destinado a desenvolvedores Android que buscam aplicar seu
conhecimento existente em Android para construir apps mobile com Flutter.
Se você entende os fundamentos do framework Android, então você
pode usar este documento como um ponto de partida para o desenvolvimento Flutter.

:::note
Para integrar código Flutter em seu app Android, veja
[Add Flutter to existing app][].
:::

Seu conhecimento e conjunto de habilidades em Android são altamente valiosos ao construir com
Flutter, porque o Flutter depende do sistema operacional mobile para numerosas
capacidades e configurações. Flutter é uma nova maneira de construir UIs para mobile,
mas possui um sistema de plugins para se comunicar com Android (e iOS) para tarefas
não relacionadas à UI. Se você é um especialista em Android, você não precisa reaprender tudo
para usar Flutter.

Este documento pode ser usado como um livro de receitas pulando por aí e
encontrando questões que são mais relevantes às suas necessidades.

## Views

### Qual é o equivalente de uma View no Flutter?

:::secondary
Como a programação estilo-react, ou _declarativa_, é diferente do
estilo imperativo tradicional?
Para uma comparação, veja [Introduction to declarative UI][].
:::

No Android, a `View` é a fundação de tudo que aparece na
tela. Botões, toolbars e inputs, tudo é uma View.
No Flutter, o equivalente aproximado de uma `View` é um `Widget`.
Widgets não mapeiam exatamente para views Android, mas enquanto você está se
familiarizando com como o Flutter funciona você pode pensar neles como
"a maneira como você declara e constrói UI".

No entanto, eles têm algumas diferenças em relação a uma `View`. Para começar, widgets têm um
tempo de vida diferente: eles são imutáveis e só existem até que precisem ser
alterados. Sempre que widgets ou seu estado mudam, o framework do Flutter cria
uma nova árvore de instâncias de widget. Em comparação, uma view Android é desenhada uma vez
e não redesenha até que `invalidate` seja chamado.

Os widgets do Flutter são leves, em parte devido à sua imutabilidade.
Porque eles não são views em si, e não estão desenhando nada diretamente,
mas sim são uma descrição da UI e sua semântica que são "inflados"
em objetos view reais nos bastidores.

Flutter inclui a biblioteca [Material Components][].
Estes são widgets que implementam as
[Material Design guidelines][]. Material Design é um
sistema de design flexível [optimized for all platforms][],
incluindo iOS.

Mas o Flutter é flexível e expressivo o suficiente para implementar qualquer linguagem de design.
Por exemplo, no iOS, você pode usar os [Cupertino widgets][]
para produzir uma interface que se parece com [Apple's iOS design language][].

### Como eu atualizo widgets?

No Android, você atualiza suas views mutando-as diretamente. No entanto,
no Flutter, `Widget`s são imutáveis e não são atualizados diretamente,
em vez disso você tem que trabalhar com o estado do widget.

É aí que vem o conceito de widgets `Stateful` e `Stateless`.
Um `StatelessWidget` é exatamente o que parece&mdash;um
widget sem informação de estado.

`StatelessWidgets` são úteis quando a parte da interface do usuário
que você está descrevendo não depende de nada além das informações de configuração
no objeto.

Por exemplo, no Android, isso é similar a colocar um `ImageView`
com seu logo. O logo não vai mudar durante o runtime,
então use um `StatelessWidget` no Flutter.

Se você quer mudar a UI dinamicamente baseado em dados recebidos
após fazer uma chamada HTTP ou interação do usuário então você tem que trabalhar
com `StatefulWidget` e dizer ao framework Flutter que o
`State` do widget foi atualizado para que ele possa atualizar aquele widget.

A coisa importante a notar aqui é que no núcleo ambos widgets stateless e stateful
se comportam da mesma forma. Eles reconstroem a cada frame, a diferença é que o
`StatefulWidget` tem um objeto `State` que armazena dados de estado entre frames
e os restaura.

Se você está em dúvida, então sempre lembre desta regra: se um widget muda
(por causa de interações do usuário, por exemplo) ele é stateful.
No entanto, se um widget reage à mudança, o widget pai que o contém ainda pode
ser stateless se ele mesmo não reage à mudança.

O exemplo a seguir mostra como usar um `StatelessWidget`. Um
`StatelessWidget` comum é o widget `Text`. Se você olhar a implementação do
widget `Text` você verá que ele faz subclasse de `StatelessWidget`.

<?code-excerpt "lib/text_widget.dart (text-widget)" replace="/return const //g"?>
```dart
Text(
  'I like Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Como você pode ver, o Widget `Text` não tem informação de estado associada a ele,
ele renderiza o que é passado em seus construtores e nada mais.

Mas, e se você quiser fazer "I Like Flutter" mudar dinamicamente, por
exemplo ao clicar em um `FloatingActionButton`?

Para alcançar isso, envolva o widget `Text` em um `StatefulWidget` e
atualize-o quando o usuário clicar no botão.

Por exemplo:

<?code-excerpt "lib/text_widget.dart (stateful-widget)"?>
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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Default placeholder text.
  String textToShow = 'I Like Flutter';

  void _updateText() {
    setState(() {
      // Update the text.
      textToShow = 'Flutter is Awesome!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
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

### Como eu faço o layout dos meus widgets? Onde está meu arquivo de layout XML?

No Android, você escreve layouts em XML, mas no Flutter você escreve seus layouts
com uma árvore de widgets.

O exemplo a seguir mostra como exibir um widget simples com padding:

<?code-excerpt "lib/layout.dart (simple-widget)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Sample App'),
    ),
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

Você pode ver alguns dos layouts que o Flutter tem a oferecer no
[widget catalog][].

### Como eu adiciono ou removo um componente do meu layout?

No Android, você chama `addChild()` ou `removeChild()`
em um pai para adicionar ou remover views filhas dinamicamente.
No Flutter, porque widgets são imutáveis não há
equivalente direto para `addChild()`. Em vez disso,
você pode passar uma função ao pai que retorna um widget,
e controlar a criação daquele filho com uma flag booleana.

Por exemplo, aqui está como você pode alternar entre dois
widgets quando você clica em um `FloatingActionButton`:

<?code-excerpt "lib/layout.dart (toggle-widget)"?>
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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
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
    } else {
      return ElevatedButton(
        onPressed: () {},
        child: const Text('Toggle Two'),
      );
    }
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

### Como eu animo um widget?

No Android, você cria animações usando XML ou chama o método `animate()`
em uma view. No Flutter, anime widgets usando a biblioteca de animação
envolvendo widgets dentro de um widget animado.

No Flutter, use um `AnimationController` que é um `Animation<double>`
que pode pausar, buscar, parar e reverter a animação. Ele requer um `Ticker`
que sinaliza quando vsync acontece, e produz uma interpolação linear entre
0 e 1 em cada frame enquanto está rodando. Você então cria uma ou mais
`Animation`s e as anexa ao controller.

Por exemplo, você pode usar `CurvedAnimation` para implementar uma animação
ao longo de uma curva interpolada. Neste sentido, o controller
é a fonte "mestre" do progresso da animação e o `CurvedAnimation`
computa a curva que substitui o movimento linear padrão do controller.
Como widgets, animações no Flutter funcionam com composição.

Ao construir a árvore de widgets você atribui a `Animation` a uma propriedade
animada de um widget, como a opacidade de um `FadeTransition`, e diz ao
controller para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que faz fade do
widget para um logo quando você pressiona o `FloatingActionButton`:

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
  const FadeAppTest({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fade Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyFadeTest(title: 'Fade Demo'),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FadeTransition(
          opacity: curve,
          child: const FlutterLogo(
            size: 100,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Fade',
        onPressed: () {
          controller.forward();
        },
        child: const Icon(Icons.brush),
      ),
    );
  }
}
```

Para mais informações, veja
[Animation & Motion widgets][],
o [Animations tutorial][],
e a [Animations overview][].

### Como eu uso um Canvas para desenhar/pintar?

No Android, você usaria o `Canvas` e `Drawable`
para desenhar imagens e formas na tela.
Flutter tem uma API `Canvas` similar também,
já que é baseado no mesmo motor de renderização de baixo nível, Skia.
Como resultado, pintar em um canvas no Flutter
é uma tarefa muito familiar para desenvolvedores Android.

Flutter tem duas classes que ajudam você a desenhar no canvas: `CustomPaint`
e `CustomPainter`,
sendo que a última implementa seu algoritmo para desenhar no canvas.

Para aprender como implementar um signature painter no Flutter,
veja a resposta do Collin sobre [Custom Paint][].

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
  SignatureState createState() => SignatureState();
}

class SignatureState extends State<Signature> {
  List<Offset?> _points = <Offset>[];
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
    var paint = Paint()
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

[Custom Paint]: {{site.so}}/questions/46241071/create-signature-area-for-mobile-app-in-dart-flutter

### Como eu construo widgets personalizados?

No Android, você tipicamente faz subclasse de `View`, ou usa uma view pré-existente,
para sobrescrever e implementar métodos que alcançam o comportamento desejado.

No Flutter, construa um widget personalizado [composing][]
widgets menores (em vez de estendê-los).
É similar a implementar um `ViewGroup` personalizado
no Android, onde todos os blocos de construção já existem,
mas você fornece um comportamento diferente&mdash;por exemplo,
lógica de layout personalizada.

Por exemplo, como você constrói um `CustomButton` que recebe um label no
construtor? Crie um CustomButton que compõe um `ElevatedButton` com
um label, em vez de estender `ElevatedButton`:

<?code-excerpt "lib/custom.dart (custom-button)"?>
```dart
class CustomButton extends StatelessWidget {
  final String label;

  const CustomButton(this.label, {super.key});

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

<?code-excerpt "lib/custom.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(
    child: CustomButton('Hello'),
  );
}
```

## Intents

### Qual é o equivalente de um Intent no Flutter?

No Android, existem dois casos de uso principais para `Intent`s: navegar entre
Activities e comunicar com componentes. Flutter, por outro lado,
não tem o conceito de intents, embora você ainda possa iniciar intents
através de integrações nativas (usando [a plugin][]).

Flutter não tem realmente um equivalente direto para activities e fragments;
em vez disso, no Flutter você navega entre telas, usando um `Navigator` e
`Route`s, tudo dentro da mesma `Activity`.

Uma `Route` é uma abstração para uma "screen" ou "page" de um app, e um
`Navigator` é um widget que gerencia routes. Uma route mapeia aproximadamente para uma
`Activity`, mas não carrega o mesmo significado. Um navigator pode fazer push
e pop de routes para mover de tela para tela. Navigators funcionam como uma pilha
na qual você pode fazer `push()` de novas routes para as quais você quer navegar, e da
qual você pode fazer `pop()` de routes quando você quer "voltar".

No Android, você declara suas activities dentro do `AndroidManifest.xml` do app.

No Flutter, você tem algumas opções para navegar entre páginas:

* Especificar um `Map` de nomes de route. (usando `MaterialApp`)
* Navegar diretamente para uma route. (usando `WidgetsApp`)

O exemplo a seguir constrói um Map.

<?code-excerpt "lib/intent.dart (map)"?>
```dart
void main() {
  runApp(MaterialApp(
    home: const MyAppHome(), // Becomes the route named '/'.
    routes: <String, WidgetBuilder>{
      '/a': (context) => const MyPage(title: 'page A'),
      '/b': (context) => const MyPage(title: 'page B'),
      '/c': (context) => const MyPage(title: 'page C'),
    },
  ));
}
```

Navegue para uma route fazendo `push` do seu nome para o `Navigator`.

<?code-excerpt "lib/intent.dart (push)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

O outro caso de uso popular para `Intent`s é chamar componentes externos como
uma Camera ou File picker. Para isso, você precisaria criar uma integração de plataforma
nativa (ou usar um [existing plugin][]).

Para aprender como construir uma integração de plataforma nativa,
veja [developing packages and plugins][].

### Como eu lido com intents recebidos de aplicações externas no Flutter?

Flutter pode lidar com intents recebidos do Android falando diretamente com a
camada Android e solicitando os dados que foram compartilhados.

O exemplo a seguir registra um filtro de intent de compartilhamento de texto na
activity nativa que executa nosso código Flutter, para que outros apps possam compartilhar texto com
nosso app Flutter.

O fluxo básico implica que primeiro lidamos com os dados de texto compartilhados no
lado nativo Android (em nossa `Activity`), e então esperamos até que o Flutter solicite
os dados para fornecê-los usando um `MethodChannel`.

Primeiro, registre o filtro de intent para todos os intents em `AndroidManifest.xml`:

```xml
<activity
  android:name=".MainActivity"
  android:launchMode="singleTop"
  android:theme="@style/LaunchTheme"
  android:configChanges="orientation|keyboardHidden|keyboard|screenSize|locale|layoutDirection"
  android:hardwareAccelerated="true"
  android:windowSoftInputMode="adjustResize">
  <!-- ... -->
  <intent-filter>
    <action android:name="android.intent.action.SEND" />
    <category android:name="android.intent.category.DEFAULT" />
    <data android:mimeType="text/plain" />
  </intent-filter>
</activity>
```

Então no `MainActivity`, lide com o intent, extraia o texto que foi
compartilhado do intent, e mantenha-o. Quando o Flutter estiver pronto para processar,
ele solicita os dados usando um platform channel, e eles são enviados
do lado nativo:

```java
package com.example.shared;

import android.content.Intent;
import android.os.Bundle;

import androidx.annotation.NonNull;

import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {

  private String sharedText;
  private static final String CHANNEL = "app.channel.shared.data";

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    Intent intent = getIntent();
    String action = intent.getAction();
    String type = intent.getType();

    if (Intent.ACTION_SEND.equals(action) && type != null) {
      if ("text/plain".equals(type)) {
        handleSendText(intent); // Handle text being sent
      }
    }
  }

  @Override
  public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
      GeneratedPluginRegistrant.registerWith(flutterEngine);

      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
              .setMethodCallHandler(
                      (call, result) -> {
                          if (call.method.contentEquals("getSharedText")) {
                              result.success(sharedText);
                              sharedText = null;
                          }
                      }
              );
  }

  void handleSendText(Intent intent) {
    sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
  }
}
```

Finalmente, solicite os dados do lado Flutter
quando o widget for renderizado:

<?code-excerpt "lib/request_data.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample Shared App Handler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  static const platform = MethodChannel('app.channel.shared.data');
  String dataShared = 'No data';

  @override
  void initState() {
    super.initState();
    getSharedText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(dataShared)));
  }

  Future<void> getSharedText() async {
    var sharedData = await platform.invokeMethod('getSharedText');
    if (sharedData != null) {
      setState(() {
        dataShared = sharedData as String;
      });
    }
  }
}
```

### Qual é o equivalente de startActivityForResult()?

A classe `Navigator` lida com roteamento no Flutter e é usada para obter
um resultado de volta de uma route que você fez push na pilha.
Isso é feito fazendo `await` no `Future` retornado por `push()`.

Por exemplo, para iniciar uma route de localização que permite ao usuário selecionar
sua localização, você poderia fazer o seguinte:

<?code-excerpt "lib/intent.dart (push-await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro de sua route de localização, uma vez que o usuário selecionou sua localização
você pode fazer `pop` na pilha com o resultado:

<?code-excerpt "lib/intent.dart (pop)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

## Async UI

### Qual é o equivalente de runOnUiThread() no Flutter?

Dart tem um modelo de execução single-threaded, com suporte para `Isolate`s
(uma maneira de executar código Dart em outra thread), um event loop, e
programação assíncrona. A menos que você crie um `Isolate`, seu código Dart
roda na thread principal de UI e é dirigido por um event loop. O event
loop do Flutter é equivalente ao `Looper` principal do Android&mdash;isto é, o `Looper` que
está anexado à thread principal.

O modelo single-threaded do Dart não significa que você precisa executar tudo como uma
operação bloqueante que faz a UI congelar. Ao contrário do Android, que
requer que você mantenha a thread principal livre o tempo todo, no Flutter,
use as facilidades assíncronas que a linguagem Dart fornece, como
`async`/`await`, para realizar trabalho assíncrono. Você pode estar familiarizado com
o paradigma `async`/`await` se você o usou em C#, Javascript, ou se você
usou coroutines do Kotlin.

Por exemplo, você pode executar código de rede sem fazer a UI travar
usando `async`/`await` e deixando o Dart fazer o trabalho pesado:

<?code-excerpt "lib/async.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.get(dataURL);
  setState(() {
    widgets =
        (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

Uma vez que a chamada de rede com `await` termine, atualize a UI chamando `setState()`,
que dispara uma reconstrução da subárvore de widgets e atualiza os dados.

O exemplo a seguir carrega dados assincronamente e os exibe em um `ListView`:

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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Map<String, Object?>> widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
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

  Widget getRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Row ${widgets[i]["title"]}"),
    );
  }

  Future<void> loadData() async {
    final dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(dataURL);
    setState(() {
      widgets =
          (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
    });
  }
}
```

Consulte a próxima seção para mais informações sobre fazer trabalho em
background, e como o Flutter difere do Android.

### Como você move trabalho para uma thread de background?

No Android, quando você quer acessar um recurso de rede você tipicamente
move para uma thread de background e faz o trabalho, para não bloquear a thread principal,
e evitar ANRs. Por exemplo, você pode estar usando um `AsyncTask`, um `LiveData`,
um `IntentService`, um job `JobScheduler`, ou um pipeline RxJava com um
scheduler que funciona em threads de background.

Como o Flutter é single threaded e executa um event loop (como Node.js), você
não precisa se preocupar com gerenciamento de threads ou criar threads de background. Se
você está fazendo trabalho de I/O-bound, como acesso a disco ou uma chamada de rede, então
você pode usar `async`/`await` com segurança e está tudo pronto. Se, por outro
lado, você precisa fazer trabalho computacionalmente intensivo que mantém a CPU ocupada,
você quer movê-lo para um `Isolate` para evitar bloquear o event loop, assim como
você manteria _qualquer_ tipo de trabalho fora da thread principal no Android.

Para trabalho I/O-bound, declare a função como uma função `async`,
e faça `await` em tarefas de longa duração dentro da função:

<?code-excerpt "lib/async.dart (load-data)"?>
```dart
Future<void> loadData() async {
  final dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.get(dataURL);
  setState(() {
    widgets =
        (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

É assim que você tipicamente faria chamadas de rede ou banco de dados, que são ambas
operações de I/O.

No Android, quando você estende `AsyncTask`, você tipicamente sobrescreve 3 métodos,
`onPreExecute()`, `doInBackground()` e `onPostExecute()`. Não há
equivalente no Flutter, já que você faz `await` em uma função de longa duração, e
o event loop do Dart cuida do resto.

No entanto, há momentos em que você pode estar processando uma grande quantidade de dados e
sua UI trava. No Flutter, use `Isolate`s para tirar vantagem de
múltiplos núcleos de CPU para fazer tarefas de longa duração ou computacionalmente intensivas.

Isolates são threads de execução separadas que não compartilham nenhuma memória
com o heap de memória de execução principal. Isso significa que você não pode acessar variáveis da
thread principal, ou atualizar sua UI chamando `setState()`.
Ao contrário de threads Android,
Isolates são fiéis ao seu nome, e não podem compartilhar memória
(na forma de campos estáticos, por exemplo).

O exemplo a seguir mostra, em um isolate simples, como compartilhar dados de volta para
a thread principal para atualizar a UI.

<?code-excerpt "lib/isolates.dart (load-data)"?>
```dart
Future<void> loadData() async {
  ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // The 'echo' isolate sends its SendPort as the first message.
  SendPort sendPort = await receivePort.first as SendPort;

  final msg = await sendReceive(
    sendPort,
    'https://jsonplaceholder.typicode.com/posts',
  ) as List<Object?>;

  setState(() {
    widgets = msg;
  });
}

// The entry point for the isolate.
static Future<void> dataLoader(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  ReceivePort port = ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String data = msg[0] as String;
    SendPort replyTo = msg[1] as SendPort;

    String dataURL = data;
    http.Response response = await http.get(Uri.parse(dataURL));
    // Lots of JSON to parse
    replyTo.send(jsonDecode(response.body));
  }
}

Future<Object?> sendReceive(SendPort port, Object? msg) {
  ReceivePort response = ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}
```

Aqui, `dataLoader()` é o `Isolate` que roda em sua própria thread de
execução separada. No isolate você pode realizar processamento mais intensivo de CPU
(analisar um JSON grande, por exemplo),
ou realizar matemática computacionalmente intensiva,
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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget getBody() {
    bool showLoadingDialog = widgets.isEmpty;
    if (showLoadingDialog) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  Widget getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
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

  ListView getListView() {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, position) {
        return getRow(position);
      },
    );
  }

  Widget getRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Row ${widgets[i]["title"]}"),
    );
  }

  Future<void> loadData() async {
    ReceivePort receivePort = ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message.
    SendPort sendPort = await receivePort.first as SendPort;

    final msg = await sendReceive(
      sendPort,
      'https://jsonplaceholder.typicode.com/posts',
    ) as List<Object?>;

    setState(() {
      widgets = msg;
    });
  }

  // The entry point for the isolate.
  static Future<void> dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0] as String;
      SendPort replyTo = msg[1] as SendPort;

      String dataURL = data;
      http.Response response = await http.get(Uri.parse(dataURL));
      // Lots of JSON to parse
      replyTo.send(jsonDecode(response.body));
    }
  }

  Future<Object?> sendReceive(SendPort port, Object? msg) {
    ReceivePort response = ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }
}
```

### Qual é o equivalente de OkHttp no Flutter?

Fazer uma chamada de rede no Flutter é fácil quando você usa o
popular [`http` package][].

Embora o pacote http não tenha todos os recursos encontrados em OkHttp,
ele abstrai muito do networking que você normalmente implementaria
você mesmo, tornando-o uma maneira simples de fazer chamadas de rede.

Para adicionar o pacote `http` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add http
```

Para fazer uma chamada de rede, chame `await` na função `async` `http.get()`:

<?code-excerpt "lib/network.dart"?>
```dart
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

Future<void> loadData() async {
  var dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  http.Response response = await http.get(dataURL);
  developer.log(response.body);
}
```

### Como eu mostro o progresso para uma tarefa de longa duração?

No Android você tipicamente mostra uma view `ProgressBar` em sua UI enquanto
executa uma tarefa de longa duração em uma thread de background.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando quando ele é renderizado
através de uma flag booleana. Diga ao Flutter para atualizar seu estado antes de sua
tarefa de longa duração começar, e esconda-o depois que terminar.

No exemplo a seguir, a função build é separada em três funções diferentes.
Se `showLoadingDialog` for `true` (quando `widgets.isEmpty`),
então renderize o `ProgressIndicator`. Caso contrário, renderize o
`ListView` com os dados retornados de uma chamada de rede.

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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List<Map<String, Object?>> widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Widget getBody() {
    bool showLoadingDialog = widgets.isEmpty;
    if (showLoadingDialog) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  Widget getProgressDialog() {
    return const Center(child: CircularProgressIndicator());
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

  ListView getListView() {
    return ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (context, position) {
        return getRow(position);
      },
    );
  }

  Widget getRow(int i) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text("Row ${widgets[i]["title"]}"),
    );
  }

  Future<void> loadData() async {
    final dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(dataURL);
    setState(() {
      widgets =
          (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
    });
  }
}
```

## Estrutura de projeto e recursos

### Onde eu armazeno meus arquivos de imagem dependentes de resolução?

Enquanto o Android trata recursos e assets como itens distintos,
apps Flutter têm apenas assets. Todos os recursos que viveriam
nas pastas `res/drawable-*` no Android,
são colocados em uma pasta de assets para Flutter.

Flutter segue um formato simples baseado em densidade como iOS.
Assets podem ser `1.0x`, `2.0x`, `3.0x`, ou qualquer outro multiplicador.
Flutter não tem `dp`s mas há pixels lógicos,
que são basicamente os mesmos que pixels independentes de dispositivo.
O [`devicePixelRatio`][] do Flutter expressa a razão
de pixels físicos em um único pixel lógico.

O equivalente aos buckets de densidade do Android são:

 Android density qualifier | Flutter pixel ratio
 --- | ---
 `ldpi` | `0.75x`
 `mdpi` | `1.0x`
 `hdpi` | `1.5x`
 `xhdpi` | `2.0x`
 `xxhdpi` | `3.0x`
 `xxxhdpi` | `4.0x`

Assets estão localizados em qualquer pasta arbitrária&mdash;Flutter
não tem estrutura de pastas predefinida.
Você declara os assets (com localização) no
arquivo `pubspec.yaml`, e o Flutter os pega.

Assets armazenados na pasta de assets nativos são
acessados no lado nativo usando o `AssetManager` do Android:

```kotlin
val flutterAssetStream = assetManager.open("flutter_assets/assets/my_flutter_asset.png")
```

Flutter não pode acessar recursos ou assets nativos.

Para adicionar um novo asset de imagem chamado `my_icon.png` ao nosso projeto Flutter,
por exemplo, e decidir que ele deve viver em uma pasta que
arbitrariamente chamamos de `images`, você colocaria a imagem base (1.0x)
na pasta `images`, e todas as outras variantes em sub-pastas
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

Você pode então acessar suas imagens usando `AssetImage`:

<?code-excerpt "lib/images.dart (asset-image)"?>
```dart
AssetImage('images/my_icon.png')
```

ou diretamente em um widget `Image`:

<?code-excerpt "lib/images.dart (image-asset)"?>
```dart
@override
Widget build(BuildContext context) {
  return Image.asset('images/my_image.png');
}
```

### Onde eu armazeno strings? Como eu lido com localização?

Flutter atualmente não tem um sistema dedicado tipo recursos para strings.
A melhor e recomendada prática é manter suas strings em um arquivo `.arb` como pares chave-valor. Por exemplo:

<?code-excerpt "lib/arb_examples.arb"?>
```json
{
   "@@locale": "en",
   "hello":"Hello {userName}",
   "@hello":{
      "description":"A message with a single parameter",
      "placeholders":{
         "userName":{
            "type":"String",
            "example":"Bob"
         }
      }
   }
}
```

Então em seu código, você pode acessar suas strings assim:

<?code-excerpt "lib/localization_examples.dart (access-string)"?>
```dart
Text(AppLocalizations.of(context)!.hello('John'));
```

Flutter tem suporte básico para acessibilidade no Android,
embora este recurso seja um trabalho em progresso.

Veja [Internationalizing Flutter apps][] para mais informações sobre isso.

### Qual é o equivalente de um arquivo Gradle? Como eu adiciono dependências?

No Android, você adiciona dependências adicionando ao seu script de build Gradle.
Flutter usa o próprio sistema de build do Dart, e o gerenciador de pacotes Pub.
As ferramentas delegam a construção dos apps wrapper nativos Android e iOS
para os respectivos sistemas de build.

Embora existam arquivos Gradle sob a pasta `android` em seu
projeto Flutter, use-os apenas se você estiver adicionando
dependências nativas necessárias para integração por plataforma.
Em geral, use `pubspec.yaml` para declarar
dependências externas para usar no Flutter.
Um bom lugar para encontrar pacotes Flutter é [pub.dev][].

## Activities e fragments

### Quais são os equivalentes de activities e fragments no Flutter?

No Android, uma `Activity` representa uma única coisa focada que o usuário pode fazer.
Um `Fragment` representa um comportamento ou uma porção de interface do usuário.
Fragments são uma maneira de modularizar seu código, compor interfaces de
usuário sofisticadas para telas maiores, e ajudar a escalar a UI de sua aplicação.
No Flutter, ambos esses conceitos caem sob o guarda-chuva de `Widget`s.

Para aprender mais sobre a UI para construir Activities e Fragments,
veja o artigo Medium contribuído pela comunidade,
[Flutter for Android Developers: How to design Activity UI in Flutter][].

Como mencionado na seção [Intents][],
telas no Flutter são representadas por `Widget`s já que tudo é
um widget no Flutter. Use um `Navigator` para mover entre diferentes
`Route`s que representam diferentes telas ou páginas,
ou talvez diferentes estados ou renderizações dos mesmos dados.

### Como eu escuto eventos de lifecycle de activity Android?

No Android, você pode sobrescrever métodos da `Activity` para capturar métodos de lifecycle
para a activity em si, ou registrar `ActivityLifecycleCallbacks` na
`Application`. No Flutter, você não tem nenhum conceito, mas você pode
escutar eventos de lifecycle conectando-se ao observer `WidgetsBinding` e
escutando o evento de mudança `didChangeAppLifecycleState()`.

Os eventos de lifecycle observáveis são:

* `detached` — A aplicação ainda está hospedada em uma engine flutter mas está desanexada de quaisquer views host.
* `inactive` — A aplicação está em um estado inativo e não está recebendo entrada de
  usuário.
* `paused` — A aplicação não está atualmente visível para o usuário,
  não está respondendo à entrada do usuário, e rodando em background.
  Isso é equivalente a `onPause()` no Android.
* `resumed` — A aplicação está visível e respondendo à entrada do usuário.
  Isso é equivalente a `onPostResume()` no Android.

Para mais detalhes sobre o significado desses estados, veja a
[`AppLifecycleStatus` documentation][].

Como você pode ter notado, apenas uma pequena minoria dos eventos de
lifecycle de Activity estão disponíveis; embora `FlutterActivity`
capture quase todos os eventos de lifecycle de activity internamente e
os envie para a engine Flutter, eles são em sua maioria protegidos
de você. Flutter cuida de iniciar e parar a
engine para você, e há pouca razão para precisar
observar o lifecycle de activity no lado Flutter na maioria dos casos.
Se você precisa observar o lifecycle para adquirir ou liberar quaisquer
recursos nativos, você provavelmente deveria estar fazendo isso do lado nativo,
de qualquer forma.

Aqui está um exemplo de como observar o status de lifecycle da
activity que contém:

<?code-excerpt "lib/lifecycle.dart"?>
```dart
import 'package:flutter/widgets.dart';

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({super.key});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher>
    with WidgetsBindingObserver {
  AppLifecycleState? _lastLifecycleState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      _lastLifecycleState = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_lastLifecycleState == null) {
      return const Text(
        'This widget has not observed any lifecycle changes.',
        textDirection: TextDirection.ltr,
      );
    }

    return Text(
      'The most recent lifecycle state this widget observed was: $_lastLifecycleState.',
      textDirection: TextDirection.ltr,
    );
  }
}

void main() {
  runApp(const Center(child: LifecycleWatcher()));
}
```

## Layouts

### Qual é o equivalente de um LinearLayout?

No Android, um LinearLayout é usado para dispor seus widgets
linearmente&mdash;seja horizontalmente ou verticalmente.
No Flutter, use os widgets Row ou Column
para alcançar o mesmo resultado.

Se você notar, os dois exemplos de código são idênticos com exceção do
widget "Row" e "Column". Os children são os mesmos e este recurso pode ser
explorado para desenvolver layouts ricos que podem mudar ao longo do tempo com os mesmos
children.

<?code-excerpt "lib/layout.dart (row)"?>
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

<?code-excerpt "lib/layout.dart (column)"?>
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
}
```

Para aprender mais sobre construir layouts lineares,
veja o artigo Medium contribuído pela comunidade
[Flutter for Android Developers: How to design LinearLayout in Flutter][].

### Qual é o equivalente de um RelativeLayout?

Um RelativeLayout dispõe seus widgets relativos uns aos outros. No
Flutter, existem algumas maneiras de alcançar o mesmo resultado.

Você pode alcançar o resultado de um RelativeLayout usando uma combinação de
widgets Column, Row e Stack. Você pode especificar regras para os construtores
de widgets sobre como os children são dispostos relativos ao pai.

Para um bom exemplo de construir um RelativeLayout no Flutter,
veja a resposta do Collin no [StackOverflow][].

### Qual é o equivalente de um ScrollView?

No Android, use um ScrollView para dispor seus widgets&mdash;se o dispositivo
do usuário tem uma tela menor que seu conteúdo, ele rola.

No Flutter, a maneira mais fácil de fazer isso é usando o widget ListView.
Isso pode parecer exagero vindo do Android,
mas no Flutter um widget ListView é
tanto um ScrollView quanto um ListView do Android.

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

### Como eu lido com transições de landscape no Flutter?

FlutterView lida com a mudança de configuração se AndroidManifest.xml contém:

```yaml
android:configChanges="orientation|screenSize"
```

## Detecção de gestos e manipulação de eventos de toque

### Como eu adiciono um listener onClick a um widget no Flutter?

No Android, você pode anexar onClick a views como botão chamando
o método 'setOnClickListener'.

No Flutter existem duas maneiras de adicionar listeners de toque:

 1. Se o Widget suporta detecção de eventos, passe uma função para ele e lide com ela
    na função. Por exemplo, o ElevatedButton tem um parâmetro `onPressed`:

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

 2. Se o Widget não suporta detecção de eventos, envolva o
    widget em um GestureDetector e passe uma função para o parâmetro `onTap`.

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

### Como eu lido com outros gestos em widgets?

Usando o GestureDetector, você pode escutar uma ampla gama de Gestos como:

* Tap

  * `onTapDown` - Um ponteiro que pode causar um tap contatou a tela em um
     local particular.
  * `onTapUp` - Um ponteiro que dispara um tap parou de contatar a
     tela em um local particular.
  * `onTap` - Um tap ocorreu.
  * `onTapCancel` - O ponteiro que previamente disparou o `onTapDown` não vai
     causar um tap.

* Double tap

  * `onDoubleTap` - O usuário tocou a tela no mesmo local duas vezes em
     sucessão rápida.

* Long press

  * `onLongPress` - Um ponteiro permaneceu em contato com a tela no
    mesmo local por um longo período de tempo.

* Vertical drag

  * `onVerticalDragStart` - Um ponteiro contatou a tela e
    pode começar a mover verticalmente.
  * `onVerticalDragUpdate` - Um ponteiro em contato com a tela
    se moveu mais na direção vertical.
  * `onVerticalDragEnd` - Um ponteiro que estava previamente em contato com a
    tela e movendo verticalmente não está mais em contato com a tela e estava
    movendo a uma velocidade específica quando parou de contatar a tela.

* Horizontal drag

  * `onHorizontalDragStart` - Um ponteiro contatou a tela e pode começar
    a mover horizontalmente.
  * `onHorizontalDragUpdate` - Um ponteiro em contato com a tela
    se moveu mais na direção horizontal.
  * `onHorizontalDragEnd` - Um ponteiro que estava previamente em contato com a
    tela e movendo horizontalmente não está mais em contato com a
    tela e estava movendo a uma velocidade específica quando parou
    de contatar a tela.

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

## Listviews e adapters

### Qual é a alternativa para um ListView no Flutter?

O equivalente a um ListView no Flutter é … um ListView!

Em um ListView Android, você cria um adapter e o passa para o
ListView, que renderiza cada linha com o que seu adapter retorna. No entanto, você
tem que garantir que você recicle suas linhas, caso contrário, você obtém todo tipo de
falhas visuais malucas e problemas de memória.

Devido ao padrão de widget imutável do Flutter, você passa uma lista de
widgets para seu ListView, e o Flutter cuida de garantir
que a rolagem seja rápida e suave.

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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: ListView(children: _getListData()),
    );
  }

  List<Widget> _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Row $i'),
      ));
    }
    return widgets;
  }
}
```

### Como eu sei qual item da lista foi clicado?

No Android, o ListView tem um método para descobrir qual item foi clicado,
'onItemClickListener'.
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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  const SampleAppPage({super.key});

  @override
  State<SampleAppPage> createState() => _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: ListView(children: _getListData()),
    );
  }

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
}
```

### Como eu atualizo ListView's dinamicamente?

No Android, você atualiza o adapter e chama `notifyDataSetChanged`.

No Flutter, se você fosse atualizar a lista de widgets dentro de um `setState()`,
você rapidamente veria que seus dados não mudaram visualmente.
Isso porque quando `setState()` é chamado, a engine de renderização do Flutter
olha para a árvore de widgets para ver se algo mudou. Quando chega ao seu
`ListView`, ela realiza uma verificação `==`, e determina que os dois
`ListView`s são os mesmos. Nada mudou, então nenhuma atualização é necessária.

Para uma maneira simples de atualizar seu `ListView`, crie uma nova `List` dentro de
`setState()`, e copie os dados da lista antiga para a nova lista.
Embora esta abordagem seja simples, não é recomendada para grandes conjuntos de dados,
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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample App'),
      ),
      body: ListView(children: widgets),
    );
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
}
```

A maneira recomendada, eficiente e efetiva de construir uma lista usa um
`ListView.Builder`. Este método é ótimo quando você tem uma
`List` dinâmica ou uma `List` com quantidades muito grandes de dados. Isso é essencialmente
o equivalente de RecyclerView no Android, que automaticamente
recicla elementos de lista para você:

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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
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
}
```

Em vez de criar um "ListView", crie um
`ListView.builder` que recebe dois parâmetros chave: o
comprimento inicial da lista, e uma função `ItemBuilder`.

A função `ItemBuilder` é similar à função `getView`
em um adapter Android; ela recebe uma posição,
e retorna a linha que você quer renderizada naquela posição.

Finalmente, mas muito importante, note que a função `onTap()`
não recria mais a lista, mas em vez disso faz `.add` nela.

## Trabalhando com texto

### Como eu defino fontes personalizadas nos meus widgets Text?

No Android SDK (a partir do Android O), você cria um arquivo de recurso Font e
o passa no parâmetro FontFamily para seu TextView.

No Flutter, coloque o arquivo de fonte em uma pasta e referencie-o no
arquivo `pubspec.yaml`, similar a como você importa imagens.

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

### Como eu estilizo meus widgets Text?

Junto com fontes, você pode personalizar outros elementos de estilo em um widget `Text`.
O parâmetro style de um widget `Text` recebe um objeto `TextStyle`, onde você pode
personalizar muitos parâmetros, como:

* color
* decoration
* decorationColor
* decorationStyle
* fontFamily
* fontSize
* fontStyle
* fontWeight
* hashCode
* height
* inherit
* letterSpacing
* textBaseline
* wordSpacing

## Entrada de formulário

Para mais informações sobre usar Forms,
veja [Retrieve the value of a text field][],
do [Flutter cookbook][].

### Qual é o equivalente de um "hint" em um Input?

No Flutter, você pode facilmente mostrar um "hint" ou um texto placeholder para sua entrada
adicionando um objeto InputDecoration ao parâmetro construtor decoration para
o Widget Text.

<?code-excerpt "lib/form.dart (input-hint)" replace="/return const //g;/;//g"?>
```dart
Center(
  child: TextField(
    decoration: InputDecoration(hintText: 'This is a hint'),
  ),
)
```

### Como eu mostro erros de validação?

Assim como você faria com um "hint", passe um objeto InputDecoration
para o construtor decoration do widget Text.

No entanto, você não quer começar mostrando um erro.
Em vez disso, quando o usuário digitou dados inválidos,
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
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const SampleAppPage(),
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
            errorText: _getErrorText(),
          ),
        ),
      ),
    );
  }

  String? _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|'
        r'(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|'
        r'(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = RegExp(emailRegexp);

    return regExp.hasMatch(em);
  }
}
```


## Plugins Flutter

### Como eu acesso o sensor GPS?

Use o plugin da comunidade [`geolocator`][].

### Como eu acesso a câmera?

O plugin [`image_picker`][] é popular
para acessar a câmera.

### Como eu faço login com Facebook?

Para fazer login com Facebook, use o
plugin da comunidade [`flutter_facebook_login`][].

### Como eu uso recursos do Firebase?

A maioria das funções do Firebase são cobertas por
[first party plugins][].
Estes plugins são integrações first-party,
mantidas pela equipe Flutter:

 * [`google_mobile_ads`][] for Google Mobile Ads for Flutter
 * [`firebase_analytics`][] for Firebase Analytics
 * [`firebase_auth`][] for Firebase Auth
 * [`firebase_database`][] for Firebase RTDB
 * [`firebase_storage`][] for Firebase Cloud Storage
 * [`firebase_messaging`][] for Firebase Messaging (FCM)
 * [`flutter_firebase_ui`][] para integrações rápidas com Firebase Auth
   (Facebook, Google, Twitter e email)
 * [`cloud_firestore`][] for Firebase Cloud Firestore

Você também pode encontrar alguns plugins Firebase de terceiros no
pub.dev que cobrem áreas não diretamente cobertas pelos
plugins first-party.

### Como eu construo minhas próprias integrações nativas personalizadas?

Se há funcionalidade específica de plataforma que o Flutter
ou seus Plugins da comunidade estão faltando,
você pode construir o seu próprio seguindo a
página [developing packages and plugins][].

A arquitetura de plugin do Flutter, em resumo, é muito parecida com usar um Event bus no
Android: você dispara uma mensagem e deixa o receptor processar e emitir um resultado
de volta para você. Neste caso, o receptor é código rodando no lado nativo
no Android ou iOS.

### Como eu uso o NDK na minha aplicação Flutter?

Se você usa o NDK em sua aplicação Android atual e quer que sua aplicação
Flutter tire vantagem de suas bibliotecas nativas então é possível
construindo um plugin personalizado.

Seu plugin personalizado primeiro fala com seu app Android, onde você chama suas
funções `native` sobre JNI. Uma vez que uma resposta está pronta,
envie uma mensagem de volta para o Flutter e renderize o resultado.

Chamar código nativo diretamente do Flutter atualmente não é suportado.

## Themes

### Como eu tematizo meu app?

Pronto para uso, Flutter vem com uma bela implementação de Material
Design, que cuida de muitas necessidades de estilo e tematização que você
tipicamente faria. Ao contrário do Android onde você declara themes em XML e então o atribui
à sua aplicação usando AndroidManifest.xml, no Flutter você declara themes
no widget de nível superior.

Para tirar total vantagem dos Material Components em seu app, você pode declarar um
widget de nível superior `MaterialApp` como ponto de entrada para sua aplicação. MaterialApp
é um widget de conveniência que envolve um número de widgets que são comumente
requeridos para aplicações implementando Material Design.
Ele constrói sobre um WidgetsApp adicionando funcionalidade específica de Material.

Você também pode usar um `WidgetsApp` como seu widget de app, que fornece alguma da
mesma funcionalidade, mas não é tão rico quanto `MaterialApp`.

Para personalizar as cores e estilos de quaisquer componentes filhos, passe um
objeto `ThemeData` para o widget `MaterialApp`. Por exemplo, no código abaixo,
o esquema de cores da seed é definido como deepPurple e a cor de seleção de texto é vermelho.

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
        textSelectionTheme:
            const TextSelectionThemeData(selectionColor: Colors.red),
      ),
      home: const SampleAppPage(),
    );
  }
}
```


## Bancos de dados e armazenamento local

### Como eu acesso Shared Preferences?

No Android, você pode armazenar uma pequena coleção de pares chave-valor usando
a API SharedPreferences.

No Flutter, acesse esta funcionalidade usando o
[Shared_Preferences plugin][].
Este plugin encapsula a funcionalidade tanto de
Shared Preferences quanto de NSUserDefaults (o equivalente iOS).

<?code-excerpt "lib/shared_prefs.dart"?>
```dart
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: _incrementCounter,
            child: Text('Increment Counter'),
          ),
        ),
      ),
    ),
  );
}

Future<void> _incrementCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int counter = (prefs.getInt('counter') ?? 0) + 1;
  await prefs.setInt('counter', counter);
}
```

### Como eu acesso SQLite no Flutter?

No Android, você usa SQLite para armazenar dados estruturados
que você pode consultar usando SQL.

No Flutter, para macOS, Android ou iOS,
acesse esta funcionalidade usando o
plugin [SQFlite][].

## Debugging

### Quais ferramentas eu posso usar para debugar meu app no Flutter?

Use a suíte [DevTools][] para debugar apps Flutter ou Dart.

DevTools inclui suporte para profiling, examinar o heap,
inspecionar a árvore de widgets, registrar diagnósticos, debugar,
observar linhas de código executadas, debugar vazamentos de memória e
fragmentação de memória. Para mais informações, confira a
documentação do [DevTools][].

## Notificações

### Como eu configuro notificações push?

No Android, você usa Firebase Cloud Messaging para configurar
notificações push para seu app.

No Flutter, acesse esta funcionalidade usando o
plugin [Firebase Messaging][].
Para mais informações sobre usar a API Firebase Cloud Messaging,
veja a documentação do plugin [`firebase_messaging`][].


[Add Flutter to existing app]: /add-to-app
[Animation & Motion widgets]: /ui/widgets/animation
[Animations tutorial]: /ui/animations/tutorial
[Animations overview]: /ui/animations
[`AppLifecycleStatus` documentation]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html
[Apple's iOS design language]: {{site.apple-dev}}/design/resources/
[`cloud_firestore`]: {{site.pub}}/packages/cloud_firestore
[composing]: /resources/architectural-overview#composition
[Cupertino widgets]: /ui/widgets/cupertino
[developing packages and plugins]: /packages-and-plugins/developing-packages
[`devicePixelRatio`]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[DevTools]: /tools/devtools
[existing plugin]: {{site.pub}}/flutter/
[`flutter_facebook_login`]: {{site.pub}}/packages/flutter_facebook_login
[`google_mobile_ads`]: {{site.pub}}/packages/google_mobile_ads
[`firebase_analytics`]: {{site.pub}}/packages/firebase_analytics
[`firebase_auth`]: {{site.pub}}/packages/firebase_auth
[`firebase_database`]: {{site.pub}}/packages/firebase_database
[`firebase_messaging`]: {{site.pub}}/packages/firebase_messaging
[`firebase_storage`]: {{site.pub}}/packages/firebase_storage
[`flutter_firebase_ui`]: {{site.pub}}/packages/flutter_firebase_ui
[Firebase Messaging]: {{site.github}}/firebase/flutterfire/tree/master/packages/firebase_messaging
[first party plugins]: {{site.pub}}/flutter/packages?q=firebase
[Flutter cookbook]: /cookbook
[Flutter for Android Developers: How to design LinearLayout in Flutter]: https://proandroiddev.com/flutter-for-android-developers-how-to-design-linearlayout-in-flutter-5d819c0ddf1a
[Flutter for Android Developers: How to design Activity UI in Flutter]: https://blog.usejournal.com/flutter-for-android-developers-how-to-design-activity-ui-in-flutter-4bf7b0de1e48
[`geolocator`]: {{site.pub}}/packages/geolocator
[`http` package]: {{site.pub}}/packages/http
[`image_picker`]: {{site.pub}}/packages/image_picker
[Intents]: #what-is-the-equivalent-of-an-intent-in-flutter
[intl package]: {{site.pub}}/packages/intl
[Introduction to declarative UI]: /get-started/flutter-for/declarative
[Material Components]: {{site.material}}/develop/flutter
[Material Design guidelines]: {{site.material}}/styles
[optimized for all platforms]: {{site.material}}/develop
[a plugin]: {{site.pub}}/packages/android_intent
[pub.dev]: {{site.pub}}/flutter/packages/
[Retrieve the value of a text field]: /cookbook/forms/retrieve-input
[Shared_Preferences plugin]: {{site.pub}}/packages/shared_preferences
[SQFlite]: {{site.pub}}/packages/sqflite
[StackOverflow]: {{site.so}}/questions/44396075/equivalent-of-relativelayout-in-flutter
[widget catalog]: /ui/widgets/layout
[Internationalizing Flutter apps]: /ui/accessibility-and-internationalization/internationalization
