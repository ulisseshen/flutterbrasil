---
ia-translate: true
title: Integre um módulo Flutter ao seu projeto iOS
short-title: Integre Flutter
description: Aprenda como integrar um módulo Flutter ao seu projeto iOS existente.
---

Componentes de UI Flutter podem ser incrementalmente adicionados à sua aplicação
iOS existente como frameworks incorporados.
Para incorporar Flutter em sua aplicação existente,
considere um dos três métodos a seguir.

| Método de Incorporação | Metodologia | Benefício |
|---|---|---|
| Use CocoaPods _(Recomendado)_ | Instale e use o Flutter SDK e CocoaPods. O Flutter compila o `flutter_module` do código-fonte cada vez que o Xcode constrói o app iOS. | Método menos complicado para incorporar Flutter ao seu app. |
| Use [frameworks iOS][iOS frameworks] | Crie frameworks iOS para componentes Flutter, incorpore-os ao seu iOS e atualize as configurações de build do seu app existente. | Não requer que todos os desenvolvedores instalem o Flutter SDK e CocoaPods em suas máquinas locais. |
| Use frameworks iOS e CocoaPods | Incorpore os frameworks para seu app iOS e os plugins no Xcode, mas distribua o engine Flutter como um podspec CocoaPods. | Fornece uma alternativa para distribuir a grande biblioteca do engine Flutter (`Flutter.xcframework`). |

{:.table .table-striped}

[iOS frameworks]: {{site.apple-dev}}/library/archive/documentation/MacOSX/Conceptual/BPFrameworks/Concepts/WhatAreFrameworks.html

Quando você adiciona Flutter ao seu app iOS existente,
ele [aumenta o tamanho do seu app iOS][app-size].

Para exemplos usando um app construído com UIKit,
consulte os diretórios iOS nos [exemplos de código add_to_app][add_to_app code samples].
Para um exemplo usando SwiftUI, consulte o diretório iOS no [News Feed App][].

## Requisitos do sistema de desenvolvimento

Seu ambiente de desenvolvimento deve atender aos
[requisitos de sistema macOS para Flutter][macOS system requirements for Flutter] com [Xcode instalado][Xcode installed].
O Flutter suporta Xcode {{site.appmin.xcode}} ou posterior e
[CocoaPods][] {{site.appmin.cocoapods}} ou posterior.

## Crie um módulo Flutter

Para incorporar Flutter em sua aplicação existente com qualquer método,
crie primeiro um módulo Flutter.
Use o seguinte comando para criar um módulo Flutter.

```console
$ cd /path/to/my_flutter
$ flutter create --template module my_flutter
```

O Flutter cria o projeto de módulo em `/path/to/my_flutter/`.
Se você usa o [método CocoaPods][CocoaPods method], salve o módulo
no mesmo diretório pai do seu app iOS existente.

[CocoaPods method]: /add-to-app/ios/project-setup/?tab=embed-using-cocoapods

A partir do diretório do módulo Flutter,
você pode executar os mesmos comandos `flutter` que executaria em qualquer outro projeto Flutter,
como `flutter run` ou `flutter build ios`.
Você também pode executar o módulo no [VS Code][] ou
[Android Studio/IntelliJ][] com os plugins Flutter e Dart.
Este projeto contém uma versão de exemplo de visualização única do seu módulo
antes de incorporá-lo ao seu app iOS existente.
Isso ajuda ao testar as partes do seu código que são apenas Flutter.

## Organize seu módulo

A estrutura de diretório do módulo `my_flutter` se assemelha a um app Flutter típico.

```plaintext
my_flutter/
├── .ios/
│   ├── Runner.xcworkspace
│   └── Flutter/podhelper.rb
├── lib/
│   └── main.dart
├── test/
└── pubspec.yaml
```

Seu código Dart deve ser adicionado ao diretório `lib/`.
Suas dependências, pacotes e plugins Flutter devem ser adicionados ao
arquivo `pubspec.yaml`.

A subpasta oculta `.ios/` contém um workspace Xcode onde
você pode executar uma versão standalone do seu módulo.
Este projeto wrapper faz o bootstrap do seu código Flutter.
Ele contém scripts auxiliares para facilitar a construção de frameworks ou
incorporar o módulo à sua aplicação existente com CocoaPods.

:::note

* Adicione código iOS personalizado ao projeto de sua própria aplicação
  existente ou a um plugin, não ao diretório `.ios/` do módulo.
  Mudanças feitas no diretório `.ios/` do seu módulo não
  aparecerão em seu projeto iOS existente usando o módulo,
  e podem ser sobrescritas pelo Flutter.

* Exclua o diretório `.ios/` do controle de versão, pois
  ele é gerado automaticamente.

* Antes de construir o módulo em uma nova máquina,
  execute `flutter pub get` no diretório `my_flutter`.
  Isso regenera o diretório `.ios/` antes de construir
  o projeto iOS que usa o módulo Flutter.

:::

## Incorpore um módulo Flutter ao seu app iOS

Depois de ter desenvolvido seu módulo Flutter,
você pode incorporá-lo usando os métodos descritos
na tabela no topo da página.

Você pode executar em modo **Debug** em um simulador ou dispositivo real,
e em modo **Release** em um dispositivo real.

:::note
Saiba mais sobre os [modos de build do Flutter][build modes of Flutter].

Para usar recursos de debug do Flutter como hot reload,
consulte [Fazendo debug do seu módulo add-to-app][Debugging your add-to-app module].
:::

{% tabs %}
{% tab "Use CocoaPods" %}

{% render docs/add-to-app/ios-project/embed-cocoapods.md %}

{% endtab %}
{% tab "Use frameworks" %}

{% render docs/add-to-app/ios-project/embed-frameworks.md %}

{% endtab %}
{% tab "Use frameworks and CocoaPods" %}

{% render docs/add-to-app/ios-project/embed-split.md %}

{% endtab %}
{% endtabs %}


<a id="set-local-network-privacy-permissions"></a>
## Configure permissões de privacidade de rede local

No iOS 14 e posterior, habilite o serviço Dart multicast DNS na
versão **Debug** do seu app iOS.
Isso adiciona [funcionalidades de debug como hot-reload e DevTools][debugging functionalities such as hot-reload and DevTools]
usando `flutter attach`.

:::warning
Nunca habilite este serviço na versão **Release** do seu app.
A Apple App Store pode rejeitar seu app.
:::

Para configurar permissões de privacidade de rede local apenas na versão Debug do seu app,
crie um `Info.plist` separado por configuração de build.
Projetos SwiftUI começam sem um arquivo `Info.plist`.
Se você precisa criar uma property list,
pode fazê-lo através do Xcode ou editor de texto.
As instruções a seguir assumem o padrão **Debug** e **Release**.
Ajuste os nomes conforme necessário dependendo das configurações de build do seu app.

1. Crie uma nova property list.

   1. Abra seu projeto no Xcode.

   1. No **Project Navigator**, clique no nome do projeto.

   1. Na lista **Targets** no painel Editor, clique no seu app.

   1. Clique na aba **Info**.

   1. Expanda **Custom iOS Target Properties**.

   1. Clique com o botão direito na lista e selecione **Add Row**.

   1. No menu suspenso, selecione **Bonjour Services**.
      Isso cria uma nova property list no diretório do projeto
      chamada `Info`. Isso é exibido como `Info.plist` no Finder.

1. Renomeie o `Info.plist` para `Info-Debug.plist`

   1. Clique no arquivo **Info** na lista de projeto à esquerda.

   1. No painel **Identity and Type** à direita,
      mude o **Name** de `Info.plist` para `Info-Debug.plist`.

1. Crie uma property list Release.

   1. No **Project Navigator**, clique em `Info-Debug.plist`.

   1. Selecione **File** > **Duplicate...**.
      Você também pode pressionar <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>S</kbd>.

   1. Na caixa de diálogo, defina o campo **Save As:** como
      `Info-Release.plist` e clique em **Save**.

1. Adicione as propriedades necessárias à property list **Debug**.

   1. No **Project Navigator**, clique em `Info-Debug.plist`.

   1. Adicione o valor String `_dartVmService._tcp`
      ao array **Bonjour Services**.

   1. _(Opcional)_ Para definir o texto de diálogo de permissão personalizado desejado,
      adicione a chave **Privacy - Local Network Usage Description**.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/debug-plist.png",
      caption:"The `Info-Debug` property list with the **Bonjour Services**
      and **Privacy - Local Network Usage Description** keys added" %}

1. Configure o target para usar property lists diferentes para diferentes modos de build.

   1. No **Project Navigator**, clique no seu projeto.

   1. Clique na aba **Build Settings**.

   1. Clique nas sub-abas **All** e **Combined**.

   1. Na caixa Search, digite `plist`.
      Isso limita as configurações àquelas que incluem property lists.

   1. Role pela lista até ver **Packaging**.

   1. Clique na configuração **Info.plist File**.

   1. Mude o valor de **Info.plist File**
      de `path/to/Info.plist` para `path/to/Info-$(CONFIGURATION).plist`.

      {%- render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/set-plist-build-setting.png",
      caption:"Updating the `Info.plist` build setting to use build
      mode-specific property lists" %}

      Isso resolve para o caminho **Info-Debug.plist** em **Debug** e
      **Info-Release.plist** em **Release**.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/plist-build-setting.png",
      caption:"The updated **Info.plist File** build setting displaying the
      configuration variations" %}

1. Remova a property list **Release** das **Build Phases**.

   1. No **Project Navigator**, clique no seu projeto.

   1. Clique na aba **Build Phases**.

   1. Expanda **Copy Bundle Resources**.

   1. Se esta lista incluir `Info-Release.plist`,
      clique nele e depois clique no sinal **-** (menos) abaixo dele
      para remover a property list da lista de recursos.

      {% render docs/captioned-image.liquid,
      image:"development/add-to-app/ios/project-setup/copy-bundle.png",
      caption:"The **Copy Bundle** build phase displaying the
      **Info-Release.plist** setting. Remove this setting." %}

1. A primeira tela Flutter que seu app Debug carrega solicita
   permissão de rede local.

   Clique em **OK**.

   _(Opcional)_ Para conceder permissão antes que o app carregue, habilite
   **Settings > Privacy > Local Network > Your App**.

## Mitigue problema conhecido com Macs Apple Silicon

Em [Macs executando Apple Silicon][apple-silicon],
o app hospedeiro constrói para um simulador `arm64`.
Enquanto o Flutter suporta simuladores `arm64`, alguns plugins podem não suportar.
Se você usa um desses plugins, pode ver um erro de compilação como
**Undefined symbols for architecture arm64**.
Se isso ocorrer,
exclua `arm64` das arquiteturas de simulador no seu app hospedeiro.

1. No **Project Navigator**, clique no seu projeto.

1. Clique na aba **Build Settings**.

1. Clique nas sub-abas **All** e **Combined**.

1. Em **Architectures**, clique em **Excluded Architectures**.

1. Expanda para ver as configurações de build disponíveis.

1. Clique em **Debug**.

1. Clique no sinal **+** (mais).

1. Selecione **iOS Simulator**.

1. Dê um duplo clique na coluna de valor para **Any iOS Simulator SDK**.

1. Clique no sinal **+** (mais).

1. Digite `arm64` na caixa de diálogo **Debug > Any iOS Simulator SDK**.

   {% render docs/captioned-image.liquid,
   image:"development/add-to-app/ios/project-setup/excluded-archs.png",
   caption:"Add `arm64` as an excluded architecture for your app" %}

1. Pressione <kbd>Esc</kbd> para fechar esta caixa de diálogo.

1. Repita estes passos para o modo de build **Release**.

1. Repita para quaisquer targets de teste unitário iOS.

## Próximos passos

Você agora pode [adicionar uma tela Flutter][add a Flutter screen] ao seu app iOS existente.

[add_to_app code samples]: {{site.repo.samples}}/tree/main/add_to_app
[add a Flutter screen]: /add-to-app/ios/add-flutter-screen
[Android Studio/IntelliJ]: /tools/android-studio
[build modes of Flutter]: /testing/build-modes
[CocoaPods]: https://cocoapods.org/
[debugging functionalities such as hot-reload and DevTools]: /add-to-app/debugging
[app-size]: /resources/faq#how-big-is-the-flutter-engine
[macOS system requirements for Flutter]: /get-started/install/macos/mobile-ios#verify-system-requirements
[VS Code]: /tools/vs-code
[Xcode installed]: /get-started/install/macos/mobile-ios#install-and-configure-xcode
[News Feed app]: https://github.com/flutter/put-flutter-to-work/tree/022208184ec2623af2d113d13d90e8e1ce722365
[Debugging your add-to-app module]: /add-to-app/debugging/
[apple-silicon]: https://support.apple.com/en-us/116943
