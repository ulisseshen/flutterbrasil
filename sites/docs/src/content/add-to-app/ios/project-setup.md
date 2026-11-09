---
ia-translate: true
title: Integre um app Flutter em seu projeto iOS
shortTitle: Integrar Flutter
description: Aprenda como integrar um app Flutter em seu projeto iOS existente.
---

:::note
A partir da versão 3.44, o Flutter usa o [Swift Package Manager][]
para gerenciar as dependências nativas de iOS e macOS.
O Flutter continua a oferecer suporte ao CocoaPods em modo de manutenção,
no entanto, o registro do CocoaPods se torna permanentemente
[somente leitura em 2 de dezembro de 2026][cocoapods].
:::

[cocoapods]: https://blog.cocoapods.org/CocoaPods-Specs-Repo/
[Swift Package Manager]: https://docs.swift.org/latest/documentation/packagemanagerdocs/

Componentes de UI Flutter podem ser adicionados incrementalmente
ao seu aplicativo iOS existente usando Swift packages.

## Pré-requisitos {:#prerequisites}

* Flutter 3.44 ou posterior
* Xcode 15.0 ou posterior

### Migrar da integração legada (se aplicável) {: #migrate-legacy-integration}

Se você já integrou o Flutter ao seu app iOS
usando CocoaPods ou frameworks incorporados,
você deve primeiro remover essa integração
antes de seguir as instruções do Swift Package Manager abaixo.

<details>
  <summary>Expanda para ver as instruções de migração da integração com CocoaPods</summary>

  Se o seu app foi integrado anteriormente usando CocoaPods,
  você deve primeiro remover o código de instalação do Flutter do seu Podfile.

  1. Remova o código de instalação do Flutter do seu Podfile
      ```ruby title="MyApp/Podfile" diff
      - flutter_application_path = '../my_flutter'
      - load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

      - install_all_flutter_pods(flutter_application_path)

      - flutter_post_install(installer) if defined?(flutter_post_install)
      ```

   1. Execute `pod install`.
</details>

<details>
  <summary>Expanda para ver as instruções de migração da integração com frameworks incorporados</summary>

  Se o seu app foi integrado anteriormente usando frameworks
  gerados pelo comando `flutter build ios-framework`,
  você deve primeiro remover os frameworks do seu projeto Xcode.

  1. Navegue até a aba General do seu target
     e remova todos os frameworks e bibliotecas relacionados ao Flutter
     em **Frameworks, Libraries, and Embedded Content**.

       Isso inclui `App.xcframework`, `Flutter.xcframework`,
       `FlutterPluginRegistrant.xcframework`
       e quaisquer arquivos `xcframework` de plugins Flutter.

  1. Remova o pod do Flutter do seu Podfile
      ```ruby title="MyApp/Podfile" diff
      - pod 'Flutter', :podspec => '/path/to/MyApp/Flutter/[build mode]/Flutter.podspec'
      ```

   1. Execute `pod install`.
</details>

O [guia de integração legada][legacy integration guide] é preservado para referência,
mas não receberá manutenção contínua.

### Organize seus projetos em relação uns aos outros {: #organize-projects-relatively}

Este guia assume que seu app iOS existente
e seu app ou módulo Flutter residem em diretórios irmãos.
Se você tiver uma estrutura de diretórios diferente,
precisará ajustar os caminhos relativos do exemplo de acordo.

:::note

Se estiver integrando pela primeira vez,
é recomendado usar uma aplicação Flutter (em vez de um módulo).
Execute o seguinte comando para criar uma nova aplicação Flutter:

```console
flutter create my_flutter_app
```

:::

A estrutura de diretórios de exemplo se assemelha à seguinte:

<Tabs key="ios-project-type">
<Tab name="Flutter App">

<FileTree>

- my_flutter_app/
  - ios/
  - lib/
    - main.dart
- MyNativeApp/
  - MyNativeApp.xcodeproj/

</FileTree>
</Tab>
<Tab name="Flutter Module">

<FileTree>

- my_flutter_app/
  - .ios/
  - lib/
    - main.dart
- MyNativeApp/
  - MyNativeApp.xcodeproj/

</FileTree>
</Tab>
</Tabs>

## Integre com o Swift Package Manager {: #integrate-with-swiftpm}

 1. <h3>Compile o Swift package FlutterNativeIntegration</h3>

    Dentro da sua aplicação ou módulo Flutter, execute o seguinte comando:

    ```console
    flutter build swift-package --platform ios
    ```

    Isso vai gerar os seguintes diretórios:

    <FileTree>

    - my_flutter_app/build/ios/SwiftPackages/
      - FlutterNativeIntegration/ (Um Swift package)
      - Scripts/ (Diretório de scripts e outros arquivos necessários)

    </FileTree>

    Opcionalmente, você pode alterar o local dessa saída
    com a flag `--output`.

 1. <h3>Adicione o FlutterNativeIntegration ao seu projeto Xcode</h3>

    1. Abra seu app iOS existente no Xcode.
    1. No Project navigator, clique com o botão direito no seu projeto
       e selecione **Add Files to "MyNativeApp"...**
    1. Navegue até o Swift package `FlutterNativeIntegration`
       gerado, selecione-o e clique em **Add**.
    1. Selecione **Reference files in place** e clique em **Finish**.
    1. No File inspector,
       verifique se o **Location** é **Relative to Project**.
       Se não for, você precisará mover o diretório de saída do Flutter
       para que seja um diretório irmão do seu app nativo.

       <DashImage image="development/add-to-app/ios/project-setup-swiftpm/flutternativeintegration-relative-location.png" caption="Local relativo do FlutterNativeIntegration mostrado no File inspector do Xcode." />

    1. Navegue até a aba **General** do seu target
       e adicione `FlutterNativeIntegration` em
       **Frameworks, Libraries, and Embedded Content**.

       <DashImage image="development/add-to-app/ios/project-setup-swiftpm/flutternativeintegration-library.png" caption="FlutterNativeIntegration em Frameworks, Libraries, and Embedded Content." />

 1. <h3>Adicione as build settings</h3>

    1. Na aba **Build Settings**,
       defina o local do diretório de saída do Swift package do app Flutter:
       ```
       FLUTTER_SWIFT_PACKAGE_OUTPUT=$SRCROOT/../my_flutter_app/build/ios/SwiftPackages
       ```

    1. Para configurações personalizadas, defina o modo de build do Flutter.

       O Flutter suporta três [modos de build][build modes]: Debug, Profile e Release.
       O modo de build é determinado usando o `CONFIGURATION`.
       Se a sua configuração não corresponder a um desses,
       você pode definir a build setting `FLUTTER_BUILD_MODE`
       para um desses valores.

       <DashImage image="development/add-to-app/ios/project-setup-swiftpm/flutter-build-mode.png" caption="Definindo `FLUTTER_BUILD_MODE` para configurações personalizadas em **Build Settings**." />

    1. (Opcional) Permita que o Xcode recompile seu app Flutter.

       Adicione as build settings abaixo ao seu target
       para permitir que o Xcode recompile seu app Flutter como parte do build dele.
       Isso permite que você faça alterações na sua aplicação Flutter
       sem precisar executar novamente `flutter build swift-package`.
       Isso requer que o Flutter esteja instalado na máquina.

       ```
       FLUTTER_APPLICATION_PATH=$SRCROOT/../my_flutter_app
       ENABLE_USER_SCRIPT_SANDBOXING=NO
       ```

       :::tip
       Isso recompila apenas o código do app Flutter.
       Se você adicionar novas dependências,
       precisará executar novamente `flutter build swift-package`.
       :::

 1. <h3>Adicione um Run Script de Pre-action ao Scheme</h3>

    1. Abra **Product** &gt; **Scheme** &gt; **Edit Scheme...**
       &gt; **Build** (na barra lateral esquerda) &gt; **Pre-action** &gt; **+**
       &gt; **New Run Script Action**

    1. Selecione seu projeto no menu suspenso **Provide build settings from**.

    1. Defina o script como o seguinte:
       ```
       /bin/sh $FLUTTER_SWIFT_PACKAGE_OUTPUT/Scripts/flutter_integration.sh prebuild
       ```

    <DashImage image="development/add-to-app/ios/project-setup-swiftpm/pre-action.png" caption="Run Script de Pre-action no editor de scheme." />

 1. <h3>Adicione uma nova Run Script Build Phase ao Target</h3>

    1. Navegue até **Build Phases** do seu target
       &gt; **+** &gt; **New Run Script Phase**

    1. Defina o script como o seguinte:
       ```
       /bin/sh $FLUTTER_SWIFT_PACKAGE_OUTPUT/Scripts/flutter_integration.sh assemble
       ```
    1. Desmarque **Based on dependency analysis**
    1. Adicione o seguinte em **Input File Lists**:
       ```
       $(FLUTTER_SWIFT_PACKAGE_OUTPUT)/Scripts/FlutterAssembleInputs.xcfilelist
       ```

    <DashImage image="development/add-to-app/ios/project-setup-swiftpm/build-phase-run-script.png" caption="Nova Run Script Build Phase em Build Phases." />

 1. <h3>(Opcional) Defina o LLDB Init File</h3>

    Usar o LLDB Init File do Flutter melhora a performance
    ao depurar em dispositivos físicos com iOS 26+.

    1. Abra **Product** &gt; **Scheme** &gt; **Edit Scheme...** &gt; **Run** (na barra lateral esquerda).
    1. Defina o **LLDB Init File** com o seguinte caminho:
       ```
       $(FLUTTER_SWIFT_PACKAGE_OUTPUT)/Scripts/flutter_lldbinit
       ```

       Alternativamente, se o seu scheme já tiver um LLDB Init File,
       você pode adicionar o arquivo LLDB do Flutter a ele.
       O caminho para o LLDB Init File do Flutter deve ser relativo
       ao local do LLDB Init File do seu projeto.

       ```
       command source --relative-to-command-file "../my_flutter_app/build/ios/SwiftPackages/Scripts/flutter_lldbinit"
       ```

{:.steps}

## Defina as permissões de privacidade de rede local {: #local-network-permissions}

{% render "docs/add-to-app/ios-project/local-network-privacy-permissions.md" %}



## Próximos passos {:#next-steps}

Você agora pode [adicionar uma tela Flutter][add a Flutter screen] ao seu app iOS existente.

[add a Flutter screen]: /add-to-app/ios/add-flutter-screen
[legacy integration guide]: /add-to-app/ios/project-setup-legacy
[build modes]: /testing/build-modes
