---
ia-translate: true
title: Configure um editor
description: Configurando uma IDE para Flutter.
prev:
  title: Set up Flutter
  path: /get-started/install
next:
  title: Create your first app
  path: /get-started/codelab
toc: false
---

Você pode criar apps com Flutter usando qualquer editor de texto ou
ambiente de desenvolvimento integrado (IDE)
combinado com as ferramentas de linha de comando do Flutter.
A equipe Flutter recomenda usar um editor que suporte
uma extensão ou plugin do Flutter, como VS Code e Android Studio.
Esses plugins fornecem autocompletar de código, destaque de sintaxe,
assistências de edição de widgets, suporte para executar e depurar, e muito mais.

Você pode adicionar um plugin suportado para Visual Studio Code,
Android Studio, ou IntelliJ IDEA Community, Educational,
e edições Ultimate.
O [plugin Flutter][Flutter plugin] funciona _apenas_ com
Android Studio e as edições listadas do IntelliJ IDEA.

(O [plugin Dart][Dart plugin] suporta oito IDEs JetBrains adicionais.)

[Flutter plugin]: https://plugins.jetbrains.com/plugin/9212-flutter
[Dart plugin]: https://plugins.jetbrains.com/plugin/6351-dart

Siga estes procedimentos para adicionar o plugin Flutter ao VS Code,
Android Studio, ou IntelliJ.

Se você escolher outra IDE, pule para
[Escreva seu primeiro app Flutter][Write your first Flutter app].

[Write your first Flutter app]: /get-started/codelab

{% tabs %}
{% tab "Visual Studio Code" %}

## Instalar VS Code

[VS Code][] é um editor de código para criar e depurar apps.
Com a extensão Flutter instalada, você pode compilar, implantar e depurar
apps Flutter.

Para instalar a versão mais recente do VS Code,
siga as instruções da Microsoft para a plataforma relevante:

- [Install on macOS][]
- [Install on Windows][]
- [Install on Linux][]

[VS Code]: https://code.visualstudio.com/
[Install on macOS]: https://code.visualstudio.com/docs/setup/mac
[Install on Windows]: https://code.visualstudio.com/docs/setup/windows
[Install on Linux]: https://code.visualstudio.com/docs/setup/linux

## Instalar a extensão Flutter do VS Code

1. Inicie o **VS Code**.

1. Abra um navegador e vá para a página da [extensão Flutter][Flutter extension]
   no Visual Studio Marketplace.

1. Clique em **Install**.
   Instalar a extensão Flutter também instala a extensão Dart.

[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

## Validar sua configuração do VS Code

1. Vá para **View** <span aria-label="and then">></span>
   **Command Palette...**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `doctor`.

1. Selecione **Flutter: Run Flutter Doctor**.

   Depois de selecionar este comando, o VS Code faz o seguinte.

   - Abre o painel **Output**.
   - Exibe **flutter (flutter)** no menu suspenso no canto superior direito
     deste painel.
   - Exibe a saída do comando Flutter Doctor.

{% endtab %}
{% tab "Android Studio and IntelliJ" %}

## Instalar Android Studio ou IntelliJ IDEA

Android Studio e IntelliJ IDEA oferecem uma experiência
completa de IDE depois que você instala o plugin Flutter.

Para instalar a versão mais recente das seguintes IDEs, siga suas instruções:

- [Android Studio][]
- [IntelliJ IDEA Community][]
- [IntelliJ IDEA Ultimate][]

[Android Studio]: {{site.android-dev}}/studio/install
[IntelliJ IDEA Community]: https://www.jetbrains.com/idea/download/
[IntelliJ IDEA Ultimate]: https://www.jetbrains.com/idea/download/

## Instalar o plugin Flutter

As instruções de instalação variam por plataforma.

### macOS

Use as seguintes instruções para macOS:

1. Inicie Android Studio ou IntelliJ.

1. Na barra de menu do macOS, vá para **Android Studio** (ou **IntelliJ**)
   <span aria-label="and then">></span> **Settings...**.

   Você também pode pressionar <kbd>Cmd</kbd> + <kbd>,</kbd>.

   A caixa de diálogo **Preferences** abre.

1. Na lista à esquerda, selecione **Plugins**.

1. No topo deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de busca de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

### Linux ou Windows

Use as seguintes instruções para Linux ou Windows:

1. Vá para **File** <span aria-label="and then">></span>
   **Settings**.

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Alt</kbd> +
   <kbd>S</kbd>.

   A caixa de diálogo **Preferences** abre.

1. Na lista à esquerda, selecione **Plugins**.

1. No topo deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de busca de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

{% endtab %}
{% endtabs %}

