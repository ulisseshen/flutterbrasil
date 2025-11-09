---
ia-translate: true
title: Flutter para desenvolvedores React Native
description: Aprenda como aplicar o conhecimento de desenvolvedor React Native ao construir apps Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/react_native_devs"?>

Este documento é para desenvolvedores React Native (RN) que buscam aplicar seu
conhecimento existente de RN para construir apps mobile com Flutter. Se você entende
os fundamentos do framework RN, então pode usar este documento como uma
forma de começar a aprender desenvolvimento Flutter.

Este documento pode ser usado como um guia de receitas, navegando e encontrando
questões que são mais relevantes para suas necessidades.

## Introdução ao Dart para Desenvolvedores JavaScript (ES6)

Assim como React Native, Flutter usa views no estilo reativo. No entanto, enquanto RN
transpila para widgets nativos, Flutter compila completamente para código nativo.
Flutter controla cada pixel na tela, o que evita problemas de performance
causados pela necessidade de uma ponte JavaScript.

Dart é uma linguagem fácil de aprender e oferece os seguintes recursos:

* Fornece uma linguagem de programação open-source e escalável para construir apps web,
  de servidor e mobile.
* Fornece uma linguagem orientada a objetos, com herança única, que usa uma sintaxe estilo C
  que é compilada AOT para código nativo.
* Transcompila opcionalmente para JavaScript.
* Suporta interfaces e classes abstratas.

Alguns exemplos das diferenças entre JavaScript e Dart são descritos
abaixo.

### Ponto de entrada

JavaScript não tem uma função de entrada
pré-definida&mdash;você define o ponto de entrada.

```js
// JavaScript
function startHere() {
  // Can be used as entry point
}
```

No Dart, toda app deve ter uma função `main()` de nível superior que serve como o
ponto de entrada para a app.

<?code-excerpt "lib/main.dart (main)"?>
```dart
/// Dart
void main() {}
```

Experimente no [DartPad][DartPadA].

### Imprimindo no console

Para imprimir no console em Dart, use `print()`.

```js
// JavaScript
console.log('Hello world!');
```

<?code-excerpt "lib/main.dart (print)"?>
```dart
/// Dart
print('Hello world!');
```

Experimente no [DartPad][DartPadB].

### Variáveis

Dart é type safe&mdash;usa uma combinação de verificação de tipo estática
e verificações em tempo de execução para garantir que o valor de uma variável sempre corresponda
ao tipo estático da variável. Embora os tipos sejam obrigatórios,
algumas anotações de tipo são opcionais porque
Dart realiza inferência de tipo.

#### Criando e atribuindo variáveis

Em JavaScript, variáveis não podem ser tipadas.

No [Dart][], variáveis devem ser explicitamente
tipadas ou o sistema de tipos deve inferir o tipo apropriado automaticamente.

```js
// JavaScript
let name = 'JavaScript';
```

<?code-excerpt "lib/main.dart (variables)"?>
```dart
/// Dart
/// Both variables are acceptable.
String name = 'dart'; // Explicitly typed as a [String].
var otherName = 'Dart'; // Inferred [String] type.
```

Experimente no [DartPad][DartPadC].

Para mais informações, veja [Dart's Type System][].

#### Valor padrão

Em JavaScript, variáveis não inicializadas são `undefined`.

No Dart, variáveis não inicializadas têm um valor inicial de `null`.
Como números são objetos em Dart, até mesmo variáveis não inicializadas com
tipos numéricos têm o valor `null`.

:::note
A partir da versão 2.12, Dart suporta [Sound Null Safety][],
todos os tipos subjacentes são não-anuláveis por padrão,
que devem ser inicializados como um valor não-anulável.
:::

```js
// JavaScript
let name; // == undefined
```

<?code-excerpt "lib/main.dart (null)"?>
```dart
// Dart
var name; // == null; raises a linter warning
int? x; // == null
```

Experimente no [DartPad][DartPadD].

Para mais informações, veja a documentação sobre
[variáveis][variables].

### Verificando null ou zero

Em JavaScript, valores de 1 ou qualquer objeto não-nulo
são tratados como `true` ao usar o operador de comparação `==`.

```js
// JavaScript
let myNull = null;
if (!myNull) {
  console.log('null is treated as false');
}
let zero = 0;
if (!zero) {
  console.log('0 is treated as false');
}
```

No Dart, apenas o valor booleano `true` é tratado como verdadeiro.

<?code-excerpt "lib/main.dart (true)"?>
```dart
/// Dart
var myNull = potentiallyNull();
if (myNull == null) {
  print('use "== null" to check null');
}
var zero = 0;
if (zero == 0) {
  print('use "== 0" to check zero');
}
```

Experimente no [DartPad][DartPadE].

### Funções

Funções Dart e JavaScript são geralmente similares.
A diferença principal é a declaração.

```js
// JavaScript
function fn() {
  return true;
}
```

<?code-excerpt "lib/main.dart (function)"?>
```dart
/// Dart
/// You can explicitly define the return type.
bool fn() {
  return true;
}
```

Experimente no [DartPad][DartPadF].

Para mais informações, veja a documentação sobre
[funções][functions].

### Programação assíncrona

#### Futures

Assim como JavaScript, Dart suporta execução single-threaded. Em JavaScript,
o objeto Promise representa a eventual conclusão (ou falha)
de uma operação assíncrona e seu valor resultante.

Dart usa objetos [`Future`][] para lidar com isso.

```js
// JavaScript
class Example {
  _getIPAddress() {
    const url = 'https://httpbin.org/ip';
    return fetch(url)
      .then(response => response.json())
      .then(responseJson => {
        const ip = responseJson.origin;
        return ip;
      });
  }
}

function main() {
  const example = new Example();
  example
    ._getIPAddress()
    .then(ip => console.log(ip))
    .catch(error => console.error(error));
}

main();
```

<?code-excerpt "lib/futures.dart"?>
```dart
// Dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class Example {
  Future<String> _getIPAddress() {
    final url = Uri.https('httpbin.org', '/ip');
    return http.get(url).then((response) {
      final ip = jsonDecode(response.body)['origin'] as String;
      return ip;
    });
  }
}

void main() {
  final example = Example();
  example
      ._getIPAddress()
      .then((ip) => print(ip))
      .catchError((error) => print(error));
}
```

Para mais informações, veja a documentação sobre
objetos [`Future`][].

#### `async` e `await`

A declaração de função `async` define uma função assíncrona.

Em JavaScript, a função `async` retorna uma `Promise`.
O operador `await` é usado para aguardar uma `Promise`.

```js
// JavaScript
class Example {
  async function _getIPAddress() {
    const url = 'https://httpbin.org/ip';
    const response = await fetch(url);
    const json = await response.json();
    const data = json.origin;
    return data;
  }
}

async function main() {
  const example = new Example();
  try {
    const ip = await example._getIPAddress();
    console.log(ip);
  } catch (error) {
    console.error(error);
  }
}

main();
```

No Dart, uma função `async` retorna um `Future`,
e o corpo da função é agendado para execução posterior.
O operador `await` é usado para aguardar um `Future`.

<?code-excerpt "lib/async.dart"?>
```dart
// Dart
import 'dart:convert';

import 'package:http/http.dart' as http;

class Example {
  Future<String> _getIPAddress() async {
    final url = Uri.https('httpbin.org', '/ip');
    final response = await http.get(url);
    final ip = jsonDecode(response.body)['origin'] as String;
    return ip;
  }
}

/// An async function returns a `Future`.
/// It can also return `void`, unless you use
/// the `avoid_void_async` lint. In that case,
/// return `Future<void>`.
void main() async {
  final example = Example();
  try {
    final ip = await example._getIPAddress();
    print(ip);
  } catch (error) {
    print(error);
  }
}
```

Para mais informações, veja a documentação para [async and await][].

## O básico

### Como criar uma app Flutter?

Para criar uma app usando React Native,
você executaria `create-react-native-app` na linha de comando.

```console
$ create-react-native-app <projectname>
```

Para criar uma app no Flutter, faça uma das seguintes opções:

* Use uma IDE com os plugins Flutter e Dart instalados.
* Use o comando `flutter create` na linha de comando. Certifique-se de que o
  Flutter SDK esteja no seu PATH.

```console
$ flutter create <projectname>
```

Para mais informações, veja [Getting started][], que
guia você através da criação de uma app contador de cliques de botão.
Criar um projeto Flutter cria todos os arquivos necessários para executar uma app de exemplo em dispositivos Android e iOS.

### Como executar minha app?

No React Native, você executaria `npm run` ou `yarn run` do diretório do projeto.

Você pode executar apps Flutter de algumas maneiras:

* Use a opção "run" em uma IDE com os plugins Flutter e Dart.
* Use `flutter run` do diretório raiz do projeto.

Sua app é executada em um dispositivo conectado, no iOS simulator,
ou no Android emulator.

Para mais informações, veja a documentação [Getting started][] do Flutter.

### Como importar widgets?

No React Native, você precisa importar cada componente necessário.

```js
// React Native
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
```

No Flutter, para usar widgets da biblioteca Material Design,
importe o pacote `material.dart`. Para usar widgets estilo iOS,
importe a biblioteca Cupertino. Para usar um conjunto de widgets mais básico,
importe a biblioteca Widgets.
Ou, você pode escrever sua própria biblioteca de widgets e importá-la.

<?code-excerpt "lib/imports.dart (imports)"?>
```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:my_widgets/my_widgets.dart';
```

Qualquer pacote de widget que você importar,
Dart extrai apenas os widgets que são usados na sua app.

Para mais informações, veja o [Flutter Widget Catalog][].

### Qual é o equivalente da app React Native "Hello world!" no Flutter?

No React Native, a classe `HelloWorldApp` estende `React.Component` e
implementa o método render retornando um componente view.

```js
// React Native
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const App = () => {
  return (
    <View style={styles.container}>
      <Text>Hello world!</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center'
  }
});

export default App;
```

No Flutter, você pode criar uma app "Hello world!" idêntica usando os
widgets `Center` e `Text` da biblioteca de widgets core.
O widget `Center` se torna a raiz da árvore de widgets e tem um filho,
o widget `Text`.

<?code-excerpt "lib/hello_world.dart"?>
```dart
// Flutter
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text('Hello, world!', textDirection: TextDirection.ltr),
    ),
  );
}
```

As seguintes imagens mostram a UI Android e iOS para a app Flutter
"Hello world!" básica.

{% render "docs/android-ios-figure-pair.md", image: "react-native/hello-world-basic.png", alt: "Hello world app", class: "border" %}

Agora que você viu a app Flutter mais básica, a próxima seção mostra como
aproveitar as ricas bibliotecas de widgets do Flutter para criar uma app moderna e polida.

### Como usar widgets e aninhá-los para formar uma árvore de widgets?

No Flutter, quase tudo é um widget.

Widgets são os blocos de construção básicos da interface de usuário de uma app.
Você compõe widgets em uma hierarquia, chamada de árvore de widgets.
Cada widget aninha dentro de um widget pai
e herda propriedades de seu pai.
Até mesmo o objeto da aplicação em si é um widget.
Não há um objeto "application" separado.
Em vez disso, o widget raiz serve esse papel.

Um widget pode definir:

* Um elemento estrutural—como um botão ou menu
* Um elemento estilístico—como uma fonte ou esquema de cores
* Um aspecto de layout—como padding ou alinhamento

O exemplo a seguir mostra a app "Hello world!" usando widgets da
biblioteca Material. Neste exemplo, a árvore de widgets está aninhada dentro do
widget raiz `MaterialApp`.

<?code-excerpt "lib/widget_tree.dart"?>
```dart
// Flutter
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Scaffold(
        appBar: AppBar(title: const Text('Welcome to Flutter')),
        body: const Center(child: Text('Hello world')),
      ),
    );
  }
}
```

As seguintes imagens mostram "Hello world!" construído a partir de widgets Material Design.
Você obtém mais funcionalidade gratuitamente do que na app "Hello world!" básica.

{% render "docs/android-ios-figure-pair.md", image: "react-native/hello-world.png", alt: "Hello world app" %}

Ao escrever uma app, você usará dois tipos de widgets:
[`StatelessWidget`][] ou [`StatefulWidget`][].
Um `StatelessWidget` é exatamente o que parece&mdash;um
widget sem estado. Um `StatelessWidget` é criado uma vez,
e nunca muda sua aparência.
Um `StatefulWidget` muda dinamicamente de estado com base em dados
recebidos, ou entrada do usuário.

A diferença importante entre widgets stateless e stateful
é que `StatefulWidget`s têm um objeto `State`
que armazena dados de estado e os carrega
através de reconstruções de árvore, então ele não é perdido.

Em apps simples ou básicas é fácil aninhar widgets,
mas à medida que a base de código aumenta e a app se torna complexa,
você deve quebrar widgets profundamente aninhados em
funções que retornam o widget ou classes menores.
Criar funções separadas
e widgets permite que você reutilize os componentes dentro da app.

### Como criar componentes reutilizáveis?

No React Native, você definiria uma função (ou uma classe) para criar um
componente reutilizável e então usaria métodos `props` para definir
ou retornar propriedades e valores dos elementos selecionados.
No exemplo abaixo, a função `CustomCard` é definida
e então usada dentro de um componente pai.

```js
// React Native
const CustomCard = ({ index, onPress }) => {
  return (
    <View>
      <Text> Card {index} </Text>
      <Button
        title="Press"
        onPress={() => onPress(index)}
      />
    </View>
  );
};

// Usage
<CustomCard onPress={this.onPress} index={item.key} />
```

No Flutter, defina uma classe para criar um widget customizado e então reutilize o
widget. Você também pode definir e chamar uma função que retorna um
widget reutilizável como mostrado na função `build` no exemplo a seguir.

<?code-excerpt "lib/components.dart (components)"?>
```dart
/// Flutter
class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.index, required this.onPress});

  final int index;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('Card $index'),
          TextButton(onPressed: onPress, child: const Text('Press')),
        ],
      ),
    );
  }
}

class UseCard extends StatelessWidget {
  const UseCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    /// Usage
    return CustomCard(
      index: index,
      onPress: () {
        print('Card $index');
      },
    );
  }
}
```

No exemplo anterior, o construtor da classe `CustomCard`
usa a sintaxe de chaves `{ }` do Dart para indicar [named parameters][].

Para tornar esses campos obrigatórios, remova as chaves do
construtor, ou adicione `required` ao construtor.

As seguintes capturas de tela mostram um exemplo da classe
`CustomCard` reutilizável.

{% render "docs/android-ios-figure-pair.md", image: "react-native/custom-cards.png", alt: "Custom cards", class: "border" %}

[Dart]: {{site.dart-site}}/dart-2
[Dart's Type System]: {{site.dart-site}}/guides/language/sound-dart
[Sound Null Safety]: {{site.dart-site}}/null-safety
[variables]: {{site.dart-site}}/language/variables
[`Future`]: {{site.dart-site}}/tutorials/language/futures
[async and await]: {{site.dart-site}}/language/async
[functions]: {{site.dart-site}}/language/functions
[Getting started]: /get-started
[Flutter Widget Catalog]: /ui/widgets
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[named parameters]: {{site.dart-site}}/language/functions#named-parameters
[DartPadA]: {{site.dartpad}}/?id=0df636e00f348bdec2bc1c8ebc7daeb1
[DartPadB]: {{site.dartpad}}/?id=cf9e652f77636224d3e37d96dcf238e5
[DartPadC]: {{site.dartpad}}/?id=3f4625c16e05eec396d6046883739612
[DartPadD]: {{site.dartpad}}/?id=57ec21faa8b6fe2326ffd74e9781a2c7
[DartPadE]: {{site.dartpad}}/?id=c85038ad677963cb6dc943eb1a0b72e6
[DartPadF]: {{site.dartpad}}/?id=5454e8bfadf3000179d19b9bc6be9918

## Estrutura do projeto e recursos

### Onde começo a escrever o código?

Comece com o arquivo `lib/main.dart`.
Ele é gerado automaticamente quando você cria uma app Flutter.

<?code-excerpt "lib/examples.dart (main)"?>
```dart
// Dart
void main() {
  print('Hello, this is the main function.');
}
```

No Flutter, o arquivo de ponto de entrada é
`{project_name}/lib/main.dart` e a execução
começa a partir da função `main`.

### Como os arquivos são estruturados em uma app Flutter?

Quando você cria um novo projeto Flutter,
ele constrói a seguinte estrutura de diretórios.
Você pode personalizá-la depois, mas é aqui que você começa.

```plaintext
┬
└ project_name
  ┬
  ├ android      - Contains Android-specific files.
  ├ build        - Stores iOS and Android build files.
  ├ ios          - Contains iOS-specific files.
  ├ lib          - Contains externally accessible Dart source files.
    ┬
    └ src        - Contains additional source files.
    └ main.dart  - The Flutter entry point and the start of a new app.
                   This is generated automatically when you create a Flutter
                    project.
                   It's where you start writing your Dart code.
  ├ test         - Contains automated test files.
  └ pubspec.yaml - Contains the metadata for the Flutter app.
                   This is equivalent to the package.json file in React Native.
```

### Onde coloco meus recursos e assets e como os uso?

Um recurso ou asset do Flutter é um arquivo que é empacotado e implantado
com sua app e está acessível em tempo de execução.
Apps Flutter podem incluir os seguintes tipos de assets:

* Dados estáticos como arquivos JSON
* Arquivos de configuração
* Ícones e imagens (JPEG, PNG, GIF, Animated GIF, WebP, Animated WebP, BMP,
  e WBMP)

O Flutter usa o arquivo `pubspec.yaml`,
localizado na raiz do seu projeto, para
identificar assets necessários por uma app.

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

A subseção `assets` especifica arquivos que devem ser incluídos com a app.
Cada asset é identificado por um caminho explícito
relativo ao arquivo `pubspec.yaml`, onde o arquivo de asset está localizado.
A ordem em que os assets são declarados não importa.
O diretório real usado (`assets` neste caso) não importa.
No entanto, embora assets possam ser colocados em qualquer diretório da app, é uma
melhor prática colocá-los no diretório `assets`.

Durante uma compilação, o Flutter coloca assets em um arquivo especial
chamado *asset bundle*, que as apps leem em tempo de execução.
Quando o caminho de um asset é especificado na seção assets do `pubspec.yaml`,
o processo de compilação procura por quaisquer arquivos
com o mesmo nome em subdiretórios adjacentes.
Esses arquivos também são incluídos no asset bundle
junto com o asset especificado. O Flutter usa variantes de assets
ao escolher imagens de resolução apropriada para sua app.

No React Native, você adicionaria uma imagem estática colocando o arquivo de imagem
em um diretório de código fonte e referenciando-o.

```js
<Image source={require('./my-icon.png')} />
// OR
<Image
  source={%raw%}{{
    url: 'https://reactnative.dev/img/tiny_logo.png'
  }}{%endraw%}
/>
```

No Flutter, adicione uma imagem estática à sua app
usando o construtor `Image.asset` no método build de um widget.

<?code-excerpt "lib/examples.dart (image-asset)" replace="/return //g"?>
```dart
Image.asset('assets/background.png');
```

Para mais informações, veja [Adding Assets and Images in Flutter][].

### Como carrego imagens através de uma rede?

No React Native, você especificaria o `uri` no
prop `source` do componente `Image` e também forneceria o
tamanho se necessário.

No Flutter, use o construtor `Image.network` para incluir
uma imagem de uma URL.

<?code-excerpt "lib/examples.dart (image-network)" replace="/return //g"?>
```dart
Image.network('https://docs.flutter.dev/assets/images/docs/owl.jpg');
```

### Como instalo pacotes e plugins de pacotes?

O Flutter suporta o uso de pacotes compartilhados contribuídos por outros desenvolvedores aos
ecossistemas Flutter e Dart. Isso permite que você construa rapidamente sua app sem
ter que desenvolver tudo do zero. Pacotes que contêm
código específico de plataforma são conhecidos como plugins de pacotes.

No React Native, você usaria `yarn add {package-name}` ou
`npm install --save {package-name}` para instalar pacotes
na linha de comando.

No Flutter, instale um pacote usando as seguintes instruções:

1. Para adicionar o pacote `google_sign_in` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add google_sign_in
```

2. Instale o pacote na linha de comando usando `flutter pub get`.
   Se usando uma IDE, ela frequentemente executa `flutter pub get` para você, ou pode
   solicitar que você faça isso.
3. Importe o pacote no código da sua app como mostrado abaixo:

<?code-excerpt "lib/examples.dart (package-import)"?>
```dart
import 'package:flutter/material.dart';
```

Para mais informações, veja [Using Packages][] e
[Developing Packages & Plugins][].

Você pode encontrar muitos pacotes compartilhados por desenvolvedores Flutter na
seção [Flutter packages][] do [pub.dev][].

[Adding Assets and Images in Flutter]: /ui/assets/assets-and-images
[Using Packages]: /packages-and-plugins/using-packages
[Developing Packages & Plugins]: /packages-and-plugins/developing-packages
[Flutter packages]: {{site.pub}}/flutter/
[pub.dev]: {{site.pub}}

## Widgets Flutter

No Flutter, você constrói sua UI a partir de widgets que descrevem como sua view
deve parecer dada sua configuração e estado atuais.

Widgets são frequentemente compostos de muitos widgets pequenos,
de propósito único que são aninhados para produzir efeitos poderosos.
Por exemplo, o widget `Container` consiste de
vários widgets responsáveis por layout, pintura, posicionamento e dimensionamento.
Especificamente, o widget `Container` inclui os widgets `LimitedBox`,
`ConstrainedBox`, `Align`, `Padding`, `DecoratedBox` e `Transform`.
Em vez de criar subclasses de `Container` para produzir um efeito customizado, você pode
compor esses e outros widgets simples de maneiras novas e únicas.

O widget `Center` é outro exemplo de como você pode controlar o layout.
Para centralizar um widget, envolva-o em um widget `Center` e então use widgets de layout
para alinhamento, linhas, colunas e grades.
Esses widgets de layout não têm uma representação visual própria.
Em vez disso, seu único propósito é controlar algum aspecto do layout de outro
widget. Para entender por que um widget renderiza de uma
certa maneira, geralmente é útil inspecionar os widgets vizinhos.

Para mais informações, veja o [Flutter Technical Overview][].

Para mais informações sobre os widgets core do pacote `Widgets`,
veja [Flutter Basic Widgets][],
o [Flutter Widget Catalog][],
ou o [Flutter Widget Index][].

## Views

### Qual é o equivalente do container `View`?

No React Native, `View` é um container que suporta layout com `Flexbox`,
estilo, manipulação de toque e controles de acessibilidade.

No Flutter, você pode usar os widgets de layout core na biblioteca `Widgets`,
como [`Container`][], [`Column`][],
[`Row`][], e [`Center`][].
Para mais informações, veja o catálogo [Layout Widgets][].

### Qual é o equivalente de `FlatList` ou `SectionList`?

Uma `List` é uma lista rolável de componentes organizados verticalmente.

No React Native, `FlatList` ou `SectionList` são usados para renderizar listas simples ou
seccionadas.

```js
// React Native
<FlatList
  data={[ ... ]}
  renderItem={({ item }) => <Text>{item.key}</Text>}
/>
```

[`ListView`][] é o widget de rolagem mais comumente usado do Flutter.
O construtor padrão recebe uma lista explícita de filhos.
[`ListView`][] é mais apropriado para um pequeno número de widgets.
Para uma lista grande ou infinita, use `ListView.builder`,
que constrói seus filhos sob demanda e apenas constrói
os filhos que são visíveis.

<?code-excerpt "lib/examples.dart (list-view)"?>
```dart
var data = ['Hello', 'World'];
return ListView.builder(
  itemCount: data.length,
  itemBuilder: (context, index) {
    return Text(data[index]);
  },
);
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/flatlist.webp", alt: "Flat list", class: "border" %}

Para aprender como implementar uma lista de rolagem infinita, veja o exemplo oficial
[`infinite_list`][infinite_list].

### Como usar um Canvas para desenhar ou pintar?

No React Native, componentes canvas não estão presentes
então bibliotecas de terceiros como `react-native-canvas` são usadas.

```js
// React Native
const CanvasComp = () => {
  const handleCanvas = (canvas) => {
    const ctx = canvas.getContext('2d');
    ctx.fillStyle = 'skyblue';
    ctx.beginPath();
    ctx.arc(75, 75, 50, 0, 2 * Math.PI);
    ctx.fillRect(150, 100, 300, 300);
    ctx.stroke();
  };

  return (
    <View>
      <Canvas ref={this.handleCanvas} />
    </View>
  );
}
```

No Flutter, você pode usar as classes [`CustomPaint`][]
e [`CustomPainter`][] para desenhar no canvas.

O exemplo a seguir mostra como desenhar durante a fase de pintura usando o
widget `CustomPaint`. Ele implementa a classe abstrata, `CustomPainter`,
e a passa para a propriedade painter do `CustomPaint`.
Subclasses de `CustomPaint` devem implementar os métodos `paint()`
e `shouldRepaint()`.

<?code-excerpt "lib/examples.dart (custom-paint)"?>
```dart
class MyCanvasPainter extends CustomPainter {
  const MyCanvasPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = Colors.amber;
    canvas.drawCircle(const Offset(100, 200), 40, paint);
    final Paint paintRect = Paint()..color = Colors.lightBlue;
    final Rect rect = Rect.fromPoints(
      const Offset(150, 300),
      const Offset(300, 400),
    );
    canvas.drawRect(rect, paintRect);
  }

  @override
  bool shouldRepaint(MyCanvasPainter oldDelegate) => false;
}

class MyCanvasWidget extends StatelessWidget {
  const MyCanvasWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: CustomPaint(painter: MyCanvasPainter()));
  }
}
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/canvas.png", alt: "Canvas", class: "border" %}

## Layouts

### Como usar widgets para definir propriedades de layout?

No React Native, a maior parte do layout pode ser feita com os props
que são passados para um componente específico.
Por exemplo, você poderia usar o prop `style` no componente `View`
para especificar as propriedades flexbox.
Para organizar seus componentes em uma coluna, você especificaria um prop como:
`flexDirection: 'column'`.

```js
// React Native
<View
  style={%raw%}{{
    flex: 1,
    flexDirection: 'column',
    justifyContent: 'space-between',
    alignItems: 'center'
  }}{%endraw%}
>
```

No Flutter, o layout é definido principalmente por widgets
especificamente projetados para fornecer layout,
combinados com widgets de controle e suas propriedades de estilo.

Por exemplo, os widgets [`Column`][] e [`Row`][]
recebem um array de filhos e os alinham
verticalmente e horizontalmente respectivamente.
Um widget [`Container`][] recebe uma combinação de
propriedades de layout e estilo, e um
widget [`Center`][] centraliza seus widgets filhos.

<?code-excerpt "lib/layouts.dart (column)"?>
```dart
@override
Widget build(BuildContext context) {
  return Center(
    child: Column(
      children: <Widget>[
        Container(color: Colors.red, width: 100, height: 100),
        Container(color: Colors.blue, width: 100, height: 100),
        Container(color: Colors.green, width: 100, height: 100),
      ],
    ),
  );
```

O Flutter fornece uma variedade de widgets de layout em sua biblioteca de widgets core.
Por exemplo, [`Padding`][], [`Align`][], e [`Stack`][].

Para uma lista completa, veja [Layout Widgets][].

{% render "docs/android-ios-figure-pair.md", image: "react-native/basic-layout.webp", alt: "Layout", class: "border" %}

### Como fazer camadas de widgets?

No React Native, componentes podem ter camadas usando posicionamento `absolute`.

O Flutter usa o widget [`Stack`][]
para organizar widgets filhos em camadas.
Os widgets podem sobrepor completamente ou parcialmente o widget base.

O widget `Stack` posiciona seus filhos relativamente às bordas de sua caixa.
Esta classe é útil se você simplesmente quer sobrepor vários widgets filhos.

<?code-excerpt "lib/layouts.dart (stack)"?>
```dart
@override
Widget build(BuildContext context) {
  return Stack(
    alignment: const Alignment(0.6, 0.6),
    children: <Widget>[
      const CircleAvatar(
        backgroundImage: NetworkImage(
          'https://avatars3.githubusercontent.com/u/14101776?v=4',
        ),
      ),
      Container(color: Colors.black45, child: const Text('Flutter')),
    ],
  );
```

O exemplo anterior usa `Stack` para sobrepor um Container
(que exibe seu `Text` em um fundo preto translúcido)
sobre um `CircleAvatar`.
O Stack desloca o texto usando a propriedade alignment
e coordenadas `Alignment`.

{% render "docs/android-ios-figure-pair.md", image: "react-native/stack.png", alt: "Stack", class: "border" %}

Para mais informações, veja a documentação da classe [`Stack`][].

## Estilização

### Como estilizar meus componentes?

No React Native, estilização inline e `stylesheets.create`
são usados para estilizar componentes.

```js
// React Native
<View style={styles.container}>
  <Text style={%raw%}{{ fontSize: 32, color: 'cyan', fontWeight: '600' }}{%endraw%}>
    This is a sample text
  </Text>
</View>

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
    alignItems: 'center',
    justifyContent: 'center'
  }
});
```

No Flutter, um widget `Text` pode receber uma classe `TextStyle`
para sua propriedade style. Se você quiser usar o mesmo estilo de texto
em vários lugares, pode criar uma
classe [`TextStyle`][] e usá-la para múltiplos widgets `Text`.

<?code-excerpt "lib/examples.dart (text-style)"?>
```dart
const TextStyle textStyle = TextStyle(
  color: Colors.cyan,
  fontSize: 32,
  fontWeight: FontWeight.w600,
);

return const Center(
  child: Column(
    children: <Widget>[
      Text('Sample text', style: textStyle),
      Padding(
        padding: EdgeInsets.all(20),
        child: Icon(
          Icons.lightbulb_outline,
          size: 48,
          color: Colors.redAccent,
        ),
      ),
    ],
  ),
);
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/flutterstyling.webp", alt: "Styling", class: "border" %}

### Como usar `Icons` e `Colors`?

React Native não inclui suporte para ícones
então bibliotecas de terceiros são usadas.

No Flutter, importar a biblioteca Material também extrai o
rico conjunto de [Material icons][] e [colors][].

<?code-excerpt "lib/examples.dart (icon)"?>
```dart
return const Icon(Icons.lightbulb_outline, color: Colors.redAccent);
```

Ao usar a classe `Icons`,
certifique-se de definir `uses-material-design: true` no
arquivo `pubspec.yaml` do projeto.
Isso garante que a fonte `MaterialIcons`, que exibe os ícones, seja incluída em sua app.
Em geral, se você pretende usar a biblioteca Material,
deve incluir esta linha.

```yaml
name: my_awesome_application
flutter:
  uses-material-design: true
```

O pacote [Cupertino (iOS-style)][] do Flutter fornece widgets de alta
fidelidade para a linguagem de design atual do iOS.
Para usar a fonte `CupertinoIcons`,
adicione uma dependência para `cupertino_icons` no arquivo
`pubspec.yaml` do seu projeto.

```yaml
name: my_awesome_application
dependencies:
  cupertino_icons: ^1.0.8
```

Para customizar globalmente as cores e estilos dos componentes,
use `ThemeData` para especificar cores padrão
para vários aspectos do tema.
Defina a propriedade theme no `MaterialApp` para o objeto `ThemeData`.
A classe [`Colors`][] fornece cores
da [paleta de cores][color palette] do Material Design.

O exemplo a seguir define o esquema de cores a partir da seed como `deepPurple`
e a seleção de texto como `red`.

<?code-excerpt "lib/examples.dart (swatch)"?>
```dart
class SampleApp extends StatelessWidget {
  const SampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor: Colors.red,
        ),
      ),
      home: const SampleAppPage(),
    );
  }
}
```

### Como adicionar temas de estilo?

No React Native, temas comuns são definidos para
componentes em stylesheets e então usados em componentes.

No Flutter, crie estilização uniforme para quase tudo
definindo a estilização na classe [`ThemeData`][]
e passando-a para a propriedade theme no
widget [`MaterialApp`][].

<?code-excerpt "lib/examples.dart (theme)"?>
```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(primaryColor: Colors.cyan, brightness: Brightness.dark),
    home: const StylingPage(),
  );
}
```

Um `Theme` pode ser aplicado mesmo sem usar o widget `MaterialApp`.
O widget [`Theme`][] recebe um `ThemeData` em seu parâmetro `data`
e aplica o `ThemeData` a todos os seus widgets filhos.

<?code-excerpt "lib/examples.dart (theme-data)"?>
```dart
@override
Widget build(BuildContext context) {
  return Theme(
    data: ThemeData(primaryColor: Colors.cyan, brightness: brightness),
    child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //...
    ),
  );
}
```

[Flutter Technical Overview]: /resources/architectural-overview
[Flutter Basic Widgets]: /ui/widgets/basics
[Flutter Widget Index]: /reference/widgets
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[Layout Widgets]: /ui/widgets/layout
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[infinite_list]: {{site.repo.samples}}/tree/main/infinite_list
[`CustomPaint`]: {{site.api}}/flutter/widgets/CustomPaint-class.html
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[`Padding`]: {{site.api}}/flutter/widgets/Padding-class.html
[`Align`]: {{site.api}}/flutter/widgets/Align-class.html
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[`TextStyle`]: {{site.api}}/flutter/dart-ui/TextStyle-class.html
[Material icons]: {{site.api}}/flutter/material/Icons-class.html
[colors]: {{site.api}}/flutter/material/Colors-class.html
[`Colors`]: {{site.api}}/flutter/material/Colors-class.html
[color palette]: {{site.material2}}/design/color/the-color-system.html#color-theme-creation
[Cupertino (iOS-style)]: /ui/widgets/cupertino
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`Theme`]: {{site.api}}/flutter/material/Theme-class.html

## Gerenciamento de estado

Estado é informação que pode ser lida sincronamente
quando um widget é construído ou informação
que pode mudar durante o ciclo de vida de um widget.
Para gerenciar o estado da app no Flutter,
use um [`StatefulWidget`][] pareado com um objeto State.

Para mais informações sobre maneiras de abordar o gerenciamento de estado no Flutter,
veja [State management][].

### O StatelessWidget

Um `StatelessWidget` no Flutter é um widget
que não requer uma mudança de estado&mdash;
ele não tem estado interno para gerenciar.

Widgets stateless são úteis quando a parte da interface de usuário
que você está descrevendo não depende de nada além das
informações de configuração no próprio objeto e do
[`BuildContext`][] no qual o widget é inflado.

[`AboutDialog`][], [`CircleAvatar`][], e [`Text`][] são exemplos
de widgets stateless que fazem subclasse de [`StatelessWidget`][].

<?code-excerpt "lib/stateless.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(
  const MyStatelessWidget(
    text: 'StatelessWidget Example to show immutable data',
  ),
);

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text, textDirection: TextDirection.ltr));
  }
}
```

O exemplo anterior usa o construtor da classe `MyStatelessWidget`
para passar o `text`, que é marcado como `final`.
Esta classe estende `StatelessWidget`&mdash;ela contém dados imutáveis.

O método `build` de um widget stateless é tipicamente chamado
em apenas três situações:

* Quando o widget é inserido em uma árvore
* Quando o pai do widget muda sua configuração
* Quando um [`InheritedWidget`][] do qual ele depende, muda

### O StatefulWidget

Um [`StatefulWidget`][] é um widget que muda de estado.
Use o método `setState` para gerenciar as
mudanças de estado para um `StatefulWidget`.
Uma chamada para `setState()` diz ao framework
Flutter que algo mudou em um estado,
o que faz com que uma app execute novamente o método `build()`
para que a app possa refletir a mudança.

_Estado_ é informação que pode ser lida sincronamente quando um widget
é construído e pode mudar durante o ciclo de vida do widget.
É responsabilidade do implementador do widget garantir que
o objeto de estado seja prontamente notificado quando o estado muda.
Use `StatefulWidget` quando um widget pode mudar dinamicamente.
Por exemplo, o estado do widget muda digitando em um formulário,
ou movendo um slider.
Ou, pode mudar ao longo do tempo—talvez um feed de dados atualize a UI.

[`Checkbox`][], [`Radio`][], [`Slider`][], [`InkWell`][],
[`Form`][], e [`TextField`][]
são exemplos de widgets stateful que fazem subclasse de
[`StatefulWidget`][].

O exemplo a seguir declara um `StatefulWidget`
que requer um método `createState()`.
Este método cria o objeto de estado que gerencia o estado do widget,
`_MyStatefulWidgetState`.

<?code-excerpt "lib/stateful.dart (stateful-widget)"?>
```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.title});

  final String title;

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}
```

A seguinte classe de estado, `_MyStatefulWidgetState`,
implementa o método `build()` para o widget.
Quando o estado muda, por exemplo, quando o usuário alterna
o botão, `setState()` é chamado com o novo valor de alternância.
Isso faz com que o framework reconstrua este widget na UI.

<?code-excerpt "lib/stateful.dart (stateful-widget-state)"?>
```dart
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  bool showText = true;
  bool toggleState = true;
  Timer? t2;

  void toggleBlinkState() {
    setState(() {
      toggleState = !toggleState;
    });
    if (!toggleState) {
      t2 = Timer.periodic(const Duration(milliseconds: 1000), (t) {
        toggleShowText();
      });
    } else {
      t2?.cancel();
    }
  }

  void toggleShowText() {
    setState(() {
      showText = !showText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            if (showText)
              const Text('This execution will be done before you can blink.'),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: ElevatedButton(
                onPressed: toggleBlinkState,
                child: toggleState
                    ? const Text('Blink')
                    : const Text('Stop Blinking'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Quais são as melhores práticas de StatefulWidget e StatelessWidget?

Aqui estão algumas coisas a considerar ao projetar seu widget.

1. Determine se um widget deve ser
   um `StatefulWidget` ou um `StatelessWidget`.

No Flutter, widgets são Stateful ou Stateless—dependendo se
eles dependem de uma mudança de estado.

* Se um widget muda&mdash;o usuário interage com ele ou
  um feed de dados interrompe a UI, então é *Stateful*.
* Se um widget é final ou imutável, então é *Stateless*.

2. Determine qual objeto gerencia o estado do widget (para um `StatefulWidget`).

No Flutter, existem três maneiras principais de gerenciar estado:

* O widget gerencia seu próprio estado
* O widget pai gerencia o estado do widget
* Uma abordagem mista

Ao decidir qual abordagem usar, considere os seguintes princípios:

* Se o estado em questão é dado do usuário,
  por exemplo o modo marcado ou desmarcado de uma checkbox,
  ou a posição de um slider, então o estado é melhor gerenciado
  pelo widget pai.
* Se o estado em questão é estético, por exemplo uma animação,
  então o próprio widget gerencia melhor o estado.
* Quando em dúvida, deixe o widget pai gerenciar o estado do widget filho.

3. Faça subclasse de StatefulWidget e State.

A classe `MyStatefulWidget` gerencia seu próprio estado&mdash;ela estende
`StatefulWidget`, ela sobrescreve o método `createState()`
para criar o objeto `State`,
e o framework chama `createState()` para construir o widget.
Neste exemplo, `createState()` cria uma instância de
`_MyStatefulWidgetState`, que
é implementada na próxima melhor prática.

<?code-excerpt "lib/best_practices.dart (create-state)" replace="/return const Text\('Hello World!'\);/\/\/.../g"?>
```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({super.key, required this.title});

  final String title;
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    //...
  }
}
```

4. Adicione o StatefulWidget à árvore de widgets.

Adicione seu `StatefulWidget` customizado à árvore de widgets
no método build da app.

<?code-excerpt "lib/best_practices.dart (use-stateful-widget)"?>
```dart
class MyStatelessWidget extends StatelessWidget {
  // This widget is the root of your application.
  const MyStatelessWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyStatefulWidget(title: 'State Change Demo'),
    );
  }
}
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/state-change.webp", alt: "State change", class: "border" %}

## Props

No React Native, a maioria dos componentes pode ser customizada quando eles são
criados com diferentes parâmetros ou propriedades, chamadas `props`.
Esses parâmetros podem ser usados em um componente filho usando `this.props`.

```js
// React Native
const CustomCard = ({ index, onPress }) => {
  return (
    <View>
      <Text> Card {index} </Text>
      <Button
        title='Press'
        onPress={() => onPress(index)}
      />
    </View>
  );
};

const App = () => {
  const onPress = (index) => {
    console.log('Card ', index);
  };

  return (
    <View>
      <FlatList
        data={[ /* ... */ ]}
        renderItem={({ item }) => (
          <CustomCard onPress={onPress} index={item.key} />
        )}
      />
    </View>
  );
};
```

No Flutter, você atribui uma variável ou função local marcada
`final` com a propriedade recebida no construtor parametrizado.

<?code-excerpt "lib/components.dart (components)"?>
```dart
/// Flutter
class CustomCard extends StatelessWidget {
  const CustomCard({super.key, required this.index, required this.onPress});

  final int index;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('Card $index'),
          TextButton(onPressed: onPress, child: const Text('Press')),
        ],
      ),
    );
  }
}

class UseCard extends StatelessWidget {
  const UseCard({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    /// Usage
    return CustomCard(
      index: index,
      onPress: () {
        print('Card $index');
      },
    );
  }
}
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/modular.png", alt: "Cards", class: "border" %}

## Armazenamento local

Se você não precisa armazenar muitos dados, e eles não requerem
estrutura, pode usar `shared_preferences` que permite que você
leia e escreva pares chave-valor persistentes de tipos de dados
primitivos: booleans, floats, ints, longs e strings.

### Como armazenar pares chave-valor persistentes que são globais à app?

No React Native, você usa as funções `setItem` e `getItem`
do componente `AsyncStorage` para armazenar e recuperar dados
que são persistentes e globais à app.

```js
// React Native
const [counter, setCounter] = useState(0)
...
await AsyncStorage.setItem( 'counterkey', json.stringify(++this.state.counter));
AsyncStorage.getItem('counterkey').then(value => {
  if (value != null) {
    setCounter(value);
  }
});
```

No Flutter, use o plugin [`shared_preferences`][] para
armazenar e recuperar dados chave-valor que são persistentes e globais
à app. O plugin `shared_preferences` envolve
`NSUserDefaults` no iOS e `SharedPreferences` no Android,
fornecendo um armazenamento persistente para dados simples.

Para adicionar o pacote `shared_preferences` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add shared_preferences
```

<?code-excerpt "lib/examples.dart (shared-prefs)"?>
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

Para implementar dados persistentes, use os métodos setter
fornecidos pela classe `SharedPreferences`.
Métodos setter estão disponíveis para vários tipos
primitivos, como `setInt`, `setBool` e `setString`.
Para ler dados, use o método getter apropriado fornecido
pela classe `SharedPreferences`. Para cada
setter há um método getter correspondente,
por exemplo, `getInt`, `getBool` e `getString`.

<?code-excerpt "lib/examples.dart (shared-prefs-update)"?>
```dart
Future<void> updateCounter() async {
  final prefs = await SharedPreferences.getInstance();
  int? counter = prefs.getInt('counter');
  if (counter is int) {
    await prefs.setInt('counter', ++counter);
  }
  setState(() {
    _counter = counter;
  });
}
```

[State management]: /data-and-backend/state-mgmt
[`BuildContext`]: {{site.api}}/flutter/widgets/BuildContext-class.html
[`AboutDialog`]: {{site.api}}/flutter/material/AboutDialog-class.html
[`CircleAvatar`]: {{site.api}}/flutter/material/CircleAvatar-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`shared_preferences`]: {{site.repo.packages}}/tree/main/packages/shared_preferences/shared_preferences

## Roteamento

A maioria das apps contém várias telas para exibir diferentes
tipos de informação. Por exemplo, você pode ter uma tela de produto
que exibe imagens onde os usuários podem tocar em uma imagem de produto
para obter mais informações sobre o produto em uma nova tela.

No Android, novas telas são novas Activities.
No iOS, novas telas são novas ViewControllers. No Flutter,
telas são apenas Widgets! E para navegar para novas
telas no Flutter, use o widget Navigator.

### Como navegar entre telas?

No React Native, existem três navegadores principais:
 StackNavigator, TabNavigator e DrawerNavigator.
Cada um fornece uma maneira de configurar e definir as telas.

```js
// React Native
const MyApp = TabNavigator(
  { Home: { screen: HomeScreen }, Notifications: { screen: tabNavScreen } },
  { tabBarOptions: { activeTintColor: '#e91e63' } }
);
const SimpleApp = StackNavigator({
  Home: { screen: MyApp },
  stackScreen: { screen: StackScreen }
});
export default (MyApp1 = DrawerNavigator({
  Home: {
    screen: SimpleApp
  },
  Screen2: {
    screen: drawerScreen
  }
}));
```

No Flutter, existem dois widgets principais usados para navegar entre telas:

* Um [`Route`][] é uma abstração para uma tela ou página da app.
* Um [`Navigator`][] é um widget que gerencia rotas.

Um `Navigator` é definido como um widget que gerencia um conjunto de widgets filhos
com uma disciplina de pilha. O navigator gerencia uma pilha
de objetos `Route` e fornece métodos para gerenciar a pilha,
como [`Navigator.push`][] e [`Navigator.pop`][].
Uma lista de rotas pode ser especificada no widget [`MaterialApp`][],
ou elas podem ser construídas dinamicamente, por exemplo, em animações hero.
O exemplo a seguir especifica rotas nomeadas no widget `MaterialApp`.

:::note
Rotas nomeadas não são mais recomendadas para a maioria
das aplicações. Para mais informações, veja
[Limitations][] na página [navigation overview][].
:::

[Limitations]: /ui/navigation#limitations
[navigation overview]: /ui/navigation

<?code-excerpt "lib/navigation.dart (navigator)"?>
```dart
class NavigationApp extends StatelessWidget {
  // This widget is the root of your application.
  const NavigationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //...
      routes: <String, WidgetBuilder>{
        '/a': (context) => const UsualNavScreen(),
        '/b': (context) => const DrawerNavScreen(),
      },
      //...
    );
  }
}
```

Para navegar para uma rota nomeada, o método [`Navigator.of()`][]
é usado para especificar o `BuildContext`
(uma referência à localização de um widget na árvore de widgets).
O nome da rota é passado para a função `pushNamed` para
navegar para a rota especificada.

<?code-excerpt "lib/navigation.dart (push-named)"?>
```dart
Navigator.of(context).pushNamed('/a');
```

Você também pode usar o método push do `Navigator` que
adiciona o [`Route`][] dado ao histórico do
navigator que envolve mais estreitamente o [`BuildContext`][] dado,
e faz a transição para ele. No exemplo a seguir,
o widget [`MaterialPageRoute`][] é uma rota modal que
substitui a tela inteira com uma transição adaptativa à plataforma.
Ele recebe um [`WidgetBuilder`][] como um parâmetro obrigatório.

<?code-excerpt "lib/navigation.dart (navigator-push)"?>
```dart
Navigator.push(
  context,
  MaterialPageRoute<void>(builder: (context) => const UsualNavScreen()),
);
```

### Como usar navegação por abas e navegação por drawer?

Em apps Material Design, existem duas opções principais
para navegação Flutter: abas e drawers.
Quando não há espaço suficiente para suportar abas, drawers
fornecem uma boa alternativa.

#### Navegação por abas

No React Native, `createBottomTabNavigator`
e `TabNavigation` são usados para
mostrar abas e para navegação por abas.

```js
// React Native
import { createBottomTabNavigator } from 'react-navigation';

const MyApp = TabNavigator(
  { Home: { screen: HomeScreen }, Notifications: { screen: tabNavScreen } },
  { tabBarOptions: { activeTintColor: '#e91e63' } }
);
```

O Flutter fornece vários widgets especializados para navegação por drawer e
abas:

[`TabController`][]
: Coordena a seleção de abas entre um `TabBar`
  e um `TabBarView`.

[`TabBar`][]
: Exibe uma linha horizontal de abas.

[`Tab`][]
: Cria uma aba TabBar do material design.

[`TabBarView`][]
: Exibe o widget que corresponde à aba atualmente selecionada.


<?code-excerpt "lib/navigation.dart (tab-nav)"?>
```dart
class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late TabController controller = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      tabs: const <Tab>[
        Tab(icon: Icon(Icons.person)),
        Tab(icon: Icon(Icons.email)),
      ],
    );
  }
}
```


Um `TabController` é necessário para coordenar a seleção de abas
entre um `TabBar` e um `TabBarView`.
O argumento `length` do construtor `TabController` é o número total
de abas. Um `TickerProvider` é necessário para acionar
a notificação sempre que um frame aciona uma mudança de estado.
O `TickerProvider` é `vsync`. Passe o
argumento `vsync: this` ao construtor `TabController`
sempre que você criar um novo `TabController`.

O [`TickerProvider`][] é uma interface implementada
por classes que podem fornecer objetos [`Ticker`][].
Tickers podem ser usados por qualquer objeto que precisa ser notificado sempre que um
frame aciona, mas são mais comumente usados indiretamente via um
[`AnimationController`][]. `AnimationController`s
precisam de um `TickerProvider` para obter seu `Ticker`.
Se você está criando um AnimationController de um State,
então pode usar as classes [`TickerProviderStateMixin`][]
ou [`SingleTickerProviderStateMixin`][]
para obter um `TickerProvider` adequado.

O widget [`Scaffold`][] envolve um novo widget `TabBar` e
cria duas abas. O widget `TabBarView`
é passado como o parâmetro `body` do widget `Scaffold`.
Todas as telas correspondentes às abas do widget `TabBar` são
filhas do widget `TabBarView` junto com o mesmo `TabController`.

<?code-excerpt "lib/navigation.dart (navigation-home-page-state)"?>
```dart
class _NavigationHomePageState extends State<NavigationHomePage>
    with SingleTickerProviderStateMixin {
  late TabController controller = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Material(
        color: Colors.blue,
        child: TabBar(
          tabs: const <Tab>[
            Tab(icon: Icon(Icons.person)),
            Tab(icon: Icon(Icons.email)),
          ],
          controller: controller,
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: const <Widget>[HomeScreen(), TabScreen()],
      ),
    );
  }
}
```

#### Navegação por drawer

No React Native, importe os pacotes react-navigation necessários e depois use
`createDrawerNavigator` e `DrawerNavigation`.

```js
// React Native
export default (MyApp1 = DrawerNavigator({
  Home: {
    screen: SimpleApp
  },
  Screen2: {
    screen: drawerScreen
  }
}));
```

No Flutter, podemos usar o widget `Drawer` em combinação com um
`Scaffold` para criar um layout com um drawer Material Design.
Para adicionar um `Drawer` a uma app, envolva-o em um widget `Scaffold`.
O widget `Scaffold` fornece uma
estrutura visual consistente para apps que seguem as
diretrizes do [Material Design][]. Ele também suporta
componentes especiais do Material Design,
como `Drawers`, `AppBars` e `SnackBars`.

O widget `Drawer` é um painel Material Design que desliza
horizontalmente da borda de um `Scaffold` para mostrar links de navegação
em uma aplicação. Você pode
fornecer um [`ElevatedButton`][], um widget [`Text`][],
ou uma lista de itens para exibir como filho do widget `Drawer`.
No exemplo a seguir, o widget [`ListTile`][]
fornece a navegação ao tocar.

<?code-excerpt "lib/examples.dart (drawer)"?>
```dart
@override
Widget build(BuildContext context) {
  return Drawer(
    elevation: 20,
    child: ListTile(
      leading: const Icon(Icons.change_history),
      title: const Text('Screen2'),
      onTap: () {
        Navigator.of(context).pushNamed('/b');
      },
    ),
  );
}
```

O widget `Scaffold` também inclui um widget `AppBar` que automaticamente
exibe um IconButton apropriado para mostrar o `Drawer` quando um Drawer está
disponível no `Scaffold`. O `Scaffold` automaticamente lida com o
gesto de deslizar da borda para mostrar o `Drawer`.

<?code-excerpt "lib/examples.dart (scaffold)"?>
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    drawer: Drawer(
      elevation: 20,
      child: ListTile(
        leading: const Icon(Icons.change_history),
        title: const Text('Screen2'),
        onTap: () {
          Navigator.of(context).pushNamed('/b');
        },
      ),
    ),
    appBar: AppBar(title: const Text('Home')),
    body: Container(),
  );
}
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/navigation.webp", alt: "Navigation", class: "border" %}

[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.push`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`Navigator.pop`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.of()`]: {{site.api}}/flutter/widgets/Navigator/of.html
[`MaterialPageRoute`]: {{site.api}}/flutter/material/MaterialPageRoute-class.html
[`WidgetBuilder`]: {{site.api}}/flutter/widgets/WidgetBuilder.html
[`TabController`]: {{site.api}}/flutter/material/TabController-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`Tab`]: {{site.api}}/flutter/material/Tab-class.html
[`TabBarView`]: {{site.api}}/flutter/material/TabBarView-class.html
[`TickerProvider`]: {{site.api}}/flutter/scheduler/TickerProvider-class.html
[`Ticker`]: {{site.api}}/flutter/scheduler/Ticker-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`TickerProviderStateMixin`]: {{site.api}}/flutter/widgets/TickerProviderStateMixin-mixin.html
[`SingleTickerProviderStateMixin`]: {{site.api}}/flutter/widgets/SingleTickerProviderStateMixin-mixin.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[Material Design]: {{site.material}}/styles
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html

## Detecção de gestos e manipulação de eventos de toque

Para ouvir e responder a gestos,
o Flutter suporta toques, arrastos e dimensionamento.
O sistema de gestos no Flutter tem duas camadas separadas.
A primeira camada inclui eventos de ponteiro brutos,
que descrevem a localização e movimento de ponteiros,
(como toques, mouses e movimentos de canetas), pela tela.
A segunda camada inclui gestos
que descrevem ações semânticas
e consistem em um ou mais movimentos de ponteiro.

### Como adicionar um listener de clique ou pressão a um widget?

No React Native, listeners são adicionados a componentes
usando `PanResponder` ou os componentes `Touchable`.

```js
// React Native
<TouchableOpacity
  onPress={() => {
    console.log('Press');
  }}
  onLongPress={() => {
    console.log('Long Press');
  }}
>
  <Text>Tap or Long Press</Text>
</TouchableOpacity>
```

Para gestos mais complexos e combinar vários toques em um
único gesto, [`PanResponder`][] é usado.

```js
// React Native
const App = () => {
  const panResponderRef = useRef(null);

  useEffect(() => {
    panResponderRef.current = PanResponder.create({
      onMoveShouldSetPanResponder: (event, gestureState) =>
        !!getDirection(gestureState),
      onPanResponderMove: (event, gestureState) => true,
      onPanResponderRelease: (event, gestureState) => {
        const drag = getDirection(gestureState);
      },
      onPanResponderTerminationRequest: (event, gestureState) => true
    });
  }, []);

  return (
    <View style={styles.container} {...panResponderRef.current.panHandlers}>
      <View style={styles.center}>
        <Text>Swipe Horizontally or Vertically</Text>
      </View>
    </View>
  );
};
```

No Flutter, para adicionar um listener de clique (ou pressão) a um widget,
use um botão ou um widget tocável que tem um campo `onPress: field`.
Ou, adicione detecção de gestos a qualquer widget envolvendo-o
em um [`GestureDetector`][].

<?code-excerpt "lib/examples.dart (gesture-detector)"?>
```dart
@override
Widget build(BuildContext context) {
  return GestureDetector(
    child: Scaffold(
      appBar: AppBar(title: const Text('Gestures')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Tap, Long Press, Swipe Horizontally or Vertically'),
          ],
        ),
      ),
    ),
    onTap: () {
      print('Tapped');
    },
    onLongPress: () {
      print('Long Pressed');
    },
    onVerticalDragEnd: (value) {
      print('Swiped Vertically');
    },
    onHorizontalDragEnd: (value) {
      print('Swiped Horizontally');
    },
  );
}
```

Para mais informações, incluindo uma lista de
callbacks do `GestureDetector` do Flutter,
veja a [GestureDetector class][].

[GestureDetector class]: {{site.api}}/flutter/widgets/GestureDetector-class.html#instance-properties
[`PanResponder`]: https://reactnative.dev/docs/panresponder
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html

{% render "docs/android-ios-figure-pair.md", image: "react-native/flutter-gestures.webp", alt: "Gestures", class: "border" %}

## Fazendo requisições de rede HTTP

Buscar dados da internet é comum para a maioria das apps. E no Flutter,
o pacote `http` fornece a maneira mais simples de buscar dados da internet.

### Como fazer chamadas de API para buscar dados?

React Native fornece a Fetch API para networking—você faz uma requisição fetch
e então recebe a resposta para obter os dados.

```js
// React Native
const [ipAddress, setIpAddress] = useState('')

const _getIPAddress = () => {
  fetch('https://httpbin.org/ip')
    .then(response => response.json())
    .then(responseJson => {
      setIpAddress(responseJson.origin);
    })
    .catch(error => {
      console.error(error);
    });
};
```

O Flutter usa o pacote `http`.

Para adicionar o pacote `http` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add http
```

O Flutter usa o suporte HTTP core do cliente [`dart:io`][].
Para criar um HTTP Client, importe `dart:io`.

<?code-excerpt "lib/examples.dart (import-dart-io)"?>
```dart
import 'dart:io';
```

O cliente suporta as seguintes operações HTTP:
GET, POST, PUT e DELETE.

<?code-excerpt "lib/examples.dart (http)"?>
```dart
final url = Uri.parse('https://httpbin.org/ip');
final httpClient = HttpClient();

Future<void> getIPAddress() async {
  final request = await httpClient.getUrl(url);
  final response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  final ip = jsonDecode(responseBody)['origin'] as String;
  setState(() {
    _ipAddress = ip;
  });
}
```

[`dart:io`]: {{site.api}}/flutter/dart-io/dart-io-library.html

{% render "docs/android-ios-figure-pair.md", image: "react-native/api-calls.webp", alt: "API calls", class: "border" %}

## Entrada de formulário

Campos de texto permitem que os usuários digitem texto em sua app para que possam ser
usados para construir formulários, apps de mensagens, experiências de busca e mais.
O Flutter fornece dois widgets de campo de texto core:
[`TextField`][] e [`TextFormField`][].

### Como usar widgets de campo de texto?

No React Native, para inserir texto você usa um componente `TextInput` para mostrar uma caixa
de entrada de texto e então usa o callback para armazenar o valor em uma variável.

```js
// React Native
const [password, setPassword] = useState('')
...
<TextInput
  placeholder="Enter your Password"
  onChangeText={password => setPassword(password)}
/>
<Button title="Submit" onPress={this.validate} />
```

No Flutter, use a classe [`TextEditingController`][]
para gerenciar um widget `TextField`.
Sempre que o campo de texto é modificado,
o controller notifica seus ouvintes.

Ouvintes leem as propriedades de texto e seleção para
saber o que o usuário digitou no campo.
Você pode acessar o texto em `TextField`
pela propriedade `text` do controller.

<?code-excerpt "lib/examples.dart (text-editing-controller)"?>
```dart
final TextEditingController _controller = TextEditingController();

@override
Widget build(BuildContext context) {
  return Column(
    children: [
      TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Type something',
          labelText: 'Text Field',
        ),
      ),
      ElevatedButton(
        child: const Text('Submit'),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: Text('You typed ${_controller.text}'),
              );
            },
          );
        },
      ),
    ],
  );
}
```

Neste exemplo, quando um usuário clica no botão submit um diálogo de alerta
exibe o texto atual inserido no campo de texto.
Isso é alcançado usando um widget [`AlertDialog`][]
que exibe a mensagem de alerta, e o texto do
`TextField` é acessado pela propriedade `text` do
[`TextEditingController`][].

### Como usar widgets Form?

No Flutter, use o widget [`Form`][] onde
widgets [`TextFormField`][] junto com o botão submit
são passados como filhos.
O widget `TextFormField` tem um parâmetro chamado
[`onSaved`][] que recebe um callback e executa
quando o formulário é salvo. Um objeto `FormState`
é usado para salvar, resetar ou validar
cada `FormField` que é descendente deste `Form`.
Para obter o `FormState`, você pode usar `Form.of()`
com um contexto cujo ancestral é o `Form`,
ou passar uma `GlobalKey` ao construtor `Form` e chamar
`GlobalKey.currentState()`.

<?code-excerpt "lib/examples.dart (form-state)"?>
```dart
@override
Widget build(BuildContext context) {
  return Form(
    key: formKey,
    child: Column(
      children: <Widget>[
        TextFormField(
          validator: (value) {
            if (value != null && value.contains('@')) {
              return null;
            }
            return 'Not a valid email.';
          },
          onSaved: (val) {
            _email = val;
          },
          decoration: const InputDecoration(
            hintText: 'Enter your email',
            labelText: 'Email',
          ),
        ),
        ElevatedButton(onPressed: _submit, child: const Text('Login')),
      ],
    ),
  );
}
```

O exemplo a seguir mostra como `Form.save()` e `formKey`
(que é uma `GlobalKey`), são usados para salvar o formulário ao submeter.

<?code-excerpt "lib/examples.dart (form-submit)"?>
```dart
void _submit() {
  final form = formKey.currentState;
  if (form != null && form.validate()) {
    form.save();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alert'),
          content: Text('Email: $_email, password: $_password'),
        );
      },
    );
  }
}
```

[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[`onSaved`]: {{site.api}}/flutter/widgets/FormField/onSaved.html

{% render "docs/android-ios-figure-pair.md", image: "react-native/input-fields.webp", alt: "Input", class: "border" %}

## Código específico de plataforma

Ao construir uma app cross-platform, você quer reutilizar o máximo de código possível
entre plataformas. No entanto, cenários podem surgir onde faz
sentido o código ser diferente dependendo do OS.
Isso requer uma implementação separada declarando uma plataforma específica.

No React Native, a seguinte implementação seria usada:

```js
// React Native
if (Platform.OS === 'ios') {
  return 'iOS';
} else if (Platform.OS === 'android') {
  return 'android';
} else {
  return 'not recognised';
}
```

No Flutter, use a seguinte implementação:

<?code-excerpt "lib/examples.dart (platform)"?>
```dart
final platform = Theme.of(context).platform;
if (platform == TargetPlatform.iOS) {
  return 'iOS';
}
if (platform == TargetPlatform.android) {
  return 'android';
}
if (platform == TargetPlatform.fuchsia) {
  return 'fuchsia';
}
return 'not recognized ';
```

## Depuração

### Quais ferramentas posso usar para depurar minha app no Flutter?

Use o conjunto de ferramentas [DevTools][] para depurar apps Flutter ou Dart.

DevTools inclui suporte para profiling, examinando o heap,
inspecionando a árvore de widgets, registrando diagnósticos, depurando,
observando linhas de código executadas, depurando vazamentos de memória e
fragmentação de memória. Para mais informações, confira a
documentação do [DevTools][].

Se você está usando uma IDE,
pode depurar sua aplicação usando o debugger da IDE.

### Como realizar um hot reload?

O recurso Stateful Hot Reload do Flutter ajuda você a experimentar rápida e facilmente,
construir UIs, adicionar recursos e corrigir bugs. Em vez de recompilar sua app
toda vez que você faz uma mudança, pode fazer hot reload da sua app instantaneamente.
A app é atualizada para refletir sua mudança,
e o estado atual da app é preservado.

Primeiro, de sua IDE preferida,
habilite autosave e hot reloads on save.

    **VS Code**

    Adicione o seguinte ao seu arquivo `.vscode/settings.json`:

    ```json
    "files.autoSave": "afterDelay",
    "dart.flutterHotReloadOnSave": "all",
    ```
    **Android Studio e IntelliJ**

    * Abra `Settings > Tools > Actions on Save` e selecione
     `Configure autosave options`.
        - Marque a opção para `Save files if the IDE is idle for X seconds`.
        - **Recomendado:** Defina uma pequena duração de delay. Por exemplo, 2 segundos.

    * Abra `Settings > Languages & Frameworks > Flutter`.
        - Marque a opção para `Perform hot reload on save`.


No React Native,
o atalho é ⌘R para o iOS Simulator e tocar R duas vezes em
emuladores Android.

No Flutter, se você está usando o IntelliJ IDE ou Android Studio,
pode selecionar Save All (⌘s/ctrl-s), ou pode clicar no
botão Hot Reload na barra de ferramentas. Se você
está executando a app na linha de comando usando `flutter run`,
digite `r` na janela do Terminal.
Você também pode realizar um restart completo digitando `R` na
janela do Terminal.

### Como acessar o menu desenvolvedor in-app?

No React Native, o menu desenvolvedor pode ser acessado sacudindo seu dispositivo: ⌘D
para o iOS Simulator ou ⌘M para emulador Android.

No Flutter, se você está usando uma IDE, pode usar as ferramentas da IDE. Se você iniciar
sua aplicação usando `flutter run` você também pode acessar o menu digitando `h`
na janela do terminal, ou digite os seguintes atalhos:

| Ação| Atalho do Terminal| Funções e propriedades de depuração|
| :------- | :------: | :------ |
| Hierarquia de widgets da app| `w`| debugDumpApp()|
| Árvore de renderização da app | `t`| debugDumpRenderTree()|
| Camadas| `L`| debugDumpLayerTree()|
| Acessibilidade | `S` (ordem de travessia) ou<br>`U` (ordem inversa do hit test)|debugDumpSemantics()|
| Para alternar o widget inspector | `i` | WidgetsApp. showWidgetInspectorOverride|
| Para alternar a exibição de linhas de construção| `p` | debugPaintSizeEnabled|
| Para simular diferentes sistemas operacionais| `o` | defaultTargetPlatform|
| Para exibir o overlay de performance | `P` | WidgetsApp. showPerformanceOverlay|
| Para salvar uma captura de tela para flutter. png| `s` ||
| Para sair| `q` ||

{:.table .table-striped}

[DevTools]: /tools/devtools

## Animação

Animação bem projetada faz uma UI parecer intuitiva,
contribui para a aparência de uma app polida,
e melhora a experiência do usuário.
O suporte de animação do Flutter facilita
implementar animações simples e complexas.
O Flutter SDK inclui muitos widgets Material Design
que incluem efeitos de movimento padrão,
e você pode facilmente customizar esses efeitos
para personalizar sua app.

No React Native, Animated APIs são usadas para criar animações.

No Flutter, use a classe [`Animation`][]
e a classe [`AnimationController`][].
`Animation` é uma classe abstrata que entende seu
valor atual e seu estado (completado ou dismissed).
A classe `AnimationController` permite que você
reproduza uma animação para frente ou para trás,
ou pare a animação e defina a animação
para um valor específico para customizar o movimento.

### Como adicionar uma animação simples de fade-in?

No exemplo React Native abaixo, um componente animado,
`FadeInView` é criado usando a Animated API.
O estado de opacidade inicial, estado final e a
duração durante a qual a transição ocorre são definidos.
O componente de animação é adicionado dentro do componente `Animated`,
o estado de opacidade `fadeAnim` é mapeado
para a opacidade do componente `Text` que queremos animar,
e então, `start()` é chamado para iniciar a animação.

```js
// React Native
const FadeInView = ({ style, children }) => {
  const fadeAnim = useRef(new Animated.Value(0)).current;

  useEffect(() => {
    Animated.timing(fadeAnim, {
      toValue: 1,
      duration: 10000
    }).start();
  }, []);

  return (
    <Animated.View style={%raw%}{{ ...style, opacity: fadeAnim }}{%endraw%}>
      {children}
    </Animated.View>
  );
};
    ...
<FadeInView>
  <Text> Fading in </Text>
</FadeInView>
    ...
```

Para criar a mesma animação no Flutter, crie um
objeto [`AnimationController`][] chamado `controller`
e especifique a duração. Por padrão, um `AnimationController`
produz linearmente valores que variam de 0.0 a 1.0,
durante uma duração dada. O controller de animação gera um novo valor
sempre que o dispositivo executando sua app está pronto para exibir um novo frame.
Tipicamente, essa taxa é de cerca de 60 valores por segundo.

Ao definir um `AnimationController`,
você deve passar um objeto `vsync`.
A presença de `vsync` evita que animações offscreen
consumam recursos desnecessários.
Você pode usar seu objeto stateful como o `vsync` adicionando
`TickerProviderStateMixin` à definição da classe.
Um `AnimationController` precisa de um TickerProvider,
que é configurado usando o argumento `vsync` no construtor.

Um [`Tween`][] descreve a interpolação entre um
valor inicial e final ou o mapeamento de um intervalo de entrada
para um intervalo de saída. Para usar um objeto `Tween`
com uma animação, chame o método `animate()` do objeto `Tween`
e passe o objeto `Animation` que você quer modificar.

Para este exemplo, um widget [`FadeTransition`][]
é usado e a propriedade `opacity` é
mapeada para o objeto `animation`.

Para iniciar a animação, use `controller.forward()`.
Outras operações também podem ser realizadas usando o
controller como `fling()` ou `repeat()`.
Para este exemplo, o widget [`FlutterLogo`][]
é usado dentro do widget `FadeTransition`.

<?code-excerpt "lib/animation.dart"?>
```dart
import 'package:flutter/material.dart';

void main() {
  runApp(const Center(child: LogoFade()));
}

class LogoFade extends StatefulWidget {
  const LogoFade({super.key});

  @override
  State<LogoFade> createState() => _LogoFadeState();
}

class _LogoFadeState extends State<LogoFade>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    final CurvedAnimation curve = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: const SizedBox(height: 300, width: 300, child: FlutterLogo()),
    );
  }
}
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/flutter-fade.webp", alt: "Flutter fade", class: "border" %}

### Como adicionar animação de swipe a cards?

No React Native, `PanResponder` ou
bibliotecas de terceiros são usadas para animação de swipe.

No Flutter, para adicionar uma animação de swipe, use o
widget [`Dismissible`][] e aninhe os widgets filhos.

<?code-excerpt "lib/examples.dart (dismissible)"?>
```dart
return Dismissible(
  key: Key(widget.key.toString()),
  onDismissed: (dismissDirection) {
    cards.removeLast();
  },
  child: Container(
    //...
  ),
);
```

{% render "docs/android-ios-figure-pair.md", image: "react-native/card-swipe.webp", alt: "Card swipe", class: "border" %}

[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
[`FadeTransition`]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[`FlutterLogo`]: {{site.api}}/flutter/material/FlutterLogo-class.html
[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html

## Componentes equivalentes de widgets React Native e Flutter

A tabela a seguir lista componentes React Native comumente usados
mapeados para o widget Flutter correspondente
e propriedades de widget comuns.

| React Native Component                                                                    | Flutter Widget                                                                                             | Descrição                                                                                                                            |
| ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| [`Button`](https://reactnative.dev/docs/button)                        | [`ElevatedButton`][]                           | Um botão elevado básico.                                                                              |
|                                                                                           |  onPressed [required]                                                                                        | O callback quando o botão é tocado ou ativado de outra forma.                                                          |
|                                                                                           | Child                                                                              | O rótulo do botão.                                                                                                      |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Button`](https://reactnative.dev/docs/button)                        | [`TextButton`][]                               | Um botão plano básico.                                                                                                         |
|                                                                                           |  onPressed [required]                                                                                        | O callback quando o botão é tocado ou ativado de outra forma.                                                            |
|                                                                                           | Child                                                                              | O rótulo do botão.                                                                                                      |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`ScrollView`](https://reactnative.dev/docs/scrollview)                | [`ListView`][]                                    | Uma lista rolável de widgets organizados linearmente.|
||        children                                                                              | 	( <Widget\> [ ])  Lista de widgets filhos para exibir.
||controller |[ [`ScrollController`][] ] Um objeto que pode ser usado para controlar um widget rolável.
||itemExtent|[ double ] Se não-nulo, força os filhos a ter a extensão dada na direção de rolagem.
||scroll Direction|[ [`Axis`][] ] O eixo ao longo do qual a view de rolagem rola.
||                                                                                                            |                                                                                                                                        |
| [`FlatList`](https://reactnative.dev/docs/flatlist)                    | [`ListView.builder`][]               | O construtor para um array linear de widgets que são criados sob demanda.
||itemBuilder [required] |[[`IndexedWidgetBuilder`][]] ajuda a construir os filhos sob demanda. Este callback é chamado apenas com índices maiores ou iguais a zero e menores que o itemCount.
||itemCount |[ int ] melhora a capacidade do `ListView` de estimar a extensão máxima de rolagem.
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Image`](https://reactnative.dev/docs/image)                         | [`Image`][]                                           | Um widget que exibe uma imagem.                                                                                                       |
|                                                                                           |  image [required]                                                                                          | A imagem a exibir.                                                                                                                  |
|                                                                                           | Image. asset                                                                                                | Vários construtores são fornecidos para as várias maneiras que uma imagem pode ser especificada.                                                 |
|                                                                                           | width, height, color, alignment                                                                            | O estilo e layout para a imagem.                                                                                                         |
|                                                                                           | fit                                                                                                        | Inscrever a imagem no espaço alocado durante o layout.                                                                           |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Modal`](https://reactnative.dev/docs/modal)                          | [`ModalRoute`][]                                | Uma rota que bloqueia a interação com rotas anteriores.                                                                                  |
|                                                                                           | animation                                                                                                  | A animação que conduz a transição da rota e a transição para frente da rota anterior.                                          |
|                                                                                           |                                                                                                            |                                                                                                                                        |
|  [`ActivityIndicator`](https://reactnative.dev/docs/activityindicator) | [`CircularProgressIndicator`][] | Um widget que mostra progresso ao longo de um círculo.                                                                                           |
|                                                                                           | strokeWidth                                                                                                | A largura da linha usada para desenhar o círculo.                                                                                         |
|                                                                                           | backgroundColor                                                                                            | A cor de fundo do indicador de progresso. O `ThemeData.backgroundColor` do tema atual por padrão.                                   |
|                                                                                           |                                                                                                            |                                                                                                                                        |
|  [`ActivityIndicator`](https://reactnative.dev/docs/activityindicator) | [`LinearProgressIndicator`][]     | Um widget que mostra progresso ao longo de uma linha.                                                                                           |
|                                                                                           | value                                                                                                      | O valor deste indicador de progresso.                                                                                                   |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`RefreshControl`](https://reactnative.dev/docs/refreshcontrol)        | [`RefreshIndicator`][]                   | Um widget que suporta o idioma Material "swipe to refresh".                                                                          |
|                                                                                           | color                                                                                                      | A cor de primeiro plano do indicador de progresso.                                                                                             |
|                                                                                           | onRefresh                                                                                                  | Uma função que é chamada quando um usuário arrasta o indicador de refresh longe o suficiente para demonstrar que quer que a app atualize.  |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://reactnative.dev/docs/view)                            | [`Container`][]                                  | Um widget que envolve um widget filho.                                                                                                                |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://reactnative.dev/docs/view)                            | [`Column`][]                                        | Um widget que exibe seus filhos em um array vertical.                                                                                              |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://reactnative.dev/docs/view)                            | [`Row`][]                                              | Um widget que exibe seus filhos em um array horizontal.                                                                                            |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://reactnative.dev/docs/view)                            | [`Center`][]                                        | Um widget que centraliza seu filho dentro de si mesmo.                                                                                                       |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://reactnative.dev/docs/view)                            | [`Padding`][]                                      | Um widget que inseta seu filho pelo padding dado.                                                                                                 |
|                                                                                           | padding [required]                                                                                         | [ EdgeInsets ] A quantidade de espaço para insetar o filho.
|||
| [`TouchableOpacity`](https://reactnative.dev/docs/touchableopacity)    | [`GestureDetector`][]                      | Um widget que detecta gestos.                                                                                                                       |
|                                                                                           | onTap                                                                                                      | Um callback quando um toque ocorre.                                                                                                               |
|                                                                                           | onDoubleTap                                                                                                | Um callback quando um toque ocorre no mesmo local duas vezes em rápida sucessão.
|||
| [`TextInput`](https://reactnative.dev/docs/textinput)                | [`TextInput`][]                                   | A interface para o controle de entrada de texto do sistema.                                                                                           |
|                                                                                           | controller                                                                                                 | [ [`TextEditingController`][] ] usado para acessar e modificar texto.
|||
| [`Text`](https://reactnative.dev/docs/text)                          | [`Text`][]                                            | O widget Text que exibe uma string de texto com um único estilo.                                                                                                                                                                           |
|                                                                                         | data                                                                                                      | [ String ] O texto a exibir.                                                                                                                                                                              |
|                                                                                         | textDirection                                                                                             | [ [`TextAlign`][] ] A direção na qual o texto flui.                                                                                     |
|                                                                                         |                                                                                                           |                                                                                                                                                                                                              |
| [`Switch`](https://reactnative.dev/docs/switch)                      | [`Switch`][]                                      | Um switch material design.                                                                                                                                                                                    |
|                                                                                         | value [required]                                                                                          | [ boolean ] Se este switch está ligado ou desligado.                                                                                                                                                                 |
|                                                                                         | onChanged [required]                                                                                      | [ callback ] Chamado quando o usuário alterna o switch para ligado ou desligado.                                                                                                                                               |

{:.table .table-striped}


[`AboutDialog`]: {{site.api}}/flutter/material/AboutDialog-class.html
[`Axis`]: {{site.api}}/flutter/painting/Axis.html
[`CircularProgressIndicator`]: {{site.api}}/flutter/material/CircularProgressIndicator-class.html
[Flutter Architectural Overview]: /resources/architectural-overview
[`IndexedWidgetBuilder`]: {{site.api}}/flutter/widgets/IndexedWidgetBuilder.html
[`LinearProgressIndicator`]: {{site.api}}/flutter/material/LinearProgressIndicator-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[`ModalRoute`]: {{site.api}}/flutter/widgets/ModalRoute-class.html
[`RefreshIndicator`]: {{site.api}}/flutter/material/RefreshIndicator-class.html
[`ScrollController`]: {{site.api}}/flutter/widgets/ScrollController-class.html
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`TextAlign`]: {{site.api}}/flutter/dart-ui/TextAlign.html
[`TextInput`]: {{site.api}}/flutter/services/TextInput-class.html