Uma vez que você [ativar o Swift Package Manager][turn on Swift Package Manager], a CLI do Flutter tenta migrar
seu projeto para usar o Swift Package Manager na próxima vez que você executar seu app
usando a CLI.

No entanto, a ferramenta CLI do Flutter pode não conseguir migrar seu projeto
automaticamente se houver modificações inesperadas.

Se a migração automática falhar, use as etapas abaixo para adicionar a integração
ao Swift Package Manager a um projeto manualmente.

Antes de migrar manualmente, [registre uma issue][file an issue]; isso ajuda a equipe do Flutter a
melhorar o processo de migração automática.
Inclua a mensagem de erro e, se possível, inclua uma cópia dos
seguintes arquivos na sua issue:

* `ios/Runner.xcodeproj/project.pbxproj`
* `ios/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`
   (ou o xcscheme para o flavor usado)

### Passo 1: Adicione a dependência do pacote FlutterGeneratedPluginSwiftPackage {:.no_toc}

1. Abra seu app (`ios/Runner.xcworkspace`) no Xcode.
1. Navegue até **Package Dependencies** para o projeto.

   <DashImage image="development/packages-and-plugins/swift-package-manager/package-dependencies.png" caption="As dependências de pacotes do projeto" />

1. Clique em <span class="material-symbols" translate="no">add</span>.
1. Na caixa de diálogo que abrir, clique em **Add Local...**.
1. Navegue até `ios/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage`
   e clique em **Add Package**.
1. Certifique-se de que está adicionado ao alvo `Runner` e clique em **Add Package**.

   <DashImage image="development/packages-and-plugins/swift-package-manager/choose-package-products.png" caption="Certifique-se de que o pacote está adicionado ao alvo `Runner`" />

1. Certifique-se de que `FlutterGeneratedPluginSwiftPackage` foi adicionado a **Frameworks,
   Libraries, and Embedded Content**.

   <DashImage image="development/packages-and-plugins/swift-package-manager/add-generated-framework.png" caption="Certifique-se de que `FlutterGeneratedPluginSwiftPackage` foi adicionado a **Frameworks, Libraries, and Embedded Content**" />

### Passo 2: Adicione a pré-ação do script Run Prepare Flutter Framework Script {:.no_toc}

**As etapas a seguir devem ser concluídas para cada flavor.**

1. Vá para **Product > Scheme > Edit Scheme**.
1. Expanda a seção **Build** na barra lateral esquerda.
1. Clique em **Pre-actions**.
1. Clique em <span class="material-symbols" translate="no">add</span> e
   selecione **New Run Script Action** no menu.
1. Clique no título **Run Script** e mude-o para:

   ```plaintext
   Run Prepare Flutter Framework Script
   ```

1. Mude o **Provide build settings from** para o app `Runner`.
1. Digite o seguinte na caixa de texto:

   ```sh
   "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" prepare
   ```

   <DashImage image="development/packages-and-plugins/swift-package-manager/add-flutter-pre-action.png" caption="Adicione a pré-ação de build **Run Prepare Flutter Framework Script**" />

### Passo 3: Execute o app {:.no_toc}

1. Execute o app no Xcode.
1. Certifique-se de que **Run Prepare Flutter Framework Script** é executado como uma pré-ação
   e que `FlutterGeneratedPluginSwiftPackage` é uma dependência de alvo.

   <DashImage image="development/packages-and-plugins/swift-package-manager/flutter-pre-action-build-log.png" caption="Certifique-se de que **Run Prepare Flutter Framework Script** é executado como uma pré-ação" />

1. Certifique-se de que o app é executado na linha de comando com `flutter run`.

[turn on Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-on-swift-package-manager
[file an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml
