---
ia-translate: true
title: Execute o DevTools a partir do VS Code
description: Aprenda como iniciar e usar o DevTools a partir do VS Code.
---

## Adicione as extensões do VS Code

Para usar o DevTools a partir do VS Code, você precisa da
[extensão Dart][]. Se você estiver depurando aplicativos
Flutter, você também deve instalar a [extensão Flutter][].

## Inicie um aplicativo para depurar

Inicie uma sessão de depuração para seu aplicativo abrindo a
pasta raiz do seu projeto (aquela que contém `pubspec.yaml`)
no VS Code e clicando em **Executar > Iniciar Depuração**
(`F5`).

## Inicie o DevTools

Assim que a sessão de depuração estiver ativa e o aplicativo
tiver sido iniciado, os comandos **Abrir DevTools**
tornam-se disponíveis na paleta de comandos do VS Code (`F1`):

![Captura de tela mostrando os comandos Abrir DevTools](/assets/images/docs/tools/vs-code/vscode_command.png){:width="100%"}

A ferramenta escolhida será aberta incorporada dentro do VS Code.

![Captura de tela mostrando o DevTools incorporado no VS Code](/assets/images/docs/tools/vs-code/vscode_embedded.png){:width="100%"}

Você pode escolher ter o DevTools sempre aberto em um navegador
com a configuração `dart.embedDevTools`, e controlar se ele
abre em uma janela inteira ou em uma nova coluna ao lado do
seu editor atual com a configuração `dart.devToolsLocation`.

Uma lista completa de configurações Dart/Flutter está disponível
em [dartcode.org](https://dartcode.org/docs/settings/) ou no
[editor de configurações do VS Code](https://code.visualstudio.com/docs/getstarted/settings#_settings-editor).
Algumas configurações recomendadas para Dart/Flutter no VS Code
também podem ser encontradas em
[dartcode.org](https://dartcode.org/docs/recommended-settings/).

Você também pode ver se o DevTools está em execução e iniciá-lo
em um navegador a partir da área de status da linguagem (o
ícone `{}` ao lado de **Dart** na barra de status).

![Captura de tela mostrando o DevTools na área de status da linguagem do VS Code](/assets/images/docs/tools/vs-code/vscode_status_bar.png){:width="100%"}

[Dart extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code
[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
