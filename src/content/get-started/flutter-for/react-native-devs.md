---
title: Flutter para desenvolvedores React Native
description: Aprenda como aplicar o conhecimento de desenvolvedor React Native na construção de aplicativos Flutter.
ia-translate: true
---

<?code-excerpt path-base="get-started/flutter-for/react_native_devs"?>

Este documento é para desenvolvedores React Native (RN) que buscam aplicar seu
conhecimento existente em RN para construir aplicativos móveis com Flutter. Se você entende
os fundamentos do framework RN, então você pode usar este documento como uma
maneira de começar a aprender o desenvolvimento Flutter.

Este documento pode ser usado como um livro de receitas, pulando e encontrando
as perguntas que são mais relevantes para suas necessidades.

## Introdução ao Dart para Desenvolvedores JavaScript (ES6)

Assim como o React Native, o Flutter usa visualizações de estilo reativo. No entanto, enquanto o RN
transpila para widgets nativos, o Flutter compila até o código nativo.
O Flutter controla cada pixel na tela, o que evita problemas de desempenho
causados pela necessidade de uma ponte JavaScript.

Dart é uma linguagem fácil de aprender e oferece os seguintes recursos:

* Fornece uma linguagem de programação de código aberto e escalável para a construção de aplicativos web,
  servidor e móveis.
* Fornece uma linguagem de herança única orientada a objetos que usa uma
  sintaxe de estilo C que é compilada em AOT para nativo.
* Transcompila opcionalmente em JavaScript.
* Suporta interfaces e classes abstratas.

Alguns exemplos das diferenças entre JavaScript e Dart são descritos
abaixo.

### Ponto de entrada

JavaScript não tem uma
função de entrada predefinida&mdash;você define o ponto de entrada.

```js
// JavaScript
function startHere() {
  // Pode ser usado como ponto de entrada
}
```

Em Dart, cada aplicativo deve ter uma função `main()` de nível superior que serve como
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
console.log('Hello world!');
```

<?code-excerpt "lib/main.dart (print)"?>
```dart
/// Dart
print('Hello world!');
```

Experimente no [DartPad][DartPadB].

### Variáveis

Dart é type safe&mdash;ele usa uma combinação de verificação de tipo estática
e verificações de tempo de execução para garantir que o valor de uma variável sempre corresponda
ao tipo estático da variável. Embora os tipos sejam obrigatórios,
algumas anotações de tipo são opcionais porque
o Dart realiza inferência de tipo.

#### Criando e atribuindo variáveis

Em JavaScript, as variáveis não podem ser tipadas.

Em [Dart][], as variáveis devem ser explicitamente
tipadas ou o sistema de tipos deve inferir o tipo apropriado automaticamente.

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

Para mais informações, veja [Dart's Type System][].

#### Valor padrão

Em JavaScript, variáveis não inicializadas são `undefined`.

Em Dart, variáveis não inicializadas têm um valor inicial de `null`.
Como os números são objetos em Dart, mesmo variáveis não inicializadas com
tipos numéricos têm o valor `null`.

:::note
A partir da versão 2.12, o Dart suporta [Sound Null Safety][],
todos os tipos subjacentes são não anuláveis por padrão,
que devem ser inicializados como um valor não nulo.
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

Para mais informações, veja a documentação sobre
[variables][].

### Verificando null ou zero

Em JavaScript, valores de 1 ou quaisquer objetos não nulos
são tratados como `true` ao usar o operador de comparação `==`.

```js
// JavaScript
let myNull = null;
if (!myNull) {
  console.log('null é tratado como falso');
}
let zero = 0;
if (!zero) {
  console.log('0 é tratado como falso');
}
```

Em Dart, apenas o valor booleano `true` é tratado como true.

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

Para mais informações, veja a documentação sobre
[functions][].

### Programação assíncrona

#### Futures

Assim como o JavaScript, o Dart suporta execução single-threaded. Em JavaScript,
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

A declaração da função `async` define uma função assíncrona.

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

Para mais informações, veja a documentação para [async e await][].

## O básico

### Como eu crio um aplicativo Flutter?

Para criar um aplicativo usando React Native,
você executaria `create-react-native-app` na linha de comando.

```console
$ create-react-native-app <projectname>
```

Para criar um aplicativo em Flutter, faça um dos seguintes:

* Use um IDE com os plugins Flutter e Dart instalados.
* Use o comando `flutter create` na linha de comando. Certifique-se de que o
  Flutter SDK esteja em seu PATH.

```console
$ flutter create <projectname>
```

Para mais informações, veja [Introdução][], que
orienta você na criação de um aplicativo contador de cliques de botão.
A criação de um projeto Flutter constrói todos os arquivos que você
precisa para executar um aplicativo de exemplo em dispositivos Android e iOS.

### Como eu executo meu aplicativo?

Em React Native, você executaria `npm run` ou `yarn run` do
diretório do projeto.

Você pode executar aplicativos Flutter de duas maneiras:

* Use a opção "run" em um IDE com os plugins Flutter e Dart.
* Use `flutter run` do diretório raiz do projeto.

Seu aplicativo é executado em um dispositivo conectado, no simulador iOS,
ou no emulador Android.

Para mais informações, veja a documentação
[Introdução][] do Flutter.

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
o Dart puxa apenas os widgets que são usados em seu aplicativo.

Para mais informações, veja o [Catálogo de Widgets do Flutter][].

### Qual é o equivalente do aplicativo "Hello world!" do React Native em Flutter?

Em React Native, a classe `HelloWorldApp` estende `React.Component` e
implementa o método render retornando um componente de visualização.

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

Em Flutter, você pode criar um aplicativo "Hello world!" idêntico usando os
widgets `Center` e `Text` da biblioteca principal de widgets.
O widget `Center` se torna a raiz da árvore de widgets e tem um child,
o widget `Text`.

<?code-excerpt "lib/hello_world.dart"?>
```dart
// Flutter
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

As imagens a seguir mostram a interface do usuário do Android e do iOS para o
aplicativo básico "Hello world!" do Flutter.

{% include docs/android-ios-figure-pair.md image="react-native/hello-world-basic.png" alt="Aplicativo Hello world" class="border" %}

Agora que você viu o aplicativo Flutter mais básico, a próxima seção mostra como
tirar proveito das ricas bibliotecas de widgets do Flutter para criar um
aplicativo moderno e polido.

### Como eu uso widgets e os aninho para formar uma árvore de widgets?

Em Flutter, quase tudo é um widget.

Widgets são os blocos de construção básicos da interface do usuário de um aplicativo.
Você compõe widgets em uma hierarquia, chamada de árvore de widgets.
Cada widget se aninha dentro de um widget pai
e herda propriedades de seu pai.
Até mesmo o próprio objeto do aplicativo é um widget.
Não há um objeto "aplicativo" separado.
Em vez disso, o widget raiz serve a esse propósito.

Um widget pode definir:

* Um elemento estrutural&mdash;como um botão ou menu
* Um elemento estilístico&mdash;como uma fonte ou esquema de cores
* Um aspecto de layout&mdash;como preenchimento ou alinhamento

O exemplo a seguir mostra o aplicativo "Hello world!" usando widgets da
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
        appBar: AppBar(
          title: const Text('Welcome to Flutter'),
        ),
        body: const Center(
          child: Text('Hello world'),
        ),
      ),
    );
  }
}
```

As imagens a seguir mostram "Hello world!" construído a partir de widgets Material Design.
Você obtém mais funcionalidade gratuitamente do que no aplicativo básico "Hello world!".

{% include docs/android-ios-figure-pair.md image="react-native/hello-world.png" alt="Aplicativo Hello world" %}

Ao escrever um aplicativo, você usará dois tipos de widgets:
[`StatelessWidget`][] ou [`StatefulWidget`][].
Um `StatelessWidget` é exatamente o que parece&mdash;um
widget sem estado. Um `StatelessWidget` é criado uma vez,
e nunca muda sua aparência.
Um `StatefulWidget` muda dinamicamente o estado com base nos dados
recebidos ou na entrada do usuário.

A diferença importante entre widgets stateless e stateful
é que os `StatefulWidget`s têm um objeto `State`
que armazena dados de estado e os transporta
através de reconstruções de árvore, para que não sejam perdidos.

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
e, em seguida, usada dentro de uma classe pai.

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
usa a sintaxe de chave `Dart { }` para indicar [named parameters][].

Para exigir esses campos, remova as chaves do
construtor ou adicione `required` ao construtor.

As capturas de tela a seguir mostram um exemplo da classe
`CustomCard` reutilizável.

{% include docs/android-ios-figure-pair.md image="react-native/custom-cards.png" alt="Cartões personalizados" class="border" %}

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
ele constrói a seguinte estrutura de diretórios.
Você pode personalizá-la mais tarde, mas é aqui que você começa.

```plaintext
┬
└ project_name
  ┬
  ├ android      - Contém arquivos específicos do Android.
  ├ build        - Armazena arquivos de build do iOS e do Android.
  ├ ios          - Contém arquivos específicos do iOS.
  ├ lib          - Contém arquivos de origem Dart acessíveis externamente.
    ┬
    └ src        - Contém arquivos de origem adicionais.
    └ main.dart  - O ponto de entrada do Flutter e o início de um novo aplicativo.
                   Isso é gerado automaticamente quando você cria um
                    projeto Flutter.
                   É aqui que você começa a escrever seu código Dart.
  ├ test         - Contém arquivos de teste automatizados.
  └ pubspec.yaml - Contém os metadados para o aplicativo Flutter.
                   Isso é equivalente ao arquivo package.json em React Native.
```

### Onde eu coloco meus recursos e ativos e como eu os uso?

Um recurso ou ativo do Flutter é um arquivo que é empacotado e implantado
com seu aplicativo e é acessível em tempo de execução.
Os aplicativos Flutter podem incluir os seguintes tipos de ativos:

* Dados estáticos, como arquivos JSON
* Arquivos de configuração
* Ícones e imagens (JPEG, PNG, GIF, GIF animado, WebP, WebP animado, BMP,
  e WBMP)

O Flutter usa o arquivo `pubspec.yaml`,
localizado na raiz do seu projeto, para
identificar os ativos necessários para um aplicativo.

```yaml
flutter:
  assets:
    - assets/my_icon.png
    - assets/background.png
```

A subseção `assets` especifica os arquivos que devem ser incluídos no aplicativo.
Cada ativo é identificado por um caminho explícito
relativo ao arquivo `pubspec.yaml`, onde o arquivo de ativo está localizado.
A ordem em que os ativos são declarados não importa.
O diretório real usado (`assets` neste caso) não importa.
No entanto, embora os ativos possam ser colocados em qualquer diretório de aplicativo, é uma
prática recomendada colocá-los no diretório `assets`.

Durante um build, o Flutter coloca os ativos em um arquivo especial
chamado *pacote de ativos*, que os aplicativos leem em tempo de execução.
Quando o caminho de um ativo é especificado na seção de ativos de `pubspec.yaml`,
o processo de build procura por quaisquer arquivos
com o mesmo nome em subdiretórios adjacentes.
Esses arquivos também são incluídos no pacote de ativos
juntamente com o ativo especificado. O Flutter usa variantes de ativos
ao escolher imagens apropriadas para a resolução do seu aplicativo.

Em React Native, você adicionaria uma imagem estática colocando o arquivo de imagem
em um diretório de código-fonte e referenciando-o.

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
usando o construtor `Image.asset` no método build de um widget.

<?code-excerpt "lib/examples.dart (image-asset)" replace="/return //g"?>
```dart
Image.asset('assets/background.png');
```

Para mais informações, veja [Adicionando Ativos e Imagens no Flutter][].

### Como eu carrego imagens de uma rede?

Em React Native, você especificaria o `uri` no
prop `source` do componente `Image` e também forneceria o
tamanho, se necessário.

Em Flutter, use o construtor `Image.network` para incluir
uma imagem de um URL.

<?code-excerpt "lib/examples.dart (image-network)" replace="/return //g"?>
```dart
Image.network('https://docs.flutter.dev/assets/images/docs/owl.jpg');
```

### Como eu instalo pacotes e plugins de pacotes?

O Flutter suporta o uso de pacotes compartilhados contribuídos por outros desenvolvedores para os
ecossistemas Flutter e Dart. Isso permite que você construa rapidamente seu aplicativo sem
ter que desenvolver tudo do zero. Pacotes que contêm
código específico da plataforma são conhecidos como plugins de pacote.

Em React Native, você usaria `yarn add {package-name}` ou
`npm install --save {package-name}` para instalar pacotes
da linha de comando.

Em Flutter, instale um pacote usando as seguintes instruções:

1. Para adicionar o pacote `google_sign_in` como uma dependência, execute `flutter pub add`:

```console
$ flutter pub add google_sign_in
```

2. Instale o pacote a partir da linha de comando usando `flutter pub get`.
   Se estiver usando um IDE, ele geralmente executa `flutter pub get` para você, ou pode
   solicitar que você o faça.
3. Importe o pacote para o código do seu aplicativo, como mostrado abaixo:

<?code-excerpt "lib/examples.dart (package-import)"?>
```dart
import 'package:flutter/material.dart';
```

Para mais informações, veja [Usando Pacotes][] e
[Desenvolvendo Pacotes e Plugins][].

Você pode encontrar muitos pacotes compartilhados por desenvolvedores Flutter na
seção [Pacotes Flutter][] de [pub.dev][].

## Widgets Flutter

Em Flutter, você constrói sua interface do usuário a partir de widgets que descrevem como sua visualização
deve ser, dada sua configuração e estado atuais.

Os widgets geralmente são compostos por muitos widgets pequenos e de
propósito único que são aninhados para produzir efeitos poderosos.
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
widget. Para entender por que um widget renderiza de uma
determinada maneira, muitas vezes é útil inspecionar os widgets vizinhos.

Para mais informações, veja a [Visão Geral Técnica do Flutter][].

Para mais informações sobre os widgets principais do pacote `Widgets`,
veja [Widgets Básicos do Flutter][],
o [Catálogo de Widgets do Flutter][],
ou o [Índice de Widgets do Flutter][].

## Visualizações

### Qual é o equivalente do contêiner `View`?

Em React Native, `View` é um contêiner que suporta layout com `Flexbox`,
estilo, tratamento de toque e controles de acessibilidade.

Em Flutter, você pode usar os widgets de layout principais na biblioteca `Widgets`,
como [`Container`][], [`Column`][],
[`Row`][], e [`Center`][].
Para mais informações, veja o catálogo [Widgets de Layout][].

### Qual é o equivalente de `FlatList` ou `SectionList`?

Uma `List` é uma lista rolável de componentes organizados verticalmente.

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
O construtor padrão leva uma lista explícita de children.
[`ListView`][] é mais apropriado para um pequeno número de widgets.
Para uma lista grande ou infinita, use `ListView.builder`,
que constrói seus children sob demanda e só constrói
os children que são visíveis.

<?code-excerpt "lib/examples.dart (list-view)"?>
```dart
var data = [
  'Hello',
  'World',
];
return ListView.builder(
  itemCount: data.length,
  itemBuilder: (context, index) {
    return Text(data[index]);
  },
);
```

{% include docs/android-ios-figure-pair.md image="react-native/flatlist.gif" alt="Lista plana" class="border" %}

Para aprender como implementar uma lista de rolagem infinita, veja o exemplo oficial
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
e a passa para a propriedade painter do `CustomPaint`.
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

Em React Native, a maior parte do layout pode ser feita com os props
que são passados para um componente específico.
Por exemplo, você pode usar o prop `style` no componente `View`
para especificar as propriedades do flexbox.
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

Em Flutter, o layout é definido principalmente por widgets
especificamente projetados para fornecer layout,
combinados com widgets de controle e suas propriedades de estilo.

Por exemplo, os widgets [`Column`][] e [`Row`][]
recebem um array de children e os alinham
verticalmente e horizontalmente, respectivamente.
Um widget [`Container`][] recebe uma combinação de
propriedades de layout e estilo, e um
widget [`Center`][] centraliza seus widgets child.

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

O Flutter fornece uma variedade de widgets de layout em sua biblioteca principal de widgets.
Por exemplo, [`Padding`][], [`Align`][], e [`Stack`][].

Para uma lista completa, veja [Widgets de Layout][].

{% include docs/android-ios-figure-pair.md image="react-native/basic-layout.gif" alt="Layout" class="border" %}

### Como eu coloco widgets em camadas?

Em React Native, os componentes podem ser colocados em camadas usando o posicionamento `absolute`.

O Flutter usa o widget [`Stack`][]
para organizar widgets children em camadas.
Os widgets podem sobrepor inteiramente ou parcialmente o widget base.

O widget `Stack` posiciona seus children em relação às bordas de sua caixa.
Esta classe é útil se você simplesmente deseja sobrepor vários widgets children.

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
A Stack desloca o texto usando a propriedade alignment
e coordenadas `Alignment`.

{% include docs/android-ios-figure-pair.md image="react-native/stack.png" alt="Stack" class="border" %}

Para mais informações, veja a documentação da classe [`Stack`][].

## Estilização

### Como eu estilizo meus componentes?

Em React Native, o estilo em linha e `stylesheets.create`
são usados para estilizar componentes.

```js
// React Native
<View style={styles.container}>
  <Text style={%raw%}{{ fontSize: 32, color: 'cyan', fontWeight: '600' }}{%endraw%}>
    Este é um texto de exemplo
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

Em Flutter, um widget `Text` pode receber uma classe `TextStyle`
para sua propriedade style. Se você quiser usar o mesmo
estilo de texto em vários lugares, você pode criar uma
classe [`TextStyle`][] e usá-la para vários widgets `Text.

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
      Text('Texto de exemplo', style: textStyle),
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

{% include docs/android-ios-figure-pair.md image="react-native/flutterstyling.gif" alt="Estilização" class="border" %}

### Como eu uso `Icons` e `Colors`?

O React Native não inclui suporte para ícones,
portanto, bibliotecas de terceiros são usadas.

Em Flutter, importar a biblioteca Material também traz o
rico conjunto de [ícones Material][] e [cores][].

<?code-excerpt "lib/examples.dart (icon)"?>
```dart
return const Icon(Icons.lightbulb_outline, color: Colors.redAccent);
```

Ao usar a classe `Icons`,
certifique-se de definir `uses-material-design: true` no
arquivo `pubspec.yaml` do projeto.
Isso garante que a fonte `MaterialIcons`,
que exibe os ícones, seja incluída em seu aplicativo.
Em geral, se você pretende usar a biblioteca Material,
você deve incluir esta linha.

```yaml
name: my_awesome_application
flutter:
  uses-material-design: true
```

O pacote [Cupertino (estilo iOS)][] do Flutter fornece widgets de alta
fidelidade para a linguagem de design atual do iOS.
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

O exemplo a seguir define o esquema de cores a partir da semente para `deepPurple`
e a seleção de texto para `red`.

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

### Como eu adiciono temas de estilo?

Em React Native, temas comuns são definidos para
componentes em folhas de estilo e, em seguida, usados em componentes.

Em Flutter, crie um estilo uniforme para quase tudo
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
e aplica o `ThemeData` a todos os seus widgets children.

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

Estado é a informação que pode ser lida de forma síncrona
quando um widget é construído ou informação
que pode mudar durante o tempo de vida de um widget.
Para gerenciar o estado do aplicativo em Flutter,
use um [`StatefulWidget`][] emparelhado com um objeto State.

Para mais informações sobre as abordagens para gerenciar o estado em Flutter,
veja [Gerenciamento de estado][].

### O StatelessWidget

Um `StatelessWidget` em Flutter é um widget
que não requer uma mudança de estado&mdash;
ele não tem estado interno para gerenciar.

Widgets stateless são úteis quando a parte da interface do usuário
que você está descrevendo não depende de nada além da
informação de configuração no próprio objeto e do
[`BuildContext`][] no qual o widget é inflado.

[`AboutDialog`][], [`CircleAvatar`][], e [`Text`][] são exemplos
de widgets stateless que subclassificam [`StatelessWidget`][].

<?code-excerpt "lib/stateless.dart"?>
```dart
import 'package:flutter/material.dart';

void main() => runApp(
      const MyStatelessWidget(
        text: 'Exemplo de StatelessWidget para mostrar dados imutáveis',
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
* Quando um [`InheritedWidget`][] do qual ele depende, muda

### O StatefulWidget

Um [`StatefulWidget`][] é um widget que muda de estado.
Use o método `setState` para gerenciar as
mudanças de estado para um `StatefulWidget`.
Uma chamada para `setState()` diz ao framework Flutter
que algo mudou em um estado,
o que faz com que um aplicativo execute novamente o método `build()`
para que o aplicativo possa refletir a mudança.

_Estado_ é a informação que pode ser lida de forma síncrona quando um widget
é construído e pode mudar durante o tempo de vida do widget.
É responsabilidade do implementador do widget garantir que
o objeto de estado seja prontamente notificado quando o estado mudar.
Use `StatefulWidget` quando um widget puder mudar dinamicamente.
Por exemplo, o estado do widget muda digitando em um formulário,
ou movendo um controle deslizante.
Ou, ele pode mudar ao longo do tempo&mdash;talvez um feed de dados atualize a interface do usuário.

[`Checkbox`][], [`Radio`][], [`Slider`][], [`InkWell`][],
[`Form`][], e [`TextField`][]
são exemplos de widgets stateful que subclassificam
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
Isso faz com que o framework reconstrua este widget na interface do usuário.

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
                'Esta execução será feita antes que você possa piscar.',
              ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: ElevatedButton(
                onPressed: toggleBlinkState,
                child: toggleState
                    ? const Text('Piscar')
                    : const Text('Parar de Piscar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Quais são as melhores práticas para StatefulWidget e StatelessWidget?

Aqui estão algumas coisas a considerar ao projetar seu widget.

1. Determine se um widget deve ser
   um `StatefulWidget` ou um `StatelessWidget`.

Em Flutter, os widgets são Stateful ou Stateless&mdash;dependendo se
eles dependem de uma mudança de estado.

* Se um widget muda&mdash;o usuário interage com ele ou
  um feed de dados interrompe a interface do usuário, então ele é *Stateful*.
* Se um widget é final ou imutável, então ele é *Stateless*.

2. Determine qual objeto gerencia o estado do widget (para um `StatefulWidget`).

Em Flutter, existem três maneiras principais de gerenciar o estado:

* O widget gerencia seu próprio estado
* O widget pai gerencia o estado do widget
* Uma abordagem mista

Ao decidir qual abordagem usar, considere os seguintes princípios:

* Se o estado em questão são dados do usuário,
  por exemplo, o modo marcado ou desmarcado de uma caixa de seleção,
  ou a posição de um controle deslizante, então o estado é melhor gerenciado
  pelo widget pai.
* Se o estado em questão é estético, por exemplo, uma animação,
  então o próprio widget gerencia melhor o estado.
* Em caso de dúvida, deixe o widget pai gerenciar o estado do widget filho.

3. Subclasse StatefulWidget e State.

A classe `MyStatefulWidget` gerencia seu próprio estado&mdash;ela estende
`StatefulWidget`, ela substitui o método `createState()`
para criar o objeto `State`,
e o framework chama `createState()` para construir o widget.
Neste exemplo, `createState()` cria uma instância de
`_MyStatefulWidgetState`, que
é implementado na próxima melhor prática.

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

4. Adicione o StatefulWidget na árvore de widgets.

Adicione seu `StatefulWidget` personalizado à árvore de widgets
no método build do aplicativo.

<?code-excerpt "lib/best_practices.dart (use-stateful-widget)"?>
```dart
class MyStatelessWidget extends StatelessWidget {
  // Este widget é a raiz do seu aplicativo.
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

{% include docs/android-ios-figure-pair.md image="react-native/state-change.gif" alt="Mudança de estado" class="border" %}

## Props

Em React Native, a maioria dos componentes pode ser personalizada quando são
criados com diferentes parâmetros ou propriedades, chamados `props`.
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

Em Flutter, você atribui uma variável local ou função marcada como
`final` com a propriedade recebida no construtor parametrizado.

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

{% include docs/android-ios-figure-pair.md image="react-native/modular.png" alt="Cartões" class="border" %}

## Armazenamento local

Se você não precisa armazenar muitos dados e eles não requerem
estrutura, você pode usar `shared_preferences`, que permite
ler e escrever pares de chave-valor persistentes de dados primitivos
tipos: booleanos, floats, ints, longs e strings.

### Como eu armazeno pares de chave-valor persistentes que são globais para o aplicativo?

Em React Native, você usa as funções `setItem` e `getItem`
do componente `AsyncStorage` para armazenar e recuperar dados
que são persistentes e globais para o aplicativo.

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

Em Flutter, use o plugin [`shared_preferences`][] para
armazenar e recuperar dados de chave-valor que são persistentes e globais
para o aplicativo. O plugin `shared_preferences` envolve
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
Os métodos setter estão disponíveis para vários
tipos primitivos, como `setInt`, `setBool` e `setString`.
Para ler dados, use o método getter apropriado fornecido
pela classe `SharedPreferences`. Para cada
setter, há um método getter correspondente,
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

## Roteamento

A maioria dos aplicativos contém várias telas para exibir diferentes
tipos de informações. Por exemplo, você pode ter uma
tela de produto que exibe imagens onde os usuários podem tocar em uma imagem de produto
para obter mais informações sobre o produto em uma nova tela.

No Android, novas telas são novas Activities.
No iOS, novas telas são novos ViewControllers. Em Flutter,
as telas são apenas Widgets! E para navegar para novas
telas em Flutter, use o widget Navigator.

### Como eu navego entre as telas?

Em React Native, existem três navegadores principais:
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

Em Flutter, existem dois widgets principais usados para navegar entre as telas:

* Uma [`Route`][] é uma abstração para uma tela ou página de aplicativo.
* Um [`Navigator`][] é um widget que gerencia rotas.

Um `Navigator` é definido como um widget que gerencia um conjunto de
widgets filhos com uma disciplina de pilha. O navegador gerencia uma pilha
de objetos `Route` e fornece métodos para gerenciar a pilha,
como [`Navigator.push`][] e [`Navigator.pop`][].
Uma lista de rotas pode ser especificada no widget [`MaterialApp`][],
ou elas podem ser construídas em tempo real, por exemplo, em animações de herói.
O exemplo a seguir especifica rotas nomeadas no widget `MaterialApp`.

:::note
Rotas nomeadas não são mais recomendadas para a maioria
das aplicações. Para mais informações, veja
[Limitações][] na página [visão geral de navegação][].
:::

[Limitações]: /ui/navigation#limitations
[visão geral de navegação]: /ui/navigation

<?code-excerpt "lib/navigation.dart (navigator)"?>
```dart
class NavigationApp extends StatelessWidget {
  // Este widget é a raiz do seu aplicativo.
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
(um identificador para a localização de um widget na árvore de widgets).
O nome da rota é passado para a função `pushNamed` para
navegar para a rota especificada.

<?code-excerpt "lib/navigation.dart (push-named)"?>
```dart
Navigator.of(context).pushNamed('/a');
```

Você também pode usar o método push do `Navigator` que
adiciona a [`Route`][] fornecida ao histórico do
navegador que mais envolve o [`BuildContext`][] fornecido,
e faz a transição para ele. No exemplo a seguir,
o widget [`MaterialPageRoute`][] é uma rota modal que
substitui a tela inteira por uma
transição adaptável à plataforma. Ele recebe um [`WidgetBuilder`][] como um parâmetro obrigatório.

<?code-excerpt "lib/navigation.dart (navigator-push)"?>
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const UsualNavScreen(),
  ),
);
```

### Como eu uso a navegação por guias e a navegação por gaveta?

Em aplicativos Material Design, existem duas opções principais
para navegação Flutter: guias e gavetas.
Quando não há espaço suficiente para suportar guias, as gavetas
fornecem uma boa alternativa.

#### Navegação por guias

Em React Native, `createBottomTabNavigator`
e `TabNavigation` são usados para
mostrar guias e para navegação por guias.

```js
// React Native
import { createBottomTabNavigator } from 'react-navigation';

const MyApp = TabNavigator(
  { Home: { screen: HomeScreen }, Notifications: { screen: tabNavScreen } },
  { tabBarOptions: { activeTintColor: '#e91e63' } }
);
```

O Flutter fornece vários widgets especializados para gaveta e
navegação por guias:

[`TabController`][]
: Coordena a seleção de guias entre uma `TabBar`
  e uma `TabBarView`.

[`TabBar`][]
: Exibe uma linha horizontal de guias.

[`Tab`][]
: Cria uma guia TabBar de design de material.

[`TabBarView`][]
: Exibe o widget que corresponde à guia selecionada no momento.


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

Um `TabController` é necessário para coordenar a seleção de guias
entre uma `TabBar` e uma `TabBarView`.
O argumento `length` do construtor `TabController` é o
número total de guias. Um `TickerProvider` é necessário para acionar
a notificação sempre que um quadro aciona uma mudança de estado.
O `TickerProvider` é `vsync`. Passe o
argumento `vsync: this` para o construtor `TabController`
sempre que você criar um novo `TabController`.

O [`TickerProvider`][] é uma interface implementada
por classes que podem fornecer objetos [`Ticker`][].
Os tickers podem ser usados por qualquer objeto que
deva ser notificado sempre que um
quadro for acionado, mas são mais comumente usados indiretamente por meio de um
[`AnimationController`][]. `AnimationController`s
precisam de um `TickerProvider` para obter seu `Ticker`.
Se você estiver criando um AnimationController a partir de um State,
então você pode usar as classes [`TickerProviderStateMixin`][]
ou [`SingleTickerProviderStateMixin`][]
para obter um `TickerProvider` adequado.

O widget [`Scaffold`][] envolve um novo widget `TabBar` e
cria duas guias. O widget `TabBarView`
é passado como o parâmetro `body` do widget `Scaffold`.
Todas as telas correspondentes às guias do widget `TabBar` são
filhos do widget `TabBarView` junto com o mesmo `TabController`.

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

#### Navegação por gaveta

Em React Native, importe os pacotes react-navigation necessários e, em seguida, use
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

Em Flutter, podemos usar o widget `Drawer` em combinação com um
`Scaffold` para criar um layout com uma gaveta Material Design.
Para adicionar um `Drawer` a um aplicativo, envolva-o em um widget `Scaffold`.
O widget `Scaffold` fornece uma
estrutura visual consistente para aplicativos que seguem as
diretrizes do [Material Design][]. Ele também suporta
componentes especiais do Material Design,
como `Drawers`, `AppBars` e `SnackBars`.

O widget `Drawer` é um painel Material Design que desliza
horizontalmente da borda de um `Scaffold` para mostrar a navegação
links em um aplicativo. Você pode
fornecer um [`ElevatedButton`][], um widget [`Text`][],
ou uma lista de itens para exibir como filho do widget `Drawer`.
No exemplo a seguir, o widget [`ListTile`][]
fornece a navegação ao toque.

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

O widget `Scaffold` também inclui um widget `AppBar` que exibe automaticamente
um IconButton apropriado para mostrar o `Drawer` quando um Drawer está
disponível no `Scaffold`. O `Scaffold` lida automaticamente com o
gesto de deslizar na borda para mostrar o `Drawer`.

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

{% include docs/android-ios-figure-pair.md image="react-native/navigation.gif" alt="Navegação" class="border" %}

## Detecção de gestos e tratamento de eventos de toque

Para ouvir e responder a gestos,
o Flutter suporta toques, arrastos e dimensionamento.
O sistema de gestos em Flutter tem duas camadas separadas.
A primeira camada inclui eventos de ponteiro brutos,
que descrevem a localização e o movimento de ponteiros,
(como toques, movimentos do mouse e canetas), pela tela.
A segunda camada inclui gestos,
que descrevem ações semânticas
que consistem em um ou mais movimentos do ponteiro.

### Como eu adiciono um listener de clique ou pressão a um widget?

Em React Native, listeners são adicionados a componentes
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

Para gestos mais complexos e combinação de vários toques em
um único gesto, [`PanResponder`][] é usado.

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

Em Flutter, para adicionar um listener de clique (ou pressão) a um widget,
use um botão ou um widget tocável que tenha um `onPress: field`.
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

Para mais informações, incluindo uma lista de
callbacks do `GestureDetector` do Flutter,
veja a [classe GestureDetector][].

[classe GestureDetector]: {{site.api}}/flutter/widgets/GestureDetector-class.html#instance-properties

{% include docs/android-ios-figure-pair.md image="react-native/flutter-gestures.gif" alt="Gestos" class="border" %}

## Fazendo requisições de rede HTTP

Buscar dados da internet é comum para a maioria dos aplicativos. E em Flutter,
o pacote `http` fornece a maneira mais simples de buscar dados da internet.

### Como eu busco dados de chamadas de API?

O React Native fornece a API Fetch para rede&mdash;você faz uma solicitação de busca
e, em seguida, recebe a resposta para obter os dados.

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

O Flutter usa o cliente de suporte HTTP principal [`dart:io`][].
Para criar um cliente HTTP, importe `dart:io`.

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

{% include docs/android-ios-figure-pair.md image="react-native/api-calls.gif" alt="Chamadas de API" class="border" %}

## Entrada de formulário

Os campos de texto permitem que os usuários digitem texto em seu aplicativo para que possam ser
usados para construir formulários, aplicativos de mensagens, experiências de pesquisa e muito mais.
O Flutter fornece dois widgets de campo de texto principais:
[`TextField`][] e [`TextFormField`][].

### Como eu uso widgets de campo de texto?

Em React Native, para inserir texto, você usa um componente `TextInput` para mostrar uma
caixa de entrada de texto e, em seguida, usa o callback para armazenar o valor em uma variável.

```js
// React Native
const [password, setPassword] = useState('')
...
<TextInput
  placeholder="Digite sua senha"
  onChangeText={password => setPassword(password)}
/>
<Button title="Enviar" onPress={this.validate} />
```

Em Flutter, use a classe [`TextEditingController`][]
para gerenciar um widget `TextField`.
Sempre que o campo de texto é modificado,
o controlador notifica seus listeners.

Os listeners leem as propriedades de texto e seleção para
aprender o que o usuário digitou no campo.
Você pode acessar o texto em `TextField`
pela propriedade `text` do controlador.

<?code-excerpt "lib/examples.dart (text-editing-controller)"?>
```dart
final TextEditingController _controller = TextEditingController();

@override
Widget build(BuildContext context) {
  return Column(children: [
    TextField(
      controller: _controller,
      decoration: const InputDecoration(
        hintText: 'Digite algo',
        labelText: 'Campo de Texto',
      ),
    ),
    ElevatedButton(
      child: const Text('Enviar'),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Alerta'),
                content: Text('Você digitou ${_controller.text}'),
              );
            });
      },
    ),
  ]);
}
```

Neste exemplo, quando um usuário clica no botão de envio, uma caixa de diálogo de alerta
exibe o texto atual inserido no campo de texto.
Isso é obtido usando um widget [`AlertDialog`][]
que exibe a mensagem de alerta, e o texto do
`TextField` é acessado pela propriedade `text` do
[`TextEditingController`][].

### Como eu uso widgets Form?

Em Flutter, use o widget [`Form`][] onde
widgets [`TextFormField`][] junto com o botão de envio
são passados como filhos.
O widget `TextFormField` tem um parâmetro chamado
[`onSaved`][] que recebe um callback e executa
quando o formulário é salvo. Um objeto `FormState`
é usado para salvar, redefinir ou validar
cada `FormField` que é um descendente deste `Form`.
Para obter o `FormState`, você pode usar `Form.of()`
com um contexto cujo ancestral é o `Form`,
ou passar um `GlobalKey` para o construtor `Form` e chamar
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
            return 'Não é um e-mail válido.';
          },
          onSaved: (val) {
            _email = val;
          },
          decoration: const InputDecoration(
            hintText: 'Digite seu e-mail',
            labelText: 'E-mail',
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

O exemplo a seguir mostra como `Form.save()` e `formKey`
(que é um `GlobalKey`), são usados para salvar o formulário no envio.

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
            title: const Text('Alerta'),
            content: Text('E-mail: $_email, senha: $_password'));
      },
    );
  }
}
```

{% include docs/android-ios-figure-pair.md image="react-native/input-fields.gif" alt="Entrada" class="border" %}

## Código específico da plataforma

Ao construir um aplicativo multiplataforma, você deseja reutilizar o máximo de código possível
entre as plataformas. No entanto, podem surgir cenários em que
faz sentido que o código seja diferente dependendo do sistema operacional.
Isso requer uma implementação separada declarando uma plataforma específica.

Em React Native, a seguinte implementação seria usada:

```js
// React Native
if (Platform.OS === 'ios') {
  return 'iOS';
} else if (Platform.OS === 'android') {
  return 'android';
} else {
  return 'não reconhecido';
}
```

Em Flutter, use a seguinte implementação:

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
return 'não reconhecido ';
```

## Depuração

### Quais ferramentas posso usar para depurar meu aplicativo em Flutter?

Use o conjunto [DevTools][] para depurar aplicativos Flutter ou Dart.

O DevTools inclui suporte para perfil, exame do heap,
inspeção da árvore de widgets, diagnóstico de log, depuração,
observação de linhas de código executadas, depuração de vazamentos de memória e memória
fragmentação. Para mais informações, confira a
documentação do [DevTools][].

Se você estiver usando um IDE,
você pode depurar seu aplicativo usando o depurador do IDE.

### Como eu realizo um hot reload?

O recurso Stateful Hot Reload do Flutter ajuda você a experimentar de forma rápida e fácil,
construir UIs, adicionar recursos e corrigir bugs. Em vez de recompilar seu aplicativo
toda vez que você fizer uma alteração, você pode fazer o hot reload do seu aplicativo instantaneamente.
O aplicativo é atualizado para refletir sua alteração,
e o estado atual do aplicativo é preservado.

Em React Native,
o atalho é ⌘R para o Simulador iOS e tocar em R duas vezes em
emuladores Android.

Em Flutter, se você estiver usando o IntelliJ IDE ou o Android Studio,
você pode selecionar Salvar Tudo (⌘s/ctrl-s), ou você pode clicar no
botão Hot Reload na barra de ferramentas. Se você
estiver executando o aplicativo na linha de comando usando `flutter run`,
digite `r` na janela do Terminal.
Você também pode realizar uma reinicialização completa digitando `R` no
janela do terminal.

### Como eu acesso o menu de desenvolvedor no aplicativo?

Em React Native, o menu de desenvolvedor pode ser acessado agitando seu dispositivo: ⌘D
para o Simulador iOS ou ⌘M para o emulador Android.

Em Flutter, se você estiver usando um IDE, você pode usar as ferramentas do IDE. Se você iniciar
seu aplicativo usando `flutter run`, você também pode acessar o menu digitando `h`
na janela do terminal, ou digite os seguintes atalhos:

| Ação| Atalho do Terminal| Funções e propriedades de depuração|
| :------- | :------: | :------ |
| Hierarquia de widgets do aplicativo| `w`| debugDumpApp()|
| Árvore de renderização do aplicativo | `t`| debugDumpRenderTree()|
| Camadas| `L`| debugDumpLayerTree()|
| Acessibilidade | `S` (ordem de travessia) ou<br>`U` (ordem inversa de teste de acerto)|debugDumpSemantics()|
| Para alternar o inspetor de widgets | `i` | WidgetsApp. showWidgetInspectorOverride|
| Para alternar a exibição de linhas de construção| `p` | debugPaintSizeEnabled|
| Para simular diferentes sistemas operacionais| `o` | defaultTargetPlatform|
| Para exibir a sobreposição de desempenho | `P` | WidgetsApp. showPerformanceOverlay|
| Para salvar uma captura de tela em flutter. png| `s` ||
| Para sair| `q` ||

{:.table .table-striped}

## Animação

Uma animação bem projetada torna uma interface do usuário intuitiva,
contribui para a aparência de um aplicativo polido,
e melhora a experiência do usuário.
O suporte de animação do Flutter facilita
a implementação de animações simples e complexas.
O SDK do Flutter inclui muitos widgets Material Design
que incluem efeitos de movimento padrão,
e você pode facilmente personalizar esses efeitos
para personalizar seu aplicativo.

Em React Native, APIs animadas são usadas para criar animações.

Em Flutter, use a classe [`Animation`][]
e a classe [`AnimationController`][].
`Animation` é uma classe abstrata que entende seu
valor atual e seu estado (concluído ou dispensado).
A classe `AnimationController` permite que você
reproduza uma animação para frente ou para trás,
ou pare a animação e defina a animação
para um valor específico para personalizar o movimento.

### Como eu adiciono uma animação simples de fade-in?

No exemplo React Native abaixo, um componente animado,
`FadeInView` é criado usando a API Animated.
O estado de opacidade inicial, o estado final e o
duração ao longo da qual a transição ocorre são definidos.
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

Para criar a mesma animação em Flutter, crie um
objeto [`AnimationController`][] chamado `controller`
e especifique a duração. Por padrão, um `AnimationController`
produz linearmente valores que variam de 0,0 a 1,0,
durante uma determinada duração. O controlador de animação gera um novo valor
sempre que o dispositivo que executa seu aplicativo está pronto para exibir um novo quadro.
Normalmente, essa taxa é de cerca de 60 valores por segundo.

Ao definir um `AnimationController`,
você deve passar um objeto `vsync`.
A presença de `vsync` evita offscreen
animações de consumir recursos desnecessários.
Você pode usar seu objeto stateful como `vsync` adicionando
`TickerProviderStateMixin` à definição da classe.
Um `AnimationController` precisa de um TickerProvider,
que é configurado usando o argumento `vsync` no construtor.

Um [`Tween`][] descreve a interpolação entre um
valor inicial e final ou o mapeamento de um
intervalo de entrada para um intervalo de saída. Para usar um objeto `Tween`
com uma animação, chame o método `animate()` do objeto `Tween`
e passe a ele o objeto `Animation` que você deseja modificar.

Para este exemplo, um widget [`FadeTransition`][]
é usado e a propriedade `opacity` é
mapeada para o objeto `animation`.

Para iniciar a animação, use `controller.forward()`.
Outras operações também podem ser realizadas usando o
controlador como `fling()` ou `repeat()`.
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

### Como eu adiciono animação de deslizar para cartões?

Em React Native, o `PanResponder` ou
bibliotecas de terceiros são usadas para animação de deslizar.

Em Flutter, para adicionar uma animação de deslizar, use o
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

{% include docs/android-ios-figure-pair.md image="react-native/card-swipe.gif" alt="Deslizar cartão" class="border" %}

## Componentes equivalentes de widgets React Native e Flutter

A tabela a seguir lista componentes React Native comumente usados
mapeados para o widget Flutter correspondente
e propriedades de widget comuns.

| Componente React Native                                                                    | Widget Flutter                                                                                             | Descrição                                                                                                                            |
| ----------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| [`Button`](https://facebook.github.io/react-native/docs/button.html)                        | [`ElevatedButton`][]                           | Um botão elevado básico.                                                                              |
|                                                                                           |  onPressed [obrigatório]                                                                                        | O callback quando o botão é tocado ou ativado de outra forma.                                                          |
|                                                                                           | Child                                                                              | O rótulo do botão.                                                                                                      |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Button`](https://facebook.github.io/react-native/docs/button.html)                        | [`TextButton`][]                               | Um botão simples e plano.                                                                                                         |
|                                                                                           |  onPressed [obrigatório]                                                                                        | O callback quando o botão é tocado ou ativado de outra forma.                                                            |
|                                                                                           | Child                                                                              | O rótulo do botão.                                                                                                      |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`ScrollView`](https://facebook.github.io/react-native/docs/scrollview.html)                | [`ListView`][]                                    | Uma lista rolável de widgets dispostos linearmente.|
||        children                                                                              | 	( <Widget\> [ ])  Lista de widgets filhos para exibir.
||controller |[ [`ScrollController`][] ] Um objeto que pode ser usado para controlar um widget rolável.
||itemExtent|[ double ] Se não for nulo, força os filhos a terem a extensão dada na direção de rolagem.
||scroll Direction|[ [`Axis`][] ] O eixo ao longo do qual a visualização de rolagem rola.
||                                                                                                            |                                                                                                                                        |
| [`FlatList`](https://facebook.github.io/react-native/docs/flatlist.html)                    | [`ListView.builder`][]               | O construtor para uma matriz linear de widgets que são criados sob demanda.
||itemBuilder [obrigatório] |[[`IndexedWidgetBuilder`][]] ajuda na construção dos filhos sob demanda. Este callback é chamado apenas com índices maiores ou iguais a zero e menores que itemCount.
||itemCount |[ int ] melhora a capacidade do `ListView` de estimar a extensão máxima de rolagem.
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Image`](https://facebook.github.io/react-native/docs/image.html)                         | [`Image`][]                                           | Um widget que exibe uma imagem.                                                                                                       |
|                                                                                           |  image [obrigatório]                                                                                          | A imagem a ser exibida.                                                                                                                  |
|                                                                                           | Image. asset                                                                                                | Vários construtores são fornecidos para as várias maneiras pelas quais uma imagem pode ser especificada.                                                 |
|                                                                                           | width, height, color, alignment                                                                            | O estilo e o layout da imagem.                                                                                                         |
|                                                                                           | fit                                                                                                        | Inscrevendo a imagem no espaço alocado durante o layout.                                                                           |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`Modal`](https://facebook.github.io/react-native/docs/modal.html)                          | [`ModalRoute`][]                                | Uma rota que bloqueia a interação com rotas anteriores.                                                                                  |
|                                                                                           | animation                                                                                                  | A animação que impulsiona a transição da rota e a transição para frente da rota anterior.                                          |
|                                                                                           |                                                                                                            |                                                                                                                                        |
|  [`ActivityIndicator`](https://facebook.github.io/react-native/docs/activityindicator.html) | [`CircularProgressIndicator`][] | Um widget que mostra o progresso ao longo de um círculo.                                                                                           |
|                                                                                           | strokeWidth                                                                                                | A largura da linha usada para desenhar o círculo.                                                                                         |
|                                                                                           | backgroundColor                                                                                            | A cor de fundo do indicador de progresso. A `ThemeData.backgroundColor` do tema atual por padrão.                                   |
|                                                                                           |                                                                                                            |                                                                                                                                        |
|  [`ActivityIndicator`](https://facebook.github.io/react-native/docs/activityindicator.html) | [`LinearProgressIndicator`][]     | Um widget que mostra o progresso ao longo de uma linha.                                                                                           |
|                                                                                           | value                                                                                                      | O valor deste indicador de progresso.                                                                                                   |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`RefreshControl`](https://facebook.github.io/react-native/docs/refreshcontrol.html)        | [`RefreshIndicator`][]                   | Um widget que suporta o idioma Material "deslizar para atualizar".                                                                          |
|                                                                                           | color                                                                                                      | A cor de primeiro plano do indicador de progresso.                                                                                             |
|                                                                                           | onRefresh                                                                                                  | Uma função que é chamada quando um usuário arrasta o indicador de atualização longe o suficiente para demonstrar que deseja que o aplicativo atualize. |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Container`][]                                  | Um widget que envolve um widget filho.                                                                                                                |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Column`][]                                        | Um widget que exibe seus filhos em uma matriz vertical.                                                                                              |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Row`][]                                              | Um widget que exibe seus filhos em uma matriz horizontal.                                                                                            |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Center`][]                                        | Um widget que centraliza seu filho dentro de si.                                                                                                       |
|                                                                                           |                                                                                                            |                                                                                                                                        |
| [`View`](https://facebook.github.io/react-native/docs/view.html)                            | [`Padding`][]                                      | Um widget que insere seu filho pelo preenchimento fornecido.                                                                                                 |
|                                                                                           | padding [obrigatório]                                                                                         | [ EdgeInsets ] A quantidade de espaço para inserir o filho.
|||
| [`TouchableOpacity`](https://facebook.github.io/react-native/docs/touchableopacity.html)    | [`GestureDetector`][]                      | Um widget que detecta gestos.                                                                                                                       |
|                                                                                           | onTap                                                                                                      | Um callback quando ocorre um toque.                                                                                                               |
|                                                                                           | onDoubleTap                                                                                                | Um callback quando ocorre um toque no mesmo local duas vezes em rápida sucessão.
|||
| [`TextInput`](https://facebook.github.io/react-native/docs/textinput.html)                | [`TextInput`][]                                   | A interface para o controle de entrada de texto do sistema.                                                                                           |
|                                                                                           | controller                                                                                                 | [ [`TextEditingController`][] ] usado para acessar e modificar o texto.
|||
| [`Text`](https://facebook.github.io/react-native/docs/text.html)                          | [`Text`][]                                            | O widget Text que exibe uma string de texto com um único estilo.                                                                                                                                                                           |
|                                                                                         | data                                                                                                      | [ String ] O texto a ser exibido.                                                                                                                                                                              |
|                                                                                         | textDirection                                                                                             | [ [`TextAlign`][] ] A direção em que o texto flui.                                                                                     |
|                                                                                         |                                                                                                           |                                                                                                                                                                                                              |
| [`Switch`](https://facebook.github.io/react-native/docs/switch.html)                      | [`Switch`][]                                      | Uma chave de design de material.                                                                                                                                                                                    |
|                                                                                         | value [obrigatório]                                                                                          | [ boolean ] Se esta chave está ligada ou desligada.                                                                                                                                                                 |
|                                                                                         | onChanged [obrigatório]                                                                                      | [ callback ] Chamado quando o usuário liga ou desliga a chave.                                                                                                                                               |
|                                                                                         |                                                                                                           |                                                                                                                                                                                                              |
| [`Slider`](https://facebook.github.io/react-native/docs/slider.html)                      | [`Slider`][]                                      | Usado para selecionar a partir de um intervalo de valores.                                                                                                                                                                       |
|                                                                                         | value [obrigatório]                                                                                          | [ double ] O valor atual do controle deslizante.                                                                                                                                                                           |
|                                                                                         | onChanged [obrigatório]                                                                                      | Chamado quando o usuário seleciona um novo valor para o controle deslizante.                                                                                                                                                      |

{:.table .table-striped}


[`AboutDialog`]: {{site.api}}/flutter/material/AboutDialog-class.html
[Adicionando Ativos e Imagens no Flutter]: /ui/assets/assets-and-images
[`AlertDialog`]: {{site.api}}/flutter/material/AlertDialog-class.html
[`Align`]: {{site.api}}/flutter/widgets/Align-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[async e await]: {{site.dart-site}}/language/async
[`Axis`]: {{site.api}}/flutter/painting/Axis.html
[`BuildContext`]: {{site.api}}/flutter/widgets/BuildContext-class.html
[`Center`]: {{site.api}}/flutter/widgets/Center-class.html
[paleta de cores]: {{site.material2}}/design/color/the-color-system.html#color-theme-creation
[cores]: {{site.api}}/flutter/material/Colors-class.html
[`Colors`]: {{site.api}}/flutter/material/Colors-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`Checkbox`]: {{site.api}}/flutter/material/Checkbox-class.html
[`CircleAvatar`]: {{site.api}}/flutter/material/CircleAvatar-class.html
[`CircularProgressIndicator`]: {{site.api}}/flutter/material/CircularProgressIndicator-class.html
[Cupertino (estilo iOS)]: /ui/widgets/cupertino
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
[Desenvolvendo Pacotes e Plugins]: /packages-and-plugins/developing-packages
[DevTools]: /tools/devtools
[`Dismissible`]: {{site.api}}/flutter/widgets/Dismissible-class.html
[`FadeTransition`]: {{site.api}}/flutter/widgets/FadeTransition-class.html
[Pacotes Flutter]: {{site.pub}}/flutter/
[Visão Geral da Arquitetura do Flutter]: /resources/architectural-overview
[Widgets Básicos do Flutter]: /ui/widgets/basics
[Visão Geral Técnica do Flutter]: /resources/architectural-overview
[Catálogo de Widgets do Flutter]: /ui/widgets
[Índice de Widgets do Flutter]: /reference/widgets
[`FlutterLogo`]: {{site.api}}/flutter/material/FlutterLogo-class.html
[`Form`]: {{site.api}}/flutter/widgets/Form-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html
[funções]: {{site.dart-site}}/language/functions
[`Future`]: {{site.dart-site}}/tutorials/language/futures
[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[Introdução]: /get-started
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`IndexedWidgetBuilder`]: {{site.api}}/flutter/widgets/IndexedWidgetBuilder.html
[`InheritedWidget`]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[Widgets de Layout]: /ui/widgets/layout
[`LinearProgressIndicator`]: {{site.api}}/flutter/material/LinearProgressIndicator-class.html
[`ListTile`]: {{site.api}}/flutter/material/ListTile-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`ListView.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[Material Design]: {{site.material}}/styles
[ícones Material]: {{site.api}}/flutter/material/Icons-class.html
[`MaterialApp`]: {{site.api}}/flutter/material/MaterialApp-class.html
[`MaterialPageRoute`]: {{site.api}}/flutter/material/MaterialPageRoute-class.html
[`ModalRoute`]: {{site.api}}/flutter/widgets/ModalRoute-class.html
[`Navigator`]: {{site.api}}/flutter/widgets/Navigator-class.html
[`Navigator.of()`]: {{site.api}}/flutter/widgets/Navigator/of.html
[`Navigator.pop`]: {{site.api}}/flutter/widgets/Navigator/pop.html
[`Navigator.push`]: {{site.api}}/flutter/widgets/Navigator/push.html
[`onSaved`]: {{site.api}}/flutter/widgets/FormField/onSaved.html
[parâmetros nomeados]: {{site.dart-site}}/language/functions#named-parameters
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
[Gerenciamento de estado]: /data-and-backend/state-mgmt
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
[Usando Pacotes]: /packages-and-plugins/using-packages
[variáveis]: {{site.dart-site}}/language/variables
[`WidgetBuilder`]: {{site.api}}/flutter/widgets/WidgetBuilder.html
[infinite_list]: {{site.repo.samples}}/tree/main/infinite_list
