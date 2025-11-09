---
ia-translate: true
title: Configurar o desenvolvimento Windows
description: >-
  Configure seu ambiente de desenvolvimento para
  executar, compilar e implantar apps Flutter para Windows.
---

Aprenda como configurar seu ambiente de desenvolvimento
para executar, compilar e implantar apps Flutter para a plataforma desktop Windows.

:::note
Se você ainda não configurou o Flutter,
visite e siga o guia [Começar com Flutter][Get started with Flutter] primeiro.

Se você já instalou o Flutter,
certifique-se de que está [atualizado][up to date].
:::

[Get started with Flutter]: /get-started
[up to date]: /install/upgrade

## Configurar as ferramentas {: #set-up-tooling}

Com o [Visual Studio][vs], você pode executar apps Flutter no Windows, bem como
compilar e depurar código C e C++ nativo.

Note que **Visual Studio** é uma IDE separada do **Visual Studio _Code_**
e só é suportado no Windows.

1. <h3>Instalar o Visual Studio</h3>

   Se você ainda não fez isso,
   siga o guia da Microsoft para
   [instalar e configurar o Visual Studio][vs].

   Se você já instalou o Visual Studio,
   [atualize-o para a versão mais recente][vs-update].

1. <h3>Configurar workloads do Visual Studio</h3>

   Quando o instalador do Visual Studio solicitar que você escolha workloads,
   selecione e instale o workload **Desktop development with C++**.

   Se você já instalou o Visual Studio,
   siga o guia da Microsoft para
   [Modificar workloads do Visual Studio][vs-modify].

   :::tip
   Se estiver instalando com a linha de comando,
   o ID do workload **Desktop development with C++** é
   `Microsoft.VisualStudio.Workload.NativeDesktop`.
   :::

{: .steps}

[vs]: https://visualstudio.microsoft.com/
[vs-install]: https://learn.microsoft.com/en-us/visualstudio/install/install-visual-studio
[vs-update]: https://learn.microsoft.com/en-us/visualstudio/install/update-visual-studio
[vs-modify]: https://learn.microsoft.com/en-us/visualstudio/install/modify-visual-studio

## Validar sua configuração {: #validate-setup}

1. <h3>Verificar problemas na toolchain</h3>

   Para verificar quaisquer problemas com sua configuração de desenvolvimento Windows,
   execute o comando `flutter doctor` em seu terminal preferido:

   ```console
   $ flutter doctor -v
   ```

   Se você vir algum erro ou tarefas a completar nas
   seções **Windows version** e **Visual Studio - develop Windows apps**,
   complete e resolva-os, então
   execute `flutter doctor -v` novamente para verificar quaisquer alterações.

1. <h3>Verificar dispositivos Windows</h3>

   Para garantir que o Flutter possa encontrar e conectar ao seu dispositivo Windows corretamente,
   execute `flutter devices` em seu terminal preferido:

   ```console
   $ flutter devices
   ```

   Se você configurou tudo corretamente,
   deve haver pelo menos uma entrada com a plataforma marcada como **windows**.

1. <h3>Solucionar problemas de configuração</h3>

   Se você precisar de ajuda para resolver quaisquer problemas de configuração,
   consulte [solução de problemas de instalação e configuração][troubleshoot].
   Dependendo do seu problema,
   também consulte o guia da Microsoft sobre
   [Solução de problemas do Visual Studio][vs-troubleshoot].

   Se você ainda tiver problemas ou dúvidas,
   entre em contato em um dos canais da [comunidade][community] Flutter.

{: .steps}

[troubleshoot]: /install/troubleshoot
[vs-troubleshoot]: https://learn.microsoft.com/en-us/troubleshoot/developer/visualstudio/installation/troubleshoot-installation-issues
[community]: {{site.main-url}}/community

## Começar a desenvolver para Windows {: #start-developing}

Parabéns!
Agora que você configurou o desenvolvimento desktop Windows para Flutter,
você pode continuar sua jornada de aprendizado Flutter enquanto testa no Windows
ou começar a expandir a integração com Windows.

<div class="card-grid link-cards">
  <div class="card filled-card list-card">
    <div class="card-leading">
      <img src="/assets/images/decorative/pointing-the-way.png" height="160" aria-hidden="true" alt="Dash helping you explore Flutter learning resources.">
    </div>
    <div class="card-header">
      <span class="card-title">Continuar aprendendo Flutter</span>
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
      <img src="/assets/images/decorative/flutter-on-desktop.svg" height="160" aria-hidden="true" alt="An outline of Flutter desktop support.">
    </div>
    <div class="card-header">
      <span class="card-title">Construir para Windows</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/platform-integration/windows/building">Construa um app Windows</a>
        </li>
        <li>
          <a class="text-button" href="/deployment/windows">Implante no Windows</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/platform-channels">Escreva código específico para Windows</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/windows/building#customizing-the-windows-host-application">Personalize a janela do app</a>
        </li>
        <li>
          <a class="text-button" href="https://pub.dev/packages/win32">Acesse APIs Win32 com Dart</a>
        </li>
      </ul>
    </div>
  </div>
</div>
