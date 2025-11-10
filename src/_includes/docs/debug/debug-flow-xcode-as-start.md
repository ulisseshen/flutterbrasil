---
ia-translate: true
---
##### Inicie o debugger do Xcode
{:.no_toc}

1. Abra `ios/Runner.xcworkspace` do diretório do seu app Flutter.

1. Selecione o dispositivo correto usando o menu **Scheme** na barra de ferramentas.

    Se você não tiver preferência, escolha **iPhone Pro 14**.

   {% comment %}
    ![Selecting iPhone 14 in the Scheme menu in the Xcode toolbar](/assets/images/docs/testing/debugging/native/xcode/select-device.png){:width="100%"}
    <div markdown="1">{:.figure-caption}
    Selecting iPhone 14 in the Scheme menu in the Xcode toolbar.
    </div>
    {% endcomment %}

1. Execute este Runner como um app normal no Xcode.

    {% comment %}
    ![Start button in Xcode interface](/assets/images/docs/testing/debugging/native/xcode/run-app.png)
    <div markdown="1">{:.figure-caption}
    Start button displayed in Xcode interface.
    </div>
    {% endcomment %}

    Quando a execução terminar, a área **Debug** na parte inferior do Xcode exibe
    uma mensagem com a URI do serviço Dart VM. Ela se assemelha à seguinte resposta:

    ```console
    2023-07-12 14:55:39.966191-0500 Runner[58361:53017145]
        flutter: The Dart VM service is listening on
        http://127.0.0.1:50642/00wEOvfyff8=/
    ```

1. Copie a URI do serviço Dart VM.

##### Conecte à Dart VM no VS Code
{:.no_toc}

1. Para abrir a paleta de comandos, vá para
    **View** <span aria-label="and then">></span>
    **Command Palette...**

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
