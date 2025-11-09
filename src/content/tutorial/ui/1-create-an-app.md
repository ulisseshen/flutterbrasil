---
ia-translate: true
title: Crie um app
description: Instruções sobre como criar um novo app Flutter.
permalink: /tutorial/create-an-app/
sitemap: false
---

{%- comment %}
<!-- TODO(ewindmill) embed video -->
{%- endcomment %}

Nesta primeira seção do tutorial do Flutter, você construirá a UI principal de um
app chamado 'Birdle', um jogo similar ao [Wordle, o popular jogo do New York Times][Wordle, the popular New York Times game].

Ao final deste tutorial, você terá aprendido os fundamentos de construção
de UIs Flutter, e seu app se parecerá com a seguinte captura de tela (e ele
até funcionará quase completamente 😀).

<img src='/assets/images/docs/tutorial/birdle.png' width="100%" alt="A screenshot that resembles the popular game Wordle.">

## Crie um novo projeto Flutter

O primeiro passo para construir apps Flutter é criar um novo projeto. Você cria
novos apps com a [ferramenta CLI do Flutter][Flutter CLI tool], instalada como parte do SDK do Flutter.

Abra seu terminal ou prompt de comando e execute o seguinte comando para criar um
novo projeto Flutter:

```shell
$ flutter create birdle --empty
```

Isso cria um novo projeto Flutter usando o template mínimo "empty".

## Examine o código

Na sua IDE, abra o arquivo em `lib/main.dart`. Começando do topo, você verá
este código.

```dart
import 'package:flutter/material.dart'; // imports Flutter

void main() {
  runApp(const MainApp());
}
// ...
```

A função `main` é o ponto de entrada para qualquer programa Dart, e um app Flutter é
apenas um programa **Dart**. O método `runApp` é parte do SDK do Flutter, e ele
recebe um **widget** como argumento. (A maior parte deste tutorial é sobre widgets, mas
em termos mais simples um widget é um objeto Dart que descreve um pedaço de UI.)
Neste caso, uma instância do widget `MainApp` está sendo passada.

Logo abaixo da função `main`, você encontrará a declaração da classe `MainApp`.

```dart
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),
        ),
      ),
    );
  }
}

```

`MainApp` é o **widget raiz**, pois é o widget que é passado para
`runApp`. Dentro deste widget, há um método `build`, que retorna outro
widget chamado `MaterialApp`.  Essencialmente, isto é o que um app Flutter é: uma
composição de Widgets que formam uma estrutura de árvore chamada **árvore de widgets.**
Seu trabalho como desenvolvedor Flutter é compor widgets do SDK em widgets maiores e
personalizados que exibem uma UI.

No momento, a árvore de widgets é bem simples:

<img src='/assets/images/docs/tutorial/initial_widget_tree.png' alt="A screenshot that resembles the popular game Wordle.">

## Execute seu app

No seu terminal na raiz do seu app Flutter, execute:

```shell
$ cd birdle
$ flutter run -d chrome
```

O app será compilado e iniciará em uma nova instância do Chrome.

<img src='/assets/images/docs/tutorial/hello_world.png' alt="A screenshot that resembles the popular game Wordle.">

## Use hot reload

**Stateful hot reload**, se você ainda não ouviu falar, permite que um app Flutter em execução
re-renderize lógica de negócio ou código de UI atualizado em menos de um segundo - tudo
sem perder seu lugar no app.

Na sua IDE, abra o arquivo `main.dart` e navegue até a linha ~15 e encontre este
código:

```dart
child: Text('Hello World!'),
```

Mude o texto dentro da string para qualquer coisa que você queira. Então, faça hot-reload do seu
app pressionando `r` no seu terminal onde o app está sendo executado. O app em execução
deve instantaneamente mostrar seu texto atualizado.


[Flutter CLI tool]: /reference/flutter-cli
[Wordle, the popular New York Times game]: https://www.nytimes.com/games/wordle/index.html
[read more about using pub packages]: {{site.dart-site}}/tools/pub/packages
[`flutter_gse`]: {{site.pub}}/packages/flutter_gse
