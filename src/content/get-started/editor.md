---
title: Configurar um editor
description: Configurando um IDE para Flutter.
prev:
  title: Configurar o Flutter
  path: /get-started/install
next:
  title: Criar seu primeiro aplicativo
  path: /get-started/codelab
toc: false
ia-translate: true
---

Você pode construir aplicativos com Flutter usando qualquer editor de texto ou
ambiente de desenvolvimento integrado (IDE)
combinado com as ferramentas de linha de comando do Flutter.
A equipe do Flutter recomenda usar um editor que suporte
uma extensão ou plugin do Flutter, como VS Code e Android Studio.
Esses plugins fornecem preenchimento de código, realce de sintaxe,
assistentes de edição de widget, suporte para executar e depurar, e mais.

Você pode adicionar um plugin suportado para Visual Studio Code,
Android Studio, ou IntelliJ IDEA Community, Educational,
e edições Ultimate.
O [plugin do Flutter][] _funciona apenas_ com
Android Studio e as edições listadas do IntelliJ IDEA.

(O [plugin do Dart][] suporta oito IDEs JetBrains adicionais.)

[plugin do Flutter]: https://plugins.jetbrains.com/plugin/9212-flutter
[plugin do Dart]: https://plugins.jetbrains.com/plugin/6351-dart

Siga estes procedimentos para adicionar o plugin do Flutter ao VS Code,
Android Studio ou IntelliJ.

Se você escolher outro IDE, pule para
[Escreva seu primeiro aplicativo Flutter][].

[Escreva seu primeiro aplicativo Flutter]: /get-started/codelab

{% tabs %}
{% tab "Visual Studio Code" %}

## Instalar o VS Code

[VS Code][] é um editor de código para construir e depurar aplicativos.
Com a extensão do Flutter instalada, você pode compilar, implantar e depurar
aplicativos Flutter.

Para instalar a versão mais recente do VS Code,
siga as instruções da Microsoft para a plataforma relevante:

- [Instalar no macOS][]
- [Instalar no Windows][]
- [Instalar no Linux][]

[VS Code]: https://code.visualstudio.com/
[Instalar no macOS]: https://code.visualstudio.com/docs/setup/mac
[Instalar no Windows]: https://code.visualstudio.com/docs/setup/windows
[Instalar no Linux]: https://code.visualstudio.com/docs/setup/linux

## Instalar a extensão Flutter para VS Code

1. Inicie o **VS Code**.

1. Abra um navegador e vá para a página da [extensão do Flutter][]
   no Visual Studio Marketplace.

1. Clique em **Install**.
   Instalar a extensão do Flutter também instala a extensão do Dart.

[extensão do Flutter]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

## Validar sua configuração do VS Code

1. Vá para **View** <span aria-label="e então">></span>
   **Command Palette...**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `doctor`.

1. Selecione **Flutter: Run Flutter Doctor**.

   Assim que você selecionar este comando, o VS Code faz o seguinte.

   - Abre o painel **Output**.
   - Exibe **flutter (flutter)** no menu suspenso no canto superior direito
     deste painel.
   - Exibe a saída do comando Flutter Doctor.

{% endtab %}
{% tab "Android Studio e IntelliJ" %}

## Instalar o Android Studio ou IntelliJ IDEA

Android Studio e IntelliJ IDEA oferecem uma experiência IDE completa,
assim que você instala o plugin do Flutter.

Para instalar a versão mais recente dos seguintes IDEs, siga suas instruções:

- [Android Studio][]
- [IntelliJ IDEA Community][]
- [IntelliJ IDEA Ultimate][]

[Android Studio]: {{site.android-dev}}/studio/install
[IntelliJ IDEA Community]: https://www.jetbrains.com/idea/download/
[IntelliJ IDEA Ultimate]: https://www.jetbrains.com/idea/download/

## Instalar o plugin do Flutter

As instruções de instalação variam de acordo com a plataforma.

### macOS

Use as seguintes instruções para macOS:

1. Inicie o Android Studio ou IntelliJ.

1. Na barra de menu do macOS, vá para **Android Studio** (ou **IntelliJ**)
   <span aria-label="e então">></span> **Settings...**.

   Você também pode pressionar <kbd>Cmd</kbd> + <kbd>,</kbd>.

   A caixa de diálogo **Preferences** é aberta.

1. Na lista à esquerda, selecione **Plugins**.

1. Na parte superior deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de pesquisa de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

### Linux ou Windows

Use as seguintes instruções para Linux ou Windows:

1. Vá para **File** <span aria-label="e então">></span>
   **Settings**.

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Alt</kbd> +
   <kbd>S</kbd>.

   A caixa de diálogo **Preferences** é aberta.

1. Na lista à esquerda, selecione **Plugins**.

1. Na parte superior deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de pesquisa de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Install**.

1. Clique em **Yes** quando solicitado para instalar o plugin.

1. Clique em **Restart** quando solicitado.

{% endtab %}
{% endtabs %}
