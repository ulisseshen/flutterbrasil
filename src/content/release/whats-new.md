---
ia-translate: true
title: Novidades na documentação
description: >-
  Uma lista de novidades em docs.flutterbrasil.dev e sites de documentação relacionados.
---

Esta página contém anúncios atuais e recentes
de novidades no site e blog do Flutter.
Encontre informações passadas sobre novidades na
página de [what's new archive][].
Você também pode conferir as
[release notes][] do Flutter SDK.

Para se manter atualizado sobre anúncios do Flutter incluindo
mudanças incompatíveis,
participe do grupo Google [flutter-announce][].

Para Dart, você pode participar do grupo Google [Dart Announce][],
e revisar o [Dart changelog][].

[Dart Announce]: {{site.groups}}/a/dartlang.org/g/announce
[Dart changelog]: {{site.github}}/dart-lang/sdk/blob/main/CHANGELOG.md
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[release notes]: /release/release-notes

## 11 de dezembro de 2024: versão 3.27

Flutter 3.27 está disponível! Para mais informações,
confira o [Flutter 3.27 umbrella blog post][3.27-umbrella]
e o [Flutter 3.27 technical blog post][3.27-tech].
Você também pode conferir o post sobre a [Dart 3.6 release][].

[3.27-umbrella]: {{site.medium}}/flutter/flutter-in-production-f9418261d8e1
[3.27-tech]: {{site.medium}}/flutter/whats-new-in-flutter-3-27-28341129570c
[Dart 3.6 release]: {{site.medium}}/dartlang/announcing-dart-3-6-778dd7a80983

**Documentação atualizada ou adicionada desde a versão 3.24**

Este lançamento do site inclui várias atualizações importantes!

* O Flutter AI Toolkit foi lançado! Você encontrará a documentação
  no site no menu de navegação lateral em
  **App solutions > AI** e em [Flutter AI Toolkit][].

* Por muito tempo, temos sido solicitados a criar mais
  orientação para desenvolvedores que escrevem apps Flutter
  complexos e de grande escala. Bem, esse trabalho começou:
  apresentando [Architecting Flutter apps][]!
  Esta seção inclui oito novas páginas sobre arquitetura de
  apps Flutter, incluindo uma página de [Design patterns][]
  que tem seis receitas para padrões de design comuns
  que você pode achar úteis.

* Adicionamos mais informações sobre
  [Support for WebAssembly (Wasm)][].

* Também reformulamos a página de [Web renderers][]
  para cobrir os dois modos de build para web e seus
  dois renderizadores.

* Impeller agora é o motor de renderização padrão para
  iOS e Android. Também adicionamos um link da
  página do Impeller para a página detalhada [Can I use Impeller?][].

* Para desenvolvedores interessados em monetização, apresentamos
  um novo pacote [Interactive Media Ads][].
  Você pode encontrá-lo através do site no menu de
  navegação lateral em
  **App solutions > Monetization > Advertising**.
  Além disso, confira o post do blog
  [Video & web app support in Flutter][ad-bp].

* Temos novos documentos para usar Flutter com Android, especificamente,
  [Launching a Jetpack Compose activity from your Flutter application][jc]
  e [Calling JetPack APIs][jetpack-api].

* O trabalho continua nas páginas [Learn the fundamentals][fwe]
  (anteriormente chamadas de First Week Experience).
  Além de atualizações em várias páginas, confira a nova
  página [Intro to Dart][].

* Suporte adicional e documentação atualizada para o Swift Package Manager.
  Especificamente, você agora pode compilar no canal stable para SPM,
  no entanto, plugins continuarão a ser instalados usando
  CocoaPods já que o recurso SwiftPM permanece
  indisponível no canal stable:
  [Swift Package Manager for plugin authors][plugin-authors] e
  [Swift Package Manager for app authors][app-authors].

* A [Deep linking validator tool][deep-linking-tool], parte do DevTools,
  agora funciona para iOS e Android.

* Além disso, não se esqueça de conferir a página de
  [breaking changes][bc-3.27]
  para esta versão. É também onde você encontrará
  informações úteis de migração.

[ad-bp]: {{site.medium}}/flutter/video-web-ad-support-in-flutter-f50e5a3480a8
[app-authors]: /packages-and-plugins/swift-package-manager/for-app-developers
[Architecting Flutter apps]: /app-architecture
[bc-3.27]: /release/breaking-changes#released-in-flutter-3-27
[Can I use Impeller?]: {{site.main-url}}/go/can-i-use-impeller
[deep-linking-tool]: /tools/devtools/deep-links
[design patterns]: /app-architecture/design-patterns
[Flutter AI Toolkit]: /ai-toolkit
[fwe]: /get-started/fundamentals
[Interactive Media Ads]: {{site.pub-pkg}}/interactive_media_ads
[jc]: /platform-integration/android/compose-activity
[jetpack-api]: /platform-integration/android/call-jetpack-apis
[Intro to Dart]: /get-started/fundamentals/dart
[plugin-authors]: /packages-and-plugins/swift-package-manager/for-plugin-authors
[Support for WebAssembly (Wasm)]: /platform-integration/web/wasm
[web renderers]: /platform-integration/web/renderers

---

## 07 de agosto de 2024: I/O Connect Beijing - versão 3.24

Flutter 3.24 está disponível! Para mais informações,
confira o [Flutter 3.24 umbrella blog post][3.24-umbrella]
e o [Flutter 3.24 technical blog post][3.24-tech].
Você também pode conferir o post sobre a [Dart 3.5 release][].

[3.24-tech]: {{site.flutter-medium}}/whats-new-in-flutter-3-24-6c040f87d1e4
[3.24-umbrella]: {{site.flutter-medium}}/flutter-3-24-dart-3-5-204b7d20c45d
[Dart 3.5 release]: {{site.medium}}/dartlang/dart-3-5-6ca36259fa2f

**Documentação atualizada ou adicionada desde a versão 3.22**

Este lançamento do site inclui várias atualizações importantes!

* Um catálogo de widgets atualizado:
  * Adicionados 37 widgets faltantes ao [Cupertino catalog][],
    e uma nova captura de tela para o widget `CupertinoActionSheet` atualizado.
  * Adicionado o novo widget [`CarouselView`][].
  * `CupertinoButton` e `CupertinoTextField`
    também têm comportamentos atualizados.
* Novos guias sobre adicionar suporte para Swift Package Manager
  a [iOS plugins][] e [iOS apps][]. (Note que,
  até que todas as dependências do seu app sejam migradas,
  Flutter continuará a usar CocoaPods.)
* Documentação web atualizada:
  * [Embedding Flutter on the web][], incluindo como
    habilitar o modo multi-view
  * [Embedding web content into a Flutter app][]
* Atualização para Android 14:
  Se você está usando um dispositivo Android que roda em
  Android 14, você agora pode suportar o
  [predictive back gesture][] do Android.
* Atualizações para iOS 18:
  A versão iOS 18 está em beta no momento deste lançamento.
  Estes recursos do iOS 18 já estão habilitados no Flutter
  e agora são mencionados na documentação:
  * Use uma [iOS app extension][] em seu app Flutter
    para criar um toggle personalizado. Seus usuários podem então
    adicionar o toggle do seu app ao personalizar seu
    Control Center.
  * [Tinted app icons][] são suportados
* Duas páginas da [Flutter fundamentals docs][] estão atualizadas:
  * [Widgets][]
  * [Layout][]
  Esperamos que essas páginas sejam úteis para novos desenvolvedores Flutter.
* DevTools também tem atualizações. Confira as notas de versão para
  [DevTools 2.35.0][], [DevTools 2.36.0][] e [DevTools 2.37.2][].

[`CarouselView`]: {{site.api}}/flutter/material/CarouselView-class.html
[Cupertino catalog]: /ui/widgets/cupertino
[DevTools 2.35.0]: /tools/devtools/release-notes/release-notes-2.35.0
[DevTools 2.36.0]: /tools/devtools/release-notes/release-notes-2.36.0
[DevTools 2.37.2]: /tools/devtools/release-notes/release-notes-2.37.2
[Embedding Flutter on the web]: /platform-integration/web/embedding-flutter-web
[Embedding web content into a Flutter app]: /platform-integration/web/web-content-in-flutter
[Flutter fundamentals docs]: /get-started/fundamentals
[Widgets]: /get-started/fundamentals/widgets
[iOS app extension]: /platform-integration/ios/app-extensions
[iOS plugins]: /packages-and-plugins/swift-package-manager/for-plugin-authors
[iOS apps]: /packages-and-plugins/swift-package-manager/for-app-developers
[Layout]: /get-started/fundamentals/layout
[predictive back gesture]: /platform-integration/android/predictive-back
[Tinted app icons]: /deployment/ios#add-an-app-icon

<b>Outros</b>

* Se você está interessado na nova API experimental
  Flutter GPU, confira o [Flutter GPU blog post][].
* O wiki do Flutter foi dividido e movido para os
  repositórios GitHub relevantes, tornando mais fácil manter essas
  informações atualizadas.

[Flutter GPU blog post]: {{site.flutter-medium}}/getting-started-with-flutter-gpu-f33d497b7c11

---

Para versões passadas, confira a
página [What's new archive][].

[What's new archive]: /release/archive-whats-new
