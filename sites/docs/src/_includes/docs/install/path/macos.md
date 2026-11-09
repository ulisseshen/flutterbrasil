---
ia-translate: true
---

:::note
Os passos a seguir assumem que você está
usando o [shell padrão][zsh-mac] no macOS, Zsh.

Se você usar outro shell além de Zsh,
confira [este tutorial sobre como definir seu PATH][other-path].
:::

 1. <h3>Determine a localização de instalação do Flutter SDK</h3>

    Copie o caminho absoluto do diretório em que você
    baixou e extraiu o Flutter SDK.

 1. <h3>Abra ou crie o arquivo de variável de ambiente do Zsh</h3>

    Se existir, abra o [arquivo de variável de ambiente do Zsh][zsh-files]
    `~/.zprofile` no seu editor de texto preferido.
    Se não existir, crie o arquivo `~/.zprofile`.

 1. <h3>Adicione o bin do Flutter SDK ao seu caminho</h3>

    No final do seu arquivo `~/.zprofile`,
    use o comando `export` incorporado para atualizar a variável `PATH`
    para incluir o diretório `bin` da sua instalação do Flutter.

    Substitua `<path-to-sdk>` pelo caminho para sua instalação do Flutter SDK.

    ```bash
    export PATH="<path-to-sdk>/bin:$PATH"
    ```

    Por exemplo, se você baixou o Flutter em uma
    pasta `develop/flutter` dentro do seu diretório de usuário,
    você adicionaria o seguinte ao arquivo:

    ```bash
    export PATH="$HOME/develop/flutter/bin:$PATH"
    ```

 1. <h3>Salve suas alterações</h3>

    Salve e feche o arquivo `~/.zprofile` que você editou.

 1. <h3>Aplique suas alterações</h3>

    Para aplicar essa mudança e obter acesso à ferramenta `flutter`,
    feche e reabra todas as sessões Zsh abertas em seus aplicativos de terminal e IDEs.

 1. <h3>Valide sua configuração</h3>

    Para garantir que você adicionou com sucesso o SDK ao seu `PATH`,
    abra uma sessão Zsh no seu terminal preferido,
    e tente executar as ferramentas `flutter` e `dart`.

    ```console
    $ flutter --version
    $ dart --version
    ```

    Se algum comando não for encontrado,
    confira [Solução de problemas de instalação do Flutter][troubleshoot].

{: .steps}

[zsh-mac]: https://support.apple.com/en-us/102360
[zsh-files]: https://zsh.sourceforge.io/Intro/intro_3.html
[other-path]: https://www.cyberciti.biz/faq/unix-linux-adding-path/
[troubleshoot]: /install/troubleshoot
