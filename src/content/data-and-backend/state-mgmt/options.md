---
ia-translate: true
title: Lista de abordagens para gerenciamento de estado
description: Uma lista de diferentes abordagens para gerenciamento de estado.
prev:
  title: Gerenciamento de estado simples em apps
  path: /development/data-and-backend/state-mgmt/simple
---

O gerenciamento de estado é um tópico complexo.
Se você sente que algumas de suas perguntas não foram respondidas,
ou que a abordagem descrita nestas páginas
não é viável para seus casos de uso, você provavelmente está certo.

Aprenda mais nos seguintes links,
muitos dos quais foram contribuições da comunidade Flutter:

## Visão geral

Coisas a revisar antes de selecionar uma abordagem.

* [Introdução ao gerenciamento de estado][],
  que é o começo desta mesma seção
  (para aqueles que chegaram diretamente a esta página _Opções_
  e perderam as páginas anteriores)
* [Gerenciamento de Estado Pragmático em Flutter][],
  um vídeo do Google I/O 2019
* [Flutter Architecture Samples][], por Brian Egan

[Flutter Architecture Samples]: https://fluttersamples.com/
[Introdução ao gerenciamento de estado]: /data-and-backend/state-mgmt/intro
[Gerenciamento de Estado Pragmático em Flutter]: {{site.yt.watch}}?v=d_m5csmrf7I

## Provider

* [Gerenciamento de estado simples em apps][], a página anterior nesta seção
* [Pacote Provider][]

[Pacote Provider]: {{site.pub-pkg}}/provider
[Gerenciamento de estado simples em apps]: /data-and-backend/state-mgmt/simple

## Riverpod

Riverpod funciona de maneira semelhante ao Provider.
Ele oferece segurança de compilação e testes sem depender do SDK do Flutter.

* [Riverpod][] página inicial
* [Começando com Riverpod][]

[Começando com Riverpod]: https://riverpod.dev/docs/introduction/getting_started
[Riverpod]: https://riverpod.dev/

## setState

A abordagem de baixo nível para usar para estado efêmero e específico do widget.

* [Adicionando interatividade ao seu app Flutter][], um tutorial do Flutter
* [Gerenciamento básico de estado no Google Flutter][], por Agung Surya

[Adicionando interatividade ao seu app Flutter]: /ui/interactivity
[Gerenciamento básico de estado no Google Flutter]: {{site.medium}}/@agungsurya/basic-state-management-in-google-flutter-6ee73608f96d

## ValueNotifier &amp; InheritedNotifier

Uma abordagem usando apenas ferramentas fornecidas pelo Flutter para atualizar o estado e notificar a interface do usuário sobre as mudanças.

* [Gerenciamento de Estado usando ValueNotifier e InheritedNotifier][], por Tadas Petra

[Gerenciamento de Estado usando ValueNotifier e InheritedNotifier]: https://www.hungrimind.com/articles/flutter-state-management

## InheritedWidget &amp; InheritedModel

A abordagem de baixo nível usada para comunicar entre ancestrais e filhos
na árvore de widgets. Isso é o que `provider` e muitas outras abordagens
usam por baixo dos panos.

O seguinte workshop em vídeo conduzido por um instrutor cobre como
usar `InheritedWidget`:

{% ytEmbed 'LFcGPS6cGrY', 'Como gerenciar o estado do aplicativo usando widgets herdados' %}

Outros documentos úteis incluem:

* [Documentação do InheritedWidget][]
* [Gerenciando o estado da aplicação Flutter com InheritedWidgets][],
  por Hans Muller
* [Herança de Widgets][], por Mehmet Fidanboylu
* [Usando Widgets Inherited do Flutter de forma Eficaz][], por Eric Windmill
* [Widget - Estado - Contexto - InheritedWidget][], por Didier Bolelens

[Documentação do InheritedWidget]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Herança de Widgets]: {{site.medium}}/@mehmetf_71205/inheriting-widgets-b7ac56dbbeb1
[Gerenciando o estado da aplicação Flutter com InheritedWidgets]: {{site.flutter-medium}}/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
[Usando Widgets Inherited do Flutter de forma Eficaz]: https://ericwindmill.com/articles/inherited_widget/
[Widget - Estado - Contexto - InheritedWidget]: https://www.didierboelens.com/2018/06/widget---state---context---inheritedwidget/

## June

Uma biblioteca de gerenciamento de estado leve e moderna que se concentra em fornecer
um padrão semelhante ao gerenciamento de estado integrado do Flutter.

* [Pacote June][]

[Pacote June]: {{site.pub-pkg}}/june

## Redux

Uma abordagem de contêiner de estado familiar para muitos desenvolvedores web.

* [Gerenciamento de Animação com Redux e Flutter][],
  um vídeo da DartConf 2018 [Artigo complementar no Medium][]
* [Pacote Flutter Redux][]
* [Redux Saga Middleware Dart e Flutter][], por Bilal Uslu
* [Introdução ao Redux no Flutter][], por Xavi Rigau
* [Flutter + Redux — Como fazer um aplicativo de lista de compras][],
  por Paulina Szklarska no Hackernoon
* [Construindo um aplicativo TODO (CRUD) no Flutter com Redux — Parte 1][],
  um vídeo da Tensor Programming
* [Flutter Redux Thunk, um exemplo][], por Jack Wong
* [Construindo um aplicativo Flutter (grande) com Redux][], por Hillel Coren
* [Fish-Redux – Uma estrutura de aplicativo Flutter montada baseada em Redux][],
  por Alibaba
* [Async Redux – Redux sem boilerplate. Permite reducers síncronos e assíncronos][],
  por Marcelo Glasberg
* [Flutter encontra Redux: A maneira Redux de gerenciar o estado das aplicações Flutter][],
  por Amir Ghezelbash
* [Redux e epics para código mais bem organizado em aplicativos Flutter][], por Nihad Delic
* [Flutter_Redux_Gen - Plugin do VS Code para gerar código boilerplate][], por Balamurugan Muthusamy (BalaDhruv)
* [Flutter Animations Studio][], por Gianluca Romeo

[Artigo complementar no Medium]: {{site.flutter-medium}}/animation-management-with-flutter-and-flux-redux-94729e6585fa
[Gerenciamento de Animação com Redux e Flutter]: {{site.yt.watch}}?v=9ZkLtr0Fbgk
[Async Redux – Redux sem boilerplate. Permite reducers síncronos e assíncronos]: {{site.pub}}/packages/async_redux
[Construindo um aplicativo Flutter (grande) com Redux]: https://hillelcoren.com/2018/06/01/building-a-large-flutter-app-with-redux/
[Construindo um aplicativo TODO (CRUD) no Flutter com Redux — Parte 1]: {{site.yt.watch}}?v=Wj216eSBBWs
[Fish-Redux – Uma estrutura de aplicativo Flutter montada baseada em Redux]: {{site.github}}/alibaba/fish-redux/
[Flutter Redux Thunk, um exemplo]: {{site.medium}}/flutterpub/flutter-redux-thunk-27c2f2b80a3b
[Flutter encontra Redux: A maneira Redux de gerenciar o estado das aplicações Flutter]: {{site.medium}}/@thisisamir98/flutter-meets-redux-the-redux-way-of-managing-flutter-applications-state-f60ef693b509
[Pacote Flutter Redux]: {{site.pub-pkg}}/flutter_redux
[Flutter + Redux — Como fazer um aplicativo de lista de compras]: https://hackernoon.com/flutter-redux-how-to-make-shopping-list-app-1cd315e79b65
[Introdução ao Redux no Flutter]: https://blog.novoda.com/introduction-to-redux-in-flutter/
[Redux e epics para código mais bem organizado em aplicativos Flutter]: {{site.medium}}/upday-devs/reduce-duplication-achieve-flexibility-means-success-for-the-flutter-app-e5e432839e61
[Redux Saga Middleware Dart e Flutter]: {{site.pub-pkg}}/redux_saga
[Flutter_Redux_Gen - Plugin do VS Code para gerar código boilerplate]: https://marketplace.visualstudio.com/items?itemName=BalaDhruv.flutter-redux-gen
[Flutter Animations Studio]: {{site.github}}/gianlucaromeo/flutter-animations-studio

## Fish-Redux

Fish Redux é uma estrutura de aplicativo Flutter montada
baseada no gerenciamento de estado Redux.
É adequada para construir aplicativos médios e grandes.

* [Pacote Fish-Redux-Library][], por Alibaba
* [Fish-Redux-Source][], código do projeto
* [Flutter-Movie][], Um exemplo não trivial demonstrando como
  usar Fish Redux, com mais de 30 telas, graphql,
  api de pagamento e reprodutor de mídia.

[Fish-Redux-Library]: {{site.pub-pkg}}/fish_redux
[Fish-Redux-Source]: {{site.github}}/alibaba/fish-redux
[Flutter-Movie]: {{site.github}}/o1298098/Flutter-Movie

## BLoC / Rx

Uma família de padrões baseados em stream/observable.

* [Arquitetando seu projeto Flutter usando o padrão BLoC][],
  por Sagar Suri
* [Biblioteca BloC][], por Felix Angelov
* [Programação Reativa - Streams - BLoC - Casos de Uso Práticos][],
  por Didier Boelens

[Arquitetando seu projeto Flutter usando o padrão BLoC]: {{site.medium}}/flutterpub/architecting-your-flutter-project-bd04e144a8f1
[Biblioteca BloC]: https://felangel.github.io/bloc
[Programação Reativa - Streams - BLoC - Casos de Uso Práticos]: https://www.didierboelens.com/2018/12/reactive-programming---streams---bloc---practical-use-cases

## GetIt

Uma abordagem de gerenciamento de estado baseada em localizador de serviço que
não precisa de um `BuildContext`.

* [Pacote GetIt][], o localizador de serviço.
  Ele também pode ser usado em conjunto com BloCs.
* [Pacote GetIt Mixin][], um mixin que completa
  `GetIt` para uma solução completa de gerenciamento de estado.
* [Pacote GetIt Hooks][], o mesmo que o mixin, caso
  você já use `flutter_hooks`.
* [Gerenciamento de estado Flutter para minimalistas][], por Suragch

:::note
Para aprender mais, assista este pequeno vídeo do Pacote da Semana sobre o pacote GetIt:

{% ytEmbed 'f9XQD5mf6FY', 'get_it | Pacote Flutter da semana', true %}
:::

[Gerenciamento de estado Flutter para minimalistas]: {{site.medium}}/flutter-community/flutter-state-management-for-minimalists-4c71a2f2f0c1?sk=6f9cedfb550ca9cc7f88317e2e7055a0
[Pacote GetIt]: {{site.pub-pkg}}/get_it
[Pacote GetIt Hooks]: {{site.pub-pkg}}/get_it_hooks
[Pacote GetIt Mixin]: {{site.pub-pkg}}/get_it_mixin

## MobX

Uma biblioteca popular baseada em observables e reações.

* [MobX.dart, gerenciamento de estado descomplicado para seus aplicativos Dart e Flutter][]
* [Começando com MobX.dart][]
* [Flutter: Gerenciamento de Estado com Mobx][], um vídeo de Paul Halliday

[Flutter: Gerenciamento de Estado com Mobx]: {{site.yt.watch}}?v=p-MUBLOEkCs
[Começando com MobX.dart]: https://mobx.netlify.app/getting-started
[MobX.dart, gerenciamento de estado descomplicado para seus aplicativos Dart e Flutter]: {{site.github}}/mobxjs/mobx.dart

## Dart Board

Uma estrutura modular de gerenciamento de recursos para Flutter.
Dart Board foi projetado para ajudar a encapsular e isolar
recursos, incluindo exemplos/frameworks,
pequeno kernel e muitos recursos desacoplados prontos para uso
como depuração, registro, autenticação, redux, localizador,
sistema de partículas e mais.

* [Dart Board Homepage + Demos](https://dart-board.io/)
* [Dart Board no pub.dev]({{site.pub-pkg}}/dart_board_core)
* [dart_board no GitHub]({{site.github}}/ahammer/dart_board)
* [Começando com Dart Board]({{site.github}}/ahammer/dart_board/blob/master/GETTING_STARTED.md)

## Flutter Commands

Gerenciamento de estado reativo que usa o Command Pattern
e é baseado em `ValueNotifiers`. Melhor em combinação com
[GetIt](#getit), mas pode ser usado com `Provider` ou outros
localizadores também.

* [Pacote Flutter Command][]
* [Pacote RxCommand][], implementação baseada em `Stream`.

[Pacote Flutter Command]: {{site.pub-pkg}}/flutter_command
[Pacote RxCommand]: {{site.pub-pkg}}/rx_command

## Binder

Um pacote de gerenciamento de estado que usa `InheritedWidget`
em seu núcleo. Inspirado em parte por recoil.
Este pacote promove a separação de responsabilidades.

* [Pacote Binder][]
* [Exemplos do Binder][]
* [Snippets do Binder][], snippets do vscode para ser ainda mais
  produtivo com o Binder

[Exemplos do Binder]: {{site.github}}/letsar/binder/tree/main/examples
[Pacote Binder]: {{site.pub-pkg}}/binder
[Snippets do Binder]: https://marketplace.visualstudio.com/items?itemName=romain-rastel.flutter-binder-snippets

## GetX

Uma solução simplificada de gerenciamento de estado reativo.

* [Pacote GetX][]
* [Exemplo de Autenticação Firebase do GetX Flutter][], por Jeff McMorris

[Pacote GetX]: {{site.pub-pkg}}/get
[Exemplo de Autenticação Firebase do GetX Flutter]: {{site.medium}}/@jeffmcmorris/getx-flutter-firebase-auth-example-b383c1dd1de2

## states_rebuilder

Uma abordagem que combina gerenciamento de estado com uma
solução de injeção de dependência e um roteador integrado.
Para mais informações, veja as seguintes informações:

* [States Rebuilder][] código do projeto
* [Documentação do States Rebuilder][]

[States Rebuilder]: {{site.github}}/GIfatahTH/states_rebuilder
[Documentação do States Rebuilder]: {{site.github}}/GIfatahTH/states_rebuilder/wiki

## Triple Pattern (Segmented State Pattern)

Triple é um padrão para gerenciamento de estado que usa `Streams` ou `ValueNotifier`.
Este mecanismo (apelidado de _triple_ porque o stream sempre usa três
valores: `Error`, `Loading` e `State`), é baseado no
[Segmented State pattern][].

Para mais informações, consulte os seguintes recursos:

* [Documentação do Triple][]
* [Pacote Flutter Triple][]
* [Triple Pattern: Um novo padrão para gerenciamento de estado no Flutter][]
  (postagem de blog escrita em português, mas pode ser traduzida automaticamente)
* [VÍDEO: Flutter Triple Pattern por Kevlin Ossada][] (gravado em inglês)

[Documentação do Triple]: https://triple.flutterando.com.br/
[Pacote Flutter Triple]: {{site.pub-pkg}}/flutter_triple
[Segmented State pattern]: https://triple.flutterando.com.br/docs/intro/overview#-segmented-state-pattern-ssp
[Triple Pattern: Um novo padrão para gerenciamento de estado no Flutter]: https://blog.flutterando.com.br/triple-pattern-um-novo-padr%C3%A3o-para-ger%C3%AAncia-de-estado-no-flutter-2e693a0f4c3e
[VÍDEO: Flutter Triple Pattern por Kevlin Ossada]: {{site.yt.watch}}?v=dXc3tR15AoA

## solidart

Uma solução de gerenciamento de estado simples, mas poderosa, inspirada no SolidJS.

* [Documentação Oficial][]
* [Pacote solidart][]
* [Pacote flutter_solidart][]

[Documentação Oficial]: https://docs.page/nank1ro/solidart
[Pacote solidart]: {{site.pub-pkg}}/solidart
[Pacote flutter_solidart]: {{site.pub-pkg}}/flutter_solidart

## flutter_reactive_value

A biblioteca `flutter_reactive_value` pode oferecer a solução menos complexa para o gerenciamento de estado no Flutter. Pode ajudar os recém-chegados ao Flutter a adicionar reatividade à sua IU, sem a complexidade dos mecanismos descritos anteriormente. A biblioteca `flutter_reactive_value` define o método de extensão `reactiveValue(BuildContext)` em `ValueNotifier`. Essa extensão permite que um `Widget` busque o valor atual do `ValueNotifier` e subscreva o `Widget` a alterações no valor do `ValueNotifier`. Se o valor do `ValueNotifier` mudar, o `Widget` é reconstruído.

* [`flutter_reactive_value`][] código fonte e documentação

[`flutter_reactive_value`]: {{site.github}}/lukehutch/flutter_reactive_value

## Elementary

Elementary é uma maneira simples e confiável de construir aplicativos com MVVM no Flutter.
Ele oferece uma experiência Flutter pura com separação clara de código por responsabilidades,
reconstruções eficientes, fácil testabilidade e aprimoramento da produtividade da equipe.

* [Documentação do Elementary][]
* [Repositório do Elementary][]
* [Pacote Elementary][]

[Documentação do Elementary]: https://documentation.elementaryteam.dev/
[Repositório do Elementary]: {{site.github}}/Elementary-team/flutter-elementary
[Pacote Elementary]: {{site.pub-pkg}}/elementary
