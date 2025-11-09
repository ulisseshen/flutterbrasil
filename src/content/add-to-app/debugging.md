---
ia-translate: true
title: Depure seu módulo add-to-app
shortTitle: Depuração
description: Como executar, depurar e fazer hot reload do seu módulo Flutter add-to-app.
---

Depois de integrar o módulo Flutter ao seu projeto e usar
as APIs de plataforma do Flutter para executar o engine Flutter e/ou UI,
você pode então compilar e executar seu app Android ou iOS da mesma forma
que você executa apps Android ou iOS normais.

Flutter agora alimenta a UI onde quer que seu código inclua
`FlutterActivity` ou `FlutterViewController`.

## Visão geral

Você pode estar acostumado a ter seu conjunto de ferramentas de depuração
favoritas do Flutter disponíveis ao executar `flutter run` ou um comando
equivalente de uma IDE. Mas você também pode usar todas as suas
[funcionalidades de depuração][debugging functionalities] do Flutter, como
hot reload, overlays de desempenho, DevTools e definição de breakpoints em
cenários add-to-app.

O comando `flutter attach` fornece essas funcionalidades.
Para executar este comando, você pode usar as ferramentas CLI do SDK, VS Code
ou IntelliJ IDEA ou Android Studio.

O comando `flutter attach` se conecta assim que você executa seu `FlutterEngine`.
Ele permanece conectado até você descartar seu `FlutterEngine`.
Você pode invocar `flutter attach` antes de iniciar seu engine.
O comando `flutter attach` aguarda a próxima Dart VM disponível que
seu engine hospeda.

## Depure a partir do Terminal

Para conectar a partir do terminal, execute `flutter attach`.
Para selecionar um dispositivo de destino específico, adicione `-d <deviceId>`.

```console
$ flutter attach
```

O comando deve imprimir uma saída semelhante à seguinte:

```console
Syncing files to device iPhone 15 Pro...
 7,738ms (!)

To hot reload the changes while running, press "r".
To hot restart (and rebuild state). press "R".
```

## Depure extensão iOS no Xcode e VS Code

{% render "docs/debug/debug-flow-ios.md", add:'launch' %}

## Depure extensão Android no Android Studio

{% render "docs/debug/debug-flow-androidstudio-as-start.md" %}

[debugging functionalities]: /testing/debugging

## Depure sem conexão USB {:#wireless-debugging}

Para depurar seu app via Wi-Fi em um dispositivo iOS ou Android,
use `flutter attach`.

### Depure via Wi-Fi em dispositivos iOS

Para um alvo iOS, complete as seguintes etapas:

1. Verifique se seu dispositivo se conecta ao Xcode via Wi-Fi
   conforme descrito no [guia de configuração do iOS][iOS setup guide].

1. Na sua máquina de desenvolvimento macOS,
   abra **Xcode** <span aria-label="and then">></span>
   **Product** <span aria-label="and then">></span>
   **Scheme** <span aria-label="and then">></span>
   **Edit Scheme...**.

   Você também pode pressionar <kbd>Cmd</kbd> + <kbd><</kbd>.

1. Clique em **Run**.

1. Clique em **Arguments**.

1. Em **Arguments Passed On Launch**, clique em **+**.

   {:type="a"}
   1. Se sua máquina de desenvolvimento usa IPv4, adicione `--vm-service-host=0.0.0.0`.

   1. Se sua máquina de desenvolvimento usa IPv6, adicione `--vm-service-host=::0`.

   <DashImage figure img-class="site-mobile-screenshot border" image="development/add-to-app/debugging/wireless-port.png" caption="Arguments Passed On Launch with an IPv4 network added", width="100%" />

#### Para determinar se você está em uma rede IPv6

1. Abra **Settings** <span aria-label="and then">></span> **Wi-Fi**.

1. Clique na sua rede conectada.

1. Clique em **Details...**

1. Clique em **TCP/IP**.

1. Verifique se há uma seção **IPv6 address**.

   <DashImage figure img-class="site-mobile-screenshot border" image="development/add-to-app/ipv6.png" caption="WiFi dialog box for macOS System Settings" width="60%" />

### Depure via Wi-Fi em dispositivos Android

Verifique se seu dispositivo se conecta ao Android Studio via Wi-Fi
conforme descrito no [guia de configuração do Android][Android setup guide].

[iOS setup guide]: /platform-integration/ios/setup
[Android setup guide]: /platform-integration/android/setup#set-up-devices
