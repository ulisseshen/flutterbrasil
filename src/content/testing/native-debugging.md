---
title: Usar um depurador de linguagem nativa
short-title: depuradores
description: Como conectar um depurador nativo ao seu aplicativo Flutter em execução.
ia-translate: true
---

<?code-excerpt path-base="testing/native_debugging"?>

:::note
Este guia pressupõe que você entende de depuração em geral,
instalou o Flutter e o git, e tem familiaridade
com a linguagem Dart, bem como com uma das seguintes
linguagens: Java, Kotlin, Swift ou Objective-C.
:::

Se você escreve aplicativos Flutter apenas com código Dart,
você pode depurar seu código usando o depurador da sua IDE.
A equipe do Flutter recomenda o VS Code.

Se você escreve um plugin específico da plataforma ou
usa bibliotecas específicas da plataforma, você pode depurar
essa porção do seu código com um depurador nativo.

- Para depurar código iOS ou macOS escrito em Swift ou Objective-C,
  você pode usar o Xcode.
- Para depurar código Android escrito em Java ou Kotlin,
  você pode usar o Android Studio.
- Para depurar código Windows escrito em C++, você pode usar o Visual Studio.

Este guia mostra como você pode conectar _dois_
depuradores ao seu aplicativo Dart, um para Dart e um para o código nativo.

## Depurar código Dart

Este guia descreve como usar o VS Code para depurar seu aplicativo Flutter.
Você também pode usar sua IDE preferida com os
plugins Flutter e Dart instalados e configurados.

## Depurar código Dart usando o VS Code

O procedimento a seguir explica como usar o depurador Dart
com o aplicativo de exemplo padrão do Flutter.
Os componentes em destaque no VS Code funcionam e aparecem quando
você também estiver depurando seu próprio projeto Flutter.

1. Crie um aplicativo Flutter básico.

    ```console
    $ flutter create my_app
    ```

    ```console
    Creating project my_app...
    Resolving dependencies in my_app... 
    Got dependencies in my_app.
    Wrote 129 files.

    All done!
    You can find general documentation for Flutter at: https://docs.flutter.dev/
    Detailed API documentation is available at: https://api.flutter.dev/
    If you prefer video documentation, consider: https://www.youtube.com/c/flutterdev

    In order to run your application, type:

      $ cd my_app
      $ flutter run

    Your application code is in my_app/lib/main.dart.
    ```

    ```console
    $ cd my_app
    ```

2. Abra o arquivo `lib\main.dart` no aplicativo Flutter usando
   o VS Code.

3. Clique no ícone de bug
   (![Ícone de bug do VS Code para iniciar o modo de depuração de um aplicativo Flutter](/assets/images/docs/testing/debugging/vscode-ui/icons/debug.png)).
   Isso abre os seguintes painéis no VS Code:

   - **Debug**
   - **Debug Console**
   - **Widget Inspector**

   A primeira vez que você executa o depurador leva mais tempo.

{% comment %}
   ![Janela do VS Code com painéis de depuração abertos](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-debugger.png){:width="100%"}
{% endcomment %}

4. Teste o depurador.

   a. Em `main.dart`, clique nesta linha:

      ```dart
      _counter++;
      ```

   b. Pressione <kbd>Shift</kbd> + <kbd>F9</kbd>.
      Isso adiciona um breakpoint onde a variável
      `_counter` é incrementada.

   c. No aplicativo, clique no botão **+**
      para incrementar o contador. O aplicativo pausa.

{% comment %}
      ![Aplicativo de teste do Flutter pausado](/assets/images/docs/testing/debugging/native/macos/basic-app.png){:width="50%"}
      <div class="figure-caption">

      Aplicativo padrão do Flutter renderizado no macOS.

      </div>
{% endcomment %}

   d. Neste ponto, o VS Code exibe:

      - Em **Editor Groups**:
        - O breakpoint destacado em `main.dart`
        - A hierarquia de widgets do aplicativo Flutter
          na **Widget Tree** do **Widget Inspector**
      - Na **barra lateral**:
        - O estado do aplicativo na seção **Call Stack**
        - O valor da variável local `this` na seção **Variables**
      - No **painel**:
        - O log do aplicativo Flutter no **Debug console**

{% comment %}
      ![Janela do VS Code com aplicativo Flutter pausado](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-debugger-paused.png){:width="100%"}
{% endcomment %}

### Depurador do Flutter no VS Code

O plugin Flutter para VS Code adiciona vários componentes
à interface do usuário do VS Code.

#### Mudanças na interface do VS Code

Quando iniciado, o depurador do Flutter adiciona ferramentas de depuração
à interface do VS Code.

A captura de tela e a tabela a seguir explicam o propósito de cada ferramenta.

![VS Code com as adições de UI do plugin Flutter](/assets/images/docs/testing/debugging/vscode-ui/screens/debugger-parts.png)

| Cor de Destaque na Captura de Tela | Barra, Painel ou Aba | Conteúdo                                                                          |
|-----------------------------------|----------------------|-----------------------------------------------------------------------------------|
| **Amarelo**                       | Variables            | Lista dos valores atuais das variáveis no aplicativo Flutter                       |
|                                   | Watch                | Lista de itens que você escolheu rastrear no aplicativo Flutter                  |
|                                   | Call Stack           | Stack de sub-rotinas ativas no aplicativo Flutter                                |
|                                   | Breakpoints          | Lista de exceções e breakpoints definidos por você                             |
| **Verde**                         | `<Arquivos Flutter>`  | Arquivos que você está editando                                                    |
| **Rosa**                          | Widget Inspector     | Hierarquia de widgets no aplicativo Flutter em execução                             |
| **Azul**                          | Layout Explorer      | Visualização de como o Flutter posicionou o widget selecionado no Widget Inspector |
|                                   | Widget Details Tree  | Lista de propriedades do widget selecionado no Widget Inspector                  |
| **Laranja**                       | Problems             | Lista de problemas que o analisador Dart encontrou no arquivo Dart atual           |
|                                   | Output               | Resposta que o aplicativo Flutter retorna ao compilar um aplicativo               |
|                                   | Debug Console        | Logs ou mensagens de erro que o aplicativo Flutter gera durante a depuração      |
|                                   | Terminal             | Prompt do shell do sistema contido no VS Code                                     |

{:.table .table-striped}

Para alterar onde o painel (em **laranja**) aparece no VS Code,
vá para **View** > **Appearance** > **Panel Position**.

#### Barra de ferramentas de depuração do Flutter no VS Code

A barra de ferramentas permite depurar usando qualquer depurador.
Você pode executar passo a passo, entrar e sair de instruções Dart, hot reload ou retomar o aplicativo.

![Barra de ferramentas do depurador Flutter no VS Code](/assets/images/docs/testing/debugging/vscode-ui/screens/debug-toolbar.png)

| Ícone                                                | Ação                | Atalho de teclado padrão                             |
|-----------------------------------------------------|---------------------|-------------------------------------------------------|
| {% render docs/vscode-flutter-bar/play.md %}        | Iniciar ou Retomar  | <kbd>F5</kbd>                                         |
| {% render docs/vscode-flutter-bar/pause.md %}       | Pausar              | <kbd>F6</kbd>                                         |
| {% render docs/vscode-flutter-bar/step-over.md %}   | Executar Passo a Passo | <kbd>F10</kbd>                                        |
| {% render docs/vscode-flutter-bar/step-into.md %}   | Entrar              | <kbd>F11</kbd>                                        |
| {% render docs/vscode-flutter-bar/step-out.md %}    | Sair                | <kbd>Shift</kbd> + <kbd>F11</kbd>                     |
| {% render docs/vscode-flutter-bar/hot-reload.md %}  | Hot Reload          | <kbd>Ctrl</kbd> + <kbd>F5</kbd>                       |
| {% render docs/vscode-flutter-bar/hot-restart.md %} | Hot Restart         | <kbd>Shift</kbd> + <kbd>Special</kbd> + <kbd>F5</kbd> |
| {% render docs/vscode-flutter-bar/stop.md %}        | Parar               | <kbd>Shift</kbd> + <kbd>F5</kbd>                      |
| {% render docs/vscode-flutter-bar/inspector.md %}   | Abrir Widget Inspector |                                                       |

{:.table .table-striped}

## Atualizar aplicativo de teste Flutter

Para o restante deste guia, você precisa atualizar o
aplicativo de teste Flutter. Esta atualização adiciona código nativo para depurar.

1. Abra o arquivo `lib/main.dart` usando sua IDE preferida.

2. Substitua o conteúdo de `main.dart` pelo código a seguir.

    <details>
    <summary>Expandir para ver o código Flutter deste exemplo</summary>

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
            host: 'docs.flutter.dev',
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

3. Para adicionar o pacote `url_launcher` como uma dependência,
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

4. Para verificar o que mudou no código-fonte:

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
   2. No Windows, execute este comando no prompt de comando.

      ```powershell
      Get-ChildItem C:\dev\example\ -Rescurse | Where-Object {$_.LastWriteTime -gt (Get-Date).AddDays(-1)}
      ```

      ```powershell
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

A instalação do `url_launcher` adicionou arquivos de configuração e arquivos de código
para todas as plataformas de destino no diretório do aplicativo Flutter.

## Depurar código Dart e de linguagem nativa ao mesmo tempo

Esta seção explica como depurar o código Dart em seu aplicativo Flutter
e qualquer código nativo com seu depurador regular.
Essa capacidade permite que você aproveite o hot reload do Flutter
ao editar código nativo.

### Depurar código Dart e Android usando o Android Studio

Para depurar código nativo Android, você precisa de um aplicativo Flutter que contenha
código Android. Nesta seção, você aprenderá como conectar
os depuradores Dart, Java e Kotlin ao seu aplicativo.
Você não precisa do VS Code para depurar código Dart e Android.
Este guia inclui as instruções do VS Code para ser consistente
com os guias Xcode e Visual Studio.

Esta seção usa o mesmo aplicativo de exemplo `url_launcher` do Flutter criado
em [Atualizar aplicativo de teste Flutter](#atualizar-aplicativo-de-teste-flutter).

{% include docs/debug/debug-flow-android.md %}

### Depurar código Dart e iOS usando o Xcode

Para depurar código iOS, você precisa de um aplicativo Flutter que contenha código iOS.
Nesta seção, você aprenderá a conectar dois depuradores ao seu aplicativo:
Flutter via VS Code e Xcode. Você precisa executar o VS Code e o Xcode.

Esta seção usa o mesmo aplicativo de exemplo `url_launcher` do Flutter criado
em [Atualizar aplicativo de teste Flutter](#atualizar-aplicativo-de-teste-flutter).

{% include docs/debug/debug-flow-ios.md %}

### Depurar código Dart e macOS usando o Xcode

Para depurar código macOS, você precisa de um aplicativo Flutter que contenha código macOS.
Nesta seção, você aprenderá a conectar dois depuradores ao seu aplicativo:
Flutter via VS Code e Xcode. Você precisa executar o VS Code e o Xcode.

Esta seção usa o mesmo aplicativo de exemplo `url_launcher` do Flutter criado
em [Atualizar aplicativo de teste Flutter](#atualizar-aplicativo-de-teste-flutter).

{% include docs/debug/debug-flow-macos.md %}

### Depurar código Dart e C++ usando o Visual Studio

Para depurar código C++, você precisa de um aplicativo Flutter que contenha código C++.
Nesta seção, você aprenderá a conectar dois depuradores ao seu aplicativo:
Flutter via VS Code e Visual Studio.
Você precisa executar o VS Code e o Visual Studio.

Esta seção usa o mesmo aplicativo de exemplo `url_launcher` do Flutter criado
em [Atualizar aplicativo de teste Flutter](#atualizar-aplicativo-de-teste-flutter).

{% include docs/debug/debug-flow-windows.md %}

## Recursos

Confira os seguintes recursos sobre depuração em Flutter, iOS, Android,
macOS e Windows:

### Flutter

- [Depurando aplicativos Flutter][]
- [Flutter inspector][] e a documentação [DevTools][]
- [Perfil de desempenho][]

[Depurando aplicativos Flutter]: /testing/debugging
[Perfil de desempenho]: /perf/ui-performance

### Android

Você pode encontrar os seguintes recursos de depuração em
[developer.android.com][].

- [Depure seu aplicativo][]
- [Android Debug Bridge (adb)][]

### iOS e macOS

Você pode encontrar os seguintes recursos de depuração em
[developer.apple.com][].

- [Depurando][]
- [Ajuda do Instruments][]

### Windows

Você pode encontrar recursos de depuração em [Microsoft Learn][].

- [Depurador do Visual Studio][]
- [Aprenda a depurar código C++ usando o Visual Studio][]

[Android Debug Bridge (adb)]: {{site.android-dev}}/studio/command-line/adb
[Depure seu aplicativo]: {{site.android-dev}}/studio/debug
[Depurando]: {{site.apple-dev}}/support/debugging/
[developer.android.com]: {{site.android-dev}}
[developer.apple.com]: {{site.apple-dev}}
[DevTools]: /tools/devtools
[Flutter inspector]: /tools/devtools/inspector
[Ajuda do Instruments]: https://help.apple.com/instruments/mac/current/
[Microsoft Learn]: https://learn.microsoft.com/visualstudio/
[Depurador do Visual Studio]: https://learn.microsoft.com/visualstudio/debugger/?view=vs-2022
[Aprenda a depurar código C++ usando o Visual Studio]: https://learn.microsoft.com/visualstudio/debugger/getting-started-with-the-debugger-cpp?view=vs-2022
