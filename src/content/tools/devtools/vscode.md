---
ia-translate: true
title: Executar DevTools do VS Code
description: Aprenda como executar e usar DevTools do VS Code.
---

## Adicionar as extensões do VS Code

Para usar DevTools do VS Code, você precisa da [extensão Dart][Dart extension].
Se você estiver depurando aplicações Flutter, você também deve instalar
a [extensão Flutter][Flutter extension].

## Iniciar uma aplicação para depurar

Inicie uma sessão de depuração para sua aplicação abrindo a pasta raiz
do seu projeto (aquela que contém `pubspec.yaml`)
no VS Code e clicando em **Run > Start Debugging** (`F5`).

## Executar DevTools

Quando a sessão de depuração estiver ativa e a aplicação tiver iniciado,
os comandos **Open DevTools** ficam disponíveis na
paleta de comandos do VS Code (`F1`):

![Screenshot showing Open DevTools commands](/assets/images/docs/tools/vs-code/vscode_command.png){:width="100%"}

A ferramenta escolhida será aberta embutida dentro do VS Code.

![Screenshot showing DevTools embedded in VS Code](/assets/images/docs/tools/vs-code/vscode_embedded.png){:width="100%"}

Você pode optar por ter DevTools sempre aberto
em um navegador com a configuração `dart.embedDevTools`,
e controlar se ele abre como uma janela completa ou
em uma nova coluna ao lado do seu editor atual com a
configuração `dart.devToolsLocation`.

Uma lista completa de configurações Dart/Flutter está disponível em
[dartcode.org](https://dartcode.org/docs/settings/)
ou no
[editor de configurações do VS Code](https://code.visualstudio.com/docs/getstarted/settings#_settings-editor).
Algumas configurações recomendadas para Dart/Flutter no VS Code
também podem ser encontradas em
[dartcode.org](https://dartcode.org/docs/recommended-settings/).

Você também pode ver se DevTools está em execução
e executá-lo em um navegador pela área de status do idioma
(o ícone `{}` próximo a **Dart** na barra de status).

![Screenshot showing DevTools in the VS Code language status area](/assets/images/docs/tools/vs-code/vscode_status_bar.png){:width="100%"}

[Dart extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code
[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
