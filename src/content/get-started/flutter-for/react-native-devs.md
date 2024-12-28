---
ia-translate: true
título: Flutter para Desenvolvedores React Native
descrição: Aprenda como aplicar o conhecimento de desenvolvedor React Native ao construir aplicativos Flutter.
---

<?code-excerpt path-base="get-started/flutter-for/react_native_devs"?>

Este documento é para desenvolvedores React Native (RN) que procuram aplicar seus
conhecimentos existentes em RN para construir aplicativos móveis com Flutter. Se você entende
os fundamentos do framework RN, então você pode usar este documento como uma
maneira de começar a aprender o desenvolvimento Flutter.

Este documento pode ser usado como um livro de receitas, navegando e encontrando
perguntas que são mais relevantes para suas necessidades.

## Introdução ao Dart para Desenvolvedores JavaScript (ES6)

Assim como o React Native, o Flutter usa visualizações em estilo reativo. No entanto, enquanto o RN
transcompila para widgets nativos, o Flutter compila totalmente para código nativo.
O Flutter controla cada pixel na tela, o que evita problemas de desempenho
causados pela necessidade de uma ponte JavaScript.

Dart é uma linguagem fácil de aprender e oferece os seguintes recursos:

* Fornece uma linguagem de programação de código aberto e escalável para construir web,
  servidor e aplicativos móveis.
* Fornece uma linguagem orientada a objetos, de herança única, que usa uma sintaxe de estilo C
  que é compilada em AOT para nativo.
* Transcompila opcionalmente para JavaScript.
* Suporta interfaces e classes abstratas.

Alguns exemplos das diferenças entre JavaScript e Dart são descritos
abaixo.

### Ponto de entrada

JavaScript não possui uma função de entrada
predefinida &mdash; você define o ponto de entrada.

```js
// JavaScript
function startHere() {
  // Pode ser usado como ponto de entrada
}
```

Em Dart, todo aplicativo deve ter uma função `main()` de nível superior que serve como
ponto de entrada para o aplicativo.

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
console.log('Olá mundo!');
```

<?code-excerpt "lib/main.dart (print)"?>
```dart
/// Dart
print('Olá mundo!');
```

Experimente no [DartPad][DartPadB].

### Variáveis

Dart é type safe &mdash; ele usa uma combinação de verificação de tipo estática
e verificações em tempo de execução para garantir que o valor de uma variável sempre corresponda
ao tipo estático da variável. Embora os tipos sejam obrigatórios,
algumas anotações de tipo são opcionais porque
Dart realiza inferência de tipo.

#### Criando e atribuindo variáveis

Em JavaScript, as variáveis não podem ser tipadas.

Em [Dart][], as variáveis devem ser explicitamente
tipadas ou o sistema de tipos deve inferir o tipo adequado automaticamente.

```js
// JavaScript
let name = 'JavaScript';
```

<?code-excerpt "lib/main.dart (variables)"?>
```dart
/// Dart
/// Ambas as variáveis são aceitáveis.
String name = 'dart'; // Explicitamente tipado como [String].
var otherName = 'Dart'; // Tipo [String] inferido.
```

Experimente no [DartPad][DartPadC].

Para mais informações, consulte [Dart's Type System][].

#### Valor padrão

Em JavaScript, variáveis não inicializadas são `undefined`.

Em Dart, variáveis não inicializadas têm um valor inicial de `null`.
Como os números são objetos em Dart, até mesmo variáveis não inicializadas com
tipos numéricos têm o valor `null`.

:::note
A partir da versão 2.12, o Dart suporta [Sound Null Safety][],
todos os tipos são não anuláveis por padrão,
que devem ser inicializados como um valor não anulável.
:::

```js
// JavaScript
let name; // == undefined
```

<?code-excerpt "lib/main.dart (null)"?>
```dart
// Dart
var name; // == null; gera um aviso do linter
int? x; // == null
```

Experimente no [DartPad][DartPadD].

Para mais informações, consulte a documentação sobre
[variáveis][].

### Verificando por nulo ou zero

Em JavaScript, valores de 1 ou qualquer objeto não nulo
são tratados como `true` ao usar o operador de comparação `==`.

```js
// JavaScript
let myNull = null;
if (!myNull) {
  console.log('nulo é tratado como falso');
}
let zero = 0;
if (!zero) {
  console.log('0 é tratado como falso');
}
```

Em Dart, apenas o valor booleano `true` é tratado como verdadeiro.

<?code-excerpt "lib/main.dart (true)"?>
```dart
/// Dart
var myNull;
var zero = 0;
if (zero == 0) {
  print('use "== 0" para verificar zero');
}
```

Experimente no [DartPad][DartPadE].

### Funções

As funções Dart e JavaScript são geralmente semelhantes.
A principal diferença é a declaração.

```js
// JavaScript
function fn() {
  return true;
}
```

<?code-excerpt "lib/main.dart (function)"?>
```dart
/// Dart
/// Você pode definir explicitamente o tipo de retorno.
bool fn() {
  return true;
}
```

Experimente no [DartPad][DartPadF].

Para mais informações, consulte a documentação sobre
[funções][].

### Programação assíncrona

#### Futures

Assim como o JavaScript, o Dart suporta execução em uma única thread. Em JavaScript,
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

Para mais informações, consulte a documentação sobre
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

Em Dart, uma função `async` retorna um `Future`,
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

/// Uma função async retorna um `Future`.
/// Ela também pode retornar `void`, a menos que você use
/// o lint `avoid_void_async`. Nesse caso,
/// retorne `Future<void>`.
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

Para mais informações, consulte a documentação para [async e await][].

## O básico

### Como eu crio um aplicativo Flutter?

Para criar um aplicativo usando React Native,
você executaria `create-react-native-app` na linha de comando.

```console
$ create-react-native-app <projectname>
```

Para criar um aplicativo em Flutter, faça um dos seguintes:

* Use uma IDE com os plugins Flutter e Dart instalados.
* Use o comando `flutter create` na linha de comando. Certifique-se de que o
  Flutter SDK está em seu PATH.

```console
$ flutter create <projectname>
```

Para mais informações, consulte [Primeiros passos][], que
orienta você na criação de um aplicativo de contador de cliques de botão.
A criação de um projeto Flutter constrói todos os arquivos que você
precisa para executar um aplicativo de exemplo em dispositivos Android e iOS.

### Como eu executo meu aplicativo?

Em React Native, você executaria `npm run` ou `yarn run` no
diretório do projeto.

Você pode executar aplicativos Flutter de algumas maneiras:

* Use a opção "run" em uma IDE com os plugins Flutter e Dart.
* Use `flutter run` no diretório raiz do projeto.

Seu aplicativo é executado em um dispositivo conectado, no simulador iOS,
ou no emulador Android.

Para mais informações, consulte a documentação
[Primeiros passos][] do Flutter.

### Como eu importo widgets?

Em React Native, você precisa importar cada componente necessário.

```js
// React Native
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
```

Em Flutter, para usar widgets da biblioteca Material Design,
importe o pacote `material.dart`. Para usar widgets de estilo iOS,
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

Qualquer que seja o pacote de widgets que você importe,
Dart puxa apenas os widgets que são usados em seu aplicativo.

Para mais informações, consulte o [Catálogo de Widgets do Flutter][].

### Qual é o equivalente do aplicativo "Hello world!" do React Native em Flutter?

Em React Native, a classe `HelloWorldApp` estende `React.Component` e
implementa o método de renderização retornando um componente de visualização.

```js
// React Native
import React from 'react';
import { StyleSheet, Text, View } from 'react-native';

const App = () => {
  return (
    <View style={styles.container}>
      <Text>Olá mundo!</Text>
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

Em Flutter, você pode criar um aplicativo "Olá mundo!" idêntico usando os
widgets `Center` e `Text` da biblioteca de widgets principal.
O widget `Center` se torna a raiz da árvore de widgets e tem um filho,
o widget `Text`.

<?code-excerpt "lib/hello_world.dart"?>
```dart
// Flutter
import 'package:flutter/material.dart';

void main() {
  runApp(
    const Center(
      child: Text(
        'Olá, mundo!',
        textDirection: TextDirection.ltr,
      ),
    ),
  );
}
```

As imagens a seguir mostram a interface do usuário Android e iOS para o
aplicativo Flutter básico "Olá mundo!".

{% include docs/android-ios-figure-pair.md image="react-native/hello-world-basic.png" alt="Hello world app" class="border" %}

Agora que você viu o aplicativo Flutter mais básico, a próxima seção mostra como
aproveitar as ricas bibliotecas de widgets do Flutter para criar um aplicativo
moderno e refinado.

### Como eu uso widgets e os aninho para formar uma árvore de widgets?

Em Flutter, quase tudo é um widget.

Widgets são os blocos de construção básicos da interface do usuário de um aplicativo.
Você compõe widgets em uma hierarquia, chamada de árvore de widgets.
Cada widget se aninha dentro de um widget pai
e herda propriedades de seu pai.
Até mesmo o próprio objeto do aplicativo é um widget.
Não há um objeto "aplicação" separado.
Em vez disso, o widget raiz serve para essa função.

Um widget pode definir:

* Um elemento estrutural &mdash; como um botão ou menu
* Um elemento estilístico &mdash; como uma fonte ou esquema de cores
* Um aspecto do layout &mdash; como preenchimento ou alinhamento

O exemplo a seguir mostra o aplicativo "Olá mundo!" usando widgets da
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
      title: 'Bem-vindo ao Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Bem-vindo ao Flutter'),
        ),
        body: const Center(
          child: Text('Olá mundo'),
        ),
      ),
    );
  }
}
```

As imagens a seguir mostram "Olá mundo!" construído com widgets do Material Design.
Você obtém mais funcionalidade automaticamente  do que no aplicativo básico "Olá mundo!".

{% include docs/android-ios-figure-pair.md image="react-native/hello-world.png" alt="Hello world app" %}

Ao escrever um aplicativo, você usará dois tipos de widgets:
[`StatelessWidget`][] ou [`StatefulWidget`][].
Um `StatelessWidget` é exatamente o que parece &mdash; um
widget sem estado. Um `StatelessWidget` é criado uma vez,
e nunca muda sua aparência.
Um `StatefulWidget` muda dinamicamente o estado com base nos dados
recebidos ou na entrada do usuário.

A diferença importante entre widgets stateless e stateful
é que os `StatefulWidget`s têm um objeto `State`
que armazena dados de estado e os transporta
através de reconstruções da árvore, para que não sejam perdidos.

Em aplicativos simples ou básicos, é fácil aninhar widgets,
mas à medida que a base de código fica maior e o aplicativo se torna complexo,
você deve dividir widgets profundamente aninhados em
funções que retornam o widget ou classes menores.
Criar funções separadas
e widgets permite que você reutilize os componentes dentro do aplicativo.

### Como eu crio componentes reutilizáveis?

Em React Native, você definiria uma classe para criar um
componente reutilizável e, em seguida, usaria métodos `props` para definir
ou retornar propriedades e valores dos elementos selecionados.
No exemplo abaixo, a classe `CustomCard` é definida
e então usada dentro de uma classe pai.

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

// Uso
<CustomCard onPress={this.onPress} index={item.key} />
```

Em Flutter, defina uma classe para criar um widget personalizado e, em seguida, reutilize o
widget. Você também pode definir e chamar uma função que retorna um
widget reutilizável, como mostrado na função `build` no exemplo a seguir.

<?code-excerpt "lib/components.dart (components)"?>
```dart
/// Flutter
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.index,
    required this.onPress,
  });

  final int index;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('Card $index'),
          TextButton(
            onPressed: onPress,
            child: const Text('Press'),
          ),
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
    /// Uso
    return CustomCard(
      index: index,
      onPress: () {
        print('Card $index');
      },
    );
  }
}
```

No exemplo anterior, o construtor para a classe `CustomCard`
usa a sintaxe de chaves `{ }` do Dart para indicar [parâmetros nomeados][].

Para exigir esses campos, remova as chaves do
construtor ou adicione `required` ao construtor.

As capturas de tela a seguir mostram um exemplo da classe
`CustomCard` reutilizável.

{% include docs/android-ios-figure-pair.md image="react-native/custom-cards.png" alt="Custom cards" class="border" %}

## Estrutura do projeto e recursos

### Onde eu começo a escrever o código?

Comece com o arquivo `lib/main.dart`.
Ele é gerado automaticamente quando você cria um aplicativo Flutter.

<?code-excerpt "lib/examples.dart (main)"?>
```dart
// Dart
void main() {
  print('Olá, esta é a função principal.');
}
```

Em Flutter, o arquivo de ponto de entrada é
`{project_name}/lib/main.dart` e a execução
começa a partir da função `main`.

### Como os arquivos são estruturados em um aplicativo Flutter?

Quando você cria um novo projeto Flutter,
ele constrói a seguinte estrutura de diretório.
Você pode personalizá-la posteriormente, mas é aqui que você começa.

```plaintext
┬
└ project_name
  ┬
  ├ android      - Contém arquivos específicos do Android.
  ├ build        - Armazena arquivos de build do iOS e Android.
  ├ ios          - Contém arquivos específicos do iOS.
  ├ lib          - Contém arquivos de origem Dart acessíveis externamente.
    ┬
    └ src        - Contém arquivos de origem adicionais.
    └ main.dart  - O ponto de entrada do Flutter e o início de um novo aplicativo.
                   Isso é gerado automaticamente quando você cria um projeto Flutter.
                   É onde você começa a escrever seu código Dart.
  ├ test         - Contém arquivos de teste automatizados.
  └ pubspec.yaml - Contém os metadados para o aplicativo Flutter.
                   Isso é equivalente ao arquivo package.json no React Native.
```

### Onde eu coloco meus recursos e ativos (assets) e como eu os uso?

Um recurso ou ativo do Flutter é um arquivo que é empacotado e implantado
com seu aplicativo e é acessível em tempo de execução.
Os aplicativos Flutter podem incluir os seguintes tipos de assets:

* Dados estáticos, como arquivos JSON
* Arquivos de configuração
* Ícones e imagens (JPEG, PNG, GIF, GIF animado, WebP, WebP animado, BMP,
  e WBMP)

Flutter usa o arquivo `pubspec.yaml`,
localizado na raiz do seu projeto, para
identificar assets exigidos por um aplicativo.

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

A subseção `assets` especifica os arquivos que devem ser incluídos com o aplicativo.  
Cada ativo é identificado por um caminho explícito relativo
ao arquivo `pubspec.yaml`, onde o arquivo do ativo está localizado.  
A ordem em que os ativos são declarados não importa.  
O diretório utilizado (`assets`, neste caso) também não importa.  
No entanto, embora os ativos possam ser colocados em qualquer diretório
do aplicativo, é uma boa prática organizá-los no diretório `assets`.  

Durante a construção do aplicativo (build), o Flutter coloca os ativos em um
arquivo especial chamado *asset bundle*, que os aplicativos acessam durante a execução.  
Quando o caminho de um ativo é especificado na seção `assets` do `pubspec.yaml`,
o processo de build procura por arquivos com o mesmo nome em subdiretórios relacionados.  
Esses arquivos também são incluídos no *asset bundle* junto
com o ativo especificado.  
O Flutter utiliza variantes de ativos ao selecionar imagens
com resoluções apropriadas para o aplicativo.  

No React Native, você adicionaria uma imagem estática colocando
o arquivo de imagem em um diretório do código-fonte e referenciando-o.  

```js
<Image source={require('./my-icon.png')} />
// OU
<Image
  source={%raw%}{{
    url: 'https://reactnative.dev/img/tiny_logo.png'
  }}{%endraw%}
/>
```

Em Flutter, adicione uma imagem estática ao seu aplicativo
usando o construtor `Image.asset` no método de construção de um widget.

<?code-excerpt "lib/examples.dart (image-asset)" replace="/return //g"?>
```dart
Image.asset('assets/background.png');
```

Para mais informações, consulte [Adicionando Ativos e Imagens no Flutter][].

### Como eu carrego imagens pela rede?

Em React Native, você especificaria o `uri` na
propriedade `source` do componente `Image` e também forneceria o
tamanho, se necessário.

Em Flutter, use o construtor `Image.network` para incluir
uma imagem de um URL.

<?code-excerpt "lib/examples.dart (image-network)" replace="/return //g"?>
```dart
Image.network('https://docs.flutter.dev/assets/images/docs/owl.jpg');
```

### Como eu instalo pacotes e plugins de pacotes?

O Flutter suporta o uso de pacotes compartilhados contribuídos por outros
desenvolvedores para os ecossistemas Flutter e Dart. Isso permite que você
construa rapidamente seu aplicativo sem ter que desenvolver tudo do zero.
Pacotes que contêm código específico da plataforma são conhecidos como plugins de pacotes.

Em React Native, você usaria `yarn add {package-name}` ou
`npm install --save {package-name}` para instalar pacotes
pela linha de comando.

Em Flutter, instale um pacote usando as seguintes instruções:

1. Para adicionar o pacote `google_sign_in` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add google_sign_in
```

2. Instale o pacote a partir da linha de comando usando `flutter pub get`.
   Se estiver usando uma IDE, ela geralmente executa `flutter pub get` para você, ou pode
   solicitar que você o faça.
3. Importe o pacote para o código do seu aplicativo, conforme mostrado abaixo:

<?code-excerpt "lib/examples.dart (package-import)"?>
```dart
import 'package:flutter/material.dart';
```

Para mais informações, consulte [Usando Pacotes][] e
[Desenvolvendo Pacotes e Plugins][].

Você pode encontrar muitos pacotes compartilhados por desenvolvedores Flutter na
seção [Pacotes Flutter][] do [pub.dev][].

## Widgets Flutter

Em Flutter, você constrói sua interface do usuário a partir de widgets que
descrevem como sua visualização deve se parecer, dada sua configuração e estado atuais.

Os widgets são frequentemente compostos por muitos widgets pequenos e
de propósito único que são aninhados para produzir efeitos poderosos.
Por exemplo, o widget `Container` consiste em
vários widgets responsáveis pelo layout, pintura, posicionamento e dimensionamento.
Especificamente, o widget `Container` inclui os widgets `LimitedBox`,
`ConstrainedBox`, `Align`, `Padding`, `DecoratedBox` e `Transform`.
Em vez de subclassificar `Container` para produzir um efeito personalizado, você pode
compor esses e outros widgets simples de maneiras novas e exclusivas.

O widget `Center` é outro exemplo de como você pode controlar o layout.
Para centralizar um widget, envolva-o em um widget `Center` e, em seguida, use widgets de layout
para alinhamento, linha, colunas e grades.
Esses widgets de layout não têm uma representação visual própria.
Em vez disso, seu único objetivo é controlar algum aspecto do layout de outro
widget. Para entender por que um widget é renderizado de uma
determinada maneira, geralmente é útil inspecionar os widgets vizinhos.

Para mais informações, consulte a [Visão Geral Técnica do Flutter][].

Para mais informações sobre os widgets principais do pacote `Widgets`,
consulte [Widgets Básicos do Flutter][],
o [Catálogo de Widgets do Flutter][]
ou o [Índice de Widgets do Flutter][].

## Visualizações

### Qual é o equivalente do contêiner `View`?

Em React Native, `View` é um contêiner que suporta layout com `Flexbox`,
estilo, manipulação de toque e controles de acessibilidade.

Em Flutter, você pode usar os widgets de layout principais na biblioteca `Widgets`,
como [`Container`][], [`Column`][],
[`Row`][] e [`Center`][].
Para mais informações, consulte o catálogo [Widgets de Layout][].

### Qual é o equivalente de `FlatList` ou `SectionList`?

Uma `List` é uma lista rolável de componentes dispostos verticalmente.

Em React Native, `FlatList` ou `SectionList` são usados para renderizar listas simples ou
seccionadas.

```js
// React Native
<FlatList
  data={[ ... ]}
  renderItem={({ item }) => <Text>{item.key}</Text>}
/>
```

[`ListView`][] é o widget de rolagem mais comumente usado do Flutter.
O construtor padrão leva uma lista explícita de filhos (children).
[`ListView`][] é mais apropriado para um pequeno número de widgets.
Para uma lista grande ou infinita, use `ListView.builder`,
que constrói seus filhos sob demanda e constrói apenas
aqueles filhos que são visíveis.

<?code-excerpt "lib/examples.dart (list-view)"?>
```dart
var data = [
  'Olá',
  'Mundo',
];
return ListView.builder(
  itemCount: data.length,
  itemBuilder: (context, index) {
    return Text(data[index]);
  },
);
```

{% include docs/android-ios-figure-pair.md image="react-native/flatlist.gif" alt="Flat list" class="border" %}

Para aprender como implementar uma lista de rolagem infinita, consulte o exemplo oficial
[`infinite_list`][infinite_list].

### Como eu uso um Canvas para desenhar ou pintar?

Em React Native, os componentes de canvas não estão presentes,
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

Em Flutter, você pode usar as classes [`CustomPaint`][]
e [`CustomPainter`][] para desenhar no canvas.

O exemplo a seguir mostra como desenhar durante a fase de pintura usando o
widget `CustomPaint`. Ele implementa a classe abstrata, `CustomPainter`,
e a passa para a propriedade painter de `CustomPaint`.
As subclasses `CustomPaint` devem implementar os métodos `paint()`
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
    return const Scaffold(
      body: CustomPaint(painter: MyCanvasPainter()),
    );
  }
}
```

{% include docs/android-ios-figure-pair.md image="react-native/canvas.png" alt="Canvas" class="border" %}

## Layouts

### Como eu uso widgets para definir propriedades de layout?

Em React Native, a maior parte do layout pode ser feita com as propriedades
que são passadas para um componente específico.
Por exemplo, você pode usar a propriedade `style` no componente `View`
para especificar as propriedades do flexbox.
Para organizar seus componentes em uma coluna, você especificaria uma propriedade como:
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

Em Flutter, o layout é definido principalmente por widgets
projetados especificamente para fornecer layout,
combinados com widgets de controle e suas propriedades de estilo.

Por exemplo, os widgets [`Column`][] e [`Row`][]
recebem um array de filhos e os alinham
verticalmente e horizontalmente, respectivamente.
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
        Container(
          color: Colors.red,
          width: 100,
          height: 100,
        ),
        Container(
          color: Colors.blue,
          width: 100,
          height: 100,
        ),
        Container(
          color: Colors.green,
          width: 100,
          height: 100,
        ),
      ],
    ),
  );
```

O Flutter fornece uma variedade de widgets de layout em sua biblioteca de widgets principal.
Por exemplo, [`Padding`][], [`Align`][] e [`Stack`][].

Para uma lista completa, consulte [Widgets de Layout][].

{% include docs/android-ios-figure-pair.md image="react-native/basic-layout.gif" alt="Layout" class="border" %}

### Como sobrepor widgets?

Em React Native, os componentes podem ser sobrepostos usando posicionamento `absolute`.

O Flutter usa o widget [`Stack`][]
para organizar widgets filhos em camadas.
Os widgets podem sobrepor-se total ou parcialmente ao widget base.

O widget `Stack` posiciona seus filhos em relação às bordas de sua caixa.
Essa classe é útil se você simplesmente quiser sobrepor vários widgets filhos.

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
      Container(
        color: Colors.black45,
        child: const Text('Flutter'),
      ),
    ],
  );
```

O exemplo anterior usa `Stack` para sobrepor um Container
(que exibe seu `Text` em um fundo preto translúcido)
em cima de um `CircleAvatar`.
O Stack desloca o texto usando a propriedade alignment
e as coordenadas `Alignment`.

{% include docs/android-ios-figure-pair.md image="react-native/stack.png" alt="Stack" class="border" %}

Para mais informações, veja a documentação da classe [`Stack`][].

## Estilização

### Como estilizar meus componentes?

Em React Native, estilização inline e `stylesheets.create`
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
para sua propriedade style. Se você quiser usar o mesmo estilo de
texto em vários lugares, você pode criar uma classe
[`TextStyle`][] e usá-la para vários widgets `Text`.

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

{% include docs/android-ios-figure-pair.md image="react-native/flutterstyling.gif" alt="Styling" class="border" %}

### Como usar `Icons` e `Colors`?

React Native não inclui suporte para ícones,
então bibliotecas de terceiros são usadas.

No Flutter, importar a biblioteca Material também traz um rico
conjunto de [ícones do Material][] e [cores][].

<?code-excerpt "lib/examples.dart (icon)"?>
```dart
return const Icon(Icons.lightbulb_outline, color: Colors.redAccent);
```

Ao usar a classe `Icons`,
certifique-se de definir `uses-material-design: true` no
arquivo `pubspec.yaml` do projeto.
Isso garante que a fonte `MaterialIcons`,
que exibe os ícones, seja incluída no seu aplicativo.
Em geral, se você pretende usar a biblioteca Material,
você deve incluir esta linha.

```yaml
name: my_awesome_application
flutter:
  uses-material-design: true
```

O pacote [Cupertino (estilo iOS)][] do Flutter fornece
widgets de alta fidelidade para a linguagem de design atual do iOS.
Para usar a fonte `CupertinoIcons`,
adicione uma dependência para `cupertino_icons` no arquivo
`pubspec.yaml` do seu projeto.

```yaml
name: my_awesome_application
dependencies:
  cupertino_icons: ^1.0.8
```

Para personalizar globalmente as cores e estilos dos componentes,
use `ThemeData` para especificar cores padrão
para vários aspectos do tema.
Defina a propriedade theme em `MaterialApp` para o objeto `ThemeData`.
A classe [`Colors`][] fornece cores
da [paleta de cores][] do Material Design.

O exemplo a seguir define o esquema de cores da semente para
`deepPurple` e a seleção de texto para `red`.

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
          textSelectionTheme:
              const TextSelectionThemeData(selectionColor: Colors.red)),
      home: const SampleAppPage(),
    );
  }
}
```

### Como adicionar temas de estilo?

Em React Native, temas comuns são definidos para
componentes em folhas de estilo e então usados em componentes.

No Flutter, crie um estilo uniforme para quase tudo
definindo o estilo na classe [`ThemeData`][]
e passando-o para a propriedade theme no
widget [`MaterialApp`][].

<?code-excerpt "lib/examples.dart (theme)"?>
```dart
@override
Widget build(BuildContext context) {
  return MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.cyan,
      brightness: Brightness.dark,
    ),
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
    data: ThemeData(
      primaryColor: Colors.cyan,
      brightness: brightness,
    ),
    child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      //...
    ),
  );
}
```

## Gerenciamento de estado

Estado é informação que pode ser lida de forma síncrona
quando um widget é construído ou informação
que pode mudar durante o tempo de vida de um widget.
Para gerenciar o estado do aplicativo no Flutter,
use um [`StatefulWidget`][] combinado com um objeto State.

Para mais informações sobre formas de abordar o gerenciamento de estado no Flutter,
veja [Gerenciamento de estado][].

### O StatelessWidget

Um `StatelessWidget` no Flutter é um widget
que não requer uma mudança de estado&mdash;
ele não tem estado interno para gerenciar.

Widgets sem estado (stateless widgets) são úteis quando a parte da interface do usuário
que você está descrevendo não depende de nada além da
informação de configuração no próprio objeto e do
[`BuildContext`][] no qual o widget é renderizado.

[`AboutDialog`][], [`CircleAvatar`][] e [`Text`][] são exemplos
de widgets stateless que são subclasses de [`StatelessWidget`][].

<?code-excerpt "lib/stateless.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(
      const MyStatelessWidget(
        text: 'StatelessWidget Example to show immutable data',
      ),
    );

class MyStatelessWidget extends StatelessWidget {
  const MyStatelessWidget({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        textDirection: TextDirection.ltr,
      ),
    );
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
* Quando um [`InheritedWidget`][] do qual ele depende muda

### O StatefulWidget

Um [`StatefulWidget`][] é um widget que muda de estado.
Use o método `setState` para gerenciar as
mudanças de estado para um `StatefulWidget`.
Uma chamada para `setState()` diz ao framework
Flutter que algo mudou em um estado,
o que faz com que um aplicativo execute novamente o método `build()`
para que o aplicativo possa refletir a mudança.

_Estado_ é informação que pode ser lida de forma síncrona quando um widget
é construído e pode mudar durante o tempo de vida do widget.
É responsabilidade do implementador do widget garantir que
o objeto de estado seja prontamente notificado quando o estado mudar.
Use `StatefulWidget` quando um widget puder mudar dinamicamente.
Por exemplo, o estado do widget muda ao digitar em um formulário,
ou ao mover um slider.
Ou, ele pode mudar com o tempo—como quando um feed de dados atualiza a UI.

[`Checkbox`][], [`Radio`][], [`Slider`][], [`InkWell`][],
[`Form`][] e [`TextField`][]
são exemplos de widgets stateful que são subclasses de
[`StatefulWidget`][].

O exemplo a seguir declara um `StatefulWidget`
que requer um método `createState()`.
Este método cria o objeto de estado que gerencia o estado do widget,
`_MyStatefulWidgetState`.

<?code-excerpt "lib/stateful.dart (stateful-widget)"?>
```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
    required this.title,
  });

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
              const Text(
                'This execution will be done before you can blink.',
              ),
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

### What are the StatefulWidget and StatelessWidget best practices?

Here are a few things to consider when designing your widget.

1. Determine whether a widget should be
   a `StatefulWidget` or a `StatelessWidget`.

In Flutter, widgets are either Stateful or Stateless—depending on whether
they depend on a state change.

* If a widget changes&mdash;the user interacts with it or
  a data feed interrupts the UI, then it's *Stateful*.
* If a widget is final or immutable, then it's *Stateless*.

2. Determine which object manages the widget's state (for a `StatefulWidget`).

In Flutter, there are three primary ways to manage state:

* The widget manages its own state
* The parent widget manages the widget's state
* A mix-and-match approach

When deciding which approach to use, consider the following principles:

* If the state in question is user data,
  for example the checked or unchecked mode of a checkbox,
  or the position of a slider, then the state is best managed
  by the parent widget.
* If the state in question is aesthetic, for example an animation,
  then the widget itself best manages the state.
* When in doubt, let the parent widget manage the child widget's state.

3. Subclass StatefulWidget and State.

The `MyStatefulWidget` class manages its own state&mdash;it extends
`StatefulWidget`, it overrides the `createState()`
method to create the `State` object,
and the framework calls `createState()` to build the widget.
In this example, `createState()` creates an instance of
`_MyStatefulWidgetState`, which
is implemented in the next best practice.

<?code-excerpt "lib/best_practices.dart (create-state)" replace="/return const Text\('Hello World!'\);/\/\/.../g"?>
```dart
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({
    super.key,
    required this.title,
  });

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

4. Add the StatefulWidget into the widget tree.

Add your custom `StatefulWidget` to the widget tree
in the app's build method.

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

{% include docs/android-ios-figure-pair.md image="react-native/state-change.gif" alt="State change" class="border" %}

## Props

In React Native, most components can be customized when they are
created with different parameters or properties, called `props`.
These parameters can be used in a child component using `this.props`.

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

In Flutter, you assign a local variable or function marked
`final` with the property received in the parameterized constructor.

<?code-excerpt "lib/components.dart (components)"?>
```dart
/// Flutter
class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.index,
    required this.onPress,
  });

  final int index;
  final void Function() onPress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Text('Card $index'),
          TextButton(
            onPressed: onPress,
            child: const Text('Press'),
          ),
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

{% include docs/android-ios-figure-pair.md image="react-native/modular.png" alt="Cards" class="border" %}

## Local storage

If you don't need to store a lot of data, and it doesn't require
structure, you can use `shared_preferences` which allows you to
read and write persistent key-value pairs of primitive data
types: booleans, floats, ints, longs, and strings.

### How do I store persistent key-value pairs that are global to the app?

In React Native, you use the `setItem` and `getItem` functions
of the `AsyncStorage` component to store and retrieve data
that is persistent and global to the app.

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

In Flutter, use the [`shared_preferences`][] plugin to
store and retrieve key-value data that is persistent and global
to the app. The `shared_preferences` plugin wraps
`NSUserDefaults` on iOS and `SharedPreferences` on Android,
providing a persistent store for simple data.

To add the `shared_preferences` package as a dependency, run `flutter pub add`:

```console
$ flutter pub add shared_preferences
```

<?code-excerpt "lib/examples.dart (shared-prefs)"?>
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

To implement persistent data, use the setter methods
provided by the `SharedPreferences` class.
Setter methods are available for various primitive
types, such as `setInt`, `setBool`, and `setString`.
To read data, use the appropriate getter method provided
by the `SharedPreferences` class. For each
setter there is a corresponding getter method,
for example, `getInt`, `getBool`, and `getString`.

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

## Routing

Most apps contain several screens for displaying different
types of information. For example, you might have a product
screen that displays images where users could tap on a product
image to get more information about the product on a new screen.

In Android, new screens are new Activities.
In iOS, new screens are new ViewControllers. In Flutter,
screens are just Widgets! And to navigate to new
screens in Flutter, use the Navigator widget.

### How do I navigate between screens?

In React Native, there are three main navigators:
StackNavigator, TabNavigator, and DrawerNavigator.
Each provides a way to configure and define the screens.

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

In Flutter, there are two main widgets used to navigate between screens:

* A [`Route`][] is an abstraction for an app screen or page.
* A [`Navigator`][] is a widget that manages routes.

A `Navigator` is defined as a widget that manages a set of child
widgets with a stack discipline. The navigator manages a stack
of `Route` objects and provides methods for managing the stack,
like [`Navigator.push`][] and [`Navigator.pop`][].
A list of routes might be specified in the [`MaterialApp`][] widget,
or they might be built on the fly, for example, in hero animations.
The following example specifies named routes in the `MaterialApp` widget.

:::note
Named routes are no longer recommended for most
applications. For more information, see
[Limitations][] in the [navigation overview][] page.
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

To navigate to a named route, the [`Navigator.of()`][]
method is used to specify the `BuildContext`
(a handle to the location of a widget in the widget tree).
The name of the route is passed to the `pushNamed` function to
navigate to the specified route.

<?code-excerpt "lib/navigation.dart (push-named)"?>
```dart
Navigator.of(context).pushNamed('/a');
```

You can also use the push method of `Navigator` which
adds the given [`Route`][] to the history of the
navigator that most tightly encloses the given [`BuildContext`][],
and transitions to it. In the following example,
the [`MaterialPageRoute`][] widget is a modal route that
replaces the entire screen with a platform-adaptive
transition. It takes a [`WidgetBuilder`][] as a required parameter.

<?code-excerpt "lib/navigation.dart (navigator-push)"?>
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const UsualNavScreen(),
  ),
);
```

### How do I use tab navigation and drawer navigation?

In Material Design apps, there are two primary options
for Flutter navigation: tabs and drawers.
When there is insufficient space to support tabs, drawers
provide a good alternative.

#### Tab navigation

In React Native, `createBottomTabNavigator`
and `TabNavigation` are used to
show tabs and for tab navigation.

```js
// React Native
import { createBottomTabNavigator } from 'react-navigation';

const MyApp = TabNavigator(
  { Home: { screen: HomeScreen }, Notifications: { screen: tabNavScreen } },
  { tabBarOptions: { activeTintColor: '#e91e63' } }
);
```

Flutter provides several specialized widgets for drawer and
tab navigation:

[`TabController`][]
: Coordinates the tab selection between a `TabBar`
  and a `TabBarView`.

[`TabBar`][]
: Displays a horizontal row of tabs.

[`Tab`][]
: Creates a material design TabBar tab.

[`TabBarView`][]
: Displays the widget that corresponds to the currently selected tab.


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


A `TabController` is required to coordinate the tab selection
between a `TabBar` and a `TabBarView`.
The `TabController` constructor `length` argument is the total
number of tabs. A `TickerProvider` is required to trigger
the notification whenever a frame triggers a state change.
The `TickerProvider` is `vsync`. Pass the
`vsync: this` argument to the `TabController` constructor
whenever you create a new `TabController`.

The [`TickerProvider`][] is an interface implemented
by classes that can vend [`Ticker`][] objects.
Tickers can be used by any object that must be notified whenever a
frame triggers, but they're most commonly used indirectly via an
[`AnimationController`][]. `AnimationController`s
need a `TickerProvider` to obtain their `Ticker`.
If you are creating an AnimationController from a State,
then you can use the [`TickerProviderStateMixin`][]
or [`SingleTickerProviderStateMixin`][]
classes to obtain a suitable `TickerProvider`.

The [`Scaffold`][] widget wraps a new `TabBar` widget and
creates two tabs. The `TabBarView` widget
is passed as the `body` parameter of the `Scaffold` widget.
All screens corresponding to the `TabBar` widget's tabs are
children to the `TabBarView` widget along with the same `TabController`.

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
              Tab(
                icon: Icon(Icons.person),
              ),
              Tab(
                icon: Icon(Icons.email),
              ),
            ],
            controller: controller,
          ),
        ),
        body: TabBarView(
          controller: controller,
          children: const <Widget>[HomeScreen(), TabScreen()],
        ));
  }
}
```

#### Drawer navigation

In React Native, import the needed react-navigation packages and then use
`createDrawerNavigator` and `DrawerNavigation`.

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

In Flutter, we can use the `Drawer` widget in combination with a
`Scaffold` to create a layout with a Material Design drawer.
To add a `Drawer` to an app, wrap it in a `Scaffold` widget.
The `Scaffold` widget provides a consistent
visual structure to apps that follow the
[Material Design][] guidelines. It also supports
special Material Design components,
such as `Drawers`, `AppBars`, and `SnackBars`.

The `Drawer` widget is a Material Design panel that slides
in horizontally from the edge of a `Scaffold` to show navigation
links in an application. You can
provide a [`ElevatedButton`][], a [`Text`][] widget,
or a list of items to display as the child to the `Drawer` widget.
In the following example, the [`ListTile`][]
widget provides the navigation on tap.

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

The `Scaffold` widget also includes an `AppBar` widget that automatically
displays an appropriate IconButton to show the `Drawer` when a Drawer is
available in the `Scaffold`. The `Scaffold` automatically handles the
edge-swipe gesture to show the `Drawer`.

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

{% include docs/android-ios-figure-pair.md image="react-native/navigation.gif" alt="Navigation" class="border" %}

## Gesture detection and touch event handling

To listen for and respond to gestures,
Flutter supports taps, drags, and scaling.
The gesture system in Flutter has two separate layers.
The first layer includes raw pointer events,
which describe the location and movement of pointers,
(such as touches, mice, and styli movements), across the screen.
The second layer includes gestures,
which describe semantic actions
that consist of one or more pointer movements.

### How do I add a click or press listeners to a widget?

In React Native, listeners are added to components
using `PanResponder` or the `Touchable` components.

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

For more complex gestures and combining several touches into
a single gesture, [`PanResponder`][] is used.

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

In Flutter, to add a click (or press) listener to a widget,
use a button or a touchable widget that has an `onPress: field`.
Or, add gesture detection to any widget by wrapping it
in a [`GestureDetector`][].

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
      )),
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

For more information, including a list of
Flutter `GestureDetector` callbacks,
see the [GestureDetector class][].

[GestureDetector class]: {{site.api}}/flutter/widgets/GestureDetector-class.html#instance-properties

{% include docs/android-ios-figure-pair.md image="react-native/flutter-gestures.gif" alt="Gestures" class="border" %}

## Making HTTP network requests

Fetching data from the internet is common for most apps. And in Flutter,
the `http` package provides the simplest way to fetch data from the internet.

### How do I fetch data from API calls?

React Native provides the Fetch API for networking—you make a fetch request
and then receive the response to get the data.

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

Flutter uses the `http` package. 

To add the `http` package as a dependency, run `flutter pub add`:

```console
$ flutter pub add http
```

Flutter uses the [`dart:io`][] core HTTP support client.
To create an HTTP Client, import `dart:io`.

<?code-excerpt "lib/examples.dart (import-dart-io)"?>
```dart
import 'dart:io';
```

The client supports the following HTTP operations:
GET, POST, PUT, and DELETE.

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

{% include docs/android-ios-figure-pair.md image="react-native/api-calls.gif" alt="API calls" class="border" %}

## Form input

Text fields allow users to type text into your app so they can be
used to build forms, messaging apps, search experiences, and more.
Flutter provides two core text field widgets:
[`TextField`][] and [`TextFormField`][].

### How do I use text field widgets?

In React Native, to enter text you use a `TextInput` component to show a text
input box and then use the callback to store the value in a variable.

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

In Flutter, use the [`TextEditingController`][]
class to manage a `TextField` widget.
Whenever the text field is modified,
the controller notifies its listeners.

Listeners read the text and selection properties to
learn what the user typed into the field.
You can access the text in `TextField`
by the `text` property of the controller.

<?code-excerpt "lib/examples.dart (text-editing-controller)"?>
```dart
final TextEditingController _controller = TextEditingController();

@override
Widget build(BuildContext context) {
  return Column(children: [
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
            });
      },
    ),
  ]);
}
```

In this example, when a user clicks on the submit button an alert dialog
displays the current text entered in the text field.
This is achieved using an [`AlertDialog`][]
widget that displays the alert message, and the text from
the `TextField` is accessed by the `text` property of the
[`TextEditingController`][].

### How do I use Form widgets?

In Flutter, use the [`Form`][] widget where
[`TextFormField`][] widgets along with the submit
button are passed as children.
The `TextFormField` widget has a parameter called
[`onSaved`][] that takes a callback and executes
when the form is saved. A `FormState`
object is used to save, reset, or validate
each `FormField` that is a descendant of this `Form`.
To obtain the `FormState`, you can use `Form.of()`
with a context whose ancestor is the `Form`,
or pass a `GlobalKey` to the `Form` constructor and call
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
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Login'),
        ),
      ],
    ),
  );
}
```

The following example shows how `Form.save()` and `formKey`
(which is a `GlobalKey`), are used to save the form on submit.

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
            content: Text('Email: $_email, password: $_password'));
      },
    );
  }
}
```

{% include docs/android-ios-figure-pair.md image="react-native/input-fields.gif" alt="Input" class="border" %}

## Platform-specific code

When building a cross-platform app, you want to re-use as much code as
possible across platforms. However, scenarios might arise where it
makes sense for the code to be different depending on the OS.
This requires a separate implementation by declaring a specific platform.

In React Native, the following implementation would be used:

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

In Flutter, use the following implementation:

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

## Debugging

### What tools can I use to debug my app in Flutter?

Use the [DevTools][] suite for debugging Flutter or Dart apps.

DevTools includes support for profiling, examining the heap,
inspecting the widget tree, logging diagnostics, debugging,
observing executed lines of code, debugging memory leaks and memory
fragmentation. For more information, check out the
[DevTools][] documentation.

If you're using an IDE,
you can debug your application using the IDE's debugger.

### How do I perform a hot reload?

Flutter's Stateful Hot Reload feature helps you quickly and easily experiment,
build UIs, add features, and fix bugs. Instead of recompiling your app
every time you make a change, you can hot reload your app instantly.
The app is updated to reflect your change,
and the current state of the app is preserved.

In React Native,
the shortcut is ⌘R for the iOS Simulator and tapping R twice on
Android emulators.

In Flutter, If you are using IntelliJ IDE or Android Studio,
you can select Save All (⌘s/ctrl-s), or you can click the
Hot Reload button on the toolbar. If you
are running the app at the command line using `flutter run`,
type `r` in the Terminal window.
You can also perform a full restart by typing `R` in the
Terminal window.

### How do I access the in-app developer menu?

In React Native, the developer menu can be accessed by shaking your device: ⌘D
for the iOS Simulator or ⌘M for Android emulator.

In Flutter, if you are using an IDE, you can use the IDE tools. If you start
your application using `flutter run` you can also access the menu by typing `h`
in the terminal window, or type the following shortcuts:

| Action| Terminal Shortcut| Debug functions and properties|
| :------- | :------: | :------ |
| Widget hierarchy of the app| `w`| debugDumpApp()|
| Rendering tree of the app | `t`| debugDumpRenderTree()|
| Layers| `L`| debugDumpLayerTree()|
| Accessibility | `S` (traversal order) or<br>`U` (inverse hit test order)|debugDumpSemantics()|
| To toggle the widget inspector | `i` | WidgetsApp. showWidgetInspectorOverride|
| To toggle the display of construction lines| `p` | debugPaintSizeEnabled|
| To simulate different operating systems| `o` | defaultTargetPlatform|
| To display the performance overlay | `P` | WidgetsApp. showPerformanceOverlay|
| To save a screenshot to flutter. png| `s` ||
| To quit| `q` ||

{:.table .table-striped}

## Animation

Well-designed animation makes a UI feel intuitive,
contributes to the look and feel of a polished app,
and improves the user experience.
Flutter's animation support makes it easy
to implement simple and complex animations.
The Flutter SDK includes many Material Design widgets
that include standard motion effects,
and you can easily customize these effects
to personalize your app.

In React Native, Animated APIs are used to create animations.

In Flutter, use the [`Animation`][]
class and the [`AnimationController`][] class.
`Animation` is an abstract class that understands its
current value and its state (completed or dismissed).
The `AnimationController` class lets you
play an animation forward or in reverse,
or stop animation and set the animation
to a specific value to customize the motion.

### How do I add a simple fade-in animation?

In the React Native example below, an animated component,
`FadeInView` is created using the Animated API.
The initial opacity state, final state, and the
duration over which the transition occurs are defined.
The animation component is added inside the `Animated` component,
the opacity state `fadeAnim` is mapped
to the opacity of the `Text` component that we want to animate,
and then, `start()` is called to start the animation.

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

To create the same animation in Flutter, create an
[`AnimationController`][] object named `controller`
and specify the duration. By default, an `AnimationController`
linearly produces values that range from 0.0 to 1.0,
during a given duration. The animation controller generates a new value
whenever the device running your app is ready to display a new frame.
Typically, this rate is around 60 values per second.

When defining an `AnimationController`,
you must pass in a `vsync` object.
The presence of `vsync` prevents offscreen
animations from consuming unnecessary resources.
You can use your stateful object as the `vsync` by adding
`TickerProviderStateMixin` to the class definition.
An `AnimationController` needs a TickerProvider,
which is configured using the `vsync` argument on the constructor.

A [`Tween`][] describes the interpolation between a
beginning and ending value or the mapping from an input
range to an output range. To use a `Tween` object
with an animation, call the `Tween` object's `animate()`
method and pass it the `Animation` object that you want to modify.

For this example, a [`FadeTransition`][]
widget is used and the `opacity` property is
mapped to the `animation` object.

To start the animation, use `controller.forward()`.
Other operations can also be performed using the
controller such as `fling()` or `repeat()`.
For this example, the [`FlutterLogo`][]
widget is used inside the `FadeTransition` widget.

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
      child: const SizedBox(
        height: 300,
        width: 300,
        child: FlutterLogo(),
      ),
    );
  }
}
```

{% include docs/android-ios-figure-pair.md image="react-native/flutter-fade.gif" alt="Flutter fade" class="border" %}

### How do I add swipe animation to cards?

In React Native, either the `PanResponder` or
third-party libraries are used for swipe animation.

In Flutter, to add a swipe animation, use the
[`Dismissible`][] widget and nest the child widgets.

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

{% include docs/android-ios-figure-pair.md image="react-native/card-swipe.gif" alt="Card swipe" class="border" %}

## React Native and Flutter widget equivalent components

The following table lists commonly-used React Native
components mapped to the corresponding Flutter widget
and common widget properties.

| React Native Component                                                                    | Flutter Widget                                                                                             | Description                                                                                                                            |
| ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| [`Button`](https://facebook.github.io/react-native/docs/button.html)                        | [`ElevatedButton`][]                           | A basic raised button.                                                                              |
|                                                                                           |  onPressed [required]                                                                                        | The callback when the button is tapped or otherwise activated.                                                          |
|                                                                                           | Child                                                                              | The button's label.                                                                                                      |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Button`](https://facebook.github.io/react-native/docs/button.html)                        | [`TextButton`][]                               | A basic flat button.                                                                                                         |
|                                                                                           |  onPressed [required]                                                                                        | The callback when the button is tapped or otherwise activated.                                                            |
|                                                                                           | Child                                                                              | The button's label.                                                                                                      |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`ScrollView`](https://facebook.github.io/react-native/docs/scrollview.html)                | [`ListView`][]                                    | A scrollable list of widgets arranged linearly.|
||        children                                                                              | 	( <Widget\> [ ])  List of child widgets to display.
||controller |[ [`ScrollController`][] ] An object that can be used to control a scrollable widget.
||itemExtent|[ double ] If non-null, forces the children to have the given extent in the scroll direction.
||scroll Direction|[ [`Axis`][] ] The axis along which the scroll view scrolls.
||                                                                                                            |                                                                                                                                        |
| [`FlatList`](https://facebook.github.io/react-native/docs/flatlist.html)                    | [`ListView.builder`][]               | The constructor for a linear array of widgets that are created on demand.
||itemBuilder [required] |[[`IndexedWidgetBuilder`][]] helps in building the children on demand. This callback is called only with indices greater than or equal to zero and less than the itemCount.
||itemCount |[ int ] improves the ability of the `ListView` to estimate the maximum scroll extent.
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Image`](https://facebook.github.io/react-native/docs/image.html)                         | [`Image`][]                                           | A widget that displays an image.                                                                                                       |
|                                                                                           |  image [required]                                                                                          | The image to display.                                                                                                                  |
|                                                                                           | Image. asset                                                                                                | Several constructors are provided for the various ways that an image can be specified.                                                 |
|                                                                                           | width, height, color, alignment                                                                            | The style and layout for the image.                                                                                                         |
|                                                                                           | fit                                                                                                        | Inscribing the image into the space allocated during layout.                                                                           |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Modal`](https://facebook.github.io/react-native/docs/modal.html)                          | [`ModalRoute`][]                                | A route that blocks interaction with previous routes.                                                                                  |
|                                                                                           | animation                                                                                                  | The animation that drives the route's transition and the previous route's forward transition.                                          |
|                                                                                           |                                                                                                            |                                                                                                                                        |
|  [`ActivityIndicator`](https://facebook.github.io/react-native/docs/activityindicator.html) | [`CircularProgressIndicator`][] | A widget that shows progress along a circle.                                                                                           |
|                                                                                           | strokeWidth                                                                                                | The width of the line used to draw the circle.                                                                                         |
|                                                                                           | backgroundColor                                                                                            | The progress indicator's background color. The current theme's `ThemeData.backgroundColor` by default.                                   |
|                                                                                           |                                                                                                            |                                                                                                                                        |
|  [`ActivityIndicator`](https://facebook.github.io/react-native/docs/activityindicator.html) | [`LinearProgressIndicator`][]     | A widget that shows progress along a line.                                                                                           |
|                                                                                           | value                                                                                                      | The value of this progress indicator.                                                                                                   |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`RefreshControl`](https://facebook.github.io/react-native/docs/refreshcontrol.html)        | [`RefreshIndicator`][]                   | A widget that supports the Material "swipe to refresh" idiom.                                                                          |
|                                                                                           | color                                                                                                      | The progress indicator's foreground color.                                                                                             |
|                                                                                           | onRefresh                                                                                                  | A function that's called when a user drags the refresh indicator far enough to demonstrate that they want the app to refresh.  |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Container`][]                                  | A widget that surrounds a child widget.                                                                                                                |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Column`][]                                        | A widget that displays its children in a vertical array.                                                                                              |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Row`][]                                              | A widget that displays its children in a horizontal array.                                                                                            |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Center`][]                                        | A widget that centers its child within itself.                                                                                                       |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Padding`][]                                      | A widget that insets its child by the given padding.                                                                                                 |
|                                                                                           | padding [required]                                                                                         | [ EdgeInsets ] The amount of space to inset the child.
|||
| [`TouchableOpacity`](https://facebook.github.io/react-native/docs/touchableopacity.html)    | [`GestureDetector`][]                      | A widget that detects gestures.                                                                                                                       |
|                                                                                           | onTap                                                                                                      | A callback when a tap occurs.                                                                                                               |
|                                                                                           | onDoubleTap                                                                                                | A callback when a tap occurs at the same location twice in quick succession.
|||
| [`TextInput`](https://facebook.github.io/react-native/docs/textinput.html)                | [`TextInput`][]                                   | The interface to the system's text input control.                                                                                           |
|                                                                                           | controller                                                                                                 | [ [`TextEditingController`][] ] used to access and modify text.
|||
| [`Text`](https://facebook.github.io/react-native/docs/text.html)                          | [`Text`][]                                            | The Text widget that displays a string of text with a single style.                                                                                                                                                                           |
|                                                                                         | data                                                                                                      | [ String ] The text to display.                                                                                                                                                                              |
|                                                                                         | textDirection                                                                                             | [ [`TextAlign`][] ] The direction in which the text flows.                                                                                     |
|                                                                                         |                                                                                                           |                                                                                                                                                                                                              |
| [`Switch`](https://facebook.github.io/react-native/docs/switch.html)                      | [`Switch`][]                                      | A material design switch.                                                                                                                                                                                    |
|                                                                                         | value [required]                                                                                          | [ boolean ] Whether this switch is on or off.                                                                                                                                                                 |
|                                                                                         | onChanged [required]                                                                                      | [ callback ] Called when the user toggles the switch on or off.                                                                                                                                               |
|                                                                                         |                                                                                                           |                                                                                                                                                                                                              |
| [`Slider`](https://facebook.github.io/react-native/docs/slider.html)                      | [`Slider`][]                                      | Used to select from a range of values.                                                                                                                                                                       |
|                                                                                         | value [required]                                                                                          | [ double ] The current value of the slider.                                                                                                                                                                           |
|                                                                                         | onChanged [required]                                                                                      | Called when the user selects a new value for the slider.                                                                                                                                                      |

{:.table .table-striped}


[`AboutDialog`]: {{site.api}}/flutter/material/AboutDialog-class.html
[Adding Assets and Images in Flutter]: /ui/assets/assets-and-images
[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[`Align`]: {{site.api}}/flutter/widgets/Align-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[async and await]: {{site.dart-site}}/language/async
[`Axis`]: {{site.api}}/flutter/painting/Axis.html
[`BuildContext`]: {{site.api}}/flutter/widgets/BuildContext-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[color palette]: {{site.material2}}/design/color/the-color-system.html#color-theme-creation
[colors]: {{site.api}}/flutter/material/Colors-class.html
[`Colors`]: {{site.api}}/flutter/material/Colors-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`CircleAvatar`]: {{site.api}}/flutter/material/CircleAvatar-class.html
[`CircularProgressIndicator`]: {{site.api}}/flutter/material/CircularProgressIndicator-class.html
[Cupertino (iOS-style)]: /ui/widgets/cupertino
[`CustomPaint`]: {{site.api}}/flutter/widgets/CustomPaint-class.html
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[Dart]: {{site.dart-site}}/dart-2
[Dart's Type System]: {{site.dart-site}}/guides/language/sound-dart
[Sound Null Safety]: {{site.dart-site}}/null-safety
[`dart:io`]: {{site.api}}/flutter/dart-io/dart-io-library.html
[DartPadA]: {{site.dartpad}}/?id=0df636e00f348bdec2bc1c8ebc7daeb1
[DartPadB]: {{site.dartpad}}/?id=cf9e652f77636224d3e37d96dcf238e5
[DartPadC]: {{site.dartpad}}/?id=3f4625c16e05eec396d6046883739612
[DartPadD]: {{site.dartpad}}/?id=57ec21faa8b6fe2326ffd74e9781a2c7
[DartPadE]: {{site.dartpad}}/?id=c85038ad677963cb6dc943eb1a0b72e6
[DartPadF]: {{site.dartpad}}/?id=5454e8bfadf3000179d19b9bc6be9918
[Developing Packages & Plugins]: /packages-and-plugins/developing-packages
[DevTools]: /tools/devtools
[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[`FadeTransition`]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[Flutter packages]: {{site.pub}}/flutter/
[Flutter Architectural Overview]: /resources/architectural-overview
[Flutter Basic Widgets]: /ui/widgets/basics
[Flutter Technical Overview]: /resources/architectural-overview
[Flutter Widget Catalog]: /ui/widgets
[Flutter Widget Index]: /reference/widgets
[`FlutterLogo`]: {{site.api}}/flutter/material/FlutterLogo-class.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[functions]: {{site.dart-site}}/language/functions
[`Future`]: {{site.dart-site}}/tutorials/language/futures
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Getting started]: /get-started
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`IndexedWidgetBuilder`]: {{site.api}}/flutter/widgets/IndexedWidgetBuilder.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[Layout Widgets]: /ui/widgets/layout
[`LinearProgressIndicator`]: {{site.api}}/flutter/material/LinearProgressIndicator-class.html
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[Material Design]: {{site.material}}/styles
[Material icons]: {{site.api}}/flutter/material/Icons-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`MaterialPageRoute`]: {{site.api}}/flutter/material/MaterialPageRoute-class.html
[`ModalRoute`]: {{site.api}}/flutter/widgets/ModalRoute-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.of()`]: {{site.api}}/flutter/widgets/Navigator/of.html
[`Navigator.pop`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.push`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`onSaved`]: {{site.api}}/flutter/widgets/FormField/onSaved.html
[named parameters]: {{site.dart-site}}/language/functions#named-parameters
[`Padding`]: {{site.api}}/flutter/widgets/Padding-class.html
[`PanResponder`]: https://facebook.github.io/react-native/docs/panresponder.html
[pub.dev]: {{site.pub}}
[`Radio`]: {{site.api}}/flutter/material/Radio-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`RefreshIndicator`]: {{site.api}}/flutter/material/RefreshIndicator-class.html
[`Route`]: {{site.api}}/flutter/widgets/Route-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`ScrollController`]: {{site.api}}/flutter/widgets/ScrollController-class.html
[`shared_preferences`]: {{site.repo.packages}}/tree/main/packages/shared_preferences/shared_preferences
[`SingleTickerProviderStateMixin`]: {{site.api}}/flutter/widgets/SingleTickerProviderStateMixin-mixin.html
[`Slider`]: {{site.api}}/flutter/material/Slider-class.html
[`Stack`]: {{site.api}}/flutter/widgets/Stack-class.html
[State management]: /data-and-backend/state-mgmt
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`Switch`]: {{site.api}}/flutter/material/Switch-class.html
[`Tab`]: {{site.api}}/flutter/material/Tab-class.html
[`TabBar`]: {{site.api}}/flutter/material/TabBar-class.html
[`TabBarView`]: {{site.api}}/flutter/material/TabBarView-class.html
[`TabController`]: {{site.api}}/flutter/material/TabController-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[`TextAlign`]: {{site.api}}/flutter/dart-ui/TextAlign.html
[`TextEditingController`]: {{site.api}}/flutter/widgets/TextEditingController-class.html
[`TextField`]: {{site.api}}/flutter/material/TextField-class.html
[`TextFormField`]: {{site.api}}/flutter/material/TextFormField-class.html
[`TextInput`]: {{site.api}}/flutter/services/TextInput-class.html
[`TextStyle`]: {{site.api}}/flutter/dart-ui/TextStyle-class.html
[`Theme`]: {{site.api}}/flutter/material/Theme-class.html
[`ThemeData`]: {{site.api}}/flutter/material/ThemeData-class.html
[`Ticker`]: {{site.api}}/flutter/scheduler/Ticker-class.html
[`TickerProvider`]: {{site.api}}/flutter/scheduler/TickerProvider-class.html
[`TickerProviderStateMixin`]: {{site.api}}/flutter/widgets/TickerProviderStateMixin-mixin.html
[`Tween`]: {{site.api}}/flutter/animation/Tween-class.html
[Using Packages]: /packages-and-plugins/using-packages
[variables]: {{site.dart-site}}/language/variables
[`WidgetBuilder`]: {{site.api}}/flutter/widgets/WidgetBuilder.html
[infinite_list]: {{site.repo.samples}}/tree/main/infinite_list
