<!-- ia-translate: true -->
[![Logotipo do Flutter]](https://docs.flutter.dev)

[Logotipo do Flutter]: https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/flutter/icon/64.png?raw=1

# Site de documentação do [Flutter][]

O [site de documentação][Flutter] para o [framework Flutter][],
construído com [Eleventy][] e hospedado no [Firebase][].

[Framework Flutter]: https://flutter.dev
[Eleventy]: https://11ty.dev/
[Firebase]: https://firebase.google.com/

[Status da Construção]: https://github.com/flutter/website/workflows/build/badge.svg
[Flutter]: https://docs.flutter.dev/
[Repositório no GitHub Actions]: https://github.com/flutter/website/actions?query=workflow%3Abuild+branch%3Amain

<a href="https://idx.google.com/import?url=https%3A%2F%2Fgithub.com%2Fflutter%2Fwebsite">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.idx.dev/btn/open_dark_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.idx.dev/btn/open_light_32.svg">
    <img
      height="32"
      alt="Abrir no IDX"
      src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

## Problemas, bugs e solicitações

Agradecemos contribuições e feedback em nosso site.
Por favor, registre uma solicitação em nosso
[rastreador de problemas](https://github.com/flutter/website/issues/new/choose)
ou crie um [pull request](https://github.com/flutter/website/pulls).
Para alterações simples (como ajustar algum texto),
é mais fácil fazer as alterações usando a IU do GitHub.

Se você tiver um problema com os
docs da API em [api.flutter.dev](https://api.flutter.dev),
por favor, registre esses problemas no
repositório [`flutter/flutter`](https://github.com/flutter/flutter/issues),
e não neste repositório (`flutter/website`).
Os docs da API estão incorporados no código-fonte do Flutter,
então a equipe de engenharia lida com eles.


## Antes de enviar um PR

Adoramos quando a comunidade se envolve na melhoria de nossos documentos!
Mas aqui estão algumas coisas a ter em mente antes de enviar um PR:

- Ao analisar os problemas,
  às vezes, marcamos um problema com a tag **PRs welcome** (PRs são bem-vindos).
  Mas também aceitamos PRs em outros problemas -
  não precisa ser marcado com essa tag.
- Por favor, não execute nossos documentos pelo Grammarly (ou similar)
  e envie essas alterações como um PR.
- Seguimos as [Diretrizes de estilo de documentação do Google para desenvolvedores][] -
  por exemplo, não use "i.e." ou "e.g.",
  evite escrever na primeira pessoa,
  e evite escrever no tempo futuro.
  Você pode começar com os
  [destaques do guia de estilo](https://developers.google.com/style/highlights)
  ou a [lista de palavras](https://developers.google.com/style/word-list),
  ou use a barra de pesquisa que está no topo de cada página do guia de estilo.

> Nós realmente agradecemos sua disposição e ajuda
> em manter os documentos do site atualizados!

[Diretrizes de estilo de documentação do Google para desenvolvedores]: https://developers.google.com/style

## Contribuindo

Para atualizar este site, faça um fork do repositório, faça suas alterações
e gere um pull request.
Para pequenas alterações contidas (como correções de estilo e erros de digitação),
você provavelmente não precisa construir este site.
Muitas vezes, você pode fazer alterações usando a IU do GitHub.
Se necessário, podemos organizar as alterações automaticamente em seu pull request.

> [!IMPORTANTE]
> Se você estiver clonando este repositório localmente,
> siga as instruções abaixo sobre como clonar com seu submódulo.

Se a sua alteração envolver exemplos de código, adicionar/remover páginas ou afetar a navegação,
considere construir e testar seu trabalho antes de enviar.

Se você quiser ou precisar construir o site, siga as etapas abaixo.

## Construir o site

Para alterações além de pequenos ajustes de texto e CSS,
recomendamos executar o site localmente para
habilitar um ciclo de edição-atualização.

### Obtenha os pré-requisitos

Instale as seguintes ferramentas para construir e desenvolver o site:

#### Flutter

A versão estável mais recente do Flutter, que inclui o Dart,
é necessária para construir o site e executar suas ferramentas.
Se você não tem o Flutter ou precisa atualizar, siga as
instruções em [Instalar o Flutter][] ou [Atualizar o Flutter][].

Se você já tem o Flutter instalado, verifique se ele está no seu caminho
e já é a versão estável mais recente:

```console
flutter --version
```

[Instalar o Flutter]: https://docs.flutter.dev/get-started
[Atualizar o Flutter]: https://docs.flutter.dev/release/upgrade

#### Node.js

A versão LTS estável **mais recente** do Node.js é necessária para construir o site.
Se você não tem o Node.js ou precisa atualizar, baixe a
versão correspondente do seu computador e siga as instruções
do [arquivo de download do Node.js][].
Se preferir, você pode usar um gerenciador de versão como o [nvm][],
e executar `nvm install` a partir do diretório raiz do repositório.

Se você já tem o Node instalado, verifique se ele está disponível em seu caminho
e já é a versão estável mais recente _(atualmente `22.12` ou posterior)_:

```console
node --version
```

Se sua versão estiver desatualizada,
siga as instruções de atualização de como você o instalou originalmente.

[arquivo de download do Node.js]: https://nodejs.org/en/download/
[nvm]: https://github.com/nvm-sh/nvm

### Clone este repositório e seus submódulos

> [!NOTA]
> Este repositório tem _submódulos_ git, o que afeta como você o clona.
> A documentação do GitHub tem ajuda geral sobre
> [forking][] e [clonagem][] de repositórios.

Se você não é membro da organização Flutter,
recomendamos que você **crie um fork** deste repositório em sua própria conta,
e então envie um PR desse fork.

Depois de ter um fork (ou você é um membro da organização Flutter),
_escolha uma_ das seguintes técnicas de clonagem de submódulo:

1. Clone o repositório e seu submódulo ao mesmo tempo
   usando a opção `--recurse-submodules`:

   ```console
   git clone --recurse-submodules https://github.com/flutter/website.git
   ```

2. Se você já clonou o repositório sem seu submódulo,
   então execute este comando a partir da raiz do repositório:

   ```console
   git submodule update --init --recursive
   ```

> [!NOTA]
> A qualquer momento durante o desenvolvimento
> você pode usar o comando `git submodule` para atualizar os submódulos:
>
> ```console
> git pull && git submodule update --init --recursive
> ```

[clonagem]: https://docs.github.com/repositories/creating-and-managing-repositories/cloning-a-repository
[forking]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo

## Configure seu ambiente local e sirva as alterações

Antes de continuar a configurar a infraestrutura do site,
verifique se as versões corretas do Flutter e Node.js estão configuradas e disponíveis seguindo as instruções em [Obtenha os pré-requisitos](#get-the-prerequisites).

1. _Opcional:_ Depois de clonar o repositório e seus submódulos,
   crie um branch para suas alterações:

   ```console
   git checkout -b <NOME_DO_BRANCH>
   ```

2. A partir do diretório raiz do repositório,
   busque as dependências Dart do site.

   ```console
   dart pub get
   ```

3. _Opcional:_ Recomendamos que você use `pnpm`, mas você também pode usar `npm`.
   Instale `pnpm`, um gerenciador de pacotes alternativo e eficiente para
   pacotes npm. Se você já tem `pnpm`, verifique se tem a
   versão estável mais recente.

   ```console
   node --version
   ```

   Se você ainda não tem o `pnpm` instalado, recomendamos
   usar o [`corepack`][] para instalar e gerenciar as versões do `pnpm`,
   já que o `corepack` é fornecido com a maioria das instalações do
   Node. Se você instalou o `node` usando o Homebrew, precisará
   instalar o corepack separadamente:

   ```console
   brew install corepack
   ```

   Se você não usou o `corepack` antes, precisará
   primeiro habilitá-lo com `corepack enable`.
   Em seguida, para instalar a versão correta do `pnpm`, a partir do
   diretório raiz do repositório, execute `corepack install`:

   ```console
   corepack enable;
   corepack install
   ```

   Para instalar [`pnpm`][] sem usar o `corepack`, você
   pode usar seu [método de instalação][] preferido.

5. _(opcional)_ Depois de ter o `pnpm` instalado e configurado,
   busque as dependências npm do site usando `pnpm install`.
   Recomendamos que você use `pnpm`, mas você também pode usar `npm`.

   ```console
   pnpm install
   ```
   
   Execute `pnpm install` novamente sempre que incorporar as
   últimas alterações no branch `main` ou se você
   encontrar erros de dependência ou importação ao construir o site.

6. A partir do diretório raiz, execute a ferramenta `dash_site` para
   validar sua configuração e aprender sobre os comandos disponíveis.

   ```console
   ./dash_site --help
   ```

7. A partir do diretório raiz, sirva o site localmente.

   ```console
   ./dash_site serve
   ```

   Este comando gera e serve o site em uma
   porta local que é impressa em seu terminal.

8. Veja suas alterações no navegador navegando para <http://localhost:4000>.

   Observe que a porta pode ser diferente se `4000` estiver ocupada.

   Se você quiser verificar a saída e estrutura HTML bruta gerada,
   veja o diretório `_site` em um explorador de arquivos ou IDE.

9. Faça suas alterações no repositório local.

   O site deve ser reconstruído automaticamente na maioria das alterações, mas se
   algo não atualizar, saia do processo e execute o comando novamente.
   Melhorias nesta funcionalidade estão planejadas.
   Por favor, abra um novo problema para acompanhar o problema se isso ocorrer.

10. Confirme suas alterações no branch e envie seu PR.

   Se sua alteração for grande, ou você gostaria de testá-la,
   considere [validar suas alterações](#validate-your-changes).

> [!DICA]
> Para encontrar comandos adicionais que você pode executar,
> execute `./dash_site --help` a partir do diretório raiz do repositório.

[`corepack`]: https://nodejs.org/api/corepack.html
[`pnpm`]: https://pnpm.io/
[método de instalação]: https://pnpm.io/installation

## Validar suas alterações

### Verifique a documentação e o código de exemplo

Se você fez alterações no código nos diretórios `/examples` ou `/tool`,
confirme seu trabalho e execute o seguinte comando para
verificar se ele está atualizado e corresponde aos padrões do site.

```console
./dash_site check-all
```

Se este script relatar quaisquer erros ou avisos,
então resolva esses problemas e execute o comando novamente.
Se você tiver algum problema, deixe um comentário em seu problema ou pull request,
e faremos o possível para ajudá-lo.
Você também pode conversar conosco no canal `#hackers-devrel`
no [Discord de contribuidores do Flutter][]!

[Discord de contribuidores do Flutter]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md

### Atualizar trechos de código

Uma construção que falha com o erro
`Error: Some code excerpts needed to be updated!`
significa que um ou mais trechos de código nos arquivos Markdown do site
não são idênticos às regiões de código declaradas
nos arquivos `.dart` correspondentes.

Os arquivos `.dart` são a fonte da verdade para trechos de código,
e as instruções `<?code-excerpt>` precedentes nos arquivos Markdown especificam
como os trechos são copiados dos arquivos `.dart`.

Para resolver esse erro e atualizar os trechos Markdown para corresponder,
a partir da raiz do diretório `website`,
execute `./dash_site refresh-excerpts`.

Para saber mais sobre como criar, editar e usar trechos de código,
confira a [documentação do pacote de atualização de trechos][].

[documentação do pacote de atualização de trechos]: https://github.com/dart-lang/site-shared/tree/main/pkgs/excerpter#readme

## [Opcional] Implantar em um site de staging

Pull requests enviados podem ser automaticamente organizados
por um mantenedor do site.
Se você gostaria de organizar o site sozinho,
você pode construir uma versão completa e carregá-la no Firebase.

1. Se você ainda não tem um projeto Firebase,

  - Navegue até o [Console do Firebase](https://console.firebase.google.com)
    e crie seu próprio projeto Firebase (por exemplo, `flutter-dev-staging`).

  - Volte para seu terminal local e verifique se você está logado.

    ```console
    firebase login
    ```

  - Certifique-se de que seu projeto existe e ative esse projeto:

    ```console
    firebase projects:list
    firebase use <seu-projeto>
    ```

2. A partir do diretório raiz do repositório, construa o site:

   ```console
   ./dash_site build
   ```

   Isso constrói o site e o copia para seu diretório local `_site`.
   Se esse diretório existia anteriormente, ele será substituído.

3. Implante no site de hospedagem padrão do seu projeto Firebase ativado:

   ```console
   firebase deploy --only hosting
   ```

4. Navegue até o seu PR no GitHub e inclua o link da versão organizada.
   Considere adicionar uma referência ao commit que você organizou,
   para que os revisores saibam se alguma alteração adicional foi feita.
