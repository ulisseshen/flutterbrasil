---
ia-translate: true
title: Construindo interfaces de usuário com Flutter
shortTitle: UI
description: Introdução ao desenvolvimento de interfaces de usuário no Flutter.
---

<?code-excerpt path-base="ui/widgets_intro/"?>

Os widgets Flutter são construídos usando um framework moderno que se
inspira no [React][]. A ideia central é que você construa
sua UI com widgets. Widgets descrevem como sua visualização
deve ser, dada sua configuração e estado atuais.
Quando o estado de um widget muda, o widget reconstrói sua descrição,
que o framework compara com a descrição anterior para
determinar as mudanças mínimas necessárias na árvore de renderização
subjacente para fazer a transição de um estado para o próximo.

:::note
Se você gostaria de se familiarizar melhor com o Flutter mergulhando
em algum código, confira [construindo layouts][building layouts],
e [adicionando interatividade ao seu app Flutter][adding interactivity to your Flutter app].
:::

## Hello world

O app Flutter mínimo simplesmente chama a função [`runApp()`][]
com um widget:

<?code-excerpt "lib/main.dart"?>
```dartpad title="Flutter Hello World hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Hello, world!',
        textDirection: TextDirection.ltr,
        style: TextStyle(color: Colors.blue),
      ),
    ),
  );
}
```

A função `runApp()` recebe o
[`Widget`][] fornecido e o torna a raiz da árvore de widgets.
Neste exemplo, a árvore de widgets consiste em dois widgets,
o widget [`Center`][] e seu filho, o widget [`Text`][].
O framework força o widget raiz a cobrir a tela,
o que significa que o texto "Hello, world" acaba centralizado na tela.
A direção do texto precisa ser especificada nesta instância;
quando o widget `MaterialApp` é usado,
isso é cuidado para você, como demonstrado mais tarde.

Ao escrever um app, você geralmente criará novos widgets que
são subclasses de [`StatelessWidget`][] ou [`StatefulWidget`][],
dependendo se seu widget gerencia algum estado.
O trabalho principal de um widget é implementar uma função [`build()`][],
que descreve o widget em termos de outros widgets de nível mais baixo.
O framework constrói esses widgets por sua vez até que o processo
chegue ao fim em widgets que representam o [`RenderObject`][] subjacente,
que computa e descreve a geometria do widget.

## Basic widgets

Flutter vem com um conjunto de widgets básicos poderosos,
dos quais os seguintes são comumente usados:

**[`Text`][]**
: O widget `Text` permite criar um trecho de texto estilizado
  dentro de sua aplicação.

**[`Row`][], [`Column`][]**
: Esses widgets flex permitem criar layouts flexíveis em
  ambas as direções horizontal (`Row`) e vertical (`Column`).
  O design desses objetos é baseado no modelo de layout
  flexbox da web.

**[`Stack`][]**
: Em vez de ser orientado linearmente (horizontal ou verticalmente),
  um widget `Stack` permite colocar widgets em cima uns dos outros na ordem de pintura.
  Você pode então usar o widget [`Positioned`][] nos filhos de um
  `Stack` para posicioná-los relativamente ao topo, direita, inferior,
  ou borda esquerda da pilha. Stacks são baseados no modelo de layout
  de posicionamento absoluto da web.

**[`Container`][]**
: O widget `Container` permite criar um elemento visual retangular.
  Um container pode ser decorado com um [`BoxDecoration`][], como um
  plano de fundo, uma borda ou uma sombra. Um `Container` também pode ter margens,
  padding e restrições aplicadas ao seu tamanho. Além disso, um
  `Container` pode ser transformado no espaço tridimensional usando uma matriz.

Abaixo estão alguns widgets simples que combinam esses e outros widgets:

<?code-excerpt "lib/main_myappbar.dart"?>
```dartpad title="Flutter combining widgets hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  const MyAppBar({required this.title, super.key});

  // Fields in a Widget subclass are always marked "final".

  final Widget title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56, // in logical pixels
      padding: const EdgeInsets.symmetric(horizontal: 8),
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
          Expanded(child: title),
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
              style:
                  Theme.of(context) //
                      .primaryTextTheme
                      .titleLarge,
            ),
          ),
          const Expanded(child: Center(child: Text('Hello, world!'))),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      title: 'My app', // used by the OS task switcher
      home: SafeArea(child: MyScaffold()),
    ),
  );
}
```

Certifique-se de ter uma entrada `uses-material-design: true` na seção `flutter`
do seu arquivo `pubspec.yaml`. Isso permite que você use o conjunto predefinido
de [ícones Material][Material icons]. Geralmente é uma boa ideia incluir esta linha
se você estiver usando a biblioteca Materials.

```yaml
name: my_app
flutter:
  uses-material-design: true
```

Muitos widgets Material Design precisam estar dentro de um [`MaterialApp`][]
para serem exibidos corretamente, a fim de herdar dados de tema.
Portanto, execute a aplicação com um `MaterialApp`.

O widget `MyAppBar` cria um [`Container`][] com uma altura de 56
pixels independentes de dispositivo com um padding interno de 8 pixels,
tanto na esquerda quanto na direita. Dentro do container,
`MyAppBar` usa um layout [`Row`][] para organizar seus filhos.
O filho do meio, o widget `title`, é marcado como [`Expanded`][],
o que significa que ele se expande para preencher qualquer espaço disponível restante
que não foi consumido pelos outros filhos.
Você pode ter vários filhos `Expanded` e determinar a
proporção em que eles consomem o espaço disponível usando o
argumento [`flex`][] para `Expanded`.

O widget `MyScaffold` organiza seus filhos em uma coluna vertical.
No topo da coluna ele coloca uma instância de `MyAppBar`,
passando para a barra do app um widget [`Text`][] para usar como seu título.
Passar widgets como argumentos para outros widgets é uma técnica poderosa
que permite criar widgets genéricos que podem ser reutilizados de várias
formas. Finalmente, `MyScaffold` usa um
[`Expanded`][] para preencher o espaço restante com seu corpo,
que consiste em uma mensagem centralizada.

Para mais informações, confira [Layouts][Layouts].

## Using Material Components

Flutter fornece vários widgets que ajudam você a construir apps
que seguem o Material Design. Um app Material começa com o
widget [`MaterialApp`][], que constrói vários widgets úteis
na raiz do seu app, incluindo um [`Navigator`][],
que gerencia uma pilha de widgets identificados por strings,
também conhecidas como "routes". O `Navigator` permite fazer a transição suavemente
entre telas da sua aplicação. Usar o widget [`MaterialApp`][]
é totalmente opcional, mas uma boa prática.

<?code-excerpt "lib/main_tutorial.dart"?>
```dartpad title="Flutter Material design hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title: 'Flutter Tutorial', home: TutorialHome()));
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
      body: const Center(child: Text('Hello, world!')),
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
widgets [`AppBar`][] e [`Scaffold`][], e de `material.dart`,
o app está começando a parecer um pouco mais Material.
Por exemplo, a barra do app tem uma sombra e o texto do título herda o
estilo correto automaticamente. Um botão de ação flutuante também é adicionado.

Observe que widgets são passados como argumentos para outros widgets.
O widget [`Scaffold`][] recebe vários widgets diferentes como
argumentos nomeados, cada um dos quais é colocado no layout do `Scaffold`
no lugar apropriado. Da mesma forma, o
widget [`AppBar`][] permite passar widgets para o
widget [`leading`][], e para as [`actions`][] do widget [`title`][].
Esse padrão se repete em todo o framework e é algo que você
pode considerar ao projetar seus próprios widgets.

Para mais informações, confira [widgets Material Components][Material Components widgets].

:::note
Material é um dos 2 designs incluídos com o Flutter.
Para criar um design centrado em iOS,
confira o pacote [componentes Cupertino][Cupertino components],
que tem suas próprias versões de
[`CupertinoApp`][], e [`CupertinoNavigationBar`][].
:::


## Handling gestures

A maioria das aplicações inclui alguma forma de interação do usuário com o sistema.
O primeiro passo na construção de uma aplicação interativa é detectar
gestos de entrada. Veja como isso funciona criando um botão simples:

<?code-excerpt "lib/main_mybutton.dart"?>
```dartpad title="Flutter button hands-on example in DartPad" run="true"
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
        height: 50,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.lightGreen[500],
        ),
        child: const Center(child: Text('Engage')),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: MyButton())),
    ),
  );
}
```

O widget [`GestureDetector`][] não tem uma
representação visual, mas detecta gestos feitos pelo
usuário. Quando o usuário toca no [`Container`][],
o `GestureDetector` chama seu callback [`onTap()`][], neste
caso imprimindo uma mensagem no console. Você pode usar
`GestureDetector` para detectar uma variedade de gestos de entrada,
incluindo toques, arrastos e escalonamentos.

Muitos widgets usam um [`GestureDetector`][] para fornecer
callbacks opcionais para outros widgets. Por exemplo, os
widgets [`IconButton`][], [`ElevatedButton`][], e
[`FloatingActionButton`][] têm callbacks [`onPressed()`][]
que são acionados quando o usuário toca no widget.

Para mais informações, confira [Gestos no Flutter][Gestures in Flutter].

## Changing widgets in response to input

Até agora, esta página usou apenas widgets stateless.
Widgets stateless recebem argumentos do seu widget pai,
que eles armazenam em variáveis membro [`final`][].
Quando um widget é solicitado a [`build()`][], ele usa esses valores
armazenados para derivar novos argumentos para os widgets que ele cria.

Para construir experiências mais complexas&mdash;por exemplo,
para reagir de formas mais interessantes à entrada do usuário&mdash;aplicações
normalmente carregam algum estado. Flutter usa `StatefulWidgets` para capturar
essa ideia. `StatefulWidgets` são widgets especiais que sabem como gerar
objetos `State`, que são então usados para manter estado.
Considere este exemplo básico, usando o [`ElevatedButton`][] mencionado anteriormente:

<?code-excerpt "lib/main_counter.dart"?>
```dartpad title="Flutter state management hands-on example in DartPad" run="true"
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
        ElevatedButton(onPressed: _increment, child: const Text('Increment')),
        const SizedBox(width: 16),
        Text('Count: $_counter'),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: Center(child: Counter())),
    ),
  );
}
```

Você pode se perguntar por que `StatefulWidget` e `State` são objetos separados.
No Flutter, esses dois tipos de objetos têm ciclos de vida diferentes.
`Widgets` são objetos temporários, usados para construir uma apresentação da
aplicação em seu estado atual. Objetos `State`, por outro
lado, são persistentes entre chamadas a
`build()`, permitindo que eles se lembrem de informações.

O exemplo acima aceita entrada do usuário e usa diretamente
o resultado em seu método `build()`. Em aplicações mais complexas,
diferentes partes da hierarquia de widgets podem ser
responsáveis por diferentes preocupações; por exemplo, um
widget pode apresentar uma interface de usuário complexa
com o objetivo de coletar informações específicas,
como uma data ou localização, enquanto outro widget pode
usar essas informações para mudar a apresentação geral.

No Flutter, notificações de mudança fluem "para cima" na hierarquia
de widgets por meio de callbacks, enquanto o estado atual flui
"para baixo" para os widgets stateless que fazem a apresentação.
O pai comum que redireciona esse fluxo é o `State`.
O exemplo um pouco mais complexo a seguir mostra como
isso funciona na prática:

<?code-excerpt "lib/main_counterdisplay.dart"?>
```dartpad title="Flutter Hello World hands-on example in DartPad" run="true"
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
    return ElevatedButton(onPressed: onPressed, child: const Text('Increment'));
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
      home: Scaffold(body: Center(child: Counter())),
    ),
  );
}
```

Observe a criação de dois novos widgets stateless,
separando claramente as preocupações de _exibir_ o contador
(`CounterDisplay`) e _mudar_ o contador (`CounterIncrementor`).
Embora o resultado final seja o mesmo do exemplo anterior,
a separação de responsabilidade permite maior complexidade ser
encapsulada nos widgets individuais,
mantendo a simplicidade no pai.

Para mais informações, confira:

* [`StatefulWidget`][]
* [`setState()`][]

## Bringing it all together

O que segue é um exemplo mais completo que reúne
esses conceitos: Uma aplicação hipotética de compras exibe vários
produtos oferecidos para venda e mantém um carrinho de compras para
compras pretendidas. Comece definindo a classe de apresentação,
`ShoppingListItem`:

<?code-excerpt "lib/main_shoppingitem.dart"?>
```dartpad title="Flutter complete shopping list item hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});

  final String name;
}

typedef CartChangedCallback = void Function(Product product, bool inCart);

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

O widget `ShoppingListItem` segue um padrão comum
para widgets stateless. Ele armazena os valores que recebe
em seu construtor em variáveis membro [`final`][],
que ele então usa durante sua função [`build()`][].
Por exemplo, o booleano `inCart` alterna entre duas aparências
visuais: uma que usa a cor primária do tema atual,
e outra que usa cinza.

Quando o usuário toca no item da lista, o widget não modifica
seu valor `inCart` diretamente. Em vez disso, o widget chama a
função `onCartChanged` que recebeu do seu widget pai.
Esse padrão permite armazenar estado mais alto na hierarquia
de widgets, o que faz com que o estado persista por períodos mais longos.
No extremo, o estado armazenado no widget passado para
[`runApp()`][] persiste durante toda a vida útil da
aplicação.

Quando o pai recebe o callback `onCartChanged`,
o pai atualiza seu estado interno, o que aciona
o pai a reconstruir e criar uma nova instância
de `ShoppingListItem` com o novo valor `inCart`.
Embora o pai crie uma nova instância de
`ShoppingListItem` quando reconstrói, essa operação é barata
porque o framework compara os widgets recém-construídos com os widgets
construídos anteriormente e aplica apenas as diferenças ao
[`RenderObject`][] subjacente.

Aqui está um exemplo de widget pai que armazena estado mutável:

<?code-excerpt "lib/main_shoppinglist.dart"?>
```dartpad title="Flutter storing mutable state hands-on example in DartPad" run="true"
import 'package:flutter/material.dart';

class Product {
  const Product({required this.name});

  final String name;
}

typedef CartChangedCallback = void Function(Product product, bool inCart);

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
      appBar: AppBar(title: const Text('Shopping List')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
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
  runApp(
    const MaterialApp(
      title: 'Shopping App',
      home: ShoppingList(
        products: [
          Product(name: 'Eggs'),
          Product(name: 'Flour'),
          Product(name: 'Chocolate chips'),
        ],
      ),
    ),
  );
}
```

A classe `ShoppingList` estende [`StatefulWidget`][],
o que significa que este widget armazena estado mutável.
Quando o widget `ShoppingList` é inserido pela primeira vez
na árvore, o framework chama a função [`createState()`][] para
criar uma nova instância de `_ShoppingListState` para associar com aquela
localização na árvore. (Observe que subclasses de
[`State`][] são tipicamente nomeadas com sublinhados iniciais para
indicar que são detalhes de implementação privados.)
Quando o pai deste widget reconstrói, o pai cria uma nova instância
de `ShoppingList`, mas o framework reutiliza a instância `_ShoppingListState`
que já está na árvore em vez de chamar
`createState` novamente.

Para acessar propriedades do `ShoppingList` atual,
o `_ShoppingListState` pode usar sua propriedade [`widget`][].
Se o pai reconstrói e cria um novo `ShoppingList`,
o `_ShoppingListState` reconstrói com o novo valor de widget.
Se você deseja ser notificado quando a propriedade `widget` muda,
sobrescreva a função [`didUpdateWidget()`][], que recebe
um `oldWidget` para permitir comparar o widget antigo com
o widget atual.

Ao lidar com o callback `onCartChanged`, o `_ShoppingListState`
muda seu estado interno adicionando ou removendo um produto de
`_shoppingCart`. Para sinalizar ao framework que ele mudou seu estado
interno, ele envolve essas chamadas em uma chamada [`setState()`][].
Chamar `setState` marca este widget como sujo e o agenda para ser reconstruído
na próxima vez que seu app precisar atualizar a tela.
Se você esquecer de chamar `setState` ao modificar o estado
interno de um widget, o framework não saberá que seu widget está
sujo e pode não chamar a função [`build()`][] do widget,
o que significa que a interface do usuário pode não atualizar para refletir
o estado alterado. Ao gerenciar estado dessa forma,
você não precisa escrever código separado para criar e
atualizar widgets filhos. Em vez disso, você simplesmente implementa a função `build`,
que lida com ambas as situações.

## Responding to widget lifecycle events

Após chamar [`createState()`][] no `StatefulWidget`,
o framework insere o novo objeto de estado na árvore e
então chama [`initState()`][] no objeto de estado.
Uma subclasse de [`State`][] pode sobrescrever `initState` para fazer trabalho
que precisa acontecer apenas uma vez. Por exemplo, sobrescreva `initState`
para configurar animações ou para se inscrever em serviços de plataforma.
Implementações de `initState` são obrigadas a começar
chamando `super.initState`.

Quando um objeto de estado não é mais necessário,
o framework chama [`dispose()`][] no objeto de estado.
Sobrescreva a função `dispose` para fazer trabalho de limpeza.
Por exemplo, sobrescreva `dispose` para cancelar temporizadores ou para
cancelar a inscrição de serviços de plataforma. Implementações de
`dispose` normalmente terminam chamando `super.dispose`.

Para mais informações, confira [`State`][].

## Keys

Use keys para controlar quais widgets o framework combina
com outros widgets quando um widget reconstrói. Por padrão, o
framework combina widgets na construção atual e anterior
de acordo com seu [`runtimeType`][] e a ordem em que aparecem.
Com keys, o framework exige que os dois widgets tenham
a mesma [`key`][] assim como o mesmo `runtimeType`.

Keys são mais úteis em widgets que constroem muitas instâncias do
mesmo tipo de widget. Por exemplo, o widget `ShoppingList`,
que constrói apenas instâncias suficientes de `ShoppingListItem` para
preencher sua região visível:

 * Sem keys, a primeira entrada na construção atual
   sempre sincronizaria com a primeira entrada na construção anterior,
   mesmo se, semanticamente, a primeira entrada na lista acabou de
   rolar para fora da tela e não está mais visível no viewport.

 * Ao atribuir a cada entrada na lista uma key "semântica",
   a lista infinita pode ser mais eficiente porque o
   framework sincroniza entradas com keys semânticas correspondentes
   e, portanto, aparências visuais semelhantes (ou idênticas).
   Além disso, sincronizar as entradas semanticamente significa que
   o estado retido em widgets filhos stateful permanece anexado
   à mesma entrada semântica em vez da entrada na
   mesma posição numérica no viewport.

Para mais informações, confira a API [`Key`][].

## Global keys

Use global keys para identificar exclusivamente widgets filhos.
Global keys devem ser globalmente únicas em toda a
hierarquia de widgets, diferentemente de local keys que precisam
ser únicas apenas entre irmãos. Porque são
globalmente únicas, uma global key pode ser usada para
recuperar o estado associado a um widget.

Para mais informações, confira a API [`GlobalKey`][].

[`actions`]: {{site.api}}/flutter/material/AppBar-class.html#actions
[adding interactivity to your Flutter app]: /ui/interactivity
[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`BoxDecoration`]: {{site.api}}/flutter/painting/BoxDecoration-class.html
[`build()`]: {{site.api}}/flutter/widgets/StatelessWidget/build.html
[building layouts]: /ui/layout
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`createState()`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html#createState
[Cupertino components]: /ui/widgets/cupertino
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`CupertinoNavigationBar`]: {{site.api}}/flutter/cupertino/CupertinoNavigationBar-class.html
[`didUpdateWidget()`]: {{site.api}}/flutter/widgets/State-class.html#didUpdateWidget
[`dispose()`]: {{site.api}}/flutter/widgets/State-class.html#dispose
[`Expanded`]: {{site.api}}/flutter/widgets/Expanded-class.html
[`final`]: {{site.dart-site}}/language/variables#final-and-const
[`flex`]: {{site.api}}/flutter/widgets/Expanded-class.html#flex
[`FloatingActionButton`]: {{site.api}}/flutter/material/FloatingActionButton-class.html
[Gestures in Flutter]: /ui/interactivity/gestures
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`GlobalKey`]: {{site.api}}/flutter/widgets/GlobalKey-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`initState()`]: {{site.api}}/flutter/widgets/State-class.html#initState
[`key`]: {{site.api}}/flutter/widgets/Widget-class.html#key
[`Key`]: {{site.api}}/flutter/foundation/Key-class.html
[Layouts]: /ui/widgets/layout
[`leading`]: {{site.api}}/flutter/material/AppBar-class.html#leading
[Material Components widgets]: /ui/widgets/material
[Material icons]: https://design.google.com/icons/
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`onPressed()`]: {{site.api}}/flutter/material/ElevatedButton-class.html#onPressed
[`onTap()`]: {{site.api}}/flutter/widgets/GestureDetector-class.html#onTap
[`Positioned`]: {{site.api}}/flutter/widgets/Positioned-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[React]: https://react.dev
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`runApp()`]: {{site.api}}/flutter/widgets/runApp.html
[`runtimeType`]: {{site.api}}/flutter/widgets/Widget-class.html#runtimeType
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`setState()`]: {{site.api}}/flutter/widgets/State/setState.html
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`title`]: {{site.api}}/flutter/material/AppBar-class.html#title
[`widget`]: {{site.api}}/flutter/widgets/State-class.html#widget
[`Widget`]: {{site.api}}/flutter/widgets/Widget-class.html
