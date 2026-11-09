---
ia-translate: true
title: Swift Package Manager para desenvolvedores de apps
description: Como usar Swift Package Manager para dependências nativas iOS ou macOS
---

:::note
A partir da versão 3.44, o Flutter usa o [Swift Package Manager][]
para gerenciar dependências nativas iOS e macOS.
O Flutter continua a suportar CocoaPods em modo de manutenção,
no entanto, o registro do CocoaPods se torna permanentemente
[somente leitura em 2 de dezembro de 2026][cocoapods].
:::

[cocoapods]: https://blog.cocoapods.org/CocoaPods-Specs-Repo/
[Swift Package Manager]: https://www.swift.org/documentation/package-manager/

## Como ativar o Swift Package Manager {:#how-to-turn-on-swift-package-manager}

A partir da versão 3.44, o suporte do Flutter ao Swift Package Manager (SwiftPM)
está ativado por padrão.
Atualizar o Flutter e executar seu app adiciona automaticamente a integração com SwiftPM.
Isso faz com que seu projeto baixe os pacotes Swift dos quais
seus plugins Flutter dependem.
Para usar uma versão mais antiga do Flutter,
talvez você precise [remover a integração com Swift Package Manager][removeSPM]
do app.

Observe que o Flutter recorre ao CocoaPods para dependências que ainda
não suportam Swift Package Manager.

[Opcional] Para verificar se seu projeto está usando SwiftPM:

1. No Xcode, execute o app.
1. Certifique-se de que **Run Prepare Flutter Framework Script** é executado como uma pre-action
   e que `FlutterGeneratedPluginSwiftPackage` é uma dependência do target.

   <DashImage image="development/packages-and-plugins/swift-package-manager/flutter-pre-action-build-log.png" caption="Ensure **Run Prepare Flutter Framework Script** runs as a pre-action" />

Se você desativou o SwiftPM anteriormente, talvez precise ativá-lo com
`flutter config --enable-swift-package-manager`.

Se a migração automática funcionar para você e todas as suas dependências
suportarem Swift Package Manager,
você pode [remover a integração com CocoaPods][removeCocoaPods].

## Como remover a integração com CocoaPods {:#how-to-remove-cocoapods-integration}

**O Flutter recorre ao CocoaPods se alguma das dependências do seu projeto
não suportar Swift Package Manager.**
Certifique-se de que todos os plugins do seu projeto suportam Swift Package Manager
antes de remover o CocoaPods.

:::note
Se você editou manualmente seu `Podfile` para adicionar dependências
CocoaPods ou lógica diferente de plugins Flutter,
você deve remover essas alterações manualmente.
:::

<Tabs key="darwin-platform">
<Tab name="iOS project">

Para remover o CocoaPods do seu projeto, use os passos a seguir.

1. Para desintegrar o CocoaPods dos seus projetos Xcode, execute:

    ```sh
    cd ios
    pod deintegrate
    cd ..
    ```

2. Exclua os arquivos e diretórios relacionados ao CocoaPods:

    Exclua `ios/Podfile`, `ios/Podfile.lock`,
    o diretório `ios/Pods/` e
    o diretório `ios/.symlinks/` (se presente).

3. Verifique seus arquivos de configuração:

    Em `ios/Flutter/Debug.xcconfig`
    e `ios/Flutter/Release.xcconfig`,
    remova quaisquer linhas `#include` que referenciem `Pods/Target Support Files`
    ou arquivos `.xcconfig` do CocoaPods, se ainda estiverem presentes.

4. Limpe e compile seu projeto para verificar a migração:

    ```sh
    flutter clean
    flutter pub get
    flutter run
    ```

</Tab>
<Tab name="macOS project">

Para remover o CocoaPods do seu projeto, use os passos a seguir.

1. Para desintegrar o CocoaPods dos seus projetos Xcode, execute:

    ```sh
    cd macos
    pod deintegrate
    cd ..
    ```

2. Exclua os arquivos e diretórios relacionados ao CocoaPods:

    Exclua `macos/Podfile`, o diretório `macos/Pods/`
    e o diretório `macos/.symlinks/` (se presente).

3. Verifique seus arquivos de configuração:

    Em `macos/Flutter/Flutter-Debug.xcconfig` e `macos/Flutter/Flutter-Release.xcconfig`
    remova quaisquer linhas `#include` que referenciem `Pods/Target Support Files`
    ou arquivos `.xcconfig` do CocoaPods, se ainda estiverem presentes.

4. Limpe e compile seu projeto para verificar a migração:

    ```sh
    flutter clean
    flutter pub get
    flutter run
    ```

</Tab>
</Tabs>

## Como adicionar integração com Swift Package Manager manualmente {:#how-to-add-swift-package-manager-integration-manually}

Quando você atualiza para o Flutter 3.44 ou posterior e executa
seu app, a integração com SwiftPM é adicionada automaticamente. Você só precisa
destas instruções se ocorrerem problemas e você precisar adicionar
manualmente a integração com SwiftPM ao seu projeto.

A maioria dos desenvolvedores não precisa fazer isso.

Se você tiver um problema ao migrar automaticamente seu
projeto para SwiftPM, por favor [abra uma issue][file an issue].
Inclua a mensagem de erro e, se possível,
inclua uma cópia dos seguintes arquivos na sua issue:

* `ios/Runner.xcodeproj/project.pbxproj`
* `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`
   (ou o xcsheme do flavor usado)

<Tabs key="darwin-platform">
<Tab name="iOS project">

{% render "docs/swift-package-manager/migrate-ios-project-manually.md", site: site %}

</Tab>
<Tab name="macOS project">

{% render "docs/swift-package-manager/migrate-macos-project-manually.md", site: site %}

</Tab>
</Tabs>

[file an issue]: {{site.repo.flutter}}/issues/new?template=02_bug.yml

### Adicionar a um app existente (add-to-app) {:#add-to-an-existing-app-add-to-app}

Para usar SwiftPM, consulte uma das seguintes páginas, conforme apropriado:

* [Integrar um app Flutter ao seu projeto iOS][ios-add-2-app]
* [Integrar um app Flutter ao seu projeto macOS][macos-add-2-app]

[ios-add-2-app]:   /add-to-app/ios/project-setup
[macos-add-2-app]: /add-to-app/macos/project-setup

### Adicionar a um target personalizado do Xcode {:#add-to-a-custom-xcode-target}

Seu projeto Flutter Xcode pode ter [targets personalizados do Xcode][Xcode targets] para construir produtos adicionais,
como frameworks ou testes unitários.
Você pode adicionar integração com Swift Package Manager a esses targets personalizados do Xcode.

Siga os passos em
[Como adicionar integração com Swift Package Manager][manualIntegration].

No [Passo 1][Step 1], para o item 6 da lista,
use seu target personalizado em vez do target `Flutter`.

No [Passo 2][Step 2], para o item 6 da lista,
use seu target personalizado em vez do target `Flutter`.

[Xcode targets]: {{site.apple-dev}}/documentation/xcode/configuring-a-new-target-in-your-project
[manualIntegration]: #how-to-add-swift-package-manager-integration-manually
[Step 1]: #step-1-add-fluttergeneratedpluginswiftpackage-package-dependency
[Step 2]: #step-2-add-run-prepare-flutter-framework-script-pre-action

## Como remover integração com Swift Package Manager {:#how-to-remove-swift-package-manager-integration}

Quando seu app é modificado para suportar SwiftPM,
o projeto Xcode é atualizado para adicionar dependências de plugin Flutter.

Para desfazer esta migração:

1. [Desative o Swift Package Manager][Turn off Swift Package Manager].

1. Limpe seu projeto:

   ```sh
   flutter clean
   ```

1. Abra seu app (`ios/Runner.xcworkspace` ou `macos/Runner.xcworkspace`) no
   Xcode.

1. Navegue até **Package Dependencies** para o projeto.

1. Clique no pacote `FlutterGeneratedPluginSwiftPackage`, depois clique
   no botão <Icon id="remove" label="remove/minus"></Icon>.

   <DashImage image="development/packages-and-plugins/swift-package-manager/remove-generated-package.png" caption="The `FlutterGeneratedPluginSwiftPackage` to remove" />

1. Navegue até **Frameworks, Libraries, and Embedded Content** para o target `Runner`.

1. Clique em `FlutterGeneratedPluginSwiftPackage`, depois clique
   no botão <Icon id="remove" label="remove/minus"></Icon>.

   <DashImage image="development/packages-and-plugins/swift-package-manager/remove-generated-framework.png" caption="The `FlutterGeneratedPluginSwiftPackage` to remove" />

1. Vá para **Product > Scheme > Edit Scheme**.

1. Expanda a seção **Build** na barra lateral esquerda.

1. Clique em **Pre-actions**.

1. Expanda **Run Prepare Flutter Framework Script**.

1. Clique no botão <Icon id="delete" label="delete/trash"></Icon>.

   <DashImage image="development/packages-and-plugins/swift-package-manager/remove-flutter-pre-action.png" caption="The build pre-action to remove" />

[Turn off Swift Package Manager]: #how-to-turn-off-swift-package-manager

## Como usar um plugin Flutter Swift Package Manager que requer uma versão de OS mais alta {:#how-to-use-a-swift-package-manager-flutter-plugin-that-requires-a-higher-os-version}

Se um plugin Flutter Swift Package Manager requer uma versão de OS mais alta do que
o projeto, você pode obter um erro como este:

```plaintext
Target Integrity (Xcode): The package product 'plugin_name_ios' requires minimum platform version 14.0 for the iOS platform, but this target supports 12.0
```

Para usar o plugin:

1. Abra seu app (`ios/Runner.xcworkspace` ou `macos/Runner.xcworkspace`) no
   Xcode.

1. Aumente o **Minimum Deployments** do target do seu app.

   <DashImage image="development/packages-and-plugins/swift-package-manager/minimum-deployments.png" caption="The target's **Minimum Deployments** setting" />

1. Se você atualizou o **Minimum Deployments** do seu app iOS,
   regenere os arquivos de configuração do projeto iOS:

   ```sh
   flutter build ios --config-only
   ```

1. Se você atualizou o **Minimum Deployments** do seu app macOS,
   regenere os arquivos de configuração do projeto macOS:

   ```sh
   flutter build macos --config-only
   ```

## Como desativar o Swift Package Manager {:#how-to-turn-off-swift-package-manager}

Em geral, não faça isso. Lembre-se de que
o registro do CocoaPods se torna somente leitura em 2 de dezembro de 2026
e desativar o SwiftPM não será permitido no futuro.

Desativar o Swift Package Manager faz com que o Flutter use CocoaPods para todas
as dependências. No entanto, o SwiftPM permanece integrado ao seu projeto.
Para remover completamente a integração com Swift Package Manager do seu projeto,
siga as instruções em [Como remover integração com Swift Package Manager][removeSPM].

### Desativar o SwiftPM para um único projeto {:#turn-off-swiftpm-for-a-single-project}

No arquivo `pubspec.yaml` do projeto, na seção `flutter`,
defina `enable-swift-package-manager` como `false` na subseção `config`.

```yaml title="pubspec.yaml"
# The following section is specific to Flutter packages.
flutter:
  config:
    enable-swift-package-manager: false
```

Isso desativa o Swift Package Manager para todos os contribuidores deste projeto.

### Desativar o SwiftPM globalmente para todos os projetos {:#turn-off-swiftpm-globally-for-all-projects}

Execute o seguinte comando:

```sh
flutter config --no-enable-swift-package-manager
```

Isso desativa o Swift Package Manager para o usuário atual.

Se um projeto for incompatível com Swift Package Manager,
todos os contribuidores precisam executar este comando.

[removeCocoaPods]: #how-to-remove-cocoapods-integration
[removeSPM]: #how-to-remove-swift-package-manager-integration
