#### Construa a versão Windows da aplicação Flutter no PowerShell ou no Command Prompt

Para gerar as dependências de plataforma Windows necessárias,
execute o comando `flutter build`.

```console
C:\> flutter build windows --debug
```

```console
Building Windows application...                                    31.4s
√  Built build\windows\runner\Debug\my_app.exe.
```

<Tabs key="windows-debug-flow">
<Tab name="Start from VS Code">

#### Comece a depuração primeiro com o VS Code {:#vscode-windows}

Se você usa VS Code para depurar a maior parte do seu código, comece com esta seção.

##### Inicie o debugger no VS Code

{% render "docs/debug/debug-flow-vscode-as-start.md" %}

{% comment %}
     !['Flutter app generated as a Windows app. The app displays two buttons to open this page in a browser or in the app'](/assets/images/docs/testing/debugging/native/url-launcher-app/windows.png){:width="50%"}
     <div class="figure-caption">

     Flutter app generated as a Windows app. The app displays two buttons to open this page in a browser or in the app.

     </div>
{% endcomment %}

##### Anexe ao processo Flutter no Visual Studio

1. Para abrir o arquivo de solução do projeto, vá para
   **File** <span aria-label="and then">></span>
   **Open** <span aria-label="and then">></span>
   **Project/Solution…**

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd>.

1. Escolha o arquivo `build/windows/my_app.sln` no diretório da sua aplicação Flutter.

{% comment %}
   ![Open Project/Solution dialog box in Visual Studio 2022 with my_app.sln file selected.](/assets/images/docs/testing/debugging/native/visual-studio/choose-solution.png){:width="100%"}
   <div class="figure-caption">

   Open Project/Solution dialog box in Visual Studio 2022 with
   `my_app.sln` file selected.

   </div>
{% endcomment %}

1. Vá para **Debug** > **Attach to Process**.

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Alt</kbd> + <kbd>P</kbd>.

1. Na caixa de diálogo **Attach to Process**, escolha `my_app.exe`.

{% comment %}
   ![Selecting my_app from the Attach to Process dialog box](/assets/images/docs/testing/debugging/native/visual-studio/attach-to-process-dialog.png){:width="100%"}
{% endcomment %}

   Visual Studio começa a monitorar a aplicação Flutter.

{% comment %}
   ![Visual Studio debugger running and monitoring the Flutter app](/assets/images/docs/testing/debugging/native/visual-studio/debugger-active.png){:width="100%"}
{% endcomment %}

</Tab>
<Tab name="Start from Visual Studio">

#### Comece a depuração primeiro com o Visual Studio

Se você usa Visual Studio para depurar a maior parte do seu código, comece com esta seção.

##### Inicie o debugger local do Windows

1. Para abrir o arquivo de solução do projeto, vá para
   **File** <span aria-label="and then">></span>
   **Open** <span aria-label="and then">></span>
   **Project/Solution…**

   Você também pode pressionar <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>O</kbd>.

1. Escolha o arquivo `build/windows/my_app.sln` no diretório da sua aplicação Flutter.

{% comment %}
   ![Open Project/Solution dialog box in Visual Studio 2022 with my_app.sln file selected.](/assets/images/docs/testing/debugging/native/visual-studio/choose-solution.png){:width="100%"}
   <div class="figure-caption">

   Open Project/Solution dialog box in Visual Studio 2022 with
   `my_app.sln` file selected.

   </div>
{% endcomment %}

1. Defina `my_app` como o projeto de inicialização.
   No **Solution Explorer**, clique com o botão direito em `my_app` e selecione
   **Set as Startup Project**.

1. Clique em **Local Windows Debugger** para iniciar a depuração.

   Você também pode pressionar <kbd>F5</kbd>.

   Quando a aplicação Flutter é iniciada, uma janela de console exibe
   uma mensagem com o URI do serviço Dart VM. Ela se assemelha à seguinte resposta:

   ```console
   flutter: The Dart VM service is listening on http://127.0.0.1:62080/KPHEj2qPD1E=/
   ```

1. Copie o URI do serviço Dart VM.

##### Anexe à Dart VM no VS Code

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
   do Visual Studio e pressione <kbd>Enter</kbd>.

{% comment %}
   ![Alt text](/assets/images/docs/testing/debugging/vscode-ui/screens/vscode-add-attach-uri-filled.png)
{% endcomment %}

</Tab>
</Tabs>
