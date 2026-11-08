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

Para se manter atualizado sobre anúncios do Flutter incluindo mudanças breaking,
junte-se ao grupo Google [flutter-announce][].

Para Dart, você pode se juntar ao grupo Google [Dart Announce][],
e revisar o [changelog do Dart][Dart changelog].

[Dart Announce]: {{site.groups.dart-announce}}
[Dart changelog]: {{site.repo.dart-sdk}}/blob/main/CHANGELOG.md
[flutter-announce]: {{site.groups.flutter-announce}}
[release notes]: /release/release-notes

## 12 de agosto de 2026: Lançamento 3.47 {:#12-august-2026-release-3-47}

Flutter 3.47 está no ar! Para mais detalhes,
confira o [post do blog do Flutter 3.47][3.47-blog-post].

**Documentação atualizada ou adicionada desde o lançamento 3.44**

* A ferramenta [Widget Previews][widget-previewer] do Flutter se tornou estável,
  introduzindo cache de build local para tempos de inicialização mais rápidos
  e busca e filtragem de prévias em tempo real.

* A documentação de AI foi reorganizada para melhorar a navegação
  e ajudar você a começar rapidamente com agent-plugins
  (anteriormente conhecidos como skills) usando a [Antigravity CLI][antigravity-cli],
  integrações com IDEs e outros assistentes de programação.
  Uma página experimental sobre [AI Evaluations][ai-evals] também foi adicionada.

* Um novo guia sobre [gerenciamento de dependências][dependency-mgmt] explica
  como configurar, gerenciar e atualizar dependências de pacotes.

* Os guias do [Swift Package Manager][swiftpm] para iOS e macOS foram expandidos,
  e a documentação de [Add-to-app][add-to-app] agora inclui
  instruções de integração com SwiftPM.

* A documentação web agora inclui orientações de solução de problemas para
  [erros de compilação Wasm][wasm] e instruções para usar a
  flag `--source-maps` durante builds web.

* O guia de assets agora explica como empacotar
  [assets específicos de plataforma][platform-assets] no `pubspec.yaml`.

* Um novo guia de migração ajuda você a migrar plugins e apps para
  os plugins Gradle de [Kotlin integrado][kotlin-migration].

Como sempre, confira a página de [mudanças breaking][bc-3-47] deste lançamento,
que inclui links para guias de migração e outras informações vitais.

[3.47-blog-post]: /blog/whats-new-in-flutter-3-47
[widget-previewer]: /tools/widget-previewer
[antigravity-cli]: /ai/antigravity-cli
[ai-evals]: /ai/evals
[dependency-mgmt]: /packages-and-plugins/dependency-management
[swiftpm]: /packages-and-plugins/swift-package-manager
[add-to-app]: /add-to-app
[wasm]: /platform-integration/web/wasm
[platform-assets]: /ui/assets/assets-and-images
[kotlin-migration]: /release/breaking-changes/migrate-to-built-in-kotlin
[bc-3-47]: /release/breaking-changes#released-in-flutter-3-47

---

## 18 de maio de 2026: Lançamento Google I/O 3.44 {:#18-may-2026-google-io-release-3-44}

Flutter 3.44 está no ar! Este lançamento está repleto de novidades.
Para mais detalhes, confira o [post do blog do Flutter 3.44][3.44-blog-post]
e [assista ao vídeo][3.44-whats-new]:

<div class="video-wrapper">
<span class="video-intro">Confira as novidades do Dart e do Flutter</span>
<YouTubeEmbed id="I1uIbGh1dGE" title="What's New in Dart and Flutter 3.44" fullWidth></YouTubeEmbed>
</div>

[3.44-blog-post]: {{site.flutter-blog}}/whats-new-in-flutter-3-44-b0cc1ad3c527
[3.44-whats-new]: https://www.youtube.com/watch?v=I1uIbGh1dGE&t=451s

Mais atualizações do site em breve.

## 11 de fevereiro de 2026: Lançamento "Year of the Fire Horse" 3.41 {:#11-february-2026-year-of-the-fire-horse-release-3-41}

Flutter 3.41 está no ar! Para mais detalhes,
confira o [post do blog do Flutter 3.41][3.41-blog-post].

[3.41-blog-post]: {{site.flutter-blog}}/whats-new-in-flutter-3-41-302ec140e632


**Documentação atualizada ou adicionada desde o lançamento 3.38**

Além de muitas atualizações menores, aqui estão algumas das mudanças
mais significativas:

* Introduzimos uma nova experiência de introdução para
  Flutter e Dart, conforme anunciado em um [post do blog][few] recente.
  Você pode encontrar o [caminho de aprendizado][learning pathway] do Flutter na aba **Learn**
  no topo de [docs.flutter.dev][]. Para voltar ao restante do site,
  selecione a aba **Guides**. Como sempre, a aba **Reference**
  leva você à [documentação da API do Flutter][Flutter API docs].

* Flutter e Dart agora têm um [glossário oficial][official glossary].
  Como parte da recente migração dos sites para o Jaspr,
  um glossário foi adicionado ao site do Flutter.
  Espere vê-lo crescer com o tempo.

* Como sempre, confira a página de [mudanças breaking][bc-3-41] deste lançamento,
  que inclui links para guias de migração e outras informações vitais.
  Um agradecimento especial a [navaronbracke][], que escreveu um guia
  de migração para a [descontinuação do callback `onReorder`][onReorder].

[bc-3-41]: /release/breaking-changes#released-in-flutter-3-41
[docs.flutter.dev]: /
[Flutter API docs]: {{site.api}}
[few]: {{site.flutter-blog}}/announcing-our-new-dart-and-flutter-getting-started-experience-b8c4b2be0984
[learning pathway]: /learn
[navaronbracke]: https://github.com/navaronbracke
[official glossary]: /resources/glossary
[onReorder]: /release/breaking-changes/separated-builder-find-child-index-callback

---

## 12 de novembro de 2025: Lançamento 3.38 {:#12-november-2025-release-3-38}

Flutter 3.38 está no ar! Para mais detalhes,
confira o [post técnico do blog do Flutter 3.38][3.38-tech].

[3.38-tech]: {{site.flutter-blog}}/whats-new-in-flutter-3-38-3f7b258f7228

**Atualização do site**

Uma atualização significativa do site acabou de ser lançada!
Assim como a atualização do site dart.dev lançada
no início deste ano, o site docs.flutter.dev foi
reimplementado para usar o [Jaspr][], um framework web em Dart.

Conte-nos o que você achou!

[Jaspr]: https://jaspr.site/

**Documentação atualizada ou adicionada desde o lançamento 3.35**

* A linguagem Dart agora suporta a sintaxe de _dot shorthands_
  (também conhecida como _shorthands_), que permite escrever código
  mais conciso. Para mais informações, visite a
  página [Dart dot shorthands][] no dart.dev. Com o tempo,
  os exemplos deste site serão atualizados
  para aproveitar esse novo recurso.

* O comando `flutter run` agora suporta um arquivo de configuração
  que permite especificar configurações web como host, porta,
  certificação e cabeçalho.
  O arquivo de configuração de desenvolvimento web também suporta configurações de proxy,
  tornando possível encaminhar requisições de caminhos específicos
  para outro servidor. Isso facilita o desenvolvimento de um
  cliente web que se conecta a endpoints dinâmicos no mesmo host.
  Para mais informações, visite
  [configurando um arquivo de configuração de desenvolvimento web][web-config-file].

* O desenvolvimento continua na ferramenta Flutter Widget Previewer,
  introduzida como recurso experimental no lançamento 3.35.
  Neste lançamento, o previewer se integra melhor com as IDEs VS Code
  e IntelliJ (incluindo o Android Studio).
  Ainda é um recurso experimental.
  Para mais informações sobre a versão mais recente,
  confira a [página da ferramenta Widget Previewer][Widget Previewer tool page].

* O lançamento Flutter 3.38 suporta totalmente as versões de plataforma
  iOS 26, Xcode 26 e macOS 26, todas lançadas em setembro.
  Para as informações mais recentes sobre o suporte do Flutter ao iOS,
  visite [Flutter no iOS mais recente][Flutter on latest iOS].

* O Flutter 3.38 suporta o novo [ciclo de vida UIScene][UIScene lifecycle] exigido pela Apple.
  Para suportá-lo, é necessária uma migração de código.
  Para mais informações, visite o [guia de migração para UIScene][UIScene migration guide].

* Com foco em melhorar a acessibilidade do Flutter,
  a [documentação de acessibilidade][accessibility docs] também foi completamente reformulada.

* Além disso, não se esqueça de conferir a página de [mudanças breaking][bc-3.38]
  deste lançamento. É lá que você encontrará informações
  sobre mudanças breaking, descontinuações de código e guias de migração.

Outros recursos relevantes:

* [Notas de lançamento e changelog do 3.38][3.38 release notes and changelog]
* [Notas de lançamento do DevTools 2.51.1][DevTools 2.51.1 release notes]
* Post do blog do [lançamento do Dart 3.10][Dart 3.10 release]

[3.38 release notes and changelog]: /release/release-notes/release-notes-3.38.0
[accessibility docs]: /ui/accessibility
[bc-3.38]: /release/breaking-changes#released-in-flutter-3-38
[Dart 3.10 release]: {{site.dart-blog}}/announcing-dart-3-10
[Dart dot shorthands]: {{site.dart-site}}/language/dot-shorthands
[DevTools 2.51.1 release notes]: /tools/devtools/release-notes/release-notes-2.51.1
[Flutter on latest iOS]: /platform-integration/ios/ios-latest
[UIScene lifecycle]: {{site.apple-dev}}/documentation/technotes/tn3187-migrating-to-the-uikit-scene-based-life-cycle
[UIScene migration guide]: /release/breaking-changes/uiscenedelegate
[Widget Previewer tool page]: /tools/widget-previewer
[web-config-file]: /platform-integration/web/web-dev-config-file


---

Para lançamentos passados, confira a
página [arquivo de novidades][What's new archive].

[What's new archive]: /release/archive-whats-new
