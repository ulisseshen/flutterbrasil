##### Ativar anexação automática

Você pode configurar o VS Code para anexar ao seu projeto de módulo Flutter
sempre que você iniciar a depuração.
Para ativar este recurso,
crie um arquivo `.vscode/launch.json` no seu projeto de módulo Flutter.

1. Vá para **View** <span aria-label="and then">></span> **Run**.

   Você também pode pressionar
   <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>.

   O VS Code exibe a barra lateral **Run and Debug**.

1. Nesta barra lateral, clique em **create a launch.json file**.

   O VS Code exibe o menu **Select debugger** no topo.

1. Selecione **Dart & Flutter**.

   O VS Code cria e então abre o arquivo `.vscode/launch.json`.

   <details markdown="1">
   <summary>Expandir para ver um exemplo de arquivo launch.json</summary>

    ```json
    {
        // Use IntelliSense to learn about possible attributes.
        // Hover to view descriptions of existing attributes.
        // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
        "version": "0.2.0",
        "configurations": [
            {
                "name": "my_app",
                "request": "launch",
                "type": "dart"
            },
            {
                "name": "my_app (profile mode)",
                "request": "launch",
                "type": "dart",
                "flutterMode": "profile"
            },
            {
                "name": "my_app (release mode)",
                "request": "launch",
                "type": "dart",
                "flutterMode": "release"
            }
        ]
    }
    ```

    </details>

1. Para anexar, vá para **Run** <span aria-label="and then">></span>
   **Start Debugging**.

   Você também pode pressionar <kbd>F5</kbd>.
