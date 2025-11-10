<!-- ia-translate: true -->

Uma vez que você [ativar o Swift Package Manager][Turn on Swift Package Manager], a CLI do Flutter tenta migrar
seu projeto na próxima vez que você executar seu app usando a CLI.
Esta migração atualiza seu projeto Xcode para usar o Swift Package Manager para
adicionar dependências de plugins Flutter.

Para migrar seu projeto:

1. [Ative o Swift Package Manager][Turn on Swift Package Manager].

1. Execute o app macOS usando a CLI do Flutter.

   Se seu projeto macOS ainda não tiver integração com o Swift Package Manager, a
   CLI do Flutter tenta migrar seu projeto e gera uma saída semelhante a:

   ```console
   $ flutter run -d macos
   Adding Swift Package Manager integration...
   ```

   A migração automática do iOS modifica os
   arquivos `macos/Runner.xcodeproj/project.pbxproj` e
   `macos/Runner.xcodeproj/xcshareddata/xcschemes/Runner.xcscheme`.

1. Se a migração automática da CLI do Flutter falhar, siga as etapas em
   [adicionar integração ao Swift Package Manager manualmente][manualIntegration].

[Opcional] Para verificar se seu projeto foi migrado:

1. Execute o app no Xcode.
1. Certifique-se de que **Run Prepare Flutter Framework Script** é executado como uma pré-ação
   e que `FlutterGeneratedPluginSwiftPackage` é uma dependência de alvo.

   <DashImage image="development/packages-and-plugins/swift-package-manager/flutter-pre-action-build-log.png" caption="Certifique-se de que **Run Prepare Flutter Framework Script** é executado como uma pré-ação" />

[Turn on Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-on-swift-package-manager
[manualIntegration]: /packages-and-plugins/swift-package-manager/for-app-developers/#add-to-a-flutter-app-manually
