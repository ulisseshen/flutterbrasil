---
ia-translate: true
title: Swift Package Manager para desenvolvedores de aplicativos
description: Como usar o Swift Package Manager para dependências nativas iOS ou macOS
---

:::warning
O Flutter está migrando para o [Swift Package Manager][] para gerenciar as
dependências nativas de iOS e macOS.
O suporte do Flutter ao Swift Package Manager está em desenvolvimento.
Se você encontrar um bug no suporte do Flutter ao Swift Package Manager,
[abra uma issue][].
O suporte ao Swift Package Manager está [desativado por padrão][].
O Flutter continua a suportar o CocoaPods.
:::

A integração do Flutter com o Swift Package Manager tem diversos benefícios:

1.  **Fornece acesso ao ecossistema de pacotes Swift**.
    Os plugins do Flutter podem usar o crescente ecossistema de [pacotes
    Swift][].
2.  **Simplifica a instalação do Flutter**.
    O Xcode inclui o Swift Package Manager.
    Você não precisa instalar Ruby e CocoaPods se seu projeto usar o
    Swift Package Manager.

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[desativado por padrão]: #como-ativar-o-swift-package-manager
[pacotes Swift]: https://swiftpackageindex.com/
[abra uma issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% include docs/swift-package-manager/how-to-enable-disable.md %}

## Como adicionar a integração do Swift Package Manager

### Adicionar a um aplicativo Flutter

{% tabs %}
{% tab "Projeto iOS" %}

{% include docs/swift-package-manager/migrate-ios-project.md %}

{% endtab %}
{% tab "Projeto macOS" %}

{% include docs/swift-package-manager/migrate-macos-project.md %}

{% endtab %}
{% endtabs %}

### Adicionar a um aplicativo Flutter _manualmente_

{% tabs %}
{% tab "Projeto iOS" %}

{% include docs/swift-package-manager/migrate-ios-project-manually.md %}

{% endtab %}
{% tab "Projeto macOS" %}

{% include docs/swift-package-manager/migrate-macos-project-manually.md %}

{% endtab %}
{% endtabs %}

### Adicionar a um aplicativo existente (add-to-app)

O suporte do Flutter ao Swift Package Manager não funciona com cenários add-to-app.

Para se manter atualizado sobre as atualizações de status, consulte
[flutter#146957][].

[flutter#146957]: https://github.com/flutter/flutter/issues/146957

### Adicionar a um target Xcode personalizado

Seu projeto Flutter Xcode pode ter [targets Xcode][] personalizados para
construir produtos adicionais, como frameworks ou testes unitários. Você
pode adicionar a integração do Swift Package Manager a esses targets Xcode
personalizados.

Siga os passos em
[Como adicionar a integração do Swift Package Manager a um projeto
_manualmente_][manualIntegration].

No [Passo 1][manualIntegrationStep1], item 6 da lista, use seu target
personalizado em vez do target `Flutter`.

No [Passo 2][manualIntegrationStep2], item 6 da lista, use seu target
personalizado em vez do target `Flutter`.

[targets Xcode]: https://developer.apple.com/documentation/xcode/configuring-a-new-target-in-your-project
[manualIntegration]: /packages-and-plugins/swift-package-manager/for-app-developers/#como-adicionar-a-integracao-do-swift-package-manager-a-um-aplicativo-flutter-manualmente
[manualIntegrationStep1]: /packages-and-plugins/swift-package-manager/for-app-developers/#passo-1-adicione-fluttergeneratedpluginswiftpackage-como-dependencia-de-pacote
[manualIntegrationStep2]: /packages-and-plugins/swift-package-manager/for-app-developers/#passo-2-adicione-run-prepare-flutter-framework-script-pre-action

## Como remover a integração do Swift Package Manager

Para adicionar a integração do Swift Package Manager, o Flutter CLI migra seu
projeto. Essa migração atualiza seu projeto Xcode para adicionar as
dependências do plugin Flutter.

Para desfazer essa migração:

1.  [Desative o Swift Package Manager][].

2.  Limpe seu projeto:

    ```sh
    flutter clean
    ```

3.  Abra seu aplicativo (`ios/Runner.xcworkspace` ou `macos/Runner.xcworkspace`)
    no Xcode.

4.  Navegue até **Package Dependencies** (Dependências de Pacotes) do projeto.

5.  Clique no pacote `FlutterGeneratedPluginSwiftPackage` e, em seguida, clique
    em <span class="material-symbols">remove</span> (remover).

    {% render docs/captioned-image.liquid,
    image:"development/packages-and-plugins/swift-package-manager/remove-generated-package.png",
    caption:"O `FlutterGeneratedPluginSwiftPackage` a ser removido" %}

6.  Navegue até **Frameworks, Libraries, and Embedded Content** (Frameworks,
    Bibliotecas e Conteúdo Embutido) para o target `Runner`.

7.  Clique em `FlutterGeneratedPluginSwiftPackage` e, em seguida, clique em
    <span class="material-symbols">remove</span> (remover).

    {% render docs/captioned-image.liquid,
    image:"development/packages-and-plugins/swift-package-manager/remove-generated-framework.png",
    caption:"O `FlutterGeneratedPluginSwiftPackage` a ser removido" %}

8. Vá em **Product > Scheme > Edit Scheme** (Produto > Esquema > Editar Esquema).

9. Expanda a seção **Build** (Construir) na barra lateral esquerda.

10. Clique em **Pre-actions** (Pré-ações).

11. Expanda **Run Prepare Flutter Framework Script** (Executar Script Preparar
    Framework Flutter).

12. Clique em **<span class="material-symbols">delete</span>** (excluir).

    {% render docs/captioned-image.liquid,
    image:"development/packages-and-plugins/swift-package-manager/remove-flutter-pre-action.png",
    caption:"A pré-ação de construção a ser removida" %}

[Desative o Swift Package Manager]: /packages-and-plugins/swift-package-manager/for-app-developers/#como-desativar-o-swift-package-manager

## Como usar um plugin Flutter do Swift Package Manager que requer uma versão de SO superior

Se um plugin Flutter do Swift Package Manager exigir uma versão de SO superior
à do projeto, você poderá receber um erro como este:

```plaintext
Target Integrity (Xcode): The package product 'plugin_name_ios' requires minimum platform version 14.0 for the iOS platform, but this target supports 12.0
```

Para usar o plugin, aumente o **Minimum Deployments** (Implantação Mínima) do
target do seu aplicativo.

{% render docs/captioned-image.liquid,
image:"development/packages-and-plugins/swift-package-manager/minimum-deployments.png",
caption:"A configuração **Minimum Deployments** do target" %}
