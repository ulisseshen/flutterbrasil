---
ia-translate: true
title: Execute DevTools do VS Code
description: Aprenda como iniciar e usar DevTools do VS Code.
---

## Adicione as extensões do VS Code

Para usar DevTools do VS Code, você precisa da [extensão Dart][Dart extension].
Se você estiver depurando aplicações Flutter, você também deve instalar
a [extensão Flutter][Flutter extension].

## Inicie uma aplicação para depurar {: #run-and-debug}

Inicie uma sessão de debug para sua aplicação abrindo a pasta raiz
do seu projeto (aquela contendo `pubspec.yaml`)
no VS Code e clicando em **Run > Start Debugging** (`F5`).

## Inicie DevTools

Uma vez que a sessão de debug esteja ativa e a aplicação tenha iniciado,
os comandos **Open DevTools** ficam disponíveis na
paleta de comandos do VS Code (`F1`):

![Screenshot showing Open DevTools commands](/assets/images/docs/tools/vs-code/vscode_command.png){:width="100%"}

A ferramenta escolhida será aberta embutida dentro do VS Code.

![Screenshot showing DevTools embedded in VS Code](/assets/images/docs/tools/vs-code/vscode_embedded.png){:width="100%"}

Você pode escolher ter DevTools sempre aberto
em um navegador com a configuração `dart.embedDevTools`,
e controlar se ele abre como uma janela completa ou
em uma nova coluna ao lado do seu editor atual com a
configuração `dartbrasil.devToolsLocation`.

Uma lista completa de configurações Dart/Flutter está disponível em
[dartcode.org](https://dartcode.org/docs/settings/)
ou no
[editor de configurações do VS Code](https://code.visualstudio.com/docs/getstarted/settings#_settings-editor).
Algumas configurações recomendadas para Dart/Flutter no VS Code
também podem ser encontradas em
[dartcode.org](https://dartcode.org/docs/recommended-settings/).

Você também pode ver se DevTools está em execução
e iniciá-lo em um navegador a partir da área de status de idioma
(o ícone `{}` ao lado de **Dart** na barra de status).

![Screenshot showing DevTools in the VS Code language status area](/assets/images/docs/tools/vs-code/vscode_status_bar.png){:width="100%"}

[Dart extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.dart-code
[Flutter extension]: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
