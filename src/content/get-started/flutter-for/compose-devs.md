---
title: Flutter para desenvolvedores Jetpack Compose
description: Aprenda como aplicar conhecimentos de desenvolvimento Jetpack Compose ao criar aplicativos Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/compose_devs"?>

:::note
Se você tem experiência construindo aplicativos Android com Views (XML),
confira [Flutter para desenvolvedores Android][].
:::

Flutter é um framework para construir aplicativos multiplataforma
que usa a linguagem de programação Dart.

Seu conhecimento e experiência em Jetpack Compose
são altamente valiosos ao construir com Flutter.

:::tip
Para integrar código Flutter em um aplicativo Android **existente**,
confira [Adicionar Flutter a um aplicativo existente][].
:::

Este documento pode ser usado como referência pulando entre seções
e encontrando questões que sejam mais relevantes para suas necessidades.
Este guia incorpora código de exemplo.
Usando o botão "Abrir no DartPad" que aparece ao passar o mouse ou focar,
você pode abrir e executar alguns dos exemplos no DartPad.

## Visão Geral

O código Flutter e Jetpack Compose descreve como a UI parece e funciona.
Desenvolvedores chamam este tipo de código de _framework declarativo_.

Embora existam diferenças importantes, especialmente quando se trata de
interagir com código Android legado, há muitas semelhanças
entre os dois frameworks.

### Composables vs. Widgets

**Jetpack Compose** representa componentes de UI como _funções composable_,
posteriormente notadas neste documento como _composables_. Composables podem ser
alterados ou decorados através do uso de objetos _Modifier_.

``` kotlin
Text("Hello, World!",
   modifier: Modifier.padding(10.dp)
)
Text("Hello, World!",
    modifier = Modifier.padding(10.dp))
```

**Flutter** representa componentes de UI como _widgets_.

Tanto composables quanto widgets existem apenas até precisarem mudar.
Essas linguagens chamam essa propriedade de _imutabilidade_.
Jetpack Compose modifica propriedades de componentes de UI usando uma
propriedade _modifier_ opcional apoiada por um objeto `Modifier`.
Em contraste, Flutter usa widgets tanto para componentes de UI quanto
suas propriedades.

```dart
Padding(                         // <-- Este é um Widget
  padding: EdgeInsets.all(10.0), // <-- Este também
  child: Text("Hello, World!"),  // <-- Este também
)));
```

Para compor layouts, tanto Jetpack Compose quanto Flutter aninham componentes de UI
dentro uns dos outros.
Jetpack Compose aninha `Composables` enquanto Flutter aninha `Widgets`.

### Processo de layout

Jetpack Compose e Flutter lidam com layout de maneiras semelhantes. Ambos
fazem o layout da UI em uma única passagem e elementos pai fornecem restrições de layout
para seus filhos. Mais especificamente,

1. O pai mede a si mesmo e seus filhos recursivamente fornecendo
   quaisquer restrições do pai para o filho.
2. Os filhos tentam dimensionar a si mesmos usando os métodos acima e
fornecem a seus próprios filhos tanto suas restrições quanto quaisquer que
possam se aplicar de seus nós ancestrais.
3. Ao encontrar um nó folha (um nó sem filhos), o tamanho
e propriedades são determinados com base nas restrições fornecidas
e o elemento é colocado na UI.
4. Com todos os filhos dimensionados e posicionados, os nós raiz podem
determinar sua medição, tamanho e posicionamento.

Tanto no Jetpack Compose quanto no Flutter, o componente pai pode sobrescrever
ou restringir o tamanho desejado do filho. O widget não pode ter qualquer tamanho que quiser.
Ele também não pode _geralmente_ saber ou decidir sua posição na tela já que seu pai
toma essa decisão.

Para forçar um widget filho a renderizar em um tamanho específico,
o pai deve definir restrições rígidas.
Uma restrição se torna rígida quando o valor de tamanho mínimo de sua restrição
é igual ao seu valor de tamanho máximo.

Para aprender como as restrições funcionam no Flutter,
visite [Entendendo restrições][].

### Sistema de design

Como o Flutter visa várias plataformas, seu aplicativo não precisa
se conformar a nenhum sistema de design.
Embora este guia apresente widgets [Material][],
seu aplicativo Flutter pode usar muitos sistemas de design diferentes:

- Widgets Material personalizados
- Widgets construídos pela comunidade
- Seus próprios widgets personalizados

Se você está procurando um ótimo aplicativo de referência que apresenta um
sistema de design personalizado, confira [Wonderous][].

## Básico da UI

Esta seção cobre o básico do desenvolvimento de UI no
Flutter e como ele se compara ao Jetpack Compose.
Isso inclui como começar a desenvolver seu aplicativo, exibir texto estático,
criar botões, reagir a eventos on-press, exibir listas, grades e muito mais.

### Começando

Para aplicativos **Compose**, seu ponto de entrada principal será
_Activity_ ou um de seus descendentes,
geralmente _ComponentActivity_.

```kotlin
class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            SampleTheme {
                Scaffold(modifier = Modifier.fillMaxSize()) { innerPadding ->
                    Greeting(
                        name = "Android",
                        modifier = Modifier.padding(innerPadding)
                    )
                }
            }
        }
    }
}

@Composable
fun Greeting(name: String, modifier: Modifier = Modifier) {
    Text(
        text = "Hello $name!",
        modifier = modifier
    )
}
```

Para iniciar seu aplicativo **Flutter**, passe uma instância do seu aplicativo para
a função `runApp`.

```dart
void main() {
  runApp(const MyApp());
}
```

`App` é um widget. Seu método `build` descreve a parte da
interface do usuário que ele representa.
É comum começar seu aplicativo com uma classe [`WidgetApp`][],
como [`MaterialApp`][].

```dart
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
```

O widget usado em `HomePage` pode começar com a classe `Scaffold`.
`Scaffold` implementa uma estrutura de layout básica para um aplicativo.

```dart
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

Compose tem uma série de padrões de suas Views Android ancestrais.
A menos que especificado de outra forma, a maioria dos componentes "envolvem" seu tamanho ao
conteúdo, o que significa que eles só ocupam o espaço necessário quando renderizados.
Nem sempre é o caso com Flutter.

Para centralizar o texto, envolva-o em um widget `Center`.
Para aprender sobre diferentes widgets e seus comportamentos padrão, confira
o [Catálogo de widgets][].

### Adicionando Botões

No **Compose**, você usa o composable `Button` ou uma de suas variantes
para criar um botão. `Button` é um alias para `FilledTonalButton`
quando usando um tema Material.

```kotlin
Button(onClick = {}) {
    Text("Do something")
}
```

Para alcançar o mesmo resultado no **Flutter**,
use a classe `FilledButton`:

```dart
FilledButton(
  onPressed: () {
    // Este closure é chamado quando seu botão é tocado.
  },
  const Text('Do something'),
),
```

**Flutter** fornece acesso a uma variedade de botões com estilos predefinidos.


### Alinhando componentes horizontalmente ou verticalmente
Jetpack Compose e Flutter lidam com coleções horizontais e verticais de
itens de forma semelhante.

O seguinte snippet Compose adiciona uma imagem de globo e
texto em containers `Row` e `Column` com centralização dos itens:

```kotlin
Row(horizontalArrangement = Arrangement.Center) {
   Image(Icons.Default.Public, contentDescription = "")
   Text("Hello, world!")
}

Column(verticalArrangement = Arrangement.Center) {
   Image(Icons.Default.Public, contentDescription = "")
   Text("Hello, world!")
}
```

**Flutter** usa [`Row`][] e [`Column`][] também, mas há algumas pequenas diferenças para especificar
widgets filhos e alinhamento. O seguinte é equivalente ao exemplo Compose.

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.public),
    Text('Hello, world!'),
  ],
),

Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(MaterialIcons.globe),
    Text('Hello, world!'),
  ],
)

```

`Row` e `Column` requerem uma `List<Widget>` no parâmetro `children`.
A propriedade `mainAxisAlignment` diz ao Flutter como posicionar os filhos
com espaço extra. `MainAxisAlignment.center` posiciona os filhos no
centro do eixo principal. Para `Row`, o eixo principal é o horizontal
axis, inversamente para `Column`, o eixo principal é o eixo vertical.

::: note
Enquanto `Row` e `Column` do Flutter têm `MainAxisAlignment`
e `CrossAxisAlignment` para controlar como os itens são posicionados, as propriedades que
controlam o posicionamento no Jetpack Compose são uma propriedade vertical e horizontal
das seguintes: `verticalArrangement`, `verticalAlignment`,
`horizontalAlignment` e `horizontalArrangement`. O truque para determinar
qual é o `MainAxis` é procurar pela propriedade que termina em `arrangement`.
O `CrossAxis` será a propriedade que termina em `alignment`.
:::

### Exibindo um list view

No **Compose**, você tem algumas maneiras de criar uma lista baseada no
tamanho da lista que você precisa exibir. Para um pequeno número de itens
que podem todos ser exibidos de uma vez, você pode iterar sobre uma coleção
dentro de uma `Column` ou `Row`.

Para uma lista com um grande número de itens, `LazyList` tem melhor
desempenho. Ela só faz o layout dos componentes que serão visíveis
versus todos eles.

```kotlin
data class Person(val name: String)

val people = arrayOf(
   Person(name = "Person 1"),
   Person(name = "Person 2"),
   Person(name = "Person 3")
)

@Composable
fun ListDemo(people: List<Person>) {
   Column {
      people.forEach {
         Text(it.name)
      }
   }
}

@Composable
fun ListDemo2(people: List<Person>) {
   LazyColumn {
      items(people) { person ->
         Text(person.name)
      }
   }
}
```

Para construir preguiçosamente uma lista no Flutter, ....

```dart
class Person {
  String name;
  Person(this.name);
}

var items = [
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

Flutter tem algumas convenções para listas:

- O widget [`ListView`] tem um método builder.
  Isso funciona como o closure `item` dentro de um Compose `LazyList`.

- O parâmetro `itemCount` do `ListView` define quantos itens
  o `ListView` exibe.

- O `itemBuilder` tem um parâmetro index que será entre zero
  e um a menos que itemCount.

O exemplo anterior retornou um widget [`ListTile`][] para cada item.
O `ListTile` possui propriedades como `height` e `font-size`.
Essas propriedades ajudam a construir uma lista. No entanto, o Flutter permite que você retorne
quase qualquer widget que represente seus dados.

### Exibindo uma grade

Construir uma grade no **Compose** é semelhante a uma
LazyList (`LazyColumn` ou `LazyRow`). Você pode usar o
mesmo closure `items`. Há propriedades em cada
tipo de grade para especificar como organizar os itens,
se usar layout adaptativo ou fixo,
entre outros.


```kotlin
val widgets = arrayOf(
        "Row 1",
        Icons.Filled.ArrowDownward,
        Icons.Filled.ArrowUpward,
        "Row 2",
        Icons.Filled.ArrowDownward,
        Icons.Filled.ArrowUpward
    )

    LazyVerticalGrid (
        columns = GridCells.Fixed(3),
        contentPadding = PaddingValues(8.dp)
    ) {
        items(widgets) { i ->
            if (i is String) {
                Text(i)
            } else {
                Image(i as ImageVector, "")
            }
        }
    }
```

Para exibir grades no **Flutter**, use o widget [`GridView`].
Este widget possui vários construtores. Cada construtor tem
um objetivo semelhante, mas usa parâmetros de entrada diferentes.
O exemplo a seguir usa o inicializador `.builder()`:

```dart
const widgets = [
  Text('Row 1'),
  Icon(Icons.arrow_downward),
  Icon(Icons.arrow_upward),
  Text('Row 2'),
  Icon(Icons.arrow_downward),
  Icon(Icons.arrow_upward),
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
vários parâmetros que a grade usa para fazer o layout de seus componentes.
Isso inclui `crossAxisCount` que determina o número de itens
exibidos em cada linha.

`LazyHorizontalGrid`, `LazyVerticalGrid` do Jetpack Compose e `GridView` do Flutter são de certa forma
semelhantes. `GridView` usa um delegate para decidir como a grade
deve fazer o layout de seus componentes. As propriedades `rows`, `columns` e outras
associadas em `LazyHorizontalGrid` \ `LazyVerticalGrid` servem o mesmo propósito.

### Criando uma scroll view

`LazyColumn` e `LazyRow` no **Jetpack Compose** têm suporte
integrado para rolagem.

Para criar uma view com rolagem, **Flutter** usa [`SingleChildScrollView`][].
No exemplo a seguir, a função `mockPerson` simula instâncias
da classe `Person` para criar o widget personalizado `PersonView`.

```dart
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

Design Adaptativo no **Compose** é um tópico complexo com muitas
soluções viáveis:
* Usando um layout personalizado
* Usando `WindowSizeClass` sozinho
* Usando `BoxWithConstraints` para controlar o que é exibido com base no
espaço disponível
* Usando a biblioteca adaptativa Material 3 que usa `WindowSizeClass`
junto com layouts composable especializados para layouts comuns

Por esse motivo, você é encorajado a examinar as opções do **Flutter**
diretamente e ver o que se adequa aos seus requisitos versus
tentar encontrar algo que seja uma tradução um para um.

Para criar views relativas no **Flutter**, você pode usar uma das duas opções:

- Obter o objeto `BoxConstraints` na classe [`LayoutBuilder`][].
- Usar o [`MediaQuery.of()`][] em suas funções build
  para obter o tamanho e a orientação do seu aplicativo atual.

Para saber mais, confira [Criando aplicativos responsivos e adaptativos][].

### Gerenciando estado

**Compose** armazena estado com a API `remember` e descendentes
da interface `MutableState`.

```kotlin
Scaffold(
   content = { padding ->
      var _counter = remember {  mutableIntStateOf(0) }
      Column(horizontalAlignment = Alignment.CenterHorizontally,
         verticalArrangement = Arrangement.Center,
         modifier = Modifier.fillMaxSize().padding(padding)) {
            Text(_counter.value.toString())
            Spacer(modifier = Modifier.height(16.dp))
            FilledIconButton (onClick = { -> _counter.intValue += 1 }) {
               Text("+")
            }
      }
   }
)
```


**Flutter** gerencia estado local usando um [`StatefulWidget`][].
Implemente um widget stateful com as duas classes a seguir:

- uma subclasse de `StatefulWidget`
- uma subclasse de `State`

O objeto `State` armazena o estado do widget.
Para alterar o estado de um widget, chame `setState()` da subclasse `State`
para dizer ao framework para redesenhar o widget.

O exemplo a seguir mostra parte de um aplicativo contador:

```dart
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

Para aprender mais maneiras de gerenciar estado, confira [Gerenciamento de estado][].


### Desenhando na tela

No **Compose**, você usa o composable `Canvas` para desenhar
formas, imagens e texto na tela.

**Flutter** possui uma API baseada na classe `Canvas`,
com duas classes que ajudam você a desenhar:

1. [`CustomPaint`][] que requer um painter:

    ```dart
    CustomPaint(
      painter: SignaturePainter(_points),
      size: Size.infinite,
    ),
    ```

2. [`CustomPainter`][] que implementa seu algoritmo para desenhar no canvas.

    ```dart
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

## Temas, estilos e mídia

Você pode estilizar aplicativos Flutter com pouco esforço.
A estilização inclui alternar entre temas claro e escuro,
mudar o design de seu texto e componentes de UI,
e muito mais. Esta seção cobre como estilizar seus aplicativos.

### Usando modo escuro

No **Compose**, você pode controlar claro e escuro em qualquer
nível arbitrário envolvendo um componente com
um composable `Theme`.

No **Flutter**, você pode controlar o modo claro e escuro no nível do aplicativo.
Para controlar o modo de brilho, use a propriedade `theme`
da classe `App`:

```dart
const MaterialApp(
  theme: ThemeData(
    brightness: Brightness.dark,
  ),
  home: HomePage(),
);
```

### Estilizando texto

No **Compose**, você usa as propriedades em `Text` para um ou dois
atributos ou constrói um objeto `TextStyle` para definir muitos de uma vez.

```kotlin
Text("Hello, world!", color = Color.Green,
        fontWeight = FontWeight.Bold, fontSize = 30.sp)
```
```kotlin
Text("Hello, world!",
   style = TextStyle(
      color = Color.Green,
      fontSize = 30.sp,
      fontWeight = FontWeight.Bold
   ),
)
```

Para estilizar texto no **Flutter**, adicione um widget `TextStyle` como o valor
do parâmetro `style` do widget `Text`.

```dart
Text(
  'Hello, world!',
  style: TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
  ),
),
```

### Estilizando botões

No **Compose**, você modifica as cores de um botão usando
a propriedade `colors`. Se deixado sem modificação, eles
usam os padrões do tema atual.

```kotlin
Button(onClick = {},
   colors = ButtonDefaults.buttonColors().copy(
      containerColor = Color.Yellow, contentColor = Color.Blue,
       )) {
    Text("Do something", fontSize = 30.sp, fontWeight = FontWeight.Bold)
}
```

Para estilizar widgets de botão no **Flutter**, você similarmente
define o estilo de seu filho, ou modifica propriedades no próprio botão.

```dart
FilledButton(
  onPressed: (){},
  style: FilledButton.styleFrom(backgroundColor: Colors.amberAccent),
  child: const Text(
    'Do something',
    style: TextStyle(
      color: Colors.blue,
      fontSize: 30,
      fontWeight: FontWeight.bold,
    )
  )
)
```
## Empacotando assets para uso no Flutter

Comumente há a necessidade de empacotar recursos para uso em seu aplicativo.
Eles podem ser animações, gráficos vetoriais, imagens, fontes ou outros arquivos gerais.

Ao contrário de aplicativos Android nativos que esperam uma estrutura de diretório definida sob `/res/<qualifier>/`
onde o qualificador pode indicar o tipo de arquivo, uma orientação específica,
ou versão do android, o Flutter não requer um local específico desde que
os arquivos referenciados estejam listados no arquivo `pubspec.yaml`. Abaixo está um trecho
de um `pubspec.yaml` referenciando várias imagens e um arquivo de fonte.

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
  fonts:
    - family: FiraSans
      fonts:
        - asset: fonts/FiraSans-Regular.ttf
```

### Usando fontes

No **Compose**, você tem duas opções para usar fontes em seu aplicativo.
Você pode usar um serviço de runtime para recuperá-las [Google Fonts][].
Alternativamente, elas podem ser empacotadas em arquivos de recursos.

**Flutter** possui métodos semelhantes para usar fontes, vamos discuti-los ambos inline.

### Usando fontes empacotadas

Os seguintes são aproximadamente código Compose e Flutter equivalente para usar um arquivo de fonte no diretório `/res/` ou `fonts`
conforme listado acima.

```kotlin
// Arquivos de fonte empacotados com app
val firaSansFamily = FontFamily(
   Font(R.font.firasans_regular, FontWeight.Normal),
   // ...
)

// Uso
Text(text = "Compose", fontFamily = firaSansFamily, fontWeight = FontWeight.Normal)
```

```dart
Text(
  'Flutter',
  style: TextStyle(
    fontSize: 40,
    fontFamily: 'FiraSans',
  ),
),
```

### Usando um provedor de fontes (Google Fonts)

Um ponto de diferença é usar fontes de um provedor de fontes como Google Fonts. No **Compose**,
a instanciação é feita inline com aproximadamente o mesmo código para referenciar um arquivo local.

Após instanciar um provedor que referencia as strings especiais para o serviço de fontes,
você usaria a mesma declaração `FontFamily`.

```kotlin
// Arquivos de fonte empacotados com app
val provider = GoogleFont.Provider(
    providerAuthority = "com.google.android.gms.fonts",
    providerPackage = "com.google.android.gms",
    certificates = R.array.com_google_android_gms_fonts_certs
)

val firaSansFamily = FontFamily(
    Font(
        googleFont = GoogleFont("FiraSans"),
        fontProvider = provider,
    )
)

// Uso
Text(text = "Compose", fontFamily = firaSansFamily, fontWeight = FontWeight.Light)
```

Para Flutter, isso é fornecido pelo plugin [google_fonts][] usando o nome da
fonte.

```dart
import 'package:google_fonts/google_fonts.dart';
//...
Text(
  'Flutter',
  style: GoogleFonts.firaSans(),
  // ou
  //style: GoogleFonts.getFont('FiraSans')
),
```

### Usando imagens

No **Compose**, tipicamente arquivos de imagem vão para o diretório drawable
em resources `/res/drawable` e usa-se o composable `Image` para exibir
as imagens. Assets são referenciados usando o localizador de recursos
no estilo de `R.drawable.<nome do arquivo>` sem a extensão do arquivo.

No **Flutter**, a localização do recurso é listada em `pubspec.yaml` como mostrado no snippet abaixo.

```yaml
    flutter:
      assets:
        - images/Blueberries.jpg
   ```

Após adicionar sua imagem, você pode exibi-la usando o construtor `.asset()` do widget `Image`. Este construtor:

Para revisar um exemplo completo, confira a documentação do [`Image`][].


[Flutter para desenvolvedores Android]: /get-started/flutter-for/android-devs
[Adicionar Flutter a um aplicativo existente]: /add-to-app
[Material]: {{site.material}}/develop/flutter/
[Platform adaptations]: /platform-integration/platform-adaptations
[Catálogo de widgets]: /ui/widgets/layout
[Entendendo restrições]: /ui/layout/constraints
[`WidgetApp`]: {{site.api}}/flutter/widgets/WidgetsApp-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
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
[Gerenciamento de estado]:  /data-and-backend/state-mgmt
[Wonderous]: https://flutter.gskinner.com/wonderous/?utm_source=flutterdocs&utm_medium=docs
[video_player]: {{site.pub-pkg}}/video_player
[video_player example]: {{site.pub-pkg}}/video_player/example
[Criando aplicativos responsivos e adaptativos]: /ui/adaptive-responsive
[`MediaQuery.of()`]: {{site.api}}/flutter/widgets/MediaQuery-class.html
[`CustomPaint`]: {{site.api}}/flutter/widgets/CustomPaint-class.html
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[go_router]: {{site.pub-pkg}}/go_router
[Google Fonts]: https://fonts.google.com/
[google_fonts]: https://pub.dev/packages/google_fonts
[`MaterialApp`]: https://api.flutterbrasil.dev/flutter/material/MaterialApp-class.html
