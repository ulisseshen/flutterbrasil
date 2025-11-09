---
ia-translate: true
title: Estudo de caso de arquitetura
shortTitle: Estudo de caso de arquitetura
description: >-
  Um passo a passo de um app Flutter que implementa o padrão arquitetural MVVM.
prev:
  title: Guide to app architecture
  path: /app-architecture/guide
next:
  title: UI Layer
  path: /app-architecture/case-study/ui-layer
---

Os exemplos de código neste guia são do [aplicativo de exemplo Compass][Compass sample application],
um app que ajuda os usuários a construir e reservar itinerários para viagens.
É um aplicativo de exemplo robusto com muitas funcionalidades, rotas e telas.
O app se comunica com um servidor HTTP,
tem ambientes de desenvolvimento e produção,
inclui estilização específica de marca e contém alta cobertura de testes.
Dessas formas e mais, ele simula um aplicativo Flutter do mundo real,
rico em funcionalidades.

<div class="wrapping-row" style="margin-block-end: 2rem">
  <DashImage figure image="app-architecture/case-study/splash_screen.png" alt="A screenshot of the splash screen of the compass app." img-style="max-height: 400px;" />
  <DashImage figure image="app-architecture/case-study/home_screen.png" alt="A screenshot of the home screen of the compass app." img-style="max-height: 400px;" />
  <DashImage figure image="app-architecture/case-study/search_form_screen.png" alt="A screenshot of the search form screen of the compass app." img-style="max-height: 400px;" />
  <DashImage figure image="app-architecture/case-study/booking_screen.png" alt="A screenshot of the booking screen of the compass app." img-style="max-height: 400px;" />
</div>

A arquitetura do app Compass se assemelha mais ao [padrão arquitetural MVVM][MVVM architectural pattern]
conforme descrito nas [diretrizes de arquitetura de app][app architecture guidelines] do Flutter.
Este estudo de caso de arquitetura demonstra como
implementar essas diretrizes percorrendo
a funcionalidade "Home" do app compass.
Se você não está familiarizado com MVVM, você deve ler essas diretrizes primeiro.

A tela Home do app Compass exibe informações da conta do usuário e
uma lista das viagens salvas do usuário.
A partir desta tela você pode fazer logout, abrir páginas detalhadas de viagem,
excluir viagens salvas e navegar para a primeira página do fluxo principal do app,
que permite ao usuário construir um novo itinerário.

Neste estudo de caso, você aprenderá o seguinte:

* Como implementar as [diretrizes de arquitetura de app][app architecture guidelines] do Flutter
  usando repositórios e serviços na [camada de dados][data layer] e
  o padrão arquitetural MVVM na [camada de UI][UI layer]
* Como usar o [padrão Command][Command pattern] para renderizar UI com segurança conforme os dados mudam
* Como usar objetos [`ChangeNotifier`][`ChangeNotifier`] e [`Listenable`][`Listenable`] para gerenciar estado
* Como implementar [Injeção de Dependência][Dependency Injection] usando `package:provider`
* Como [configurar testes][set up tests] ao seguir a arquitetura recomendada
* [Estrutura de pacote][package structure] eficaz para apps Flutter grandes

Este estudo de caso foi escrito para ser lido em ordem.
Qualquer página pode referenciar as páginas anteriores.

Os exemplos de código neste estudo de caso incluem todos os detalhes necessários para
entender a arquitetura, mas não são trechos completos e executáveis.
Se você prefere acompanhar com o app completo,
você pode encontrá-lo no [GitHub][GitHub].

## Estrutura de pacote

Código bem organizado é mais fácil para vários engenheiros trabalharem com
conflitos mínimos de código e é mais fácil para novos engenheiros
navegarem e entenderem.
A organização do código tanto se beneficia quanto beneficia de uma arquitetura bem definida.

Existem dois meios populares de organizar código:

1. Por funcionalidade - As classes necessárias para cada funcionalidade são agrupadas juntas. Por
   exemplo, você pode ter um diretório `auth`, que conteria arquivos
   como `auth_viewmodel.dart`, `login_usecase.dart`, `logout_usecase.dart`,
   `login_screen.dart`, `logout_button.dart`, etc.
2. Por tipo - Cada "tipo" de arquitetura é agrupado junto.
   Por exemplo, você pode ter diretórios como
   `repositories`, `models`, `services` e `viewmodels`.

A arquitetura recomendada neste guia se presta a
uma combinação das duas.
Objetos da camada de dados (repositórios e serviços) não estão vinculados a uma única funcionalidade,
enquanto objetos da camada de UI (views e view models) estão.
O seguinte é como o código é organizado dentro do aplicativo Compass.

```plaintext
lib
├─┬─ ui
│ ├─┬─ core
│ │ ├─┬─ ui
│ │ │ └─── <shared widgets>
│ │ └─── themes
│ └─┬─ <FEATURE NAME>
│   ├─┬─ view_model
│   │ └─── <view_model class>.dart
│   └─┬─ widgets
│     ├── <feature name>_screen.dart
│     └── <other widgets>
├─┬─ domain
│ └─┬─ models
│   └─── <model name>.dart
├─┬─ data
│ ├─┬─ repositories
│ │ └─── <repository class>.dart
│ ├─┬─ services
│ │ └─── <service class>.dart
│ └─┬─ model
│   └─── <api model class>.dart
├─── config
├─── utils
├─── routing
├─── main_staging.dart
├─── main_development.dart
└─── main.dart

// The test folder contains unit and widget tests
test
├─── data
├─── domain
├─── ui
└─── utils

// The testing folder contains mocks other classes need to execute tests
testing
├─── fakes
└─── models
```

A maior parte do código da aplicação vive nas
pastas `data`, `domain` e `ui`.
A pasta data organiza o código por tipo,
porque repositórios e serviços podem ser usados entre
diferentes funcionalidades e por múltiplos view models.
A pasta ui organiza o código por funcionalidade,
porque cada funcionalidade tem exatamente uma view e exatamente um view model.

Outras características notáveis desta estrutura de pastas:

* A pasta UI também contém um subdiretório chamado "core".
  Core contém widgets e lógica de tema que são compartilhados por múltiplas views,
  como botões com a estilização da sua marca.
* A pasta domain contém os tipos de dados da aplicação, porque eles são
  usados pelas camadas de dados e ui.
* O app contém três arquivos "main", que atuam como diferentes pontos de entrada para
  a aplicação para desenvolvimento, staging e produção.
* Existem dois diretórios relacionados a testes no mesmo nível que `lib`: `test/` tem
  o código de teste, e sua própria estrutura corresponde a `lib/`. `testing/` é um
  subpacote que contém mocks e outros utilitários de teste que podem ser usados
  no código de teste de outros pacotes. A pasta `testing/` pode ser descrita como uma
  versão do seu app que você não envia. É o conteúdo que é testado.

Há código adicional no app compass que não pertence à arquitetura.
Para a estrutura completa do pacote, [veja no GitHub][view it on GitHub].

## Outras opções de arquitetura

O exemplo neste estudo de caso demonstra como uma aplicação segue nossas
regras arquiteturais recomendadas, mas existem muitos outros apps de exemplo que
poderiam ter sido escritos. A UI deste app depende muito de view models
e `ChangeNotifier`, mas poderia facilmente ter sido escrita
com streams, ou com outras bibliotecas como as fornecidas pelos pacotes [`riverpod`][`riverpod`],
[`flutter_bloc`][`flutter_bloc`] e [`signals`][`signals`].
A comunicação entre camadas deste app tratou
tudo com chamadas de método, incluindo polling para novos dados.
Poderia ter usado streams para expor dados de um repositório para
um view model e ainda assim seguir as regras cobertas neste guia.

Mesmo se você seguir este guia exatamente,
e escolher não introduzir bibliotecas adicionais, você tem decisões a tomar:
Você terá uma camada de domínio?
Se sim, como você gerenciará o acesso aos dados?
A resposta depende tanto das necessidades de uma equipe individual que
não há uma única resposta certa.
Independentemente de como você responda a essas perguntas,
os princípios neste guia ajudarão você a escrever apps Flutter escaláveis.

E se você olhar de longe, não são todas as arquiteturas MVVM de qualquer forma?

[Compass sample application]: https://github.com/flutter/samples/tree/main/compass_app
[MVVM architectural pattern]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel
[app architecture guidelines]: /app-architecture/guide
[data layer]: /app-architecture/case-study/data-layer
[UI layer]: /app-architecture/case-study/ui-layer
[Command pattern]: /app-architecture/case-study/ui-layer#command-objects
[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[Dependency Injection]: /app-architecture/case-study/dependency-injection
[set up tests]: /app-architecture/case-study/testing
[view it on GitHub]: https://github.com/flutter/samples/tree/main/compass_app
[GitHub]: https://github.com/flutter/samples/tree/main/compass_app
[`riverpod`]: {{site.pub-pkg}}/riverpod
[`flutter_bloc`]: {{site.pub-pkg}}/flutter_bloc
[`signals`]: {{site.pub-pkg}}/signals
[package structure]: /app-architecture/case-study#package-structure

## Feedback

À medida que esta seção do website está evoluindo,
nós [damos boas-vindas ao seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="case-study/index"
