---
title: Introdução aos widgets
description: Aprenda sobre os widgets do Flutter.
js:
  - defer: true
    url: https://dartpad.dev/inject_embed.dart.js
traduzida: true
---

<?code-excerpt path-base="ui/widgets_intro/"?>

{% assign api = site.api | append: '/flutter' -%}

Os widgets do Flutter são construídos usando um framework moderno que se inspira no [React][]. A ideia central é que você construa sua interface de usuário usando widgets. Os widgets descrevem como a visualização deve ser, considerando sua configuração e estado atual. Quando o estado de um widget muda, ele reconstrói sua descrição, que o framework compara com a descrição anterior para determinar as mudanças mínimas necessárias na árvore de renderização subjacente para fazer a transição de um estado para o próximo.

{{site.alert.note}}
Se você gostaria de se familiarizar melhor com o Flutter mergulhando em alguns códigos, confira o [codelab de layout básico][],
[criando layouts][], e [adicionando interatividade ao seu aplicativo Flutter][].
{{site.alert.end}}

## Hello world

O aplicativo mínimo do Flutter simplesmente chama a função [`runApp()`][] com um widget:

<?code-excerpt "lib/main.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-310px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

A função `runApp()` recebe o [`Widget`][] fornecido e o torna a raiz da árvore de widgets. Neste exemplo, a árvore de widgets consiste em dois widgets, o widget [`Center`][] e seu filho, o widget [`Text`][]. O framework força o widget raiz a cobrir a tela, o que significa que o texto "Olá, mundo" acaba centralizado na tela. A direção do texto precisa ser especificada neste exemplo; quando o widget `MaterialApp` é usado, isso é cuidado para você, como será demonstrado posteriormente.


Ao escrever um aplicativo, você comumente criará novos widgets que são subclasses de [`StatelessWidget`][] ou [`StatefulWidget`][], dependendo se o seu widget gerencia algum estado. O trabalho principal de um widget é implementar uma função [`build()`][] que descreve o widget em termos de outros widgets de nível inferior. O framework constrói esses widgets por sua vez, até que o processo termine em widgets que representam o [`RenderObject`][] base, que calcula e descreve a geometria do widget.


## Widgets básicos

O Flutter vem com uma série de widgets básicos poderosos, dos quais os seguintes são comumente usados:

**[`Text`][]**
: O widget `Text` permite que você crie um trecho de texto estilizado dentro do seu aplicativo.

**[`Row`][], [`Column`][]**
: Esses widgets de flexibilidade permitem que você crie layouts flexíveis em ambas as direções horizontal (`Row`) e vertical (`Column`). O design desses objetos é baseado no modelo de layout flexbox da web.

**[`Stack`][]**
: Em vez de ser linearmente orientado (horizontal ou verticalmente), um widget `Stack` permite que você coloque widgets um em cima do outro em ordem de pintura. Você pode então usar o widget [`Positioned`][] em filhos de um `Stack` para posicioná-los em relação à borda superior, direita, inferior ou esquerda do `Stack`. Stacks são baseados no modelo de layout de posicionamento absoluto da web.

**[`Container`][]**
: O widget `Container` permite que você crie um elemento visual retangular. Um container pode ser decorado com um [`BoxDecoration`][], como um fundo, uma borda ou uma sombra. Um `Container` também pode ter margens, preenchimento e restrições aplicadas ao seu tamanho. Além disso, um `Container` pode ser transformado no espaço tridimensional usando uma matriz.

Abaixo estão alguns widgets simples que combinam estes e outros widgets:

<?code-excerpt "lib/main_myappbar.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  // Fields in a Widget subclass are always marked "final".

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.0, // in logical pixels
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(color: Colors.blue[500]),
      // Row is a horizontal, linear layout.
      child: Row(
        children: [
          const IconButton(
            icon: Icon(Icons.menu),
            tooltip: 'Navigation menu',
            onPressed: null, // null disables the button
          ),
          // Expanded expands its child
          // to fill the available space.
          Expanded(
            child: title,
          ),
          const IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class MyScaffold extends StatelessWidget {
  const MyScaffold({super.key});

  @override
  Widget build(BuildContext context) {
    // Material is a conceptual piece
    // of paper on which the UI appears.
    return Material(
      // Column is a vertical, linear layout.
      child: Column(
        children: [
          MyAppBar(
            title: Text(
              'Example title',
              style: Theme.of(context) //
                  .primaryTextTheme
                  .titleLarge,
            ),
          ),
          const Expanded(
            child: Center(
              child: Text('Hello, world!'),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: SafeArea(
        child: MyScaffold(),
      ),
    ),
  );
}
```

Certifique-se de ter uma entrada `uses-material-design: true` na seção `flutter` do arquivo `pubspec.yaml`. Isso permite que você use o conjunto predefinido de [Material icons][]. É uma boa ideia incluir essa linha em geral se você estiver usando a biblioteca Material.


```yaml
name: my_app
flutter:
  uses-material-design: true
```

Muitos widgets do Material Design precisam estar dentro de um [`MaterialApp`][]
para serem exibidos corretamente e herdar dados de tema.
Portanto, execute o aplicativo com um `MaterialApp`.

O widget `MyAppBar` cria um [`Container`][] com uma altura de 56 pixels
independentes do dispositivo com um preenchimento interno de 8 pixels,
tanto à esquerda quanto à direita. Dentro do contêiner,
`MyAppBar` usa um layout de [`Row`][] para organizar seus filhos.
O filho do meio, o widget `title`, é marcado como [`Expanded`][],
o que significa que ele se expande para preencher qualquer espaço disponível restante
que não tenha sido consumido pelos outros filhos.
Você pode ter vários filhos `Expanded` e determinar
a proporção na qual eles consomem o espaço disponível usando o
argumento [`flex`][] para `Expanded`.

O widget `MyScaffold` organiza seus filhos em uma coluna vertical.
No topo da coluna, ele coloca uma instância de `MyAppBar`,
passando ao app bar um widget [`Text`][] para usar como título.
Passar widgets como argumentos para outros widgets é uma técnica poderosa
que permite criar widgets genéricos que podem ser reutilizados de várias maneiras.
Finalmente, `MyScaffold` usa um [`Expanded`][] para preencher o espaço restante com o corpo,
que consiste em uma mensagem centralizada.

Para obter mais informações, consulte [Layouts][].


## Utilizando Componentes Material

Flutter fornece vários widgets que ajudam você a construir aplicativos que seguem o Material Design. Um aplicativo Material começa com o widget [`MaterialApp`][], que constrói vários widgets úteis na raiz do seu aplicativo, incluindo um [`Navigator`][], que gerencia uma pilha de widgets identificados por strings, também conhecidos como "rotas". O `Navigator` permite que você faça transições suaves entre as telas do seu aplicativo. O uso do widget [`MaterialApp`][] é totalmente opcional, mas é uma boa prática.


<?code-excerpt "lib/main_tutorial.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      title: 'Flutter Tutorial',
      home: TutorialHome(),
    ),
  );
}

class TutorialHome extends StatelessWidget {
  const TutorialHome({super.key});

  @override
  Widget build(BuildContext context) {
    // Scaffold is a layout for
    // the major Material Components.
    return Scaffold(
      appBar: AppBar(
        leading: const IconButton(
          icon: Icon(Icons.menu),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: const Text('Example title'),
        actions: const [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: 'Search',
            onPressed: null,
          ),
        ],
      ),
      // body is the majority of the screen.
      body: const Center(
        child: Text('Hello, world!'),
      ),
      floatingActionButton: const FloatingActionButton(
        tooltip: 'Add', // used by assistive technologies
        onPressed: null,
        child: Icon(Icons.add),
      ),
    );
  }
}
```
Agora que o código mudou de `MyAppBar` e `MyScaffold` para os
widgets [`AppBar`][] e [`Scaffold`][], e do arquivo `material.dart`,
o aplicativo está começando a ter uma aparência mais Material.
Por exemplo, a barra de aplicativos tem uma sombra e o texto do título herda o
estilo correto automaticamente. Um botão de ação flutuante também é adicionado.

Observe que os widgets são passados como argumentos para outros widgets.
O widget [`Scaffold`][] recebe vários widgets diferentes como
argumentos nomeados, cada um dos quais é colocado no layout do `Scaffold`
no local apropriado. Da mesma forma, o widget [`AppBar`][] permite que você
passe widgets para o widget [`leading`][], e [`actions`][] do widget
[`title`][]. Esse padrão se repete em todo o framework e é algo que você
pode considerar ao projetar seus próprios widgets.

Para mais informações, veja [Material Components widgets][].


{{site.alert.note}}
  Material é um dos dois designs incluídos no pacote padrão do Flutter.
  Para criar um design centrado no iOS,
  veja o pacote [Cupertino Components][],
  que possui suas próprias versões de
  [`CupertinoApp`][], e [`CupertinoNavigationBar`][].
{{site.alert.end}}



## Manipulando gestos

A maioria dos aplicativos inclui alguma forma de interação do usuário com o sistema.
A primeira etapa na construção de um aplicativo interativo é detectar
gestos de entrada. Veja como isso funciona criando um botão simples:

<?code-excerpt "lib/main_mybutton.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('MyButton was tapped!');
      },
      child: Container(
        height: 50.0,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: Colors.lightGreen[500],
        ),
        child: const Center(
          child: Text('Engage'),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: MyButton(),
        ),
      ),
    ),
  );
}
```

O widget [`GestureDetector`][] não tem uma representação visual, mas em vez disso detecta gestos feitos pelo usuário. Quando o usuário toca o [`Container`][], o `GestureDetector` chama seu callback [`onTap()`][], que neste caso imprime uma mensagem no console. Você pode usar o `GestureDetector` para detectar uma variedade de gestos de entrada, incluindo toques, arrastos e escalas.

Muitos widgets usam um [`GestureDetector`][] para fornecer callbacks opcionais para outros widgets. Por exemplo, os widgets [`IconButton`][], [`ElevatedButton`][] e [`FloatingActionButton`][] têm callbacks [`onPressed()`][] que são acionados quando o usuário toca o widget.

Para mais informações, consulte [Gestures in Flutter][].


## Alterando widgets em resposta a entrada

Até agora, esta página só usou widgets sem estado.
Widgets sem estado recebem argumentos de seu widget pai,
que eles armazenam em variáveis membros [`final`][].
Quando um widget é solicitado a [`build()`][], ele usa esses valores armazenados
para derivar novos argumentos para os widgets que cria.

Para construir experiências mais complexas, por exemplo,
para reagir de maneiras mais interessantes à entrada do usuário,
os aplicativos geralmente mantêm algum estado. O Flutter usa `StatefulWidgets` para capturar
essa ideia. `StatefulWidgets` são widgets especiais que sabem como gerar
objetos `State`, que são então usados para manter o estado.
Considere este exemplo básico, usando o [`ElevatedButton`][] mencionado anteriormente:


<?code-excerpt "lib/main_counter.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

class Counter extends StatefulWidget {
  // This class is the configuration for the state.
  // It holds the values (in this case nothing) provided
  // by the parent and used by the build  method of the
  // State. Fields in a Widget subclass are always marked
  // "final".

  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      // This call to setState tells the Flutter framework
      // that something has changed in this State, which
      // causes it to rerun the build method below so that
      // the display can reflect the updated values. If you
      // change _counter without calling setState(), then
      // the build method won't be called again, and so
      // nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called,
    // for instance, as done by the _increment method above.
    // The Flutter framework has been optimized to make
    // rerunning build methods fast, so that you can just
    // rebuild anything that needs updating rather than
    // having to individually changes instances of widgets.
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ElevatedButton(
          onPressed: _increment,
          child: const Text('Increment'),
        ),
        const SizedBox(width: 16),
        Text('Count: $_counter'),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}
```

Você pode se perguntar por que `StatefulWidget` e `State` são objetos separados.
No Flutter, esses dois tipos de objetos têm ciclos de vida diferentes.
`Widgets` são objetos temporários, usados para construir uma apresentação do aplicativo em seu estado atual. `State` objects, por outro lado, são persistentes entre chamadas de `build()`, permitindo que eles lembrem informações.

O exemplo acima aceita a entrada do usuário e usa diretamente o resultado em seu método `build()`. Em aplicativos mais complexos, diferentes partes da hierarquia de widgets podem ser responsáveis por diferentes preocupações; por exemplo, um widget pode apresentar uma interface do usuário complexa com o objetivo de coletar informações específicas, como uma data ou localização, enquanto outro widget pode usar essas informações para alterar a apresentação geral.

No Flutter, as notificações de mudanças fluem "para cima" na hierarquia de widgets por meio de callbacks, enquanto o estado atual flui "para baixo" para os widgets stateless que fazem a apresentação. O pai comum que redireciona esse fluxo é o `State`. O exemplo ligeiramente mais complexo a seguir mostra como isso funciona na prática:


<?code-excerpt "lib/main_counterdisplay.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

class CounterDisplay extends StatelessWidget {
  const CounterDisplay({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Text('Count: $count');
  }
}

class CounterIncrementor extends StatelessWidget {
  const CounterIncrementor({required this.onPressed, super.key});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Increment'),
    );
  }
}

class Counter extends StatefulWidget {
  const Counter({super.key});

  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _counter = 0;

  void _increment() {
    setState(() {
      ++_counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        CounterIncrementor(onPressed: _increment),
        const SizedBox(width: 16),
        CounterDisplay(count: _counter),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Counter(),
        ),
      ),
    ),
  );
}
```


Observe a criação de dois novos widgets stateless, separando claramente as preocupações de _exibir_ o contador (`CounterDisplay`) e _alterar_ o contador (`CounterIncrementor`). Embora o resultado líquido seja o mesmo que o exemplo anterior, a separação de responsabilidades permite uma maior complexidade ser encapsulada nos widgets individuais, mantendo a simplicidade no pai.

Para mais informações, veja:

* [`StatefulWidget`][]
* [`setState()`][]


## Juntando tudo

A seguir, temos um exemplo mais completo que reúne esses conceitos: um aplicativo hipotético de compras exibe vários produtos oferecidos à venda e mantém um carrinho de compras para as compras pretendidas. Comece definindo a classe de apresentação, `ShoppingListItem`:


<?code-excerpt "lib/main_shoppingitem.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});

  final String name;
}

typedef CartChangedCallback = Function(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(product.name, style: _getTextStyle(context)),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: ShoppingListItem(
            product: const Product(name: 'Chips'),
            inCart: true,
            onCartChanged: (product, inCart) {},
          ),
        ),
      ),
    ),
  );
}
```

O widget `ShoppingListItem` segue um padrão comum para widgets sem estado. Ele armazena os valores que recebe em seu construtor em variáveis de membro [`final`][] que são usadas em sua função [`build()`][]. Por exemplo, o booleano `inCart` alterna entre duas aparências visuais: uma que usa a cor primária do tema atual e outra que usa cinza.

Quando o usuário toca no item da lista, o widget não modifica diretamente o valor de `inCart`. Em vez disso, o widget chama a função `onCartChanged` que recebeu de seu widget pai. Esse padrão permite armazenar o estado mais acima na hierarquia do widget, fazendo com que o estado persista por períodos mais longos. Na situação extrema, o estado armazenado no widget passado para [`runApp()`][] persiste durante toda a vida do aplicativo.

Quando o pai recebe o retorno de chamada `onCartChanged`,
o pai atualiza seu estado interno, o que aciona
a reconstrução do pai e cria uma nova instância
de `ShoppingListItem` com o novo valor `inCart`.
Embora o pai crie uma nova instância de `ShoppingListItem` quando reconstrói, essa operação é barata
porque o framework compara os widgets recém-criados com os anteriormente
construídos e aplica apenas as diferenças ao
[`RenderObject`][] subjacente.

Aqui está um exemplo de widget pai que armazena estado mutável:


<?code-excerpt "lib/main_shoppinglist.dart"?>
```run-dartpad:theme-light:mode-flutter:run-false:width-100%:height-600px:split-60:ga_id-starting_code
import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});

  final String name;
}

typedef CartChangedCallback = Function(Product product, bool inCart);

class ShoppingListItem extends StatelessWidget {
  ShoppingListItem({
    required this.product,
    required this.inCart,
    required this.onCartChanged,
  }) : super(key: ObjectKey(product));

  final Product product;
  final bool inCart;
  final CartChangedCallback onCartChanged;

  Color _getColor(BuildContext context) {
    // The theme depends on the BuildContext because different
    // parts of the tree can have different themes.
    // The BuildContext indicates where the build is
    // taking place and therefore which theme to use.

    return inCart //
        ? Colors.black54
        : Theme.of(context).primaryColor;
  }

  TextStyle? _getTextStyle(BuildContext context) {
    if (!inCart) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        onCartChanged(product, inCart);
      },
      leading: CircleAvatar(
        backgroundColor: _getColor(context),
        child: Text(product.name[0]),
      ),
      title: Text(
        product.name,
        style: _getTextStyle(context),
      ),
    );
  }
}

class ShoppingList extends StatefulWidget {
  const ShoppingList({required this.products, super.key});

  final List<Product> products;

  // The framework calls createState the first time
  // a widget appears at a given location in the tree.
  // If the parent rebuilds and uses the same type of
  // widget (with the same key), the framework re-uses
  // the State object instead of creating a new State object.

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  final _shoppingCart = <Product>{};

  void _handleCartChanged(Product product, bool inCart) {
    setState(() {
      // When a user changes what's in the cart, you need
      // to change _shoppingCart inside a setState call to
      // trigger a rebuild.
      // The framework then calls build, below,
      // which updates the visual appearance of the app.

      if (!inCart) {
        _shoppingCart.add(product);
      } else {
        _shoppingCart.remove(product);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping List'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: widget.products.map((product) {
          return ShoppingListItem(
            product: product,
            inCart: _shoppingCart.contains(product),
            onCartChanged: _handleCartChanged,
          );
        }).toList(),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    title: 'Shopping App',
    home: ShoppingList(
      products: [
        Product(name: 'Eggs'),
        Product(name: 'Flour'),
        Product(name: 'Chocolate chips'),
      ],
    ),
  ));
}
```

A classe `ShoppingList` estende [`StatefulWidget`][],
o que significa que esse widget armazena estado mutável.
Quando o widget `ShoppingList` é inserido pela primeira vez na árvore,
o framework chama a função [`createState()`][] para criar uma nova instância
de `_ShoppingListState` para associar com esse local na árvore.
(Observe que subclasses de [`State`][] normalmente são nomeadas com sublinhados
iniciais para indicar que são detalhes de implementação privados).
Quando o pai deste widget é reconstruído, o pai cria uma nova instância de `ShoppingList`,
mas o framework reutiliza a instância `_ShoppingListState` que já está na árvore em vez de chamar
`createState` novamente.

Para acessar as propriedades do `ShoppingList` atual,
o `_ShoppingListState` pode usar sua propriedade [`widget`][].
Se o pai for reconstruído e criar um novo `ShoppingList`,
o `_ShoppingListState` reconstrói com o novo valor do widget.
Se você deseja ser notificado quando a propriedade do widget é alterada,
substitua a função [`didUpdateWidget()`][] que recebe um `oldWidget` para permitir que você compare
o widget antigo com o widget atual.

Ao lidar com o retorno da chamada `onCartChanged`, o `_ShoppingListState`
modifica seu estado interno adicionando ou removendo um produto de
`_shoppingCart`. Para sinalizar ao framework que ele alterou seu estado interno,
ele envolve essas chamadas em uma chamada [`setState()`][].
Chamar `setState` marca este widget como sujo e o programa o reconstrói
na próxima vez em que o aplicativo precisar atualizar a tela.
Se você esquecer de chamar `setState` ao modificar o estado interno de um widget,
o framework não saberá que o widget está sujo e talvez não chame a função [`build()`][]
do widget, o que significa que a interface do usuário pode não ser atualizada
para refletir o estado alterado. Gerenciando o estado dessa maneira,
você não precisa escrever código separado para criar e atualizar widgets filhos.
Em vez disso, você simplesmente implementa a função `build`,
que lida com ambas as situações.


## Respondendo a eventos do ciclo de vida do widget

Após chamar [`createState()`][] no `StatefulWidget`, o framework insere o novo objeto de estado na árvore e, em seguida, chama [`initState()`][] no objeto de estado. Uma subclasse de [`State`][] pode substituir `initState` para fazer o trabalho que precisa acontecer apenas uma vez. Por exemplo, substitua `initState` para configurar animações ou se inscrever em serviços de plataforma. Implementações de `initState` devem começar chamando `super.initState`.

Quando um objeto de estado não é mais necessário, o framework chama [`dispose()`][] no objeto de estado. Substitua a função `dispose` para fazer o trabalho de limpeza. Por exemplo, substitua `dispose` para cancelar timers ou cancelar inscrições em serviços de plataforma. Implementações de `dispose` geralmente terminam chamando `super.dispose`.

Para obter mais informações, consulte [`State`][].


## Chaves

Use chaves para controlar quais widgets o framework corresponde
com outros widgets quando um widget é reconstruído. Por padrão, o
framework corresponde widgets na construção atual e anterior
de acordo com seu [`runtimeType`][] e a ordem em que aparecem.
Com chaves, o framework requer que os dois widgets tenham
a mesma [`key`][] bem como o mesmo `runtimeType`.

Chaves são mais úteis em widgets que constroem muitas instâncias de
o mesmo tipo de widget. Por exemplo, o widget `ShoppingList`,
que constrói exatamente o suficiente de instâncias de `ShoppingListItem`
para preencher sua região visível:

 * Sem chaves, a primeira entrada na construção atual
   sempre seria sincronizada com a primeira entrada na construção anterior,
   mesmo que, semanticamente, a primeira entrada na lista só
   rolou para fora da tela e não é mais visível na viewport.

 * Atribuindo a cada entrada na lista uma chave "semântica",
   a lista infinita pode ser mais eficiente porque o
   framework sincroniza entradas com chaves semânticas correspondentes
   e, portanto, aparências visuais semelhantes (ou idênticas).
   Além disso, a sincronização semântica das entradas significa que
   estado retido em widgets filhos com estado permanece anexado
   à mesma entrada semântica em vez da entrada na
   mesma posição numérica na viewport.

Para mais informações, consulte a API [`Key`][].


## Chaves Globais

Use chaves globais para identificar exclusivamente widgets filhos.
As chaves globais devem ser globalmente únicas em toda a hierarquia de widgets, ao contrário das chaves locais que precisam ser únicas apenas entre irmãos. Por serem globalmente únicas, uma chave global pode ser usada para recuperar o estado associado a um widget.

Para obter mais informações, consulte a API [`GlobalKey`][].



[`actions`]: {{api}}/material/AppBar-class.html#actions
[adicionando interatividade ao seu aplicativo Flutter]: {{site.url}}/development/ui/interactive
[`AppBar`]: {{api}}/material/AppBar-class.html
[codelab de layout básico]: {{site.url}}/codelabs/layout-basics
[`BoxDecoration`]: {{api}}/painting/BoxDecoration-class.html
[`build()`]: {{api}}/widgets/StatelessWidget/build.html
[criando layouts]: {{site.url}}/development/ui/layout
[`Center`]: {{api}}/widgets/Center-class.html
[`Column`]: {{api}}/widgets/Column-class.html
[`Container`]: {{api}}/widgets/Container-class.html
[`createState()`]: {{api}}/widgets/StatefulWidget-class.html#createState
[Cupertino components]: {{site.url}}/development/ui/widgets/cupertino
[`CupertinoApp`]: {{api}}/cupertino/CupertinoApp-class.html
[`CupertinoNavigationBar`]: {{api}}/cupertino/CupertinoNavigationBar-class.html
[`didUpdateWidget()`]: {{api}}/widgets/State-class.html#didUpdateWidget
[`dispose()`]: {{api}}/widgets/State-class.html#dispose
[`Expanded`]: {{api}}/widgets/Expanded-class.html
[`final`]: {{site.dart-site}}/language/variables#final-and-const
[`flex`]: {{api}}/widgets/Expanded-class.html#flex
[`FloatingActionButton`]: {{api}}/material/FloatingActionButton-class.html
[Gestures in Flutter]: {{site.url}}/development/ui/advanced/gestures
[`GestureDetector`]: {{api}}/widgets/GestureDetector-class.html
[`GlobalKey`]: {{api}}/widgets/GlobalKey-class.html
[`IconButton`]: {{api}}/material/IconButton-class.html
[`initState()`]: {{api}}/widgets/State-class.html#initState
[`key`]: {{api}}/widgets/Widget-class.html#key
[`Key`]: {{api}}/foundation/Key-class.html
[Layouts]: {{site.url}}/development/ui/widgets/layout
[`leading`]: {{api}}/material/AppBar-class.html#leading
[Material Components widgets]: {{site.url}}/development/ui/widgets/material
[Material icons]: https://design.google.com/icons/
[`MaterialApp`]: {{api}}/material/MaterialApp-class.html
[`Navigator`]: {{api}}/widgets/Navigator-class.html
[`onPressed()`]: {{api}}/material/ElevatedButton-class.html#onPressed
[`onTap()`]: {{api}}/widgets/GestureDetector-class.html#onTap
[`Positioned`]: {{api}}/widgets/Positioned-class.html
[`ElevatedButton`]: {{api}}/material/ElevatedButton-class.html
[React]: https://reactjs.org
[`RenderObject`]: {{api}}/rendering/RenderObject-class.html
[`Row`]: {{api}}/widgets/Row-class.html
[`runApp()`]: {{api}}/widgets/runApp.html
[`runtimeType`]: {{api}}/widgets/Widget-class.html#runtimeType
[`Scaffold`]: {{api}}/material/Scaffold-class.html
[`setState()`]: {{api}}/widgets/State/setState.html
[`Stack`]: {{api}}/widgets/Stack-class.html
[`State`]: {{api}}/widgets/State-class.html
[`StatefulWidget`]: {{api}}/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{api}}/widgets/StatelessWidget-class.html
[`Text`]: {{api}}/widgets/Text-class.html
[`title`]: {{api}}/material/AppBar-class.html#title
[`widget`]: {{api}}/widgets/State-class.html#widget
[`Widget`]: {{api}}/widgets/Widget-class.html
