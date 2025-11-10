---
ia-translate: true
title: Contribua com o Flutter
shortTitle: Contribua
description: >-
  Aprenda a contribuir com o projeto Flutter e seu ecossistema.
showBreadcrumbs: false
---

![Dash e seus amigos animados com sua contribuição](/assets/images/dash/dash-contribute.png){:height="160px" style="float: right;"}

Se você gostaria de contribuir com o
projeto Flutter e seu ecossistema,
ficamos felizes em ter sua ajuda!

Flutter é um projeto de código aberto que prospera com contribuições da comunidade.
Não importa se você está corrigindo um bug, propondo um novo recurso,
melhorando a documentação ou ajudando outros membros da comunidade,
seus esforços são valiosos e apreciados.

Esta página fornece uma visão geral não exaustiva de como você pode se envolver.
Se você precisar de ajuda para contribuir ou quiser mais sugestões sobre como começar,
considere entrar em contato no [Discord de contribuidores do Flutter][Flutter contributors Discord].

:::important
Antes de iniciar sua jornada contribuindo com o Flutter,
certifique-se de ler e seguir o [Código de conduta][Code of conduct] do Flutter.

Além disso, saiba mais sobre a [cultura de inclusão][culture of inclusivity] e [valores fundamentais][core values] do Flutter.
:::

[Flutter contributors Discord]: {{site.main-url}}/chat
[Code of conduct]: {{site.repo.flutter}}/blob/main/CODE_OF_CONDUCT.md
[culture of inclusivity]: https://flutterbrasil.dev/culture
[core values]: {{site.repo.flutter}}/blob/main/docs/about/Values.md

<div class="card-grid">
  <a class="card outlined-card" href="#develop-with-flutter">
    <div class="card-header">
      <span class="card-title">Use Flutter</span>
    </div>
    <div class="card-content">
      <p>Crie seus próprios apps com Flutter e forneça feedback valioso.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#contribute-code">
    <div class="card-header">
      <span class="card-title">Contribute code</span>
    </div>
    <div class="card-content">
      <p>Contribua diretamente com o código que sustenta o Flutter.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#write-documentation">
    <div class="card-header">
      <span class="card-title">Write docs</span>
    </div>
    <div class="card-content">
      <p>Melhore a experiência de aprendizado do Flutter escrevendo documentação.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#triage-issues">
    <div class="card-header">
      <span class="card-title">Triage issues</span>
    </div>
    <div class="card-content">
      <p>Garanta que os contribuidores do Flutter possam causar o maior impacto.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#strengthen-the-package-ecosystem">
    <div class="card-header">
      <span class="card-title">Develop packages</span>
    </div>
    <div class="card-content">
      <p>Fortaleça o ecossistema de packages Dart e Flutter.</p>
    </div>
  </a>
  <a class="card outlined-card" href="#support-the-community">
    <div class="card-header">
      <span class="card-title"><span>Support the community</span></span>
    </div>
    <div class="card-content">
      <p>Ajude outros desenvolvedores Flutter a se beneficiarem de sua experiência.</p>
    </div>
  </a>
</div>

## Desenvolva com Flutter

Apenas usar o Flutter e fornecer feedback já é uma contribuição valiosa!

### Forneça feedback

Compartilhar seu feedback e experiências ajuda a equipe do Flutter
a entender e priorizar as necessidades e problemas dos desenvolvedores.

Você pode fornecer feedback valioso através de várias formas, incluindo:

- Votando em issues existentes

  Se você está enfrentando um problema que já foi reportado,
  considere votar nele para ajudar a equipe do Flutter a entender sua importância.

  Evite comentários vazios como curtidas, +1 ou similares.
  No entanto, se você tem informações adicionais,
  como passos de reprodução ou informações de versão adicionais,
  considere fornecer esses detalhes em um novo comentário.
- Reportando novos bugs

  Se você encontrar um bug no Flutter que ainda não foi reportado,
  [abra uma nova issue][open a new issue] com informações de reprodução.
- Solicitando recursos

  Se há um recurso que você acha que o Flutter deveria adicionar ou implementar
  mas ainda não foi sugerido, [abra uma nova issue][open a new issue] com
  todas as informações relevantes, bem como seu caso de uso.
- Participando de pesquisas

  Ocasionalmente, a equipe do Flutter realizará pesquisas e estudos com desenvolvedores.
  Para ajudar a entender os problemas e melhorar a experiência do desenvolvedor Flutter,
  considere responder com o máximo de feedback e detalhes possível.

  Para se inscrever em futuros estudos de pesquisa de UX,
  visite [flutterbrasil.dev/research-signup][uxr-signup].
- Discutindo propostas

  Mudanças importantes no Flutter são frequentemente discutidas através de [documentos de design][design documents].
  Considere ler e fornecer feedback sobre propostas que sejam
  relevantes para você ou seus apps.

  Para encontrar documentos de design e propostas atuais,
  confira [issues com o label `design doc`][design-doc-issues] no
  banco de dados de issues do GitHub.
- Revisando pull requests

  Se você está familiarizado com uma área específica do Flutter
  ou uma solução para um problema particular é importante para você,
  considere revisar pull requests abertas, testá-las com seu app
  e fornecer feedback relevante.

[open a new issue]: {{site.repo.flutter}}/issues/new
[uxr-signup]: {{site.main-url}}/research-signup
[design documents]: {{site.repo.flutter}}/blob/main/docs/contributing/Design-Documents.md
[design-doc-issues]: {{site.repo.flutter}}/issues?q=is%3Aopen+is%3Aissue+label%3A%22design+doc%22

### Experimente o canal beta

Para ajudar a garantir a estabilidade do Flutter e melhorar os recursos futuros,
ajude a testar versões futuras antes que elas cheguem ao canal stable.

Considere testar versões no canal `beta`,
tanto para desenvolvimento geral quanto para testar compatibilidade com seus apps.

Qualquer feedback que você tenha ou regressões que você encontre,
certifique-se de [reportá-los][report-bugs] à equipe do Flutter.

Para começar,
[mude][switch-channels] para o [canal `beta`][beta-channel] hoje
e considere quaisquer [migrações necessárias][necessary migrations].

[switch-channels]: /install/upgrade#change-channels
[beta-channel]: /install/upgrade#the-beta-channel
[report-bugs]: {{site.github}}/flutter/flutter/issues/new/choose
[necessary migrations]: /release/breaking-changes

## Contribua com código

Melhore diretamente a base de código do Flutter e ferramentas relacionadas.

### Framework Flutter

Encontrou um bug em um widget nativo, tem uma ideia para um novo,
adora adicionar testes ou está interessado nas partes internas do Flutter?
Considere contribuir com o framework Flutter em si
e melhorar o núcleo do Flutter para todos.

Para aprender sobre como contribuir com o framework Flutter,
confira o [guia de contribuição][framework-contribute] do Flutter.

[framework-contribute]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md

### Engine Flutter

Interessado em implementar as primitivas e integrações de plataforma
que sustentam o Flutter ou tem aptidão para programação gráfica?
Considere contribuir com o engine Flutter e
tornar o Flutter ainda mais portável, performático e poderoso.

Para aprender sobre como contribuir com o engine Flutter,
confira o [guia de contribuição][framework-contribute] do Flutter
e como [Configurar o ambiente de desenvolvimento do engine][engine-setup].

[framework-contribute]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[engine-setup]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/contributing/Setting-up-the-Engine-development-environment.md

### Packages Flutter

Contribua com packages oficiais que são
mantidos pela equipe do Flutter.
Os packages oficiais fornecem funcionalidades essenciais para apps,
bem como encapsulam várias funcionalidades específicas de plataforma.

Para aprender sobre como contribuir com os packages oficiais,
confira o [guia de contribuição][framework-contribute] do Flutter,
bem como o [guia de contribuição][packages-contribute] específico de packages.

[framework-contribute]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[packages-contribute]: {{site.repo.packages}}/blob/main/CONTRIBUTING.md

### DevTools

Contribuir com o [Dart e Flutter DevTools][Dart and Flutter DevTools] é
um ótimo lugar para começar a contribuir devido à sua configuração relativamente simples.
Melhorias e correções podem impactar bastante a experiência do desenvolvedor
para desenvolvedores Flutter e talvez ajudar você a desenvolver seus próprios apps.

Para começar, confira
o [guia `CONTRIBUTING.md` do DevTools][devtools-contribute].

[Dart and Flutter DevTools]: /tools/devtools
[devtools-contribute]: {{site.repo.organization}}/devtools/blob/master/CONTRIBUTING.md

### Infraestrutura de sites

Corrija bugs, melhore a acessibilidade ou adicione recursos aos
sites Dart e Flutter.

Se você está familiarizado com desenvolvimento web ou geração de sites,
contribuir com os sites Dart e Flutter pode ser uma ótima maneira
de melhorar a experiência de aprendizado dos desenvolvedores Flutter.

Dependendo de seus interesses,
você pode querer contribuir com:

- O site pub.dev
  - **Site ativo:** [`pub.dev`]({{site.pub}})
  - **Repositório:** [`dart-lang/pub-dev`]({{site.github}}/dart-lang/pub-dev)
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.github}}/dart-lang/pub-dev/blob/master/CONTRIBUTING.md)
- O site de documentação do Flutter
  - **Site ativo:** [`docs.flutterbrasil.dev`]({{site.url}})
  - **Repositório:** [`flutter/website`]({{site.repo.this}})
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.github}}/flutter/website/blob/main/CONTRIBUTING.md)
- O site de documentação do Dart
  - **Site ativo:** [`dartbrasil.dev`]({{site.dart-site}})
  - **Repositório:** [`dart-lang/site-www`]({{site.github}}/dart-lang/site-www)
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.github}}/dart-lang/site-www/blob/main/CONTRIBUTING.md)
- DartPad
  - **Site ativo:** [`dartpad.dev`]({{site.dartpad}})
  - **Repositório:** [`dart-lang/dart-pad`]({{site.github}}/dart-lang/dart-pad)
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.github}}/dart-lang/dart-pad/blob/main/CONTRIBUTING.md)
- A ferramenta `dartdoc`
  - **Site ativo:** [`api.flutterbrasil.dev`]({{site.api}})
  - **Repositório:** [`dart-lang/dartdoc`]({{site.github}}/dart-lang/dartdoc)
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.github}}/dart-lang/dartdoc/blob/main/CONTRIBUTING.md)

### Dart SDK

Contribua com a linguagem Dart e ferramentas relacionadas,
melhorando a linguagem otimizada para o cliente que
forma a base da excelente experiência de desenvolvedor do Flutter.

O fluxo de contribuição do Dart é um pouco diferente,
então se você está interessado, certifique-se de conferir seus
guias de [contribuição][dart-contribute] e [compilação][dart-build].

[dart-contribute]: {{site.github}}/dart-lang/sdk/blob/main/CONTRIBUTING.md
[dart-build]: {{site.github}}/dart-lang/sdk/blob/main/docs/Building.md

### Exemplos de código

Melhore ou adicione exemplos demonstrando recursos do Flutter,
ajudando desenvolvedores que preferem aprender através de exemplos.

Você sempre pode compartilhar seus próprios exemplos ou templates,
ou pode contribuir com exemplos mantidos pelo Flutter:

- Exemplos de projetos completos
  - **Localização:** [`flutter/samples`]({{site.repo.samples}})
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.repo.samples}}/blob/main/CONTRIBUTING.md)
- Exemplos de documentação da API
  - **Localização:** [`flutter/flutter/packages/flutter`]({{site.repo.flutter}}/tree/main/packages/flutter)
  - **Guia de contribuição:** [`README.md`]({{site.repo.flutter}}/tree/main/dev/snippets)
- Trechos de código do site
  - **Localização:** [`flutter/website/examples`]({{site.repo.this}}/tree/main/examples)
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.repo.this}}/blob/main/CONTRIBUTING.md)
- Exemplos do repositório Flutter
  - **Localização:** [`flutter/flutter/examples`]({{site.repo.flutter}}/tree/main/examples)
  - **Guia de contribuição:** [`CONTRIBUTING.md`]({{site.repo.flutter}}/blob/main/CONTRIBUTING.md)

## Escreva documentação

Contribuir com a documentação do Flutter, não importa a forma,
é uma das maneiras mais impactantes de ajudar o Flutter.

### Documentação da API Flutter

A documentação da API é muito utilizada por muitos desenvolvedores Flutter,
tanto online quanto em seus editores de código.

Quer você esteja interessado em escrever nova documentação, atualizar as existentes,
adicionar trechos de código relevantes ou até criar novos recursos visuais como diagramas,
sua contribuição para a documentação da API será
apreciada por todos os desenvolvedores Flutter.

Para começar, confira
o [guia de contribuição do SDK Flutter][flutter-contribute],
particularmente sua seção sobre [documentação da API][flutter-api-contribute]

[flutter-contribute]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md
[flutter-api-contribute]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md#api-documentation

### Site de documentação

Considere contribuir com este site,
guiando desenvolvedores enquanto eles aprendem e exploram o Flutter.

Para aprender sobre como contribuir com o site de documentação do Flutter,
confira a [documentação de contribuição][website-contribute] do site.

Você também pode contribuir com o [site Dart][Dart website],
melhorando a documentação para a linguagem otimizada para o cliente
que forma a base do Flutter.
Para aprender como contribuir,
confira a [documentação de contribuição do `dart-lang/site-www`][dart-dev-contribute].

[website-contribute]: {{site.repo.this}}/blob/main/CONTRIBUTING.md
[Dart website]: {{site.dart-site}}
[dart-dev-contribute]: {{site.github}}/dart-lang/site-www/tree/main?tab=readme-ov-file#getting-started

## Faça triagem de issues

Ajude a equipe do Flutter fazendo triagem de relatórios de bugs e solicitações de recursos.

Existem várias maneiras de ajudar no [banco de dados de issues do Flutter][flutter-issues],
incluindo, mas não limitado a:

- Determinar validade de issues
- Garantir acionabilidade
- Documentar versões afetadas
- Adicionar passos de reprodução
- Identificar issues duplicadas ou resolvidas
- Resolver ou redirecionar consultas de suporte

Para começar a ajudar com issues,
leia sobre [como ajudar no banco de dados de issues][issue-contribute] e
aprenda sobre a abordagem do Flutter para
[triagem de issues][issue triage] e [higiene de issues][issue hygiene].

[flutter-issues]: {{site.repo.flutter}}/issues
[issue-contribute]: {{site.repo.flutter}}/blob/main/CONTRIBUTING.md#helping-out-in-the-issue-database
[issue triage]: {{site.repo.flutter}}/blob/main/docs/triage/README.md
[issue hygiene]: {{site.repo.flutter}}/tree/main/docs/contributing/issue_hygiene

## Fortaleça o ecossistema de packages

Ajude a crescer e apoiar a coleção de
packages Dart e Flutter disponíveis no [pub.dev](https://pub.dev/).

### Contribua com packages que você usa

Para retribuir aos packages dos quais você depende e potencialmente até ajudar seus próprios apps,
encontre packages que você utiliza e contribua de volta para eles.

Para contribuir com um package,
navegue até sua página no [site pub.dev][pub.dev site]
e encontre o repositório vinculado na barra lateral da página.

Antes de contribuir, certifique-se de
seguir o guia de contribuição de cada package,
discutir sua contribuição com os mantenedores e
manter em mente o [Código de conduta][Code of conduct] do Flutter.

[pub.dev site]: {{site.pub}}
[Code of conduct]: {{site.repo.flutter}}/blob/main/CODE_OF_CONDUCT.md

### Abra o código de funcionalidades reutilizáveis do seu app

Se você construiu um widget ou utilitário genérico interessante em seu app,
considere extraí-lo em um package e publicá-lo no pub.dev.

Para começar, aprenda sobre
[Criar packages Dart][Creating Dart packages] e [Desenvolver packages Flutter][Developing Flutter packages].
Então, quando estiver pronto para publicar seu package no [site pub.dev][pub.dev site],
siga o guia e melhores práticas em [Publicar packages][Publishing packages].

[Creating Dart packages]: {{site.dart-site}}/tools/pub/create-packages
[Developing Flutter packages]: /packages-and-plugins/developing-packages
[pub.dev site]: {{site.pub}}
[Publishing packages]: {{site.dart-site}}/tools/pub/publishing

### Adicione suporte Dart ou Flutter a SDKs populares

Crie ou contribua com packages que encapsulem SDKs nativos ou APIs web.

Antes de criar um novo package,
primeiro tente encontrar qualquer wrapper existente que você
possa usar ou contribuir no [site pub.dev][pub.dev site].

Dependendo do SDK e plataforma,
você pode precisar [Escrever código específico de plataforma][Write platform-specific code],
usar [interop JS][JS interop], encapsular uma API REST usando [`package:http`][`package:http`],
ou reimplementar a funcionalidade necessária em Dart.

Se você está planejando criar um novo package, aprenda sobre
[Criar packages Dart][Creating Dart packages] e [Desenvolver packages Flutter][Developing Flutter packages].
Então, quando estiver pronto para publicar seu package no [site pub.dev][pub.dev site],
siga o guia e melhores práticas em [Publicar packages][Publishing packages].

[pub.dev site]: {{site.pub}}
[Write platform-specific code]: /platform-integration/platform-channels
[JS interop]: {{site.dart-site}}/interop/js-interop
[`package:http`]: {{site.pub-pkg}}/http

## Apoie a comunidade

Ajude outros desenvolvedores a aprender Flutter e
ter sucesso enquanto constroem seus próprios apps.

### Ajude outros desenvolvedores

Compartilhe seu conhecimento e experiência em Flutter
para ajudar seus colegas desenvolvedores Flutter a ter sucesso.

Isso pode assumir muitas formas, desde iniciar um canal de ajuda Flutter em sua empresa
até responder perguntas em fóruns públicos.

Alguns locais comuns onde desenvolvedores Flutter procuram ajuda incluem:

- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Flutter Dev Discord](https://discord.com/invite/rflutterdev)
- [Dart Community Discord](https://discord.com/invite/Qt6DgfAWWx)
- [r/FlutterDev no Reddit](https://www.reddit.com/r/FlutterDev)
- [GitHub issues]({{site.repo.flutter}}/issues)
- [Flutter Forum](https://forum.itsallwidgets.com/)

### Organize eventos

Conecte-se com outros entusiastas do Flutter e
organize eventos locais, nacionais e até virtuais.
Eventos podem ser qualquer coisa, desde grupos de estudo e meetups simples,
até workshops e hackathons.

Para inspiração e suporte,
confira [eventos Flutter][Flutter events] existentes,
saiba mais sobre a [comunidade Flutter][Flutter community] e
explore a [Rede de Meetups Flutter][Flutter Meetup Network].

[Flutter events]: {{site.main-url}}/events
[Flutter community]: {{site.main-url}}/community
[Flutter Meetup Network]: https://www.meetup.com/pro/flutter/

### Poste sobre Flutter

Compartilhe seus insights e projetos com a comunidade Flutter mais ampla.

Existem infinitas opções para compartilhar sobre Flutter
e se conectar com a comunidade de desenvolvedores.
Algumas saídas comuns incluem:

- Posts em blogs
- Tutoriais em vídeo
- Posts curtos
- Tópicos em fóruns
- Discussões no GitHub
- Quadros de agregação de links

Poste ou compartilhe sobre o que você é apaixonado,
mas se você não tem certeza do que postar,
considere postar sobre tópicos sobre os quais os desenvolvedores frequentemente perguntam.

Se a plataforma em que você está postando suporta tags,
considere adicionar as hashtags `#Flutter` e `#FlutterDev`
para ajudar outros desenvolvedores a encontrar seu conteúdo.
