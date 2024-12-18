---
ia-translate: true
title: Widgets
description: Aprenda os blocos de construção básicos do Flutter.
prev:
  title: Introdução ao Dart
  path: /get-started/fundamentals/dart
next:
  title: Layout
  path: /get-started/fundamentals/layout
---

Para começar com Flutter, você precisa ter alguma familiaridade
com a linguagem de programação Dart, na qual os aplicativos
Flutter são escritos, e com os widgets, que são os blocos de
construção da UI do Flutter. Ambos serão introduzidos nesta
página, mas você continuará aprendendo sobre cada um ao longo
desta série. Recursos adicionais são listados ao longo desta
página, mas você não precisa ser um especialista em nenhum dos
assuntos para continuar.

## Widgets

Em relação ao Flutter, você costuma ouvir
"tudo é um widget". Widgets são os blocos de
construção da interface do usuário de um aplicativo
Flutter, e cada widget é uma declaração imutável de parte
da interface do usuário. Widgets são usados para
descrever todos os aspectos de uma interface do usuário,
incluindo aspectos físicos como texto e botões para
dispor efeitos como padding e alinhamento.

Widgets formam uma hierarquia baseada em composição.
Cada widget se aninha dentro de seu pai e
pode receber contexto do pai.
Essa estrutura segue até o widget raiz,
como mostra este exemplo trivial:

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // Widget Raiz
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Minha Página Inicial'),
        ),
        body: Center(
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  const Text('Olá, Mundo!'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      print('Clique!');
                    },
                    child: const Text('Um botão'),
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

No código anterior, todas as classes instanciadas são widgets:
`MaterialApp`, `Scaffold`, `AppBar`, `Text`,
`Center`, `Builder`, `Column`, `SizedBox` e
`ElevatedButton`.

### Composição de Widgets

Como mencionado, Flutter enfatiza widgets como uma unidade
de composição. Os widgets são normalmente compostos por
muitos outros widgets pequenos e de propósito único que
se combinam para produzir efeitos poderosos.

Existem widgets de layout como
`Padding`, `Alignment`, `Row`, `Column` e `Grid`.
Esses widgets de layout não têm uma representação
visual própria. Em vez disso, seu único propósito é
controlar algum aspecto do layout de outro widget.
Flutter também inclui widgets utilitários que
aproveitam essa abordagem composicional.
Por exemplo, `Container`, um widget comumente usado,
é composto por vários widgets responsáveis pelo layout,
pintura, posicionamento e dimensionamento.
Alguns widgets têm representação visual,
como `ElevatedButton` e
`Text` no exemplo anterior, bem como
widgets como `Icon` e `Image`.

Se você executar o código do exemplo anterior,
o Flutter pinta um botão com o texto
"Olá, Mundo!" centralizado na tela, disposto verticalmente.
Para posicionar esses elementos, há um widget `Center`,
que posiciona seus filhos no centro do espaço disponível,
e um widget `Column`, que dispõe seus filhos verticalmente,
um após o outro.

<img src='/assets/images/docs/fwe/simple_composition_example.png' width="100%" alt="Um diagrama que mostra a composição de widgets com uma série de linhas e nós.">

Na [próxima página][] desta série, você aprenderá
mais sobre layout no Flutter.

### Construindo widgets

Para criar uma interface do usuário no Flutter,
você sobrescreve o método [`build`][] em objetos widget.
Todos os widgets devem ter um método `build`,
e ele deve retornar outro widget. Por exemplo,
se você quiser adicionar texto à tela com algum padding,
você pode escrevê-lo assim:

```dart
class PaddedText extends StatelessWidget {
  const PaddedText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text('Olá, Mundo!'),
    );
  }
}
```

O framework chama o método `build` quando este
widget é criado e quando as dependências deste
widget mudam (como o estado que é passado para o widget).
Este método pode ser potencialmente chamado em cada frame
e não deve ter nenhum efeito colateral além de
construir um widget.
Para saber mais sobre como o Flutter renderiza widgets,
confira a [visão geral arquitetônica do Flutter][].

### Estado do widget

O framework introduz duas classes principais de widget:
widgets com estado e widgets sem estado.

Widgets que não têm estado mutável
(eles não têm propriedades de classe
que mudam ao longo do tempo) são subclasses de [`StatelessWidget`][].
Muitos widgets integrados são sem estado,
como `Padding`, `Text` e `Icon`.
Quando você cria seus próprios widgets,
você criará widgets `Stateless` na maioria das vezes.

Por outro lado,
se as características únicas de um widget precisam mudar
com base na interação do usuário ou outros fatores,
esse widget é com estado.
Por exemplo, se um widget tem um contador que
incrementa sempre que o usuário toca em um botão,
então o valor do contador é o estado para esse widget.
Quando esse valor muda, o widget precisa ser
reconstruído para atualizar sua parte da UI.
Esses widgets são subclasses de [`StatefulWidget`][],
e (porque o próprio widget é imutável) eles armazenam
o estado mutável em uma classe separada que
é subclasse de [`State`][].
`StatefulWidgets` não têm um método `build`;
em vez disso, sua interface do usuário é construída por meio
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

Sempre que você altera um objeto `State`
(por exemplo, incrementando o contador),
você deve chamar [`setState`][] para sinalizar o framework
para atualizar a interface do usuário chamando
o método `build` do `State` novamente.

Separar o estado dos objetos widget permite que outros
widgets tratem widgets sem estado e com estado exatamente
da mesma forma, sem se preocupar em perder o estado.
Em vez de precisar manter um filho para preservar seu
estado, o pai pode criar uma nova instância do filho
a qualquer momento sem perder
o estado persistente do filho.
O framework faz todo o trabalho de encontrar e
reutilizar objetos de estado existentes quando apropriado.

Há mais informações sobre objetos
[`StatefulWidget`][] mais adiante nesta
série, na [lição de gerenciamento de estado][].

## Widgets importantes para conhecer

O SDK do Flutter inclui muitos widgets integrados,
desde as menores partes da UI, como `Text`,
até widgets de layout e widgets que estilizam
seu aplicativo. Os seguintes widgets são os mais
importantes para estar ciente ao passar para a
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

Esta página é uma introdução aos conceitos
fundamentais do Flutter, como widgets, e ajuda você a se
familiarizar com a leitura do código Flutter e Dart.
Tudo bem se você não estiver claro sobre todos os tópicos que
encontrou, pois cada página após esta é um mergulho profundo
em tópicos específicos. Na próxima seção, você começará a
construir UIs mais interessantes criando layouts mais
complexos no Flutter.

Se você quiser praticar as informações que
aprendeu nesta página, você pode ler [Construindo
interfaces de usuário com Flutter][].

[Construindo interfaces de usuário com Flutter]: /ui
[`build`]: {{site.api}}/flutter/widgets/StatelessWidget/build.html
[próxima página]: /get-started/fundamentals/layout
[visão geral arquitetônica do Flutter]: /resources/architectural-overview
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[lição de gerenciamento de estado]: /get-started/fundamentals/state-management
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

Como esta seção do site está em evolução,
nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_6A9KxXR7XmMrNsy?page="widgets"
