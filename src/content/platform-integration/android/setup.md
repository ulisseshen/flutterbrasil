---
ia-translate: true
title: Configure o desenvolvimento Android
description: >-
  Configure seu ambiente de desenvolvimento para
  executar, fazer build e implantar apps Flutter para dispositivos Android.
---

Aprenda como configurar seu ambiente de desenvolvimento
para executar, fazer build e implantar apps Flutter para dispositivos Android.

:::note
Se você ainda não configurou o Flutter,
visite e siga o guia [Get started with Flutter][Get started with Flutter] primeiro.

Se você já instalou o Flutter,
certifique-se de que está [atualizado][up to date].
:::

[Get started with Flutter]: /get-started
[up to date]: /install/upgrade

## Escolha sua plataforma de desenvolvimento {: #dev-platform}

As instruções nesta página estão configuradas para cobrir
a configuração do desenvolvimento Android em um dispositivo **Windows**{:.selected-os-text}.

Se você gostaria de seguir as instruções para um sistema operacional diferente,
por favor selecione um dos seguintes.

<OSSelector />

## Configure as ferramentas Android {: #set-up-tooling}

Com o Android Studio, você pode executar apps Flutter em
um dispositivo Android físico ou um Android Emulator.

Se você ainda não fez isso,
instale e configure a última versão estável do [Android Studio][Android Studio].

 1. <h3>Instale bibliotecas de pré-requisitos</h3>

    Se você está desenvolvendo no Linux, primeiro instale a
    [coleção de pré-requisitos de bibliotecas de 32 bits][64bit-libs]
    que o Android Studio requer.
    {: .linux-only}

 1. <h3>Instale o Android Studio</h3>

    Se você ainda não fez isso, [instale e configure][as-install]
    a última versão estável do [Android Studio][Android Studio].

    Se você já tem o Android Studio instalado,
    certifique-se de que está [atualizado][as-update].

 1. <h3>Instale Android SDK e ferramentas</h3>

    1. Inicie o **Android Studio**.

    1. Abra o diálogo de configurações **SDK Manager**.

       1. Se o diálogo **Welcome to Android Studio** estiver aberto,
          clique no botão **More Actions** que segue os
          botões **New Project** e **Open**,
          então clique em **SDK Manager** no menu dropdown.

       1. Se você tem um projeto aberto,
          vá para **Tools** <span aria-label="and then">></span> **SDK Manager**.

       {: type="a"}

    1. Se a aba **SDK Platforms** não estiver aberta, mude para ela.

    1. Verifique se a primeira entrada com um **API Level** de
       **36** foi selecionada.

       Se a coluna **Status** exibir
       **Update available** ou **Not installed**:

       1. Selecione a checkbox para essa entrada ou linha.

       1. Clique em **Apply**.

       1. Quando o diálogo **Confirm Change** aparecer, clique em **OK**.

          O diálogo **SDK Component Installer** aparece com um
          indicador de progresso.

       1. Quando a instalação terminar, clique em **Finish**.

       {: type="a"}

    1. Mude para a aba **SDK Tools**.

    1. Verifique se as seguintes SDK Tools foram selecionadas:

       - **Android SDK Build-Tools**
       - **Android SDK Command-line Tools**
       - **Android Emulator**
       - **Android SDK Platform-Tools**

    1. Se a coluna **Status** para qualquer uma das ferramentas anteriores exibir
       **Update available** ou **Not installed**:

       1. Selecione a checkbox para as ferramentas necessárias.

       1. Clique em **Apply**.

       1. Quando o diálogo **Confirm Change** aparecer, clique em **OK**.

          O diálogo **SDK Component Installer** aparece com um
          indicador de progresso.

       1. Quando a instalação terminar, clique em **Finish**.

       {: type="a"}

   1. <h3>Aceite as licenças Android</h3>

      Antes de poder usar o Flutter e após instalar todos os pré-requisitos,
      aceite as licenças da plataforma Android SDK.

      1. Abra seu terminal preferido.

      1. Execute o seguinte comando para revisar e assinar as licenças do SDK.

         ```console
         $ flutter doctor --android-licenses
         ```

      1. Leia e aceite quaisquer licenças necessárias.

         Se você não aceitou cada uma das licenças do SDK anteriormente,
         você precisará revisá-las e concordar com elas antes de desenvolver para Android.

         Antes de concordar com os termos de cada licença,
         leia cada uma com cuidado.

         Uma vez que você aceitou todas as licenças necessárias com sucesso,
         você deve ver uma saída similar à seguinte:

         ```console
         All SDK package licenses accepted.
         ```

{: .steps}

[Android Studio]: https://developer.android.com/studio
[64bit-libs]: https://developer.android.com/studio/install#64bit-libs
[as-install]: https://developer.android.com/studio/install
[as-update]: https://developer.android.com/studio/intro/update

## Configure um dispositivo Android {: #set-up-devices}

Você pode debugar apps Flutter em dispositivos Android físicos ou
executando-os em um emulador Android.

<Tabs key="android-emulator-or-not">
<Tab name="Android emulator">

Para configurar seu ambiente de desenvolvimento para
executar um app Flutter em um emulador Android, siga estas etapas:

 1. <h3>Configure seu dispositivo de desenvolvimento</h3>

    Habilite [aceleração de VM][VM acceleration] em seu computador de desenvolvimento.

 1. <h3>Configure um novo emulador</h3>

    1. Inicie o **Android Studio**.

    1. Abra o diálogo de configurações **Device Manager**.

       1. Se o diálogo **Welcome to Android Studio** estiver aberto,
          clique no botão **More Actions** que segue os
          botões **New Project** e **Open**,
          então selecione **Virtual Device Manager** no menu dropdown.

       1. Se você tem um projeto aberto,
          vá para **Tools** <span aria-label="and then">></span>
          **Device Manager**.

       {: type="a"}

    1. Clique no botão **Create Virtual Device** que aparece como um ícone `+`.

       O diálogo **Virtual Device Configuration** é exibido.

    1. Selecione **Phone** ou **Tablet** em **Form Factor**.

    1. Selecione uma definição de dispositivo. Você pode navegar ou pesquisar pelo dispositivo.

    1. Clique em **Next**.

    1. Se a opção for fornecida,
       selecione **x86 Images** ou **ARM Images** dependendo de
       se seu computador de desenvolvimento é um dispositivo x64 ou Arm64.

    1. Selecione uma imagem de sistema para a versão Android que você quer emular.

       1. Se a imagem desejada tem um ícone **Download** à esquerda
          do nome da imagem do sistema, clique nele.

          O diálogo **SDK Component Installer** é exibido com um
          indicador de progresso.

       1. Quando o download completar, clique em **Finish**.

       {: type="a"}

    1. Clique em **Additional settings** na barra de abas superior e
       role até **Emulated Performance**.

    1. No menu dropdown **Graphics acceleration**,
       selecione uma opção que mencione **Hardware**.

       Isso habilita [aceleração de hardware][hardware acceleration], melhorando a performance de renderização.

    1. Verifique sua configuração de dispositivo virtual.
       Se estiver correta, clique em **Finish**.

       Para aprender mais sobre dispositivos virtuais,
       confira [Create and manage virtual devices][Create and manage virtual devices].

 1. <h3>Tente executar o emulador</h3>

    No diálogo **Device Manager**,
    clique no ícone **Run** à direita do seu dispositivo virtual desejado.

    O emulador deve iniciar e exibir o canvas padrão para
    sua versão de sistema operacional Android selecionada e dispositivo.

{: .steps}

[VM acceleration]: {{site.android-dev}}/studio/run/emulator-acceleration#accel-vm
[hardware acceleration]: {{site.android-dev}}/studio/run/emulator-acceleration
[Create and manage virtual devices]: {{site.android-dev}}/studio/run/managing-avds

</Tab>
<Tab name="Physical device">

Para configurar seu ambiente de desenvolvimento para
executar um app Flutter em um dispositivo Android físico, siga estas etapas:

 1. <h3>Configure seu dispositivo</h3>

    Habilite **Developer options** e **USB debugging** em seu dispositivo
    como descrito em [Configure on-device developer options][Configure on-device developer options].

 1. <h3>Habilite depuração sem fio</h3>

    Para aproveitar a depuração sem fio,
    habilite **Wireless debugging** em seu dispositivo como descrito em
    [Connect to your device using Wi-Fi][Connect to your device using Wi-Fi].
    {: .windows-only}

 1. <h3>Instale pré-requisitos de plataforma</h3>

    Se você está desenvolvendo no Windows, primeiro instale o
    driver USB necessário para seu dispositivo particular como descrito em
    [Install OEM USB drivers][Install OEM USB drivers].

 1. <h3>Conecte seu dispositivo</h3>

    Conecte seu dispositivo ao seu computador.
    Se seu dispositivo solicitar,
    autorize seu computador a acessar seu dispositivo Android.

 1. <h3>Verifique a conexão do dispositivo</h3>

    Para verificar se o Flutter reconhece seu dispositivo Android conectado,
    execute `flutter devices` em seu terminal preferido:

    ```console
    $ flutter devices
    ```

    Seu dispositivo deve ser encontrado e aparecer como um dispositivo conectado.

{: .steps}

[Configure on-device developer options]: {{site.android-dev}}/studio/debug/dev-options
[Connect to your device using Wi-Fi]: {{site.android-dev}}/studio/run/device#wireless
[Install OEM USB drivers]: {{site.android-dev}}/studio/run/oem-usb

</Tab>
</Tabs>

## Valide sua configuração {: #validate-setup}

 1. <h3>Verifique problemas na toolchain</h3>

    Para verificar quaisquer problemas com sua configuração de desenvolvimento Android,
    execute o comando `flutter doctor` em seu terminal preferido:

    ```console
    $ flutter doctor
    ```

    Se você ver quaisquer erros ou tarefas a completar nas
    seções **Android toolchain** ou **Android Studio**,

    Complete quaisquer tarefas mencionadas e então
    execute `flutter doctor` novamente para verificar quaisquer alterações.

 1. <h3>Verifique dispositivos Android</h3>

    Para garantir que você configurou seu emulador e/ou dispositivo Android físico corretamente,
    execute `flutter emulators` e `flutter devices` em seu terminal preferido:

    ```console
    $ flutter emulators && flutter devices
    ```

    Dependendo se você configurou um emulador ou um dispositivo,
    pelo menos um deve exibir uma entrada com a plataforma marcada como **android**.

 1. <h3>Solucione problemas de configuração</h3>

    Se você precisa de ajuda para resolver quaisquer problemas de configuração,
    confira [Install and setup troubleshooting][Install and setup troubleshooting].

    Se você ainda tem problemas ou perguntas,
    entre em contato em um dos canais da [comunidade][community] Flutter.

{: .steps}

[Install and setup troubleshooting]: /install/troubleshoot#android-setup
[community]: {{site.main-url}}/community

## Comece a desenvolver para Android {: #start-developing}

Parabéns!
Agora que você configurou o desenvolvimento Android para Flutter,
você pode continuar sua jornada de aprendizado Flutter enquanto testa no Android
ou começar a melhorar a integração com Android.

<div class="card-grid link-cards">
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/pointing-the-way.png" height="160" aria-hidden="true" alt="Dash helping you explore Flutter learning resources.">
    </div>
    <div class="card-header">
      <span class="card-title">Continue aprendendo Flutter</span>
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
        <li>
          <a class="text-button" href="/reference/learning-resources">Confira exemplos</a>
        </li>
        <li>
          <a class="text-button" href="/resources/bootstrap-into-dart">Aprenda sobre Dart</a>
        </li>
      </ul>
    </div>
  </div>
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/flutter-on-phone.svg" height="160" aria-hidden="true" alt="A representation of Flutter on multiple devices.">
    </div>
    <div class="card-header">
      <span class="card-title">Construa para Android</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/deployment/android">Faça build e implante para Android</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/android/c-interop">Vincule a código Android nativo</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/android/splash-screen">Adicione uma splash screen</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/android/platform-views">Incorpore views Android nativas</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/android/predictive-back">Suporte predictive back</a>
        </li>
      </ul>
    </div>
  </div>
</div>
