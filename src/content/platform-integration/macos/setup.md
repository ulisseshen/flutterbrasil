---
ia-translate: true
title: Configurar desenvolvimento macOS
description: >-
  Configure seu ambiente de desenvolvimento para
  executar, compilar e implantar apps Flutter para dispositivos macOS.
---

Aprenda como configurar seu ambiente de desenvolvimento
para executar, compilar e implantar apps Flutter para a plataforma desktop macOS.

:::note
Se você ainda não configurou Flutter,
visite e siga o guia [Começando com Flutter][Get started with Flutter] primeiro.

Se você já instalou Flutter,
certifique-se de que está [atualizado][up to date].
:::

[Get started with Flutter]: /get-started
[up to date]: /install/upgrade

## Configurar ferramentas {: #set-up-tooling}

Com Xcode, você pode executar apps Flutter no macOS assim como
compilar e debugar código nativo Swift e Objective-C.

 1. <h3>Instalar Xcode</h3>

    Se você ainda não o fez,
    [instale e configure a versão mais recente do Xcode][xcode].

    Se você já instalou Xcode,
    atualize-o para a versão mais recente usando o
    mesmo método de instalação que você usou originalmente.

 1. <h3>Configurar ferramentas de linha de comando do Xcode</h3>

    Para configurar as ferramentas de linha de comando do Xcode para usar
    a versão do Xcode que você instalou,
    execute o seguinte comando em seu terminal preferido:

    ```console
    $ sudo sh -c 'xcode-select -s /Applications/Xcode.app/Contents/Developer && xcodebuild -runFirstLaunch'
    ```

    Se você baixou Xcode em outro lugar ou precisa usar uma versão diferente,
    substitua `/Applications/Xcode.app` pelo caminho para lá.

 1. <h3>Aceitar as licenças do Xcode</h3>

    Depois de ter configurado Xcode e suas ferramentas de linha de comando,
    aceite as licenças do Xcode.

    1. Abra seu terminal preferido.

    1. Execute o seguinte comando para revisar e assinar as licenças do Xcode.

       ```console
       $ sudo xcodebuild -license
       ```

    1. Leia e aceite todas as licenças necessárias.

       Antes de concordar com os termos de cada licença,
       leia cada uma com cuidado.

       Uma vez que você tenha aceitado todas as licenças necessárias com sucesso,
       o comando deve exibir como revisar as licenças.

 1. <h3>Instalar CocoaPods</h3>

    Para suportar [plugins Flutter][Flutter plugins] que usam código nativo macOS,
    instale a versão mais recente do [CocoaPods][CocoaPods].

    Instale CocoaPods seguindo o
    [guia de instalação do CocoaPods][CocoaPods installation guide].

    Se você já instalou CocoaPods,
    atualize-o seguindo o [guia de atualização do CocoaPods][CocoaPods update guide].

{: .steps}

[xcode]: https://developer.apple.com/xcode/
[Flutter plugins]: /packages-and-plugins/developing-packages#types
[CocoaPods]: https://cocoapods.org/
[CocoaPods installation guide]: https://guides.cocoapods.org/using/getting-started.html#installation
[CocoaPods update guide]: https://guides.cocoapods.org/using/getting-started.html#updating-cocoapods

## Validar sua configuração {: #validate-setup}

 1. <h3>Verificar problemas na toolchain</h3>

    Para verificar quaisquer problemas com sua configuração de desenvolvimento macOS,
    execute o comando `flutter doctor` em seu terminal preferido:

    ```console
    $ flutter doctor -v
    ```

    Se você ver quaisquer erros ou tarefas a completar
    na seção **Xcode**,
    complete e resolva-os, então
    execute `flutter doctor -v` novamente para verificar quaisquer alterações.

 1. <h3>Verificar dispositivos macOS</h3>

    Para garantir que Flutter possa encontrar e conectar ao seu dispositivo macOS corretamente,
    execute `flutter devices` em seu terminal preferido:

    ```console
    $ flutter devices
    ```

    Se você configurou tudo corretamente,
    deve haver pelo menos uma entrada com a plataforma marcada como **macos**.

 1. <h3>Solucionar problemas de configuração</h3>

    Se você precisar de ajuda para resolver quaisquer problemas de configuração,
    consulte [Solução de problemas de instalação e configuração][Install and setup troubleshooting].

    Se você ainda tiver problemas ou perguntas,
    entre em contato em um dos canais da [comunidade][community] Flutter.

{: .steps}

[Install and setup troubleshooting]: /install/troubleshoot
[community]: {{site.main-url}}/community

## Começar a desenvolver para macOS {: #start-developing}

Parabéns!
Agora que você configurou o desenvolvimento desktop macOS para Flutter,
você pode continuar sua jornada de aprendizado Flutter enquanto testa no macOS
ou começar a expandir a integração com macOS.

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
      <img src="/assets/images/decorative/flutter-on-desktop.svg" height="160" aria-hidden="true" alt="An outline of Flutter desktop support.">
    </div>
    <div class="card-header">
      <span class="card-title">Build for macOS</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/deployment/macos">Build and deploy to macOS</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/macos/c-interop">Bind to native macOS code</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/macos/platform-views">Embed native macOS views</a>
        </li>
        <li>
          <a class="text-button" href="/deployment/flavors-ios">Set up app flavors</a>
        </li>
        <li>
          <a class="text-button" href="/packages-and-plugins/swift-package-manager/for-app-developers">Use Swift Package Manager</a>
        </li>
      </ul>
    </div>
  </div>
</div>
