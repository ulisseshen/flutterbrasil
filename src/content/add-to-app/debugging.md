---
ia-translate: true
title: Faça debug do seu módulo add-to-app
short-title: Debugging
description: Como executar, fazer debug e hot reload do seu módulo Flutter add-to-app.
---

Uma vez que você integrou o módulo Flutter ao seu projeto e usou
as APIs de plataforma do Flutter para executar o engine Flutter e/ou UI,
você pode então construir e executar seu app Android ou iOS da mesma forma
que você executa apps Android ou iOS normais.

O Flutter agora alimenta a UI onde quer que seu código inclua
`FlutterActivity` ou `FlutterViewController`.

## Visão geral

Você pode estar acostumado a ter seu conjunto de ferramentas de debug
Flutter favoritas disponíveis ao executar `flutter run` ou um comando equivalente
de uma IDE. Mas você também pode usar todas as suas [funcionalidades de debug][debugging functionalities]
do Flutter, como hot reload, overlays de desempenho, DevTools e definição de
breakpoints em cenários add-to-app.

O comando `flutter attach` fornece essas funcionalidades.
Para executar este comando, você pode usar as ferramentas CLI do SDK, VS Code
ou IntelliJ IDEA ou Android Studio.

O comando `flutter attach` se conecta assim que você executa seu `FlutterEngine`.
Ele permanece anexado até você descartar seu `FlutterEngine`.
Você pode invocar `flutter attach` antes de iniciar seu engine.
O comando `flutter attach` aguarda a próxima Dart VM disponível que
seu engine hospeda.

## Debug pelo Terminal

Para anexar pelo terminal, execute `flutter attach`.
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
An Observatory debugger and profiler on iPhone 15 Pro is available at:
http://127.0.0.1:65525/EXmCgco5zjo=/
For a more detailed help message, press "h".
To detach, press "d"; to quit, press "q".
```

## Debug extensão iOS no Xcode e VS Code

{% include docs/debug/debug-flow-ios.md add='launch' %}

## Debug extensão Android no Android Studio

{% include docs/debug/debug-flow-androidstudio-as-start.md %}

[debugging functionalities]: /testing/debugging

## Debug sem conexão USB {:#wireless-debugging}

Para fazer debug do seu app via Wi-Fi em um dispositivo iOS ou Android,
use `flutter attach`.

### Debug via Wi-Fi em dispositivos iOS

Para um alvo iOS, complete os seguintes passos:

1. Verifique se seu dispositivo se conecta ao Xcode via Wi-Fi
   conforme descrito no [guia de configuração iOS][iOS setup guide].

1. Em sua máquina de desenvolvimento macOS,
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

   {% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"development/add-to-app/debugging/wireless-port.png",
   caption:"Arguments Passed On Launch with an IPv4 network added", width:"100%" %}

#### Para determinar se você está em uma rede IPv6

1. Abra **Settings** <span aria-label="and then">></span> **Wi-Fi**.

1. Clique em sua rede conectada.

1. Clique em **Details...**

1. Clique em **TCP/IP**.

1. Verifique se há uma seção **IPv6 address**.

   {% render docs/app-figure.md, img-class:"site-mobile-screenshot border", image:"development/add-to-app/ipv6.png", caption:"WiFi dialog box for macOS System Settings", width:"60%" %}

### Debug via Wi-Fi em dispositivos Android

Verifique se seu dispositivo se conecta ao Android Studio via Wi-Fi
conforme descrito no [guia de configuração Android][Android setup guide].

[iOS setup guide]: /get-started/install/macos/mobile-ios
[Android setup guide]: /get-started/install/macos/mobile-android?tab=physical#configure-your-target-android-device
