---
ia-translate: true
title: Swift Package Manager para autores de plugin
description: Como adicionar compatibilidade com o Swift Package Manager a plugins iOS e macOS
---

:::warning
O Flutter está migrando para o [Swift Package Manager][] para gerenciar dependências nativas iOS e macOS. O suporte do Flutter ao Swift Package Manager está em desenvolvimento. Se você encontrar um bug no suporte do Swift Package Manager do Flutter, [abra um issue][]. O suporte ao Swift Package Manager está [desativado por padrão][]. O Flutter continua a suportar o CocoaPods.
:::

A integração do Swift Package Manager no Flutter oferece vários benefícios:

1.  **Fornece acesso ao ecossistema de pacotes Swift**.
    Plugins Flutter podem usar o crescente ecossistema de [pacotes Swift][]!
2.  **Simplifica a instalação do Flutter**.
    O Swift Package Manager já vem com o Xcode. No futuro, você não precisará instalar Ruby e CocoaPods para direcionar iOS ou macOS.

[Swift Package Manager]: https://www.swift.org/documentation/package-manager/
[desativado por padrão]: #como-ativar-o-swift-package-manager
[pacotes Swift]: https://swiftpackageindex.com/
[abra um issue]: {{site.github}}/flutter/flutter/issues/new?template=2_bug.yml

{% include docs/swift-package-manager/how-to-enable-disable.md %}

## Como adicionar suporte ao Swift Package Manager a um plugin Flutter existente

Este guia mostra como adicionar suporte ao Swift Package Manager a um plugin que já suporta CocoaPods. Isso garante que o plugin possa ser usado por todos os projetos Flutter.

Plugins Flutter devem suportar _tanto_ Swift Package Manager quanto CocoaPods até novo aviso.

A adoção do Swift Package Manager será gradual. Plugins que não suportam CocoaPods não poderão ser usados por projetos que ainda não migraram para o Swift Package Manager. Plugins que não suportam o Swift Package Manager podem causar problemas para projetos que já migraram.

{% tabs %}
{% tab "Plugin Swift" %}

{% include docs/swift-package-manager/migrate-swift-plugin.md %}

{% endtab %}
{% tab "Plugin Objective-C" %}

{% include docs/swift-package-manager/migrate-objective-c-plugin.md %}

{% endtab %}
{% endtabs %}

## Como atualizar testes de unidade no app de exemplo de um plugin

Se o seu plugin tiver XCTests nativos, pode ser necessário atualizá-los para funcionar com o Swift Package Manager se uma das seguintes condições for verdadeira:

* Você está usando uma dependência CocoaPod para o teste.
* Seu plugin está explicitamente definido como `type: .dynamic` em seu arquivo `Package.swift`.

Para atualizar seus testes de unidade:

1. Abra seu `example/ios/Runner.xcworkspace` no Xcode.

2. Se você estivesse usando uma dependência CocoaPod para testes, como `OCMock`, você vai querer removê-la do seu arquivo `Podfile`.

   ```ruby title="ios/Podfile" diff
     target 'RunnerTests' do
       inherit! :search_paths
   
   -   pod 'OCMock', '3.5'
     end
   ```

   Em seguida, no terminal, execute `pod install` no diretório `plugin_name_ios/example/ios`.

3. Navegue até **Package Dependencies** (Dependências do Pacote) para o projeto.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/package-dependencies.png",
   caption:"As dependências do pacote do projeto" %}

4. Clique no botão **+** e adicione quaisquer dependências somente de teste, pesquisando-as na barra de pesquisa no canto superior direito.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/search-for-ocmock.png",
   caption:"Pesquise dependências somente de teste" %}

   :::note
   OCMock usa flags de build inseguras e só pode ser usado se for direcionado por commit. `fe1661a3efed11831a6452f4b1a0c5e6ddc08c3d` é o commit para a versão 3.9.3.
   :::

5. Garanta que a dependência seja adicionada ao Target `RunnerTests`.

   {% render docs/captioned-image.liquid,
   image:"development/packages-and-plugins/swift-package-manager/choose-package-products-test.png",
   caption:"Garanta que a dependência seja adicionada ao target `RunnerTests`" %}

6. Clique no botão **Add Package** (Adicionar Pacote).

7. Se você definiu explicitamente o tipo de biblioteca do seu plugin como `.dynamic` em seu arquivo `Package.swift` ([não recomendado pela Apple][library type recommendations]), você também precisará adicioná-lo como uma dependência ao target `RunnerTests`.

   1. Garanta que o `RunnerTests` **Build Phases** (Fases de Build) tenha uma fase de build **Link Binary With Libraries** (Ligar Binário com Bibliotecas):

      {% render docs/captioned-image.liquid,
      image:"development/packages-and-plugins/swift-package-manager/runner-tests-link-binary-with-libraries.png",
      caption:"A Fase de Build `Link Binary With Libraries` no target `RunnerTests`" %}

      Se a fase de build ainda não existir, crie uma. Clique em <span class="material-symbols">add</span> e, em seguida, clique em **New Link Binary With Libraries Phase** (Nova Fase de Link Binário com Bibliotecas).

      {% render docs/captioned-image.liquid,
      image:"development/packages-and-plugins/swift-package-manager/add-runner-tests-link-binary-with-libraries.png",
      caption:"Adicionar Fase de Build `Link Binary With Libraries`" %}

   2. Navegue até **Package Dependencies** (Dependências do Pacote) para o projeto.

   3. Clique em <span class="material-symbols">add</span>.

   4. Na caixa de diálogo que se abre, clique no botão **Add Local...** (Adicionar Local...).

   5. Navegue até `plugin_name/plugin_name_ios/ios/plugin_name_ios` e clique no botão **Add Package** (Adicionar Pacote).

   6. Garanta que ele seja adicionado ao target `RunnerTests` e clique no botão **Add Package** (Adicionar Pacote).

8. Garanta que os testes passem **Product > Test**.

[library type recommendations]: https://developer.apple.com/documentation/packagedescription/product/library(name:type:targets:)
