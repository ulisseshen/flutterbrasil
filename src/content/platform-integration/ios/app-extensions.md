---
ia-translate: true
title: Adicionando extensões de app iOS
description: Aprenda como adicionar extensões de app aos seus apps Flutter
---

Este guia mostra como usar extensões de app iOS com um
app Flutter.

## Visão geral {: #overview }

[Extensões de app iOS][iOS app extensions] permitem expandir funcionalidades
fora do seu app iOS. Seu app pode aparecer como um widget na tela inicial,
ou você pode disponibilizar partes do seu app dentro de outros apps.

No exemplo a seguir, quando um usuário seleciona uma
foto para compartilhar no app Fotos do iOS, um app Flutter chamado
`Example App With Extension` é exibido na
planilha de compartilhamento do app Fotos:

<figure>
  <div class="site-figure-container">
    <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension.png' alt='Planilha de compartilhamento com um app Flutter.' height='400'>
  </div>
</figure>

[iOS app extensions]: {{site.apple-dev}}/app-extensions/

## Adicione uma extensão de app iOS ao seu app Flutter {: #add-extension }

Se você deseja integrar seu app Flutter com
o sistema operacional iOS, pode adicionar extensões de app iOS
ao seu projeto Flutter. Para um fluxo de trabalho contínuo, os
passos a seguir mostram como adicionar uma extensão de app [Share][Share]
a um novo app Flutter chamado
`example_app_with_extension`, mas você pode sempre começar com
um projeto existente.

1.  No console, crie um novo projeto Flutter chamado
    `example_app_with_extension`.

    ```console
    $ flutter create example_app_with_extension
    ```

1.  No console, abra o workspace do Xcode para o
    projeto `example_app_with_extension`.

    ```console
    $ cd example_app_with_extension && open ios/Runner.xcworkspace
    ```

1.  No Xcode, adicione uma extensão de app chamada `Share`
    e chame-a de `ShareExtension`.

    *   Na barra de menu do Xcode, selecione
        **File** > **New** > **Target**.

    *   Adicione **Share Extension**.

    *   No campo **Name**, digite **ShareExtension**.

    *   Clique em **Finish**.

    *   Na caixa de diálogo **Activate … Scheme** que
        aparece, selecione **Activate**.

1.  No Xcode, altere a ordem do processo de build.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   No **project navigator**, no topo, selecione
        **Runner**.

    *   Na janela principal em **TARGETS**, selecione
        **Runner**.

    *   Abra a aba **Build Phases**.

    *   Arraste **Embed Foundation Extensions** acima de
        **Run Script**.


1.  Certifique-se de que o valor **Minimum Deployments** do iOS está configurado
    corretamente e corresponde em **Runner** e **ShareExtension**

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   No **project navigator**, no topo, selecione
        **Runner**.

    *   Na janela principal em **TARGETS**, selecione
        **Runner**.

    *   Na aba **General**, verifique o valor do menu suspenso **Minimum Deployments**
        para corresponder ao que você tem em
        **ShareExtension** > aba **General**.

1.  No console, execute o seguinte comando para reconstruir seu
    app iOS:

    ```console
    $ flutter build ios --config-only
    ```

1.  [Teste seu app com o simulador][Test your app with the simulator].

Quando você adiciona uma nova extensão de app, o Xcode gera
código de exemplo baseado no template que você selecionou. Para mais
informações sobre o código gerado e WidgetKit, veja
[documentação de extensões de app da Apple][Apple's app extension documentation].

[Apple's app extension documentation]: {{site.apple-dev}}/app-extensions/
[Test your app with the simulator]: #test-extensions
[Share]: https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html

## Teste uma extensão de app iOS {: #test-extensions }

Depois de adicionar uma extensão de app ao seu projeto Flutter,
você pode testá-la, usando um simulador ou dispositivo físico.
Se você está testando sua extensão em modo debug, deve
usar o simulador iOS.

Os passos a seguir assumem que você está usando a aplicação de exemplo
e a extensão Share de
[Adicionando extensões de app iOS][Adding iOS app extensions].

<Tabs key="register-plugins-tabs" wrapped="true">

<Tab name="Simulator">

1.  No Xcode, [adicione uma extensão de app ao seu projeto][add an app extension to your project].

1.  No console, use o seguinte comando para executar seu
    app iOS:

    ```console
    $ flutter run
    ```

1.  No simulador, teste sua extensão de app.

    *   Execute um app que suporta a extensão Share,
        como o app Fotos.

    *   Selecione uma foto, toque no botão de compartilhar e depois toque
        no ícone da extensão de compartilhamento do seu app.

</Tab>

<Tab name="Physical device">

1.  Adicione uma extensão de app ao seu projeto.

1.  No console, execute seu app Flutter em modo release:

    ```console
    $ flutter run --release
    ```

1.  No seu dispositivo, teste sua extensão de app.

    *   Execute um app que suporta a extensão Share,
        como o app Fotos.

    *   Selecione uma foto, toque no botão de compartilhar e depois toque
        no ícone da extensão de compartilhamento do seu app.

</Tab>

</Tabs>

[Adding iOS app extensions]: #add-extension
[add an app extension to your project]: #add-extension

## Formas adicionais de interagir com extensões de app iOS {: #interact-app-extensions }

Apps Flutter interagem com extensões de app iOS usando as mesmas
técnicas que apps UIKit ou SwiftUI.
O app contêiner e a extensão de app não se comunicam diretamente.
O app contêiner pode não estar em execução enquanto o usuário do dispositivo
interage com a extensão.
O app e sua extensão podem ler e escrever em
recursos compartilhados ou usar APIs de nível superior
para se comunicarem entre si.

### Use APIs de nível superior {: #using-higher-level-apis }

Algumas extensões possuem APIs. Por exemplo,
o framework [Core Spotlight][Core Spotlight] indexa seu app,
permitindo que usuários pesquisem no Spotlight e Safari.
O framework [WidgetKit][WidgetKit] pode acionar uma atualização
do seu widget de tela inicial.

Para simplificar como seu app se comunica com extensões,
plugins Flutter encapsulam essas APIs.
Para encontrar plugins que encapsulam APIs de extensão,
confira [Aproveitando APIs e Frameworks do Sistema da Apple][leverage]
ou pesquise em [pub.dev][pub.dev].

[Core Spotlight]: {{site.apple-dev}}/documentation/corespotlight
[leverage]: /platform-integration/ios/apple-frameworks
[pub.dev]: {{site.pub-pkg}}
[WidgetKit]: {{site.apple-dev}}/documentation/widgetkit

### Compartilhe recursos {: #sharing-resources }

Para compartilhar recursos entre seu app Flutter
e sua extensão de app, coloque o target do app `Runner`
e o target da extensão no mesmo [App Group][App Group].

:::note
Você deve estar conectado à sua conta Apple Developer.
:::

Para adicionar um target a um App Group:

1. Abra as configurações do target no Xcode.
1. Navegue até a aba **Signing & Capabilities**.
1. Selecione **+ Capability** e depois **App Groups**.
1. Escolha qual App Group você deseja adicionar o target a partir de
   uma das duas opções:

    {: type="a"}
    1. Selecione um App Group da lista.
    1. Clique em **+** para adicionar um novo App Group.

<DashImage figure image="development/platform-integration/app-extensions/xcode-app-groups.png" alt="Selecionando um App Group dentro de uma configuração de target Runner do Xcode." />

Quando dois targets pertencem ao mesmo App Group,
eles podem ler e escrever na mesma fonte.
Escolha uma das seguintes fontes para seus dados.

* **Chave/valor:** Use o plugin [`shared_preference_app_group`][`shared_preference_app_group`]
  para ler ou escrever em `UserDefaults` dentro do mesmo App Group.
* **Arquivo:** Use o caminho do contêiner do App Group do
  plugin [`path_provider`][`path_provider`] para [ler e escrever arquivos][read and write files].
* **Banco de dados:** Use o caminho do contêiner do App Group do
  plugin [`path_provider`][`path_provider`] para criar um banco de dados com o
  plugin [`sqflite`][`sqflite`].

[App Group]: {{site.apple-dev}}/documentation/xcode/configuring-app-groups
[`path_provider`]: {{site.pub-pkg}}/path_provider
[read and write files]: /cookbook/persistence/reading-writing-files
[`shared_preference_app_group`]: {{site.pub-pkg}}/shared_preference_app_group
[`sqflite`]: {{site.pub-pkg}}/sqflite

### Agende atualizações em segundo plano {: #background-updates }

Tarefas em segundo plano fornecem um meio de atualizar sua extensão
através de código, independentemente do status do seu app.

Para agendar trabalho em segundo plano do seu app Flutter,
use o plugin [`workmanager`][`workmanager`].

[`workmanager`]: {{site.pub-pkg}}/workmanager

### Adicione deep linking {: #deep-linking }

Você pode querer direcionar usuários de uma
extensão de app para uma página específica no seu app Flutter.
Para abrir uma rota específica no seu app,
você pode usar [Deep Linking][Deep Linking].

[Deep Linking]:/ui/navigation/deep-linking

### Adicione uma lista rolável {: #advanced-scrolling-behavior }

Por padrão, a visualização Flutter não lida com gestos de rolagem
em uma extensão [Share][Share]. Para suportar uma lista rolável na
extensão Share, siga [estas instruções][these instructions].

[Share]: https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html
[these instructions]: {{site.github}}/flutter/flutter/issues/164670#issuecomment-2740702986

### Abra um app Flutter em uma extensão de app iOS {: #creating-app-extension-uis-with-flutter }

Você pode abrir seu app Flutter diretamente
em algumas extensões de app iOS, como a
extensão [Share][Share], com um `FlutterViewController`.

No exemplo a seguir, um app Flutter chamado
`Example App With Extension` é aberto na
extensão Share, que permite aos usuários compartilhar conteúdo
entre apps:

<figure>
  <div class="site-figure-container">
    <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension-open-app.gif' alt='Um exemplo de uma entrada adicionada ao menu de compartilhamento por um app Flutter' height='400'>
  </div>
</figure>

Use os passos a seguir para exibir um app Flutter dentro de
uma extensão de app [Share][Share]. Neste exemplo, o esquema da extensão de app
é chamado `ShareExtension`, o esquema do app Flutter é
chamado `Runner`, e o app Flutter é chamado
`Example App With Extension`:

1.  [Adicione uma extensão ao seu app Flutter][Add an extension to your Flutter app] se você ainda não
    tiver feito isso.

1.  No console, navegue até o diretório do seu projeto Flutter
    e depois abra seu projeto no Xcode
    com o seguinte comando:

    ```console
    open ios/Runner.xcworkspace
    ```

1.  No Xcode, desabilite o sandboxing de script do usuário.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Na janela principal em **TARGETS**, selecione
        **ShareExtension**.

    *   Abra a aba **Build Settings**.

    *   Navegue até **Build Options**.

    *   Defina **User Script Sandboxing** como **No**.

1.  No Xcode, adicione a pre-action ao
    esquema `ShareExtension`.

    *   Abra a janela **Manage Schemes**
        (**Product** > **Scheme** > **Manage Schemes**).

    *   Selecione o esquema **ShareExtension** e edite-o.

    *   Expanda a aba **Build**.

    *   Selecione **Pre-actions**.

    *   Clique em **+** e selecione **New Run Script Action**.

    *   Na lista suspensa **Provide build settings from**,
        selecione **ShareExtension**.

    *   No campo de texto **Shell**, digite:

        ```console
        /bin/sh "$FLUTTER_ROOT/packages/flutter_tools/bin/xcode_backend.sh" prepare
        ```

    *   Clique em **Close**.

1.  No Xcode, compartilhe as configurações de build.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Na janela principal em **PROJECT**, selecione
        **Runner**.

    *   Abra a aba **Info**.

    *   Expanda **Configuration**.

    *   Expanda **Debug** e atualize o valor para
        **ShareExtension** para corresponder ao valor de
        **Runner**.

    *   Repita o passo anterior para **Profile** e
        **Release**.

    *   Quando terminar, certifique-se de que as
        configurações pareçam semelhantes ao seguinte:

        ![Configurações do Xcode](/assets/images/docs/development/platform-integration/app-extensions/xcode-configurations.png)


1.  (Opcional) No Xcode, substitua quaisquer arquivos storyboard por
    uma classe de extensão, se necessário.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Selecione **Runner** > **ShareExtension** > **Info**.

    *   Expanda **Information Property List**.

    *   Delete a chave **NSExtensionMainStoryboard**.

    *   Adicione a chave **NSExtensionPrincipalClass**.

    *   Adicione um destes valores para a
        chave `NSExtensionPrincipalClass`:

        *   (Swift) **ShareExtension.ShareViewController**
        *   (Objective-C)  **ShareViewController**

1.  No Xcode, atualize o `ShareViewController` para usar o
    `FlutterViewController`.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Selecione **Runner** > **ShareExtension** > **ShareViewController**.

    *   Atualize `ShareViewController` para usar a
        classe `FlutterViewController`:

<Tabs key="controller-code-tabs" wrapped="true">
<Tab name="UIKit-Swift">

```swift title="ShareViewController.swift"
import UIKit
import Flutter

class ShareViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        showFlutter()
    }

    func showFlutter() {
        let flutterEngine = FlutterEngine(name: "my flutter engine")
        flutterEngine.run()
        let flutterViewController = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        addChild(flutterViewController)
        view.addSubview(flutterViewController.view)
        flutterViewController.view.frame = view.bounds
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.extensionContext?.cancelRequest(
            withError: NSError(domain: Bundle.main.bundleIdentifier!, code: 0))
    }
}
```

</Tab>

<Tab name="UIKit-ObjC">

```objc title="ShareViewController.h"
@import Flutter;
@import UIKit;

@interface ShareViewController : UIViewController

@end
```

```objc title="ShareViewController.m"
#import "ShareViewController.h"
@import Flutter;

@implementation ShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showFlutter];
}

- (void)showFlutter {
    FlutterEngine *flutterEngine = [[FlutterEngine alloc] initWithName:@"my flutter engine"];
    [flutterEngine run];
    FlutterViewController *flutterViewController =
            [[FlutterViewController alloc] initWithEngine:flutterEngine nibName:nil bundle:nil];
    [self addChildViewController:flutterViewController];
    [self.view addSubview:flutterViewController.view];
    flutterViewController.view.frame = self.view.bounds;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.extensionContext cancelRequestWithError:[NSError errorWithDomain:NSBundle.mainBundle.bundleIdentifier code:0 userInfo:nil]];
}
@end
```

</Tab>

</Tabs>

8.  [Teste seu app com o simulador][Test your app with the simulator].

[Add an extension to your Flutter app]: #add-extension
[Share]: https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html
[Test your app with the simulator]: #test-extensions

### Registre plugins

Use os passos a seguir para registrar plugins para
uma extensão de app. Neste exemplo, o esquema da extensão de app
é chamado `ShareExtension`, o esquema do app Flutter é
chamado `Runner`, e o app Flutter é chamado
`Example App With Extension`:

1.  [Adicione uma extensão ao seu app Flutter][Add an extension to your Flutter app] se você ainda não
    tiver feito isso.

1.  No Xcode, adicione `GeneratedPluginRegistrant.m` ao
    target da extensão de app.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Na janela principal em **TARGETS**, selecione
        **ShareExtension**.

    *   Abra a aba **Build Phases**.

    *   Expanda **Compile Sources**.

    *   Clique em **+**.

    *   Da lista na
        caixa de diálogo _Choose item to add_, selecione
        **GeneratedPluginRegistrant.m**.

    *   Clique em **Add**.

1.  (Apenas Swift) No Xcode, atualize a
    configuração de build `SWIFT_OBJC_BRIDGING_HEADER`.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Na janela principal em **TARGETS**, selecione
        **ShareExtension**.

    *   Abra a aba **Build Settings**.

    *   Selecione o filtro **All**.

    *   Navegue até **Swift Compiler - General** e altere
        o valor para a chave **Objective-C Bridging Header**
        para **Runner/Runner-Bridging-Header.h**.

1.  No Xcode, atualize o código de `ShareViewController`
    para registrar `GeneratedPluginRegistrant.h`.

    *   Abra o **project navigator**
        (**View** > **Navigators** > **Project**).

    *   Selecione **Runner** > **ShareExtension** > **ShareViewController**.

    *   Atualize o arquivo `ShareViewController` para usar o
        `GeneratedPluginRegistrant.h`:

<Tabs key="register-plugins-tabs" wrapped="true">

<Tab name="UIKit-Swift">

```swift title="ShareViewController.swift"
// Add this inside `showFlutter()` at the top
GeneratedPluginRegistrant.register(with: flutterEngine)
```

</Tab>

<Tab name="UIKit-ObjC">

```objc title="ShareViewController.m"
// Add this import at the top
#import "GeneratedPluginRegistrant.h"
```

```objc title="ShareViewController.m"
// Add this after [flutterEngine run]
[GeneratedPluginRegistrant registerWithRegistry:flutterEngine];
```

</Tab>

</Tabs>

5.  (Xcode) [Teste seu app com o simulador][Test your app with the simulator].

[Add an extension to your Flutter app]: #add-extension
[Share]: https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/Share.html
[Test your app with the simulator]: #test-extensions

## Restrições {: #constraints }

*   Você deve usar um simulador iOS para testar sua extensão em
    modo debug.

*   O Flutter não suporta totalmente a execução de extensões de app em
    modo debug em dispositivos físicos quando usadas para construir
    UIs de extensão porque um dispositivo físico pode ficar sem
    memória.

*   Extensões de app iOS possuem memória limitada.
    É aconselhável modificar apenas a UI de uma extensão de app
    se a extensão de app suportar pelo menos 100MB de memória.

## Chamar código Dart / renderizar conteúdo Flutter em extensões de app iOS

O pacote [home_widget][home_widget] fornece uma grande quantidade de funcionalidades,
que inclui permitir o seguinte:

* [Responder à entrada do usuário][Respond to user input] em extensões de app
  usando código Dart.

* [Renderizar widgets Flutter][Render Flutter widgets] em uma extensão de app como uma imagem.

* [Salvar e recuperar dados][Save and retrieve data] do `UserDefaults` no iOS.

## Outros recursos {: #other-resources }

Para instruções passo a passo sobre como usar extensões de app
com seu app Flutter iOS, confira o
codelab [Adicionando um Widget de Tela Inicial ao seu app Flutter][lab].

Para saber mais sobre as várias formas de adicionar uma
tela Flutter a um app iOS, veja
[Adicionando uma tela Flutter a um app iOS][Adding a Flutter Screen to an iOS app].

[Adding a Flutter Screen to an iOS app]: /add-to-app/ios/add-flutter-screen
[lab]: {{site.codelabs}}/flutter-home-screen-widgets
[home_widget]: https://pub.dev/packages/home_widget
[Save and retrieve data]: https://docs.page/abausg/home_widget/usage/sync-data
[Render Flutter widgets]: https://docs.page/abausg/home_widget/features/render-flutter-widgets
[Respond to user input]: https://docs.page/abausg/home_widget/features/interactive-widgets
