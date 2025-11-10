<!-- ia-translate: true -->

:::note
As etapas a seguir assumem que
você já [ativou o suporte ao Linux][chromeos-linux] e que
está usando Bash ou o shell padrão no ChromeOS.

Se você estiver usando um shell diferente além do padrão ou Bash, siga as
[instruções de adicionar ao path para Linux][linux-path]{: target="_blank"} em vez disso.
:::

 1. <h3>Determine o local de instalação do seu Flutter SDK</h3>

    Copie o caminho absoluto para o diretório no qual você
    baixou e extraiu o Flutter SDK.

 1. <h3>Adicione o bin do Flutter SDK ao seu path</h3>

    Para adicionar o diretório `bin` da sua instalação do Flutter ao seu `PATH`:

    1. Copie o comando a seguir.
    1. Substitua `<path-to-sdk>` pelo caminho para sua instalação do Flutter SDK.
    1. Execute o comando editado no seu terminal preferido.

    ```console
    $ echo 'export PATH="<path-to-sdk>:$PATH"' >> ~/.bash_profile
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.bash_profile
    ```

 1. <h3>Aplique suas alterações</h3>

    Para aplicar esta mudança e obter acesso à ferramenta `flutter`,
    feche e reabra todas as sessões Zsh abertas em seus apps de terminal e IDEs.

 1. <h3>Valide sua configuração</h3>

    Para garantir que você adicionou com sucesso o SDK ao seu `PATH`,
    abra uma sessão Zsh no seu terminal preferido,
    então tente executar as ferramentas `flutter` e `dart`.

    ```console
    $ flutter --version
    $ dart --version
    ```

    Se qualquer comando não for encontrado,
    confira [Solução de problemas de instalação do Flutter][troubleshoot].

{: .steps}

[chromeos-linux]: https://support.google.com/chromebook/answer/9145439
[linux-path]: /install/add-to-path#linux
[troubleshoot]: /install/troubleshoot
