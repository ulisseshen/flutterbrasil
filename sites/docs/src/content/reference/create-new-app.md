---
ia-translate: true
title: Criar um novo app Flutter
shortTitle: Criar um novo app
description: >-
  Aprenda como inicializar uma nova aplicação Flutter a partir da
  sua linha de comando, diferentes editores e até na nuvem.
showBreadcrumbs: false
---

Esta página fornece instruções passo a passo sobre como
inicializar um novo app Flutter no seu ambiente de desenvolvimento preferido.

Para criar um novo app Flutter, primeiro [configure o Flutter][flutter-setup], então
escolha seu ambiente preferido e siga as instruções correspondentes.

<div class="card-grid">
  <a class="card outlined-card" href="#vs-code">
    <div class="card-header">
      <span class="card-title">VS Code</span>
    </div>
    <div class="card-content">
      <p>Crie um novo app Flutter sem sair do VS Code.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#android-studio">
    <div class="card-header">
      <span class="card-title">Android Studio</span>
    </div>
    <div class="card-content">
      <p>Crie um novo app Flutter sem sair do Android Studio.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#intellij">
    <div class="card-header">
      <span class="card-title">IntelliJ</span>
    </div>
    <div class="card-content">
      <p>Crie um novo app Flutter sem sair do seu IDE baseado em IntelliJ.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#antigravity">
    <div class="card-header">
      <span class="card-title">Antigravity</span>
    </div>
    <div class="card-content">
      <p>Para suporte a programação agêntica, crie um novo app Flutter no Antigravity.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#terminal">
    <div class="card-header">
      <span class="card-title">Terminal</span>
    </div>
    <div class="card-content">
      <p>Para máxima flexibilidade, crie um novo app Flutter a partir da linha de comando.</p>
    </div>
  </a>
  <a class="card outlined-card" href="/add-to-app#get-started">
    <div class="card-header">
      <span class="card-title">
        <span>Add to app</span>
        <Icon id="open_in_new" size="1rem" />
      </span>
    </div>
    <div class="card-content">
      <p>Crie um novo módulo Flutter para incorporar em um app existente.</p>
    </div>
  </a>
</div>

## VS Code

Para criar um app Flutter com [VS Code][] e outros editores baseados em Code OSS,
você primeiro precisa [instalar o Flutter][flutter-setup] e
[configurar o VS Code][vscode-setup] para desenvolvimento Flutter.
Então siga estes passos:

 1. <h3>Inicie o VS Code</h3>

    Abra o VS Code ou seu editor baseado em Code OSS preferido.

 1. <h3>Abra a paleta de comandos</h3>

    Vá para **View** <span aria-label="e então">></span> **Command Palette** ou
    pressione <kbd class="special-key">Cmd/Ctrl</kbd> +
    <kbd>Shift</kbd> + <kbd>P</kbd>.

 1. <h3>Encontre os comandos Flutter</h3>

    Na paleta de comandos, comece a digitar `flutter:`.
    O VS Code deve sugerir comandos do plugin Flutter.

 1. <h3>Execute o comando de novo projeto</h3>

    Selecione o comando **Flutter: New Project**.
    Seu SO ou VS Code pode solicitar acesso aos seus documentos,
    concorde para continuar para o próximo passo.

 1. <h3>Escolha um template</h3>

    O VS Code deve solicitar **Which Flutter template?**.
    Dependendo do tipo de projeto Flutter que você quer criar,
    escolha o template correspondente.
    Para um novo app Flutter, escolha **Application**.

 1. <h3>Selecione um local para o projeto</h3>

    Uma janela de diálogo de arquivo deve aparecer.
    Selecione ou crie o diretório pai onde
    você quer que o projeto seja criado.
    Não crie a pasta do projeto em si, a ferramenta Flutter faz isso.
    Para confirmar sua seleção,
    clique em **Select a folder to create the project in**.

 1. <h3>Digite um nome de projeto</h3>

    O VS Code deve solicitar que você digite um nome para seu novo projeto.
    Digite um nome para seu app que siga a convenção de nomenclatura `lowercase_with_underscores`,
    seguindo as diretrizes do [Effective Dart][package-name].
    Para confirmar sua seleção, pressione <kbd>Enter</kbd>.

 1. <h3>Aguarde a inicialização do projeto</h3>

    Baseado nas informações que você inseriu,
    o VS Code usa `flutter create` para inicializar seu app.
    O progresso geralmente é exibido como uma notificação no canto inferior direito
    e também pode ser acessado no painel **Output**.

 1. <h3>Execute seu app</h3>

    Seu novo app agora deve estar criado e aberto no VS Code.
    Para experimentar seu novo app,
    siga os passos para [executar e depurar][vscode-run] no VS Code.

{:.steps}

Você criou com sucesso um novo app Flutter no VS Code!
Se você precisar de mais ajuda com desenvolvimento Flutter no VS Code,
confira a [referência do VS Code para Flutter][vscode-more].

[VS Code]: https://code.visualstudio.com/
[vscode-setup]: /tools/vs-code#installation-and-setup
[vscode-run]: /tools/vs-code#running-and-debugging
[vscode-more]: /tools/vs-code

## Android Studio

Para criar um app Flutter com Android Studio,
você primeiro precisa [instalar o Flutter][flutter-setup] e
[configurar o Android Studio][as-setup] para desenvolvimento Flutter.
Então siga estes passos:

 1. <h3>Inicie o Android Studio</h3>

    Abra o Android Studio com os plugins Dart e Flutter instalados.

 1. <h3>Inicie a criação do projeto</h3>

    Se você estiver na janela de boas-vindas da IDE que diz **Welcome to Android Studio**,
    encontre e clique no botão **New Flutter Project** no centro.

    Se você já tem um projeto aberto, feche-o ou
    vá para **File** <span aria-label="e então">></span> **New**
    <span aria-label="e então">></span> **New Flutter Project...**.

 1. <h3>Escolha um tipo de projeto</h3>

    Na janela **New Project**, em **Generators** no painel esquerdo,
    selecione **Flutter**.

 1. <h3>Verifique a configuração do Flutter SDK</h3>

    No topo do painel direito, certifique-se de que o valor de **Flutter SDK path** corresponde
    à localização do Flutter SDK com o qual você gostaria de desenvolver.
    Se não, atualize escolhendo ou especificando o correto.

 1. <h3>Configure seu projeto</h3>

    Clique em **Next** para continuar para a configuração do projeto.
    Várias opções de configuração devem aparecer.

    No campo **Project name**, digite um nome para seu app que
    siga a convenção de nomenclatura `lowercase_with_underscores`,
    seguindo as diretrizes do [Effective Dart][package-name].

    Se você não está criando uma aplicação,
    selecione outro template no dropdown **Project type**.

    Se você está criando um app que pode publicar no futuro,
    defina o campo **Organization** [para o domínio da sua empresa][as-set-org].

    Os outros campos podem ser mantidos como estão ou
    configurados de acordo com as necessidades do seu projeto.

 1. <h3>Finalize a criação do projeto</h3>

    Uma vez que você completou a configuração do seu projeto,
    clique em **Create** para iniciar a inicialização do projeto.

 1. <h3>Aguarde a inicialização do workspace</h3>

    O Android Studio agora inicializará seu workspace,
    inicializará a estrutura de arquivos do seu projeto,
    e recuperará as dependências do seu app.
    Isso pode levar um tempo e pode ser acompanhado na parte inferior da janela.

 1. <h3>Execute seu app</h3>

    Seu novo app agora deve estar criado e aberto no Android Studio.
    Para experimentar seu novo app,
    siga os passos para [executar e depurar][as-run] no Android Studio.

{:.steps}

Você criou com sucesso um novo app Flutter no Android Studio!
Se você precisar de mais ajuda com desenvolvimento Flutter no Android Studio,
confira a [referência do Android Studio para Flutter][as-more].

[as-setup]: /tools/android-studio#installation-and-setup
[as-set-org]: /tools/android-studio#set-the-company-domain
[as-run]: /tools/android-studio#running-and-debugging
[as-more]: /tools/android-studio

## IntelliJ

Para criar um app Flutter com IntelliJ ou outras IDEs JetBrains,
você primeiro precisa [instalar o Flutter][flutter-setup] e
[configurar o IntelliJ][ij-setup] para desenvolvimento Flutter.
Então siga estes passos:

 1. <h3>Inicie o IntelliJ</h3>

    Abra o IntelliJ IDEA ou sua IDE baseada em IntelliJ preferida da JetBrains
    que tenha os plugins Dart e Flutter instalados.

 1. <h3>Inicie a criação do projeto</h3>

    Se você estiver na janela de boas-vindas da IDE que diz **Welcome to IntelliJ IDEA**,
    encontre e clique no botão **New Project** no canto superior direito.

    Se você já tem um projeto aberto, feche-o ou
    vá para **File** <span aria-label="e então">></span> **New**
    <span aria-label="e então">></span> **New Project...**.

 1. <h3>Escolha um tipo de projeto</h3>

    Na janela **New Project**, em **Generators** no painel esquerdo,
    selecione **Flutter**.

 1. <h3>Verifique a configuração do Flutter SDK</h3>

    No topo do painel direito, certifique-se de que o valor de **Flutter SDK path** corresponde
    à localização do Flutter SDK com o qual você gostaria de desenvolver.
    Se não, atualize escolhendo ou especificando o correto.

 1. <h3>Configure seu projeto</h3>

    Clique em **Next** para continuar para a configuração do projeto.
    Várias opções de configuração devem aparecer.

    No campo **Project name**, digite um nome para seu app que
    siga a convenção de nomenclatura `lowercase_with_underscores`,
    seguindo as diretrizes do [Effective Dart][package-name].

    Se você não está criando uma aplicação,
    selecione outro template no dropdown **Project type**.

    Se você está criando um app que pode publicar no futuro,
    defina o campo **Organization** [para o domínio da sua empresa][ij-set-org].

    Os outros campos podem ser mantidos como estão ou
    configurados de acordo com as necessidades do seu projeto.

 1. <h3>Finalize a criação do projeto</h3>

    Uma vez que você completou a configuração do seu projeto,
    clique em **Create** para iniciar a inicialização do projeto.

 1. <h3>Aguarde a inicialização do workspace</h3>

    O IntelliJ agora inicializará seu workspace,
    inicializará a estrutura de arquivos do seu projeto,
    e recuperará as dependências do seu app.
    Isso pode levar um tempo e pode ser acompanhado na parte inferior da janela.

 1. <h3>Execute seu app</h3>

    Seu novo app agora deve estar criado e aberto no IntelliJ.
    Para experimentar seu novo app,
    siga os passos para [executar e depurar][ij-run] no IntelliJ.

{:.steps}

Você criou com sucesso um novo app Flutter no IntelliJ!
Se você precisar de mais ajuda com desenvolvimento Flutter no IntelliJ,
confira a [referência do IntelliJ para Flutter][ij-more].

[ij-setup]: /tools/android-studio#installation-and-setup
[ij-set-org]: /tools/android-studio#set-the-company-domain
[ij-more]: /tools/android-studio
[ij-run]: /tools/android-studio#running-and-debugging

<a id="project-idx" aria-hidden="true"></a>

## Antigravity

Para criar um app Flutter com o Antigravity, você primeiro precisa
instalar e configurar o Antigravity conforme descrito em
[Primeiros passos com IA](/ai/get-started).
Então siga estes passos:

 1. <h3>Abra o Antigravity e crie um Workspace</h3>

    Inicie o IDE Antigravity e crie um novo
    workspace isolado (sandbox) para o seu projeto usando o Agent Manager.

 1. <h3>Use o Agent Manager</h3>

    Mude para a interface do Agent Manager,
    que é onde você interage com os agentes de IA usando chat.

 1. <h3>Escreva prompts detalhados</h3>

    Comunique os requisitos do seu app ao agente usando prompts detalhados
    e estruturados, de forma parecida com dar instruções a um desenvolvedor júnior.
    Por exemplo, "Create a new Flutter project named my_app.
    Add a home screen with a list of items and a floating action button".

 1. <h3>Revise e aprove o plano</h3>

    O agente de IA vai gerar um plano de implementação detalhado,
    incluindo estrutura de pastas, dependências e etapas.
    Você pode revisar esse plano e clicar em **Proceed** ou
    fornecer feedback para fazer alterações.

 1. <h3>Autorize ações</h3>

    O agente vai pedir permissão antes de executar comandos no terminal
    (como `flutter pub add` ou `flutter create`) ou acessar o navegador/emulador.
    Revise e clique em **Accept** nessas ações para permitir que o agente construa o app.

 1. <h3>Itere e refine</h3>

    Depois que o app inicial for gerado,
    você pode fornecer mais prompts para adicionar funcionalidades,
    refinar a UI, implementar lógica ou adicionar persistência
    (por exemplo, "Add local storage using shared_preferences").

 1. <h3>Teste o app</h3>

    Use o emulador integrado ou conecte um dispositivo físico
    para testar o app. O agente pode até executar testes e fornecer
    vídeos demonstrando a funcionalidade.

 1. <h3>Verifique o código no editor</h3>

    Você pode mudar para a visualização padrão do editor de código a qualquer momento
    para inspecionar os arquivos Dart e Flutter gerados,
    garantindo que a qualidade do código atenda aos seus padrões.

{:.steps}

## Terminal

Para criar um app Flutter no seu terminal,
você primeiro precisa instalar e [configurar o Flutter][flutter-setup].
Então siga estes passos:

 1. <h3>Abra seu terminal</h3>

    Abra seu método preferido para acessar a linha de comando,
    como Terminal no macOS ou PowerShell no Windows.

 1. <h3>Navegue para o diretório desejado</h3>

    Certifique-se de que seu diretório de trabalho atual
    seja o diretório pai desejado para seu novo app.
    Não crie a pasta do projeto, a ferramenta `flutter` fará isso.

 1. <h3>Configure a criação do projeto</h3>

    No seu terminal, digite o comando `flutter create` e
    passe quaisquer flags e opções desejadas para configurar seu projeto.
    Por exemplo, para criar um app com um arquivo `main.dart` mínimo,
    você pode adicionar a opção `--empty`:

    ```console
    $ flutter create --empty
    ```

    Para aprender sobre as opções de criação disponíveis,
    execute `flutter create --help` em outra janela de terminal.

 1. <h3>Digite um nome de projeto</h3>

    Como o único argumento sem opção para `flutter create`,
    especifique o diretório e nome padrão para sua aplicação.
    O nome deve seguir a convenção de nomenclatura `lowercase_with_underscores`,
    seguindo as diretrizes do [Effective Dart][package-name].

    Por exemplo, se você quisesse criar um app chamado `my_app`:

    ```console
    $ flutter create my_app
    ```

 1. <h3>Execute o comando configurado</h3>

    Para criar um projeto com sua configuração especificada,
    execute o comando que você construiu no passo anterior.

 1. <h3>Aguarde a inicialização do projeto</h3>

    A ferramenta `flutter` agora inicializará a estrutura de arquivos do seu projeto
    e recuperará quaisquer dependências necessárias.
    Isso pode levar um tempo.

 1. <h3>Navegue para o diretório do projeto</h3>

    Agora que seu projeto foi criado,
    você pode navegar até ele no seu terminal ou no seu editor preferido.
    Por exemplo, com um shell bash e um projeto chamado `my_app`:

    ```console
    $ cd my_app
    ```

 1. <h3>Execute seu app</h3>

    Para experimentar seu novo app,
    execute o comando `flutter run` no seu terminal e
    responda aos prompts para selecionar um dispositivo de saída.

{:.steps}

Você criou com sucesso um novo app Flutter no seu terminal!
Se você precisar de ajuda configurando seu projeto ou com a ferramenta CLI `flutter`,
confira a [referência do Flutter CLI][cli-reference].

[cli-reference]: /reference/flutter-cli

[flutter-setup]: /install
[package-name]: {{site.dart-site}}/effective-dart/style#do-name-packages-and-file-system-entities-using-lowercase-with-underscores
