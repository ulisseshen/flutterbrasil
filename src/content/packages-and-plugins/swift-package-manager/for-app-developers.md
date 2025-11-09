---
ia-translate: true
title: Swift Package Manager para desenvolvedores de apps
description: Como usar Swift Package Manager para dependências nativas iOS ou macOS
---

:::warning
Flutter está migrando para [Swift Package Manager][] para gerenciar dependências nativas iOS e macOS.
O suporte do Flutter ao Swift Package Manager está em desenvolvimento.
Se você encontrar um bug no suporte do Flutter ao Swift Package Manager,
[abra uma issue][open an issue].
O suporte ao Swift Package Manager está [desativado por padrão][off by default].
Flutter continua a suportar CocoaPods.
:::

A integração do Flutter com Swift Package Manager tem vários benefícios:

1. **Fornece acesso ao ecossistema de pacotes Swift**.
   Plugins Flutter podem usar o crescente ecossistema de [pacotes Swift][Swift packages].
1. **Simplifica a instalação do Flutter**.
   Xcode inclui Swift Package Manager.
   Você não precisa instalar Ruby e CocoaPods se seu projeto usa
   Swift Package Manager.

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[off by default]: #how-to-turn-on-swift-package-manager
[Swift packages]: https://swiftpackageindex.com/
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% render "docs/swift-package-manager/how-to-enable-disable.md", site: site %}

## Como adicionar integração com Swift Package Manager

### Adicionar a um app Flutter

<Tabs key="darwin-platform">
<Tab name="iOS project">

{% render "docs/swift-package-manager/migrate-ios-project.md", site: site %}

</Tab>
<Tab name="macOS project">

{% render "docs/swift-package-manager/migrate-macos-project.md", site: site %}

</Tab>
</Tabs>

### Adicionar a um app Flutter _manualmente_

<Tabs key="darwin-platform">
<Tab name="iOS project">

{% render "docs/swift-package-manager/migrate-ios-project-manually.md", site: site %}

</Tab>
<Tab name="macOS project">

{% render "docs/swift-package-manager/migrate-macos-project-manually.md", site: site %}

</Tab>
</Tabs>

### Adicionar a um app existente (add-to-app)

O suporte do Flutter ao Swift Package Manager não funciona com cenários add-to-app.

Para acompanhar atualizações de status, consulte [flutter#146957][].

[flutter#146957]: https://github.com/flutter/flutter/issues/146957

### Adicionar a um target personalizado do Xcode

Seu projeto Flutter Xcode pode ter [targets personalizados do Xcode][Xcode targets] para construir produtos adicionais,
como frameworks ou testes unitários.
Você pode adicionar integração com Swift Package Manager a esses targets personalizados do Xcode.

Siga os passos em
[Como adicionar integração com Swift Package Manager a um projeto _manualmente_][manualIntegration].

No [Passo 1][manualIntegrationStep1], item 6 da lista, use seu target personalizado em vez
do target `Flutter`.

No [Passo 2][manualIntegrationStep2], item 6 da lista, use seu target personalizado em vez
do target `Flutter`.

[Xcode targets]: https://developer.apple.com/documentation/xcode/configuring-a-new-target-in-your-project
[manualIntegration]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-add-swift-package-manager-integration-to-a-flutter-app-manually
[manualIntegrationStep1]: /packages-and-plugins/swift-package-manager/for-app-developers/#step-1-add-fluttergeneratedpluginswiftpackage-package-dependency
[manualIntegrationStep2]: /packages-and-plugins/swift-package-manager/for-app-developers/#step-2-add-run-prepare-flutter-framework-script-pre-action

## Como remover integração com Swift Package Manager

Para adicionar integração com Swift Package Manager, o Flutter CLI migra seu projeto.
Esta migração atualiza seu projeto Xcode para adicionar dependências de plugin Flutter.

Para desfazer esta migração:

1. [Desative o Swift Package Manager][Turn off Swift Package Manager].

1. Limpe seu projeto:

   ```sh
   flutter clean
   ```

1. Abra seu app (`ios/Runner.xcworkspace` ou `macos/Runner.xcworkspace`) no
   Xcode.

1. Navegue até **Package Dependencies** para o projeto.

1. Clique no pacote `FlutterGeneratedPluginSwiftPackage`, depois clique em
   <span class="material-symbols" translate="no">remove</span>.

   <DashImage image="development/packages-and-plugins/swift-package-manager/remove-generated-package.png" caption="The `FlutterGeneratedPluginSwiftPackage` to remove" />

1. Navegue até **Frameworks, Libraries, and Embedded Content** para o target `Runner`.

1. Clique em `FlutterGeneratedPluginSwiftPackage`, depois clique no
   <span class="material-symbols" translate="no">remove</span>.

   <DashImage image="development/packages-and-plugins/swift-package-manager/remove-generated-framework.png" caption="The `FlutterGeneratedPluginSwiftPackage` to remove" />

1. Vá para **Product > Scheme > Edit Scheme**.

1. Expanda a seção **Build** na barra lateral esquerda.

1. Clique em **Pre-actions**.

1. Expanda **Run Prepare Flutter Framework Script**.

1. Clique em **<span class="material-symbols" translate="no">delete</span>**.

   <DashImage image="development/packages-and-plugins/swift-package-manager/remove-flutter-pre-action.png" caption="The build pre-action to remove" />

[Turn off Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-off-swift-package-manager

## Como usar um plugin Flutter Swift Package Manager que requer uma versão de OS mais alta

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
