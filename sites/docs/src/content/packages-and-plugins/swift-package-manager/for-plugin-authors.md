---
ia-translate: true
title: Swift Package Manager para autores de plugins
description: Como adicionar compatibilidade com Swift Package Manager a plugins iOS e macOS
---

:::note
A partir da versão 3.44, o Flutter usa o [Swift Package Manager][]
para gerenciar dependências nativas iOS e macOS.
O Flutter continua a suportar CocoaPods em modo de manutenção,
porém, o registro do CocoaPods se tornará permanentemente
[somente leitura em 2 de dezembro de 2026][cocoapods].
:::

[cocoapods]: https://blog.cocoapods.org/CocoaPods-Specs-Repo/
[Swift Package Manager]: https://www.swift.org/documentation/package-manager/

Para informações sobre como desativar e ativar o SwiftPM, visite
[Swift Package Manager para desenvolvedores de apps][for-app-devs].

[for-app-devs]: /packages-and-plugins/swift-package-manager/for-app-developers

## Como adicionar suporte ao Swift Package Manager a um plugin Flutter existente {:#how-to-add-swift-package-manager-support-to-an-existing-flutter-plugin}

Este guia mostra como adicionar suporte ao Swift Package Manager a um plugin que
já suporta CocoaPods.
Isso garante que o plugin seja utilizável por todos os projetos Flutter.

Plugins Flutter devem suportar _tanto_ Swift Package Manager quanto CocoaPods até
novo aviso.

A adoção do Swift Package Manager será gradual.
A partir do Flutter 3.44, plugins que não suportam
CocoaPods não são utilizáveis por projetos que ainda não
migraram para Swift Package Manager.
Plugins que não suportam Swift Package Manager
podem causar problemas para projetos que já migraram.
Por favor, migre seus plugins o quanto antes.

<Tabs key="darwin-plugin-type">
<Tab name="Swift plugin">

{% render "docs/swift-package-manager/migrate-swift-plugin.md", site: site %}

</Tab>
<Tab name="Objective-C plugin">

{% render "docs/swift-package-manager/migrate-objective-c-plugin.md", site: site %}

</Tab>
</Tabs>

## (Opcional, mas recomendado) Adicione o plugin como pacote local no app de exemplo {:#optional-but-recommended-add-plugin-as-local-package-in-example-app}

Se seu plugin inclui um exemplo,
é recomendado adicionar o plugin como um pacote local no app de exemplo.
Isso não é obrigatório, mas fornece um melhor suporte do Xcode ao editar
o código-fonte do plugin no app de exemplo.
Visite a [issue #179032](https://github.com/flutter/flutter/issues/179032).

### Adicione o plugin como pacote local {:#add-plugin-as-local-package}

1. Em um terminal, navegue até `my_plugin`.

1. No Xcode, execute o seguinte comando para abrir o workspace do app de exemplo
   (substitua `ios` por `macos` conforme apropriado): 

```bash
open example/ios/Runner.xcworkspace
```

1. Clique com o botão direito em **Flutter** > **Add Files to “Runner”**.

   ![Add Files to Runner](/assets/images/docs/development/packages-and-plugins/swift-package-manager/add-files-to-runner.png)

1. Selecione `my_plugin/ios/my_plugin`
   (ou `macos` ou `darwin`, conforme apropriado).

1. Certifique-se de que “Reference files in place” esteja selecionado
   (deve ser o padrão) e clique em **Finish**.

   ![Select Reference files in place](/assets/images/docs/development/packages-and-plugins/swift-package-manager/reference-files-in-place.png)

Isso adiciona o plugin como um pacote local,
mas ele é referenciado por caminho absoluto,
o que não é desejável para distribuição.
Para mudá-lo para um caminho relativo, use as instruções a seguir.

### Mude para caminho relativo {:#change-to-relative-path}

1. Copie o “Full Path” do plugin no File Inspector.

   ![Copy Full Path](/assets/images/docs/development/packages-and-plugins/swift-package-manager/copy-full-path.png)

1. No terminal:
   `open -a Xcode example/ios/Runner.xcodeproj/project.pbxproj`

1. Encontre o seguinte:
   ```text
   path = [COPIED FULL PATH]; sourceTree = "<absolute>"  
   ```

   Por exemplo:

   ```text
   path = /Users/username/path/to/my_plugin/ios/my_plugin; sourceTree = "<absolute>"
   ```

1. E substitua pelo caminho relativo:

   ```text
   path = ../../ios/my_plugin; sourceTree = "<group>"
   ```
   (Ajuste `ios` para `macos` ou `darwin` conforme necessário).

## Como atualizar testes unitários no app de exemplo de um plugin {:#how-to-update-unit-tests-in-a-plugins-example-app}

Se seu plugin tem XCTests nativos,
você pode precisar atualizá-los para funcionar com
Swift Package Manager se uma das seguintes condições for verdadeira:

* Você está usando uma dependência CocoaPod para o teste.
* Seu plugin está explicitamente configurado como `type: .dynamic` em seu arquivo `Package.swift`.

Para atualizar seus testes unitários:

1. No Xcode, abra seu `example/ios/Runner.xcworkspace`.

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
      Clique no botão <Icon id="add" label="plus/add"></Icon> e
      depois clique em **New Link Binary With Libraries Phase**.

      <DashImage image="development/packages-and-plugins/swift-package-manager/add-runner-tests-link-binary-with-libraries.png" caption="Add `Link Binary With Libraries` Build Phase" />

   1. Navegue até **Package Dependencies** para o projeto.

   1. Clique no botão <Icon id="add" label="plus/add"></Icon>.

   1. No diálogo que se abre, clique no botão **Add Local...**.

   1. Navegue até `plugin_name/plugin_name_ios/ios/plugin_name_ios` e clique
      no botão **Add Package**.

   1. Certifique-se de que foi adicionado ao target `RunnerTests` e clique no
      botão **Add Package**.

1. Certifique-se de que os testes passam **Product > Test**.

[library type recommendations]: {{site.apple-dev}}/documentation/packagedescription/product/library(name:type:targets:)
