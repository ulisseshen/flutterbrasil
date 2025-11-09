---
ia-translate: true
title: Configure e teste o Flutter
shortTitle: Início rápido
description: >-
  Configure Flutter no seu dispositivo com um editor baseado em OSS, como VS Code, e
  comece a desenvolver seu primeiro app multiplataforma com Flutter!
showBanner: false
sitemap: false
---

Aprenda como usar qualquer editor baseado em OSS, como VS Code,
para configurar seu ambiente de desenvolvimento Flutter e
experimentar a experiência de desenvolvedor do Flutter.

Se você já desenvolveu com Flutter antes,
ou prefere usar um editor ou IDE diferente,
você pode seguir as [instruções de configuração personalizada][custom setup instructions].

:::note O que você alcançará

- Instalar os pré-requisitos de software para Flutter.
- Usar VS Code para baixar e instalar Flutter.
- Criar um novo app Flutter a partir de um template de exemplo.
- Experimentar recursos de desenvolvimento Flutter como hot reload com estado.

:::

[custom setup instructions]: /get-started/custom

## Confirme sua plataforma de desenvolvimento {: #dev-platform}

As instruções nesta página estão configuradas para cobrir
a instalação e teste do Flutter em um dispositivo **Windows**{:.selected-os-text}.

Se você gostaria de seguir as instruções para um OS diferente,
por favor selecione um dos seguintes.

<OSSelector />

## Baixe o software pré-requisito {: #download-prerequisites}

Para a configuração mais suave do Flutter,
primeiro instale as seguintes ferramentas.

 1. <h3>Configure o suporte ao Linux</h3>

    Se você ainda não configurou o suporte ao Linux no seu Chromebook,
    [Ative o suporte ao Linux][chromeos-linux].

    Se você já ativou o suporte ao Linux,
    certifique-se de que está atualizado seguindo as
    instruções [Corrigir problemas com Linux][chromeos-linux-update].

 1. <h3>Baixe e instale os pacotes pré-requisito</h3>

    Usando `apt-get` ou seu mecanismo de instalação preferido,
    instale as versões mais recentes dos seguintes pacotes:

    - `curl`
    - `git`
    - `unzip`
    - `xz-utils`
    - `zip`
    - `libglu1-mesa`

    Se você quer usar `apt-get`,
    instale esses pacotes usando os seguintes comandos:

    ```console
    $ sudo apt-get update -y && sudo apt-get upgrade -y
    $ sudo apt-get install -y curl git unzip xz-utils zip libglu1-mesa
    ```

 1. <h3>Baixe e instale o Visual Studio Code</h3>

    Para instalar Flutter rapidamente, depois editar e depurar seus apps,
    [instale e configure o Visual Studio Code][vscode-install].

    Você pode, em vez disso, instalar e usar qualquer outro editor baseado em Code OSS
    que suporte extensões do VS Code.
    Se você escolher fazer isso, para o resto deste artigo,
    assuma que VS Code se refere ao editor de sua escolha.

{: .steps .chromeos-only}

 1. <h3>Instale o git</h3>

    **Se você já tem o git instalado, pule para o próximo
    passo: Baixe e instale o Visual Studio Code.**

    Existem algumas maneiras de instalar o git no seu Mac,
    mas a maneira que recomendamos é usando o XCode.
    Isso será importante quando você direcionar suas
    compilações para iOS ou macOS.

    ```console
    $ xcode-select --install
    ```

    Se você ainda não instalou as ferramentas,
    um diálogo deve abrir confirmando que você gostaria de instalá-las.
    Clique em **Install**, então uma vez que a instalação esteja completa, clique em **Done**.

 1. <h3>Baixe e instale o Visual Studio Code</h3>

    Para instalar Flutter rapidamente, depois editar e depurar seus apps,
    [instale e configure o Visual Studio Code][vscode-install].

    Você pode, em vez disso, instalar e usar qualquer outro editor baseado em Code OSS
    que suporte extensões do VS Code.
    Se você escolher fazer isso, para o resto deste artigo,
    assuma que VS Code se refere ao editor de sua escolha.

{: .steps .macos-only}

 1. <h3>Instale o Git for Windows</h3>

    Baixe e instale a versão mais recente do [Git for Windows][].

    Para ajuda com a instalação ou solução de problemas do Git,
    consulte a [documentação do Git][git-install].

 1. <h3>Baixe e instale o Visual Studio Code</h3>

    Para instalar Flutter rapidamente, depois editar e depurar seus apps,
    [instale e configure o Visual Studio Code][vscode-install].

    Você pode, em vez disso, instalar e usar qualquer outro editor baseado em Code OSS
    que suporte extensões do VS Code.
    Se você escolher fazer isso, para o resto deste artigo,
    assuma que VS Code se refere ao editor de sua escolha.

{: .steps .windows-only}

 1. <h3>Baixe e instale os pacotes pré-requisito</h3>

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

 1. <h3>Baixe e instale o Visual Studio Code</h3>

    Para instalar Flutter rapidamente, depois editar e depurar seus apps,
    [instale e configure o Visual Studio Code][vscode-install].

    Você pode, em vez disso, instalar e usar qualquer outro editor baseado em Code OSS
    que suporte extensões do VS Code.
    Se você escolher fazer isso, para o resto deste artigo,
    assuma que VS Code se refere ao editor de sua escolha.

{: .steps .linux-only}

[chromeos-linux]: https://support.google.com/chromebook/answer/9145439
[chromeos-linux-update]: https://support.google.com/chromebook/answer/9145439?hl=en#:~:text=Fix%20problems%20with%20Linux
[Git for Windows]: https://git-scm.com/downloads/win
[git-install]: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
[vscode-install]: https://code.visualstudio.com/docs/setup/setup-overview

## Instale e configure Flutter {: #install}

Agora que você instalou Git e VS Code,
siga estes passos para usar VS Code para instalar e configurar Flutter.

:::note Baixe manualmente
Se você prefere instalar Flutter manualmente,
siga as instruções em [Instalar Flutter manualmente][Install Flutter manually].
:::

 1. <h3>Inicie o VS Code</h3>

    Se ainda não estiver aberto, abra o VS Code procurando por ele com Spotlight
    ou abrindo-o manualmente do diretório onde está instalado.

 1. <h3>Adicione a extensão Flutter ao VS Code</h3>

    Para adicionar as extensões Dart e Flutter ao VS Code,
    visite a [página do marketplace da extensão Flutter][flutter-vscode],
    então clique em **Install**.
    Se solicitado pelo seu navegador, permita que ele abra o VS Code.

 1. <h3>Instale Flutter com VS Code</h3>

    1. Abra a paleta de comandos no VS Code.

       Vá para **View** <span aria-label="and then">></span> **Command Palette**
       ou pressione <kbd class="special-key">Cmd/Ctrl</kbd> +
       <kbd>Shift</kbd> + <kbd>P</kbd>.

    1. Na paleta de comandos, digite `flutter`.

    1. Selecione **Flutter: New Project**.

    1. O VS Code solicita que você localize o Flutter SDK no seu computador.
       Selecione **Download SDK**.

    1. Quando o diálogo **Select Folder for Flutter SDK** aparecer,
       escolha onde você quer instalar Flutter.

    1. Clique em **Clone Flutter**.

       Enquanto baixa Flutter, o VS Code exibe esta notificação pop-up:

       ```console
       Downloading the Flutter SDK. This may take a few minutes.
       ```

       Este download leva alguns minutos.
       Se você suspeita que o download travou, clique em **Cancel** e então
       inicie a instalação novamente.

    1. Clique em **Add SDK to PATH**.

       Quando bem-sucedido, uma notificação é exibida:

       ```console
       The Flutter SDK was added to your PATH
       ```

    1. O VS Code pode exibir um aviso do Google Analytics.

       Se você concorda, clique em **OK**.

    1. Para garantir que Flutter esteja disponível em todos os terminais:

       1. Feche e então reabra todas as janelas de terminal.
       1. Reinicie o VS Code.

       {:type="a"}

 1. <h3>Solucione problemas de instalação</h3>

    Se você encontrar problemas durante a instalação,
    confira [Solução de problemas de instalação do Flutter][troubleshoot].

{:.steps}

[Install Flutter manually]: /install/manual
[flutter-vscode]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
[troubleshoot]: /install/troubleshoot

## Teste o Flutter {: #test-drive}

Agora que você configurou VS Code e Flutter,
é hora de criar um app e experimentar o desenvolvimento Flutter!

 1. <h3>Crie um novo app Flutter</h3>

    1. Abra a paleta de comandos no VS Code.

       Vá para **View** <span aria-label="and then">></span> **Command Palette**
       ou pressione <kbd class="special-key">Cmd/Ctrl</kbd> +
       <kbd>Shift</kbd> + <kbd>P</kbd>.

    1. Na paleta de comandos, comece digitando `flutter:`.

       O VS Code deve exibir comandos do plugin Flutter.

    1. Selecione o comando **Flutter: New Project**.

       Seu OS ou VS Code pode pedir acesso aos seus documentos,
       concorde para continuar para o próximo passo.

    1. Escolha o template **Application**.

       O VS Code deve solicitar **Which Flutter template?**.
       Escolha **Application** para inicializar um app contador simples.

    1. Crie ou selecione o diretório pai para a pasta do seu novo app.

       Um diálogo de arquivo deve aparecer.

       1. Selecione ou crie o diretório pai onde
          você quer que o projeto seja criado.
       1. Para confirmar sua seleção,
          clique em **Select a folder to create the project in**.

    1. Digite um nome para seu app.

       O VS Code deve solicitar que você digite um nome para seu novo app.
       Digite `trying_flutter` ou um nome similar `minúsculas_com_underscores`.
       Para confirmar sua seleção, pressione <kbd>Enter</kbd>.

    1. Aguarde a conclusão da inicialização do projeto.

       O progresso da tarefa geralmente é exibido como uma notificação no canto inferior direito
       e também pode ser acessado no painel **Output**.

    1. Abra o diretório `lib`, depois o arquivo `main.dart`.

       Se você está curioso sobre o que cada parte do código faz,
       confira os comentários anteriores ao longo do arquivo.

 1. <h3>Execute seu app na web</h3>

    Embora apps Flutter possam rodar em muitas plataformas,
    tente executar seu novo app na web.

    1. Abra a paleta de comandos no VS Code.

       Vá para **View** <span aria-label="and then">></span> **Command Palette**
       ou pressione <kbd class="special-key">Cmd/Ctrl</kbd> +
       <kbd>Shift</kbd> + <kbd>P</kbd>.

    1. Na paleta de comandos, comece digitando `flutter:`.

       O VS Code deve exibir comandos do plugin Flutter.

    1. Selecione o comando **Flutter: Select Device**.

    1. No prompt **Select Device**, selecione **Chrome**.

    1. Execute ou comece a depurar seu app.

       Vá para **Run** <span aria-label="and then">></span>
       **Start Debugging** ou pressione <kbd>F5</kbd>.

       `flutter run` é usado para compilar e iniciar seu app,
       então uma nova instância do Chrome deve abrir e
       começar a executar seu app recém-criado.

 1. <h3>Experimente hot reload</h3>

    Flutter oferece um ciclo de desenvolvimento rápido com **hot reload com estado**,
    a capacidade de recarregar o código de um app em execução sem
    reiniciar ou perder o estado do app.

    Você pode alterar o código-fonte do seu app,
    executar o comando hot reload no VS Code,
    e então ver a mudança no seu app em execução.

    1. No app em execução, tente adicionar ao contador algumas vezes
       clicando no botão ![incremento (+)][increment-button]{: .text-icon}.

    1. Com seu app ainda em execução, faça uma alteração no arquivo `lib/main.dart`.

       Altere a linha `_counter++` no método `_incrementCounter`
       para decrementar o campo `_counter`.

       ```dart diff
         setState(() {
           // ...
       -   _counter++;
       +   _counter--;
         });
       ```

    1. Salve suas alterações
       (**File** <span aria-label="and then">></span> **Save All**) ou
       clique no botão **Hot Reload** ![ícone hot reload][hot reload icon]{: .text-icon}.

       Flutter atualiza o app em execução sem perder nenhum estado existente.
       Observe que o valor existente permaneceu o mesmo.

    1. Tente clicar no botão
       ![incremento (+)][increment-button]{: .text-icon} novamente.
       Observe que o valor diminui em vez de aumentar.

 1. <h3>Explore a barra lateral do Flutter</h3>

    O plugin Flutter adiciona uma barra lateral dedicada ao VS Code
    para gerenciar sessões de depuração e dispositivos Flutter,
    visualizar um esboço do seu código e widgets,
    bem como acessar o Dart e Flutter DevTools.

    1. Se seu app não está em execução, inicie a depuração novamente.

       Vá para **Run** <span aria-label="and then">></span>
       **Start Debugging** ou pressione <kbd>F5</kbd>.

    1. Abra a barra lateral do Flutter no VS Code.

       Abra-a com o botão ![logo Flutter][Flutter logo]{: .text-icon} do Flutter na
       barra lateral do VS Code ou abra-a da paleta de comandos
       executando o comando **Flutter: Focus on Flutter Sidebar View**.

    1. Na barra lateral do Flutter, em **DevTools**,
       clique no botão **Flutter Inspector**.

       Um painel separado **Widget Inspector** deve abrir no VS Code.

       No widget inspector, você pode visualizar a árvore de widgets do seu app,
       ver as propriedades e layout de cada widget, e muito mais.

    1. No widget inspector, tente clicar no widget `MyHomePage` de nível superior.

       Uma visualização de suas propriedades e layout deve abrir, e
       o editor do VS Code deve navegar e focar na linha onde
       o widget foi incluído.

    1. Explore e experimente outros recursos no
       widget inspector e na barra lateral do Flutter.

{:.steps}

[increment-button]: /assets/images/docs/get-started/increment-button.png
[hot reload icon]: /assets/images/docs/get-started/hot-reload.svg
[Flutter logo]: /assets/images/branding/flutter/logo/square.svg

## Continue sua jornada Flutter {: #next-steps}

**Parabéns!**
Agora que você instalou e experimentou Flutter,
siga o codelab [Construindo seu primeiro app][Building your first app],
configure o desenvolvimento para uma [plataforma de destino adicional][additional target platform], ou
explore alguns desses recursos para continuar sua jornada de aprendizado Flutter.

{% render "docs/get-started/setup-next-steps.html", site: site %}

[Building your first app]: /get-started/codelab
[additional target platform]: /platform-integration#setup
