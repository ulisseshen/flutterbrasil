Substitua `plugin_name` ao longo deste guia pelo nome do seu plugin.
O exemplo abaixo usa `ios`, substitua `ios` por `macos`/`darwin` conforme aplicável.

1. [Ative o recurso Swift Package Manager][enableSPM].

1. Comece criando um diretório sob os diretórios `ios`, `macos`, e/ou `darwin`.
   Nomeie este novo diretório com o nome do pacote de plataforma.

   ```plaintext highlightLines=3
   plugin_name/ios/
   ├── ...
   └── plugin_name/
   ```

1. Dentro deste novo diretório, crie os seguintes arquivos/diretórios:

    - `Package.swift` (arquivo)
    - `Sources` (diretório)
    - `Sources/plugin_name` (diretório)
    - `Sources/plugin_name/include` (diretório)
    - `Sources/plugin_name/include/plugin_name` (diretório)
    - `Sources/plugin_name/include/plugin_name/.gitkeep` (arquivo)
      - Este arquivo garante que o diretório seja commitado.
        Você pode remover o arquivo `.gitkeep` se outros arquivos forem adicionados ao
        diretório.

   Seu plugin deve se parecer com:

   ```plaintext highlightLines=4-6
   plugin_name/ios/
   ├── ...
   └── plugin_name/
      ├── Package.swift
      └── Sources/plugin_name/include/plugin_name/
         └── .gitkeep
   ```

1. Use o seguinte template no arquivo `Package.swift`:

   ```swift title="Package.swift"
   // swift-tools-version: 5.9
   // The swift-tools-version declares the minimum version of Swift required to build this package.

   import PackageDescription

   let package = Package(
       // TODO: Update your plugin name.
       name: "plugin_name",
       platforms: [
           // TODO: Update the platforms your plugin supports.
           // If your plugin only supports iOS, remove `.macOS(...)`.
           // If your plugin only supports macOS, remove `.iOS(...)`.
           .iOS("13.0"),
           .macOS("10.15")
       ],
       products: [
           // TODO: Update your library and target names.
           // If the plugin name contains "_", replace with "-" for the library name
           .library(name: "plugin-name", targets: ["plugin_name"])
       ],
       dependencies: [],
       targets: [
           .target(
               // TODO: Update your target name.
               name: "plugin_name",
               dependencies: [],
               resources: [
                   // TODO: If your plugin requires a privacy manifest
                   // (e.g. if it uses any required reason APIs), update the PrivacyInfo.xcprivacy file
                   // to describe your plugin's privacy impact, and then uncomment this line.
                   // For more information, see:
                   // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                   // .process("PrivacyInfo.xcprivacy"),

                   // TODO: If you have other resources that need to be bundled with your plugin, refer to
                   // the following instructions to add them:
                   // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
               ],
               cSettings: [
                   // TODO: Update your plugin name.
                   .headerSearchPath("include/plugin_name")
               ]
           )
       ]
   )
   ```

1. Atualize as [plataformas suportadas][supported platforms] no seu arquivo `Package.swift`.

   ```swift title="Package.swift"
       platforms: [
           // TODO: Update the platforms your plugin supports.
           // If your plugin only supports iOS, remove `.macOS(...)`.
           // If your plugin only supports macOS, remove `.iOS(...)`.
           [!.iOS("13.0"),!]
           [!.macOS("10.15")!]
       ],
   ```

   [supported platforms]: https://developer.apple.com/documentation/packagedescription/supportedplatform

1. Atualize os nomes do pacote, biblioteca e alvo no seu arquivo `Package.swift`.

   ```swift title="Package.swift"
   let package = Package(
       // TODO: Update your plugin name.
       name: [!"plugin_name"!],
       platforms: [
           .iOS("13.0"),
           .macOS("10.15")
       ],
       products: [
           // TODO: Update your library and target names.
           // If the plugin name contains "_", replace with "-" for the library name
           .library(name: [!"plugin-name"!], targets: [[!"plugin_name"!]])
       ],
       dependencies: [],
       targets: [
           .target(
               // TODO: Update your target name.
               name: [!"plugin_name"!],
               dependencies: [],
               resources: [
                   // TODO: If your plugin requires a privacy manifest
                   // (e.g. if it uses any required reason APIs), update the PrivacyInfo.xcprivacy file
                   // to describe your plugin's privacy impact, and then uncomment this line.
                   // For more information, see:
                   // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                   // .process("PrivacyInfo.xcprivacy"),

                   // TODO: If you have other resources that need to be bundled with your plugin, refer to
                   // the following instructions to add them:
                   // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
               ],
               cSettings: [
                   // TODO: Update your plugin name.
                   .headerSearchPath("include/[!plugin_name!]")
               ]
           )
       ]
   )
   ```

   :::note
   Se o nome do plugin contiver `_`, o nome da biblioteca deve ser uma versão
   separada por `-` do nome do plugin.
   :::

1. Se seu plugin tiver um [arquivo `PrivacyInfo.xcprivacy`][`PrivacyInfo.xcprivacy` file], mova-o para
   `ios/plugin_name/Sources/plugin_name/PrivacyInfo.xcprivacy` e descomente
   o recurso no arquivo `Package.swift`.

   ```swift title="Package.swift"
               resources: [
                   // TODO: If your plugin requires a privacy manifest
                   // (e.g. if it uses any required reason APIs), update the PrivacyInfo.xcprivacy file
                   // to describe your plugin's privacy impact, and then uncomment this line.
                   // For more information, see:
                   // https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
                   [!.process("PrivacyInfo.xcprivacy"),!]

                   // TODO: If you have other resources that need to be bundled with your plugin, refer to
                   // the following instructions to add them:
                   // https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package
               ],
   ```

1. Mova quaisquer arquivos de recursos de `ios/Assets` para
   `ios/plugin_name/Sources/plugin_name` (ou um subdiretório).
   Adicione os arquivos de recursos ao seu arquivo `Package.swift`, se aplicável.
   Para mais instruções, veja
   [https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package](https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package).

1. Mova quaisquer headers públicos de `ios/Classes` para
   `ios/plugin_name/Sources/plugin_name/include/plugin_name`.

   * Se você não tiver certeza de quais headers são públicos, verifique o atributo
     [`public_header_files`][`public_header_files`] do arquivo `podspec`.
     Se este atributo não estiver especificado, todos os seus headers eram públicos.
     Você deveria considerar se deseja que todos os seus headers sejam públicos.

   * A `pluginClass` definida no seu arquivo `pubspec.yaml` deve ser pública e
     estar dentro deste diretório.

1. Lidando com `modulemap`.

   Pule esta etapa se seu plugin não tiver um `modulemap`.

   Se você estiver usando um `modulemap` para CocoaPods criar um submódulo Test,
   considere removê-lo para Swift Package Manager.
   Observe que isso disponibiliza todos os headers públicos através do módulo.

   Para remover o `modulemap` para Swift Package Manager mas mantê-lo para
   CocoaPods, exclua o `modulemap` e o header guarda-chuva no arquivo
   `Package.swift` do plugin.

   O exemplo abaixo assume que o `modulemap` e o header guarda-chuva estão localizados
   no diretório `ios/plugin_name/Sources/plugin_name/include`.

    ```swift title="Package.swift" diff
      .target(
          name: "plugin_name",
          dependencies: [],
    +     exclude: ["include/cocoapods_plugin_name.modulemap", "include/plugin_name-umbrella.h"],
    ```

    Se você quiser manter seus testes unitários compatíveis com CocoaPods e
    Swift Package Manager, você pode tentar o seguinte:

    ```objc title="Tests/TestFile.m" diff
      @import plugin_name;
    - @import plugin_name.Test;
    + #if __has_include(<plugin_name/plugin_name-umbrella.h>)
    +   @import plugin_name.Test;
    + #endif
    ```

    Se você quiser usar um `modulemap` personalizado com seu pacote Swift,
    consulte a [documentação do Swift Package Manager][Swift Package Manager's documentation].

1. Mova todos os arquivos restantes de `ios/Classes` para
   `ios/plugin_name/Sources/plugin_name`.

1. Os diretórios `ios/Assets`, `ios/Resources` e `ios/Classes` agora devem
   estar vazios e podem ser deletados.

1. Se seus arquivos de header não estiverem mais no mesmo diretório que seus
   arquivos de implementação, você deve atualizar suas declarações de import.

   Por exemplo, imagine a seguinte migração:

   * Antes:

     ```plaintext
     ios/Classes/
     ├── PublicHeaderFile.h
     └── ImplementationFile.m
     ```

   * Depois:

     ```plaintext highlightLines=2
     ios/plugin_name/Sources/plugin_name/
     └── include/plugin_name/
        └── PublicHeaderFile.h
     └── ImplementationFile.m
     ```

   Neste exemplo, as declarações de import em `ImplementationFile.m`
   devem ser atualizadas:

   ```objc title="Sources/plugin_name/ImplementationFile.m" diff
   - #import "PublicHeaderFile.h"
   + #import "./include/plugin_name/PublicHeaderFile.h"
   ```

1. Se seu plugin usa [Pigeon][Pigeon], atualize seu arquivo de entrada Pigeon.

   ```dart title="pigeons/messages.dart" diff
     javaOptions: JavaOptions(),
   - objcHeaderOut: 'ios/Classes/messages.g.h',
   - objcSourceOut: 'ios/Classes/messages.g.m',
   + objcHeaderOut: 'ios/plugin_name/Sources/plugin_name/messages.g.h',
   + objcSourceOut: 'ios/plugin_name/Sources/plugin_name/messages.g.m',
     copyrightHeader: 'pigeons/copyright.txt',
   ```

   Se seu arquivo `objcHeaderOut` não estiver mais dentro do mesmo diretório que o
   `objcSourceOut`, você pode alterar o `#import` usando
   `ObjcOptions.headerIncludePath`:

   ```dart title="pigeons/messages.dart" diff
     javaOptions: JavaOptions(),
   - objcHeaderOut: 'ios/Classes/messages.g.h',
   - objcSourceOut: 'ios/Classes/messages.g.m',
   + objcHeaderOut: 'ios/plugin_name/Sources/plugin_name/include/plugin_name/messages.g.h',
   + objcSourceOut: 'ios/plugin_name/Sources/plugin_name/messages.g.m',
   + objcOptions: ObjcOptions(
   +   headerIncludePath: './include/plugin_name/messages.g.h',
   + ),
     copyrightHeader: 'pigeons/copyright.txt',
   ```

   Execute Pigeon para re-gerar seu código com a configuração mais recente.

1. Atualize seu arquivo `Package.swift` com quaisquer personalizações que você precise.

   1. Abra o diretório `ios/plugin_name/` no Xcode.

   1. No Xcode, abra seu arquivo `Package.swift`.
      Verifique se o Xcode não produz avisos ou erros para este arquivo.

      :::tip
      Se o Xcode não mostrar nenhum arquivo, saia do Xcode (**Xcode > Quit Xcode**) e
      reabra.

      Se o Xcode não atualizar após você fazer uma alteração, tente clicar em
      **File > Packages > Reset Package Caches**.
      :::

   1. Se seu arquivo `ios/plugin_name.podspec` tiver [dependências][CocoaPods `dependency`] CocoaPods,
      adicione as [dependências Swift Package Manager][Swift Package Manager dependencies] correspondentes ao seu
      arquivo `Package.swift`.

   1. Se seu pacote deve ser vinculado explicitamente como `static` ou `dynamic`
      ([não recomendado pela Apple][not recommended by Apple]), atualize o [Product][Product] para definir o
      tipo:

      ```swift title="Package.swift"
      products: [
          .library(name: "plugin-name", type: .static, targets: ["plugin_name"])
      ],
      ```

   1. Faça quaisquer outras personalizações. Para mais informações sobre como escrever um
      arquivo `Package.swift`, veja
      [https://developer.apple.com/documentation/packagedescription](https://developer.apple.com/documentation/packagedescription).

      :::tip
      Se você adicionar alvos ao seu arquivo `Package.swift`, use nomes únicos.
      Isso evita conflitos com alvos de outros pacotes.
      :::

1. Atualize seu `ios/plugin_name.podspec` para apontar para novos caminhos.

   ```ruby title="ios/plugin_name.podspec" diff
   - s.source_files = 'Classes/**/*.{h,m}'
   - s.public_header_files = 'Classes/**/*.h'
   - s.module_map = 'Classes/cocoapods_plugin_name.modulemap'
   - s.resource_bundles = {'plugin_name_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
   + s.source_files = 'plugin_name/Sources/plugin_name/**/*.{h,m}'
   + s.public_header_files = 'plugin_name/Sources/plugin_name/include/**/*.h'
   + s.module_map = 'plugin_name/Sources/plugin_name/include/cocoapods_plugin_name.modulemap'
   + s.resource_bundles = {'plugin_name_privacy' => ['plugin_name/Sources/plugin_name/PrivacyInfo.xcprivacy']}
   ```

1. Atualize o carregamento de recursos do pacote para usar `SWIFTPM_MODULE_BUNDLE`:

   ```objc
   #if SWIFT_PACKAGE
      NSBundle *bundle = SWIFTPM_MODULE_BUNDLE;
    #else
      NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    #endif
    NSURL *imageURL = [bundle URLForResource:@"image" withExtension:@"jpg"];
   ```

   :::note
   `SWIFTPM_MODULE_BUNDLE` só funciona se houver recursos reais
   (ou [definidos no arquivo `Package.swift`][Bundling resources] ou
   [automaticamente incluídos pelo Xcode][Xcode resource detection]).
   Caso contrário, usar `SWIFTPM_MODULE_BUNDLE` resulta em um erro.
   :::

1. Se seu diretório `ios/plugin_name/Sources/plugin_name/include` contiver apenas
   um `.gitkeep`, você vai querer atualizar seu `.gitignore` para incluir o
   seguinte:

    ```text title=".gitignore"
    !.gitkeep
    ```

    Execute `flutter pub publish --dry-run` para garantir que o diretório `include`
    seja publicado.

1. Commite as alterações do seu plugin no seu sistema de controle de versão.

1. Verifique se o plugin ainda funciona com CocoaPods.

   1. Desative o Swift Package Manager:

      ```sh
      flutter config --no-enable-swift-package-manager
      ```

   1. Navegue até o app de exemplo do plugin.

      ```sh
      cd path/to/plugin/example/
      ```

   1. Certifique-se de que o app de exemplo do plugin compila e executa.

      ```sh
      flutter run
      ```

   1. Navegue até o diretório de nível superior do plugin.

      ```sh
      cd path/to/plugin/
      ```

   1. Execute os lints de validação do CocoaPods:

      ```sh
      pod lib lint ios/plugin_name.podspec  --configuration=Debug --skip-tests --use-modular-headers --use-libraries
      ```

      ```sh
      pod lib lint ios/plugin_name.podspec  --configuration=Debug --skip-tests --use-modular-headers
      ```

1. Verifique se o plugin funciona com Swift Package Manager.

   1. Ative o Swift Package Manager:

      ```sh
      flutter config --enable-swift-package-manager
      ```

   1. Navegue até o app de exemplo do plugin.

      ```sh
      cd path/to/plugin/example/
      ```

   1. Certifique-se de que o app de exemplo do plugin compila e executa.

      ```sh
      flutter run
      ```

      :::note
      Usar a CLI do Flutter para executar o app de exemplo do plugin com o
      recurso Swift Package Manager ativado migra o projeto para adicionar
      integração ao Swift Package Manager.

      Isso aumenta o requisito do Flutter SDK do app de exemplo para a versão 3.24 ou
      superior.

      Se você quiser executar o app de exemplo usando uma versão mais antiga do Flutter SDK,
      não commite as alterações da migração no seu sistema de controle de versão.
      Se necessário, você sempre pode
      [desfazer a migração do Swift Package Manager][removeSPM].
      :::

   1. Abra o app de exemplo do plugin no Xcode.
      Certifique-se de que **Package Dependencies** apareça no
      **Project Navigator** à esquerda.

1. Verifique se os testes passam.

   * **Se seu plugin tiver testes unitários nativos (XCTest), certifique-se de também
     [atualizar os testes unitários no app de exemplo do plugin][update unit tests in the plugin's example app].**

   * Siga as instruções para [testar plugins][testing plugins].

[enableSPM]: /packages-and-plugins/swift-package-manager/for-plugin-authors#how-to-turn-on-swift-package-manager
[`PrivacyInfo.xcprivacy` file]: https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
[`public_header_files`]: https://guides.cocoapods.org/syntax/podspec.html#public_header_files
[Swift Package Manager's documentation]: {{site.github}}/apple/swift-package-manager/blob/main/Documentation/Usage.md#creating-c-language-targets
[Pigeon]: https://pub.dev/packages/pigeon
[CocoaPods `dependency`]: https://guides.cocoapods.org/syntax/podspec.html#dependency
[Swift Package Manager dependencies]: https://developer.apple.com/documentation/packagedescription/package/dependency
[not recommended by Apple]: https://developer.apple.com/documentation/packagedescription/product/library(name:type:targets:)
[Product]: https://developer.apple.com/documentation/packagedescription/product
[Bundling resources]: https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#Explicitly-declare-or-exclude-resources
[Xcode resource detection]: https://developer.apple.com/documentation/xcode/bundling-resources-with-a-swift-package#:~:text=Xcode%20detects%20common%20resource%20types%20for%20Apple%20platforms%20and%20treats%20them%20as%20a%20resource%20automatically
[removeSPM]: /packages-and-plugins/swift-package-manager/for-app-developers#how-to-remove-swift-package-manager-integration
[update unit tests in the plugin's example app]: /packages-and-plugins/swift-package-manager/for-plugin-authors/#how-to-update-unit-tests-in-a-plugins-example-app
[testing plugins]: https://docs.flutterbrasil.dev/testing/testing-plugins
