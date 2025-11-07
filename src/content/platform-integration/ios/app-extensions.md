---
ia-translate: true
title: Adicionando extensões de app iOS
description: Aprenda como adicionar extensões de app aos seus apps Flutter
---

Extensões de app iOS permitem que você expanda funcionalidades
fora do seu app. Seu app pode aparecer como um widget na tela inicial,
ou você pode disponibilizar partes do seu app dentro de outros apps.

Para saber mais sobre extensões de app, confira
a [documentação da Apple][Apple's documentation].

:::note
Se você encontrar um erro de build ao construir um
app iOS que inclui uma extensão de app, esteja
ciente de que há um bug aberto. A solução alternativa
envolve alterar a ordem do processo de build.
Para mais informações, confira
[Issue #9690][] e [Issue #135056][].
:::

[Issue #9690]:   {{site.github}}/flutter/website/issues/9690
[Issue #135056]: {{site.github}}/flutter/flutter/issues/135056

O iOS 18 adicionou suporte para personalizar o
Control Center de um dispositivo, incluindo a criação de múltiplas páginas.
Você também pode criar novos controles para o Control Center
usando a API [`ControlCenter`][], para destacar seu app.

[`ControlCenter`]: {{site.apple-dev}}/documentation/widgetkit/controlcenter

## Como adicionar uma extensão de app ao seu app Flutter?

Para adicionar uma extensão de app ao seu app Flutter,
adicione o *target* do ponto de extensão ao seu projeto Xcode.

1. Abra o workspace padrão do Xcode no seu projeto executando
   `open ios/Runner.xcworkspace` em uma janela de terminal a partir do
   diretório do seu projeto Flutter.
1. No Xcode, selecione **File -> New -> Target** na barra de menu.

    <figure>
      <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-new-target.png' alt='Opening the File -> New menu, then selecting Target in Xcode.' height='300'>
      </div>
    </figure>
1. Selecione a extensão de app que você pretende adicionar.
   Esta seleção gera código específico da extensão
   dentro de uma nova pasta no seu projeto.
   Para saber mais sobre o código gerado e os SDKs para cada
   ponto de extensão, confira os recursos na
   [documentação da Apple][Apple's documentation].

Para aprender como adicionar um widget na tela inicial ao seu dispositivo iOS,
confira o codelab
[Adding a Home Screen Widget to your Flutter app][lab].

## Como apps Flutter interagem com Extensões de App?

Apps Flutter interagem com extensões de app usando as mesmas
técnicas que apps UIKit ou SwiftUI.
O app contêiner e a extensão de app não se comunicam diretamente.
O app contêiner pode não estar em execução enquanto o usuário do dispositivo
interage com a extensão.
O app e sua extensão podem ler e escrever em
recursos compartilhados ou usar APIs de nível superior
para se comunicar entre si.

### Usando APIs de nível superior

Algumas extensões têm APIs. Por exemplo,
o framework [Core Spotlight][] indexa seu app,
permitindo que os usuários pesquisem a partir do Spotlight e Safari.
O framework [WidgetKit][] pode acionar uma atualização
do seu widget na tela inicial.

Para simplificar como seu app se comunica com extensões,
plugins Flutter encapsulam essas APIs.
Para encontrar plugins que encapsulam APIs de extensão,
confira [Leveraging Apple's System APIs and Frameworks][leverage]
ou pesquise no [pub.dev][].

### Compartilhando recursos

Para compartilhar recursos entre seu app Flutter
e sua extensão de app, coloque o target do app `Runner`
e o target da extensão no mesmo [App Group][].

:::note
Você deve estar conectado à sua conta Apple Developer.
:::

Para adicionar um target a um App Group:

1. Abra as configurações do target no Xcode.
1. Navegue até a aba **Signing & Capabilities**.
1. Selecione **+ Capability** e depois **App Groups**.
1. Escolha a qual App Group você deseja adicionar o target de
   uma das duas opções:

    {: type="a"}
    1. Selecione um App Group da lista.
    1. Clique em **+** para adicionar um novo App Group.

{% render docs/app-figure.md, image:"development/platform-integration/app-extensions/xcode-app-groups.png", alt:"Selecting an App Group within an Xcode Runner target configuration." %}

Quando dois targets pertencem ao mesmo App Group,
eles podem ler e escrever na mesma fonte.
Escolha uma das seguintes fontes para seus dados.

* **Key/value:** Use o plugin [`shared_preference_app_group`][]
  para ler ou escrever em `UserDefaults` dentro do mesmo App Group.
* **File:** Use o caminho do container do App Group do plugin
  [`path_provider`][] para [ler e escrever arquivos][read and write files].
* **Database:** Use o caminho do container do App Group do plugin
  [`path_provider`][] para criar um banco de dados com o plugin
  [`sqflite`][].

### Atualizações em background

Tarefas em background fornecem um meio de atualizar sua extensão
através de código independentemente do status do seu app.

Para agendar trabalho em background a partir do seu app Flutter,
use o plugin [`workmanager`][].

### Deep linking

Você pode querer direcionar usuários de uma
extensão de app para uma página específica no seu app Flutter.
Para abrir uma rota específica no seu app,
você pode usar [Deep Linking][].

## Criando UIs de extensão de app com Flutter

Algumas extensões de app exibem uma interface de usuário.

Por exemplo, extensões de compartilhamento permitem que os usuários convenientemente
compartilhem conteúdo com outros apps,
como compartilhar uma foto para criar
uma nova postagem em um app de mídia social.

<figure>
  <div class="site-figure-container">
    <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension.png' alt='An example of an entry added to the share menu by a Flutter app' height='300'>
  </div>
</figure>

A partir da versão 3.16, você pode construir
UI Flutter para uma extensão de app,
embora você deva usar um
`Flutter.xcframework` seguro para extensão
e incorporar o
`FlutterViewController` como descrito na
seção seguinte.

:::note
Devido às limitações de memória das extensões de app,
use Flutter para construir uma UI de extensão de app para tipos de extensão
que têm limites de memória maiores que 100MB.
Por exemplo, extensões Share têm um limite de memória de 120MB.

Além disso, Flutter usa memória extra no modo debug.
Portanto, Flutter não suporta completamente a execução
de extensões de app no modo debug em dispositivos físicos
quando usado para construir UI de extensão; ele pode ficar sem memória.
Como alternativa,
use um simulador iOS para testar sua extensão no modo debug.
:::

1. Localize o arquivo `Flutter.xcframework` seguro para extensão,
   em `<path_to_flutter_sdk>/bin/cache/artifacts/engine/ios/extension_safe/Flutter.xcframework`.

    * Para construir nos modos release ou profile,
      encontre o arquivo framework na pasta
      `ios-release` ou `ios-profile`, respectivamente.

1. Arraste e solte o arquivo `Flutter.xcframework` na
   lista de frameworks e bibliotecas da sua extensão de compartilhamento.
   Certifique-se de que a coluna embed diz "Embed & Sign".

   <figure>
     <div class="site-figure-container">
       <img src='/assets/images/docs/development/platform-integration/app-extensions/embed-framework.png' alt='The Flutter.xcframework file being marked as Embed & Sign in Xcode.' height='300'>
     </div>
   </figure>

1. Abra as configurações do projeto do app Flutter no Xcode
   para compartilhar configurações de build.

   {: type="a"}
   1. Navegue até a aba **Info**.
   1. Expanda o grupo **Configurations**.
   1. Expanda as entradas **Debug**, **Profile** e **Release**.
   1. Para cada uma dessas configurações, certifique-se de que o valor no
      menu dropdown **Based on configuration file** para sua
      extensão corresponda ao selecionado para o target do app normal.

    <figure>
      <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-configurations.png' alt='An example Xcode Runner configuration with each property set to: Based on configuration file.' height='300'>
      </div>
    </figure>

1. (Opcional) Substitua quaisquer arquivos storyboard por uma classe de extensão, se necessário.

    {: type="a"}
    1. No arquivo `Info.plist`,
       exclua a propriedade **NSExtensionMainStoryboard**.
    1. Adicione a propriedade **NSExtensionPrincipalClass**.
    1. Defina o valor para esta propriedade como o ponto de entrada da extensão.
       Por exemplo, para extensões de compartilhamento, geralmente é
       `<YourShareExtensionTargetName>.ShareViewController`.
       Se você usar Objective-C para implementar a extensão,
       você deve omitir a porção `<YourShareExtensionTargetName>.`.<br>

    <figure>
      <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension-info.png' alt='Setting the NSExtensionPrincipalClass property in the Info.plist file within Xcode.' height='300'>
      </div>
    </figure>

1. Incorpore o `FlutterViewController` como descrito em
   [Adding a Flutter Screen][]. Por exemplo, você pode exibir uma
   rota específica no seu app Flutter dentro de uma extensão de compartilhamento.

    ```swift
    import UIKit
    import Flutter

    class ShareViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            showFlutter()
        }

        func showFlutter() {
            let flutterViewController = FlutterViewController(project: nil, nibName: nil, bundle: nil)
            addChild(flutterViewController)
            view.addSubview(flutterViewController.view)
            flutterViewController.view.frame = view.bounds
        }
    }
    ```

## Testar extensões

Testar extensões em simuladores e dispositivos físicos
têm procedimentos ligeiramente diferentes.

{% comment %}
The different procedures are necessary due to bugs(which bugs?) in Xcode.
Revisit these docs after future Xcode releases to see if they are fixed.
{% endcomment -%}

### Testar em um simulador

1. Construa e execute o target da aplicação principal.
1. Depois que o app for iniciado no simulador,
   pressione <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd>
   para minimizar o app, o que alterna para a tela inicial.
1. Inicie um app que suporte a extensão de compartilhamento,
   como o app Photos.
1. Selecione uma foto, toque no botão de compartilhamento e depois toque
   no ícone da extensão de compartilhamento do seu app.

### Testar em um dispositivo físico

Você pode usar o procedimento a seguir ou as
instruções de [Testar em simuladores](#test-on-a-simulator)
para testar em dispositivos físicos.

1. Inicie o target da extensão de compartilhamento.
1. Na janela popup que diz "Choose an app to run",
   selecione um app que possa ser usado para testar a extensão de compartilhamento,
   como o app Photos.
1. Selecione uma foto, toque no botão de compartilhamento,
   e depois toque no ícone da extensão de compartilhamento do seu app.

## Tutoriais

Para instruções passo a passo sobre como usar extensões de app
com seu app Flutter iOS, confira o codelab
[Adding a Home Screen Widget to your Flutter app][lab].

[Adding a Flutter Screen]: /add-to-app/ios/add-flutter-screen?tab=vc-uikit-swift-tab#alternatively-create-a-flutterviewcontroller-with-an-implicit-flutterengine
[App Group]: {{site.apple-dev}}/documentation/xcode/configuring-app-groups
[Apple's documentation]: {{site.apple-dev}}/app-extensions/
[Core Spotlight]: {{site.apple-dev}}/documentation/corespotlight
[Deep Linking]:/ui/navigation/deep-linking
[lab]: {{site.codelabs}}/flutter-home-screen-widgets
[leverage]: /platform-integration/ios/apple-frameworks
[`path_provider`]: {{site.pub-pkg}}/path_provider
[pub.dev]: {{site.pub-pkg}}
[read and write files]: /cookbook/persistence/reading-writing-files
[`shared_preference_app_group`]: {{site.pub-pkg}}/shared_preference_app_group
[`sqflite`]: {{site.pub-pkg}}/sqflite
[WidgetKit]: {{site.apple-dev}}/documentation/widgetkit
[`workmanager`]: {{site.pub-pkg}}/workmanager
