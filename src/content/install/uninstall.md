---
title: Desinstalar Flutter
shortTitle: Desinstalar
description: >-
    Como remover o Flutter SDK e limpar seus arquivos de configuração.
showToc: false
ia-translate: true
---

Para remover o Flutter SDK da sua máquina de desenvolvimento,
exclua os diretórios que armazenam o Flutter e seus arquivos de configuração.

## Escolha sua plataforma de desenvolvimento {: #dev-platform }

As instruções nesta página estão configuradas para cobrir
desinstalar o Flutter em um dispositivo **Windows**{:.selected-os-text}.

Se você gostaria de seguir as instruções para um SO diferente,
por favor selecione um dos seguintes.

<OSSelector />

## Desinstalar o Flutter SDK {: #uninstall }

 1. <h3>Determine a localização da instalação do Flutter SDK</h3>

    Copie o caminho absoluto para o diretório em que você
    baixou e extraiu o Flutter SDK.

 1. <h3>Remova o diretório de instalação</h3>

    Para desinstalar o Flutter SDK,
    exclua o diretório `flutter` em que você instalou o Flutter.

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop\flutter` dentro do seu diretório de usuário,
    execute o seguinte comando para excluir o SDK:

    ```ps
    $ Remove-Item -Recurse -Force -Path (Join-Path $env:USERPROFILE "develop\flutter")
    ```

{: .steps .windows-only}

 1. <h3>Determine a localização da instalação do Flutter SDK</h3>

    Copie o caminho absoluto para o diretório em que você
    baixou e extraiu o Flutter SDK.

 1. <h3>Remova o diretório de instalação</h3>

    Para desinstalar o Flutter SDK,
    exclua o diretório `flutter` em que você instalou o Flutter.

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    execute o seguinte comando para excluir o SDK:

    ```console
    $ rm -rf ~/develop/flutter
    ```

{: .steps .macos-only .linux-only .chromeos-only }

## Limpar arquivos de instalação e configuração {: #cleanup }

O Flutter e o Dart adicionam a diretórios adicionais em seu diretório home.
Estes contêm arquivos de configuração e downloads de pacotes.
A seguinte limpeza é opcional.

 1. <h3>Remova diretórios de configuração do Flutter</h3>

    Se você não deseja preservar sua configuração de ferramentas do Flutter,
    remova os seguintes diretórios do seu dispositivo.

    <div class="windows-only">

    - `%APPDATA%\.flutter-devtools`

    Para remover esses diretórios, execute o seguinte comando:

    ```ps
    $ Remove-Item -Recurse -Force -Path (Join-Path $env:APPDATA ".flutter-devtools")
    ```

    </div>

    <div class="macos-only linux-only chromeos-only">

    - `~/.flutter`
    - `~/.flutter-devtools`
    - `~/.flutter_settings`

    Para remover esses diretórios, execute o seguinte comando:

    ```ps
    $ rm -rf  ~/.flutter ~/.flutter-devtools ~/.flutter_settings
    ```

    </div>

 1. <h3>Remova diretórios de configuração do Dart</h3>

    Se você não deseja preservar sua configuração de ferramentas do Dart,
    remova os seguintes diretórios do seu dispositivo.

    <div class="windows-only">

    - `%APPDATA%\.dart`
    - `%APPDATA%\.dart-tool`
    - `%LOCALAPPDATA%\.dartServer`

    Para remover esses diretórios, execute o seguinte comando:

    ```console
    $ Remove-Item -Recurse -Force -Path (Join-Path $env:APPDATA ".dart"), (Join-Path $env:APPDATA ".dart-tool"), (Join-Path $env:LOCALAPPDATA ".dartServer")
    ```

    </div>

    <div class="macos-only linux-only chromeos-only">

    - `~/.dart`
    - `~/.dart-tool`
    - `~/.dartServer`

    Para remover esses diretórios, execute o seguinte comando:

    ```console
    $ rm -rf  ~/.dart ~/.dart-tool ~/.dartServer
    ```

    </div>

 1. <h3>Remova diretórios de pacotes pub</h3>

    Se você não deseja preservar seus pacotes pub instalados localmente,
    remova o diretório de [pub system cache][] do seu dispositivo.

    <div class="windows-only">

    Se você não alterou a localização do cache do sistema pub,
    execute o seguinte comando para
    excluir o diretório `%LOCALAPPDATA%\Pub\Cache`:

    ```ps
    $ Remove-Item -Recurse -Force -Path (Join-Path $env:LOCALAPPDATA "Pub\Cache")
    ```

    </div>

    <div class="macos-only linux-only chromeos-only">

    Se você não alterou a localização do cache do sistema pub,
    execute o seguinte comando para excluir o diretório `~/.pub-cache`:

    ```console
    $ rm -rf ~/.pub-cache
    ```

    </div>

{: .steps }

[pub system cache]: {{site.dart-site}}/tools/pub/glossary#system-cache

## Reinstalar Flutter {: #reinstall }

Você pode [reinstalar o Flutter][flutter-install] ou
[apenas o Dart][dart-install] a qualquer momento.
Se você removeu quaisquer diretórios de configuração,
reinstalar o Flutter os restaura para as configurações padrão.

[flutter-install]: /install
[dart-install]: {{site.dart-site}}/get-dart
