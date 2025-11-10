#### Compilar a versão iOS do app Flutter no Terminal

Para gerar as dependências necessárias da plataforma iOS,
execute o comando `flutter build`.

```console
$ flutter build ios --config-only --no-codesign --debug
```

```console
Warning: Building for device with codesigning disabled. You will have to manually codesign before deploying to device.
Building com.example.myApp for device (ios)...
```

<Tabs key="darwin-debug-flow">
<Tab name="Start from VS Code">

#### Começar a depuração primeiro com o VS Code {:#vscode-ios}

Se você usa o VS Code para depurar a maior parte do seu código, comece com esta seção.

##### Iniciar o depurador Dart no VS Code

{% render "docs/debug/debug-flow-vscode-as-start.md", add: add %}

##### Anexar ao processo Flutter no Xcode

Para anexar ao app Flutter no Xcode:

1. Vá para **Debug** <span aria-label="and then">></span>
   **Attach to Process** <span aria-label="and then">></span>

1. Selecione **Runner**. Ele deve estar no topo do
   menu **Attach to Process** sob o título **Likely Targets**.

</Tab>
<Tab name="Start from Xcode">

#### Começar a depuração primeiro com o Xcode {:#xcode-ios}

Se você usa o Xcode para depurar a maior parte do seu código, comece com esta seção.

##### Iniciar o depurador do Xcode

1. Abra `ios/Runner.xcworkspace` do diretório do seu app Flutter.

1. Selecione o dispositivo correto usando o menu **Scheme** na barra de ferramentas.

    Se você não tem preferência, escolha **iPhone Pro 14**.

   {% comment %}
    ![Selecting iPhone 14 in the Scheme menu in the Xcode toolbar](/assets/images/docs/testing/debugging/native/xcode/select-device.png){:width="100%"}
    <div class="figure-caption">

    Selecting iPhone 14 in the Scheme menu in the Xcode toolbar.

    </div>
    {% endcomment %}

1. Execute este Runner como um app normal no Xcode.

    {% comment %}
    ![Start button in Xcode interface](/assets/images/docs/testing/debugging/native/xcode/run-app.png)
    <div class="figure-caption">

    Start button displayed in Xcode interface.

    </div>
    {% endcomment %}

    Quando a execução for concluída, a área **Debug** na parte inferior do Xcode exibe
    uma mensagem com o URI do serviço Dart VM. Ela se parece com a seguinte resposta:

    ```console
    2023-07-12 14:55:39.966191-0500 Runner[58361:53017145]
        flutter: The Dart VM service is listening on
        http://127.0.0.1:50642/00wEOvfyff8=/
    ```

1. Copie o URI do serviço Dart VM.

##### Anexar à Dart VM no VS Code

1. Para abrir a paleta de comandos, vá para
    **View** <span aria-label="and then">></span>
    **Command Palette...**

    Você também pode pressionar <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `debug`.

1. Clique no comando **Debug: Attach to Flutter on Device**.

{% comment %}
    !['Running the Debug: Attach to Flutter on Device command in VS Code.'](/assets/images/docs/testing/debugging/vscode-ui/screens/attach-flutter-process-menu.png){:width="100%"}
{% endcomment %}

1. Na caixa **Paste an VM Service URI**, cole o URI que você copiou
    do Xcode e pressione <kbd>Enter</kbd>.

{% comment %}
    ![Alt text](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-add-attach-uri-filled.png)
{% endcomment %}

</Tab>
</Tabs>
