<!-- ia-translate: true -->

Migrar para o SwiftPM requer atualizar os arquivos
`macos/Runner.xcodeproj/project.pbxproj` e
`macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`.

### Passo 1: Adicione a dependência do pacote FlutterGeneratedPluginSwiftPackage {:.no_toc #step-1-add-fluttergeneratedpluginswiftpackage-package-dependency}

1. No Xcode, abra `macos/Runner.xcworkspace`.
1. Navegue até **Package Dependencies** para o projeto.

   <DashImage image="development/packages-and-plugins/swift-package-manager/package-dependencies.png" caption="As dependências de pacotes do projeto" />

1. Clique no botão <Icon id="add" label="add/plus"></Icon>.
1. Na caixa de diálogo que abrir, clique em **Add Local...**.
1. Navegue até `macos/Flutter/ephemeral/Packages/FlutterGeneratedPluginSwiftPackage`
   e clique em **Add Package**.
1. Certifique-se de que está adicionado ao alvo `Runner` e clique em **Add Package**.

   <DashImage image="development/packages-and-plugins/swift-package-manager/choose-package-products.png" caption="Certifique-se de que o pacote está adicionado ao alvo `Runner`" />

1. Certifique-se de que `FlutterGeneratedPluginSwiftPackage` foi adicionado a **Frameworks,
   Libraries, and Embedded Content**.

   <DashImage image="development/packages-and-plugins/swift-package-manager/add-generated-framework.png" caption="Certifique-se de que `FlutterGeneratedPluginSwiftPackage` foi adicionado a **Frameworks, Libraries, and Embedded Content**" />

### Passo 2: Adicione a pré-ação do script Run Prepare Flutter Framework Script {:.no_toc #step-2-add-run-prepare-flutter-framework-script-pre-action}

**As etapas a seguir devem ser concluídas para cada flavor.**

1. Vá para **Product > Scheme > Edit Scheme**.
1. Expanda a seção **Build** na barra lateral esquerda.
1. Clique em **Pre-actions**.
1. Clique no botão <Icon id="add" label="add/plus"></Icon> e
   selecione **New Run Script Action** no menu.
1. Clique no título **Run Script** e mude-o para:

   ```plaintext
   Run Prepare Flutter Framework Script
   ```

1. Mude o **Provide build settings from** para o alvo `Runner`.
1. Digite o seguinte na caixa de texto:

   ```sh
   "$FLUTTER_ROOT"/packages/flutter_tools/bin/macos_assemble.sh prepare
   ```

   <DashImage image="development/packages-and-plugins/swift-package-manager/add-flutter-pre-action.png" caption="Adicione a pré-ação de build **Run Prepare Flutter Framework Script**" />

### Passo 3: Execute o app {:.no_toc #step-3-run-app}

1. No Xcode, execute o app.
1. Certifique-se de que **Run Prepare Flutter Framework Script** é executado como uma pré-ação
   e que `FlutterGeneratedPluginSwiftPackage` é uma dependência de alvo.

   <DashImage image="development/packages-and-plugins/swift-package-manager/flutter-pre-action-build-log.png" caption="Certifique-se de que `Run Prepare Flutter Framework Script` é executado como uma pré-ação" />

1. Certifique-se de que o app é executado na linha de comando com `flutter run`.

[file an issue]: {{site.repo.flutter}}/issues/new?template=2_bug.yml
