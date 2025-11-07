---
ia-translate: true
title: Adicione Flutter a um app existente
short-title: Add to app
description: Adicionando Flutter como uma biblioteca a um app Android ou iOS existente.
---

## Add-to-app

Se você está escrevendo uma nova aplicação do zero, é fácil [começar][get started]
usando Flutter. Mas e se você já tem um app que não é escrito em
Flutter, e é impraticável começar do zero?

Para essas situações, o Flutter pode ser integrado à sua aplicação existente
de forma incremental, como um módulo. Este recurso é conhecido como "add-to-app".
O módulo pode ser importado para seu app existente para renderizar parte do seu app
usando Flutter, enquanto o resto pode ser renderizado usando tecnologia existente.
Este método também pode ser usado para executar lógica compartilhada não-UI aproveitando
a portabilidade e interoperabilidade do Dart com outras linguagens.

Add-to-app é atualmente suportado no Android, iOS e web.

O Flutter suporta dois tipos de add-to-app:

- **Multi-engine**: suportado no Android e iOS, permite executar uma ou mais
  instâncias do Flutter, cada uma renderizando um widget incorporado ao aplicativo
  hospedeiro. Cada instância é um programa Dart separado, executando em isolamento
  de outros programas. Ter múltiplas instâncias Flutter permite que cada instância
  mantenha estado de aplicação e UI independente, usando recursos mínimos de memória.
  Veja mais na página [múltiplos Flutters][multiple Flutters].
- **Multi-view**: suportado na web, permite criar múltiplas
  [FlutterView][]s, cada uma renderizando um widget incorporado ao aplicativo hospedeiro.
  Neste modo há apenas um programa Dart e todas as views e widgets podem compartilhar
  objetos.

Add-to-app suporta integrar múltiplas views Flutter de qualquer tamanho, suportando
vários casos de uso. Dois dos casos de uso mais comuns são:

* **Pilhas de navegação híbridas**: um app é feito de múltiplas telas, algumas das
  quais são renderizadas pelo Flutter, e outras por outro framework. O usuário pode
  navegar de uma tela para outra livremente, não importa qual framework é usado
  para renderizar a tela.
* **Views de tela parcial**: uma tela no app renderiza múltiplos widgets, alguns
  dos quais são renderizados pelo Flutter, e outros por outro framework. O usuário
  pode rolar e interagir com qualquer widget livremente, não importa qual framework é
  usado para renderizar o widget.

## Recursos suportados

### Adicionar a aplicações Android

{% render docs/app-figure.md, image:"development/add-to-app/android-overview.gif", alt:"Add-to-app steps on Android" %}

* Construa e importe automaticamente o módulo Flutter adicionando um
  hook do Flutter SDK ao seu script Gradle.
* Construa seu módulo Flutter em um
  [Android Archive (AAR)][] genérico para integração ao seu
  próprio sistema de build e para melhor interoperabilidade Jetifier
  com AndroidX.
* API [`FlutterEngine`][java-engine] para iniciar e persistir
  seu ambiente Flutter independentemente de anexar uma
  [`FlutterActivity`][]/[`FlutterFragment`][] etc.
* Co-edição Android/Flutter no Android Studio e assistente de
  criação/importação de módulos.
* Apps hospedeiros Java e Kotlin são suportados.
* Módulos Flutter podem usar [plugins Flutter][Flutter plugins] para interagir
  com a plataforma.
* Suporte para debug Flutter e hot reload stateful usando
  `flutter attach` de IDEs ou linha de comando para
  conectar a um app que contém Flutter.

### Adicionar a aplicações iOS

{% render docs/app-figure.md, image:"development/add-to-app/ios-overview.gif", alt:"Add-to-app steps on iOS" %}

* Construa e importe automaticamente o módulo Flutter adicionando um hook
  do Flutter SDK ao seu CocoaPods e à sua fase de build do Xcode.
* Construa seu módulo Flutter em um [iOS Framework][] genérico
  para integração ao seu próprio sistema de build.
* API [`FlutterEngine`][ios-engine] para iniciar e persistir
  seu ambiente Flutter independentemente de anexar um
  [`FlutterViewController`][].
* Apps hospedeiros Objective-C e Swift suportados.
* Módulos Flutter podem usar [plugins Flutter][Flutter plugins] para interagir
  com a plataforma.
* Suporte para debug Flutter e hot reload stateful usando
  `flutter attach` de IDEs ou linha de comando para
  conectar a um app que contém Flutter.

Veja nosso [repositório de amostras GitHub add-to-app][add-to-app GitHub Samples repository]
para projetos de exemplo em Android e iOS que importam
um módulo Flutter para UI.

### Adicionar a aplicações web

O Flutter pode ser adicionado a qualquer app web existente baseado em HTML DOM escrito
em qualquer framework web Dart do lado do cliente ([jaspr][], [ngdart][], [over_react][], etc),
qualquer framework JS do lado do cliente ([React][], [Angular][], [Vue.js][], etc),
qualquer framework renderizado do lado do servidor ([Django][], [Ruby on Rails][],
[Apache Struts][], etc), ou mesmo sem framework (carinhosamente conhecido como
"[VanillaJS][]"). O requisito mínimo é apenas que sua aplicação existente
e seu framework suportem importar bibliotecas JavaScript e criar elementos HTML
para o Flutter renderizar.

Para adicionar Flutter a um app existente, construa-o normalmente, depois siga as
[instruções de incorporação][embedding instructions] para colocar views Flutter na página.

[jaspr]: https://pub.dev/packages/jaspr
[ngdart]: https://pub.dev/packages/ngdart
[over_react]: https://pub.dev/packages/over_react
[React]: https://react.dev/
[Angular]: https://angular.dev/
[Vue.js]: https://vuejs.org/
[Django]: https://www.djangoproject.com/
[Ruby on Rails]: https://rubyonrails.org/
[Apache Struts]: https://struts.apache.org/
[VanillaJS]: http://vanilla-js.com/
[embedding instructions]: {{site.docs}}/platform-integration/web/embedding-flutter-web#embedded-mode

## Comece

Para começar, veja nosso guia de integração de projeto para
Android e iOS:

<div class="card-grid">
  <a class="card" href="/add-to-app/android/project-setup">
    <div class="card-body">
      <header class="card-title text-center">
        Android
      </header>
    </div>
  </a>
  <a class="card" href="/add-to-app/ios/project-setup">
    <div class="card-body">
      <header class="card-title text-center">
        iOS
      </header>
    </div>
  </a>
  <a class="card" href="/platform-integration/web/embedding-flutter-web#embedded-mode">
    <div class="card-body">
      <header class="card-title text-center">
        Web
      </header>
    </div>
  </a>
</div>

## Uso da API

Depois que o Flutter é integrado ao seu projeto,
veja nossos guias de uso de API nos seguintes links:

<div class="card-grid">
  <a class="card" href="/add-to-app/android/add-flutter-screen">
    <div class="card-body">
      <header class="card-title text-center">
        Android
      </header>
    </div>
  </a>
  <a class="card" href="/add-to-app/ios/add-flutter-screen">
    <div class="card-body">
      <header class="card-title text-center">
        iOS
      </header>
    </div>
  </a>
  <a class="card" href="/platform-integration/web/embedding-flutter-web#manage-flutter-views-from-js">
    <div class="card-body">
      <header class="card-title text-center">
        Web
      </header>
    </div>
  </a>
</div>

## Limitações

Limitações mobile:

* Modo multi-view não é suportado (apenas multi-engine).
* Empacotar múltiplas bibliotecas Flutter em uma
  aplicação não é suportado.
* Plugins que não suportam `FlutterPlugin` podem ter comportamentos
  inesperados se fizerem suposições que são insustentáveis em add-to-app
  (como assumir que uma `Activity` Flutter está sempre presente).
* No Android, o módulo Flutter suporta apenas aplicações AndroidX.

Limitações web:

* Modo multi-engine não é suportado (apenas multi-view).
* Não há forma de "desligar" completamente o engine Flutter. O app pode remover
  todos os objetos [FlutterView][] e garantir que todos os dados sejam coletados
  pelo garbage collector usando conceitos normais do Dart. No entanto, o engine
  permanecerá aquecido, mesmo que não esteja renderizando nada.

[get started]: /get-started/codelab
[add-to-app GitHub Samples repository]: {{site.repo.samples}}/tree/main/add_to_app
[Android Archive (AAR)]: {{site.android-dev}}/studio/projects/android-library
[Flutter plugins]: {{site.pub}}/flutter
[`FlutterActivity`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterActivity.html
[java-engine]: {{site.api}}/javadoc/io/flutter/embedding/engine/FlutterEngine.html
[ios-engine]: {{site.api}}/ios-embedder/interface_flutter_engine.html
[FlutterFire]: {{site.github}}/firebase/flutterfire/tree/main/packages
[`FlutterFragment`]: {{site.api}}/javadoc/io/flutter/embedding/android/FlutterFragment.html
[`FlutterPlugin`]: {{site.api}}/javadoc/io/flutter/embedding/engine/plugins/FlutterPlugin.html
[`FlutterViewController`]: {{site.api}}/ios-embedder/interface_flutter_view_controller.html
[iOS Framework]: {{site.apple-dev}}/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html
[maintained by the Flutter team]: {{site.repo.packages}}/tree/main/packages
[multiple Flutters]: /add-to-app/multiple-flutters
[FlutterView]: https://api.flutter.dev/flutter/dart-ui/FlutterView-class.html
