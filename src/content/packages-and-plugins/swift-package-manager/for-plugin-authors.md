---
ia-translate: true
title: Swift Package Manager para autores de plugins
description: Como adicionar compatibilidade com Swift Package Manager a plugins iOS e macOS
---

:::warning
Flutter está migrando para [Swift Package Manager][]
para gerenciar dependências nativas iOS e macOS.
O suporte do Flutter ao Swift Package Manager está em desenvolvimento.
Se você encontrar um bug no suporte do Flutter ao Swift Package Manager,
[abra uma issue][open an issue].
O suporte ao Swift Package Manager está [desativado por padrão][off by default].
Flutter continua a suportar CocoaPods.
:::

A integração do Flutter com Swift Package Manager tem vários benefícios:

1. **Fornece acesso ao ecossistema de pacotes Swift**.
   Plugins Flutter podem usar o crescente ecossistema de [pacotes Swift][Swift packages]!
1. **Simplifica a instalação do Flutter**.
   Swift Package Manager vem integrado com Xcode.
   No futuro, você não precisará instalar Ruby e CocoaPods para ter como alvo iOS ou
   macOS.


[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[off by default]: #how-to-turn-on-swift-package-manager
[Swift packages]: https://swiftpackageindex.com/
[open an issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% render "docs/swift-package-manager/how-to-enable-disable.md", site: site %}

## Como adicionar suporte ao Swift Package Manager a um plugin Flutter existente

Este guia mostra como adicionar suporte ao Swift Package Manager a um plugin que
já suporta CocoaPods.
Isso garante que o plugin seja utilizável por todos os projetos Flutter.

Plugins Flutter devem suportar _tanto_ Swift Package Manager quanto CocoaPods até
novo aviso.

A adoção do Swift Package Manager será gradual.
Plugins que não suportam CocoaPods não serão utilizáveis por projetos que ainda não
migraram para Swift Package Manager.
Plugins que não suportam Swift Package Manager podem causar problemas para projetos
que já migraram.


<Tabs key="darwin-plugin-type">
<Tab name="Swift plugin">

{% render "docs/swift-package-manager/migrate-swift-plugin.md", site: site %}

</Tab>
<Tab name="Objective-C plugin">

{% render "docs/swift-package-manager/migrate-objective-c-plugin.md", site: site %}

</Tab>
</Tabs>

## Como atualizar testes unitários no app de exemplo de um plugin

Se seu plugin tem XCTests nativos, você pode precisar atualizá-los para funcionar com
Swift Package Manager se uma das seguintes condições for verdadeira:

* Você está usando uma dependência CocoaPod para o teste.
* Seu plugin está explicitamente configurado como `type: .dynamic` em seu arquivo `Package.swift`.

Para atualizar seus testes unitários:

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

1. Navegue até **Package Dependencies** para o projeto.

   <DashImage image="development/packages-and-plugins/swift-package-manager/package-dependencies.png" caption="The project's package dependencies" />

1. Clique no botão **+** e adicione quaisquer dependências apenas para teste pesquisando por
   elas na barra de pesquisa superior direita.

   <DashImage image="development/packages-and-plugins/swift-package-manager/search-for-ocmock.png" caption="Search for test-only dependencies" />

   :::note
   OCMock usa unsafe build flags e só pode ser usado se direcionado por commit.
   `fe1661a3efed11831a6452f4b1a0c5e6ddc08c3d` é o commit para a versão 3.9.3.
   :::

1. Certifique-se de que a dependência foi adicionada ao Target `RunnerTests`.

   <DashImage image="development/packages-and-plugins/swift-package-manager/choose-package-products-test.png" caption="Ensure the dependency is added to the `RunnerTests` target" />

1. Clique no botão **Add Package**.

1. Se você configurou explicitamente o tipo de biblioteca do seu plugin como `.dynamic` em seu
   arquivo `Package.swift`
   ([não recomendado pela Apple][library type recommendations]),
   você também precisará adicioná-lo como uma dependência ao target `RunnerTests`.

   1. Certifique-se de que **Build Phases** do `RunnerTests` tem uma fase de build **Link Binary With Libraries**:

      <DashImage image="development/packages-and-plugins/swift-package-manager/runner-tests-link-binary-with-libraries.png" caption="The `Link Binary With Libraries` Build Phase in the `RunnerTests` target" />

      Se a fase de build ainda não existir, crie uma.
      Clique no <span class="material-symbols" translate="no">add</span> e
      depois clique em **New Link Binary With Libraries Phase**.

      <DashImage image="development/packages-and-plugins/swift-package-manager/add-runner-tests-link-binary-with-libraries.png" caption="Add `Link Binary With Libraries` Build Phase" />

   1. Navegue até **Package Dependencies** para o projeto.

   1. Clique em <span class="material-symbols" translate="no">add</span>.

   1. No diálogo que se abre, clique no botão **Add Local...**.

   1. Navegue até `plugin_name/plugin_name_ios/ios/plugin_name_ios` e clique
      no botão **Add Package**.

   1. Certifique-se de que foi adicionado ao target `RunnerTests` e clique no
      botão **Add Package**.

1. Certifique-se de que os testes passam **Product > Test**.

[library type recommendations]: https://developer.apple.com/documentation/packagedescription/product/library(name:type:targets:)
