---
ia-translate: true
title: Widgets
description: Aprenda os blocos de construção básicos do Flutter.
prev:
  title: Intro to Dart
  path: /get-started/fundamentals/dart
next:
  title: Layout
  path: /get-started/fundamentals/layout
---

Para começar com Flutter,
você precisa ter alguma familiaridade com a linguagem de programação Dart, na qual aplicações
Flutter são escritas, e widgets,
que são os blocos de construção da UI do Flutter.
Ambos serão apresentados nesta página, mas você continuará
aprendendo sobre cada um ao longo desta série.
Recursos adicionais estão listados ao longo desta página,
mas você não precisa ser um especialista em nenhum dos
assuntos para continuar.

## Widgets

Em relação ao Flutter, você frequentemente ouvirá
"tudo é um widget".
Widgets são os blocos de construção da
interface de usuário de um app Flutter,
e cada widget é uma declaração imutável de parte
da interface do usuário. Widgets são usados
para descrever todos os aspectos de uma interface de usuário,
incluindo aspectos físicos como texto e botões até
efeitos de layout como padding e alinhamento.

Widgets formam uma hierarquia baseada em composição.
Cada widget se aninha dentro de seu pai e
pode receber contexto do pai.
Esta estrutura vai até o widget raiz,
como este exemplo trivial mostra:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Root widget
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My Home Page'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Hello, World!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Click!');
                    },
                    child: const Text('A button'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
```

No código anterior,
todas as classes instanciadas são widgets:
`MaterialApp`, `Scaffold`, `AppBar`, `Text`,
`Center`, `Builder`, `Column`, `SizedBox`, e
`ElevatedButton`.

### Composição de widgets

Como mencionado, Flutter enfatiza widgets como uma unidade
de composição. Widgets são tipicamente compostos de
muitos outros widgets pequenos e de propósito único que
se combinam para produzir efeitos poderosos.

Existem widgets de layout como
`Padding`, `Alignment`, `Row`, `Column`,
e `Grid`. Esses widgets de layout não têm
representação visual própria.
Em vez disso, seu único propósito é
controlar algum aspecto do layout de outro widget.
Flutter também inclui widgets utilitários que
aproveitam essa abordagem de composição.
Por exemplo, `Container`, um widget comumente usado,
é composto por vários widgets responsáveis por layout,
pintura, posicionamento e dimensionamento.
Alguns widgets têm representação visual,
como `ElevatedButton` e
`Text` no exemplo anterior, assim como
widgets como `Icon` e `Image`.

Se você executar o código do exemplo anterior,
Flutter pinta um botão com o texto
"Hello, World!" centralizado na tela, organizado verticalmente.
Para posicionar esses elementos, há um widget `Center`,
que posiciona seus filhos no centro
do espaço disponível, e um widget `Column`,
que organiza seus filhos verticalmente um após o outro.

<img src='/assets/images/docs/fwe/simple_composition_example.png' width="100%" alt="A diagram that shows widget composition with a series of lines and nodes.">


Na [próxima página][next page] desta série, você
aprenderá mais sobre layout no Flutter.

### Construindo widgets

Para criar uma interface de usuário no Flutter,
você sobrescreve o método [`build`][] em objetos widget.
Todos os widgets devem ter um método build,
e ele deve retornar outro widget. Por exemplo,
se você quiser adicionar texto à tela com algum padding,
você poderia escrever assim:

```dart
class PaddedText extends StatelessWidget {
  const PaddedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text('Hello, World!'),
    );
  }
}
```

O framework chama o método `build` quando este
widget é criado e quando as dependências deste
widget mudam (como estado que é passado para o widget).
Este método pode potencialmente ser chamado em cada frame
e não deve ter efeitos colaterais além de
construir um widget.
Para aprender mais sobre como Flutter renderiza widgets,
confira a [visão geral arquitetural do Flutter][Flutter architectural overview].

### Estado do widget

O framework introduz duas classes principais de widget:
widgets stateful e stateless.

Widgets que não têm estado mutável
(eles não têm propriedades de classe
que mudam ao longo do tempo) estendem [`StatelessWidget`][].
Muitos widgets integrados são stateless,
como `Padding`, `Text`, e `Icon`.
Quando você cria seus próprios widgets,
você criará widgets `Stateless` na maioria das vezes.

Por outro lado,
se as características únicas de um widget precisam mudar
com base na interação do usuário ou outros fatores,
esse widget é stateful.
Por exemplo, se um widget tem um contador que
incrementa sempre que o usuário toca em um botão,
então o valor do contador é o estado desse widget.
Quando esse valor muda, o widget precisa ser
reconstruído para atualizar sua parte da UI.
Esses widgets estendem [`StatefulWidget`][],
e (porque o widget em si é imutável)
eles armazenam estado mutável em uma classe separada que
estende [`State`][].
`StatefulWidgets` não têm um método `build`;
em vez disso, sua interface de usuário é construída através
de seu objeto `State`, como mostrado no exemplo abaixo.

```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text('$_counter');
  }
}
```

Sempre que você mutar um objeto `State`
(por exemplo, incrementando o contador),
você deve chamar [`setState`][] para sinalizar ao framework
para atualizar a interface de usuário
chamando o método `build` do `State` novamente.

Separar estado de objetos widget
permite que outros widgets tratem widgets
stateless e stateful exatamente da mesma forma,
sem se preocupar em perder estado.
Em vez de precisar reter
um filho para preservar seu estado,
o pai pode criar uma nova instância do filho
a qualquer momento sem perder
o estado persistente do filho.
O framework faz todo o trabalho de encontrar e
reutilizar objetos de estado existentes quando apropriado.

Há mais informações sobre
objetos [`StatefulWidget`][] mais adiante nesta
série, na [lição de gerenciamento de estado][state management lesson].

## Widgets importantes para conhecer

O Flutter SDK inclui muitos widgets integrados,
das menores peças de UI, como `Text`,
até widgets de layout, e widgets que estilizam
sua aplicação. Os seguintes widgets são
os mais importantes para estar ciente ao avançar para a
próxima lição no caminho de aprendizado.

* [`Container`][]
* [`Text`][]
* [`Scaffold`][]
* [`AppBar`][]
* [`Row`][] e [`Column`][]
* [`ElevatedButton`][]
* [`Image`][]
* [`Icon`][]

## Próximo: Layouts

Esta página é uma introdução a conceitos
fundamentais do Flutter, como widgets,
e ajuda você a se familiarizar com a leitura
de código Flutter e Dart. Não há problema se você não
se sentir claro sobre cada tópico que encontrou, pois cada página depois
desta é um mergulho profundo em tópicos específicos.
Na próxima seção, você começará a construir
UIs mais interessantes criando layouts mais complexos no Flutter.

Se você quiser praticar com as
informações que aprendeu nesta página,
você pode ler [Construindo interfaces de usuário com Flutter][Building user interfaces with Flutter].

[Building user interfaces with Flutter]: /ui
[`build`]: {{site.api}}/flutter/widgets/StatelessWidget/build.html
[next page]: /get-started/fundamentals/layout
[Flutter architectural overview]: /resources/architectural-overview
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[state management lesson]: /get-started/fundamentals/state-management
[`AppBar`]: {{site.api}}/flutter/material/AppBar-class.html
[`Column`]: {{site.api}}/flutter/widgets/Column-class.html
[`Container`]: {{site.api}}/flutter/widgets/Container-class.html
[`ElevatedButton`]: {{site.api}}/flutter/material/ElevatedButton-class.html
[`Icon`]: {{site.api}}/flutter/widgets/Icon-class.html
[`Image`]: {{site.api}}/flutter/widgets/Image-class.html
[`Row`]: {{site.api}}/flutter/widgets/Row-class.html
[`Scaffold`]: {{site.api}}/flutter/material/Scaffold-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html

## Feedback

À medida que esta seção do site evolui,
[recebemos bem seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="widgets"
