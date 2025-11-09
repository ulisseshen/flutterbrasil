---
ia-translate: true
---

<!--
  Nota: Este é um arquivo README.md de repositório, não uma página de documentação.
  Por isso, não usa frontmatter completo (title, description, etc.) como as páginas
  de documentação em /src. Apenas contém 'ia-translate: true' para marcar que foi
  traduzido para PT-BR usando IA.
-->

[![Logo do Flutter]](https://docs.flutter.dev)

[Logo do Flutter]: https://github.com/dart-lang/site-shared/blob/main/src/_assets/image/flutter/icon/64.png?raw=1

# Site de documentação do [Flutter][Flutter]

O [site de documentação][Flutter] para o [framework Flutter][Flutter framework],
construído com [Jaspr][Jaspr] e hospedado no [Firebase][Firebase].

[Flutter framework]: https://flutter.dev
[Jaspr]: https://jaspr.site
[Firebase]: https://firebase.google.com/

[Build Status]: https://github.com/flutter/website/workflows/build/badge.svg
[Flutter]: https://docs.flutter.dev/
[Repo on GitHub Actions]: https://github.com/flutter/website/actions?query=workflow%3Abuild+branch%3Amain

<a href="https://studio.firebase.google.com/import?url=https%3A%2F%2Fgithub.com%2Fflutter%2Fwebsite">
  <img
    height="32"
    alt="Open in Firebase Studio"
    src="https://cdn.firebasestudio.dev/btn/open_blue_32.svg">
</a>

## Problemas, bugs e solicitações

Recebemos com prazer contribuições e feedback sobre nosso site.
Por favor, registre uma solicitação no nosso
[rastreador de problemas](https://github.com/flutter/website/issues/new/choose)
ou crie um [pull request](https://github.com/flutter/website/pulls).
Para mudanças simples (como ajustar algum texto),
é mais fácil fazer alterações usando a interface do GitHub.

Se você tiver um problema com a
documentação da API em [api.flutter.dev](https://api.flutter.dev),
por favor, registre esses problemas no
repositório [`flutter/flutter`](https://github.com/flutter/flutter/issues),
não neste repositório (`flutter/website`).
A documentação da API está incorporada no código-fonte do Flutter,
então a equipe de engenharia cuida disso.


## Antes de enviar um PR

Adoramos quando a comunidade se envolve em melhorar nossa documentação!
Mas aqui estão algumas notas a ter em mente antes de enviar um PR:

- Ao fazer a triagem de problemas,
  às vezes rotulamos um problema com a tag **PRs welcome**.
  Mas recebemos PRs em outros problemas também&mdash;
  não precisa estar marcado com esse rótulo.
- Por favor, não execute nossa documentação através do Grammarly (ou similar)
  e envie essas alterações como um PR.
- Seguimos o [Google Developer Documentation Style Guidelines][Google Developer Documentation Style Guidelines] —
  por exemplo, não use "i.e." ou "e.g.",
  evite escrever em primeira pessoa,
  e evite escrever no tempo futuro.
  Você pode começar com os
  [destaques do guia de estilo](https://developers.google.com/style/highlights)
  ou a [lista de palavras](https://developers.google.com/style/word-list),
  ou usar a barra de pesquisa no topo de cada página do guia de estilo.

> Agradecemos sinceramente sua disposição e ajuda
> em manter a documentação do site atualizada!

[Google Developer Documentation Style Guidelines]: https://developers.google.com/style


## Contribuindo

Para atualizar este site, faça um fork do repositório, faça suas alterações,
e gere um pull request.
Para alterações pequenas e contidas (como correções de estilo e digitação),
você provavelmente não precisa compilar este site.
Frequentemente você pode fazer alterações usando a interface do GitHub.
Se necessário, podemos preparar as alterações automaticamente no seu pull request.

Se sua alteração envolve exemplos de código, adiciona/remove páginas ou afeta a navegação,
considere compilar e testar seu trabalho antes de enviar.

Se você quer ou precisa compilar o site, siga os passos abaixo.

## Compilar o site

Para alterações além de ajustes simples de texto e CSS,
recomendamos executar o site localmente para
habilitar um ciclo de edição-atualização.

### Obter os pré-requisitos

Para compilar e desenvolver o site, você precisará
instalar a versão estável mais recente do Flutter, que inclui Dart.

Se você não tem o Flutter ou precisa atualizar, siga as
instruções em [Install Flutter][Install Flutter] ou [Upgrading Flutter][Upgrading Flutter].

Se você já tem o Flutter instalado, verifique se está no seu path
e já é a versão estável mais recente:

```console
flutter --version
```

[Install Flutter]: https://docs.flutter.dev/get-started
[Upgrading Flutter]: https://docs.flutter.dev/release/upgrade

### Clonar este repositório

Se você não é membro da organização Flutter,
recomendamos que você [crie um fork][create a fork] deste repositório na sua própria conta,
e então envie um PR a partir desse fork.

Depois de ter um fork (ou se você é membro da organização Flutter),
clone o repositório com `git clone`:

```bash
git clone https://github.com/flutter/website.git
```

[create a fork]: https://docs.github.com/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo

## Configurar seu ambiente local e servir alterações

Antes de continuar configurando a infraestrutura do site,
verifique se as versões corretas do Flutter e Node.js estão configuradas e disponíveis
seguindo as instruções em [Obter os pré-requisitos](#obter-os-pré-requisitos).

1. _Opcional:_ Após clonar o repositório,
   crie um branch para suas alterações:

   ```console
   git checkout -b <BRANCH_NAME>
   ```

2. Do diretório raiz do repositório,
   busque as dependências Dart do site.

   ```console
   dart pub get
   ```

3. Do diretório raiz, execute a ferramenta `dash_site` para
   validar sua configuração e aprender sobre os comandos disponíveis.

   ```terminal
   dart run dash_site --help
   ```

4. Do diretório raiz, sirva o site localmente.

   ```terminal
   dart run dash_site serve
   ```

   Este comando gera e serve o site em uma
   porta local que é impressa no seu terminal.

5. Visualize suas alterações no navegador navegando para <http://localhost:8080>.

   Note que a porta pode ser diferente se `8080` estiver ocupada.

6. Faça suas alterações no repositório local.

   Para visualizar suas alterações no navegador,
   você precisará atualizar a página.
   O site deve reconstruir automaticamente na maioria das alterações, mas se
   algo não atualizar, saia do processo e execute o comando novamente.

7. Faça commit das suas alterações no branch e envie seu PR.

   Se sua alteração for grande, ou você gostaria de testá-la,
   considere [validar suas alterações](#validar-suas-alterações).

> [!TIP]
> Para encontrar comandos adicionais que você pode executar,
> execute `dart run dash_site --help` do diretório raiz do repositório.

## Validar suas alterações

### Verificar documentação e código de exemplo

Se você fez alterações no código nos
diretórios `/examples`, `/site` ou `/tool`,
faça commit do seu trabalho e então execute o seguinte comando para
verificar se está atualizado e corresponde aos padrões do site.

```terminal
dart run dash_site check-all
```

Se este script reportar quaisquer erros ou avisos,
então resolva esses problemas e execute o comando novamente.
Se você tiver quaisquer problemas, deixe um comentário no seu problema ou pull request,
e tentaremos nosso melhor para ajudá-lo.
Você também pode conversar conosco no canal `#hackers-devrel`
no [Flutter contributors Discord][Flutter contributors Discord]!

[Flutter contributors Discord]: https://github.com/flutter/flutter/blob/main/docs/contributing/Chat.md

### Atualizar trechos de código

Uma compilação que falha com o erro
`Error: Some code excerpts needed to be updated!`
significa que um ou mais trechos de código nos arquivos Markdown do site
não são idênticos às regiões de código declaradas
nos arquivos `.dart` correspondentes.

Os arquivos `.dart` são a fonte de verdade para trechos de código,
e as instruções `<?code-excerpt>` anteriores nos arquivos Markdown especificam
como os trechos são copiados dos arquivos `.dart`.

Para resolver este erro e atualizar os trechos Markdown para corresponder,
do diretório raiz do `website`,
execute `dart run dash_site refresh-excerpts`.

Para aprender mais sobre criar, editar e usar trechos de código,
confira a [documentação do pacote excerpt updater][excerpt updater package documentation].

[excerpt updater package documentation]: https://github.com/dart-lang/site-shared/tree/main/pkgs/excerpter#readme
