 1. <h3>Determine o local de instalação do seu Flutter SDK</h3>

    Copie o caminho absoluto para o diretório onde você
    baixou e extraiu o Flutter SDK.

 1. <h3>Determine seu shell padrão</h3>

    Se você não sabe qual shell você usa,
    verifique qual shell inicia quando você abre uma nova janela de console.

    ```console
    $ echo $SHELL
    ```

 1. <h3>Adicione o bin do Flutter SDK ao seu path</h3>

    Para adicionar o diretório `bin` da sua instalação Flutter ao seu `PATH`:

    1. Expanda as instruções para o seu shell padrão.
    1. Copie o comando fornecido.
    1. Substitua `<path-to-sdk>` pelo caminho para sua instalação do Flutter SDK.
    1. Execute o comando editado no seu terminal preferido com esse shell.

    <hr>

    <details>
    <summary>Expand for <code>bash</code> instructions</summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>:$PATH"' >> ~/.bash_profile
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.bash_profile
    ```

    </details>

    <details>
    <summary>Expand for <code>zsh</code> instructions</summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>/bin:$PATH"' >> ~/.zshenv
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.zshenv
    ```

    </details>

    <details>
    <summary>Expand for <code>fish</code> instructions</summary>

    ```console
    $ fish_add_path -g -p <path-to-sdk>/bin
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ fish_add_path -g -p ~/develop/flutter/bin
    ```

    </details>

    <details>
    <summary>Expand for <code>csh</code> instructions</summary>

    ```console
    $ echo 'setenv PATH "<path-to-sdk>/bin:$PATH"' >> ~/.cshrc
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ echo 'setenv PATH "$HOME/develop/flutter/bin:$PATH"' >> ~/.cshrc
    ```

    </details>

    <details>
    <summary>Expand for <code>tcsh</code> instructions</summary>

    ```console
    $ echo 'setenv PATH "<path-to-sdk>/bin:$PATH"' >> ~/.tcshrc
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ echo 'setenv PATH "$HOME/develop/flutter/bin:$PATH"' >> ~/.tcshrc
    ```

    </details>

    <details>
    <summary>Expand for <code>ksh</code> instructions</summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>/bin:$PATH"' >> ~/.profile
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.profile
    ```

    </details>

    <details>
    <summary>Expand for <code>sh</code> instructions</summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>/bin:$PATH"' >> ~/.profile
    ```

    For example, if you downloaded Flutter into a
    `develop/flutter` folder inside your user directory,
    you'd run the following:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.profile
    ```

    </details>

 1. <h3>Aplique suas mudanças</h3>

    Para aplicar esta mudança e obter acesso à ferramenta `flutter`,
    feche e reabra todas as sessões de shell abertas em seus terminais e IDEs.

 1. <h3>Valide sua configuração</h3>

    Para garantir que você adicionou com sucesso o SDK ao seu `PATH`,
    abra seu terminal preferido com seu shell padrão,
    então tente executar as ferramentas `flutter` e `dart`.

    ```console
    $ flutter --version
    $ dart --version
    ```

    If either command isn't found,
    check out [Flutter installation troubleshooting][troubleshoot].

{: .steps}

[troubleshoot]: /install/troubleshoot
