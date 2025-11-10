---
ia-translate: true
title: Instalar Flutter manualmente
shortTitle: Instalar manualmente
breadcrumb: Manualmente
description: >-
  Aprenda como instalar e configurar o Flutter SDK manualmente.
---

Aprenda como instalar e configurar manualmente
seu ambiente de desenvolvimento Flutter.

:::tip
Se você nunca configurou ou desenvolveu um app com Flutter antes,
siga [Começar com Flutter][] em vez disso.

Se você está apenas procurando instalar o Flutter rapidamente,
considere [instalar o Flutter com VS Code][with-vs-code] para
uma experiência de configuração simplificada.
:::

[Começar com Flutter]: /get-started
[with-vs-code]: /install/with-vs-code

## Escolha sua plataforma de desenvolvimento {: #dev-platform}

As instruções nesta página estão configuradas para cobrir
a instalação do Flutter em um dispositivo **Windows**{:.selected-os-text}.

Se você gostaria de seguir as instruções para um SO diferente,
por favor selecione um dos seguintes.

<OSSelector />

## Baixar software pré-requisito {: #download-prerequisites}

Antes de instalar o Flutter SDK,
primeiro complete a seguinte configuração.

 1. <h3>Instale o Git para Windows</h3>

    Baixe e instale a versão mais recente do [Git para Windows][].

    Para ajuda instalando ou solucionando problemas com Git,
    consulte a [documentação do Git][git-install].

 1. <h3>Configure um editor ou IDE</h3>

    Para a melhor experiência desenvolvendo apps Flutter,
    considere instalar e configurar um
    [editor ou IDE com suporte ao Flutter][editors]{: target="_blank"}.

{: .steps .windows-only}

 1. <h3>Instale as ferramentas de linha de comando do Xcode</h3>

    Baixe as ferramentas de linha de comando do Xcode para obter acesso às
    ferramentas de linha de comando das quais o Flutter depende, incluindo Git.

    Para baixar as ferramentas, execute o seguinte comando no seu terminal preferido:

    ```console
    $ xcode-select --install
    ```

    Se você ainda não instalou as ferramentas,
    uma janela deve abrir confirmando que você gostaria de instalá-las.
    Clique em **Install**, então uma vez que a instalação estiver completa, clique em **Done**.

 1. <h3>Configure um editor ou IDE</h3>

    Para a melhor experiência desenvolvendo apps Flutter,
    considere instalar e configurar um
    [editor ou IDE com suporte ao Flutter][editors]{: target="_blank"}.

{: .steps .macos-only}

 1. <h3>Baixe e instale pacotes pré-requisito</h3>

    Usando seu gerenciador de pacotes ou mecanismo preferido,
    instale as versões mais recentes dos seguintes pacotes:

    - `curl`
    - `git`
    - `unzip`
    - `xz-utils`
    - `zip`
    - `libglu1-mesa`

    Em distros baseadas em Debian com `apt-get`, como Ubuntu,
    instale estes pacotes usando os seguintes comandos:

    ```console
    $ sudo apt-get update -y && sudo apt-get upgrade -y
    $ sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    ```

1. <h3>Configure um editor ou IDE</h3>

   Para a melhor experiência desenvolvendo apps Flutter,
   considere instalar e configurar um
   [editor ou IDE com suporte ao Flutter][editors]{: target="_blank"}.

{: .steps .linux-only}

 1. <h3>Configure suporte ao Linux</h3>

    Se você ainda não configurou suporte ao Linux no seu Chromebook,
    [Ative o suporte ao Linux][chromeos-linux].

    Se você já ativou o suporte ao Linux,
    certifique-se de que está atualizado seguindo as
    instruções de [Corrigir problemas com Linux][chromeos-linux-update].

 1. <h3>Baixe e instale pacotes pré-requisito</h3>

    Usando `apt-get` ou seu mecanismo de instalação preferido,
    instale as versões mais recentes dos seguintes pacotes:

    - `curl`
    - `git`
    - `unzip`
    - `xz-utils`
    - `zip`
    - `libglu1-mesa`

    Se você quiser usar `apt-get`,
    instale estes pacotes usando os seguintes comandos:

    ```console
    $ sudo apt-get update -y && sudo apt-get upgrade -y
    $ sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    ```

 1. <h3>Configure um editor ou IDE</h3>

    Para a melhor experiência desenvolvendo apps Flutter,
    considere instalar e configurar um
    [editor ou IDE com suporte ao Flutter][editors]{: target="_blank"}.

{: .steps .chromeos-only}

[editors]: /tools/editors
[Git para Windows]: https://git-scm.com/downloads/win
[git-install]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
[chromeos-linux]: https://support.google.com/chromebook/answer/9145439
[chromeos-linux-update]: https://support.google.com/chromebook/answer/9145439?hl=en#:~:text=Fix%20problems%20with%20Linux

## Instalar e configurar o Flutter {: #install-flutter}

Para instalar o Flutter SDK,
baixe o bundle mais recente do arquivo SDK,
então extraia o SDK para onde você quer que ele seja armazenado.

 1. <h3>Baixe o bundle do Flutter SDK</h3>

    Baixe o seguinte bundle de instalação para obter a
    versão estável mais recente do Flutter SDK.

    <DownloadLatestButton os="windows" />

 1. <h3>Crie uma pasta para armazenar o SDK</h3>

    Crie ou encontre uma pasta para armazenar o SDK extraído.
    Considere criar e usar um diretório em
    `%USERPROFILE%\develop` (`C:\Users\{username}\develop`).

    :::note
    Selecione um local que
    não tenha caracteres especiais ou espaços no seu caminho e
    não requer privilégios elevados.
    :::

 1. <h3>Extraia o SDK</h3>

    Extraia o bundle do SDK que você baixou para
    o diretório onde você quer armazenar o Flutter SDK.

    1. Copie o seguinte comando.
    1. Substitua `<sdk_zip_path>` pelo caminho para o bundle que você baixou.
    1. Substitua `<destination_directory_path>` pelo caminho para a
       pasta em que você quer que o SDK extraído esteja.
    1. Execute o comando editado no seu terminal preferido.

    ```console
    $ Expand-Archive –Path <sdk_zip_path> -Destination <destination_directory_path>
    ```

    Por exemplo, se você baixou o bundle para Flutter 3.29.3 no
    diretório `%USERPROFILE%\Downloads` e quer
    armazenar o SDK extraído no diretório `%USERPROFILE%\develop`:

    ```console
    $ Expand-Archive `
      -Path $env:USERPROFILE\Downloads\flutter_windows_3.29.3-stable.zip `
      -Destination $env:USERPROFILE\develop\
    ```

{: .steps .windows-only}

 1. <h3>Baixe o bundle do Flutter SDK</h3>

    Dependendo da arquitetura de cpu do seu dispositivo macOS,
    baixe um dos seguintes bundles de instalação para obter a
    versão estável mais recente do Flutter SDK.

    | Apple Silicon (ARM64)                            | Intel                                          |
    |--------------------------------------------------|------------------------------------------------|
    | <DownloadLatestButton os="macos" arch="arm64" /> | <DownloadLatestButton os="macos" arch="x64" /> |

 1. <h3>Crie uma pasta para armazenar o SDK</h3>

    Crie ou encontre uma pasta para armazenar o SDK extraído.
    Considere criar e usar um diretório em `~/develop/`.

 1. <h3>Extraia o SDK</h3>

    Extraia o bundle do SDK que você baixou para
    o diretório onde você quer armazenar o Flutter SDK.

    1. Copie o seguinte comando.
    1. Substitua `<sdk_zip_path>` pelo caminho para o bundle que você baixou.
    1. Substitua `<destination_directory_path>` pelo caminho para a
       pasta em que você quer que o SDK extraído esteja.
    1. Execute o comando editado no seu terminal preferido.

    ```console
    $ unzip <sdk_zip_path> -d <destination_directory_path>
    ```

    Por exemplo, se você baixou o bundle para Flutter 3.29.3 no
    diretório `~/Downloads` e quer
    armazenar o SDK extraído no diretório `~/develop`:

    ```console
    $ unzip ~/Downloads/flutter_macos_3.29.3-stable.zip -d ~/develop/
    ```

{: .steps .macos-only}

 1. <h3>Baixe o bundle do Flutter SDK</h3>

    Baixe o seguinte bundle de instalação para obter a
    versão estável mais recente do Flutter SDK.

    <DownloadLatestButton os="linux" />

 1. <h3>Crie uma pasta para armazenar o SDK</h3>

    Crie ou encontre uma pasta para armazenar o SDK extraído.
    Considere criar e usar um diretório em `~/develop/`.

 1. <h3>Extraia o SDK</h3>

    Extraia o bundle do SDK que você baixou para
    o diretório onde você quer armazenar o Flutter SDK.

    1. Copie o seguinte comando.
    1. Substitua `<sdk_zip_path>` pelo caminho para o bundle que você baixou.
    1. Substitua `<destination_directory_path>` pelo caminho para a
       pasta em que você quer que o SDK extraído esteja.
    1. Execute o comando editado no seu terminal preferido.

    ```console
    $ tar -xf <sdk_zip_path> -C <destination_directory_path>
    ```

    Por exemplo, se você baixou o bundle para Flutter 3.29.3 no
    diretório `~/Downloads` e quer
    armazenar o SDK extraído no diretório `~/develop`:

    ```console
    $ tar -xf ~/Downloads/flutter_linux_3.29.3-stable.tar.xz -C ~/develop/
    ```

{: .steps .linux-only .chromeos-only}

## Adicionar Flutter ao seu PATH {: #add-to-path}

Agora que você baixou o SDK,
adicione o diretório `bin` do Flutter SDK à sua variável de ambiente `PATH`.
Adicionar Flutter ao seu `PATH` permite que você use as
ferramentas de linha de comando `flutter` e `dart` em terminais e IDEs.

<div class="windows-only">

{% render "docs/install/path/windows.md" %}

</div>

<div class="macos-only">

{% render "docs/install/path/macos.md" %}

</div>

<div class="linux-only">

{% render "docs/install/path/linux.md" %}

</div>

<div class="chromeos-only">

{% render "docs/install/path/chromeos.md" %}

</div>

## Continue sua jornada com Flutter {: #next-steps}

Agora que você instalou o Flutter com sucesso,
configure desenvolvimento para pelo menos uma plataforma alvo
para continuar sua jornada com Flutter.

:::recommend
Se você ainda não tem uma plataforma preferida
para alvejar durante o desenvolvimento,
a equipe Flutter recomenda que você primeiro experimente
[desenvolver para a web][web-setup]!
:::

[web-setup]: /platform-integration/web/setup

<div class="card-grid link-cards">
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/flutter-on-phone.svg" height="160" aria-hidden="true" alt="Uma representação do Flutter em múltiplos dispositivos.">
    </div>
    <div class="card-header">
      <span class="card-title">Configure uma plataforma alvo</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/platform-integration/web/setup">Alveje a web</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/android/setup">Alveje Android</a>
        </li>
        <li class="macos-only">
          <a class="text-button" href="/platform-integration/ios/setup">Alveje iOS</a>
        </li>
        <li class="macos-only">
          <a class="text-button" href="/platform-integration/macos/setup">Alveje macOS</a>
        </li>
        <li class="windows-only">
          <a class="text-button" href="/platform-integration/windows/setup">Alveje Windows</a>
        </li>
        <li class="linux-only">
          <a class="text-button" href="/platform-integration/linux/setup">Alveje Linux</a>
        </li>
      </ul>
    </div>
  </div>

  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/pointing-the-way.png" height="160" aria-hidden="true" alt="Dash ajudando você a explorar recursos de aprendizado Flutter.">
    </div>
    <div class="card-header">
      <span class="card-title">Aprenda desenvolvimento Flutter</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/get-started/codelab">Escreva seu primeiro app</a>
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
      <img src="/assets/images/decorative/up-to-date.png" height="160" aria-hidden="true" alt="Mantenha-se atualizado com Flutter">
    </div>
    <div class="card-header">
      <span class="card-title">Mantenha-se atualizado com Flutter</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/install/upgrade">Atualize Flutter</a>
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
