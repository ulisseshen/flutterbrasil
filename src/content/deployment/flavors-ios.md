---
ia-translate: true
title: Configurar flavors Flutter para iOS e macOS
shortTitle: Flavors (iOS e macOS)
description: >
  Como criar flavors Flutter para um app iOS ou macOS.
---

Este guia mostra como criar flavors Flutter para um
app iOS ou macOS.

## Visão geral

Um flavor Flutter é basicamente uma coleção de configurações que
definem como uma versão específica do seu app deve ser compilada
e executada. Por exemplo, um flavor pode determinar qual ícone,
nome do app, chave de API, feature flag e nível de logging está
associado a uma versão específica do seu app.

Se você quiser criar flavors Flutter para um app iOS, você
precisará fazer isso no Xcode. O Xcode não tem um conceito chamado
"flavor". Em vez disso, você precisará configurar algo chamado
scheme e anexar configurações personalizadas a ele.

O seguinte ilustra um exemplo de dois flavors Flutter
(staging, production) como schemes do Xcode com configurações personalizadas
do Xcode atribuídas a eles:

<table class="table table-striped">
  <thead>
    <tr>
      <th>Scheme</th>
      <th>Configurações para o scheme</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>staging</td>
      <td>
        Debug-staging</br>
        Profile-staging</br>
        Release-staging</br>
      </td>
    </tr>
    <tr>
      <td>production</td>
      <td>
        Debug-production</br>
        Profile-production</br>
        Release-production</br>
      </td>
    </tr>
  </tbody>
</table>

## Configurar schemes do Xcode

Os seguintes passos mostram como configurar dois schemes do Xcode
chamados `staging` e `production` para seu projeto Flutter iOS.
Você também pode usar esses passos para configurar um
projeto macOS substituindo qualquer referência a `iOS`
por `macOS`.

Para um fluxo de trabalho perfeito, começamos com um
novo projeto Flutter chamado `flavors_example`, mas você pode
sempre começar com um projeto existente.

1.  Crie um novo projeto Flutter chamado `flavors_example`.

    ```console title="console"
    $ flutter create flavors_example
    ```

1.  Abra o workspace padrão do Xcode para a versão iOS do
    projeto `flavors_example`.

    ```console title="console"
    $ cd flavors_example && open ios/Runner.xcworkspace
    ```

1.  Abra o projeto `flavors_example` no
    navegador de projetos do Xcode:

    * Abra o **project navigator**
      (**View** > **Navigators** > **Project**).

    * No **project navigator**, no topo, selecione
      **Runner**.

1.  Crie schemes no Xcode:

    * Abra a janela **New Scheme**
      (**Product > Scheme > New Scheme**).

    * No campo **Target**, selecione **Runner**.

    * Na caixa **Name**, digite `staging`.

    * Clique em **Okay** para adicionar o novo scheme.

    * Repita os passos anteriores para um scheme chamado
      `production`.

    * Quando terminar, verifique para ter certeza de que você
      tem os seguintes schemes:

      ![Schemes for Flutter flavors](/assets/images/docs/flavors/flavors-ios-schemes.png){:width="100%"}

    :::note
    Por padrão, os novos schemes são compartilhados. Os schemes devem
    ser compartilhados para que os flavors Flutter funcionem corretamente. Para
    verificar novamente se o compartilhamento está ativado, abra a
    janela **Manage Schemes**
    (**Product > Scheme > Manage Schemes**) e certifique-se
    de que a caixa de seleção **Shared** à direita do seu novo
    scheme esteja marcada.
    :::

1.  Crie configurações para os schemes no Xcode:

    * No **project navigator**, selecione **Runner**.

    * Na janela principal em **PROJECT**, selecione
      **Runner**.

    * Abra a aba **Info** se ela não estiver aberta.

    * Vá para a seção **Configurations** e adicione novas
      configurações `Debug`.

      * Clique em **+**, selecione
        **Duplicate "Debug" configuration**, e nomeie a
        nova configuração como `Debug-staging`.
      * Clique em **+**, selecione
        **Duplicate "Debug" configuration**, e nomeie a
        nova configuração como `Debug-production`.

    * Repita o passo anterior para as
      configurações `Release` e as
      configurações `Profile`.

    * Quando terminar, verifique para ter certeza de que você
      tem as seguintes configurações:

      ![Scheme configurations for Flutter flavors](/assets/images/docs/flavors/flavors-ios-scheme-configurations.png){:width="100%"}

    :::note
    O nome do scheme (exemplo: `staging`) que é anexado a
    um nome de configuração deve estar em minúsculas se você quiser
    usá-lo com o comando Flutter CLI.
    :::

    :::note
    Suas configurações devem ser baseadas nos seus
    arquivos `Debug.xconfig`, `Profile.xcconfig`, e
    `Release.xcconfig`, não no
    arquivo `Pods-Runner.xcconfigs`. Você pode verificar isso
    expandindo os nomes de configuração no Xcode.
    :::

1.  Atribua as configurações aos schemes no Xcode:

    * Abra a janela **Manage Schemes**
      (**Product > Scheme > Manage Schemes**).

    * Selecione o scheme `staging` e edite-o.

    * Nas seguintes abas, atualize o
      campo **Build Configuration** da seguinte forma:

      * **Run**: `Debug-staging`
      * **Test**: `Debug-staging`
      * **Profile**: `Profile-staging`
      * **Analyze**: `Debug-staging`
      * **Archive**: `Release-staging`

    * Clique em **Close**.

    * Repita os passos anteriores para o scheme `production`.

1.  Se você está trabalhando com um projeto Flutter pré-existente
    que tem pelo menos um Podfile, atualize-o. Para mais
    informações, veja [Update Podfiles][].

1.  Para ter certeza de que você configurou tudo corretamente,
    execute seu app nos novos schemes no Xcode. Você não verá
    diferenças porque as configurações
    não mudaram, mas você quer ter certeza de que o
    app pode executar.

    * Selecione o scheme `staging`
      (**Product > Schemes > staging**).

    * À direita de `staging` na barra de ferramentas,
      selecione o dispositivo iOS que você quer testar. No
      exemplo a seguir, o dispositivo é `iPhone 16 Pro`.

      ![Run a Flutter flavor](/assets/images/docs/flavors/flavors-ios-test-scheme.png){:width="100%"}

    * Execute o scheme do app (**Product > Run**).

    * Repita os passos anteriores para o scheme `production`.

1.  Se tudo executar, você está pronto para personalizar suas
    configurações. Para mais informações, veja
    [Customize configurations][].

[Update Podfiles]: #update-podfiles
[Customize configurations]: #customize-configurations

## Iniciar um scheme do Xcode {:#launch-an-xcode-scheme}

Depois de criar os schemes para um app iOS no
Xcode, você pode iniciar um scheme específico através do Xcode ou
Flutter. Você também pode usar esses passos para iniciar um projeto
macOS substituindo qualquer referência a `iOS` por `macOS`.

### Use a flag flavor (Flutter CLI)

Você pode iniciar um scheme do Xcode no modo `Debug` com o
Flutter CLI usando os seguintes passos:

1.  No seu IDE, inicie o simulador iOS.

1.  No console, navegue até o
    diretório `flavors_example` e digite o seguinte
    comando:

    ```console title="console"
    $ flutter run --flavor <xcode_scheme_name>
    ```

    * `<xcode_scheme_name>`: Substitua isso pelo nome do
      seu scheme do Xcode (por exemplo, `staging` ou
      `production`).

    Exemplo:

    ```console title="console"
    $ flutter run --flavor staging
    ```

### Use o comando run (Xcode)

Você pode iniciar um scheme específico no Xcode usando os
seguintes passos:

1.  Selecione o scheme que você quer testar
    (**Product > Schemes > Choose scheme**).

1.  Ao lado do nome do scheme na barra de ferramentas, selecione o
    dispositivo que você quer testar.

1.  Execute o scheme para seu app
    (**Product > Run**).

## Personalizar configurações {:#customize-configurations}

Depois de adicionar schemes do Xcode, você pode personalizá-los para
seu app iOS. Você também pode usar esses passos para configurar um
projeto macOS substituindo qualquer referência a `iOS` por
`macOS`.

### Criar nomes de exibição de app distintos {: #create_a_distinct_app_display_name }

Se você tem múltiplos schemes, um nome de app distinto pode
identificar rapidamente qual scheme seu app implantado está usando.

<img src="/assets/images/docs/flavors/flavors-ios-app-names.png" alt="Rename a Flutter flavor" width="50%">

Os seguintes passos mostram como adicionar nomes de exibição de app distintos
no Xcode para dois schemes chamados `staging` e
`production` em um projeto chamado `flavors_example`.

1.  Crie configurações definidas pelo usuário no Xcode:

    * Abra o **project navigator**
      (**View > Navigators > Project**).

    * No **project navigator**, no topo, selecione
      **Runner**.

    * Na janela principal em **TARGETS**, selecione
      **Runner**.

    * Abra a aba **Build Settings**.

    * À esquerda da aba Basic, clique em **+** e selecione
      **Add User-Defined Setting**.

    * Crie uma configuração chamada `APP_DISPLAY_NAME`.

    * Expanda a configuração **APP_DISPLAY_NAME**.

    * Atribua os seguintes valores às seguintes chaves:

      * **Debug-production**: `Flavors prod`
      * **Debug-staging**: `Flavors staging`
      * **Profile-production**: `Flavors prod`
      * **Profile-staging**: `Flavors staging`
      * **Release-production**: `Flavors prod`
      * **Release-staging**: `Flavors staging`

1.  Atualize `Info.plist` no Xcode:

    * No navegador de projetos, selecione
      **Runner > Runner > Info** para abrir
      `flavor_test/ios/Runner/Info.plist`.

    * Em **Information Property List**, encontre a
      seguinte chave e atualize o valor para ela:

      * **Key**: `CFBundleDisplayName`
      * **Value**: `$(APP_DISPLAY_NAME)`

1.  Inicie o app para cada scheme (`staging`, `production`)
    e verifique para ter certeza de que o nome de exibição do app mudou
    para cada um. Para iniciar um scheme, veja os passos em
    [Launch an Xcode scheme][].

[Launch an Xcode scheme]: #launch-an-xcode-scheme

### Criar ícones distintos

Se você tem múltiplos schemes, um ícone distinto para cada
configuração pode ajudá-lo a identificar rapidamente qual scheme
seu app implantado está usando.

<img src="/assets/images/docs/flavors/flavors-ios-icons.png" alt="Rename a Flutter flavor" width="50%">

Os seguintes passos mostram como adicionar um ícone distinto no
Xcode para dois schemes chamados `staging` e `production` em
um projeto iOS chamado `flavors_example`.

1.  Prepare seus ícones:

    * Projete seu ícone de staging e ícone de production na
      ferramenta de design de sua escolha.

    * Gere versões do ícone de staging e ícone de production
      nos tamanhos que você precisa. Salve-os em
      formato PNG.

      :::note
      Você pode usar uma ferramenta como [App Icon Generator][]
      para gerar as versões de seus ícones.
      :::

1.  Adicione os ícones ao seu projeto Xcode:

    * Abra o **project navigator**
      (**View > Navigators > Project**).

    * No **project navigator**, selecione
      **Runner > Runner > Assets** para abrir a
      janela **Assets**.

    * Complete os seguintes passos para o ícone de staging:

      * Clique em **+  > iOS > iOS App icon**.

      * Nomeie o ícone como `AppIcon-staging`.

      * Arraste seus ícones de staging para a
        janela **AppIcon-staging** e certifique-se de que os ícones
        estão atribuídos aos tamanhos corretos.

    * Repita o passo anterior para o ícone de production.

1.  Conecte os ícones aos seus schemes:

    * Abra o **project navigator**.

    * Na janela principal em **TARGETS**, selecione
      **Runner**.

    * Abra a aba **General** se ela ainda não estiver aberta.

    * Vá para a seção **Apps Icons and Launch Screen** e
      expanda-a.

    * À direita do campo **App icon**, clique em
      **+** e atualize os campos da seguinte forma:

      * **Debug-staging**: `AppIcon-staging`
      * **Profile-staging**: `AppIcon-staging`
      * **Release-staging**: `AppIcon-staging`
      * **Debug-production**: `AppIcon-production`
      * **Profile-production**: `AppIcon-production`
      * **Release-production**: `AppIcon-production`

1.  Inicie o app para cada scheme (`staging`, `production`)
    e verifique para ter certeza de que o ícone do app mudou
    para cada um. Para iniciar um scheme, veja os passos em
    [Launch an Xcode scheme][].

[Launch an Xcode scheme]: #launch-an-xcode-scheme
[App Icon Generator]: https://www.appicon.co/

### Adicionar identificadores de bundle distintos

Um identificador de bundle é um identificador único para sua
aplicação nas plataformas Apple. Se você está usando múltiplos
schemes do Xcode como flavors Flutter, você pode fazer com que a Apple trate
cada scheme como uma aplicação separada. Para fazer isso, você precisa
atribuir um identificador de bundle diferente a cada scheme.
Isso permite que você teste novos recursos ou correções de bugs em uma
versão do app (por exemplo `staging`) sem afetar
outra versão do app (por exemplo, `production`).

Os seguintes passos mostram como definir um identificador de
bundle único para dois schemes do Xcode chamados `staging`
e `production` em um projeto iOS chamado `flavors_example`.

1.  No Xcode, abra o **project navigator**
    (**View > Navigators > Project**).

1.  Na janela principal em **TARGETS**, selecione
    **Runner**.

1.  Abra a aba **Build Settings**.

1.  Navegue até a seção **Packaging**.

1.  Expanda a configuração **Product Bundle Identifier** para
    ver as diferentes configurações de build.

1.  Para a configuração de build de cada scheme, defina o
    identificador de bundle desejado. Por exemplo:

    *   Debug-staging, Profile-staging, Release-staging:

        `com.example.flavorsExample.staging`

    *   Debug, Profile, Release, Debug-production,
        Profile-production, Release-production:

        `com.example.flavorsExample`

1.  Garanta que esses identificadores de bundle estão incluídos no
    seu App ID e que seu App ID está [registrado na sua conta Apple Developer][registered in your Apple Developer account].

[registered in your Apple Developer account]: https://developer.apple.com/help/account/identifiers/register-an-app-id/

### Bundle de assets

Se você tem assets que são usados apenas em um flavor específico
no seu app, você pode configurá-los para serem incluídos no bundle
apenas quando iniciar esse flavor. Isso evita que o
tamanho do bundle do seu app seja inflado por assets não utilizados. Para
incluir assets no bundle para cada flavor, adicione o subcampo `flavors`
ao campo `assets` no pubspec do seu projeto. Para saber
mais, veja o [campo `assets`][`assets` field] em
[opções pubspec do Flutter][Flutter pubspec options].

[`assets` field]: /tools/pubspec#assets
[Flutter pubspec options]: /tools/pubspec

### Atualizar Podfiles {:#update-podfiles}

Se você está criando novos schemes do Xcode para um projeto Flutter iOS
e você tem um Podfile iOS em um projeto
Flutter existente, você deve atualizar o Podfile iOS do Flutter para
corresponder às mudanças que você fez no Xcode.

Os seguintes passos mostram como atualizar seu Podfile iOS para
incluir dois novos schemes do Xcode chamados `staging` e
`production` em um projeto Flutter chamado `flavors_example`.
Você também pode usar esses passos para atualizar um projeto
macOS substituindo qualquer referência a `iOS` por `macOS`.

1. No seu IDE, abra o arquivo `ios/Podfile`.
1. Faça as seguintes atualizações e salve suas mudanças.

    ```ruby title="flavors_example/ios/Podfile"
    project 'Runner', {
      ...
      'Debug' => :debug,
      'Debug-staging' => :debug,
      'Debug-production' => :debug,
      'Profile' => :release,
      'Profile-staging' => :release,
      'Profile-production' => :release,
      'Release' => :release,
      'Release-staging' => :release,
      'Release-production' => :release,
      ...
    ```

### Adicionar configurações de build únicas

Você pode usar [configurações de build][build settings] para governar seu processo de build iOS
desde compilação e vinculação até depuração e
distribuição. Uma maneira de usar configurações de build
com flavors Flutter é atribuir essas configurações de build
a configurações de build do Xcode. Por exemplo, você pode querer
atribuir URLs de API diferentes para `Debug-staging` e
`Debug-production`. Por exemplo:

```plaintext title="debug-staging-settings.xcconfig"
# Debug-staging build settings
API_BASE_URL = staging.flavors.com/api
```

```plaintext title="debug-production-settings.xcconfig"
# Debug-production build settings
API_BASE_URL = flavors.com/api
```

Se você deseja adicionar configurações de build adicionais para
uma configuração de build específica, veja o documento da Apple
[Adding a build configuration file to your project][].

[build settings]: https://developer.apple.com/documentation/xcode/build-settings-reference/
[Adding a build configuration file to your project]: https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project

### Adicionar personalizações adicionais

Este documento contém algumas configurações de scheme do Xcode
comuns, mas há muitas mais que você pode aplicar.
Para saber mais sobre elas, veja
[Customizing the build schemes for a project][].

[Customizing the build schemes for a project]: https://developer.apple.com/documentation/xcode/customizing-the-build-schemes-for-a-project

## Mais informações

Para mais informações sobre como criar e usar flavors, confira
os seguintes recursos:

* [How to Setup Flutter & Firebase with Multiple Flavors
  using the FlutterFire CLI][flutterfireCLI]
* [Build flavors in Flutter (Android and iOS) with different
  Firebase projects per flavor Flutter Ready to Go][flavors-firebase]

[flutterfireCLI]: https://codewithandrea.com/articles/flutter-firebase-multiple-flavors-flutterfire-cli/
[flavors-firebase]: {{site.medium}}/@animeshjain/build-flavors-in-flutter-android-and-ios-with-different-firebase-projects-per-flavor-27c5c5dac10b
