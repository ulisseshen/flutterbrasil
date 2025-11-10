#### Crie a versão macOS do app Flutter no Terminal

Para gerar as dependências de plataforma macOS necessárias,
execute o comando `flutter build`.

```console
flutter build macos --debug
```

```console
Building macOS application...
```

<Tabs key="darwin-debug-flow">
<Tab name="Start from VS Code">

#### Comece a depuração pelo VS Code primeiro {:#vscode-macos}

##### Inicie o depurador no VS Code

{% render "docs/debug/debug-flow-vscode-as-start.md" %}

##### Anexe ao processo Flutter no Xcode

1. Para anexar ao app Flutter, vá em
   **Debug** <span aria-label="and then">></span>
   **Attach to Process** <span aria-label="and then">></span>
   **Runner**.

   **Runner** deve estar no topo do menu **Attach to Process**
   sob o título **Likely Targets**.

</Tab>
<Tab name="Start from XCode">

#### Comece a depuração pelo Xcode primeiro {:#xcode-macos}

##### Inicie o depurador no Xcode

1. Abra `macos/Runner.xcworkspace` do diretório do seu app Flutter.

1. Execute este Runner como um app normal no Xcode.

{% comment %}
   ![Start button in Xcode interface](/assets/images/docs/testing/debugging/native/xcode/run-app.png)
   <div class="figure-caption">

   Start button displayed in Xcode interface.

   </div>
{% endcomment %}

   Quando a execução terminar, a área **Debug** na parte inferior do Xcode exibe
   uma mensagem com a URI do serviço Dart VM. Ela se parece com a seguinte resposta:

   ```console
   2023-07-12 14:55:39.966191-0500 Runner[58361:53017145]
       flutter: The Dart VM service is listening on
       http://127.0.0.1:50642/00wEOvfyff8=/
   ```

1. Copie a URI do serviço Dart VM.

##### Anexe à Dart VM no VS Code

1. Para abrir a paleta de comandos, vá em **View** > **Command Palette...**

   Você também pode pressionar <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `debug`.

1. Clique no comando **Debug: Attach to Flutter on Device**.

{% comment %}
   !['Running the Debug: Attach to Flutter on Device command in VS Code.'](/assets/images/docs/testing/debugging/vscode-ui/screens/attach-flutter-process-menu.png){:width="100%"}
{% endcomment %}

1. Na caixa **Paste an VM Service URI**, cole a URI que você copiou
   do Xcode e pressione <kbd>Enter</kbd>.

{% comment %}
   ![Alt text](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-add-attach-uri-filled.png)
{% endcomment %}

</Tab>
</Tabs>
