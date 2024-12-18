---
ia-translate: true
title: O que há de novo na documentação
description: >-
  Uma lista das novidades em docs.flutter.dev e sites de documentação
  relacionados.
---

Esta página contém anúncios atuais e recentes
sobre as novidades no site e blog do Flutter.
Encontre informações antigas sobre as novidades na página
[arquivo de novidades][].
Você também pode verificar as
[notas de versão][] do SDK do Flutter.

Para ficar por dentro dos anúncios do Flutter,
incluindo breaking changes,
participe do grupo do Google [flutter-announce][].

Para Dart, você pode participar do grupo do Google [Dart Announce][],
e revisar o [changelog do Dart][].

[Dart Announce]: {{site.groups}}/a/dartlang.org/g/announce
[changelog do Dart]: {{site.github}}/dart-lang/sdk/blob/main/CHANGELOG.md
[flutter-announce]: {{site.groups}}/forum/#!forum/flutter-announce
[notas de versão]: /release/release-notes

## 07 de agosto de 2024: Lançamento do I/O Connect Beijing 3.24

O Flutter 3.24 está disponível! Para mais informações,
confira a [postagem de blog guarda-chuva do Flutter 3.24][3.24-umbrella]
e a [postagem de blog técnica do Flutter 3.24][3.24-tech].
Você também pode verificar a postagem de blog [lançamento do Dart 3.5][].

[3.24-tech]: {{site.flutter-medium}}/whats-new-in-flutter-3-24-6c040f87d1e4
[3.24-umbrella]: {{site.flutter-medium}}/flutter-3-24-dart-3-5-204b7d20c45d
[lançamento do Dart 3.5]: {{site.medium}}/dartlang/dart-3-5-6ca36259fa2f

**Documentos atualizados ou adicionados desde o lançamento 3.22**

Esta versão do site inclui várias atualizações importantes!

* Um catálogo de widgets atualizado:
    * Adicionados 37 widgets ausentes ao [catálogo Cupertino][],
      e uma nova captura de tela para o widget `CupertinoActionSheet`
      atualizado.
    * Adicionado o novo widget [`CarouselView`][].
    * `CupertinoButton` e `CupertinoTextField`
      também têm comportamentos atualizados.
* Novos guias sobre como adicionar suporte para Swift Package Manager
    para [plugins iOS][] e [aplicativos iOS][]. (Observe que,
    até que todas as dependências do seu aplicativo sejam migradas,
    o Flutter continuará usando o CocoaPods.)
* Documentos da web atualizados:
    * [Incorporando o Flutter na web][], incluindo como
      habilitar o modo multi-view
    * [Incorporando conteúdo da web em um aplicativo Flutter][]
* Atualização para Android 14:
    Se você estiver usando um dispositivo Android que seja executado
    no Android 14, agora você pode dar suporte ao
    [gesto de voltar preditivo][] do Android.
* Atualizações para iOS 18:
    O lançamento do iOS 18 está em beta no momento desta versão.
    Esses recursos do iOS 18 já estão habilitados no Flutter
    e agora são mencionados na documentação:
    * Use uma [extensão de aplicativo iOS][] em seu aplicativo Flutter
      para criar uma alternância personalizada. Seus usuários podem então
      adicionar a alternância do seu aplicativo ao personalizar seu
      Central de Controle.
    * [Ícones de aplicativos com matiz][] são suportados
* Duas páginas dos [documentos fundamentais do Flutter][] foram atualizadas:
    * [Widgets][]
    * [Layout][]
    Esperamos que estas páginas sejam úteis para novos desenvolvedores
    Flutter.
* O DevTools também tem atualizações. Confira as notas de versão
    para [DevTools 2.35.0][], [DevTools 2.36.0][] e [DevTools 2.37.2][].

[`CarouselView`]: {{site.api}}/flutter/material/CarouselView-class.html
[catálogo Cupertino]: /ui/widgets/cupertino
[DevTools 2.35.0]: /tools/devtools/release-notes/release-notes-2.35.0
[DevTools 2.36.0]: /tools/devtools/release-notes/release-notes-2.36.0
[DevTools 2.37.2]: /tools/devtools/release-notes/release-notes-2.37.2
[Incorporando o Flutter na web]: /platform-integration/web/embedding-flutter-web
[Incorporando conteúdo da web em um aplicativo Flutter]: /platform-integration/web/web-content-in-flutter
[documentos fundamentais do Flutter]: /get-started/fundamentals
[Widgets]: /get-started/fundamentals/widgets
[extensão de aplicativo iOS]: /platform-integration/ios/app-extensions
[plugins iOS]: /packages-and-plugins/swift-package-manager/for-plugin-authors
[aplicativos iOS]: /packages-and-plugins/swift-package-manager/for-app-developers
[Layout]: /get-started/fundamentals/layout
[gesto de voltar preditivo]: /platform-integration/android/predictive-back
[Ícones de aplicativos com matiz]: /deployment/ios#add-an-app-icon

### Outro

* Se você estiver interessado na nova API experimental
   Flutter GPU, confira a [postagem do blog do Flutter GPU][].
* O wiki do Flutter foi dividido e movido para os
   repositórios relevantes do GitHub, tornando mais fácil manter
   essas informações atualizadas.

[postagem do blog do Flutter GPU]: {{site.flutter-medium}}/getting-started-with-flutter-gpu-f33d497b7c11

## 14 de maio de 2024: Lançamento do Google I/O 3.22

O Flutter 3.22 está disponível! Para mais informações,
confira a [postagem de blog guarda-chuva do Flutter 3.22][3.22-umbrella]
e a [postagem de blog técnica do Flutter 3.22][3.22-tech].

Você também pode verificar a postagem de blog [lançamento do Dart 3.4][].
Em particular, o Dart agora fornece uma macro de linguagem "embutida",
`JsonCodable`, para serializar e desserializar dados JSON.
Um futuro (e não especificado) lançamento do Dart permitirá
que você crie suas próprias macros.
Para saber mais, confira [dart.dev/go/macros][].

[3.22-tech]: {{site.flutter-medium}}/whats-new-in-flutter-3-22-fbde6c164fe3
[3.22-umbrella]: {{site.flutter-medium}}/io24-5e211f708a37
[lançamento do Dart 3.4]: {{site.medium}}/dartlang/dart-3-4-bd8d23b4462a
[dart.dev/go/macros]: http://dart.dev/go/macros

**Documentos atualizados ou adicionados desde o lançamento 3.19**

* Uma nova seção de 7 páginas sobre [design adaptativo e responsivo][].
  (Isso substitui nossa documentação anterior, um tanto dispersa,
  sobre este assunto.)
* Para novos desenvolvedores Flutter que trabalharam no
  primeiro codelab do Flutter, adicionamos alguns conselhos de "próximos
  passos" sobre como avançar além desse passo inicial.
  Confira os [documentos fundamentais do Flutter][].
* Nossa documentação de [instalação do Flutter][] foi reformulada.
* Temos três novos codelabs e um novo guia para o Games Toolkit.
  Para ver a lista de adições,
  confira a página atualizada do [Casual Games Toolkit][].
* Uma nova seção, [Agrupamento condicional de ativos com base no flavor][],
  na página Flavors.
* O suporte do Flutter para Web Assembly (Wasm) agora atingiu a estabilidade.
  Para saber mais, confira a página atualizada
  [Suporte para WebAssembly (Wasm)][].
* O DevTools tem uma nova tela para avaliar deep links no Android.
  Para saber mais, confira a nova página, [Validar deep links][].
* Temos uma nova página que descreve o bootstrapping da web para
  o lançamento do SDK do Flutter 3.22 e posterior.
  Confira [Inicialização de aplicativos da web Flutter][].
* Agora você pode fornecer código para transformar seus ativos
  em outro formato em tempo de execução. Para saber mais,
  confira [Transformando ativos no momento da construção][].

**Infraestrutura do site**

* Se você contribui para o site, pode ter notado
  algumas mudanças recentes. Ou seja, a infraestrutura do site
  foi atualizada e o novo fluxo de trabalho é mais simples.
  Para mais detalhes, confira o [README do site][].
* Você também pode ter notado que o submenu **Soluções de aplicativos**
  na barra lateral agora tem uma seção **IA**,
  e uma seção **Monetização** aprimorada,
  para citar algumas das mudanças.

[design adaptativo e responsivo]: /ui/adaptive-responsive
[Casual Games Toolkit]: /resources/games-toolkit
[Agrupamento condicional de ativos com base no flavor]: /deployment/flavors#conditionally-bundling-assets-based-on-flavor
[documentos fundamentais do Flutter]: /get-started/fundamentals
[instalação do Flutter]: /get-started/install
[Inicialização de aplicativos da web Flutter]: /platform-integration/web/initialization
[README do site]: {{site.github}}/flutter/website/?tab=readme-ov-file#flutter-documentation-website
[Suporte para WebAssembly (Wasm)]: /platform-integration/web/wasm
[Transformando ativos no momento da construção]: /ui/assets/asset-transformation
[Validar deep links]: /tools/devtools/deep-links

---

Para versões anteriores, confira a página
[Arquivo de novidades][].

[Arquivo de novidades]: /release/archive-whats-new
