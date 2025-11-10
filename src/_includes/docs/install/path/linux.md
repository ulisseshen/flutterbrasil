<!-- ia-translate: true -->

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
    <summary>Expanda para instruções do <code>bash</code></summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>:$PATH"' >> ~/.bash_profile
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.bash_profile
    ```

    </details>

    <details>
    <summary>Expanda para instruções do <code>zsh</code></summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>/bin:$PATH"' >> ~/.zshenv
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.zshenv
    ```

    </details>

    <details>
    <summary>Expanda para instruções do <code>fish</code></summary>

    ```console
    $ fish_add_path -g -p <path-to-sdk>/bin
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ fish_add_path -g -p ~/develop/flutter/bin
    ```

    </details>

    <details>
    <summary>Expanda para instruções do <code>csh</code></summary>

    ```console
    $ echo 'setenv PATH "<path-to-sdk>/bin:$PATH"' >> ~/.cshrc
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ echo 'setenv PATH "$HOME/develop/flutter/bin:$PATH"' >> ~/.cshrc
    ```

    </details>

    <details>
    <summary>Expanda para instruções do <code>tcsh</code></summary>

    ```console
    $ echo 'setenv PATH "<path-to-sdk>/bin:$PATH"' >> ~/.tcshrc
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ echo 'setenv PATH "$HOME/develop/flutter/bin:$PATH"' >> ~/.tcshrc
    ```

    </details>

    <details>
    <summary>Expanda para instruções do <code>ksh</code></summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>/bin:$PATH"' >> ~/.profile
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

    ```console
    $ echo 'export PATH="$HOME/develop/flutter/bin:$PATH"' >> ~/.profile
    ```

    </details>

    <details>
    <summary>Expanda para instruções do <code>sh</code></summary>

    ```console
    $ echo 'export PATH="<path-to-sdk>/bin:$PATH"' >> ~/.profile
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você executaria o seguinte:

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

    Se qualquer comando não for encontrado,
    confira [Solução de problemas de instalação do Flutter][troubleshoot].

{: .steps}

[troubleshoot]: /install/troubleshoot
