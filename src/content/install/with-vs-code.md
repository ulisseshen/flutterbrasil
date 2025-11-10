---
title: Instalar o Flutter usando o VS Code
shortTitle: Instalar com VS Code
breadcrumb: Com VS Code
description: >-
  Aprenda a usar o VS Code para instalar e configurar rapidamente o Flutter SDK.
ia-translate: true
---

Aprenda a instalar e configurar o Flutter em um editor baseado em Code OSS.
Isso inclui (mas não se limita a), [VS Code][], [Cursor][] e [Windsurf][].

[VS Code]: https://code.visualstudio.com
[Cursor]: https://cursor.com/
[Windsurf]: https://windsurf.com/

:::tip
Se você nunca configurou ou desenvolveu um aplicativo com Flutter antes,
siga [Configurar e testar o Flutter][Set up and test drive Flutter] em vez disso.
:::

[Set up and test drive Flutter]: /get-started/quick

## Escolha sua plataforma de desenvolvimento {: #dev-platform}

As instruções nesta página estão configuradas para cobrir
a instalação do Flutter em um dispositivo **Windows**{:.selected-os-text}.

Se você deseja seguir as instruções para um sistema operacional diferente,
selecione uma das opções a seguir.

<OSSelector />

## Baixar software pré-requisito {: #download-prerequisites}

Para uma configuração mais tranquila do Flutter,
primeiro instale as seguintes ferramentas.

 1. <h3>Configurar o suporte ao Linux</h3>

    Se você ainda não configurou o suporte ao Linux no seu Chromebook,
    [Ative o suporte ao Linux][chromeos-linux].

    Se você já ativou o suporte ao Linux,
    certifique-se de que está atualizado seguindo as
    instruções em [Corrigir problemas com o Linux][chromeos-linux-update].

 1. <h3>Baixar e instalar pacotes pré-requisitos</h3>

    Usando `apt-get` ou seu mecanismo de instalação preferido,
    instale as versões mais recentes dos seguintes pacotes:

    - `curl`
    - `git`
    - `unzip`
    - `xz-utils`
    - `zip`
    - `libglu1-mesa`

    Se você quiser usar `apt-get`,
    instale esses pacotes usando os seguintes comandos:

    ```console
    $ sudo apt-get update -y && sudo apt-get upgrade -y
    $ sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    ```

 1. <h3>Baixar e instalar o Visual Studio Code</h3>

    Para instalar rapidamente o Flutter e, em seguida, editar e depurar seus aplicativos,
    [instale e configure o Visual Studio Code][vscode-install].

{: .steps .chromeos-only}

 1. <h3>Instalar as ferramentas de linha de comando do Xcode</h3>

    Baixe as ferramentas de linha de comando do Xcode para obter acesso às
    ferramentas de linha de comando das quais o Flutter depende, incluindo Git.

    Para baixar as ferramentas, execute o seguinte comando no seu terminal preferido:

    ```console
    $ xcode-select --install
    ```

    Se você ainda não instalou as ferramentas,
    um diálogo deve abrir confirmando que você deseja instalá-las.
    Clique em **Install** e, após a conclusão da instalação, clique em **Done**.

 1. <h3>Baixar e instalar o Visual Studio Code</h3>

    Para instalar rapidamente o Flutter e, em seguida, editar e depurar seus aplicativos,
    [instale e configure o Visual Studio Code][vscode-install].

{: .steps .macos-only}

 1. <h3>Instalar o Git para Windows</h3>

    Baixe e instale a versão mais recente do [Git for Windows][].

    Para obter ajuda na instalação ou solução de problemas do Git,
    consulte a [documentação do Git][git-install].

 1. <h3>Baixar e instalar o Visual Studio Code</h3>

    Para instalar rapidamente o Flutter e, em seguida, editar e depurar seus aplicativos,
    [instale e configure o Visual Studio Code][vscode-install].

{: .steps .windows-only}

 1. <h3>Baixar e instalar pacotes pré-requisitos</h3>

    Usando seu gerenciador de pacotes ou mecanismo preferido,
    instale as versões mais recentes dos seguintes pacotes:

    - `curl`
    - `git`
    - `unzip`
    - `xz-utils`
    - `zip`
    - `libglu1-mesa`

    Em distribuições baseadas em Debian com `apt-get`, como Ubuntu,
    instale esses pacotes usando os seguintes comandos:

    ```console
    $ sudo apt-get update -y && sudo apt-get upgrade -y
    $ sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    ```

 1. <h3>Baixar e instalar o Visual Studio Code</h3>

    Para instalar rapidamente o Flutter e, em seguida, editar e depurar seus aplicativos,
    [instale e configure o Visual Studio Code][vscode-install].

{: .steps .linux-only}

[chromeos-linux]: https://support.google.com/chromebook/answer/9145439
[chromeos-linux-update]: https://support.google.com/chromebook/answer/9145439?hl=en#:~:text=Fix%20problems%20with%20Linux
[Git for Windows]: https://git-scm.com/downloads/win
[git-install]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
[vscode-install]: https://code.visualstudio.com/docs/setup/setup-overview

## Instalar e configurar o Flutter {: #install-flutter}

Agora que você instalou o Git e o VS Code,
siga estas etapas para usar o VS Code para instalar e configurar o Flutter.

 1. <h3>Iniciar o VS Code</h3>

    Se ainda não estiver aberto, abra o VS Code procurando por ele com o Spotlight
    ou abrindo-o manualmente do diretório onde está instalado.

 1. <h3>Adicionar a extensão Flutter ao VS Code</h3>

    Para adicionar as extensões Dart e Flutter ao VS Code,
    visite a [página do marketplace da extensão Flutter][flutter-vscode]
    e clique em **Install**.
    Se solicitado pelo seu navegador, permita que ele abra o VS Code.

 1. <h3>Instalar o Flutter com o VS Code</h3>

    1. Abra a paleta de comandos no VS Code.

       Vá para **View** <span aria-label="and then">></span> **Command Palette**
       ou pressione <kbd class="special-key">Cmd/Ctrl</kbd> +
       <kbd>Shift</kbd> + <kbd>P</kbd>.

    1. Na paleta de comandos, digite `flutter`.

    1. Selecione **Flutter: New Project**.

    1. O VS Code solicita que você localize o Flutter SDK no seu computador.
       Selecione **Download SDK**.

    1. Quando o diálogo **Select Folder for Flutter SDK** aparecer,
       escolha onde você deseja instalar o Flutter.

    1. Clique em **Clone Flutter**.

       Enquanto baixa o Flutter, o VS Code exibe esta notificação pop-up:

       ```console
       Downloading the Flutter SDK. This may take a few minutes.
       ```

       Este download leva alguns minutos.
       Se você suspeitar que o download travou, clique em **Cancel** e
       inicie a instalação novamente.

    1. Clique em **Add SDK to PATH**.

       Quando bem-sucedido, uma notificação é exibida:

       ```console
       The Flutter SDK was added to your PATH
       ```

    1. O VS Code pode exibir um aviso do Google Analytics.

       Se você concordar, clique em **OK**.

    1. Para garantir que o Flutter esteja disponível em todos os terminais:

       1. Feche e, em seguida, reabra todas as janelas de terminal.
       1. Reinicie o VS Code.

       {:type="a"}

 1. <h3>Validar sua configuração</h3>

    Para garantir que você instalou o Flutter corretamente,
    execute `flutter doctor -v` no seu terminal preferido.

    Se o comando não for encontrado ou houver um erro,
    consulte [Solução de problemas de instalação do Flutter][troubleshoot].

{:.steps}

[Install Flutter manually]: /install/manual
[flutter-vscode]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[troubleshoot]: /install/troubleshoot

## Continue sua jornada com Flutter {: #next-steps}

Agora que você instalou o Flutter com sucesso,
configure o desenvolvimento para pelo menos uma plataforma de destino
para continuar sua jornada com o Flutter.

:::recommend
Se você ainda não tem uma plataforma preferida
para usar durante o desenvolvimento,
a equipe do Flutter recomenda que você experimente primeiro
[desenvolver para a web][web-setup]!
:::

[web-setup]: /platform-integration/web/setup

<div class="card-grid link-cards">
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/flutter-on-phone.svg" height="160" aria-hidden="true" alt="Uma representação do Flutter em múltiplos dispositivos.">
    </div>
    <div class="card-header">
      <span class="card-title">Configurar uma plataforma de destino</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/platform-integration/web/setup">Ter como alvo a web</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/android/setup">Ter como alvo Android</a>
        </li>
        <li class="macos-only">
          <a class="text-button" href="/platform-integration/ios/setup">Ter como alvo iOS</a>
        </li>
        <li class="macos-only">
          <a class="text-button" href="/platform-integration/macos/setup">Ter como alvo macOS</a>
        </li>
        <li class="windows-only">
          <a class="text-button" href="/platform-integration/windows/setup">Ter como alvo Windows</a>
        </li>
        <li class="linux-only">
          <a class="text-button" href="/platform-integration/linux/setup">Ter como alvo Linux</a>
        </li>
      </ul>
    </div>
  </div>

  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/pointing-the-way.png" height="160" aria-hidden="true" alt="Dash ajudando você a explorar recursos de aprendizado do Flutter.">
    </div>
    <div class="card-header">
      <span class="card-title">Aprenda desenvolvimento Flutter</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/get-started/codelab">Escreva seu primeiro aplicativo</a>
        </li>
        <li>
          <a class="text-button" href="/get-started/fundamentals">Aprenda os fundamentos</a>
        </li>
        <li>
          <a class="text-button" href="https://www.youtube.com/watch?v=b_sQ9bMltGU&list=PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Explore widgets Flutter</a>
        </li>
      </ul>
    </div>
  </div>

  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/up-to-date.png" height="160" aria-hidden="true" alt="Mantenha-se atualizado com o Flutter">
    </div>
    <div class="card-header">
      <span class="card-title">Mantenha-se atualizado com o Flutter</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/install/upgrade">Atualizar o Flutter</a>
        </li>
        <li>
          <a class="text-button" href="/release/release-notes">Descubra o que há de novo</a>
        </li>
        <li>
          <a class="text-button" href="{{site.social.youtube}}">Inscreva-se no YouTube</a>
        </li>
      </ul>
    </div>
  </div>
</div>
