---
ia-translate: true
title: Lista de abordagens de gerenciamento de estado
description: Uma lista de diferentes abordagens para gerenciar estado.
prev:
  title: Simple app state management
  path: /development/data-and-backend/state-mgmt/simple
---

Gerenciamento de estado é um tópico complexo.
Se você sente que algumas de suas perguntas não foram respondidas,
ou que a abordagem descrita nestas páginas
não é viável para seus casos de uso, você provavelmente está certo.

Saiba mais nos seguintes links,
muitos dos quais foram contribuídos pela comunidade Flutter:

## Visão geral

Coisas para revisar antes de selecionar uma abordagem.

* [Introdução ao gerenciamento de estado][Introduction to state management],
  que é o início desta mesma seção
  (para aqueles que chegaram diretamente a esta página de _Opções_
  e perderam as páginas anteriores)
* [Pragmatic State Management in Flutter][],
  um vídeo do Google I/O 2019
* [Flutter Architecture Samples][], por Brian Egan

[Flutter Architecture Samples]: https://fluttersamples.com/
[Introduction to state management]: /data-and-backend/state-mgmt/intro
[Pragmatic State Management in Flutter]: {{site.yt.watch}}?v=d_m5csmrf7I

## Provider

* [Gerenciamento de estado de app simples][Simple app state management], a página anterior nesta seção
* [Pacote Provider][Provider package]

[Provider package]: {{site.pub-pkg}}/provider
[Simple app state management]: /data-and-backend/state-mgmt/simple

## Riverpod

Riverpod funciona de maneira similar ao Provider.
Ele oferece segurança de compilação e testes sem depender do Flutter SDK.

* [Página inicial do Riverpod][Riverpod]
* [Começando com Riverpod][Getting started with Riverpod]

[Getting started with Riverpod]: https://riverpod.dev/docs/introduction/getting_started
[Riverpod]: https://riverpod.dev/

## setState

A abordagem de baixo nível para usar para estado efêmero específico de widget.

* [Adicionando interatividade ao seu app Flutter][Adding interactivity to your Flutter app], um tutorial Flutter
* [Basic state management in Google Flutter][], por Agung Surya

[Adding interactivity to your Flutter app]: /ui/interactivity
[Basic state management in Google Flutter]: {{site.medium}}/@agungsurya/basic-state-management-in-google-flutter-6ee73608f96d

## ValueNotifier &amp; InheritedNotifier

Uma abordagem usando apenas ferramentas fornecidas pelo Flutter para atualizar o estado e notificar a UI sobre mudanças.


* [State Management using ValueNotifier and InheritedNotifier][], por Tadas Petra

[State Management using ValueNotifier and InheritedNotifier]: https://www.hungrimind.com/articles/flutter-state-management

## InheritedWidget &amp; InheritedModel

A abordagem de baixo nível usada para comunicar entre ancestrais e filhos
na árvore de widgets. É isso que `provider` e muitas outras abordagens
usam por baixo dos panos.

O seguinte workshop em vídeo conduzido por instrutor cobre como
usar `InheritedWidget`:

{% ytEmbed 'LFcGPS6cGrY', 'How to manage application state using inherited widgets' %}

Outros documentos úteis incluem:

* [Documentação do InheritedWidget][InheritedWidget docs]
* [Managing Flutter Application State With InheritedWidgets][],
  por Hans Muller
* [Inheriting Widgets][], por Mehmet Fidanboylu
* [Using Flutter Inherited Widgets Effectively][], por Eric Windmill
* [Widget - State - Context - InheritedWidget][], por Didier Bolelens

[InheritedWidget docs]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Inheriting Widgets]: {{site.medium}}/@mehmetf_71205/inheriting-widgets-b7ac56dbbeb1
[Managing Flutter Application State With InheritedWidgets]: {{site.flutter-medium}}/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
[Using Flutter Inherited Widgets Effectively]: https://ericwindmill.com/articles/inherited_widget/
[Widget - State - Context - InheritedWidget]: https://www.didierboelens.com/2018/06/widget---state---context---inheritedwidget/

## June

Uma biblioteca de gerenciamento de estado leve e moderna que se concentra em fornecer
um padrão similar ao gerenciamento de estado integrado do Flutter.

* [Pacote june][june package]

[june package]: {{site.pub-pkg}}/june


## Redux

Uma abordagem de contêiner de estado familiar para muitos desenvolvedores web.

* [Animation Management with Redux and Flutter][],
  um vídeo da DartConf 2018 [Artigo acompanhante no Medium][Accompanying article on Medium]
* [Pacote Flutter Redux][Flutter Redux package]
* [Redux Saga Middleware Dart and Flutter][], por Bilal Uslu
* [Introduction to Redux in Flutter][], por Xavi Rigau
* [Flutter + Redux&mdash;How to make a shopping list app][],
  por Paulina Szklarska no Hackernoon
* [Building a TODO application (CRUD) in Flutter with Redux&mdash;Part 1][],
  um vídeo de Tensor Programming
* [Flutter Redux Thunk, an example][], por Jack Wong
* [Building a (large) Flutter app with Redux][], por Hillel Coren
* [Fish-Redux–An assembled flutter application framework based on Redux][],
  por Alibaba
* [Async Redux–Redux without boilerplate. Allows for both sync and async reducers][],
  por Marcelo Glasberg
* [Flutter meets Redux: The Redux way of managing Flutter applications state][],
  por Amir Ghezelbash
* [Redux and epics for better-organized code in Flutter apps][], por Nihad Delic
* [Flutter_Redux_Gen - VS Code Plugin to generate boiler plate code][], por Balamurugan Muthusamy (BalaDhruv)
* [Flutter Animations Studio][], por Gianluca Romeo

[Accompanying article on Medium]: {{site.flutter-medium}}/animation-management-with-flutter-and-flux-redux-94729e6585fa
[Animation Management with Redux and Flutter]: {{site.yt.watch}}?v=9ZkLtr0Fbgk
[Async Redux–Redux without boilerplate. Allows for both sync and async reducers]: {{site.pub}}/packages/async_redux
[Building a (large) Flutter app with Redux]: https://hillelcoren.com/2018/06/01/building-a-large-flutter-app-with-redux/
[Building a TODO application (CRUD) in Flutter with Redux&mdash;Part 1]: {{site.yt.watch}}?v=Wj216eSBBWs
[Fish-Redux–An assembled flutter application framework based on Redux]: {{site.github}}/alibaba/fish-redux/
[Flutter Redux Thunk, an example]: {{site.medium}}/flutterpub/flutter-redux-thunk-27c2f2b80a3b
[Flutter meets Redux: The Redux way of managing Flutter applications state]: {{site.medium}}/@thisisamir98/flutter-meets-redux-the-redux-way-of-managing-flutter-applications-state-f60ef693b509
[Flutter Redux package]: {{site.pub-pkg}}/flutter_redux
[Flutter + Redux&mdash;How to make a shopping list app]: https://hackernoon.com/flutter-redux-how-to-make-shopping-list-app-1cd315e79b65
[Introduction to Redux in Flutter]: https://blog.novoda.com/introduction-to-redux-in-flutter/
[Redux and epics for better-organized code in Flutter apps]: {{site.medium}}/upday-devs/reduce-duplication-achieve-flexibility-means-success-for-the-flutter-app-e5e432839e61
[Redux Saga Middleware Dart and Flutter]: {{site.pub-pkg}}/redux_saga
[Flutter_Redux_Gen - VS Code Plugin to generate boiler plate code]: https://marketplace.visualstudio.com/items?itemName=BalaDhruv.flutter-redux-gen
[Flutter Animations Studio]: {{site.github}}/gianlucaromeo/flutter-animations-studio

## Fish-Redux

Fish Redux é um framework de aplicação flutter montado
baseado em gerenciamento de estado Redux.
É adequado para construir aplicações médias e grandes.

* [Pacote Fish-Redux-Library][Fish-Redux-Library], por Alibaba
* [Fish-Redux-Source][], código do projeto
* [Flutter-Movie][], Um exemplo não trivial demonstrando como
  usar Fish Redux, com mais de 30 telas, graphql,
  api de pagamento e media player.

[Fish-Redux-Library]: {{site.pub-pkg}}/fish_redux
[Fish-Redux-Source]: {{site.github}}/alibaba/fish-redux
[Flutter-Movie]: {{site.github}}/o1298098/Flutter-Movie

## BLoC / Rx

Uma família de padrões baseados em stream/observable.

* [Architect your Flutter project using BLoC pattern][],
  por Sagar Suri
* [BloC Library][], por Felix Angelov
* [Reactive Programming - Streams - BLoC - Practical Use Cases][],
  por Didier Boelens

[Architect your Flutter project using BLoC pattern]: {{site.medium}}/flutterpub/architecting-your-flutter-project-bd04e144a8f1
[BloC Library]: https://felangel.github.io/bloc
[Reactive Programming - Streams - BLoC - Practical Use Cases]: https://www.didierboelens.com/2018/12/reactive-programming---streams---bloc---practical-use-cases

## GetIt

Uma abordagem de gerenciamento de estado baseada em service locator que
não precisa de um `BuildContext`.

* [Pacote GetIt][GetIt package], o service locator.
  Também pode ser usado junto com BloCs.
* [Pacote GetIt Mixin][GetIt Mixin package], um mixin que completa
  `GetIt` para uma solução completa de gerenciamento de estado.
* [Pacote GetIt Hooks][GetIt Hooks package], o mesmo que o mixin caso
  você já use `flutter_hooks`.
* [Flutter state management for minimalists][], por Suragch

:::note
Para saber mais, assista a este curto vídeo Package of the Week sobre o pacote GetIt:

{% ytEmbed 'f9XQD5mf6FY', 'get_it | Flutter package of the week', true %}
:::

[Flutter state management for minimalists]: {{site.medium}}/flutter-community/flutter-state-management-for-minimalists-4c71a2f2f0c1?sk=6f9cedfb550ca9cc7f88317e2e7055a0
[GetIt package]: {{site.pub-pkg}}/get_it
[GetIt Hooks package]: {{site.pub-pkg}}/get_it_hooks
[GetIt Mixin package]: {{site.pub-pkg}}/get_it_mixin

## MobX

Uma biblioteca popular baseada em observables e reações.

* [MobX.dart, Hassle free state-management for your Dart and Flutter apps][]
* [Getting started with MobX.dart][]
* [Flutter: State Management with Mobx][], um vídeo por Paul Halliday

[Flutter: State Management with Mobx]: {{site.yt.watch}}?v=p-MUBLOEkCs
[Getting started with MobX.dart]: https://mobx.netlify.app/getting-started
[MobX.dart, Hassle free state-management for your Dart and Flutter apps]: {{site.github}}/mobxjs/mobx.dart

## Dart Board

Um framework de gerenciamento de recursos modular para Flutter.
Dart Board é projetado para ajudar a encapsular e isolar
recursos, incluindo exemplos/frameworks,
kernel pequeno, e muitos recursos desacoplados prontos para uso
como debugging, logging, auth, redux, locator,
particle system e mais.

* [Dart Board Homepage + Demos](https://dart-board.io/)
* [Dart Board on pub.dev]({{site.pub-pkg}}/dart_board_core)
* [dart_board on GitHub]({{site.github}}/ahammer/dart_board)
* [Getting started with Dart Board]({{site.github}}/ahammer/dart_board/blob/master/GETTING_STARTED.md)

## Flutter Commands

Gerenciamento de estado reativo que usa o Command Pattern
e é baseado em `ValueNotifiers`. Melhor em combinação com
[GetIt](#getit), mas pode ser usado com `Provider` ou outros
locators também.

* [Pacote Flutter Command][Flutter Command package]
* [Pacote RxCommand][RxCommand package], implementação baseada em `Stream`.

[Flutter Command package]: {{site.pub-pkg}}/flutter_command
[RxCommand package]: {{site.pub-pkg}}/rx_command

## Binder

Um pacote de gerenciamento de estado que usa `InheritedWidget`
em seu núcleo. Inspirado em parte pelo recoil.
Este pacote promove a separação de preocupações.

* [Pacote Binder][Binder package]
* [Exemplos de Binder][Binder examples]
* [Snippets de Binder][Binder snippets], snippets do vscode para ser ainda mais
  produtivo com Binder

[Binder examples]: {{site.github}}/letsar/binder/tree/main/examples
[Binder package]: {{site.pub-pkg}}/binder
[Binder snippets]: https://marketplace.visualstudio.com/items?itemName=romain-rastel.flutter-binder-snippets

## GetX

Uma solução simplificada de gerenciamento de estado reativo.

* [Pacote GetX][GetX package]
* [GetX Flutter Firebase Auth Example][], por Jeff McMorris

[GetX package]: {{site.pub-pkg}}/get
[GetX Flutter Firebase Auth Example]: {{site.medium}}/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2

## states_rebuilder

Uma abordagem que combina gerenciamento de estado com uma
solução de injeção de dependência e um roteador integrado.
Para mais informações, veja as seguintes informações:

* [States Rebuilder][] código do projeto
* [Documentação do States Rebuilder][States Rebuilder documentation]

[States Rebuilder]: {{site.github}}/GIfatahTH/states_rebuilder
[States Rebuilder documentation]: {{site.github}}/GIfatahTH/states_rebuilder/wiki

## Triple Pattern (Segmented State Pattern)

Triple é um padrão para gerenciamento de estado que usa `Streams` ou `ValueNotifier`.
Este mecanismo (apelidado de _triple_ porque o stream sempre usa três
valores: `Error`, `Loading` e `State`), é baseado no
[Segmented State pattern][].

Para mais informações, consulte os seguintes recursos:

* [Documentação do Triple][Triple documentation]
* [Pacote Flutter Triple][Flutter Triple package]
* [Triple Pattern: A new pattern for state management in Flutter][]
  (post de blog escrito em português mas pode ser traduzido automaticamente)
* [VIDEO: Flutter Triple Pattern by Kevlin Ossada][] (gravado em inglês)

[Triple documentation]: https://triple.flutterando.com.br/
[Flutter Triple package]: {{site.pub-pkg}}/flutter_triple
[Segmented State pattern]: https://triple.flutterando.com.br/docs/intro/overview#-segmented-state-pattern-ssp
[Triple Pattern: A new pattern for state management in Flutter]: https://blog.flutterando.com.br/triple-pattern-um-novo-padr%C3%A3o-para-ger%C3%AAncia-de-estado-no-flutter-2e693a0f4c3e
[VIDEO: Flutter Triple Pattern by Kevlin Ossada]: {{site.yt.watch}}?v=dXc3tR15AoA

## solidart

Uma solução de gerenciamento de estado simples mas poderosa inspirada no SolidJS.

* [Documentação Oficial][Official Documentation]
* [Pacote solidart][solidart package]
* [Pacote flutter_solidart][flutter_solidart package]

[Official Documentation]: https://docs.page/nank1ro/solidart
[solidart package]: {{site.pub-pkg}}/solidart
[flutter_solidart package]: {{site.pub-pkg}}/flutter_solidart

## flutter_reactive_value

A biblioteca `flutter_reactive_value` pode oferecer a solução menos complexa para gerenciamento de estado
no Flutter. Pode ajudar novatos do Flutter a adicionar reatividade à sua UI,
sem a complexidade dos mecanismos descritos antes.
A biblioteca `flutter_reactive_value` define o método de extensão `reactiveValue(BuildContext)`
em `ValueNotifier`. Esta extensão permite que um `Widget`
busque o valor atual do `ValueNotifier` e
inscreva o `Widget` em mudanças no valor do `ValueNotifier`.
Se o valor do `ValueNotifier` mudar, o `Widget` reconstrói.

* [`flutter_reactive_value`][] fonte e documentação

[`flutter_reactive_value`]: {{site.github}}/lukehutch/flutter_reactive_value

## Elementary

Elementary é uma maneira simples e confiável de construir aplicações com MVVM no Flutter.
Oferece uma experiência pura de Flutter com separação clara de código por responsabilidades,
reconstruções eficientes, testabilidade fácil e melhorando a produtividade da equipe.

* [Documentação do Elementary][Elementary Documentation]
* [Repositório do Elementary][Elementary Repository]
* [Pacote Elementary][Elementary package]

[Elementary Documentation]: https://documentation.elementaryteam.dev/
[Elementary Repository]: {{site.github}}/Elementary-team/flutter-elementary
[Elementary package]: {{site.pub-pkg}}/elementary
