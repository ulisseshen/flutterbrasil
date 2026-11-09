---
ia-translate: true
title: Instalar Flutter manualmente
shortTitle: Instalar manualmente
breadcrumb: Manualmente
description: >-
  Aprenda como instalar e configurar o Flutter SDK manualmente.
---

Aprenda como baixar e configurar manualmente o Flutter SDK
e configurar seu ambiente de desenvolvimento.

Para uma configuração mais rápida e automatizada no VS Code (ou em qualquer editor baseado no Code OSS),
siga [Instalar o Flutter com VS Code][with-vs-code] em vez disso.
Para baixar uma versão ou canal de lançamento específico do Flutter,
visite o [arquivo do SDK][SDK archive], ou gerencie uma instalação existente em
[Instalar e configurar o Flutter][Install and set up Flutter].

[with-vs-code]: /install/with-vs-code
[SDK archive]: /install/archive
[Install and set up Flutter]: /install

## Confirme sua plataforma de desenvolvimento {: #dev-platform}

Estas instruções estão configuradas para **Windows**{:.selected-os-text}.
Se você está usando um sistema operacional diferente,
selecione-o entre as seguintes opções:

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

    **Se você já tem o Git instalado,**
    pode pular para o próximo passo: Configure um editor ou IDE.

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

    Extraia o arquivo `.zip` baixado para o diretório escolhido
    (por exemplo, de `Downloads` para `develop`,
    ajustando o nome do arquivo e os caminhos conforme necessário):

    <Tabs key="windows-terminal">
    <Tab name="PowerShell">

    ```powershell
    Expand-Archive `
      -Path "$env:USERPROFILE\Downloads\flutter_windows_3.47.5-stable.zip" `
      -DestinationPath "$env:USERPROFILE\develop"
    ```

    </Tab>
    <Tab name="Command prompt">

    ```bat
    tar -xf "%USERPROFILE%\Downloads\flutter_windows_3.47.5-stable.zip" -C "%USERPROFILE%\develop"
    ```

    </Tab>
    </Tabs>

    :::note
    Se o arquivo `flutter.bat` estiver faltando no diretório `bin`
    após a extração, seu software antivírus pode tê-lo colocado em quarentena.
    Se isso acontecer, configure seu antivírus para confiar no diretório do Flutter SDK
    e então extraia o bundle novamente.
    :::

{: .steps .windows-only}

<div class="macos-only">

:::warning
**Nota para Macs Intel:**
O Flutter está descontinuando o suporte para Macs baseados em Intel (x64).
Lançamentos futuros do Flutter exigirão Apple Silicon.
Para detalhes, confira a
[estratégia de descontinuação do macOS Intel](https://docs.google.com/document/d/1ty3js_Eg2sNIbDuyYS_aV7h4jYdx1hEpX_mV135gO4s/edit?tab=t.0#heading=h.cx7d8y57ce6p).
:::

</div>

 1. <h3>Baixe o bundle do Flutter SDK</h3>

    Para escolher o bundle correto,
    você precisa saber o tipo de processador do seu Mac.
    *(Para verificar, vá em **Apple menu () > About This Mac**
    e veja a seção **Processor** ou **Chip**.)*

    Dependendo da arquitetura de cpu do seu dispositivo macOS,
    baixe um dos seguintes bundles de instalação para obter a
    versão estável mais recente do Flutter SDK.

    | Apple Silicon (ARM64)                                                 | Intel                                                               |
    |-----------------------------------------------------------------------|---------------------------------------------------------------------|
    | <DownloadLatestButton os="macos" arch="arm64"></DownloadLatestButton> | <DownloadLatestButton os="macos" arch="x64"></DownloadLatestButton> |

 1. <h3>Crie uma pasta para armazenar o SDK</h3>

    Crie ou encontre uma pasta para armazenar o SDK extraído.
    Considere criar e usar um diretório em `~/develop/`.

 1. <h3>Extraia o SDK</h3>

    Extraia o arquivo `.zip` baixado para o diretório escolhido
    (por exemplo, de `~/Downloads` para `~/develop/`,
    ajustando o nome do arquivo e os caminhos conforme necessário):

    ```console
    $ unzip ~/Downloads/flutter_macos_3.47.5-stable.zip -d ~/develop/
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

    Extraia o arquivo `.tar.xz` baixado para o diretório escolhido
    (por exemplo, de `~/Downloads` para `~/develop/`,
    ajustando o nome do arquivo e os caminhos conforme necessário):

    ```console
    $ tar -xf ~/Downloads/flutter_linux_3.47.5-stable.tar.xz -C ~/develop/
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

## Valide sua configuração {: #validate-setup}

Para verificar sua instalação do Flutter, execute `flutter doctor` no seu terminal:

```console
$ flutter doctor
```

:::note O que esperar do `flutter doctor`
Você só precisa de marcas de verificação (`[✓]`) para **Flutter**
e para as plataformas que você planeja ter como alvo
(por exemplo, **Chrome** permite que você compile para a web imediatamente).
Você pode ignorar com segurança avisos `[!]` ou `[✗]` para ferramentas como
Android Studio ou Xcode até estar pronto para ter essas plataformas como alvo.
:::

Se você encontrar algum problema durante a instalação,
consulte [solução de problemas de instalação do Flutter][troubleshoot].

[troubleshoot]: /install/troubleshoot

## Continue sua jornada com Flutter {: #next-steps}

Agora que você instalou o Flutter com sucesso,
configure o desenvolvimento para uma plataforma alvo ou comece a aprender
para continuar sua jornada com Flutter.

{% render "docs/get-started/setup-next-steps.html", site: site %}
