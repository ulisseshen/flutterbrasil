---
ia-translate: true
title: Adicionando extensões de aplicativos iOS
description: Aprenda como adicionar extensões de aplicativos aos seus aplicativos Flutter
---

Extensões de aplicativos iOS permitem que você expanda a funcionalidade
fora do seu aplicativo. Seu aplicativo pode aparecer como um widget na tela inicial,
ou você pode tornar partes do seu aplicativo disponíveis em outros aplicativos.

Para saber mais sobre extensões de aplicativos, confira a
[documentação da Apple][].

:::note
Se você encontrar um erro de build ao compilar um
aplicativo iOS que inclua uma extensão de aplicativo, esteja
ciente de que há um bug em aberto. A solução alternativa
envolve alterar a ordem do processo de build.
Para obter mais informações, confira
[Issue #9690][] e [Issue #135056][].
:::

[Issue #9690]:   {{site.github}}/flutter/website/issues/9690
[Issue #135056]: {{site.github}}/flutter/flutter/issues/135056

O iOS 18 adicionou suporte para personalizar o
Centro de Controle de um dispositivo, incluindo a criação de várias páginas.
Você também pode criar novos botões de alternância para o Centro de Controle
usando a API [`ControlCenter`][], para destacar seu aplicativo.

[`ControlCenter`]: {{site.apple-dev}}/documentation/widgetkit/controlcenter

## Como você adiciona uma extensão de aplicativo ao seu aplicativo Flutter?

Para adicionar uma extensão de aplicativo ao seu aplicativo Flutter,
adicione o *target* do ponto de extensão ao seu projeto Xcode.

1. Abra o workspace padrão do Xcode no seu projeto executando
   `open ios/Runner.xcworkspace` em uma janela de terminal do seu
   diretório de projeto Flutter.
2. No Xcode, selecione **File -> New -> Target** na barra de menu.

    <figure>
      <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-new-target.png' alt='Abrindo o menu File -> New, em seguida, selecionando Target no Xcode.' height='300'>
      </div>
    </figure>
3. Selecione a extensão de aplicativo que você pretende adicionar.
   Essa seleção gera código específico da extensão
   dentro de uma nova pasta no seu projeto.
   Para saber mais sobre o código gerado e os SDKs para cada
   ponto de extensão, confira os recursos na
   [documentação da Apple][].

Para aprender como adicionar um widget da tela inicial ao seu dispositivo iOS,
confira o
[Adicionando um Widget da Tela Inicial ao seu aplicativo Flutter][lab]
codelab.

## Como os aplicativos Flutter interagem com as Extensões de Aplicativos?

Os aplicativos Flutter interagem com as extensões de aplicativos usando as mesmas
técnicas que os aplicativos UIKit ou SwiftUI.
O aplicativo contêiner e a extensão de aplicativo não se comunicam diretamente.
O aplicativo contêiner pode não estar em execução enquanto o usuário do dispositivo
interage com a extensão.
O aplicativo e sua extensão podem ler e gravar em
recursos compartilhados ou usar APIs de nível superior
para se comunicar uns com os outros.

### Usando APIs de nível superior

Algumas extensões têm APIs. Por exemplo,
o framework [Core Spotlight][] indexa seu aplicativo,
permitindo que os usuários pesquisem no Spotlight e no Safari.
O framework [WidgetKit][] pode acionar uma atualização
do seu widget da tela inicial.

Para simplificar a forma como seu aplicativo se comunica com as extensões,
os plugins Flutter encapsulam essas APIs.
Para encontrar plugins que encapsulam APIs de extensão,
confira [Aproveitando as APIs e Frameworks do Sistema da Apple][leverage]
ou pesquise no [pub.dev][].

### Compartilhando recursos

Para compartilhar recursos entre seu aplicativo Flutter
e sua extensão de aplicativo, coloque o *target* do aplicativo `Runner`
e o *target* da extensão no mesmo [App Group][].

:::note
Você deve estar logado em sua conta de Desenvolvedor Apple.
:::

Para adicionar um *target* a um App Group:

1. Abra as configurações do *target* no Xcode.
2. Navegue até a guia **Signing & Capabilities**.
3. Selecione **+ Capability** e depois **App Groups**.
4. Escolha qual App Group você deseja adicionar o *target*
   de uma das duas opções:

    {: type="a"}
    1. Selecione um App Group na lista.
    2. Clique em **+** para adicionar um novo App Group.

{% render docs/app-figure.md, image:"development/platform-integration/app-extensions/xcode-app-groups.png", alt:"Selecionando um App Group dentro de uma configuração de target do Xcode Runner." %}

Quando dois *targets* pertencem ao mesmo App Group,
eles podem ler e gravar na mesma fonte.
Escolha uma das seguintes fontes para seus dados.

* **Chave/valor:** Use o plugin [`shared_preference_app_group`][]
  para ler ou gravar em `UserDefaults` dentro do mesmo App Group.
* **Arquivo:** Use o caminho do contêiner do App Group do
  plugin [`path_provider`][] para [ler e gravar arquivos][].
* **Banco de dados:** Use o caminho do contêiner do App Group do
  plugin [`path_provider`][] para criar um banco de dados com o
  plugin [`sqflite`][].

### Atualizações em segundo plano

As tarefas em segundo plano fornecem um meio de atualizar sua extensão
por meio de código, independentemente do status do seu aplicativo.

Para agendar o trabalho em segundo plano a partir do seu aplicativo Flutter,
use o plugin [`workmanager`][].

### Deep linking

Você pode querer direcionar os usuários de uma
extensão de aplicativo para uma página específica em seu aplicativo Flutter.
Para abrir uma rota específica em seu aplicativo,
você pode usar [Deep Linking][].

## Criando interfaces de usuário de extensões de aplicativos com Flutter

Algumas extensões de aplicativos exibem uma interface de usuário.

Por exemplo, as extensões de compartilhamento permitem que os usuários
compartilhem conteúdo convenientemente com outros aplicativos,
como compartilhar uma imagem para criar
uma nova postagem em um aplicativo de mídia social.

<figure>
  <div class="site-figure-container">
    <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension.png' alt='Um exemplo de uma entrada adicionada ao menu de compartilhamento por um aplicativo Flutter' height='300'>
  </div>
</figure>

A partir da versão 3.16, você pode criar
UI Flutter para uma extensão de aplicativo,
embora você deva usar um
`Flutter.xcframework` seguro para extensão e incorporar o
`FlutterViewController`, conforme descrito na
seção a seguir.

:::note
Devido às limitações de memória das extensões de aplicativos,
use o Flutter para criar uma UI de extensão de aplicativo para tipos de extensão
que tenham limites de memória maiores que 100 MB.
Por exemplo, as extensões de compartilhamento têm um limite de memória de 120 MB.

Além disso, o Flutter usa memória extra no modo debug.
Portanto, o Flutter não oferece suporte total à execução de
extensões de aplicativos no modo debug em dispositivos físicos
quando usado para construir UI de extensão; pode ficar sem memória.
Como alternativa,
use um simulador iOS para testar sua extensão no modo debug.
:::

1. Localize o arquivo `Flutter.xcframework` seguro para extensão,
   em `<path_to_flutter_sdk>/bin/cache/artifacts/engine/ios/extension_safe/Flutter.xcframework`.

    * Para compilar para modos release ou profile,
      encontre o arquivo de framework na pasta
      `ios-release` ou `ios-profile`, respectivamente.

2. Arraste e solte o arquivo `Flutter.xcframework` para a lista de
   frameworks e bibliotecas da sua extensão de compartilhamento.
   Certifique-se de que a coluna de incorporação diga "Embed & Sign".

   <figure>
     <div class="site-figure-container">
       <img src='/assets/images/docs/development/platform-integration/app-extensions/embed-framework.png' alt='O arquivo Flutter.xcframework sendo marcado como Embed & Sign no Xcode.' height='300'>
     </div>
   </figure>

3. Abra as configurações do projeto do aplicativo Flutter no Xcode
   para compartilhar configurações de build.

   {: type="a"}
   1. Navegue até a aba **Info**.
   2. Expanda o grupo **Configurations**.
   3. Expanda as entradas **Debug**, **Profile** e **Release**.
   4. Para cada uma dessas configurações, certifique-se de que o valor no
      menu suspenso **Based on configuration file** para sua
      extensão corresponda ao selecionado para o target normal do aplicativo.

    <figure>
      <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/xcode-configurations.png' alt='Um exemplo de configuração Xcode Runner com cada propriedade definida como: Based on configuration file.' height='300'>
      </div>
    </figure>

4. (Opcional) Substitua quaisquer arquivos de storyboard por uma classe de extensão, se necessário.

    {: type="a"}
    1. No arquivo `Info.plist`,
       exclua a propriedade **NSExtensionMainStoryboard**.
    2. Adicione a propriedade **NSExtensionPrincipalClass**.
    3. Defina o valor desta propriedade como o ponto de entrada da extensão.
       Por exemplo, para extensões de compartilhamento, geralmente é
       `<YourShareExtensionTargetName>.ShareViewController`.
       Se você usar Objective-C para implementar a extensão,
       você deve omitir a parte `<YourShareExtensionTargetName>.`.<br>

    <figure>
      <div class="site-figure-container">
        <img src='/assets/images/docs/development/platform-integration/app-extensions/share-extension-info.png' alt='Definindo a propriedade NSExtensionPrincipalClass no arquivo Info.plist dentro do Xcode.' height='300'>
      </div>
    </figure>

5. Incorpore o `FlutterViewController`, conforme descrito em
   [Adicionando uma Tela Flutter][]. Por exemplo, você pode exibir uma
   rota específica em seu aplicativo Flutter dentro de uma extensão de compartilhamento.

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
tem procedimentos ligeiramente diferentes.

{% comment %}
Os diferentes procedimentos são necessários devido a bugs (quais bugs?) no Xcode.
Revisite esta documentação após lançamentos futuros do Xcode para ver se eles foram corrigidos.
{% endcomment -%}

### Testar em um simulador

1. Compile e execute o *target* principal do aplicativo.
2. Depois que o aplicativo for iniciado no simulador,
   pressione <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>H</kbd>
   para minimizar o aplicativo, o que muda para a tela inicial.
3. Inicie um aplicativo que suporte a extensão de compartilhamento,
   como o aplicativo Fotos.
4. Selecione uma foto, toque no botão de compartilhamento e, em seguida, toque
   no ícone de extensão de compartilhamento do seu aplicativo.

### Testar em um dispositivo físico

Você pode usar o seguinte procedimento ou as
instruções de [Teste em simuladores](#testar-em-um-simulador)
para testar em dispositivos físicos.

1. Inicie o *target* da extensão de compartilhamento.
2. Na janela pop-up que diz "Escolha um aplicativo para executar",
   selecione um aplicativo que possa ser usado para testar a extensão de compartilhamento,
   como o aplicativo Fotos.
3. Selecione uma foto, toque no botão de compartilhamento
   e toque no ícone de extensão de compartilhamento do seu aplicativo.

## Tutoriais

Para obter instruções passo a passo para usar
extensões de aplicativos com seu aplicativo Flutter iOS, confira o
[Adicionando um Widget da Tela Inicial ao seu aplicativo Flutter][lab]
codelab.

[Adicionando uma Tela Flutter]: /add-to-app/ios/add-flutter-screen?tab=vc-uikit-swift-tab#alternatively-create-a-flutterviewcontroller-with-an-implicit-flutterengine
[App Group]: {{site.apple-dev}}/documentation/xcode/configuring-app-groups
[documentação da Apple]: {{site.apple-dev}}/app-extensions/
[Core Spotlight]: {{site.apple-dev}}/documentation/corespotlight
[Deep Linking]:/ui/navigation/deep-linking
[lab]: {{site.codelabs}}/flutter-home-screen-widgets
[leverage]: /platform-integration/ios/apple-frameworks
[`path_provider`]: {{site.pub-pkg}}/path_provider
[pub.dev]: {{site.pub-pkg}}
[ler e gravar arquivos]: /cookbook/persistence/reading-writing-files
[`shared_preference_app_group`]: {{site.pub-pkg}}/shared_preference_app_group
[`sqflite`]: {{site.pub-pkg}}/sqflite
[WidgetKit]: {{site.apple-dev}}/documentation/widgetkit
[`workmanager`]: {{site.pub-pkg}}/workmanager
