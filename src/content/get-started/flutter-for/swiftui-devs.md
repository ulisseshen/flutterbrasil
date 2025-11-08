---
ia-translate: true
title: Flutter para desenvolvedores SwiftUI
description: Aprenda como aplicar conhecimento de desenvolvimento SwiftUI ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/ios_devs"?>

{% assign sample_path = "blob/main/examples/get-started/flutter-for/ios_devs" %}

Desenvolvedores SwiftUI que querem escrever apps mobile usando Flutter
devem revisar este guia.
Ele explica como aplicar conhecimento existente de SwiftUI ao Flutter.

:::note
Se você tem experiência construindo apps para iOS com UIKit,
veja [Flutter for UIKit developers][].
:::

Flutter é um framework para construir aplicações cross-platform
que usa a linguagem de programação Dart.
Para entender algumas diferenças entre programar com Dart
e programar com Swift, veja [Learning Dart as a Swift Developer][]
e [Flutter concurrency for Swift developers][].

Seu conhecimento e experiência com SwiftUI
são altamente valiosos ao construir com Flutter.
{% comment %}
  TODO: Add talk about plugin system for interacting with OS and hardware
  when [iOS and Apple hardware interactions with Flutter][] is released.
{% endcomment %}

Flutter também faz um número de adaptações
ao comportamento do app quando rodando em iOS e macOS.
Para aprender como, veja [Platform adaptations][].

:::tip
Para integrar código Flutter em um app iOS **existente**,
confira [Add Flutter to existing app][].
:::

Este documento pode ser usado como um livro de receitas pulando por aí
e encontrando questões que são mais relevantes às suas necessidades.
Este guia incorpora código de exemplo.
Usando o botão "Open in DartPad" que aparece ao passar o mouse ou focar,
você pode abrir e executar alguns dos exemplos no DartPad.

## Overview

Como introdução, assista ao seguinte vídeo.
Ele delineia como o Flutter funciona no iOS e como usar Flutter para construir apps iOS.

{% ytEmbed 'ceMsPBbcEGg', 'Flutter for iOS developers', false, true %}

Código Flutter e SwiftUI descreve como a UI parece e funciona.
Desenvolvedores chamam esse tipo de código de _framework declarativo_.

### Views vs. Widgets

**SwiftUI** representa componentes de UI como _views_.
Você configura views usando _modifiers_.

```swift
Text("Hello, World!") // <-- This is a View
  .padding(10)        // <-- This is a modifier of that View
```

**Flutter** representa componentes de UI como _widgets_.

Tanto views quanto widgets só existem até que precisem ser alterados.
Essas linguagens chamam essa propriedade de _imutabilidade_.
SwiftUI representa uma propriedade de componente de UI como um View modifier.
Por contraste, Flutter usa widgets tanto para componentes de UI quanto para
suas propriedades.

```dart
Padding(                         // <-- This is a Widget
  padding: EdgeInsets.all(10.0), // <-- So is this
  child: Text("Hello, World!"),  // <-- This, too
)));
```

Para compor layouts, tanto SwiftUI quanto Flutter aninham componentes de UI
dentro uns dos outros.
SwiftUI aninha Views enquanto Flutter aninha Widgets.

### Processo de layout

**SwiftUI** faz layout de views usando o seguinte processo:

1. A view pai propõe um tamanho para sua view filha.
1. Todas as views filhas subsequentes:
    - propõem um tamanho para _sua_ view filha
    - perguntam a esse filho que tamanho ele quer
1. Cada view pai renderiza sua view filha no tamanho retornado.

**Flutter** difere um pouco com seu processo:

1. O widget pai passa constraints para seus filhos.
   Constraints incluem valores mínimos e máximos para altura e largura.
1. O filho tenta decidir seu tamanho. Ele repete o mesmo processo com sua própria
   lista de filhos:
    - Ele informa seu filho das constraints do filho.
    - Ele pergunta ao seu filho que tamanho ele deseja ser.

1. O pai faz o layout do filho.
    - Se o tamanho solicitado cabe nas constraints,
      o pai usa esse tamanho.
    - Se o tamanho solicitado não cabe nas constraints,
      o pai limita a altura, largura, ou ambos para caber em
      suas constraints.

Flutter difere do SwiftUI porque o componente pai pode sobrescrever
o tamanho desejado do filho. O widget não pode ter qualquer tamanho que quiser.
Ele também não pode saber ou decidir sua posição na tela já que seu pai
toma essa decisão.

Para forçar um widget filho a renderizar em um tamanho específico,
o pai deve definir tight constraints.
Uma constraint se torna tight quando o valor de tamanho mínimo da constraint
é igual ao seu valor de tamanho máximo.

No **SwiftUI**, views podem expandir para o espaço disponível ou
limitar seu tamanho àquele de seu conteúdo.
Widgets **Flutter** se comportam de maneira similar.

No entanto, no Flutter widgets pais podem oferecer unbounded constraints.
Unbounded constraints definem seus valores máximos como infinito.

```dart
UnboundedBox(
  child: Container(
      width: double.infinity, height: double.infinity, color: red),
)
```

Se o filho expandir e tiver unbounded constraints,
Flutter retorna um aviso de overflow:

```dart
UnconstrainedBox(
  child: Container(color: red, width: 4000, height: 50),
)
```

<img src="/assets/images/docs/ui/layout/layout-14.png" alt="When parents pass unbounded constraints to children, and the children are expanding, then there is an overflow warning.">

Para aprender como constraints funcionam no Flutter,
veja [Understanding constraints][].

### Sistema de design

Como o Flutter tem como alvo múltiplas plataformas, seu app não precisa
se conformar a nenhum sistema de design.
Embora este guia apresente widgets [Material][],
seu app Flutter pode usar muitos sistemas de design diferentes:

- Custom Material widgets
- Community built widgets
- Seus próprios widgets personalizados
- [Cupertino widgets][] que seguem as Apple's Human Interface Guidelines

{% ytEmbed '3PdUaidHc-E', 'Flutter\'s cupertino library for iOS developers' %}

Se você está procurando um ótimo app de referência que apresenta um
sistema de design personalizado, confira [Wonderous][].

## Básicos de UI

Esta seção cobre os básicos de desenvolvimento de UI no
Flutter e como ele se compara ao SwiftUI.
Isso inclui como começar a desenvolver seu app, exibir texto estático,
criar botões, reagir a eventos de pressionar, exibir listas, grids, e mais.

### Começando

No **SwiftUI**, você usa `App` para iniciar seu app.

```swift
@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            HomePage()
        }
    }
}
```

Outra prática comum do SwiftUI coloca o corpo do app dentro de uma `struct`
que conforma ao protocolo `View` da seguinte forma:

```swift
struct HomePage: View {
  var body: some View {
    Text("Hello, World!")
  }
}
```

Para iniciar seu app **Flutter**, passe uma instância de seu app para
a função `runApp`.

<?code-excerpt "lib/get_started.dart (main)"?>
```dart dartpad="42cf3026e1460ef618257684ee5af6a2"
void main() {
  runApp(const MyApp());
}
```

`App` é um widget. O método build descreve a parte da interface de usuário
que ele representa.
É comum começar seu app com uma classe [`WidgetApp`][],
como [`CupertinoApp`][].

<?code-excerpt "lib/get_started.dart (myapp)"?>
```dart dartpad="42cf3026e1460ef618257684ee5af6a2"
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Returns a CupertinoApp that, by default,
    // has the look and feel of an iOS app.
    return const CupertinoApp(
      home: HomePage(),
    );
  }
}
```

O widget usado em `HomePage` pode começar com a classe `Scaffold`.
`Scaffold` implementa uma estrutura de layout básica para um app.

<?code-excerpt "lib/get_started.dart (homepage)"?>
```dart dartpad="42cf3026e1460ef618257684ee5af6a2"
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Hello, World!',
        ),
      ),
    );
  }
}
```

Note como o Flutter usa o widget [`Center`][].
SwiftUI renderiza o conteúdo de uma view em seu centro por padrão.
Esse não é sempre o caso com Flutter.
`Scaffold` não renderiza seu widget `body` no centro da tela.
Para centralizar o texto, envolva-o em um widget `Center`.
Para aprender sobre widgets diferentes e seus comportamentos padrão, confira
o [Widget catalog][].

### Adicionando Botões

No **SwiftUI**, você usa o struct `Button` para criar um botão.

```swift
Button("Do something") {
  // this closure gets called when your
  // button is tapped
}
```

Para alcançar o mesmo resultado no **Flutter**,
use a classe `CupertinoButton`:

<?code-excerpt "lib/text_button.dart (text-button)" replace="/child: //g;"?>
```dart dartpad="3c9b9a4de431b86725197a7fc2c84158"
CupertinoButton(
  onPressed: () {
    // This closure is called when your button is tapped.
  },
  const Text('Do something'),
),
```

**Flutter** te dá acesso a uma variedade de botões com estilos predefinidos.
A classe [`CupertinoButton`][] vem da biblioteca Cupertino.
Widgets na biblioteca Cupertino usam o sistema de design da Apple.

### Alinhando componentes horizontalmente

No **SwiftUI**, stack views têm um papel importante ao projetar seus layouts.
Duas estruturas separadas permitem que você crie stacks:

1. `HStack` para horizontal stack views

2. `VStack` para vertical stack views

A seguinte view SwiftUI adiciona uma imagem de globo e
texto a uma horizontal stack view:

```swift
HStack {
  Image(systemName: "globe")
  Text("Hello, world!")
}
```

**Flutter** usa [`Row`][] ao invés de `HStack`:

<?code-excerpt "lib/row.dart (row)" replace="/child: //g;"?>
```dart dartpad="0365338f938427b01d72e37cea554f75"
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(CupertinoIcons.globe),
    Text('Hello, world!'),
  ],
),
```

O widget `Row` requer uma `List<Widget>` no parâmetro `children`.
A propriedade `mainAxisAlignment` diz ao Flutter como posicionar filhos
com espaço extra. `MainAxisAlignment.center` posiciona filhos no
centro do eixo principal. Para `Row`, o eixo principal é o eixo
horizontal.

### Alinhando componentes verticalmente

Os exemplos seguintes constroem sobre aqueles da seção anterior.

No **SwiftUI**, você usa `VStack` para organizar os componentes em uma
pilha vertical.

```swift
VStack {
  Image(systemName: "globe")
  Text("Hello, world!")
}
```

**Flutter** usa o mesmo código Dart do exemplo anterior,
exceto que troca [`Column`][] por `Row`:

<?code-excerpt "lib/column.dart (column)" replace="/child: //g;"?>
```dart dartpad="d9a288be0c2a353296fc8825680b84b8"
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(CupertinoIcons.globe),
    Text('Hello, world!'),
  ],
),
```

### Exibindo uma list view

No **SwiftUI**, você usa o componente base `List` para exibir sequências
de itens.
Para exibir uma sequência de objetos modelo, certifique-se de que o usuário possa
identificar seus objetos modelo.
Para tornar um objeto identificável, use o protocolo `Identifiable`.

```swift
struct Person: Identifiable {
  var name: String
}

var persons = [
  Person(name: "Person 1"),
  Person(name: "Person 2"),
  Person(name: "Person 3"),
]

struct ListWithPersons: View {
  let persons: [Person]
  var body: some View {
    List {
      ForEach(persons) { person in
        Text(person.name)
      }
    }
  }
}
```

Isso se assemelha a como **Flutter** prefere construir seus widgets de lista.
Flutter não precisa que os itens da lista sejam identificáveis.
Você define o número de itens a exibir e então constrói um widget para cada item.

<?code-excerpt "lib/list.dart (simple-list)"?>
```dart dartpad="67426fd4f9c38c0c1db96b1af65598f2"
class Person {
  String name;
  Person(this.name);
}

final List<Person> items = [
  Person('Person 1'),
  Person('Person 2'),
  Person('Person 3'),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index].name),
          );
        },
      ),
    );
  }
}
```

Flutter tem algumas ressalvas para listas:

- O widget [`ListView`] tem um método builder.
  Isso funciona como o `ForEach` dentro do struct `List` do SwiftUI.

- O parâmetro `itemCount` do `ListView` define quantos itens
  o `ListView` exibe.

- O `itemBuilder` tem um parâmetro index que estará entre zero
  e um a menos que itemCount.

O exemplo anterior retornou um widget [`ListTile`][] para cada item.
O widget `ListTile` inclui propriedades como `height` e `font-size`.
Essas propriedades ajudam a construir uma lista. No entanto, Flutter permite que você retorne
quase qualquer widget que represente seus dados.

### Exibindo um grid

Ao construir grids não-condicionais no **SwiftUI**,
você usa `Grid` com `GridRow`.

```swift
Grid {
  GridRow {
    Text("Row 1")
    Image(systemName: "square.and.arrow.down")
    Image(systemName: "square.and.arrow.up")
  }
  GridRow {
    Text("Row 2")
    Image(systemName: "square.and.arrow.down")
    Image(systemName: "square.and.arrow.up")
  }
}
```

Para exibir grids no **Flutter**, use o widget [`GridView`].
Este widget tem vários construtores. Cada construtor tem
um objetivo similar, mas usa parâmetros de entrada diferentes.
O exemplo seguinte usa o inicializador `.builder()`:

<?code-excerpt "lib/grid.dart (grid-example)"?>
```dart dartpad="d6b9174f33db94164e457b3da80da933"
const widgets = [
  Text('Row 1'),
  Icon(CupertinoIcons.arrow_down_square),
  Icon(CupertinoIcons.arrow_up_square),
  Text('Row 2'),
  Icon(CupertinoIcons.arrow_down_square),
  Icon(CupertinoIcons.arrow_up_square),
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 40,
        ),
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
      ),
    );
  }
}
```

O delegate `SliverGridDelegateWithFixedCrossAxisCount` determina
vários parâmetros que o grid usa para fazer layout de seus componentes.
Isso inclui `crossAxisCount` que dita o número de itens
exibidos em cada linha.

Como o `Grid` do SwiftUI e o `GridView` do Flutter diferem em que `Grid`
requer `GridRow`. `GridView` usa o delegate para decidir como o
grid deve fazer layout de seus componentes.

### Criando uma scroll view

No **SwiftUI**, você usa `ScrollView` para criar componentes
de rolagem personalizados.
O exemplo seguinte exibe uma série de instâncias `PersonView`
de forma rolável.

```swift
ScrollView {
  VStack(alignment: .leading) {
    ForEach(persons) { person in
      PersonView(person: person)
    }
  }
}
```

Para criar uma view de rolagem, **Flutter** usa [`SingleChildScrollView`][].
No exemplo seguinte, a função `mockPerson` simula instâncias
da classe `Person` para criar o widget personalizado `PersonView`.

<?code-excerpt "lib/scroll.dart (scroll-example)" replace="/body: //g;"?>
```dart dartpad="a75740320989ed04020d95502a0de34e"
SingleChildScrollView(
  child: Column(
    children: mockPersons
        .map(
          (person) => PersonView(
            person: person,
          ),
        )
        .toList(),
  ),
),
```

### Design responsivo e adaptativo

No **SwiftUI**, você usa `GeometryReader` para criar tamanhos de view relativos.

Por exemplo, você poderia:

- Multiplicar `geometry.size.width` por algum fator para definir a _width_.
- Usar `GeometryReader` como um breakpoint para mudar o design de seu app.

Você também pode ver se a size class tem `.regular` ou `.compact`
usando `horizontalSizeClass`.

Para criar views relativas no **Flutter**, você pode usar uma de duas opções:

- Obter o objeto `BoxConstraints` na classe [`LayoutBuilder`][].
- Usar o [`MediaQuery.of()`][] em suas funções build
  para obter o tamanho e orientação de seu app atual.

Para aprender mais, confira [Creating responsive and adaptive apps][].

### Gerenciando estado

No **SwiftUI**, você usa o property wrapper `@State` para representar o
estado interno de uma view SwiftUI.

```swift
struct ContentView: View {
  @State private var counter = 0;
  var body: some View {
    VStack{
      Button("+") { counter+=1 }
      Text(String(counter))
    }
  }}
```

**SwiftUI** também inclui várias opções para gerenciamento de estado
mais complexo, como o protocolo `ObservableObject`.

**Flutter** gerencia estado local usando um [`StatefulWidget`][].
Implemente um stateful widget com as duas classes seguintes:

- uma subclasse de `StatefulWidget`
- uma subclasse de `State`

O objeto `State` armazena o estado do widget.
Para mudar o estado de um widget, chame `setState()` da subclasse `State`
para dizer ao framework para redesenhar o widget.

O exemplo seguinte mostra parte de um app contador:

<?code-excerpt "lib/state.dart (state)"?>
```dart dartpad="34815ab7d6ee0c5a45c82597df444450"
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$_counter'),
            TextButton(
              onPressed: () => setState(() {
                _counter++;
              }),
              child: const Text('+'),
            ),
          ],
        ),
      ),
    );
  }
}
```

Para aprender mais maneiras de gerenciar estado, confira [State management][].

### Animações

Existem dois tipos principais de animações de UI.

- Implícita que anima de um valor atual para um novo alvo.
- Explícita que anima quando solicitada.

#### Animação Implícita

SwiftUI e Flutter adotam uma abordagem similar para animação.
Em ambos os frameworks, você especifica parâmetros como `duration` e `curve`.

No **SwiftUI**, você usa o modifier `animate()` para lidar com animação
implícita.

```swift
Button("Tap me!"){
   angle += 45
}
.rotationEffect(.degrees(angle))
.animation(.easeIn(duration: 1))
```

**Flutter** inclui widgets para animação implícita.
Isso simplifica animar widgets comuns.
Flutter nomeia esses widgets com o seguinte formato: `AnimatedFoo`.

Por exemplo: Para rotacionar um botão, use a classe [`AnimatedRotation`][].
Isso anima o widget `Transform.rotate`.

<?code-excerpt "lib/simple_animation.dart (animated-button)" replace="/child: //g;"?>
```dart dartpad="0ad0572cbf98ead2e5d31a2a94430f19"
AnimatedRotation(
  duration: const Duration(seconds: 1),
  turns: turns,
  curve: Curves.easeIn,
  TextButton(
      onPressed: () {
        setState(() {
          turns += .125;
        });
      },
      const Text('Tap me!')),
),
```

Flutter permite que você crie animações implícitas personalizadas.
Para compor um novo widget animado, use o [`TweenAnimationBuilder`][].

#### Animação Explícita

Para animações explícitas, **SwiftUI** usa a função `withAnimation()`.

**Flutter** inclui widgets explicitamente animados com nomes formatados
como `FooTransition`.
Um exemplo seria a classe [`RotationTransition`][].

Flutter também permite que você crie uma animação explícita personalizada usando
`AnimatedWidget` ou `AnimatedBuilder`.

Para aprender mais sobre animações no Flutter, veja [Animations overview][].

### Desenhando na tela

No **SwiftUI**, você usa `CoreGraphics` para desenhar linhas e formas na
tela.

**Flutter** tem uma API baseada na classe `Canvas`,
com duas classes que ajudam você a desenhar:

1. [`CustomPaint`][] que requer um painter:

    <?code-excerpt "lib/canvas.dart (custom-paint)" replace="/child: //g;"?>
    ```dart dartpad="978d64ee66d54177fb639f8a9f801039"
    CustomPaint(
      painter: SignaturePainter(_points),
      size: Size.infinite,
    ),
    ```

2. [`CustomPainter`][] que implementa seu algoritmo para desenhar no canvas.

    <?code-excerpt "lib/canvas.dart (custom-painter)"?>
    ```dart dartpad="978d64ee66d54177fb639f8a9f801039"
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

## Navegação

Esta seção explica como navegar entre páginas de um app,
o mecanismo de push e pop, e mais.

### Navegando entre páginas

Desenvolvedores constroem apps iOS e macOS com diferentes páginas chamadas
_navigation routes_.

No **SwiftUI**, o `NavigationStack` representa esta pilha de páginas.

O exemplo seguinte cria um app que exibe uma lista de pessoas.
Para exibir os detalhes de uma pessoa em um novo navigation link,
toque naquela pessoa.

```swift
NavigationStack(path: $path) {
      List {
        ForEach(persons) { person in
          NavigationLink(
            person.name,
            value: person
          )
        }
      }
      .navigationDestination(for: Person.self) { person in
        PersonView(person: person)
      }
    }
```

Se você tem um app **Flutter** pequeno sem linking complexo,
use [`Navigator`][] com named routes.
Após definir suas navigation routes,
chame suas navigation routes usando seus nomes.

1. Nomeie cada route na classe passada para a função `runApp()`.
   O exemplo seguinte usa `App`:

    <?code-excerpt "lib/navigation.dart (routes)"?>
    ```dart dartpad="d8b22d4dcbefdc8a2e21f1382cf7dc2a"
    // Defines the route name as a constant
    // so that it's reusable.
    const detailsPageRouteName = '/details';
    
    class App extends StatelessWidget {
      const App({
        super.key,
      });
    
      @override
      Widget build(BuildContext context) {
        return CupertinoApp(
          home: const HomePage(),
          // The [routes] property defines the available named routes
          // and the widgets to build when navigating to those routes.
          routes: {
            detailsPageRouteName: (context) => const DetailsPage(),
          },
        );
      }
    }
    ```

   O exemplo seguinte gera uma lista de pessoas usando
   `mockPersons()`. Tocar em uma pessoa empurra a página de detalhes da pessoa
   para o `Navigator` usando `pushNamed()`.

    <?code-excerpt "lib/navigation.dart (list-view)" replace="/child: //g;"?>
    ```dart dartpad="d8b22d4dcbefdc8a2e21f1382cf7dc2a"
    ListView.builder(
      itemCount: mockPersons.length,
      itemBuilder: (context, index) {
        final person = mockPersons.elementAt(index);
        final age = '${person.age} years old';
        return ListTile(
          title: Text(person.name),
          subtitle: Text(age),
          trailing: const Icon(
            Icons.arrow_forward_ios,
          ),
          onTap: () {
            // When a [ListTile] that represents a person is
            // tapped, push the detailsPageRouteName route
            // to the Navigator and pass the person's instance
            // to the route.
            Navigator.of(context).pushNamed(
              detailsPageRouteName,
              arguments: person,
            );
          },
        );
      },
    ),
    ```

1. Defina o widget `DetailsPage` que exibe os detalhes de
   cada pessoa. No Flutter, você pode passar argumentos para o
   widget ao navegar para a nova route.
   Extraia os argumentos usando `ModalRoute.of()`:

    <?code-excerpt "lib/navigation.dart (details-page)"?>
    ```dart dartpad="d8b22d4dcbefdc8a2e21f1382cf7dc2a"
    class DetailsPage extends StatelessWidget {
      const DetailsPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        // Read the person instance from the arguments.
        final Person person = ModalRoute.of(
          context,
        )?.settings.arguments as Person;
        // Extract the age.
        final age = '${person.age} years old';
        return Scaffold(
          // Display name and age.
          body: Column(children: [Text(person.name), Text(age)]),
        );
      }
    }
    ```

Para criar requisitos de navegação e roteamento mais avançados,
use um pacote de roteamento como [go_router][].

Para aprender mais, confira [Navigation and routing][].

### Fazendo pop back manualmente

No **SwiftUI**, você usa o valor de ambiente `dismiss` para fazer pop-back para
a tela anterior.

```swift
Button("Pop back") {
        dismiss()
      }
```

No **Flutter**, use a função `pop()` da classe `Navigator`:

<?code-excerpt "lib/popback.dart (pop-back)"?>
```dart dartpad="3c125ab2dfba9f4178aeaeb8619c5bea"
TextButton(
  onPressed: () {
    // This code allows the
    // view to pop back to its presenter.
    Navigator.of(context).pop();
  },
  child: const Text('Pop back'),
),
```

### Navegando para outro app

No **SwiftUI**, você usa a variável de ambiente `openURL` para abrir uma
URL para outra aplicação.

```swift
@Environment(\.openURL) private var openUrl

// View code goes here

 Button("Open website") {
      openUrl(
        URL(
          string: "https://google.com"
        )!
      )
    }
```

No **Flutter**, use o plugin [`url_launcher`][].

<?code-excerpt "lib/openapp.dart (open-app-example)" replace="/child: //g;"?>
```dart dartpad="695beba25fa8120d89c9960cb222e276"
CupertinoButton(
  onPressed: () async {
    await launchUrl(
      Uri.parse('https://google.com'),
    );
  },
  const Text(
    'Open website',
  ),
),
```

## Temas, estilos e mídia

Você pode estilizar apps Flutter com pouco esforço.
Estilização inclui alternar entre temas claro e escuro,
mudar o design de seu texto e componentes de UI,
e mais. Esta seção cobre como estilizar seus apps.

### Usando dark mode

No **SwiftUI**, você chama a função `preferredColorScheme()`
em uma `View` para usar dark mode.

No **Flutter**, você pode controlar modo claro e escuro no nível do app.
Para controlar o modo de brilho, use a propriedade `theme`
da classe `App`:

<?code-excerpt "lib/cupertino_themes.dart (theme)" replace="/return //g;"?>
```dart dartpad="18790cfaa8441085994373a4bc4f46b0"
const CupertinoApp(
  theme: CupertinoThemeData(
    brightness: Brightness.dark,
  ),
  home: HomePage(),
);
```

### Estilizando texto

No **SwiftUI**, você usa funções modifier para estilizar texto.
Por exemplo, para mudar a fonte de uma string `Text`,
use o modifier `font()`:

```swift
Text("Hello, world!")
  .font(.system(size: 30, weight: .heavy))
  .foregroundColor(.yellow)
```

Para estilizar texto no **Flutter**, adicione um widget `TextStyle` como o valor
do parâmetro `style` do widget `Text`.

<?code-excerpt "lib/cupertino_themes.dart (styling-text)" replace="/child: //g;"?>
```dart dartpad="18790cfaa8441085994373a4bc4f46b0"
Text(
  'Hello, world!',
  style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: CupertinoColors.systemYellow,
  ),
),
```

### Estilizando botões

No **SwiftUI**, você usa funções modifier para estilizar botões.

```swift
Button("Do something") {
    // do something when button is tapped
  }
  .font(.system(size: 30, weight: .bold))
  .background(Color.yellow)
  .foregroundColor(Color.blue)
}
```

Para estilizar widgets de botão no **Flutter**, defina o estilo de seu filho,
ou modifique propriedades no próprio botão.

No exemplo seguinte:

- A propriedade `color` de `CupertinoButton` define sua `color`.
- A propriedade `color` do widget filho `Text` define a cor do
  texto do botão.

<?code-excerpt "lib/stylingbutton.dart (styling-button)"?>
```dart dartpad="f8b6622f526fc5c7d5adadf1e071c28f"
child: CupertinoButton(
  color: CupertinoColors.systemYellow,
  onPressed: () {},
  padding: const EdgeInsets.all(16),
  child: const Text(
    'Do something',
    style: TextStyle(
      color: CupertinoColors.systemBlue,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  ),
),
```

### Usando fontes personalizadas

No **SwiftUI**, você pode usar uma fonte personalizada em seu app em dois passos.
Primeiro, adicione o arquivo de fonte ao seu projeto SwiftUI. Após adicionar o arquivo,
use o modifier `.font()` para aplicá-lo aos seus componentes de UI.

```swift
Text("Hello")
  .font(
    Font.custom(
      "BungeeSpice-Regular",
      size: 40
    )
  )
```

No **Flutter**, você controla seus recursos com um arquivo
chamado `pubspec.yaml`. Este arquivo é agnóstico de plataforma.
Para adicionar uma fonte personalizada ao seu projeto, siga estes passos:

1. Crie uma pasta chamada `fonts` no diretório raiz do projeto.
   Este passo opcional ajuda a organizar suas fontes.
1. Adicione seu arquivo de fonte `.ttf`, `.otf`, ou `.ttc` na pasta `fonts`.
1. Abra o arquivo `pubspec.yaml` dentro do projeto.
1. Encontre a seção `flutter`.
1. Adicione sua(s) fonte(s) personalizada(s) sob a seção `fonts`.

    ```yaml
    flutter:
      fonts:
        - family: BungeeSpice
          fonts:
            - asset: fonts/BungeeSpice-Regular.ttf
    ```

Após adicionar a fonte ao seu projeto, você pode usá-la como no
exemplo seguinte:

<?code-excerpt "lib/stylingbutton.dart (custom-font)" replace="/middle: //g;"?>
```dart
Text(
  'Cupertino',
  style: TextStyle(
    fontSize: 40,
    fontFamily: 'BungeeSpice',
  ),
),
```

:::note
Para baixar fontes personalizadas para usar em seus apps,
confira [Google Fonts](https://fonts.google.com).
:::

### Empacotando imagens em apps

No **SwiftUI**, você primeiro adiciona os arquivos de imagem a `Assets.xcassets`,
então usa a view `Image` para exibir as imagens.

Para adicionar imagens no **Flutter**, siga um método similar a como você adicionou
fontes personalizadas.

1. Adicione uma pasta `images` ao diretório raiz.
1. Adicione este asset ao arquivo `pubspec.yaml`.

    ```yaml
    flutter:
      assets:
        - images/Blueberries.jpg
    ```

Após adicionar sua imagem, exiba-a usando o construtor
`.asset()` do widget `Image`. Este construtor:

1. Instancia a imagem dada usando o caminho fornecido.
1. Lê a imagem dos assets empacotados com seu app.
1. Exibe a imagem na tela.

Para revisar um exemplo completo, confira a documentação de [`Image`][].

### Empacotando vídeos em apps

No **SwiftUI**, você empacota um arquivo de vídeo local com seu app em dois
passos.
Primeiro, você importa o framework `AVKit`, então você instancia uma
view `VideoPlayer`.

No **Flutter**, adicione o plugin [video_player][] ao seu projeto.
Este plugin permite que você crie um video player que funciona no
Android, iOS, e na web a partir da mesma codebase.

1. Adicione o plugin ao seu app e adicione o arquivo de vídeo ao seu projeto.
1. Adicione o asset ao seu arquivo `pubspec.yaml`.
1. Use a classe `VideoPlayerController` para carregar e reproduzir seu arquivo
   de vídeo.

Para revisar um passo-a-passo completo, confira o [video_player example][].

[Flutter for UIKit developers]: /get-started/flutter-for/uikit-devs
[Add Flutter to existing app]: /add-to-app
[Animations overview]: /ui/animations
[Cupertino widgets]: /ui/widgets/cupertino
[Flutter concurrency for Swift developers]: /get-started/flutter-for/dart-swift-concurrency
[Navigation and routing]: /ui/navigation
[Material]: {{site.material}}/develop/flutter/
[Platform adaptations]: /platform-integration/platform-adaptations
[`url_launcher`]: {{site.pub-pkg}}/url_launcher
[widget catalog]: /ui/widgets/layout
[Understanding constraints]: /ui/layout/constraints
[`WidgetApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[`CupertinoApp`]: {{site.api}}/flutter/cupertino/CupertinoApp-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`CupertinoButton`]: {{site.api}}/flutter/cupertino/CupertinoButton-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[Learning Dart as a Swift Developer]: {{site.dart-site}}/guides/language/coming-from/swift-to-dart
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListTile`]: {{site.api}}/flutter/widgets/ListTitle-class.html
[`GridView`]: {{site.api}}/flutter/widgets/GridView-class.html
[`SingleChildScrollView`]: {{site.api}}/flutter/widgets/SingleChildScrollView-class.html
[`LayoutBuilder`]: {{site.api}}/flutter/widgets/LayoutBuilder-class.html
[`AnimatedRotation`]: {{site.api}}/flutter/widgets/AnimatedRotation-class.html
[`TweenAnimationBuilder`]: {{site.api}}/flutter/widgets/TweenAnimationBuilder-class.html
[`RotationTransition`]: {{site.api}}/flutter/widgets/RotationTransition-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[State management]:  /data-and-backend/state-mgmt
[Wonderous]: https://flutter.gskinner.com/wonderous/?utm_source=flutterdocs&utm_medium=docs&utm_campaign=iosdevs
[video_player]: {{site.pub-pkg}}/video_player
[video_player example]: {{site.pub-pkg}}/video_player/example
[Creating responsive and adaptive apps]: /ui/adaptive-responsive
[`MediaQuery.of()`]: {{site.api}}/flutter/widgets/MediaQuery-class.html
[`CustomPaint`]: {{site.api}}/flutter/widgets/CustomPaint-class.html
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[go_router]: {{site.pub-pkg}}/go_router
