---
ia-translate: true
title: Flutter para desenvolvedores Android
description: Aprenda como aplicar o conhecimento de desenvolvedor Android ao criar aplicativos Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/android_devs"?>

Este documento destina-se a desenvolvedores Android que desejam aplicar seu
conhecimento Android existente para criar aplicativos móveis com Flutter.
Se você entende os fundamentos do framework Android, então pode usar este documento
como um pontapé inicial para o desenvolvimento Flutter.

:::note
Para integrar o código Flutter em seu aplicativo Android, veja
[Adicionar Flutter a um aplicativo existente][].
:::

Seu conhecimento e conjunto de habilidades Android são muito valiosos ao criar
com Flutter, porque o Flutter depende do sistema operacional móvel para
inúmeras capacidades e configurações. Flutter é uma nova maneira de criar
UIs para dispositivos móveis, mas possui um sistema de plugin para se
comunicar com Android (e iOS) para tarefas não relacionadas à UI. Se você é um
especialista em Android, não precisa reaprender tudo para usar o Flutter.

Este documento pode ser usado como um livro de receitas, navegando e
encontrando as perguntas mais relevantes para suas necessidades.

## Views

### Qual é o equivalente de uma View no Flutter?

:::secondary
Como a programação estilo react, ou _declarativa_, é diferente do
estilo imperativo tradicional?
Para uma comparação, veja [Introdução à UI declarativa][].
:::

No Android, a `View` é a base de tudo que aparece na tela.
Botões, barras de ferramentas e entradas, tudo é uma View.
No Flutter, o equivalente aproximado a uma `View` é um `Widget`.
Widgets não são mapeados exatamente para views Android, mas enquanto você
está se familiarizando com o funcionamento do Flutter, pode pensar neles como
"a maneira como você declara e constrói a UI".

No entanto, eles têm algumas diferenças em relação a uma `View`. Para
começar, os widgets têm um tempo de vida diferente: eles são imutáveis
e existem apenas até que precisem ser alterados. Sempre que os widgets ou
seu estado mudam, o framework do Flutter cria uma nova árvore de instâncias
de widgets. Em comparação, uma view Android é desenhada uma vez e não
é redesenhada até que `invalidate` seja chamado.

Os widgets do Flutter são leves, em parte devido à sua imutabilidade.
Como eles não são views em si e não estão desenhando nada diretamente,
mas sim uma descrição da UI e sua semântica que são "infladas"
em objetos de view reais por baixo dos panos.

O Flutter inclui a biblioteca [Componentes Material][].
Estes são widgets que implementam as
[diretrizes de Design Material][]. Design Material é um
sistema de design flexível [otimizado para todas as plataformas][],
incluindo iOS.

Mas o Flutter é flexível e expressivo o suficiente para implementar qualquer
linguagem de design. Por exemplo, no iOS, você pode usar os
[widgets Cupertino][] para produzir uma interface que se parece com a
[linguagem de design do iOS da Apple][].

### Como eu atualizo os widgets?

No Android, você atualiza suas views diretamente as modificando. No entanto,
no Flutter, os `Widget`s são imutáveis e não são atualizados diretamente,
em vez disso, você precisa trabalhar com o estado do widget.

É daí que vem o conceito de widgets `Stateful` e `Stateless`. Um
`StatelessWidget` é exatamente o que parece&mdash;um
widget sem informações de estado.

`StatelessWidgets` são úteis quando a parte da interface do usuário
que você está descrevendo não depende de nada além das informações de
configuração no objeto.

Por exemplo, no Android, isso é semelhante a colocar uma `ImageView`
com seu logotipo. O logotipo não vai mudar durante a execução,
então use um `StatelessWidget` no Flutter.

Se você deseja alterar dinamicamente a UI com base em dados recebidos
após fazer uma chamada HTTP ou interação do usuário, então você precisa
trabalhar com `StatefulWidget` e informar ao framework Flutter que o
`State` do widget foi atualizado para que ele possa atualizar esse widget.

O importante a notar aqui é que, no núcleo, tanto os widgets sem estado
quanto os com estado se comportam da mesma forma. Eles são reconstruídos
a cada frame, a diferença é que o `StatefulWidget` possui um objeto
`State` que armazena dados de estado entre frames e os restaura.

Se você estiver em dúvida, então sempre lembre-se desta regra: se um widget
mudar (por causa de interações do usuário, por exemplo) ele é stateful.
No entanto, se um widget reage à mudança, o widget pai contido ainda pode
ser stateless se ele próprio não reagir à mudança.

O exemplo a seguir mostra como usar um `StatelessWidget`. Um
`StatelessWidget` comum é o widget `Text`. Se você observar a implementação
do widget `Text`, você verá que ele é uma subclasse de `StatelessWidget`.

<?code-excerpt "lib/text_widget.dart (text-widget)" replace="/return const //g"?>
```dart
Text(
  'Eu gosto de Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Como você pode ver, o Widget `Text` não tem informações de estado
associadas a ele, ele renderiza o que é passado em seus construtores e
nada mais.

Mas, e se você quiser fazer "Eu gosto de Flutter" mudar dinamicamente,
por exemplo, ao clicar em um `FloatingActionButton`?

Para conseguir isso, envolva o widget `Text` em um `StatefulWidget` e
o atualize quando o usuário clicar no botão.

Por exemplo:

<?code-excerpt "lib/text_widget.dart (stateful-widget)"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  // Este widget é a raiz do seu aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de amostra',
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
  // Texto de espaço reservado padrão.
  String textToShow = 'Eu gosto de Flutter';

  void _updateText() {
    setState(() {
      // Atualizar o texto.
      textToShow = 'Flutter é Incrível!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicativo de Amostra'),
      ),
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

### Como eu layout meus widgets? Onde está meu arquivo de layout XML?

No Android, você escreve layouts em XML, mas no Flutter, você escreve seus
layouts com uma árvore de widgets.

O exemplo a seguir mostra como exibir um widget simples com padding:

<?code-excerpt "lib/layout.dart (simple-widget)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Aplicativo de amostra'),
    ),
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

Você pode visualizar alguns dos layouts que o Flutter tem a oferecer no
[catálogo de widgets][].

### Como eu adiciono ou removo um componente do meu layout?

No Android, você chama `addChild()` ou `removeChild()`
em um pai para adicionar ou remover dinamicamente as views filhas.
No Flutter, porque os widgets são imutáveis, não há
equivalente direto para `addChild()`. Em vez disso,
você pode passar uma função para o pai que retorna um widget,
e controlar a criação desse filho com uma flag booleana.

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

  // Este widget é a raiz do seu aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicativo de Amostra',
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
  // Valor padrão para alternar.
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  Widget _getToggleChild() {
    if (toggle) {
      return const Text('Alternar Um');
    } else {
      return ElevatedButton(
        onPressed: () {},
        child: const Text('Alternar Dois'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aplicativo de Amostra'),
      ),
      body: Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Atualizar Texto',
        child: const Icon(Icons.update),
      ),
    );
  }
}
```

### Como eu animo um widget?

No Android, você cria animações usando XML ou chama o método `animate()`
em uma view. No Flutter, anime os widgets usando a biblioteca de animação
envolvendo os widgets dentro de um widget animado.

No Flutter, use um `AnimationController`, que é uma `Animation<double>`
que pode pausar, procurar, parar e reverter a animação. Ela requer um
`Ticker` que sinaliza quando vsync acontece e produz uma interpolação
linear entre 0 e 1 em cada frame enquanto está em execução. Em seguida, você
cria uma ou mais `Animation`s e as anexa ao controlador.

Por exemplo, você pode usar `CurvedAnimation` para implementar uma animação
ao longo de uma curva interpolada. Nesse sentido, o controlador
é a fonte "mestre" do progresso da animação e o `CurvedAnimation`
calcula a curva que substitui o movimento linear padrão do controlador.
Assim como os widgets, as animações no Flutter funcionam com composição.

Ao construir a árvore de widgets, você atribui a `Animation` a uma
propriedade animada de um widget, como a opacidade de um `FadeTransition`,
e informa ao controlador para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que esmaece o
widget em um logotipo quando você pressiona o `FloatingActionButton`:

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const FadeAppTest());
}

class FadeAppTest extends StatelessWidget {
  const FadeAppTest({super.key});
  // Este widget é a raiz do seu aplicativo.
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
[Widgets de Animação & Movimento][],
o [tutorial de Animações][],
e a [visão geral de Animações][].

### Como eu uso um Canvas para desenhar/pintar?

No Android, você usaria o `Canvas` e `Drawable`
para desenhar imagens e formas na tela.
O Flutter tem uma API `Canvas` semelhante também,
já que é baseada no mesmo mecanismo de renderização de baixo nível, o Skia.
Como resultado, pintar em um canvas no Flutter
é uma tarefa muito familiar para os desenvolvedores Android.

O Flutter possui duas classes que ajudam você a desenhar no canvas: `CustomPaint`
e `CustomPainter`,
a última das quais implementa seu algoritmo para desenhar no canvas.

Para aprender como implementar um pintor de assinatura no Flutter,
veja a resposta de Collin em [Pintura Personalizada][].

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

[Pintura Personalizada]: {{site.so}}/questions/46241071/create-signature-area-for-mobile-app-in-dart-flutter

### Como eu construo widgets personalizados?

No Android, você normalmente cria uma subclasse de `View`, ou usa uma view
pré-existente, para substituir e implementar métodos que alcançam o
comportamento desejado.

No Flutter, construa um widget personalizado por [composição][]
de widgets menores (em vez de estendê-los).
É um pouco semelhante a implementar um `ViewGroup` personalizado
no Android, onde todos os blocos de construção já existem,
mas você fornece um comportamento diferente&mdash;por exemplo,
lógica de layout personalizada.

Por exemplo, como você cria um `CustomButton` que recebe um rótulo no
construtor? Crie um CustomButton que componha um `ElevatedButton` com
um rótulo, em vez de estender `ElevatedButton`:

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

Em seguida, use `CustomButton`, assim como você usaria qualquer outro
widget do Flutter:

<?code-excerpt "lib/custom.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(
    child: CustomButton('Olá'),
  );
}
```

## Intents

### Qual é o equivalente de uma Intent no Flutter?

No Android, existem dois principais casos de uso para `Intent`s: navegar entre
Activities e se comunicar com componentes. O Flutter, por outro lado,
não tem o conceito de intents, embora você ainda possa iniciar intents
por meio de integrações nativas (usando [um plugin][]).

O Flutter realmente não tem um equivalente direto para activities e
fragments; em vez disso, no Flutter, você navega entre telas, usando um
`Navigator` e `Route`s, tudo dentro da mesma `Activity`.

Uma `Route` é uma abstração para uma "tela" ou "página" de um aplicativo,
e um `Navigator` é um widget que gerencia rotas. Uma rota mapeia
aproximadamente para uma `Activity`, mas não carrega o mesmo significado. Um
navegador pode empurrar e retirar rotas para se mover de tela em tela.
Navegadores funcionam como uma pilha na qual você pode `push()` novas rotas
para as quais você deseja navegar e da qual você pode `pop()` rotas quando
deseja "voltar".

No Android, você declara suas activities dentro do `AndroidManifest.xml` do aplicativo.

No Flutter, você tem algumas opções para navegar entre as páginas:

* Especificar um `Map` de nomes de rotas. (usando `MaterialApp`)
* Navegar diretamente para uma rota. (usando `WidgetsApp`)

O exemplo a seguir cria um Map.

<?code-excerpt "lib/intent.dart (map)"?>
```dart
void main() {
  runApp(MaterialApp(
    home: const MyAppHome(), // Torna-se a rota nomeada '/'.
    routes: <String, WidgetBuilder>{
      '/a': (context) => const MyPage(title: 'página A'),
      '/b': (context) => const MyPage(title: 'página B'),
      '/c': (context) => const MyPage(title: 'página C'),
    },
  ));
}
```

Navegue até uma rota enviando seu nome para o `Navigator`.

<?code-excerpt "lib/intent.dart (push)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

O outro caso de uso popular para `Intent`s é chamar componentes externos,
como uma câmera ou seletor de arquivos. Para isso, você precisaria criar
uma integração de plataforma nativa (ou usar um [plugin existente][]).

Para aprender como construir uma integração de plataforma nativa,
veja [desenvolvimento de pacotes e plugins][].

### Como eu lido com intents recebidos de aplicativos externos no Flutter?

O Flutter pode lidar com intents recebidos do Android conversando diretamente
com a camada Android e solicitando os dados que foram compartilhados.

O exemplo a seguir registra um filtro de intent de compartilhamento de texto
na activity nativa que executa nosso código Flutter, para que outros
aplicativos possam compartilhar texto com nosso aplicativo Flutter.

O fluxo básico implica que primeiro lidamos com os dados de texto
compartilhados no lado nativo do Android (em nossa `Activity`) e, em
seguida, aguardamos até que o Flutter solicite os dados para fornecê-los
usando um `MethodChannel`.

Primeiro, registre o filtro de intent para todos os intents em
`AndroidManifest.xml`:

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

Então, em `MainActivity`, manipule o intent, extraia o texto que foi
compartilhado do intent e o guarde. Quando o Flutter estiver pronto para
processar, ele solicita os dados usando um canal de plataforma e eles são
enviados do lado nativo:

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
        handleSendText(intent); // Manipula o envio de texto
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

Finalmente, solicite os dados do lado do Flutter
quando o widget é renderizado:

<?code-excerpt "lib/request_data.dart"?>
```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  // Este widget é a raiz do seu aplicativo.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manipulador de Aplicativo Compartilhado de Amostra',
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
  String dataShared = 'Sem dados';

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

A classe `Navigator` lida com o roteamento no Flutter e é usada para
obter um resultado de volta de uma rota que você enviou para a pilha.
Isso é feito usando `await` no `Future` retornado por `push()`.

Por exemplo, para iniciar uma rota de localização que permita ao usuário
selecionar sua localização, você pode fazer o seguinte:

<?code-excerpt "lib/intent.dart (push-await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro de sua rota de localização, depois que o usuário selecionou
sua localização, você pode `pop` a pilha com o resultado:

<?code-excerpt "lib/intent.dart (pop)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

## UI Assíncrona

### Qual é o equivalente de runOnUiThread() no Flutter?

O Dart tem um modelo de execução de thread única, com suporte para
`Isolate`s (uma forma de executar código Dart em outra thread), um loop de
eventos e programação assíncrona. A menos que você gere um `Isolate`, seu
código Dart é executado na thread principal da UI e é impulsionado por um
loop de eventos. O loop de eventos do Flutter é equivalente ao `Looper`
principal do Android&mdash;ou seja, o `Looper` que está anexado à thread
principal.

O modelo de thread única do Dart não significa que você precise executar
tudo como uma operação de bloqueio que faz com que a UI congele. Ao
contrário do Android, que exige que você mantenha a thread principal livre
em todos os momentos, no Flutter, use os recursos assíncronos que a
linguagem Dart oferece, como `async`/`await`, para realizar trabalhos
assíncronos. Você pode estar familiarizado com o paradigma `async`/`await`
se já o usou em C#, Javascript ou se usou as corrotinas do Kotlin.

Por exemplo, você pode executar código de rede sem fazer com que a UI
trave usando `async`/`await` e deixando o Dart fazer o trabalho pesado:

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

Depois que a chamada de rede `await` terminar, atualize a UI chamando
`setState()`, que aciona uma reconstrução da subárvore de widgets e
atualiza os dados.

O exemplo a seguir carrega dados de forma assíncrona e os exibe em um
`ListView`:

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
      title: 'Aplicativo de amostra',
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
        title: const Text('Aplicativo de amostra'),
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
      child: Text("Linha ${widgets[i]["title"]}"),
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

Consulte a próxima seção para obter mais informações sobre como realizar
trabalhos em segundo plano e como o Flutter difere do Android.
### Como você move o trabalho para uma thread em segundo plano?

No Android, quando você deseja acessar um recurso de rede, normalmente você move
para uma thread em segundo plano e faz o trabalho, para não bloquear a thread
principal e evitar ANRs. Por exemplo, você pode estar usando um `AsyncTask`, um
`LiveData`, um `IntentService`, um job `JobScheduler` ou um pipeline RxJava com um
scheduler que funciona em threads em segundo plano.

Como o Flutter é single-threaded e executa um loop de eventos (como o Node.js),
você não precisa se preocupar com o gerenciamento de threads ou com o
lançamento de threads em segundo plano. Se você estiver fazendo trabalho
vinculado a E/S, como acesso a disco ou uma chamada de rede, então você
pode usar com segurança `async`/`await` e está tudo certo. Se, por outro
lado, você precisa fazer um trabalho computacionalmente intensivo que mantém a CPU
ocupada, você deseja movê-lo para um `Isolate` para evitar o bloqueio do loop
de eventos, assim como você manteria _qualquer_ tipo de trabalho fora da
thread principal no Android.

Para trabalho vinculado a E/S, declare a função como uma função `async` e
`await` em tarefas de longa duração dentro da função:

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

É assim que você normalmente faria chamadas de rede ou banco de dados, que são ambas
operações de E/S.

No Android, quando você estende `AsyncTask`, você normalmente sobrescreve 3
métodos, `onPreExecute()`, `doInBackground()` e `onPostExecute()`. Não há
equivalente no Flutter, já que você usa `await` em uma função de longa duração, e
o loop de eventos do Dart cuida do resto.

No entanto, há momentos em que você pode estar processando uma grande quantidade de
dados e sua UI trava. No Flutter, use `Isolate`s para aproveitar
vários núcleos de CPU para fazer tarefas de longa duração ou computacionalmente
intensivas.

Isolates são threads de execução separadas que não compartilham nenhuma memória
com o heap de memória de execução principal. Isso significa que você não pode
acessar variáveis ​​da thread principal ou atualizar sua UI chamando
`setState()`. Diferente das threads do Android, os Isolates são fiéis ao seu
nome e não podem compartilhar memória (na forma de campos estáticos, por exemplo).

O exemplo a seguir mostra, em um isolate simples, como compartilhar dados de
volta para a thread principal para atualizar a UI.

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

Aqui, `dataLoader()` é o `Isolate` que é executado em sua própria thread de
execução separada. No isolate, você pode realizar um processamento mais
intensivo de CPU (análise de um grande JSON, por exemplo), ou realizar
cálculos computacionalmente intensivos, como criptografia ou processamento de
sinal.

Você pode executar o exemplo completo abaixo:

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

### Qual é o equivalente do OkHttp no Flutter?

Fazer uma chamada de rede no Flutter é fácil quando você usa o
popular [`http` package][].

Embora o pacote http não tenha todos os recursos encontrados no OkHttp,
ele abstrai grande parte da rede que você normalmente implementaria
você mesmo, tornando-a uma maneira simples de fazer chamadas de rede.

Para adicionar o pacote `http` como dependência, execute `flutter pub add`:

```console
$ flutter pub add http
```

Para fazer uma chamada de rede, chame `await` na função `async` `http.get()`:

```dart
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

Future<void> loadData() async {
  var dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  http.Response response = await http.get(dataURL);
  developer.log(response.body);
}
```

### Como mostrar o progresso de uma tarefa de longa duração?

No Android, você normalmente mostraria uma view `ProgressBar` em sua UI enquanto
executa uma tarefa de longa duração em uma thread em segundo plano.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando quando ele é renderizado
por meio de um sinalizador booleano. Diga ao Flutter para atualizar seu estado antes que sua
tarefa de longa duração seja iniciada e oculte-o após o término.

No exemplo a seguir, a função build é separada em três funções
diferentes. Se `showLoadingDialog` for `true` (quando `widgets.isEmpty`),
renderize o `ProgressIndicator`. Caso contrário, renderize o `ListView` com
os dados retornados de uma chamada de rede.

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

## Estrutura e recursos do projeto

### Onde armazeno meus arquivos de imagem dependentes da resolução?

Enquanto o Android trata recursos e assets como itens distintos, os aplicativos
Flutter têm apenas assets. Todos os recursos que estariam nas pastas
`res/drawable-*` no Android, são colocados em uma pasta de assets para Flutter.

O Flutter segue um formato simples baseado em densidade como o iOS.
Os assets podem ser `1.0x`, `2.0x`, `3.0x` ou qualquer outro multiplicador.
O Flutter não tem `dp`s, mas existem pixels lógicos, que são basicamente os
mesmos que pixels independentes de dispositivo. O [`devicePixelRatio`][] do
Flutter expressa a proporção de pixels físicos em um único pixel lógico.

O equivalente aos buckets de densidade do Android são:

 Qualificador de densidade do Android | Proporção de pixel do Flutter
 --- | ---
 `ldpi` | `0.75x`
 `mdpi` | `1.0x`
 `hdpi` | `1.5x`
 `xhdpi` | `2.0x`
 `xxhdpi` | `3.0x`
 `xxxhdpi` | `4.0x`

Os assets estão localizados em qualquer pasta arbitrária — o Flutter não
tem estrutura de pastas predefinida. Você declara os assets (com localização) no
arquivo `pubspec.yaml` e o Flutter os coleta.

Os assets armazenados na pasta de assets nativa são acessados no lado nativo
usando o `AssetManager` do Android:

```kotlin
val flutterAssetStream = assetManager.open("flutter_assets/assets/my_flutter_asset.png")
```

O Flutter não pode acessar recursos ou assets nativos.

Para adicionar um novo asset de imagem chamado `my_icon.png` ao nosso projeto
Flutter, por exemplo, e decidindo que ele deve estar em uma pasta que
arbitrariamente chamamos de `images`, você colocaria a imagem base (1.0x)
na pasta `images` e todas as outras variantes em subpastas
chamadas com o multiplicador de proporção apropriado:

```plaintext
images/my_icon.png       // Base: imagem 1.0x
images/2.0x/my_icon.png  // imagem 2.0x
images/3.0x/my_icon.png  // imagem 3.0x
```

Em seguida, você precisará declarar essas imagens em seu arquivo `pubspec.yaml`:

```yaml
assets:
 - images/my_icon.png
```

Você pode acessar suas imagens usando `AssetImage`:

```dart
AssetImage('images/my_icon.png')
```

ou diretamente em um widget `Image`:

```dart
@override
Widget build(BuildContext context) {
  return Image.asset('images/my_image.png');
}
```

### Onde armazeno as strings? Como faço para lidar com a localização?

Atualmente, o Flutter não tem um sistema dedicado semelhante a recursos para
strings. A melhor prática e recomendada é manter suas strings em um arquivo
`.arb` como pares chave-valor. Por exemplo:

```json
{
   "@@locale": "en",
   "hello":"Olá {userName}",
   "@hello":{
      "description":"Uma mensagem com um único parâmetro",
      "placeholders":{
         "userName":{
            "type":"String",
            "example":"Bob"
         }
      }
   }
}
```

Então, em seu código, você pode acessar suas strings da seguinte forma:

```dart
Text(AppLocalizations.of(context)!.hello('John'));
```

O Flutter tem suporte básico para acessibilidade no Android, embora esse
recurso esteja em andamento.

Consulte [Internacionalizando aplicativos Flutter][] para obter mais informações
sobre isso.

### Qual é o equivalente de um arquivo Gradle? Como faço para adicionar dependências?

No Android, você adiciona dependências adicionando ao seu script de build do
Gradle. O Flutter usa o próprio sistema de build do Dart e o gerenciador de
pacotes Pub. As ferramentas delegam a construção dos aplicativos wrapper
nativos do Android e iOS para os respectivos sistemas de build.

Embora existam arquivos Gradle na pasta `android` em seu projeto Flutter, use-os
apenas se estiver adicionando dependências nativas necessárias para a
integração por plataforma. Em geral, use `pubspec.yaml` para declarar
dependências externas para usar no Flutter. Um bom lugar para encontrar pacotes
Flutter é [pub.dev][].

## Activities e fragments

### Quais são os equivalentes de activities e fragments no Flutter?

No Android, uma `Activity` representa uma única coisa focada que o usuário pode
fazer. Um `Fragment` representa um comportamento ou uma porção da interface do
usuário. Fragments são uma forma de modularizar seu código, compor interfaces
de usuário sofisticadas para telas maiores e ajudar a dimensionar a UI do seu
aplicativo. No Flutter, esses dois conceitos se enquadram no guarda-chuva de
`Widget`s.

Para saber mais sobre a UI para a construção de Activities e Fragments,
consulte o artigo do Medium, de contribuição da comunidade,
[Flutter for Android Developers: How to design Activity UI in Flutter][].

Como mencionado na seção [Intents][], telas no Flutter são representadas por
`Widget`s, já que tudo é um widget no Flutter. Use um `Navigator` para se mover
entre diferentes `Route`s que representam diferentes telas ou páginas, ou talvez
diferentes estados ou renderizações dos mesmos dados.

### Como faço para ouvir os eventos do ciclo de vida da activity do Android?

No Android, você pode sobrescrever métodos da `Activity` para capturar métodos
de ciclo de vida para a própria activity ou registrar `ActivityLifecycleCallbacks`
no `Application`. No Flutter, você não tem nenhum desses conceitos, mas pode,
em vez disso, ouvir os eventos do ciclo de vida conectando-se ao observador
`WidgetsBinding` e ouvindo o evento de alteração `didChangeAppLifecycleState()`.

Os eventos de ciclo de vida observáveis ​​são:

* `detached` — O aplicativo ainda está hospedado em um mecanismo Flutter, mas
está desanexado de quaisquer views do host.
* `inactive` — O aplicativo está em um estado inativo e não está recebendo
entrada do usuário.
* `paused` — O aplicativo não está visível para o usuário, não responde à
entrada do usuário e está em execução em segundo plano. Isso é equivalente a
`onPause()` no Android.
* `resumed` — O aplicativo está visível e respondendo à entrada do usuário.
Isso é equivalente a `onPostResume()` no Android.

Para obter mais detalhes sobre o significado desses estados, consulte a
documentação [`AppLifecycleStatus`][].

Como você deve ter percebido, apenas uma pequena minoria dos eventos de ciclo
de vida da Activity estão disponíveis; enquanto a `FlutterActivity` captura
quase todos os eventos de ciclo de vida da activity internamente e os envia
para o mecanismo Flutter, eles são principalmente protegidos de você. O Flutter
cuida de iniciar e parar o mecanismo para você, e há pouca razão para
precisar observar o ciclo de vida da activity no lado do Flutter na maioria dos
casos. Se você precisar observar o ciclo de vida para adquirir ou liberar
quaisquer recursos nativos, você provavelmente deve estar fazendo isso do lado
nativo, de qualquer forma.

Aqui está um exemplo de como observar o status do ciclo de vida da activity
contêiner:

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
        'Este widget não observou nenhuma mudança no ciclo de vida.',
        textDirection: TextDirection.ltr,
      );
    }

    return Text(
      'O estado de ciclo de vida mais recente que este widget observou foi: $_lastLifecycleState.',
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

No Android, um LinearLayout é usado para dispor seus widgets de forma
linear — horizontal ou verticalmente. No Flutter, use os widgets Row ou
Column para obter o mesmo resultado.

Se você observar que as duas amostras de código são idênticas, com exceção do
widget "Row" e "Column". Os filhos são os mesmos e este recurso pode ser
explorado para desenvolver layouts ricos que podem mudar ao longo do tempo com
os mesmos filhos.

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

Para saber mais sobre a construção de layouts lineares, consulte o artigo do
Medium, de contribuição da comunidade,
[Flutter for Android Developers: How to design LinearLayout in Flutter][].

### Qual é o equivalente de um RelativeLayout?

Um RelativeLayout dispõe seus widgets em relação uns aos outros. No
Flutter, existem algumas maneiras de obter o mesmo resultado.

Você pode obter o resultado de um RelativeLayout usando uma combinação de
widgets Column, Row e Stack. Você pode especificar regras para os construtores
de widgets sobre como os filhos são dispostos em relação ao pai.

Para um bom exemplo de como construir um RelativeLayout no Flutter, consulte a
resposta de Collin em [StackOverflow][].

### Qual é o equivalente de um ScrollView?

No Android, use um ScrollView para dispor seus widgets — se o dispositivo do
usuário tiver uma tela menor que seu conteúdo, ele rola.

No Flutter, a maneira mais fácil de fazer isso é usando o widget ListView.
Isso pode parecer exagero vindo do Android, mas no Flutter um widget ListView
é tanto um ScrollView quanto um ListView do Android.

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

### Como faço para lidar com transições de paisagem no Flutter?

FlutterView lida com a mudança de configuração se AndroidManifest.xml
contiver:

```yaml
android:configChanges="orientation|screenSize"
```

## Detecção de gestos e tratamento de eventos de toque

### Como adiciono um listener onClick a um widget no Flutter?

No Android, você pode anexar onClick a views como um botão chamando o método
`setOnClickListener`.

No Flutter, existem duas maneiras de adicionar listeners de toque:

 1. Se o Widget suportar detecção de eventos, passe uma função para ele e
    trate-o na função. Por exemplo, o ElevatedButton tem um parâmetro
    `onPressed`:

  ```dart
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        developer.log('clique');
      },
      child: const Text('Botão'),
    );
  }
  ```

 2. Se o Widget não suportar detecção de eventos, envolva o widget em um
    GestureDetector e passe uma função para o parâmetro `onTap`.

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

### Como faço para lidar com outros gestos em widgets?

Usando o GestureDetector, você pode ouvir uma ampla gama de Gestos, como:

* Toque

  * `onTapDown` - Um ponteiro que pode causar um toque entrou em contato com a
    tela em um local específico.
  * `onTapUp` - Um ponteiro que aciona um toque parou de entrar em contato com a
    tela em um local específico.
  * `onTap` - Ocorreu um toque.
  * `onTapCancel` - O ponteiro que anteriormente acionou o `onTapDown` não
    causará um toque.

* Toque duplo

  * `onDoubleTap` - O usuário tocou na tela no mesmo local duas vezes em rápida
    sucessão.

* Pressão longa

  * `onLongPress` - Um ponteiro permaneceu em contato com a tela no mesmo local
    por um longo período de tempo.

* Arrastar vertical

  * `onVerticalDragStart` - Um ponteiro entrou em contato com a tela e pode
    começar a se mover verticalmente.
  * `onVerticalDragUpdate` - Um ponteiro em contato com a tela se moveu mais
    na direção vertical.
  * `onVerticalDragEnd` - Um ponteiro que estava anteriormente em contato com a
    tela e se movendo verticalmente não está mais em contato com a tela e estava
    se movendo a uma velocidade específica quando parou de entrar em contato com a
    tela.

* Arrastar horizontal

  * `onHorizontalDragStart` - Um ponteiro entrou em contato com a tela e pode
    começar a se mover horizontalmente.
  * `onHorizontalDragUpdate` - Um ponteiro em contato com a tela se moveu mais
    na direção horizontal.
  * `onHorizontalDragEnd` - Um ponteiro que estava anteriormente em contato com a
    tela e se movendo horizontalmente não está mais em contato com a tela e
    estava se movendo a uma velocidade específica quando parou de entrar em
    contato com a tela.

O exemplo a seguir mostra um `GestureDetector` que gira o logotipo do Flutter
em um toque duplo:

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

### Qual é a alternativa para uma ListView no Flutter?

O equivalente a uma ListView no Flutter é… uma ListView!

Em uma ListView do Android, você cria um adapter e o passa para a ListView, que
renderiza cada linha com o que seu adapter retorna. No entanto, você precisa
garantir que recicle suas linhas, caso contrário, você terá todos os tipos de
falhas visuais e problemas de memória.

Devido ao padrão de widget imutável do Flutter, você passa uma lista de
widgets para sua ListView, e o Flutter cuida de garantir que a rolagem seja
rápida e suave.

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
        child: Text('Linha $i'),
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
  // Este widget é a raiz do seu aplicativo.
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
            developer.log('linha clicada');
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Text('Linha $i'),
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
Isso ocorre porque quando `setState()` é chamado, o mecanismo de renderização do
Flutter analisa a árvore de widgets para ver se algo mudou. Quando chega ao seu
`ListView`, ele executa uma verificação `==` e determina que os dois
`ListView`s são os mesmos. Nada mudou, então nenhuma atualização é necessária.

Para uma maneira simples de atualizar seu `ListView`, crie uma nova `List` dentro
de `setState()` e copie os dados da lista antiga para a nova lista.
Embora essa abordagem seja simples, ela não é recomendada para grandes conjuntos
de dados, como mostrado no próximo exemplo.

<?code-excerpt "lib/listview_dynamic.dart"?>
```dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  // Este widget é a raiz do seu aplicativo.
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
          developer.log('linha $i');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Linha $i'),
      ),
    );
  }
}
```

A maneira recomendada, eficiente e eficaz de construir uma lista usa um
`ListView.Builder`. Este método é ótimo quando você tem uma `List` dinâmica
ou uma `List` com quantidades muito grandes de dados. Isso é essencialmente
o equivalente ao RecyclerView no Android, que automaticamente recicla os
elementos da lista para você:

<?code-excerpt "lib/listview_builder.dart"?>
```dart
import 'dart:developer' as developer;

import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  // Este widget é a raiz do seu aplicativo.
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
          developer.log('linha $i');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Linha $i'),
      ),
    );
  }
}
```

Em vez de criar um "ListView", crie um
`ListView.builder` que recebe dois parâmetros principais: o
comprimento inicial da lista e uma função `ItemBuilder`.

A função `ItemBuilder` é semelhante à função `getView`
em um adapter do Android; ela recebe uma posição e
retorna a linha que você deseja renderizada nessa posição.

Finalmente, mas o mais importante, observe que a função `onTap()` não
recria mais a lista, mas em vez disso, usa `.add` para adiciona-la.

## Trabalhando com texto

### Como eu configuro fontes personalizadas em meus widgets de Texto?

No Android SDK (a partir do Android O), você cria um arquivo de recurso Font e
o passa para o parâmetro FontFamily do seu TextView.

No Flutter, coloque o arquivo de fonte em uma pasta e faça referência a ele no
arquivo `pubspec.yaml`, semelhante a como você importa imagens.

```yaml
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
```

Em seguida, atribua a fonte ao seu widget `Text`:

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
        'Este é um texto de fonte personalizada',
        style: TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
```

### Como eu estilizo meus widgets de Texto?

Juntamente com as fontes, você pode personalizar outros elementos de estilo em um
widget `Text`. O parâmetro style de um widget `Text` usa um objeto
`TextStyle`, onde você pode personalizar vários parâmetros, como:

* cor
* decoração
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

Para obter mais informações sobre como usar formulários,
veja [Recuperar o valor de um campo de texto][],
do [Livro de receitas do Flutter][].

### Qual é o equivalente de uma "dica" em uma Entrada?

No Flutter, você pode facilmente mostrar uma "dica" ou um texto de espaço
reservado para sua entrada adicionando um objeto InputDecoration ao parâmetro
do construtor de decoração para o Widget de Texto.

<?code-excerpt "lib/form.dart (input-hint)" replace="/return const //g;/;//g"?>
```dart
Center(
  child: TextField(
    decoration: InputDecoration(hintText: 'Esta é uma dica'),
  ),
)
```

### Como eu mostro erros de validação?

Assim como você faria com uma "dica", passe um objeto InputDecoration
para o construtor de decoração do widget de Texto.

No entanto, você não quer começar mostrando um erro.
Em vez disso, quando o usuário inserir dados inválidos,
atualize o estado e passe um novo objeto `InputDecoration`.

<?code-excerpt "lib/validation_errors.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const SampleApp());
}

class SampleApp extends StatelessWidget {
  const SampleApp({super.key});
  // Este widget é a raiz do seu aplicativo.
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

## Plugins do Flutter

### Como eu acesso o sensor GPS?

Use o plugin da comunidade [`geolocator`][].

### Como eu acesso a câmera?

O plugin [`image_picker`][] é popular
para acessar a câmera.

### Como eu faço login com o Facebook?

Para fazer login com o Facebook, use o
plugin da comunidade [`flutter_facebook_login`][].

### Como eu uso os recursos do Firebase?

A maioria das funções do Firebase são cobertas por
[plugins de primeira parte][].
Esses plugins são integrações de primeira parte,
mantidos pela equipe do Flutter:

 * [`google_mobile_ads`][] para Google Mobile Ads para Flutter
 * [`firebase_analytics`][] para Firebase Analytics
 * [`firebase_auth`][] para Firebase Auth
 * [`firebase_database`][] para Firebase RTDB
 * [`firebase_storage`][] para Firebase Cloud Storage
 * [`firebase_messaging`][] para Firebase Messaging (FCM)
 * [`flutter_firebase_ui`][] para integrações rápidas do Firebase Auth
   (Facebook, Google, Twitter e e-mail)
 * [`cloud_firestore`][] para Firebase Cloud Firestore

Você também pode encontrar alguns plugins Firebase de terceiros em
pub.dev que cobrem áreas não diretamente cobertas pelos
plugins de primeira parte.

### Como eu construo minhas próprias integrações nativas personalizadas?

Se houver funcionalidade específica da plataforma que o Flutter
ou seus Plugins da comunidade estão faltando,
você pode construir o seu próprio seguindo a
página [desenvolvendo pacotes e plugins][].

A arquitetura de plugin do Flutter, em poucas palavras, é muito parecida com o
uso de um barramento de eventos no Android: você dispara uma mensagem e deixa o
receptor processar e emitir um resultado de volta para você. Nesse caso, o
receptor é o código em execução no lado nativo no Android ou iOS.

### Como eu uso o NDK no meu aplicativo Flutter?

Se você usa o NDK em seu aplicativo Android atual e deseja que seu aplicativo
Flutter aproveite suas bibliotecas nativas, é possível construindo um plugin
personalizado.

Seu plugin personalizado primeiro conversa com seu aplicativo Android, onde você
chama suas funções `native` sobre JNI. Assim que uma resposta estiver pronta,
envie uma mensagem de volta para o Flutter e renderize o resultado.

Chamar código nativo diretamente do Flutter atualmente não é compatível.

## Temas

### Como eu defino o tema do meu aplicativo?

Imediatamente, o Flutter vem com uma bela implementação do Material
Design, que cuida de muitas necessidades de estilo e tema que você
normalmente faria. Ao contrário do Android, onde você declara temas em XML e
depois os atribui ao seu aplicativo usando AndroidManifest.xml, no Flutter você
declara temas no widget de nível superior.

Para aproveitar ao máximo os Componentes Material em seu aplicativo, você pode
declarar um widget de nível superior `MaterialApp` como o ponto de entrada para
seu aplicativo. MaterialApp é um widget de conveniência que envolve vários
widgets que são comumente necessários para aplicativos que implementam o
Material Design. Ele se baseia em um WidgetsApp adicionando funcionalidade
específica do Material.

Você também pode usar um `WidgetsApp` como o widget do seu aplicativo, que
fornece algumas das mesmas funcionalidades, mas não é tão rico quanto
`MaterialApp`.

Para personalizar as cores e estilos de qualquer componente filho, passe um
objeto `ThemeData` para o widget `MaterialApp`. Por exemplo, no código abaixo,
o esquema de cores da semente é definido como roxo profundo e a cor de seleção
de texto é vermelha.

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

### Como eu acesso as Preferências Compartilhadas?

No Android, você pode armazenar uma pequena coleção de pares de chave-valor usando
a API SharedPreferences.

No Flutter, acesse essa funcionalidade usando o
[plugin Shared_Preferences][].
Este plugin envolve a funcionalidade de ambos
Preferências Compartilhadas e NSUserDefaults (o equivalente iOS).

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
            child: Text('Incrementar Contador'),
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

### Como eu acesso o SQLite no Flutter?

No Android, você usa o SQLite para armazenar dados estruturados
que você pode consultar usando SQL.

No Flutter, para macOS, Android ou iOS,
acesse essa funcionalidade usando o
plugin [SQFlite][].

## Depuração

### Quais ferramentas eu posso usar para depurar meu aplicativo no Flutter?

Use o conjunto [DevTools][] para depurar aplicativos Flutter ou Dart.

O DevTools inclui suporte para criação de perfil, exame do heap, inspeção da
árvore de widgets, registro de diagnósticos, depuração, observação de linhas de
código executadas, depuração de vazamentos de memória e fragmentação de memória.
Para mais informações, consulte a
documentação do [DevTools][].

## Notificações

### Como eu configuro notificações push?

No Android, você usa o Firebase Cloud Messaging para configurar
notificações push para seu aplicativo.

No Flutter, acesse essa funcionalidade usando o
plugin [Firebase Messaging][].
Para mais informações sobre como usar a API Firebase Cloud Messaging,
consulte a documentação do plugin [`firebase_messaging`][].

[Adicionar Flutter a um aplicativo existente]: /add-to-app
[Widgets de Animação e Movimento]: /ui/widgets/animation
[Tutorial de Animações]: /ui/animations/tutorial
[Visão geral de Animações]: /ui/animations
[Documentação do `AppLifecycleStatus`]: {{site.api}}/flutter/dart-ui/AppLifecycleState.html
[Linguagem de design iOS da Apple]: {{site.apple-dev}}/design/resources/
[`cloud_firestore`]: {{site.pub}}/packages/cloud_firestore
[composição]: /resources/architectural-overview#composition
[Widgets Cupertino]: /ui/widgets/cupertino
[desenvolvendo pacotes e plugins]: /packages-and-plugins/developing-packages
[`devicePixelRatio`]: {{site.api}}/flutter/dart-ui/FlutterView/devicePixelRatio.html
[DevTools]: /tools/devtools
[plugin existente]: {{site.pub}}/flutter/
[`flutter_facebook_login`]: {{site.pub}}/packages/flutter_facebook_login
[`google_mobile_ads`]: {{site.pub}}/packages/google_mobile_ads
[`firebase_analytics`]: {{site.pub}}/packages/firebase_analytics
[`firebase_auth`]: {{site.pub}}/packages/firebase_auth
[`firebase_database`]: {{site.pub}}/packages/firebase_database
[`firebase_messaging`]: {{site.pub}}/packages/firebase_messaging
[`firebase_storage`]: {{site.pub}}/packages/firebase_storage
[`flutter_firebase_ui`]: {{site.pub}}/packages/flutter_firebase_ui
[Firebase Messaging]: {{site.github}}/firebase/flutterfire/tree/master/packages/firebase_messaging
[plugins de primeira parte]: {{site.pub}}/flutter/packages?q=firebase
[Livro de receitas do Flutter]: /cookbook
[Flutter para Desenvolvedores Android: Como projetar LinearLayout no Flutter]: https://proandroiddev.com/flutter-for-android-developers-how-to-design-linearlayout-in-flutter-5d819c0ddf1a
[Flutter para Desenvolvedores Android: Como projetar a UI da Activity no Flutter]: https://blog.usejournal.com/flutter-for-android-developers-how-to-design-activity-ui-in-flutter-4bf7b0de1e48
[`geolocator`]: {{site.pub}}/packages/geolocator
[`http` package]: {{site.pub}}/packages/http
[`image_picker`]: {{site.pub}}/packages/image_picker
[Intents]: #qual-e-o-equivalente-de-um-intent-no-flutter
[intl package]: {{site.pub}}/packages/intl
[Introdução à UI declarativa]: /get-started/flutter-for/declarative
[Componentes Material]: {{site.material}}/develop/flutter
[Diretrizes de Design Material]: {{site.material}}/styles
[otimizado para todas as plataformas]: {{site.material}}/develop
[um plugin]: {{site.pub}}/packages/android_intent
[pub.dev]: {{site.pub}}/flutter/packages/
[Recuperar o valor de um campo de texto]: /cookbook/forms/retrieve-input
[plugin Shared_Preferences]: {{site.pub}}/packages/shared_preferences
[SQFlite]: {{site.pub}}/packages/sqflite
[StackOverflow]: {{site.so}}/questions/44396075/equivalent-of-relativelayout-in-flutter
[catálogo de widgets]: /ui/widgets/layout
[Internacionalizando aplicativos Flutter]: /ui/accessibility-and-internationalization/internationalization
