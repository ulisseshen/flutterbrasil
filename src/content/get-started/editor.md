---
ia-translate: true
title: Configurar um editor
description: Configurando um IDE para Flutter.
prev:
  title: Configurar o Flutter
  path: /get-started/install
next:
  title: Crie seu primeiro aplicativo
  path: /get-started/codelab
toc: false
---

Você pode criar aplicativos com Flutter usando qualquer editor de texto ou
ambiente de desenvolvimento integrado (IDE)
combinado com as ferramentas de linha de comando do Flutter.
A equipe do Flutter recomenda usar um editor que suporte
uma extensão ou plugin do Flutter, como VS Code e Android Studio.
Esses plugins oferecem preenchimento de código, realce de sintaxe,
assistências de edição de widget, suporte para executar e depurar e muito mais.

Você pode adicionar um plugin compatível para Visual Studio Code,
Android Studio ou IntelliJ IDEA Community, Educational,
e edições Ultimate.
O [plugin do Flutter][] _só_ funciona com
Android Studio e as edições listadas do IntelliJ IDEA.

(O [plugin do Dart][] suporta oito IDEs JetBrains adicionais.)

[plugin do Flutter]: https://plugins.jetbrains.com/plugin/9212-flutter
[plugin do Dart]: https://plugins.jetbrains.com/plugin/6351-dart

Siga estes procedimentos para adicionar o plugin do Flutter ao VS Code,
Android Studio ou IntelliJ.

Se você escolher outro IDE, avance
para [Escreva seu primeiro aplicativo Flutter][].

[Escreva seu primeiro aplicativo Flutter]: /get-started/codelab

{% tabs %}
{% tab "Visual Studio Code" %}

## Instale o VS Code

[VS Code][] é um editor de código para criar e depurar aplicativos.
Com a extensão Flutter instalada, você pode compilar, implantar e depurar
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

## Instalar a extensão Flutter do VS Code

1. Inicie o **VS Code**.

1. Abra um navegador e vá para a página da [extensão Flutter][]
   no Visual Studio Marketplace.

1. Clique em **Instalar**.
   A instalação da extensão Flutter também instala a extensão Dart.

[extensão Flutter]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter

## Validar sua configuração do VS Code

1. Vá para **Exibir** <span aria-label="e então">></span>
   **Paleta de comandos...**.

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `doctor`.

1. Selecione **Flutter: Executar Flutter Doctor**.

   Depois de selecionar este comando, o VS Code faz o seguinte.

   - Abre o painel **Saída**.
   - Exibe **flutter (flutter)** no menu suspenso no canto superior direito
     deste painel.
   - Exibe a saída do comando Flutter Doctor.

{% endtab %}
{% tab "Android Studio e IntelliJ" %}

## Instale o Android Studio ou IntelliJ IDEA

Android Studio e IntelliJ IDEA oferecem uma experiência completa de
IDE depois que você instala o plugin do Flutter.

Para instalar a versão mais recente dos seguintes IDEs, siga as instruções deles:

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
   <span aria-label="e então">></span> **Configurações...**.

   Você também pode pressionar <kbd>Cmd</kbd> + <kbd>,</kbd>.

   A caixa de diálogo **Preferências** é aberta.

1. Na lista à esquerda, selecione **Plugins**.

1. Na parte superior deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de pesquisa de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Instalar**.

1. Clique em **Sim** quando solicitado a instalar o plugin.

1. Clique em **Reiniciar** quando solicitado.

### Linux ou Windows

Use as seguintes instruções para Linux ou Windows:

1. Vá para **Arquivo** <span aria-label="e então">></span>
   **Configurações**.

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Alt</kbd> +
   <kbd>S</kbd>.

   A caixa de diálogo **Preferências** é aberta.

1. Na lista à esquerda, selecione **Plugins**.

1. Na parte superior deste painel, selecione **Marketplace**.

1. Digite `flutter` no campo de pesquisa de plugins.

1. Selecione o plugin **Flutter**.

1. Clique em **Instalar**.

1. Clique em **Sim** quando solicitado a instalar o plugin.

1. Clique em **Reiniciar** quando solicitado.

{% endtab %}
{% endtabs %}
