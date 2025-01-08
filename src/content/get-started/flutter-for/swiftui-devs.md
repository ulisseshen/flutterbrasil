---
ia-translate: true
title: Flutter para Desenvolvedores SwiftUI
description: Aprenda como aplicar o conhecimento de desenvolvedor SwiftUI ao construir aplicativos Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/ios_devs"?>

{% assign sample_path = "blob/main/examples/get-started/flutter-for/ios_devs" %}

Desenvolvedores SwiftUI que desejam escrever aplicativos móveis usando
Flutter devem revisar este guia. Ele explica como aplicar o conhecimento
existente de SwiftUI ao Flutter.

:::note
Se você, em vez disso, tiver experiência na criação de aplicativos para
iOS com UIKit, veja [Flutter para desenvolvedores UIKit][Flutter for UIKit developers].
:::

Flutter é um framework para construir aplicações multiplataforma que usa
a linguagem de programação Dart. Para entender algumas diferenças entre a
programação com Dart e a programação com Swift, consulte [Aprendendo Dart
como um Desenvolvedor Swift][Learning Dart as a Swift Developer] e [Concorrência Flutter para desenvolvedores
Swift][Flutter concurrency for Swift developers].

Seu conhecimento e experiência em SwiftUI são muito valiosos ao construir
com Flutter.
{% comment %}
  TODO: Adicionar uma conversa sobre o sistema de plugins para interagir com o
  SO e o hardware quando [Interações de hardware iOS e Apple com o Flutter][]
  for lançado.
{% endcomment %}

O Flutter também faz uma série de adaptações ao comportamento do
aplicativo ao ser executado no iOS e macOS. Para saber como, consulte
[Adaptações de plataforma][Platform adaptations].

:::tip
Para integrar o código Flutter em um aplicativo iOS **existente**,
confira [Adicionar Flutter a um aplicativo existente][Add Flutter to existing app].
:::

Este documento pode ser usado como um livro de receitas, navegando e
encontrando as perguntas mais relevantes para suas necessidades. Este
guia incorpora exemplos de código. Usando o botão "Abrir no DartPad" que
aparece ao passar o mouse ou focar, você pode abrir e executar alguns dos
exemplos no DartPad.

## Visão geral

Como introdução, assista ao seguinte vídeo. Ele descreve como o Flutter
funciona no iOS e como usar o Flutter para construir aplicativos iOS.

{% ytEmbed 'ceMsPBbcEGg', 'Flutter para desenvolvedores iOS', false, true %}

O código Flutter e SwiftUI descreve como a interface do usuário aparece e
funciona. Os desenvolvedores chamam este tipo de código de _framework
declarativo_.

### Views vs. Widgets

**SwiftUI** representa componentes da interface do usuário como _views_.
Você configura views usando _modificadores_.

```swift
Text("Olá, Mundo!") // <-- Isso é uma View
  .padding(10)        // <-- Isso é um modificador dessa View
```

**Flutter** representa os componentes da interface do usuário como
_widgets_.

Tanto views quanto widgets só existem até que precisem ser alterados.
Essas linguagens chamam essa propriedade de _imutabilidade_. SwiftUI
representa uma propriedade de componente da interface do usuário como um
modificador de View. Por outro lado, o Flutter usa widgets tanto para
componentes da interface do usuário quanto para suas propriedades.

```dart
Padding(                         // <-- Isso é um Widget
  padding: EdgeInsets.all(10.0), // <-- Isso também
  child: Text("Olá, Mundo!"),  // <-- Isso também
)));
```

Para compor layouts, tanto o SwiftUI quanto o Flutter aninham os
componentes da interface do usuário uns dentro dos outros. O SwiftUI
aninham Views enquanto o Flutter aninham Widgets.

### Processo de Layout

**SwiftUI** organiza as views usando o seguinte processo:

1. A view pai propõe um tamanho para sua view filha.
2. Todas as views filhas subsequentes:
    - propõem um tamanho para a view de seu _próprio_ filho
    - perguntam a esse filho qual tamanho ele deseja
3. Cada view pai renderiza sua view filha no tamanho retornado.

**Flutter** difere um pouco com seu processo:

1. O widget pai passa restrições para seus filhos. As restrições
   incluem valores mínimos e máximos para altura e largura.
2. O filho tenta decidir seu tamanho. Ele repete o mesmo processo com sua
   própria lista de filhos:
    - Informa seu filho das restrições do filho.
    - Pergunta ao filho qual tamanho ele deseja ter.

3. O pai organiza o filho.
    - Se o tamanho solicitado se encaixar nas restrições, o pai usa esse
      tamanho.
    - Se o tamanho solicitado não se encaixar nas restrições, o pai limita
      a altura, a largura ou ambos para se encaixar em suas restrições.

O Flutter difere do SwiftUI porque o componente pai pode substituir o
tamanho desejado do filho. O widget não pode ter qualquer tamanho que
desejar. Ele também não pode saber ou decidir sua posição na tela, pois
seu pai toma essa decisão.

Para forçar um widget filho a renderizar em um tamanho específico, o
pai deve definir restrições rígidas. Uma restrição torna-se rígida quando
o valor de tamanho mínimo de sua restrição é igual ao seu valor de
tamanho máximo.

Em **SwiftUI**, as views podem se expandir para o espaço disponível ou
limitar seu tamanho ao de seu conteúdo. Os widgets do **Flutter** se
comportam de maneira semelhante.

No entanto, no Flutter, os widgets pai podem oferecer restrições
ilimitadas. Restrições ilimitadas definem seus valores máximos para
infinito.

```dart
UnboundedBox(
  child: Container(
      width: double.infinity, height: double.infinity, color: red),
)
```

Se o filho se expandir e tiver restrições ilimitadas, o Flutter
retornará um aviso de estouro:

```dart
UnconstrainedBox(
  child: Container(color: red, width: 4000, height: 50),
)
```

<img src="/assets/images/docs/ui/layout/layout-14.png" alt="Quando os pais passam restrições ilimitadas para os filhos, e os filhos estão se expandindo, então há um aviso de estouro.">

Para saber como as restrições funcionam no Flutter, consulte
[Entendendo as restrições][Understanding constraints].

### Sistema de design

Como o Flutter tem como alvo várias plataformas, seu aplicativo não
precisa estar em conformidade com nenhum sistema de design. Embora este
guia apresente widgets [Material][Material], seu aplicativo Flutter pode usar
muitos sistemas de design diferentes:

- Widgets Material personalizados
- Widgets construídos pela comunidade
- Seus próprios widgets personalizados
- [Widgets Cupertino][Cupertino widgets] que seguem as Diretrizes de Interface Humana da
  Apple

{% ytEmbed '3PdUaidHc-E', 'Biblioteca cupertino do Flutter para desenvolvedores iOS' %}

Se você está procurando um ótimo aplicativo de referência que apresenta um
sistema de design personalizado, confira [Wonderous][Wonderous].

## Conceitos básicos de UI

Esta seção aborda os conceitos básicos de desenvolvimento de UI no
Flutter e como ele se compara ao SwiftUI. Isso inclui como começar a
desenvolver seu aplicativo, exibir texto estático, criar botões, reagir a
eventos de pressão, exibir listas, grades e muito mais.

### Começando

Em **SwiftUI**, você usa `App` para iniciar seu aplicativo.

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

Outra prática comum do SwiftUI coloca o corpo do aplicativo dentro de uma
`struct` que está em conformidade com o protocolo `View` da seguinte
forma:

```swift
struct HomePage: View {
  var body: some View {
    Text("Olá, Mundo!")
  }
}
```

Para iniciar seu aplicativo **Flutter**, passe uma instância do seu
aplicativo para a função `runApp`.

<?code-excerpt "lib/get_started.dart (main)"?>
```dart dartpad="42cf3026e1460ef618257684ee5af6a2"
void main() {
  runApp(const MyApp());
}
```

`App` é um widget. O método build descreve a parte da interface do
usuário que ele representa. É comum iniciar seu aplicativo com uma classe
[`WidgetApp`][`WidgetApp`], como [`CupertinoApp`][`CupertinoApp`].

<?code-excerpt "lib/get_started.dart (myapp)"?>
```dart dartpad="42cf3026e1460ef618257684ee5af6a2"
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Retorna um CupertinoApp que, por padrão,
    // tem a aparência de um aplicativo iOS.
    return const CupertinoApp(
      home: HomePage(),
    );
  }
}
```

O widget usado em `HomePage` pode começar com a classe `Scaffold`.
`Scaffold` implementa uma estrutura de layout básica para um aplicativo.

<?code-excerpt "lib/get_started.dart (homepage)"?>
```dart dartpad="42cf3026e1460ef618257684ee5af6a2"
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Olá, Mundo!',
        ),
      ),
    );
  }
}
```

Observe como o Flutter usa o widget [`Center`][`Center`]. O SwiftUI renderiza o
conteúdo de uma view em seu centro por padrão. Esse nem sempre é o caso
com o Flutter. `Scaffold` não renderiza seu widget `body` no centro da
tela. Para centralizar o texto, envolva-o em um widget `Center`. Para
aprender sobre diferentes widgets e seus comportamentos padrão, confira
o [Catálogo de widgets][widget catalog].

### Adicionando botões

Em **SwiftUI**, você usa a struct `Button` para criar um botão.

```swift
Button("Fazer algo") {
  // este closure é chamado quando o seu
  // botão é tocado
}
```

Para obter o mesmo resultado no **Flutter**, use a classe
`CupertinoButton`:

<?code-excerpt "lib/text_button.dart (text-button)" replace="/child: //g;"?>
```dart dartpad="3c9b9a4de431b86725197a7fc2c84158"
CupertinoButton(
  onPressed: () {
    // Este closure é chamado quando seu botão é tocado.
  },
  const Text('Fazer algo'),
),
```

O **Flutter** oferece acesso a uma variedade de botões com estilos
predefinidos. A classe [`CupertinoButton`][`CupertinoButton`] vem da biblioteca
Cupertino. Os widgets na biblioteca Cupertino usam o sistema de design da
Apple.

### Alinhando componentes horizontalmente

Em **SwiftUI**, as stack views desempenham um papel importante no
design de seus layouts. Duas estruturas separadas permitem que você crie
stacks:

1. `HStack` para stack views horizontais

2. `VStack` para stack views verticais

A seguinte view do SwiftUI adiciona uma imagem do globo e texto a uma
stack view horizontal:

```swift
HStack {
  Image(systemName: "globe")
  Text("Olá, mundo!")
}
```

O **Flutter** usa [`Row`][`Row`] em vez de `HStack`:

<?code-excerpt "lib/row.dart (row)" replace="/child: //g;"?>
```dart dartpad="0365338f938427b01d72e37cea554f75"
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(CupertinoIcons.globe),
    Text('Olá, mundo!'),
  ],
),
```

O widget `Row` requer um `List<Widget>` no parâmetro `children`. A
propriedade `mainAxisAlignment` diz ao Flutter como posicionar os filhos
com espaço extra. `MainAxisAlignment.center` posiciona os filhos no
centro do eixo principal. Para `Row`, o eixo principal é o eixo
horizontal.

### Alinhando componentes verticalmente

Os exemplos a seguir se baseiam nos da seção anterior.

Em **SwiftUI**, você usa `VStack` para organizar os componentes em um
pilar vertical.

```swift
VStack {
  Image(systemName: "globe")
  Text("Olá, mundo!")
}
```

O **Flutter** usa o mesmo código Dart do exemplo anterior, exceto que
troca [`Column`][`Column`] por `Row`:

<?code-excerpt "lib/column.dart (column)" replace="/child: //g;"?>
```dart dartpad="d9a288be0c2a353296fc8825680b84b8"
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(CupertinoIcons.globe),
    Text('Olá, mundo!'),
  ],
),
```

### Exibindo uma list view

Em **SwiftUI**, você usa o componente base `List` para exibir sequências
de itens. Para exibir uma sequência de objetos de modelo, certifique-se
de que o usuário possa identificar seus objetos de modelo. Para tornar
um objeto identificável, use o protocolo `Identifiable`.

```swift
struct Person: Identifiable {
  var name: String
}

var persons = [
  Person(name: "Pessoa 1"),
  Person(name: "Pessoa 2"),
  Person(name: "Pessoa 3"),
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

Isso se assemelha a como o **Flutter** prefere construir seus widgets de
lista. O Flutter não precisa que os itens da lista sejam identificáveis.
Você define o número de itens a serem exibidos e, em seguida, constrói um
widget para cada item.

<?code-excerpt "lib/list.dart (simple-list)"?>
```dart dartpad="67426fd4f9c38c0c1db96b1af65598f2"
class Person {
  String name;
  Person(this.name);
}

final List<Person> items = [
  Person('Pessoa 1'),
  Person('Pessoa 2'),
  Person('Pessoa 3'),
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

O Flutter tem algumas ressalvas para listas:

- O widget [`ListView`] tem um método builder. Isso funciona como o
  `ForEach` dentro da struct `List` do SwiftUI.

- O parâmetro `itemCount` do `ListView` define quantos itens o `ListView`
  exibe.

- O `itemBuilder` tem um parâmetro de índice que estará entre zero e um
  a menos que itemCount.

O exemplo anterior retornou um widget [`ListTile`][`ListTile`] para cada item. O
widget `ListTile` inclui propriedades como `height` e `font-size`. Essas
propriedades ajudam a construir uma lista. No entanto, o Flutter permite
que você retorne quase qualquer widget que represente seus dados.

### Exibindo uma grade

Ao construir grades não condicionais em **SwiftUI**, você usa `Grid` com
`GridRow`.

```swift
Grid {
  GridRow {
    Text("Linha 1")
    Image(systemName: "square.and.arrow.down")
    Image(systemName: "square.and.arrow.up")
  }
  GridRow {
    Text("Linha 2")
    Image(systemName: "square.and.arrow.down")
    Image(systemName: "square.and.arrow.up")
  }
}
```

Para exibir grades no **Flutter**, use o widget [`GridView`]. Este
widget tem vários construtores. Cada construtor tem um objetivo
semelhante, mas usa diferentes parâmetros de entrada. O exemplo a seguir
usa o inicializador `.builder()`:

<?code-excerpt "lib/grid.dart (grid-example)"?>
```dart dartpad="d6b9174f33db94164e457b3da80da933"
const widgets = [
  Text('Linha 1'),
  Icon(CupertinoIcons.arrow_down_square),
  Icon(CupertinoIcons.arrow_up_square),
  Text('Linha 2'),
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

O delegado `SliverGridDelegateWithFixedCrossAxisCount` determina vários
parâmetros que a grade usa para organizar seus componentes. Isso inclui
`crossAxisCount` que dita o número de itens exibidos em cada linha.

Como o `Grid` do SwiftUI e o `GridView` do Flutter diferem é que o
`Grid` requer `GridRow`. `GridView` usa o delegado para decidir como a
grade deve organizar seus componentes.

### Criando uma scroll view

Em **SwiftUI**, você usa `ScrollView` para criar componentes de rolagem
personalizados. O exemplo a seguir exibe uma série de instâncias
`PersonView` de forma rolável.

```swift
ScrollView {
  VStack(alignment: .leading) {
    ForEach(persons) { person in
      PersonView(person: person)
    }
  }
}
```

Para criar uma view de rolagem, o **Flutter** usa
[`SingleChildScrollView`][`SingleChildScrollView`]. No exemplo a seguir, a função `mockPerson`
simula instâncias da classe `Person` para criar o widget `PersonView`
personalizado.

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

Em **SwiftUI**, você usa `GeometryReader` para criar tamanhos de view
relativos.

Por exemplo, você pode:

- Multiplicar `geometry.size.width` por algum fator para definir a
  _largura_.
- Use `GeometryReader` como um ponto de interrupção para alterar o
  design do seu aplicativo.

Você também pode ver se a classe de tamanho tem `.regular` ou
`.compact` usando `horizontalSizeClass`.

Para criar views relativas no **Flutter**, você pode usar uma de duas
opções:

- Obtenha o objeto `BoxConstraints` na classe [`LayoutBuilder`][`LayoutBuilder`].
- Use [`MediaQuery.of()`][`MediaQuery.of()`] em suas funções de build para obter o
  tamanho e a orientação do seu aplicativo atual.

Para saber mais, confira [Criando aplicativos responsivos e adaptativos][Creating responsive and adaptive apps].

### Gerenciando o estado

Em **SwiftUI**, você usa o wrapper de propriedade `@State` para
representar o estado interno de uma view SwiftUI.

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

**SwiftUI** também inclui várias opções para gerenciamento de estado mais
complexo, como o protocolo `ObservableObject`.

O **Flutter** gerencia o estado local usando um [`StatefulWidget`][`StatefulWidget`].
Implemente um widget stateful com as seguintes duas classes:

- uma subclasse de `StatefulWidget`
- uma subclasse de `State`

O objeto `State` armazena o estado do widget. Para alterar o estado de
um widget, chame `setState()` da subclasse `State` para informar ao
framework para redesenhar o widget.

O exemplo a seguir mostra uma parte de um aplicativo de contador:

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

Para saber mais maneiras de gerenciar o estado, confira [Gerenciamento de
estado][State management].

### Animações

Existem dois tipos principais de animações de UI.

- Implícita que anima de um valor atual para um novo alvo.
- Explícita que anima quando solicitado.

#### Animação Implícita

SwiftUI e Flutter adotam uma abordagem semelhante à animação. Em ambos
os frameworks, você especifica parâmetros como `duration` e `curve`.

Em **SwiftUI**, você usa o modificador `animate()` para lidar com a
animação implícita.

```swift
Button("Toque em mim!"){
   angle += 45
}
.rotationEffect(.degrees(angle))
.animation(.easeIn(duration: 1))
```

O **Flutter** inclui widgets para animação implícita. Isso simplifica a
animação de widgets comuns. O Flutter nomeia esses widgets com o
seguinte formato: `AnimatedFoo`.

Por exemplo: para girar um botão, use a classe
[`AnimatedRotation`][`AnimatedRotation`]. Isso anima o widget `Transform.rotate`.

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
      const Text('Toque em mim!')),
),
```

O Flutter permite que você crie animações implícitas personalizadas.
Para compor um novo widget animado, use o
[`TweenAnimationBuilder`][`TweenAnimationBuilder`].

#### Animação Explícita

Para animações explícitas, o **SwiftUI** usa a função `withAnimation()`.

O **Flutter** inclui widgets animados explicitamente com nomes
formatados como `FooTransition`. Um exemplo seria a classe
[`RotationTransition`][`RotationTransition`].

O Flutter também permite que você crie uma animação explícita
personalizada usando `AnimatedWidget` ou `AnimatedBuilder`.

Para saber mais sobre animações no Flutter, consulte
[Visão geral de animações][Animations overview].

### Desenhando na tela

Em **SwiftUI**, você usa `CoreGraphics` para desenhar linhas e formas na
tela.

O **Flutter** tem uma API baseada na classe `Canvas`, com duas classes
que ajudam você a desenhar:

1. [`CustomPaint`][`CustomPaint`] que requer um painter:

    <?code-excerpt "lib/canvas.dart (custom-paint)" replace="/child: //g;"?>
    ```dart dartpad="978d64ee66d54177fb639f8a9f801039"
    CustomPaint(
      painter: SignaturePainter(_points),
      size: Size.infinite,
    ),
    ```

2. [`CustomPainter`][`CustomPainter`] que implementa seu algoritmo para desenhar na
   canvas.

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

Esta seção explica como navegar entre as páginas de um aplicativo, o
mecanismo push e pop e muito mais.

### Navegando entre as páginas

Os desenvolvedores criam aplicativos iOS e macOS com páginas diferentes
chamadas _rotas de navegação_.

Em **SwiftUI**, o `NavigationStack` representa essa pilha de páginas.

O exemplo a seguir cria um aplicativo que exibe uma lista de pessoas.
Para exibir os detalhes de uma pessoa em um novo link de navegação, toque
nessa pessoa.

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

Se você tiver um aplicativo **Flutter** pequeno sem links complexos, use
[`Navigator`][`Navigator`] com rotas nomeadas. Depois de definir suas rotas de
navegação, chame suas rotas de navegação usando seus nomes.

1. Nomeie cada rota na classe passada para a função `runApp()`. O exemplo
   a seguir usa `App`:

    <?code-excerpt "lib/navigation.dart (routes)"?>
    ```dart dartpad="d8b22d4dcbefdc8a2e21f1382cf7dc2a"
    // Define o nome da rota como uma constante
    // para que seja reutilizável.
    const detailsPageRouteName = '/details';
    
    class App extends StatelessWidget {
      const App({
        super.key,
      });
    
      @override
      Widget build(BuildContext context) {
        return CupertinoApp(
          home: const HomePage(),
          // A propriedade [routes] define as rotas nomeadas disponíveis
          // e os widgets a serem construídos ao navegar para essas rotas.
          routes: {
            detailsPageRouteName: (context) => const DetailsPage(),
          },
        );
      }
    }
    ```

   A seguinte amostra gera uma lista de pessoas usando `mockPersons()`.
   Tocar em uma pessoa envia a página de detalhes da pessoa para o
   `Navigator` usando `pushNamed()`.

    <?code-excerpt "lib/navigation.dart (list-view)" replace="/child: //g;"?>
    ```dart dartpad="d8b22d4dcbefdc8a2e21f1382cf7dc2a"
    ListView.builder(
      itemCount: mockPersons.length,
      itemBuilder: (context, index) {
        final person = mockPersons.elementAt(index);
        final age = '${person.age} anos de idade';
        return ListTile(
          title: Text(person.name),
          subtitle: Text(age),
          trailing: const Icon(
            Icons.arrow_forward_ios,
          ),
          onTap: () {
            // Quando um [ListTile] que representa uma pessoa é
            // tocado, envia a rota detailsPageRouteName
            // para o Navigator e passa a instância da pessoa
            // para a rota.
            Navigator.of(context).pushNamed(
              detailsPageRouteName,
              arguments: person,
            );
          },
        );
      },
    ),
    ```

2. Defina o widget `DetailsPage` que exibe os detalhes de cada pessoa.
   No Flutter, você pode passar argumentos para o widget ao navegar
   para a nova rota. Extraia os argumentos usando
   `ModalRoute.of()`:

    <?code-excerpt "lib/navigation.dart (details-page)"?>
    ```dart dartpad="d8b22d4dcbefdc8a2e21f1382cf7dc2a"
    class DetailsPage extends StatelessWidget {
      const DetailsPage({super.key});
    
      @override
      Widget build(BuildContext context) {
        // Leia a instância da pessoa dos argumentos.
        final Person person = ModalRoute.of(
          context,
        )?.settings.arguments as Person;
        // Extraia a idade.
        final age = '${person.age} anos de idade';
        return Scaffold(
          // Exibe o nome e a idade.
          body: Column(children: [Text(person.name), Text(age)]),
        );
      }
    }
    ```

Para criar requisitos de navegação e roteamento mais avançados, use um
pacote de roteamento como [go_router][go_router].

Para saber mais, confira [Navegação e roteamento][Navigation and routing].

### Voltar manualmente

Em **SwiftUI**, você usa o valor do ambiente `dismiss` para voltar para a
tela anterior.

```swift
Button("Voltar") {
        dismiss()
      }
```

No **Flutter**, use a função `pop()` da classe `Navigator`:

<?code-excerpt "lib/popback.dart (pop-back)"?>
```dart dartpad="3c125ab2dfba9f4178aeaeb8619c5bea"
TextButton(
  onPressed: () {
    // Este código permite que a
    // view volte para seu apresentador.
    Navigator.of(context).pop();
  },
  child: const Text('Voltar'),
),
```

### Navegando para outro aplicativo

Em **SwiftUI**, você usa a variável de ambiente `openURL` para abrir
uma URL para outro aplicativo.

```swift
@Environment(\.openURL) private var openUrl

// O código da view vai aqui

 Button("Abrir site") {
      openUrl(
        URL(
          string: "https://google.com"
        )!
      )
    }
```

No **Flutter**, use o plugin [`url_launcher`][`url_launcher`].

<?code-excerpt "lib/openapp.dart (open-app-example)" replace="/child: //g;"?>
```dart dartpad="695beba25fa8120d89c9960cb222e276"
CupertinoButton(
  onPressed: () async {
    await launchUrl(
      Uri.parse('https://google.com'),
    );
  },
  const Text(
    'Abrir site',
  ),
),
```

## Temas, estilos e mídia

Você pode estilizar aplicativos Flutter com pouco esforço. A
estilização inclui alternar entre temas claros e escuros, alterar o design
do seu texto e componentes de UI e muito mais. Esta seção aborda como
estilizar seus aplicativos.

### Usando o modo escuro

Em **SwiftUI**, você chama a função `preferredColorScheme()` em uma
`View` para usar o modo escuro.

No **Flutter**, você pode controlar o modo claro e escuro no nível do
aplicativo. Para controlar o modo de brilho, use a propriedade `theme` da
classe `App`:

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

Em **SwiftUI**, você usa funções modificadoras para estilizar o texto.
Por exemplo, para alterar a fonte de uma string `Text`, use o
modificador `font()`:

```swift
Text("Olá, mundo!")
  .font(.system(size: 30, weight: .heavy))
  .foregroundColor(.yellow)
```

Para estilizar texto no **Flutter**, adicione um widget `TextStyle` como
o valor do parâmetro `style` do widget `Text`.

<?code-excerpt "lib/cupertino_themes.dart (styling-text)" replace="/child: //g;"?>
```dart dartpad="18790cfaa8441085994373a4bc4f46b0"
Text(
  'Olá, mundo!',
  style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: CupertinoColors.systemYellow,
  ),
),
```
### Estilizando botões

Em **SwiftUI**, você usa funções modificadoras para estilizar botões.

```swift
Button("Fazer algo") {
    // fazer algo quando o botão for tocado
  }
  .font(.system(size: 30, weight: .bold))
  .background(Color.yellow)
  .foregroundColor(Color.blue)
}
```

Para estilizar widgets de botão no **Flutter**, defina o estilo de seu filho ou modifique as propriedades no próprio botão.

No exemplo a seguir:

- A propriedade `color` de `CupertinoButton` define sua `color`.
- A propriedade `color` do widget filho `Text` define a cor do texto do botão.

<?code-excerpt "lib/stylingbutton.dart (styling-button)"?>
```dart dartpad="f8b6622f526fc5c7d5adadf1e071c28f"
child: CupertinoButton(
  color: CupertinoColors.systemYellow,
  onPressed: () {},
  padding: const EdgeInsets.all(16),
  child: const Text(
    'Fazer algo',
    style: TextStyle(
      color: CupertinoColors.systemBlue,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
  ),
),
```

### Usando fontes customizadas

Em **SwiftUI**, você pode usar uma fonte customizada em seu aplicativo em duas etapas. Primeiro, adicione o arquivo de fonte ao seu projeto SwiftUI. Após adicionar o arquivo, use o modificador `.font()` para aplicá-lo aos seus componentes de UI.

```swift
Text("Olá")
  .font(
    Font.custom(
      "BungeeSpice-Regular",
      size: 40
    )
  )
```

Em **Flutter**, você controla seus recursos com um arquivo
chamado `pubspec.yaml`. Este arquivo é independente de plataforma.
Para adicionar uma fonte customizada ao seu projeto, siga estas etapas:

1. Crie uma pasta chamada `fonts` no diretório raiz do projeto.
   Esta etapa opcional ajuda a organizar suas fontes.
1. Adicione seu arquivo de fonte `.ttf`, `.otf` ou `.ttc` na pasta `fonts`.
1. Abra o arquivo `pubspec.yaml` dentro do projeto.
1. Encontre a seção `flutter`.
1. Adicione sua(s) fonte(s) customizada(s) sob a seção `fonts`.

    ```yaml
    flutter:
      fonts:
        - family: BungeeSpice
          fonts:
            - asset: fonts/BungeeSpice-Regular.ttf
    ```

Depois de adicionar a fonte ao seu projeto, você pode usá-la como no exemplo a seguir:

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
Para baixar fontes customizadas para usar em seus aplicativos,
confira o [Google Fonts](https://fonts.google.com).
:::

### Agrupando imagens em aplicativos

Em **SwiftUI**, você primeiro adiciona os arquivos de imagem ao `Assets.xcassets` e, em seguida, usa a view `Image` para exibir as imagens.

Para adicionar imagens no **Flutter**, siga um método semelhante a como você adicionou fontes customizadas.

1. Adicione uma pasta `images` ao diretório raiz.
1. Adicione este recurso ao arquivo `pubspec.yaml`.

    ```yaml
    flutter:
      assets:
        - images/Blueberries.jpg
    ```

Depois de adicionar sua imagem, exiba-a usando o construtor `.asset()` do widget `Image`. Este construtor:

1. Instancia a imagem fornecida usando o caminho fornecido.
1. Lê a imagem dos recursos agrupados com seu aplicativo.
1. Exibe a imagem na tela.

Para revisar um exemplo completo, confira a documentação do [`Image`][`Image`].

### Agrupando vídeos em aplicativos

Em **SwiftUI**, você agrupa um arquivo de vídeo local com seu aplicativo em duas etapas.
Primeiro, você importa o framework `AVKit` e, em seguida, instancia uma view `VideoPlayer`.

Em **Flutter**, adicione o plugin [video_player][video_player] ao seu projeto.
Este plugin permite que você crie um reprodutor de vídeo que funciona no Android, iOS e na web a partir da mesma base de código.

1. Adicione o plugin ao seu aplicativo e adicione o arquivo de vídeo ao seu projeto.
1. Adicione o recurso ao seu arquivo `pubspec.yaml`.
1. Use a classe `VideoPlayerController` para carregar e reproduzir seu arquivo de vídeo.

Para revisar um passo a passo completo, confira o [exemplo do video_player][video_player example].

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
