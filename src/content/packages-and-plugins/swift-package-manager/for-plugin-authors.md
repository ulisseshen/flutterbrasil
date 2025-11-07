---
ia-translate: true
title: Swift Package Manager for plugin authors
description: Como adicionar compatibilidade Swift Package Manager a plugins iOS e macOS
---

:::warning
Flutter está migrando para [Swift Package Manager][]
para gerenciar dependências nativas iOS e macOS.
O suporte do Flutter ao Swift Package Manager está em desenvolvimento.
Se você encontrar um bug no suporte do Flutter ao Swift Package Manager,
[abra uma issue][open an issue].
O suporte ao Swift Package Manager está [desativado por padrão][off by default].
O Flutter continua a suportar CocoaPods.
:::

A integração do Flutter com Swift Package Manager tem vários benefícios:

1. **Fornece acesso ao ecossistema de packages Swift**.
   Plugins Flutter podem usar o crescente ecossistema de [Swift packages][]!
1. **Simplifica a instalação do Flutter**.
   Swift Package Manager vem incluído com Xcode.
   No futuro, você não precisará instalar Ruby e CocoaPods para ter como alvo iOS ou
   macOS.


[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[off by default]: #how-to-turn-on-swift-package-manager
[Swift packages]: https://swiftpackageindex.com/
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% include docs/swift-package-manager/how-to-enable-disable.md %}

## How to add Swift Package Manager support to an existing Flutter plugin

Este guia mostra como adicionar suporte Swift Package Manager a um plugin que
já suporta CocoaPods.
Isso garante que o plugin seja usável por todos os projetos Flutter.

Plugins Flutter devem suportar _tanto_ Swift Package Manager _quanto_ CocoaPods até
novo aviso.

A adoção do Swift Package Manager será gradual.
Plugins que não suportam CocoaPods não serão usáveis por projetos que ainda não
migraram para Swift Package Manager.
Plugins que não suportam Swift Package Manager podem causar problemas para projetos
que já migraram.


{% tabs %}
{% tab "Swift plugin" %}

{% include docs/swift-package-manager/migrate-swift-plugin.md %}

{% endtab %}
{% tab "Objective-C plugin" %}

{% include docs/swift-package-manager/migrate-objective-c-plugin.md %}

{% endtab %}
{% endtabs %}

## How to update unit tests in a plugin's example app

Se seu plugin tem XCTests nativos, você pode precisar atualizá-los para funcionar com
Swift Package Manager se uma das seguintes condições for verdadeira:

* Você está usando uma dependência CocoaPod para o teste.
* Seu plugin está explicitamente configurado para `type: .dynamic` em seu arquivo `Package.swift`.

Para atualizar seus unit tests:

1. Abra seu `example/ios/Runner.xcworkspace` no Xcode.

1. Se você estava usando uma dependência CocoaPod para testes, como `OCMock`,
   você vai querer removê-la do seu arquivo `Podfile`.

   ```ruby title="ios/Podfile" diff
     target 'RunnerTests' do
       inherit! :search_paths

   -   pod 'OCMock', '3.5'
     end
   ```

   Então no terminal, execute `pod install` no diretório `plugin_name_ios/example/ios`.

1. Navegue até **Package Dependencies** do projeto.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/package-dependencies.png",
   caption:"As package dependencies do projeto" %}

1. Clique no botão **+** e adicione quaisquer dependências apenas para testes pesquisando por
   elas na barra de pesquisa superior direita.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/search-for-ocmock.png",
   caption:"Pesquise por dependências apenas para testes" %}

   :::note
   OCMock usa unsafe build flags e só pode ser usado se direcionado por commit.
   `fe1661a3efed11831a6452f4b1a0c5e6ddc08c3d` é o commit para a versão 3.9.3.
   :::

1. Certifique-se de que a dependência seja adicionada ao Target `RunnerTests`.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/choose-package-products-test.png",
   caption:"Certifique-se de que a dependência seja adicionada ao target `RunnerTests`" %}

1. Clique no botão **Add Package**.

1. Se você configurou explicitamente o tipo de biblioteca do seu plugin para `.dynamic` em seu
   arquivo `Package.swift`
   ([não recomendado pela Apple][library type recommendations]),
   você também precisará adicioná-lo como uma dependência ao target `RunnerTests`.

   1. Certifique-se de que `RunnerTests` **Build Phases** tenha uma fase de build **Link Binary With Libraries**:

      {% render docs/captioned-image.liquid,
      image:"development/packages-and-plugins/swift-package-manager/runner-tests-link-binary-with-libraries.png",
      caption:"A Build Phase `Link Binary With Libraries` no target `RunnerTests`" %}

      Se a fase de build ainda não existir, crie uma.
      Clique no <span class="material-symbols">add</span> e
      então clique em **New Link Binary With Libraries Phase**.

      {% render docs/captioned-image.liquid,
      image:"development/packages-and-plugins/swift-package-manager/add-runner-tests-link-binary-with-libraries.png",
      caption:"Adicione a Build Phase `Link Binary With Libraries`" %}

   1. Navegue até **Package Dependencies** do projeto.

   1. Clique em <span class="material-symbols">add</span>.

   1. No diálogo que abre, clique no botão **Add Local...**.

   1. Navegue até `plugin_name/plugin_name_ios/ios/plugin_name_ios` e clique
      no botão **Add Package**.

   1. Certifique-se de que seja adicionado ao target `RunnerTests` e clique no
      botão **Add Package**.

1. Certifique-se de que os testes passem com **Product > Test**.

[library type recommendations]: https://developer.apple.com/documentation/packagedescription/product/library(name:type:targets:)
