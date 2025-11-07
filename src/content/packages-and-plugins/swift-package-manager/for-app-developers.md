---
ia-translate: true
title: Swift Package Manager for app developers
description: Como usar Swift Package Manager para dependências nativas iOS ou macOS
---

:::warning
Flutter está migrando para [Swift Package Manager][] para gerenciar dependências nativas
iOS e macOS.
O suporte do Flutter ao Swift Package Manager está em desenvolvimento.
Se você encontrar um bug no suporte do Flutter ao Swift Package Manager,
[abra uma issue][open an issue].
O suporte ao Swift Package Manager está [desativado por padrão][off by default].
O Flutter continua a suportar CocoaPods.
:::

A integração do Flutter com Swift Package Manager tem vários benefícios:

1. **Fornece acesso ao ecossistema de packages Swift**.
   Plugins Flutter podem usar o crescente ecossistema de [Swift packages][].
1. **Simplifica a instalação do Flutter**.
   Xcode inclui Swift Package Manager.
   Você não precisa instalar Ruby e CocoaPods se seu projeto usa
   Swift Package Manager.

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[off by default]: #how-to-turn-on-swift-package-manager
[Swift packages]: https://swiftpackageindex.com/
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% include docs/swift-package-manager/how-to-enable-disable.md %}

## How to add Swift Package Manager integration

### Add to a Flutter app

{% tabs %}
{% tab "iOS project" %}

{% include docs/swift-package-manager/migrate-ios-project.md %}

{% endtab %}
{% tab "macOS project" %}

{% include docs/swift-package-manager/migrate-macos-project.md %}

{% endtab %}
{% endtabs %}

### Add to a Flutter app _manually_

{% tabs %}
{% tab "iOS project" %}

{% include docs/swift-package-manager/migrate-ios-project-manually.md %}

{% endtab %}
{% tab "macOS project" %}

{% include docs/swift-package-manager/migrate-macos-project-manually.md %}

{% endtab %}
{% endtabs %}

### Add to an existing app (add-to-app)

O suporte do Flutter ao Swift Package Manager não funciona com cenários add-to-app.

Para se manter atualizado sobre status, consulte [flutter#146957][].

[flutter#146957]: https://github.com/flutter/flutter/issues/146957

### Add to a custom Xcode target

Seu projeto Xcode Flutter pode ter [Xcode targets][] customizados para construir produtos
adicionais, como frameworks ou unit tests.
Você pode adicionar integração Swift Package Manager a estes Xcode targets customizados.

Siga os passos em
[How to add Swift Package Manager integration to a project _manually_][manualIntegration].

No [Step 1][manualIntegrationStep1], item 6 da lista, use seu target customizado em vez
do target `Flutter`.

No [Step 2][manualIntegrationStep2], item 6 da lista, use seu target customizado em vez
do target `Flutter`.

[Xcode targets]: https://developer.apple.com/documentation/xcode/configuring-a-new-target-in-your-project
[manualIntegration]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-add-swift-package-manager-integration-to-a-flutter-app-manually
[manualIntegrationStep1]: /packages-and-plugins/swift-package-manager/for-app-developers/#step-1-add-fluttergeneratedpluginswiftpackage-package-dependency
[manualIntegrationStep2]: /packages-and-plugins/swift-package-manager/for-app-developers/#step-2-add-run-prepare-flutter-framework-script-pre-action

## How to remove Swift Package Manager integration

Para adicionar integração Swift Package Manager, a CLI do Flutter migra seu projeto.
Esta migração atualiza seu projeto Xcode para adicionar dependências de plugin Flutter.

Para desfazer esta migração:

1. [Desative Swift Package Manager][Turn off Swift Package Manager].

1. Limpe seu projeto:

   ```sh
   flutter clean
   ```

1. Abra seu app (`ios/Runner.xcworkspace` ou `macos/Runner.xcworkspace`) no
   Xcode.

1. Navegue até **Package Dependencies** do projeto.

1. Clique no package `FlutterGeneratedPluginSwiftPackage`, então clique em
   <span class="material-symbols">remove</span>.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/remove-generated-package.png",
   caption:"O `FlutterGeneratedPluginSwiftPackage` a remover" %}

1. Navegue até **Frameworks, Libraries, and Embedded Content** do target `Runner`.

1. Clique em `FlutterGeneratedPluginSwiftPackage`, então clique no
   <span class="material-symbols">remove</span>.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/remove-generated-framework.png",
   caption:"O `FlutterGeneratedPluginSwiftPackage` a remover" %}

1. Vá para **Product > Scheme > Edit Scheme**.

1. Expanda a seção **Build** na barra lateral esquerda.

1. Clique em **Pre-actions**.

1. Expanda **Run Prepare Flutter Framework Script**.

1. Clique em **<span class="material-symbols">delete</span>**.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/remove-flutter-pre-action.png",
   caption:"A pre-action de build a remover" %}

[Turn off Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#how-to-turn-off-swift-package-manager

## How to use a Swift Package Manager Flutter plugin that requires a higher OS version

Se um plugin Flutter Swift Package Manager requer uma versão de OS mais alta que
o projeto, você pode obter um erro como este:

```plaintext
Target Integrity (Xcode): The package product 'plugin_name_ios' requires minimum platform version 14.0 for the iOS platform, but this target supports 12.0
```

Para usar o plugin, aumente os **Minimum Deployments** do target do seu app.

{% render docs/captioned-image.liquid,
image:"development/packages-and-plugins/swift-package-manager/minimum-deployments.png",
caption:"A configuração **Minimum Deployments** do target" %}
