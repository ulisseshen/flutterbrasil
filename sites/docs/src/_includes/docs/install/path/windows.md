---
ia-translate: true
---

1. <h3>Determine o local de instalação do Flutter SDK</h3>

   Copie o caminho absoluto para o diretório no qual você
   baixou e extraiu o Flutter SDK.

1. <h3>Navegue até as configurações de variáveis de ambiente</h3>

   1. Pressione <kbd>Windows</kbd> + <kbd>Pause</kbd>.

      Se o seu teclado não tiver uma tecla <kbd>Pause</kbd>,
      tente <kbd>Windows</kbd> + <kbd>Fn</kbd> + <kbd>B</kbd>.

      A caixa de diálogo **System > About** será aberta.

   1. Clique em **Advanced System Settings**
      <span aria-label="and then">></span> **Advanced**
      <span aria-label="and then">></span> **Environment Variables...**.

      A caixa de diálogo **Environment Variables** será aberta.

1. <h3>Adicione o bin do Flutter SDK ao seu path</h3>

   1. Na seção **User variables for (username)**
      da caixa de diálogo **Environment Variables**,
      procure pela entrada **Path**.

   1. Se a entrada **Path** existir, clique duas vezes nela.

      A caixa de diálogo **Edit Environment Variable** deve ser aberta.

      1. Clique duas vezes dentro de uma linha vazia.

      1. Digite o caminho para o diretório `bin` da sua instalação do Flutter.

         Por exemplo, se você baixou o Flutter em uma
         pasta `develop\flutter` dentro do seu diretório de usuário,
         você digitaria o seguinte:

         ```plaintext
         %USERPROFILE%\develop\flutter\bin
         ```

      1. Clique na entrada do Flutter que você adicionou para selecioná-la.

      1. Clique em **Move Up** até que a entrada do Flutter fique no topo da lista.

      1. Para confirmar suas alterações, clique em **OK** três vezes.

      {: type="a"}

   1. Se a entrada não existir, clique em **New...**.

      A caixa de diálogo **Edit Environment Variable** deve ser aberta.

      1. Na caixa **Variable Name**, digite `Path`.

      1. Na caixa **Variable Value**,
         digite o caminho para o diretório `bin` da sua instalação do Flutter.

         Por exemplo, se você baixou o Flutter em uma
         pasta `develop\flutter` dentro do seu diretório de usuário,
         você digitaria o seguinte:

         ```plaintext
         %USERPROFILE%\develop\flutter\bin
         ```

      1. Para confirmar suas alterações, clique em **OK** três vezes.

      {: type="a"}

1. <h3>Aplique suas alterações</h3>

   Para aplicar essa alteração e obter acesso à ferramenta `flutter`,
   feche e reabra todos os prompts de comando abertos,
   sessões nos seus apps de terminal e IDEs.

1. <h3>Valide sua configuração</h3>

   Para garantir que você adicionou o SDK ao seu `PATH` com sucesso,
   abra o prompt de comando ou seu app de terminal preferido,
   e então tente executar as ferramentas `flutter` e `dart`.

   ```console
   $ flutter --version
   $ dart --version
   ```

   Se qualquer um dos comandos não for encontrado,
   confira [Solução de problemas de instalação do Flutter][troubleshoot].

{: .steps}

[troubleshoot]: /install/troubleshoot
