---
ia-translate: true
title: Abordagens para gerenciamento de estado
short-link: State-management approaches
breadcrumb: Approaches
description: >-
  Uma introdução às diferentes abordagens para
  gerenciar estado em apps Flutter.
prev:
  title: Simple app state management
  path: /data-and-backend/state-mgmt/simple
---

Gerenciamento de estado é um tópico complexo.
Se você sente que algumas das suas perguntas não foram respondidas,
ou que a abordagem descrita nestas páginas
não é viável para seus casos de uso, você provavelmente está certo.

Aprenda mais com os seguintes recursos,
muitos dos quais foram contribuídos pela comunidade Flutter.

## Visão geral

Coisas para revisar antes de selecionar uma abordagem.

* [Introdução ao gerenciamento de estado][Introduction to state management],
  que é o início desta mesma seção
  (para aqueles que chegaram diretamente a esta página de _Opções_
  e perderam as páginas anteriores)
* [Gerenciamento de Estado Pragmático no Flutter][Pragmatic State Management in Flutter],
  um vídeo do Google I/O 2019
* [Amostras de Arquitetura Flutter][Flutter Architecture Samples], por Brian Egan

[Flutter Architecture Samples]: https://fluttersamples.com/
[Introduction to state management]: /data-and-backend/state-mgmt/intro
[Pragmatic State Management in Flutter]: {{site.yt.watch}}?v=d_m5csmrf7I

## Abordagens integradas

### `setState`

A abordagem de baixo nível para usar em estado efêmero específico de widget.

* [Adicionando interatividade ao seu app Flutter][Adding interactivity to your Flutter app], um tutorial Flutter
* [Gerenciamento de estado básico no Google Flutter][Basic state management in Google Flutter], por Agung Surya

[Adding interactivity to your Flutter app]: /ui/interactivity
[Basic state management in Google Flutter]: {{site.medium}}/@agungsurya/basic-state-management-in-google-flutter-6ee73608f96d

<a id="valuenotifier-inheritednotifier" aria-hidden="true"></a>

### `ValueNotifier` e `InheritedNotifier`

Uma abordagem usando apenas APIs fornecidas pelo Flutter para
atualizar o estado e notificar a UI sobre mudanças.

* [Gerenciamento de Estado usando ValueNotifier e InheritedNotifier][State Management using ValueNotifier and InheritedNotifier], por Tadas Petra

[State Management using ValueNotifier and InheritedNotifier]: https://www.hungrimind.com/articles/flutter-state-management

<a id="inheritedwidget-inheritedmodel" aria-hidden="true"></a>

### `InheritedWidget` e `InheritedModel`

A abordagem de baixo nível usada para
comunicar entre ancestrais e filhos na árvore de widgets.
Isso é o que `package:provider` e muitas outras abordagens usam internamente.

O seguinte workshop em vídeo com instrutor cobre como
usar `InheritedWidget`:

<YouTubeEmbed id="LFcGPS6cGrY" title="How to manage application state using inherited widgets"></YouTubeEmbed>

Outros documentos úteis incluem:

* [Documentação do InheritedWidget][InheritedWidget docs]
* [Gerenciando Estado de Aplicação Flutter com InheritedWidgets][Managing Flutter Application State With InheritedWidgets],
  por Hans Muller
* [Herdando Widgets][Inheriting Widgets], por Mehmet Fidanboylu
* [Usando Flutter Inherited Widgets Efetivamente][Using Flutter Inherited Widgets Effectively], por Eric Windmill
* [Widget - State - Context - InheritedWidget][], por Didier Bolelens

[InheritedWidget docs]: {{site.api}}/flutter/widgets/InheritedWidget-class.html
[Inheriting Widgets]: {{site.medium}}/@mehmetf_71205/inheriting-widgets-b7ac56dbbeb1
[Managing Flutter Application State With InheritedWidgets]: {{site.flutter-blog}}/managing-flutter-application-state-with-inheritedwidgets-1140452befe1
[Using Flutter Inherited Widgets Effectively]: https://ericwindmill.com/articles/inherited_widget/
[Widget - State - Context - InheritedWidget]: https://www.didierboelens.com/2018/06/widget---state---context---inheritedwidget/

## Pacotes fornecidos pela comunidade

Dependendo da complexidade do seu app e das preferências da sua equipe,
você pode achar útil adotar um pacote de gerenciamento de estado.
Pacotes de gerenciamento de estado frequentemente ajudam a reduzir código boilerplate,
fornecem ferramentas de debugging especializadas e podem ajudar a
habilitar uma arquitetura de aplicação mais clara e consistente.

A comunidade Flutter oferece uma ampla variedade de pacotes de gerenciamento de estado.
A melhor escolha para seu app frequentemente depende da complexidade do app,
das preferências da sua equipe e dos problemas específicos que você precisa resolver.

Para começar a explorar as opções disponíveis,
confira o tópico [`#state-management`][]{: target="_blank"} no site pub.dev e
refine a busca para encontrar pacotes que correspondam às suas necessidades.

<div class="card-grid">
  <a class="card outlined-card" href="{{site.pub}}/packages?q=topic%3Astate-management" target="_blank">
    <div class="card-header">
      <span class="card-title">
        <span>Pacotes de gerenciamento de estado</span>
        <span class="material-symbols" aria-hidden="true" style="font-size: 1rem;" translate="no">open_in_new</span>
      </span>
    </div>
    <div class="card-content">
      <p>Explore a variedade de pacotes de gerenciamento de estado construídos pela e para a comunidade Flutter.</p>
    </div>
  </a>
</div>

:::tip
Se você desenvolveu um pacote de gerenciamento de estado que
acha que seria útil para a comunidade Flutter,
considere [adicionar o tópico `state-management`][pub-topics] e
[publicar o pacote][pub-publish] no pub.dev.
:::

[`#state-management`]: {{site.pub}}/packages?q=topic%3Astate-management
[pub-topics]: {{site.dart-site}}/tools/pub/pubspec#topics
[pub-publish]: {{site.dart-site}}/tools/pub/publishing
