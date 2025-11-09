---
ia-translate: true
title: Configurar desenvolvimento iOS
description: >-
  Configure seu ambiente de desenvolvimento para
  executar, compilar e implantar apps Flutter em dispositivos iOS.
---

Aprenda como configurar seu ambiente de desenvolvimento
para executar, compilar e implantar apps Flutter em dispositivos iOS.

:::note
Se você ainda não configurou o Flutter,
visite e siga o guia [Comece com Flutter][Get started with Flutter] primeiro.

Se você já instalou o Flutter,
certifique-se de que ele está [atualizado][up to date].
:::

[Get started with Flutter]: /get-started
[up to date]: /install/upgrade

## Set up iOS tooling {: #set-up-tooling}

Com o Xcode, você pode executar apps Flutter em
um dispositivo iOS físico ou no iOS Simulator.

 1. <h3>Install Xcode</h3>

    Se você ainda não fez isso,
    [instale e configure a versão mais recente do Xcode][xcode].

    Se você já instalou o Xcode,
    atualize-o para a versão mais recente usando o
    mesmo método de instalação que você usou originalmente.

 1. <h3>Set up Xcode command-line tools</h3>

    Para configurar as ferramentas de linha de comando do Xcode para usar
    a versão do Xcode que você instalou,
    execute o seguinte comando no seu terminal preferido:

    ```console
    $ sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
    ```

    Se você baixou o Xcode em outro lugar ou precisa usar uma versão diferente,
    substitua `/Applications/Xcode.app` pelo caminho para lá.

 1. <h3>Agree to the Xcode licenses</h3>

    Depois de configurar o Xcode e suas ferramentas de linha de comando,
    concorde com as licenças do Xcode.

    1. Abra seu terminal preferido.

    1. Execute o seguinte comando para revisar e assinar as licenças do Xcode.

       ```console
       $ sudo xcodebuild -license
       ```

    1. Leia e concorde com todas as licenças necessárias.

       Antes de concordar com os termos de cada licença,
       leia cada uma com cuidado.

 1. <h3>Download prerequisite tooling</h3>

    Para baixar o suporte à plataforma iOS e
    os runtimes mais recentes do iOS Simulator,
    execute o seguinte comando no seu terminal preferido.

    ```console
    $ xcodebuild -downloadPlatform iOS
    ```

 1. <h3>Install Rosetta</h3>

    Se você está desenvolvendo em um Mac [Apple Silicon][Apple Silicon] (ARM),
    [instale o Rosetta 2][install Rosetta 2]:

    ```console
    $ sudo softwareupdate --install-rosetta --agree-to-license
    ```

 1. <h3>Install CocoaPods</h3>

    Para suportar [plugins Flutter][Flutter plugins] que usam código iOS ou macOS nativo,
    instale a versão mais recente do [CocoaPods][cocoapods].

    Instale o CocoaPods seguindo o
    [guia de instalação do CocoaPods][CocoaPods installation guide].

    Se você já instalou o CocoaPods,
    atualize-o seguindo o [guia de atualização do CocoaPods][CocoaPods update guide].

{: .steps}

[xcode]: https://developer.apple.com/xcode/
[Apple Silicon]: https://support.apple.com/en-us/116943
[install Rosetta 2]: https://support.apple.com/en-us/102527
[cocoapods]: https://guides.cocoapods.org/using/getting-started.html#installation
[Flutter plugins]: /packages-and-plugins/developing-packages#types
[CocoaPods installation guide]: https://guides.cocoapods.org/using/getting-started.html#installation
[CocoaPods update guide]: https://guides.cocoapods.org/using/getting-started.html#updating-cocoapods

## Set up an iOS device {: #set-up-devices}

Recomendamos começar com o iOS Simulator, pois
é mais fácil de configurar do que um dispositivo iOS físico.
No entanto, você também deve testar seu app em um
dispositivo físico real.

<Tabs key="ios-simulator-or-physical-device">
<Tab name="Simulator">

Inicie o iOS Simulator com o seguinte comando:

```console
$ open -a Simulator
```

Se você precisa instalar um simulador para uma versão diferente do OS,
confira [Downloading and installing additional Xcode components][Downloading and installing additional Xcode components]
no site Apple Developer.

[Downloading and installing additional Xcode components]: {{site.apple-dev}}/documentation/xcode/downloading-and-installing-additional-xcode-components

</Tab>
<Tab name="Physical device">

:::warning
Uma mudança futura no iOS causou uma quebra temporária no modo debug do Flutter
em dispositivos físicos executando iOS 26 (atualmente em beta).
Se seu dispositivo físico já está no iOS 26, recomendamos mudar para a
aba **Simulator** e seguir as instruções.
Consulte [Flutter no iOS mais recente][Flutter on latest iOS] para detalhes.
:::

[Flutter on latest iOS]: /platform-integration/ios/ios-latest

Configure cada dispositivo iOS no qual você deseja testar.

 1. <h3>Configure your physical iOS device</h3>

    1. Conecte seu dispositivo iOS à porta USB do seu Mac.

    1. Ao conectar um dispositivo iOS ao seu Mac pela primeira vez,
       seu dispositivo exibe o diálogo **Trust this computer?**.

    1. Clique em **Trust**.

       ![Trust Mac](/assets/images/docs/setup/trust-computer.png)

 1. <h3>Configure your physical iOS device</h3>

    A Apple exige habilitar o **[Developer Mode][Developer Mode]**
    no dispositivo para proteção contra software malicioso.

    1. Toque em **Settings** <span aria-label="and then">></span>
       **Privacy & Security** <span aria-label="and then">></span>
       **Developer Mode**.

    1. Toque para alternar **Developer Mode** para **On**.

    1. Reinicie o dispositivo.

    1. Quando o diálogo **Turn on Developer Mode?** aparecer,
       toque em **Turn On**.

 1. <h3>Create a developer code signing certificate</h3>

    Para enviar seu app para um dispositivo iOS físico,
    _mesmo_ para testes, você deve estabelecer confiança
    entre seu Mac e o dispositivo.
    Além de confiar no dispositivo quando esse
    popup aparecer, você deve fazer upload de um
    certificado de desenvolvedor assinado para seu dispositivo.

    Para criar um certificado de desenvolvimento assinado,
    você precisa de um Apple ID.
    Se você não tem um, [crie um][apple-account-new].
    Você também deve se inscrever no [programa Apple Developer][Apple Developer program]
    e criar uma [conta Apple Developer][Apple Developer account].
    Se você está apenas _testando_ seu app em um dispositivo iOS,
    uma conta Apple Developer pessoal é gratuita e funciona.

    :::note Apple Developer program
    Quando você quiser _implantar_ seu app na App Store,
    você precisará atualizar sua conta Apple Developer pessoal para
    uma conta profissional.
    :::

 1. <h3>Prepare the device</h3>

    1. Encontre o menu **VPN & Device Management** em **Settings**.

       Alterne seu certificado para **Enable**.

       :::note
       Se você não conseguir encontrar o menu **VPN & Device Management**,
       execute seu app no seu dispositivo iOS uma vez e tente novamente.
       :::

    1. Sob o título **Developer App**,
       você deve encontrar seu certificado.

    1. Toque no certificado.

    1. Toque em **Trust "&lt;certificate&gt;"**.

    1. Quando o diálogo for exibido, toque em **Trust**.

       Se o diálogo **codesign wants to access key...** aparecer:

       1. Digite sua senha do macOS.

       1. Toque em **Always Allow**.

{: .steps}

[apple-account-new]: https://support.apple.com/en-us/108647
[Developer Mode]: {{site.apple-dev}}/documentation/xcode/enabling-developer-mode-on-a-device
[Apple Developer program]: {{site.apple-dev}}/programs/
[Apple Developer account]: {{site.apple-dev}}/account

</Tab>
</Tabs>

---

## Start developing for iOS {: #start-developing}

**Parabéns.**
Agora que você configurou o desenvolvimento iOS para Flutter,
você pode continuar sua jornada de aprendizado Flutter testando no iOS
ou começar a melhorar a integração com iOS.

<div class="card-grid link-cards">
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/pointing-the-way.png" height="160" aria-hidden="true" alt="Dash helping you explore Flutter learning resources.">
    </div>
    <div class="card-header">
      <span class="card-title">Continue learning Flutter</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/get-started/codelab">Write your first app</a>
        </li>
        <li>
          <a class="text-button" href="/get-started/fundamentals">Learn the fundamentals</a>
        </li>
        <li>
          <a class="text-button" href="https://www.youtube.com/watch?v=b_sQ9bMltGU&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Explore Flutter widgets</a>
        </li>
        <li>
          <a class="text-button" href="/reference/learning-resources">Check out samples</a>
        </li>
        <li>
          <a class="text-button" href="/resources/bootstrap-into-dart">Learn about Dart</a>
        </li>
      </ul>
    </div>
  </div>
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/flutter-on-phone.svg" height="160" aria-hidden="true" alt="A representation of Flutter on multiple devices.">
    </div>
    <div class="card-header">
      <span class="card-title">Build for iOS</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/deployment/ios">Build and deploy to iOS</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/ios/c-interop">Bind to native iOS code</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/ios/apple-frameworks">Leverage system frameworks</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/ios/platform-views">Embed native iOS views</a>
        </li>
        <li>
          <a class="text-button" href="/packages-and-plugins/swift-package-manager/for-app-developers">Use Swift Package Manager</a>
        </li>
      </ul>
    </div>
  </div>
</div>
