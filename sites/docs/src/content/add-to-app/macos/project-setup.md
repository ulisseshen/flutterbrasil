---
ia-translate: true
title: Integre um app Flutter ao seu projeto macOS
shortTitle: Integrar Flutter
description: Aprenda a integrar um app Flutter ao seu projeto macOS existente.
---

:::note
A partir da versão 3.44, o Flutter usa o [Swift Package Manager][]
para gerenciar dependências nativas de iOS e macOS.
O Flutter continua oferecendo suporte ao CocoaPods em modo de manutenção,
porém, o registro do CocoaPods se torna permanentemente
[somente leitura em 2 de dezembro de 2026][cocoapods].
:::

[cocoapods]: https://blog.cocoapods.org/CocoaPods-Specs-Repo/
[Swift Package Manager]: https://www.swift.org/documentation/package-manager/

Os componentes de UI do Flutter podem ser adicionados gradualmente
ao seu app macOS existente usando pacotes Swift.

## Pré-requisitos {:#prerequisites}

* Flutter 3.44 ou posterior
* Xcode 15.0 ou posterior

### Migre da integração legada (se aplicável) {: #migrate-legacy-integration}

Se você já integrou o Flutter ao seu app macOS
usando frameworks embutidos,
você deve primeiro remover essa integração
antes de seguir as instruções do Swift Package Manager abaixo.

<details>
  <summary>Expanda para ver as instruções de migração a partir da integração com frameworks embutidos</summary>

  Se o seu app foi integrado anteriormente usando frameworks
  gerados pelo comando `flutter build macos-framework`,
  você deve primeiro remover os frameworks do seu projeto Xcode.

  1. Acesse a aba **General** do seu target
     e remova todos os frameworks e bibliotecas relacionados ao Flutter
     em **Frameworks, Libraries, and Embedded Content**.

       Isso inclui o `App.xcframework`, o `FlutterMacOS.xcframework`,
       o `FlutterPluginRegistrant.xcframework`
       e os arquivos `xcframework` de quaisquer plugins Flutter.

  1. Remova o pod do Flutter do seu Podfile
      ```ruby title="MyApp/Podfile" diff
      - pod 'FlutterMacOS', :podspec => '/path/to/MyApp/Flutter/[build mode]/FlutterMacOS.podspec'
      ```

   1. Execute `pod install`.
</details>

### Organize seus projetos em relação uns aos outros {: #organize-projects-relatively}

Este guia pressupõe que o seu app macOS existente
e o seu app Flutter estão em diretórios irmãos.
Se você tiver uma estrutura de diretórios diferente,
será necessário ajustar os caminhos relativos do exemplo de acordo.

:::note

Se estiver integrando pela primeira vez,
execute o comando a seguir para criar um novo app Flutter:

```console
flutter create my_flutter_app
```

:::

A estrutura de diretórios de exemplo se parece com o seguinte:

<FileTree>

- my_flutter_app/
  - macos/
  - lib/
    - main.dart
- MyNativeApp/
  - MyNativeApp.xcodeproj/

</FileTree>

## Integre com o Swift Package Manager {: #integrate-with-swiftpm}

 1. <h3>Compile o pacote Swift FlutterNativeIntegration</h3>

    Dentro do seu app ou módulo Flutter, execute o comando a seguir:

    ```console
    flutter build swift-package --platform macos
    ```

    Isso gera os seguintes diretórios:

    <FileTree>

    - my_flutter_app/build/macos/SwiftPackages/
      - FlutterNativeIntegration/ (um pacote Swift)
      - Scripts/ (diretório com scripts e outros arquivos necessários)

    </FileTree>

    Você pode, opcionalmente, alterar o local dessa saída
    com a flag `--output`.

 1. <h3>Adicione o FlutterNativeIntegration ao seu projeto Xcode</h3>

    1. No Project navigator, clique com o botão direito no seu projeto
       e selecione **Add Files to "MyNativeApp"...**
    1. Navegue até o pacote Swift `FlutterNativeIntegration` gerado,
       selecione-o e clique em **Add**.
    1. Selecione **Reference files in place** e clique em **Finish**.
    1. No File inspector,
       verifique se a **Location** está como **Relative to Project**.
       Se não estiver, você precisará mover o diretório de saída do Flutter
       para ser um diretório irmão do seu app nativo.

       <DashImage image="development/add-to-app/macos/project-setup-swiftpm/flutternativeintegration-relative-location.png" caption="Localização relativa do FlutterNativeIntegration mostrada no File inspector do Xcode." />

    1. Acesse a aba **General** do seu target
       e adicione `FlutterNativeIntegration` em
       **Frameworks, Libraries, and Embedded Content**.

       <DashImage image="development/add-to-app/ios/project-setup-swiftpm/flutternativeintegration-library.png" caption="FlutterNativeIntegration em Frameworks, Libraries, and Embedded Content." />

 1. <h3>Adicione as configurações de build</h3>

    1. Na aba **Build Settings**,
       defina o local do diretório de saída do pacote Swift do app Flutter:
       ```
       FLUTTER_SWIFT_PACKAGE_OUTPUT=$SRCROOT/../my_flutter_app/build/macos/SwiftPackages
       ```
    1. Para configurações personalizadas, defina o modo de build do Flutter.

       O Flutter oferece suporte a três [modos de build][build modes]: Debug, Profile e Release.
       O modo de build é determinado pelo valor de `CONFIGURATION`.
       Se a sua configuração não corresponder a nenhum deles,
       você pode definir a configuração de build `FLUTTER_BUILD_MODE`
       com um destes valores.

       <DashImage image="development/add-to-app/ios/project-setup-swiftpm/flutter-build-mode.png" caption="Definindo `FLUTTER_BUILD_MODE` para configurações personalizadas em **Build Settings**." />

    1. Apenas para configurações **Debug**, defina as seguintes configurações de build:

       ```
       ENABLE_APP_SANDBOX=YES
       ENABLE_INCOMING_NETWORK_CONNECTIONS=YES
       RUNTIME_EXCEPTION_ALLOW_JIT=YES
       ```

       <DashImage image="development/add-to-app/macos/project-setup-swiftpm/allow-jit-build-setting.png" caption="Defina **Allow JIT** (RUNTIME_EXCEPTION_ALLOW_JIT) como **YES** nas **Build Settings** do target, apenas para configurações **Debug**." />

    1. (Opcional) Permita que o Xcode recompile o seu app Flutter.

       Adicione as seguintes configurações de build ao seu target
       para permitir que o Xcode recompile o seu app Flutter como parte do build.
       Isso permite fazer alterações no seu app Flutter
       sem precisar executar `flutter build swift-package` novamente.
       Isso exige uma instalação do Flutter na máquina.

       ```
       FLUTTER_APPLICATION_PATH=$SRCROOT/../my_flutter_app
       ENABLE_USER_SCRIPT_SANDBOXING=NO
       ```

       :::tip
       Isso recompila apenas o código do app Flutter.
       Se você adicionar novas dependências,
       será necessário executar `flutter build swift-package` novamente.
       :::

 1. <h3>Adicione um Run Script de Pre-action ao Scheme</h3>

    1. Abra **Product** &gt; **Scheme** &gt; **Edit Scheme...**
       &gt; **Build** (na barra lateral esquerda) &gt; **Pre-action** &gt; **+**
       &gt; **New Run Script Action**

    1. Selecione o seu projeto no menu suspenso **Provide build settings from**.

    1. Defina o script como segue:
       ```
       /bin/sh $FLUTTER_SWIFT_PACKAGE_OUTPUT/Scripts/flutter_integration.sh prebuild
       ```

    <DashImage image="development/add-to-app/ios/project-setup-swiftpm/pre-action.png" caption="Run Script de Pre-action no editor de schemes." />

 1. <h3>Adicione uma nova fase de Run Script de build ao seu target</h3>

    1. Acesse **Build Phases** do seu target
       &gt; **+** &gt; **New Run Script Phase**

    1. Defina o script como segue:
       ```
       /bin/sh $FLUTTER_SWIFT_PACKAGE_OUTPUT/Scripts/flutter_integration.sh assemble
       ```
    1. Desmarque **Based on dependency analysis**
    1. Adicione o seguinte em **Input File Lists**:
       ```
       $(FLUTTER_SWIFT_PACKAGE_OUTPUT)/Scripts/FlutterAssembleInputs.xcfilelist
       ```

    <DashImage image="development/add-to-app/ios/project-setup-swiftpm/build-phase-run-script.png" caption="Nova Run Script Build Phase em Build Phases." />

{:.steps}

## Próximos passos {:#next-steps}

Agora você pode [adicionar uma tela Flutter][add a Flutter screen] ao seu
app macOS existente.

[add a Flutter screen]: /add-to-app/macos/add-flutter-screen
[build modes]: /testing/build-modes
