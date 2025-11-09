---
ia-translate: true
title: Configure o desenvolvimento Linux
description: >-
  Configure seu ambiente de desenvolvimento para
  executar, compilar e implantar apps Flutter para desktop Linux.
---

Aprenda como configurar seu ambiente de desenvolvimento
para executar, compilar e implantar apps Flutter para a plataforma desktop Linux.

:::note
Se você ainda não configurou o Flutter,
visite e siga o guia [Get started with Flutter][Get started with Flutter] primeiro.

Se você já instalou o Flutter,
certifique-se de que ele está [up to date][up to date].
:::

[Get started with Flutter]: /get-started
[up to date]: /install/upgrade

## Configure as ferramentas {: #set-up-tooling}

Para executar e depurar apps desktop Flutter no Linux,
baixe e instale os pacotes pré-requisitos.

Usando seu gerenciador de pacotes ou mecanismo preferido,
instale as versões mais recentes dos seguintes pacotes:

- `clang`
- `cmake`
- `ninja-build`
- `pkg-config`
- `libgtk-3-dev`
- `libstdc++-12-dev`

Em distros baseadas em Debian com `apt-get`, como Ubuntu,
instale esses pacotes usando os seguintes comandos:

```console
$ sudo apt-get update -y && sudo apt-get upgrade -y
$ sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev libstdc++-12-dev
```

## Valide sua configuração {: #validate-setup}

 1. <h3>Verifique problemas na toolchain</h3>

    Para verificar quaisquer problemas com sua configuração de desenvolvimento Linux,
    execute o comando `flutter doctor` em seu terminal preferido:

    ```console
    $ flutter doctor -v
    ```

    Se você vir quaisquer erros ou tarefas para completar
    na seção **Linux toolchain**,
    complete e resolva-os, então
    execute `flutter doctor -v` novamente para verificar quaisquer mudanças.

 1. <h3>Verifique dispositivos Linux</h3>

    Para garantir que o Flutter possa encontrar e conectar ao seu dispositivo Linux corretamente,
    execute `flutter devices` em seu terminal preferido:

    ```console
    $ flutter devices
    ```

    Se você configurou tudo corretamente,
    deve haver pelo menos uma entrada com a plataforma marcada como **linux**.

 1. <h3>Solucione problemas de configuração</h3>

    Se você precisar de ajuda para resolver quaisquer problemas de configuração,
    confira [Install and setup troubleshooting][Install and setup troubleshooting].

    Se você ainda tiver problemas ou questões,
    entre em contato em um dos canais da [community][community] do Flutter.

{: .steps}

[Install and setup troubleshooting]: /install/troubleshoot
[community]: {{site.main-url}}/community

## Comece a desenvolver para Linux {: #start-developing}

Parabéns!
Agora que você configurou o desenvolvimento desktop Linux para Flutter,
você pode continuar sua jornada de aprendizado do Flutter enquanto testa no Linux
ou começar a expandir a integração com Linux.

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
      <span class="card-title">Build for Linux</span>
    </div>
    <div class="card-content">
      <ul>
        <li>
          <a class="text-button" href="/platform-integration/linux/building">Build a Linux app</a>
        </li>
        <li>
          <a class="text-button" href="/deployment/linux">Release a Linux app</a>
        </li>
        <li>
          <a class="text-button" href="/platform-integration/platform-channels">Write Linux-specific code</a>
        </li>
        <li>
          <a class="text-button" href="https://pub.dev/packages?q=platform%3Alinux+is%3Aplugin">Flutter plugins for Linux</a>
        </li>
        <li>
          <a class="text-button" href="https://github.com/ubuntu-flutter-community/yaru_tutorial">Design Ubuntu-themed apps</a>
        </li>
      </ul>
    </div>
  </div>
</div>
