---
ia-translate: true
title: Use um depurador de linguagem nativa
shortTitle: debuggers
description: Como conectar um depurador nativo ao seu app Flutter em execução.
---

<?code-excerpt path-base="testing/native_debugging"?>

:::note
Este guia pressupõe que você entende depuração geral,
tem o Flutter e git instalados, e possui familiaridade
com a linguagem Dart, bem como uma das seguintes
linguagens: Java, Kotlin, Swift ou Objective-C.
:::

Se você escreve apps Flutter apenas com código Dart,
você pode depurar seu código usando o depurador da sua IDE.
O time do Flutter recomenda o VS Code.

Se você escreve um plugin específico de plataforma ou
usa bibliotecas específicas de plataforma, você pode depurar
essa parte do seu código com um depurador nativo.

- Para depurar código iOS ou macOS escrito em Swift ou Objective-C,
  você pode usar o Xcode.
- Para depurar código Android escrito em Java ou Kotlin,
  você pode usar o Android Studio.
- Para depurar código Windows escrito em C++, você pode usar o Visual Studio.

Este guia mostra como você pode conectar _dois_
depuradores ao seu app Dart, um para Dart e um para o código nativo.

## Debug Dart code

Este guia descreve como usar o VS Code para depurar seu app Flutter.
Você também pode usar sua IDE preferida com os
plugins Flutter e Dart instalados e configurados.

## Debug Dart code using VS Code

O procedimento a seguir explica como usar o depurador Dart
com o app Flutter de exemplo padrão.
Os componentes destacados no VS Code funcionam e aparecem quando
você está depurando seu próprio projeto Flutter também.

1. Crie um app Flutter básico.

    ```console
    $ flutter create my_app
    ```

    ```console
    Creating project my_app...
    Resolving dependencies in my_app...
    Got dependencies in my_app.
    Wrote 129 files.

    All done!
    You can find general documentation for Flutter at: https://docs.flutterbrasil.dev/
    Detailed API documentation is available at: https://api.flutterbrasil.dev/
    If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

    In order to run your application, type:

      $ cd my_app
      $ flutter run

    Your application code is in my_app/lib/main.dart.
    ```

    ```console
    $ cd my_app
    ```

1. Abra o arquivo `lib\main.dart` no app Flutter usando
   o VS Code.

1. Clique no ícone de bug
   (![VS Code's bug icon to trigger the debugging mode of a Flutter app](/assets/images/docs/testing/debugging/vscode-ui/icons/debug.png)).
   Isso abre os seguintes painéis no VS Code:

   - **Debug**
   - **Debug Console**
   - **Widget Inspector**

   A primeira vez que você executa o depurador leva mais tempo.

   {% comment %}
   ![VS Code window with debug panes opened](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-debugger.png){:width="100%"}
   {% endcomment %}

1. Teste o depurador.

   a. Em `main.dart`, clique nesta linha:

      ```dart
      _counter++;
      ```

   b. Pressione <kbd>Shift</kbd> + <kbd>F9</kbd>.
      Isso adiciona um breakpoint onde a
      variável `_counter` é incrementada.

   c. No app, clique no botão **+**
      para incrementar o contador. O app pausa.

      {% comment %}
      ![Flutter test app paused](/assets/images/docs/testing/debugging/native/macos/basic-app.png){:width="50%"}
      <div class="figure-caption">

      Default Flutter app as rendered on macOS.

      </div>
      {% endcomment %}

    d. Neste ponto, o VS Code exibe:

      - Nos **Editor Groups**:
        - O breakpoint destacado em `main.dart`
        - A hierarquia de widgets para o app Flutter
          na **Widget Tree** do **Widget Inspector**
      - Na **side bar**:
        - O estado do app na seção **Call Stack**
        - O valor da variável local `this` na seção **Variables**
      - No **panel**:
        - O log do app Flutter no **Debug console**

      {% comment %}
      ![VS Code window with Flutter app paused](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-debugger-paused.png){:width="100%"}
      {% endcomment %}

### VS Code Flutter debugger

O plugin Flutter para VS Code adiciona vários componentes
à interface do usuário do VS Code.

#### Changes to VS Code interface

Quando iniciado, o depurador Flutter adiciona ferramentas de depuração à
interface do VS Code.

A captura de tela e tabela a seguir explicam o propósito de cada ferramenta.

![VS Code with the Flutter plugin UI additions](/assets/images/docs/testing/debugging/vscode-ui/screens/debugger-parts.png)

| Highlight Color in Screenshot | Bar, Panel, or Tab  | Contents                                                                          |
|-------------------------------|---------------------|-----------------------------------------------------------------------------------|
| **Yellow**                    | Variables           | List of current values of variables in the Flutter app                            |
|                               | Watch               | List of items you chose to track in the Flutter app                               |
|                               | Call Stack          | Stack of active subroutines in the Flutter app                                    |
|                               | Breakpoints         | List of exceptions and set breakpoints that you set                               |
| **Green**                     | `<Flutter files>`   | Files that you are editing                                                        |
| **Pink**                      | Widget Inspector    | Hierarchy of widgets in the running Flutter app                                   |
| **Blue**                      | Layout Explorer     | Visual of how Flutter placed the widget you selected in the Widget Inspector      |
|                               | Widget Details Tree | List of properties of the widget selected in the Widget Inspector                 |
| **Orange**                    | Problems            | List of issues the Dart analyzer found in the current Dart file                   |
|                               | Output              | Response that the Flutter app returns when building an app                        |
|                               | Debug Console       | Logs or error messages that the Flutter app generates while debugging             |
|                               | Terminal            | System shell prompt contained in VS Code                                          |

{:.table .table-striped}

Para alterar onde o painel (em **laranja**) aparece no VS Code,
vá para **View** > **Appearance** > **Panel Position**.

#### VS Code Flutter debugging toolbar

A barra de ferramentas permite que você depure usando qualquer depurador.
Você pode entrar, sair e pular instruções Dart, fazer hot reload ou retomar o app.

![Flutter debugger toolbar in VS Code](/assets/images/docs/testing/debugging/vscode-ui/screens/debug-toolbar.png)

| Icon                                                | Action                | Default keyboard shortcut                             |
|-----------------------------------------------------|-----------------------|-------------------------------------------------------|
| {% render "docs/vscode-flutter-bar/play.md" %}        | Start or Resume       | <kbd>F5</kbd>                                         |
| {% render "docs/vscode-flutter-bar/pause.md" %}       | Pause                 | <kbd>F6</kbd>                                         |
| {% render "docs/vscode-flutter-bar/step-over.md" %}   | Step Over             | <kbd>F10</kbd>                                        |
| {% render "docs/vscode-flutter-bar/step-into.md" %}   | Step Into             | <kbd>F11</kbd>                                        |
| {% render "docs/vscode-flutter-bar/step-out.md" %}    | Step Out              | <kbd>Shift</kbd> + <kbd>F11</kbd>                     |
| {% render "docs/vscode-flutter-bar/hot-reload.md" %}  | Hot Reload            | <kbd>Ctrl</kbd> + <kbd>F5</kbd>                       |
| {% render "docs/vscode-flutter-bar/hot-restart.md" %} | Hot Restart           | <kbd>Shift</kbd> + <kbd>Special</kbd> + <kbd>F5</kbd> |
| {% render "docs/vscode-flutter-bar/stop.md" %}        | Stop                  | <kbd>Shift</kbd> + <kbd>F5</kbd>                      |
| {% render "docs/vscode-flutter-bar/inspector.md" %}   | Open Widget Inspector |                                                       |

{:.table .table-striped}

## Update test Flutter app

Para o restante deste guia, você precisa atualizar o
app Flutter de teste. Esta atualização adiciona código nativo para depurar.

1. Abra o arquivo `lib/main.dart` usando sua IDE preferida.

1. Substitua o conteúdo de `main.dart` pelo seguinte código.

    <details>
    <summary>Expand to see Flutter code for this example</summary>

    ```dart title="lib/main.dart"
    // Copyright 2023 The Flutter Authors. All rights reserved.
    // Use of this source code is governed by a BSD-style license that can be
    // found in the LICENSE file.

    import 'package:flutter/material.dart';
    import 'package:url_launcher/url_launcher.dart';

    void main() {
      runApp(const MyApp());
    }

    class MyApp extends StatelessWidget {
      const MyApp({super.key});

      @override
      Widget build(BuildContext context) {
        return MaterialApp(
          title: 'URL Launcher',
          theme: ThemeData(
            colorSchemeSeed: Colors.purple,
            brightness: Brightness.light,
          ),
          home: const MyHomePage(title: 'URL Launcher'),
        );
      }
    }

    class MyHomePage extends StatefulWidget {
      const MyHomePage({super.key, required this.title});
      final String title;

      @override
      State<MyHomePage> createState() => _MyHomePageState();
    }

    class _MyHomePageState extends State<MyHomePage> {
      Future<void>? _launched;

      Future<void> _launchInBrowser(Uri url) async {
        if (!await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        )) {
          throw Exception('Could not launch $url');
        }
      }

      Future<void> _launchInWebView(Uri url) async {
        if (!await launchUrl(
          url,
          mode: LaunchMode.inAppWebView,
        )) {
          throw Exception('Could not launch $url');
        }
      }

      Widget _launchStatus(BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Text('');
        }
      }

      @override
      Widget build(BuildContext context) {
        final Uri toLaunch = Uri(
            scheme: 'https',
            host: 'docs.flutterbrasil.dev',
            path: 'testing/native-debugging');
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(toLaunch.toString()),
                ),
                FilledButton(
                  onPressed: () => setState(() {
                    _launched = _launchInBrowser(toLaunch);
                  }),
                  child: const Text('Launch in browser'),
                ),
                const Padding(padding: EdgeInsets.all(16)),
                FilledButton(
                  onPressed: () => setState(() {
                    _launched = _launchInWebView(toLaunch);
                  }),
                  child: const Text('Launch in app'),
                ),
                const Padding(padding: EdgeInsets.all(16.0)),
                FutureBuilder<void>(future: _launched, builder: _launchStatus),
              ],
            ),
          ),
        );
      }
    }
    ```

    </details>

1. Para adicionar o pacote `url_launcher` como uma dependência,
   execute `flutter pub add`:

    ```console
    $ flutter pub add url_launcher
    ```

    ```console
    Resolving dependencies...
      collection 1.17.1 (1.17.2 available)
    + flutter_web_plugins 0.0.0 from sdk flutter
      matcher 0.12.15 (0.12.16 available)
      material_color_utilities 0.2.0 (0.8.0 available)
    + plugin_platform_interface 2.1.4
      source_span 1.9.1 (1.10.0 available)
      stream_channel 2.1.1 (2.1.2 available)
      test_api 0.5.1 (0.6.1 available)
    + url_launcher 6.1.11
    + url_launcher_android 6.0.36
    + url_launcher_ios 6.1.4
    + url_launcher_linux 3.0.5
    + url_launcher_macos 3.0.5
    + url_launcher_platform_interface 2.1.3
    + url_launcher_web 2.0.17
    + url_launcher_windows 3.0.6
    Changed 10 dependencies!
    ```

1. Para verificar o que mudou no código:

   {: type="a"}
   1. No Linux ou macOS, execute este comando `find`.

      ```console
      $ find ./ -mmin -120
      ```

      ```console
      ./ios/Flutter/Debug.xcconfig
      ./ios/Flutter/Release.xcconfig
      ./linux/flutter/generated_plugin_registrant.cc
      ./linux/flutter/generated_plugins.cmake
      ./macos/Flutter/Flutter-Debug.xcconfig
      ./macos/Flutter/Flutter-Release.xcconfig
      ./macos/Flutter/GeneratedPluginRegistrant.swift
      ./pubspec.lock
      ./pubspec.yaml
      ./windows/flutter/generated_plugin_registrant.cc
      ./windows/flutter/generated_plugins.cmake
      ```
   1. No Windows, execute este comando no prompt de comando.

      ```ps
      Get-ChildItem C:\dev\example\ -Rescurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}
      ```

      ```ps
      C:\dev\example\ios\Flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                Debug.xcconfig
                      8/1/2025   9:15 AM                Release.xcconfig

      C:\dev\example\linux\flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                generated_plugin_registrant.cc
                      8/1/2025   9:15 AM                generated_plugins.cmake

      C:\dev\example\macos\Flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                Flutter-Debug.xcconfig
                      8/1/2025   9:15 AM                Flutter-Release.xcconfig
                      8/1/2025   9:15 AM                GeneratedPluginRegistrant.swift

      C:\dev\example\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                pubspec.lock
                      8/1/2025   9:15 AM                pubspec.yaml

      C:\dev\example\windows\flutter\


      Mode                LastWriteTime         Length Name
      ----                -------------         ------ ----
                      8/1/2025   9:15 AM                generated_plugin_registrant.cc
                      8/1/2025   9:15 AM                generated_plugins.cmake
      ```

Instalar o `url_launcher` adicionou arquivos de configuração e código
para todas as plataformas alvo no diretório do app Flutter.

## Debug Dart and native language code at the same time

Esta seção explica como depurar o código Dart no seu app Flutter
e qualquer código nativo com seu depurador regular.
Essa capacidade permite que você aproveite o hot reload do Flutter
ao editar código nativo.

### Debug Dart and Android code using Android Studio

Para depurar código Android nativo, você precisa de um app Flutter que contenha
código Android. Nesta seção, você aprende como conectar
os depuradores Dart, Java e Kotlin ao seu app.
Você não precisa do VS Code para depurar código Dart e Android.
Este guia inclui as instruções do VS Code para ser consistente
com os guias do Xcode e Visual Studio.

Esta seção usa o mesmo app Flutter `url_launcher` de exemplo criado
em [Update test Flutter app](#update-test-flutter-app).

{% render "docs/debug/debug-flow-android.md" %}

### Debug Dart and iOS code using Xcode

Para depurar código iOS, você precisa de um app Flutter que contenha código iOS.
Nesta seção, você aprende a conectar dois depuradores ao seu app:
Flutter via VS Code e Xcode. Você precisa executar tanto o VS Code quanto o Xcode.

Esta seção usa o mesmo app Flutter `url_launcher` de exemplo criado
em [Update test Flutter app](#update-test-flutter-app).

{% render "docs/debug/debug-flow-ios.md" %}

### Debug Dart and macOS code using Xcode

Para depurar código macOS, você precisa de um app Flutter que contenha código macOS.
Nesta seção, você aprende a conectar dois depuradores ao seu app:
Flutter via VS Code e Xcode. Você precisa executar tanto o VS Code quanto o Xcode.

Esta seção usa o mesmo app Flutter `url_launcher` de exemplo criado
em [Update test Flutter app](#update-test-flutter-app).

{% render "docs/debug/debug-flow-macos.md" %}

### Debug Dart and C++ code using Visual Studio

Para depurar código C++, você precisa de um app Flutter que contenha código C++.
Nesta seção, você aprende a conectar dois depuradores ao seu app:
Flutter via VS Code e Visual Studio.
Você precisa executar tanto o VS Code quanto o Visual Studio.

Esta seção usa o mesmo app Flutter `url_launcher` de exemplo criado
em [Update test Flutter app](#update-test-flutter-app).

{% render "docs/debug/debug-flow-windows.md" %}

## Resources

Confira os seguintes recursos sobre depuração de Flutter, iOS, Android,
macOS e Windows:

### Flutter

- [Debugging Flutter apps][Debugging Flutter apps]
- [Flutter inspector][Flutter inspector] e a documentação do [DevTools][DevTools]
- [Performance profiling][Performance profiling]

[Debugging Flutter apps]: /testing/debugging
[Performance profiling]: /perf/ui-performance

### Android

Você pode encontrar os seguintes recursos de depuração em
[developer.android.com][developer.android.com].

- [Debug your app][Debug your app]
- [Android Debug Bridge (adb)][Android Debug Bridge (adb)]

### iOS and macOS

Você pode encontrar os seguintes recursos de depuração em
[developer.apple.com][developer.apple.com].

- [Debugging][Debugging]
- [Instruments Help][Instruments Help]

### Windows

Você pode encontrar recursos de depuração no [Microsoft Learn][Microsoft Learn].

- [Visual Studio Debugger][Visual Studio Debugger]
- [Learn to debug C++ code using Visual Studio][Learn to debug C++ code using Visual Studio]

[Android Debug Bridge (adb)]: {{site.android-dev}}/studio/command-line/adb
[Debug your app]: {{site.android-dev}}/studio/debug
[Debugging]: {{site.apple-dev}}/support/debugging/
[developer.android.com]: {{site.android-dev}}
[developer.apple.com]: {{site.apple-dev}}
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
[Instruments Help]: https://help.apple.com/instruments/mac/current/
[Microsoft Learn]: https://learn.microsoft.com/visualstudio/
[Visual Studio Debugger]: https://learn.microsoft.com/visualstudio/debugger/?view=vs-2022
[Learn to debug C++ code using Visual Studio]: https://learn.microsoft.com/visualstudio/debugger/getting-started-with-the-debugger-cpp?view=vs-2022
