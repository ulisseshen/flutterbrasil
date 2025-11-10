---
title: O que há de novo na documentação
description: >-
  Uma lista do que há de novo em docs.flutterbrasil.dev e sites de documentação relacionados.
ia-translate: true
---

Esta página contém anúncios atuais e recentes
do que há de novo no site e blog do Flutter.
Encontre informações antigas sobre novidades na
página [arquivo de novidades][what's new archive].
Você também pode conferir as
[notas de lançamento][release notes] do Flutter SDK.

Para se manter atualizado sobre anúncios do Flutter incluindo
mudanças breaking,
junte-se ao grupo Google [flutter-announce][].

Para Dart, você pode se juntar ao grupo Google [Dart Announce][],
e revisar o [changelog do Dart][Dart changelog].

[Dart Announce]: {{site.groups}}/a/dartlang.org/g/announce
[Dart changelog]: {{site.github}}/dart-lang/sdk/blob/main/CHANGELOG.md
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[release notes]: /release/release-notes

## 13 de agosto de 2025: Lançamento 3.35

Flutter 3.35 está no ar! Para mais informações,
confira o [post técnico do blog do Flutter 3.35][3.35-tech].
Você também pode conferir o post do blog do [lançamento do Dart 3.9][Dart 3.9 release].

[3.35-tech]: {{site.flutter-blog}}/whats-new-in-flutter-3-35-c58ef72e3766
[Dart 3.9 release]: {{site.medium}}/dartlang/announcing-dart-3-9-ba49e8f38298

**Documentação atualizada ou adicionada desde o lançamento 3.32**

* Hot reload agora está disponível na web e não mais
  requer uma flag experimental. Para mais informações,
  confira [hot reload][].

* Existe um novo guia [Criar com AI][Create with AI] que cobre
  como você pode aproveitar ferramentas de AI como Gemini Code Assist,
  GeminiCLI, e o Dart e Flutter MCP Server para construir
  recursos alimentados por AI para seus apps Flutter.

* Você agora pode usar o guia [Flutter Widget Previewer][]
  para ajudá-lo a visualizar uma prévia de seus widgets Flutter no
  Chrome.

* Cada lançamento estável afeta quais versões de
  plataformas implantadas o Flutter suporta.
  Para mais informações, visite a página atualizada
  [plataformas suportadas][supported platforms].

* No Android, você agora pode proteger conteúdo sensível,
  como informações de clientes, quando você compartilha sua tela.
  Saiba mais visitando [Proteja o conteúdo sensível do seu app][Protect your app's sensitive content].

* Além disso, não se esqueça de conferir a página de [mudanças breaking][bc-3.35]
  para este lançamento. É também lá que você encontrará
  informações úteis de migração.

[Flutter Widget Previewer]: /tools/widget-previewer
[Create with AI]: /ai/create-with-ai
[bc-3.35]: /release/breaking-changes#released-in-flutter-3-35
[hot reload]: /tools/hot-reload
[Protect your app's sensitive content]: /platform-integration/android/sensitive-content
[supported platforms]: /reference/supported-platforms

---

## 20 de maio de 2025: Lançamento Google I/O 3.32

Flutter 3.32 está no ar! Para mais informações,
confira o [post técnico do blog do Flutter 3.32][3.32-tech].
Você também pode conferir o post do blog do [lançamento do Dart 3.8][Dart 3.8 release].

[3.32-tech]: {{site.medium}}/flutter/whats-new-in-flutter-3-32-40c1086bab6e
[Dart 3.8 release]: {{site.medium}}/dartlang/announcing-dart-3-8-724eaaec9f47

**Atualização do site**

Primeiramente, uma reescrita nos bastidores do site tem
estado em andamento. Essas mudanças foram publicadas incrementalmente,
então você pode já ter notado algumas delas:

* Modo escuro agora está disponível
* Você agora pode avaliar cada página no site com um joinha
  ou joinha para baixo
* A sidenav mudou e está (esperançosamente) mais fácil de encontrar conteúdo
* O site foi tornado mais acessível
* Arquivos foram movidos (nós sempre fornecemos redirecionamentos)

**Documentação atualizada ou adicionada desde o lançamento 3.29**

* Uma página atualizada [Flutter no iOS][Flutter on iOS].
* Temos um novo [fluxo de trabalho para instalar o Flutter][workflow for installing Flutter] nas várias
  plataformas de desenvolvimento. Isso continua sendo um trabalho em andamento,
  então fique atento.
* Uma nova página sobre como você pode usar o novo recurso do DevTools,
  [Flutter Property Editor][].
  As instruções do [VS Code][] e [Android Studio/IntelliJ][]
  também foram atualizadas sobre como usar este recurso.
* O site foi atualizado para explicar como
  você pode [usar hot reload na web][use hot reload on web] atrás de uma flag.
  Para este lançamento, hot reload na web é um recurso experimental.
* Uma nova página sobre [adicionar extensões de app iOS][adding iOS app extensions].
* Uma página completamente reescrita para
  [configurar flavors do Flutter para iOS e macOS][setting up Flutter flavors for iOS and macOS].
* Uma nova página para [configurar flavors do Flutter para Android][setting up Flutter flavors for Android].
* As instruções do Cupertino foram atualizadas para a
  receita de cookbook [Colocar uma barra de app flutuante acima de uma lista][floating-app-bar].
* Você agora pode
  [melhorar a acessibilidade de seus apps com SemanticRoles][semantic-roles].
* Além disso, não se esqueça de conferir a página de [mudanças breaking][bc-3.32]
  para este lançamento. É também lá que você encontrará
  informações úteis de migração.

[Architectural overview page]: /resources/architectural-overview
[bc-3.32]: /release/breaking-changes#released-in-flutter-3-32

[adding iOS app extensions]: /platform-integration/ios/app-extensions
[Android Studio/IntelliJ]: /tools/android-studio#property-editor
[floating-app-bar]: /cookbook/lists/floating-app-bar
[Flutter on iOS]: https://flutterbrasil.dev/multi-platform/ios
[Flutter Property Editor]: /tools/property-editor
[semantic-roles]: /ui/accessibility/web-accessibility#enhancing-accessibility-with-semantic-roles
[setting up Flutter flavors for Android]: /deployment/flavors
[setting up Flutter flavors for iOS and macOS]: /deployment/flavors-ios
[use hot reload on web]: /platform-integration/web/building#hot-reload-web
[VS Code]: /tools/vs-code#property-editor
[workflow for installing Flutter]: /install

---

Para lançamentos passados, confira a
página [arquivo de novidades][What's new archive].

[What's new archive]: /release/archive-whats-new
