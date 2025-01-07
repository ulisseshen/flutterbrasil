---
ia-translate: true
title: Flutter para desenvolvedores UIKit
description: Aprenda como aplicar o conhecimento de desenvolvedor iOS e UIKit ao criar aplicativos Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/ios_devs"?>

Desenvolvedores iOS com experiência no uso de UIKit
que desejam escrever aplicativos móveis usando o Flutter
devem revisar este guia.
Ele explica como aplicar o conhecimento existente de UIKit ao Flutter.

:::note
Se você tiver experiência na criação de aplicativos com SwiftUI,
confira [Flutter para desenvolvedores SwiftUI][] em vez disso.
:::

Flutter é um framework para criar aplicativos multiplataforma
que usa a linguagem de programação Dart.
Para entender algumas diferenças entre programar com Dart
e programar com Swift,
confira [Aprendendo Dart como um desenvolvedor Swift][]
e [Concorrência do Flutter para desenvolvedores Swift][].

Seu conhecimento e experiência em iOS e UIKit
são muito valiosos ao construir com o Flutter.
{% comment %}
  TODO: Adicionar discussão sobre o sistema de plugins para interação com o SO e hardware
  quando [Interações de hardware iOS e Apple com Flutter][] for lançado.
{% endcomment -%}

O Flutter também faz uma série de adaptações
no comportamento do aplicativo quando executado no iOS.
Para saber como, consulte [Adaptações de plataforma][].

:::tip
Para integrar o código do Flutter em um aplicativo iOS **existente**,
confira [Adicionar Flutter a um aplicativo existente][].
:::

Use este guia como um livro de receitas.
Explore e encontre perguntas que abordem suas necessidades mais relevantes.

## Visão geral

Como introdução, assista ao vídeo a seguir.
Ele descreve como o Flutter funciona no iOS e como usar o Flutter para criar aplicativos iOS.

{% ytEmbed 'ceMsPBbcEGg', 'Flutter para desenvolvedores iOS', false, true %}

### Views vs. Widgets

:::secondary
Como a programação no estilo React, ou _declarativa_,
é diferente do estilo imperativo tradicional?
Para uma comparação, consulte [Introdução à UI declarativa][].
:::

No UIKit, a maior parte do que você cria na UI é feita usando objetos view,
que são instâncias da classe `UIView`.
Eles podem atuar como contêineres para outras classes `UIView`,
que formam seu layout.

No Flutter, o equivalente aproximado a um `UIView` é um `Widget`.
Widgets não mapeiam exatamente para as views do iOS,
mas enquanto você está se familiarizando com o funcionamento do Flutter,
pode pensar neles como "a maneira como você declara e constrói a UI".

No entanto, estes têm algumas diferenças para um `UIView`.
Para começar, os widgets têm uma vida útil diferente: eles são imutáveis
e só existem até que precisem ser alterados.
Sempre que os widgets ou seu estado mudam,
o framework do Flutter cria uma nova árvore de instâncias de widgets.
Em comparação, uma view do UIKit não é recriada quando muda,
mas sim uma entidade mutável que é desenhada uma vez
e não redesenha até que seja invalidada usando `setNeedsDisplay()`.

Além disso, ao contrário do `UIView`, os widgets do Flutter são leves,
em parte devido à sua imutabilidade.
Porque eles não são views em si,
e não estão desenhando nada diretamente,
mas sim uma descrição da UI e sua semântica
que são "infladas" em objetos view reais sob o capô.

O Flutter inclui a biblioteca [Componentes Material][].
Esses são widgets que implementam as
[diretrizes do Material Design][].
Material Design é um sistema de design flexível
[otimizado para todas as plataformas][], incluindo iOS.

Mas o Flutter é flexível e expressivo o suficiente
para implementar qualquer linguagem de design.
No iOS, você pode usar a biblioteca [widgets Cupertino][]
para produzir uma interface que se pareça com a
[linguagem de design do iOS da Apple][].

### Atualizando widgets

Para atualizar suas views no UIKit, você as modifica diretamente.
No Flutter, os widgets são imutáveis e não são atualizados diretamente.
Em vez disso, você precisa manipular o estado do widget.

É aqui que entra o conceito de widgets com estado (Stateful) vs. sem estado (Stateless).
Um `StatelessWidget` é exatamente o que parece&mdash;um widget sem estado anexado.

`StatelessWidgets` são úteis quando a parte da interface do usuário que você está
descrevendo não depende de nada além das informações de configuração inicial
no widget.

Por exemplo, com o UIKit, isso é semelhante a colocar um `UIImageView`
com seu logotipo como a `image`. Se o logotipo não estiver mudando durante o tempo de execução,
use um `StatelessWidget` no Flutter.

Se você quiser alterar dinamicamente a UI com base em dados recebidos
após fazer uma chamada HTTP, use um `StatefulWidget`.
Depois que a chamada HTTP for concluída, diga ao framework do Flutter
que o `State` do widget foi atualizado, para que ele possa atualizar a UI.

A diferença importante entre widgets stateless e
stateful é que `StatefulWidget`s têm um objeto `State`
que armazena dados de estado e os carrega durante as reconstruções da árvore,
para que não sejam perdidos.

Se você estiver em dúvida, lembre-se desta regra:
se um widget mudar fora do método `build`
(devido a interações do usuário em tempo de execução, por exemplo),
ele é stateful.
Se o widget nunca mudar, uma vez construído, ele é stateless.
No entanto, mesmo que um widget seja stateful, o widget pai contendo
ainda pode ser stateless se ele próprio não estiver reagindo a essas mudanças
(ou outras entradas).

O exemplo a seguir mostra como usar um `StatelessWidget`.
Um `StatelessWidget` comum é o widget `Text`.
Se você olhar para a implementação do widget `Text`,
você descobrirá que ele é uma subclasse de `StatelessWidget`.

<?code-excerpt "lib/text_widget.dart (text-widget)" replace="/return const //g"?>
```dart
Text(
  'Eu gosto de Flutter!',
  style: TextStyle(fontWeight: FontWeight.bold),
);
```

Se você observar o código acima, poderá notar que o widget `Text`
não carrega nenhum estado explícito com ele. Ele renderiza o que é passado em seus
construtores e nada mais.

Mas, e se você quiser fazer com que "Eu gosto de Flutter" mude dinamicamente,
por exemplo, ao clicar em um `FloatingActionButton`?

Para conseguir isso, envolva o widget `Text` em um `StatefulWidget` e
atualize-o quando o usuário clicar no botão.

Por exemplo:

<?code-excerpt "lib/text_widget.dart (stateful-widget)"?>
```dart

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
  // Texto de espaço reservado padrão
  String textToShow = 'Eu gosto de Flutter';

  void _updateText() {
    setState(() {
      // Atualize o texto
      textToShow = 'Flutter é Incrível!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sample App')),
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

### Layout de widgets

No UIKit, você pode usar um arquivo Storyboard
para organizar suas views e definir restrições,
ou pode definir suas restrições programaticamente em seus view controllers.
No Flutter, declare seu layout no código compondo uma árvore de widgets.

O exemplo a seguir mostra como exibir um widget simples com preenchimento:

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
        child: const Text('Olá'),
      ),
    ),
  );
}
```

Você pode adicionar preenchimento a qualquer widget,
o que imita a funcionalidade das restrições no iOS.

Você pode ver os layouts que o Flutter tem a oferecer
no [catálogo de widgets][].

### Removendo Widgets

No UIKit, você chama `addSubview()` no pai,
ou `removeFromSuperview()` em uma view filha
para adicionar ou remover dinamicamente as views filhas.
No Flutter, como os widgets são imutáveis,
não há equivalente direto a `addSubview()`.
Em vez disso, você pode passar uma função para o pai
que retorna um widget e controlar a criação desse filho
com um sinalizador booleano.

O exemplo a seguir mostra como alternar entre dois widgets
quando o usuário clica no `FloatingActionButton`:

<?code-excerpt "lib/layout.dart (toggle-widget)"?>
```dart
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
    }

    return CupertinoButton(
      onPressed: () {},
      child: const Text('Alternar Dois'),
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
        tooltip: 'Atualizar Texto',
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

No Flutter, use um `AnimationController`, que é uma `Animation<double>`
que pode pausar, procurar, parar e reverter a animação.
Requer um `Ticker` que sinaliza quando vsync acontece
e produz uma interpolação linear
entre 0 e 1 em cada frame enquanto está em execução.
Em seguida, você cria uma ou mais
`Animation`s e as anexa ao controlador.

Por exemplo, você pode usar `CurvedAnimation`
para implementar uma animação ao longo de uma curva interpolada.
Nesse sentido, o controlador é a fonte "mestre"
do progresso da animação
e o `CurvedAnimation` calcula a curva
que substitui o movimento linear padrão do controlador.
Como os widgets, as animações no Flutter funcionam com composição.

Ao construir a árvore de widgets, você atribui a `Animation` a uma propriedade animada
de um widget, como a opacidade de um `FadeTransition`,
e diz ao controlador para iniciar a animação.

O exemplo a seguir mostra como escrever um `FadeTransition` que
desvanece o widget em um logotipo quando você pressiona o `FloatingActionButton`:

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

class SampleApp extends StatelessWidget {
  // Este widget é a raiz do seu aplicativo.
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

Para obter mais informações, consulte [Widgets de animação e movimento][],
o [tutorial de animações][], e a [visão geral de animações][].

### Desenhando na tela

No UIKit, você usa `CoreGraphics` para desenhar linhas e formas na
tela. O Flutter tem uma API diferente baseada na classe `Canvas`,
com duas outras classes que ajudam você a desenhar: `CustomPaint` e `CustomPainter`,
a última das quais implementa seu algoritmo para desenhar na tela.

Para saber como implementar um desenhista de assinatura no Flutter,
veja a resposta de Collin no [StackOverflow][].

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

### Opacidade de Widget

No UIKit, tudo tem `.opacity` ou `.alpha`.
No Flutter, na maioria das vezes você precisa
envolver um widget em um widget `Opacity` para conseguir isso.

### Widgets Personalizados

No UIKit, você normalmente cria uma subclasse de `UIView`, ou usa uma view pré-existente,
para substituir e implementar métodos que alcancem o comportamento desejado.
No Flutter, construa um widget personalizado [compondo][] widgets menores
(em vez de estendê-los).

Por exemplo, como você constrói um `CustomButton`
que recebe um rótulo no construtor?
Crie um CustomButton que compõe um `ElevatedButton` com um rótulo,
em vez de estender `ElevatedButton`:

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

Em seguida, use `CustomButton`,
assim como você usaria qualquer outro widget do Flutter:

<?code-excerpt "lib/custom.dart (use-custom-button)"?>
```dart
@override
Widget build(BuildContext context) {
  return const Center(
    child: CustomButton('Olá'),
  );
}
```

### Gerenciando dependências

No iOS, você adiciona dependências com o CocoaPods adicionando ao seu `Podfile`.
O Flutter usa o sistema de build do Dart e o gerenciador de pacotes Pub
para lidar com as dependências. As ferramentas delegam a construção dos
aplicativos wrapper nativos do Android e iOS para os
sistemas de build respectivos.

Embora haja um Podfile na pasta iOS em seu
projeto Flutter, use-o somente se estiver adicionando
dependências nativas necessárias para integração por plataforma.
Em geral, use `pubspec.yaml` para declarar dependências externas no Flutter.
Um bom lugar para encontrar ótimos pacotes para Flutter é em [pub.dev][].

## Navegação

Esta seção do documento discute a navegação
entre as páginas de um aplicativo, o mecanismo de push e pop e muito mais.

### Navegando entre páginas

No UIKit, para viajar entre view controllers, você pode usar um
`UINavigationController` que gerencia a pilha de view controllers
para exibir.

O Flutter tem uma implementação semelhante,
usando um `Navigator` e `Rotas`.
Uma `Rota` é uma abstração para uma "tela" ou "página" de um aplicativo,
e um `Navigator` é um [widget][]
que gerencia rotas. Uma rota mapeia aproximadamente para um
`UIViewController`. O navegador funciona de forma semelhante ao iOS
`UINavigationController`, pois ele pode `push()` e `pop()`
rotas dependendo se você deseja navegar para, ou voltar de, uma view.

Para navegar entre as páginas, você tem algumas opções:

* Especifique um `Map` de nomes de rotas.
* Navegue diretamente para uma rota.

O exemplo a seguir constrói um `Map.`

<?code-excerpt "lib/intent.dart (map)"?>
```dart
void main() {
  runApp(
    CupertinoApp(
      home: const MyAppHome(), // se torna a rota denominada '/'
      routes: <String, WidgetBuilder>{
        '/a': (context) => const MyPage(title: 'página A'),
        '/b': (context) => const MyPage(title: 'página B'),
        '/c': (context) => const MyPage(title: 'página C'),
      },
    ),
  );
}
```

Navegue para uma rota `push`ando seu nome para o `Navigator`.

<?code-excerpt "lib/intent.dart (push)"?>
```dart
Navigator.of(context).pushNamed('/b');
```

A classe `Navigator` lida com o roteamento no Flutter e é usada para obter
um resultado de volta de uma rota que você enviou por push na pilha.
Isso é feito usando `await` no `Future` retornado por `push()`.

Por exemplo, para iniciar uma rota de `localização` que permite ao usuário selecionar seu
local, você pode fazer o seguinte:

<?code-excerpt "lib/intent.dart (push-await)"?>
```dart
Object? coordinates = await Navigator.of(context).pushNamed('/location');
```

E então, dentro de sua rota de `localização`, depois que o usuário selecionou seu
local, `pop()` a pilha com o resultado:

<?code-excerpt "lib/intent.dart (pop)"?>
```dart
Navigator.of(context).pop({'lat': 43.821757, 'long': -79.226392});
```

### Navegando para outro aplicativo

No UIKit, para enviar o usuário para outro aplicativo,
você usa um esquema de URL específico.
Para os aplicativos de nível de sistema, o esquema depende do aplicativo.
Para implementar essa funcionalidade no Flutter,
crie uma integração de plataforma nativa ou use um
[plugin existente][], como [`url_launcher`][].

### Voltar manualmente

Chamar `SystemNavigator.pop()` do seu código Dart
invoca o seguinte código iOS:

```objc
UIViewController* viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
if ([viewController isKindOfClass:[UINavigationController class]]) {
  [((UINavigationController*)viewController) popViewControllerAnimated:NO];
}
```

Se isso não fizer o que você quer, você pode criar seu próprio
[canal de plataforma][] para invocar código iOS arbitrário.

### Lidando com localização

Ao contrário do iOS, que tem o arquivo `Localizable.strings`,
o Flutter não tem atualmente um sistema dedicado para lidar com strings.
No momento, a melhor prática é declarar seu texto de cópia
em uma classe como campos estáticos e acessá-los de lá. Por exemplo:

<?code-excerpt "lib/string_examples.dart (strings)"?>
```dart
class Strings {
  static const String welcomeMessage = 'Bem-vindo ao Flutter';
}
```

Você pode acessar suas strings como tal:

<?code-excerpt "lib/string_examples.dart (access-string)" replace="/const //g; /return //g;"?>
```dart
Text(Strings.welcomeMessage);
```

Por padrão, o Flutter oferece suporte apenas ao inglês americano para suas strings.
Se você precisar adicionar suporte para outros idiomas,
inclua o pacote `flutter_localizations`.
Você também pode precisar adicionar o pacote [`intl`][] do Dart
para usar o maquinário i10n, como formatação de data/hora.

```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: any # Use a versão do intl de flutter_localizations.
```

Para usar o pacote `flutter_localizations`,
especifique `localizationsDelegates` e
`supportedLocales` no widget do aplicativo:

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
        // Adicione um(s) delegate(s) de localização específico(s) do aplicativo aqui
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
enquanto `supportedLocales` define quais locais o aplicativo suporta.
O exemplo acima usa um `MaterialApp`,
portanto, ele tem um `GlobalWidgetsLocalizations`
para os valores localizados de widgets básicos,
e um `MaterialWidgetsLocalizations` para as localizações de widgets Material.
Se você usar `WidgetsApp` para seu aplicativo, você não precisa do último.
Observe que esses dois delegates contêm valores "padrão",
mas você precisará fornecer um ou mais delegates
para a cópia localizável do seu próprio aplicativo,
se você quiser que esses sejam localizados também.

Quando inicializado, o `WidgetsApp` (ou `MaterialApp`)
cria um widget [`Localizations`][] para você,
com os delegates que você especifica.
O local atual para o dispositivo está sempre acessível
a partir do widget `Localizations` do contexto atual
(na forma de um objeto `Locale`), ou usando o [`Window.locale`][].

Para acessar recursos localizados, use o método `Localizations.of()`
para acessar uma classe de localizações específica que é fornecida por um determinado delegate.
Use o pacote [`intl_translation`][] para extrair a cópia traduzível
para arquivos [arb][] para traduzir e importá-los de volta para o aplicativo
para usá-los com `intl`.

Para mais detalhes sobre internacionalização e localização no Flutter,
consulte o [guia de internacionalização][], que tem código de exemplo
com e sem o pacote `intl`.

## ViewControllers

Esta seção do documento discute o equivalente
de ViewController no Flutter e como ouvir
eventos do ciclo de vida.

### Equivalente de ViewController no Flutter

No UIKit, um `ViewController` representa uma parte da interface do usuário,
mais comumente usada para uma tela ou seção.
Estes são compostos juntos para construir interfaces de usuário complexas
e ajudam a dimensionar a UI do seu aplicativo.
No Flutter, este trabalho cabe aos Widgets.
Conforme mencionado na seção Navegação,
as telas no Flutter são representadas por Widgets, pois
"tudo é um widget!"
Use um `Navigator` para se mover entre diferentes `Rotas`
que representam telas ou páginas diferentes,
ou talvez diferentes estados ou renderizações dos mesmos dados.

### Ouvindo eventos do ciclo de vida

No UIKit, você pode substituir métodos para o `ViewController`
para capturar métodos do ciclo de vida para a própria view,
ou registrar callbacks do ciclo de vida no `AppDelegate`.
No Flutter, você não tem nenhum conceito, mas pode, em vez disso,
ouvir os eventos do ciclo de vida conectando-se ao
observador `WidgetsBinding` e ouvindo o
evento de mudança `didChangeAppLifecycleState()`.

Os eventos de ciclo de vida observáveis são:

**`inactive`**
: O aplicativo está em um estado inativo e não está recebendo
entrada do usuário. Este evento só funciona no iOS,
pois não há evento equivalente no Android.

**`paused`**
: O aplicativo não está visível para o usuário no momento,
não está respondendo à entrada do usuário, mas está em execução em segundo plano.

**`resumed`**
: O aplicativo está visível e respondendo à entrada do usuário.

**`suspending`**
: O aplicativo é suspenso momentaneamente.
A plataforma iOS não tem evento equivalente.

Para mais detalhes sobre o significado desses estados, veja
a documentação [`AppLifecycleState`][].

## Layouts

Esta seção discute diferentes layouts no Flutter
e como eles se comparam com o UIKit.

### Exibindo uma view de lista

No UIKit, você pode mostrar uma lista em
um `UITableView` ou um `UICollectionView`.
No Flutter, você tem uma implementação semelhante usando um `ListView`.
No UIKit, essas views têm métodos de delegate
para decidir o número de linhas,
a célula para cada índice e o tamanho das células.

Devido ao padrão de widget imutável do Flutter,
você passa uma lista de widgets para seu `ListView`,
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

  // Este widget é a raiz do seu aplicativo.
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
        child: Text('Linha $i'),
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

  // Este widget é a raiz do seu aplicativo.
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
### Atualizando ListView dinamicamente

Em UIKit, você atualiza os dados para a visualização de lista e notifica a tabela ou a visualização de coleção usando o método `reloadData`.

No Flutter, se você atualizar a lista de widgets dentro de um `setState()`, verá rapidamente que seus dados não mudam visualmente. Isso ocorre porque quando `setState()` é chamado, o mecanismo de renderização do Flutter analisa a árvore de widgets para ver se algo mudou. Quando chega ao seu `ListView`, ele executa uma verificação `==` e determina que os dois `ListView`s são iguais. Nada mudou, então nenhuma atualização é necessária.

Para uma maneira simples de atualizar seu `ListView`, crie uma nova `List` dentro de `setState()` e copie os dados da lista antiga para a nova lista. Embora esta abordagem seja simples, ela não é recomendada para grandes conjuntos de dados, conforme mostrado no próximo exemplo.

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
          developer.log('linha $i');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Linha $i'),
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

A maneira recomendada, eficiente e eficaz de construir uma lista usa um `ListView.Builder`. Este método é ótimo quando você tem uma lista dinâmica ou uma lista com grandes quantidades de dados.

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
          developer.log('linha $i');
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text('Linha $i'),
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

Em vez de criar um `ListView`, crie um `ListView.builder` que recebe dois parâmetros principais: o comprimento inicial da lista e uma função `ItemBuilder`.

A função `ItemBuilder` é semelhante ao método delegado `cellForItemAt` em uma tabela ou visualização de coleção do iOS, pois recebe uma posição e retorna a célula que você deseja renderizar nessa posição.

Finalmente, mas o mais importante, observe que a função `onTap()` não recria mais a lista, mas em vez disso, `.add` à ela.

### Criando uma visualização de rolagem

No UIKit, você envolve suas visualizações em um `ScrollView` que permite que um usuário role seu conteúdo, se necessário.

No Flutter, a maneira mais fácil de fazer isso é usando o widget `ListView`. Ele funciona como um `ScrollView` e um `TableView` do iOS, pois você pode dispor os widgets em um formato vertical.

<?code-excerpt "lib/layout.dart (list-view)"?>
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

Para obter documentos mais detalhados sobre como dispor widgets no Flutter, consulte o [tutorial de layout][].

## Detecção de gestos e tratamento de eventos de toque

Esta seção discute como detectar gestos e lidar com diferentes eventos no Flutter, e como eles se comparam com o UIKit.

### Adicionando um listener de clique

No UIKit, você anexa um `GestureRecognizer` a uma view para lidar com eventos de clique. No Flutter, existem duas maneiras de adicionar listeners de toque:

1. Se o widget suportar detecção de eventos, passe uma função para ele e lide com o evento na função. Por exemplo, o widget `ElevatedButton` tem um parâmetro `onPressed`:

  <?code-excerpt "lib/events.dart (on-pressed)"?>
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

2. Se o Widget não suportar detecção de eventos, envolva o widget em um GestureDetector e passe uma função para o parâmetro `onTap`.

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
              developer.log('toque');
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

### Lidando com outros gestos

Usando `GestureDetector`, você pode ouvir uma ampla gama de gestos, como:

* **Tocar**

  **`onTapDown`**
  : Um ponteiro que pode causar um toque entrou em contato com a tela em um local específico.

  **`onTapUp`**
  : Um ponteiro que aciona um toque parou de entrar em contato com a tela em um local específico.

  **`onTap`**
  : Um toque ocorreu.

  **`onTapCancel`**
  : O ponteiro que acionou anteriormente o `onTapDown` não causará um toque.

* **Toque duplo**

  **`onDoubleTap`**
  : O usuário tocou a tela no mesmo local duas vezes em rápida sucessão.

* **Pressionamento longo**

  **`onLongPress`**
  : Um ponteiro permaneceu em contato com a tela no mesmo local por um longo período de tempo.

* **Arrastar verticalmente**

  **`onVerticalDragStart`**
  : Um ponteiro entrou em contato com a tela e pode começar a se mover verticalmente.

  **`onVerticalDragUpdate`**
  : Um ponteiro em contato com a tela se moveu mais na direção vertical.

  **`onVerticalDragEnd`**
  : Um ponteiro que estava anteriormente em contato com a tela e se movendo verticalmente não está mais em contato com a tela e estava se movendo em uma velocidade específica quando parou de entrar em contato com a tela.

* **Arrastar horizontalmente**

  **`onHorizontalDragStart`**
  : Um ponteiro entrou em contato com a tela e pode começar a se mover horizontalmente.

  **`onHorizontalDragUpdate`**
  : Um ponteiro em contato com a tela se moveu mais na direção horizontal.

  **`onHorizontalDragEnd`**
  : Um ponteiro que estava anteriormente em contato com a tela e se movendo horizontalmente não está mais em contato com a tela.

O exemplo a seguir mostra um `GestureDetector` que gira o logotipo do Flutter em um toque duplo:

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

## Temas, estilos e mídia

Os aplicativos Flutter são fáceis de estilizar; você pode alternar entre temas claros e escuros, alterar o estilo do seu texto e componentes de UI e muito mais. Esta seção aborda aspectos da estilização de seus aplicativos Flutter e compara como você faria o mesmo no UIKit.

### Usando um tema

Pronto para uso, o Flutter vem com uma bela implementação do Material Design, que cuida de muitas necessidades de estilo e temas que você normalmente faria.

Para aproveitar ao máximo os componentes do Material em seu aplicativo, declare um widget de nível superior, `MaterialApp`, como o ponto de entrada para seu aplicativo. `MaterialApp` é um widget de conveniência que envolve vários widgets que são comumente exigidos para aplicativos que implementam o Material Design. Ele é construído sobre um `WidgetsApp` adicionando funcionalidades específicas do Material.

Mas o Flutter é flexível e expressivo o suficiente para implementar qualquer linguagem de design. No iOS, você pode usar a [biblioteca Cupertino][] para produzir uma interface que adere às [Diretrizes de Interface Humana][]. Para o conjunto completo desses widgets, consulte a galeria de [widgets Cupertino][].

Você também pode usar um `WidgetsApp` como seu widget de aplicativo, que fornece algumas das mesmas funcionalidades, mas não é tão rico quanto o `MaterialApp`.

Para personalizar as cores e estilos de qualquer componente filho, passe um objeto `ThemeData` para o widget `MaterialApp`. Por exemplo, no código abaixo, o esquema de cores da seed é definido como deepPurple e a cor do divisor é cinza.

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

### Usando fontes personalizadas

No UIKit, você importa todos os arquivos de fonte `ttf` para o seu projeto e cria uma referência no arquivo `info.plist`. No Flutter, coloque o arquivo de fonte em uma pasta e faça referência a ele no arquivo `pubspec.yaml`, semelhante a como você importa imagens.

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

### Estilizando texto

Junto com as fontes, você pode personalizar outros elementos de estilo em um widget `Text`. O parâmetro de estilo de um widget `Text` recebe um objeto `TextStyle`, onde você pode personalizar muitos parâmetros, como:

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

### Agrupando imagens em aplicativos

Enquanto o iOS trata imagens e ativos como itens distintos, os aplicativos Flutter têm apenas ativos. Os recursos que são colocados na pasta `Images.xcasset` no iOS são colocados em uma pasta de ativos para o Flutter. Como no iOS, os ativos são qualquer tipo de arquivo, não apenas imagens. Por exemplo, você pode ter um arquivo JSON localizado na pasta `my-assets`:

```plaintext
my-assets/data.json
```

Declare o ativo no arquivo `pubspec.yaml`:

```yaml
assets:
 - my-assets/data.json
```

E então acesse-o do código usando um [`AssetBundle`][]:

<?code-excerpt "lib/asset_bundle.dart"?>
```dart
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
```

Para imagens, o Flutter segue um formato simples baseado em densidade como o iOS. Os ativos de imagem podem ser `1.0x`, `2.0x`, `3.0x` ou qualquer outro multiplicador. O [`devicePixelRatio`][] do Flutter expressa a proporção de pixels físicos em um único pixel lógico.

Os ativos estão localizados em qualquer pasta arbitrária - o Flutter não tem uma estrutura de pastas predefinida. Você declara os ativos (com localização) no arquivo `pubspec.yaml` e o Flutter os coleta.

Por exemplo, para adicionar uma imagem chamada `my_icon.png` ao seu projeto Flutter, você pode decidir armazená-la em uma pasta chamada arbitrariamente `images`. Coloque a imagem base (1.0x) na pasta `images` e as outras variantes em subpastas com o nome do multiplicador de proporção apropriado:

```plaintext
images/my_icon.png       // Base: imagem 1.0x
images/2.0x/my_icon.png  // imagem 2.0x
images/3.0x/my_icon.png  // imagem 3.0x
```

Em seguida, declare essas imagens no arquivo `pubspec.yaml`:

```yaml
assets:
 - images/my_icon.png
```

Agora você pode acessar suas imagens usando `AssetImage`:

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

Para obter mais detalhes, consulte [Adicionando Ativos e Imagens no Flutter][].

## Entrada de formulário

Esta seção discute como usar formulários no Flutter e como eles se comparam com o UIKit.

### Recuperando entrada do usuário

Dado como o Flutter usa widgets imutáveis com um estado separado, você pode estar se perguntando como a entrada do usuário se encaixa no cenário. No UIKit, você normalmente consulta os widgets para obter seus valores atuais quando é hora de enviar a entrada do usuário ou agir sobre ela. Como isso funciona no Flutter?

Na prática, os formulários são tratados, como tudo no Flutter, por widgets especializados. Se você tiver um `TextField` ou um `TextFormField`, você pode fornecer um [`TextEditingController`][] para recuperar a entrada do usuário:

<?code-excerpt "lib/form.dart (my-form-state)"?>
```dart
class _MyFormState extends State<MyForm> {
  // Crie um controlador de texto e use-o para recuperar o valor atual.
  // do TextField!
  final myController = TextEditingController();

  @override
  void dispose() {
    // Limpe o controlador ao descartar o Widget.
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
        // Quando o usuário pressiona o botão, exiba uma caixa de diálogo de alerta com o
        // texto que o usuário digitou em nosso campo de texto.
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                // Recupere o texto que o usuário digitou usando nosso
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

Você pode encontrar mais informações e a listagem completa do código em [Recuperar o valor de um campo de texto][], do [livro de receitas do Flutter][].

### Placeholder em um campo de texto

No Flutter, você pode exibir facilmente uma "dica" ou um texto de placeholder para seu campo adicionando um objeto `InputDecoration` ao parâmetro de construtor de decoração para o widget `Text`:

<?code-excerpt "lib/form.dart (input-hint)" replace="/return const //g;/;//g"?>
```dart
Center(
  child: TextField(
    decoration: InputDecoration(hintText: 'Esta é uma dica'),
  ),
)
```

### Exibindo erros de validação

Assim como você faria com uma "dica", passe um objeto `InputDecoration` para o construtor de decoração para o widget `Text`.

No entanto, você não deseja começar mostrando um erro. Em vez disso, quando o usuário inserir dados inválidos, atualize o estado e passe um novo objeto `InputDecoration`.

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
                _errorText = 'Erro: Este não é um e-mail';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: InputDecoration(
            hintText: 'Esta é uma dica',
            errorText: _errorText,
          ),
        ),
      ),
    );
  }
}
```

## Threading e assincronicidade

Esta seção discute a concorrência no Flutter e como ela se compara ao UIKit.

### Escrevendo código assíncrono

O Dart tem um modelo de execução de thread único, com suporte para `Isolate`s (uma maneira de executar o código Dart em outro thread), um loop de eventos e programação assíncrona. A menos que você gere um `Isolate`, seu código Dart é executado no thread da UI principal e é conduzido por um loop de eventos. O loop de eventos do Flutter é equivalente ao loop principal do iOS - ou seja, o `Looper` que está anexado ao thread principal.

O modelo de thread único do Dart não significa que você seja obrigado a executar tudo como uma operação de bloqueio que faz com que a interface do usuário congele. Em vez disso, use os recursos assíncronos que a linguagem Dart fornece, como `async`/`await`, para realizar trabalhos assíncronos.

Por exemplo, você pode executar o código de rede sem fazer com que a interface do usuário trave usando `async`/`await` e deixando o Dart fazer o trabalho pesado:

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

Depois que a chamada de rede `await`ed for concluída, atualize a interface do usuário chamando `setState()`, que aciona uma reconstrução da subárvore de widgets e atualiza os dados.

O exemplo a seguir carrega dados de forma assíncrona e os exibe em um `ListView`:

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
      child: Text('Linha ${data[index]['title']}'),
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

Consulte a próxima seção para obter mais informações sobre como trabalhar em segundo plano e como o Flutter difere do iOS.
### Movendo para a thread em background

Como o Flutter é single-threaded e executa um loop de eventos
(como o Node.js), você não precisa se preocupar com
gerenciamento de threads ou criação de threads em background.
Se você estiver fazendo trabalho vinculado a I/O,
como acesso a disco ou uma chamada de rede,
você pode usar `async`/`await` com segurança e pronto.
Se, por outro lado, você precisar fazer um trabalho computacionalmente
intensivo que mantém a CPU ocupada, você deve movê-lo para um
`Isolate` para evitar o bloqueio do loop de eventos.

Para trabalho vinculado a I/O, declare a função como uma função
`async`, e use `await` em tarefas de longa duração dentro da função:

```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

É assim que você normalmente faz chamadas de rede ou banco de dados,
que são ambas operações de I/O.

No entanto, há momentos em que você pode estar processando
uma grande quantidade de dados e sua UI trava.
No Flutter, use `Isolate`s para aproveitar
vários núcleos de CPU para fazer tarefas de longa duração ou
computacionalmente intensivas.

Isolates são threads de execução separadas que não compartilham
nenhuma memória com o heap de memória de execução principal.
Isso significa que você não pode acessar variáveis ​​da thread principal,
ou atualizar sua UI chamando `setState()`.
Isolates são fiéis ao seu nome e não podem compartilhar memória
(na forma de campos estáticos, por exemplo).

O exemplo a seguir mostra, em um isolate simples,
como compartilhar dados de volta para a thread principal para atualizar a UI.

```dart
Future<void> loadData() async {
  final ReceivePort receivePort = ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // O isolate 'echo' envia seu SendPort como a primeira mensagem.
  final SendPort sendPort = await receivePort.first as SendPort;

  final List<Map<String, dynamic>> msg = await sendReceive(
    sendPort,
    'https://jsonplaceholder.typicode.com/posts',
  );

  setState(() {
    data = msg;
  });
}

// O ponto de entrada para o isolate.
static Future<void> dataLoader(SendPort sendPort) async {
  // Abre o ReceivePort para mensagens de entrada.
  final ReceivePort port = ReceivePort();

  // Notifica outros isolates a qual porta este isolate está escutando.
  sendPort.send(port.sendPort);

  await for (final dynamic msg in port) {
    final String url = msg[0] as String;
    final SendPort replyTo = msg[1] as SendPort;

    final Uri dataURL = Uri.parse(url);
    final http.Response response = await http.get(dataURL);
    // Muito JSON para analisar
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
No isolate, você pode realizar um processamento mais intensivo
da CPU (analisando um grande JSON, por exemplo),
ou realizar cálculos computacionalmente intensivos,
como criptografia ou processamento de sinais.

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

    // O isolate 'echo' envia seu SendPort como a primeira mensagem.
    final SendPort sendPort = await receivePort.first as SendPort;

    final List<Map<String, dynamic>> msg = await sendReceive(
      sendPort,
      'https://jsonplaceholder.typicode.com/posts',
    );

    setState(() {
      data = msg;
    });
  }

  // O ponto de entrada para o isolate.
  static Future<void> dataLoader(SendPort sendPort) async {
    // Abre o ReceivePort para mensagens de entrada.
    final ReceivePort port = ReceivePort();

    // Notifica outros isolates a qual porta este isolate está escutando.
    sendPort.send(port.sendPort);

    await for (final dynamic msg in port) {
      final String url = msg[0] as String;
      final SendPort replyTo = msg[1] as SendPort;

      final Uri dataURL = Uri.parse(url);
      final http.Response response = await http.get(dataURL);
      // Muito JSON para analisar
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
      child: Text("Linha ${data[i]["title"]}"),
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

### Fazendo requisições de rede

Fazer uma chamada de rede no Flutter é fácil quando você
usa o popular pacote [`http`][]. Isso abstrai
muitas das redes que você normalmente implementaria
sozinho, tornando simples fazer chamadas de rede.

Para adicionar o pacote `http` como uma dependência, execute `flutter pub add`:

```console
flutter pub add http
```

Para fazer uma chamada de rede,
chame `await` na função `async` `http.get()`:

```dart
Future<void> loadData() async {
  final Uri dataURL = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final http.Response response = await http.get(dataURL);
  setState(() {
    data = (jsonDecode(response.body) as List).cast<Map<String, Object?>>();
  });
}
```

### Exibindo o progresso em tarefas de longa duração

No UIKit, você normalmente usa um `UIProgressView`
enquanto executa uma tarefa de longa duração em background.

No Flutter, use um widget `ProgressIndicator`.
Mostre o progresso programaticamente controlando
quando ele é renderizado por meio de um flag booleano.
Diga ao Flutter para atualizar seu estado antes que sua tarefa de longa duração
comece e esconda-o depois que terminar.

No exemplo abaixo, a função build é separada em três funções
diferentes. Se `showLoadingDialog` for `true`
(quando `widgets.length == 0`), então renderize o `ProgressIndicator`.
Caso contrário, renderize a `ListView` com os dados retornados de uma
chamada de rede.

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
      child: Text("Linha ${data[i]["title"]}"),
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
