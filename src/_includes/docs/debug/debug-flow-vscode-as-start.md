<!-- ia-translate: true -->

1. Para abrir o diretório da aplicação Flutter, vá para
   **File** <span aria-label="and then">></span>
   **Open Folder...** e escolha o diretório `my_app`.

1. Abra o arquivo `lib/main.dart`.

1. Se você pode construir uma aplicação para mais de um dispositivo,
   você deve selecionar o dispositivo primeiro.

   Vá para
   **View** <span aria-label="and then">></span>
   **Command Palette...**

   Você também pode pressionar <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
   <kbd>Shift</kbd> + <kbd>P</kbd>.

1. Digite `flutter select`.

1. Clique no comando **Flutter: Select Device**.

1. Escolha o seu dispositivo de destino.

1. Clique no ícone de depuração
   (![VS Code's bug icon to trigger the debugging mode of a Flutter app](/assets/images/docs/testing/debugging/vscode-ui/icons/debug.png)).
   Isso abre o painel **Debug** e inicia a aplicação.
   Aguarde o aplicativo ser iniciado no dispositivo e o painel de depuração
   indicar **Connected**.
   O depurador leva mais tempo para iniciar na primeira vez.
   Inicializações subsequentes começam mais rápido.

   Esta aplicação Flutter contém dois botões:

   - **Launch in browser**: Este botão abre esta página no
     navegador padrão do seu dispositivo.
   - **Launch in app**: Este botão abre esta página dentro da sua aplicação.
     Este botão funciona apenas para iOS ou Android. Aplicações desktop iniciam um navegador.

{% if add == 'launch' -%}
{% render "docs/debug/vscode-flutter-attach-json.md" %}
{% endif -%}
