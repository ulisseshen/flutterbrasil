---
title: Estudo de caso de arquitetura
short-title: Estudo de caso de arquitetura
description: >-
  Um passo a passo de um aplicativo Flutter que implementa o padrão de projeto MVVM.
prev:
  title: Guia para arquitetura de aplicativos
  path: /app-architecture/guide
next:
  title: Camada de UI
  path: /app-architecture/case-study/ui-layer
ia-translate: true
---

Os exemplos de código neste guia são do [aplicativo de exemplo Compass][],
um aplicativo que ajuda os usuários a criar e reservar itinerários para viagens.
É um aplicativo de amostra robusto com muitos recursos, rotas e telas.
O aplicativo se comunica com um servidor HTTP,
possui ambientes de desenvolvimento e produção,
inclui estilo específico da marca e contém alta cobertura de testes.
Desta forma e em outras, ele simula um mundo real,
aplicativo Flutter rico em recursos.

<div class="row" style="padding-bottom:30px;">

    <div class="col-sm" style="padding-right:5px">

![Uma captura de tela da tela inicial do aplicativo compass.](/assets/images/docs/app-architecture/case-study/splash_screen.png)
    </div>
    <div class="col-sm" style="padding-left:0;padding-right:5px;">

![Uma captura de tela da tela inicial do aplicativo compass.](/assets/images/docs/app-architecture/case-study/home_screen.png)
    </div>
    <div class="col-sm" style="padding-left:0;padding-right:5px;">

![Uma captura de tela da tela de formulário de pesquisa do aplicativo compass.](/assets/images/docs/app-architecture/case-study/search_form_screen.png)
    </div>
    <div class="col-sm" style="padding-left:0;">

![Uma captura de tela da tela de reserva do aplicativo compass.](/assets/images/docs/app-architecture/case-study/booking_screen.png)
    </div>
</div>

A arquitetura do aplicativo Compass se assemelha mais ao [padrão de projeto MVVM][]
conforme descrito nas [diretrizes de arquitetura de aplicativos][] do Flutter.
Este estudo de caso de arquitetura demonstra como
implementar essas diretrizes percorrendo
o recurso "Home" do aplicativo compass.
Se você não está familiarizado com MVVM, você deve ler essas diretrizes primeiro.

A tela inicial do aplicativo Compass exibe informações da conta do usuário e
uma lista das viagens salvas do usuário.
A partir desta tela, você pode fazer logout, abrir páginas detalhadas de viagens,
excluir viagens salvas e navegar para a primeira página do fluxo principal do aplicativo,
o que permite ao usuário criar um novo itinerário.

Neste estudo de caso, você aprenderá o seguinte:

*   Como implementar as [diretrizes de arquitetura de aplicativos][] do Flutter
    usando repositórios e serviços na [camada de dados][] e
    o padrão de projeto MVVM na [camada de UI][]
*   Como usar o [padrão Command][] para renderizar a UI com segurança à medida que os dados mudam
*   Como usar objetos [`ChangeNotifier`][] e [`Listenable`][] para gerenciar o estado
*   Como implementar a [Injeção de Dependência][] usando `package:provider`
*   Como [configurar testes][] ao seguir a arquitetura recomendada
*   [Estrutura de pacotes eficaz][] para grandes aplicativos Flutter

Este estudo de caso foi escrito para ser lido em ordem.
Qualquer página pode referenciar as páginas anteriores.

Os exemplos de código neste estudo de caso incluem todos os detalhes necessários para
entender a arquitetura, mas não são trechos completos e executáveis.
Se você preferir acompanhar com o aplicativo completo,
você pode encontrá-lo no [GitHub][].

## Estrutura do pacote

Código bem organizado é mais fácil para vários engenheiros trabalharem com
conflitos de código mínimos e é mais fácil para novos engenheiros
navegar e entender.
A organização do código beneficia e é beneficiada por uma arquitetura bem definida.

Existem duas maneiras populares de organizar o código:

1.  Por feature (recurso) - As classes necessárias para cada recurso são agrupadas. Por
    exemplo, você pode ter um diretório `auth`, que conteria arquivos
    como `auth_viewmodel.dart`, `login_usecase.dart`, `logout_usecase.dart,
    `login_screen.dart`, `logout_button.dart`, etc.
2.  Por tipo - Cada "tipo" de arquitetura é agrupado.
    Por exemplo, você pode ter diretórios como
    `repositories`, `models`, `services` e `viewmodels`.

A arquitetura recomendada neste guia se presta a
uma combinação dos dois.
Objetos da camada de dados (repositórios e serviços) não estão vinculados a um único recurso,
enquanto objetos da camada de UI (views e view models) estão.
A seguir, veja como o código está organizado no aplicativo Compass.

```plaintext
lib
|____ui
| |____core
| | |____ui
| | | |____<widgets compartilhados>
| | |____themes
| |____<NOME DO RECURSO>
| | |____view_model
| | | |_____<classe_view_model>.dart
| | |____widgets
| | | |____<nome_do_recurso>_screen.dart
| | | |____<outros widgets>
|____domain
| |____models
| | |____<nome_do_modelo>.dart
|____data
| |____repositories
| | |____<classe_do_repositório>.dart
| |____services
| | |____<classe_do_serviço>.dart
| |____model
| | |____<classe_do_modelo_api>.dart
|____config
|____utils
|____routing
|____main_staging.dart
|____main_development.dart
|____main.dart

// A pasta test contém testes de unidade e widgets
test
|____data
|____domain
|____ui
|____utils

// A pasta testing contém mocks que outras classes precisam para executar testes
testing
|____fakes
|____models
```

A maior parte do código do aplicativo está nas pastas
`data`, `domain` e `ui`.
A pasta data organiza o código por tipo,
porque repositórios e serviços podem ser usados em
diferentes recursos e por vários view models.
A pasta ui organiza o código por recurso,
porque cada recurso tem exatamente uma view e exatamente um view model.

Outros recursos notáveis ​​desta estrutura de pastas:

*   A pasta UI também contém um subdiretório chamado "core".
    O core contém widgets e lógica de tema que são compartilhados por várias views,
    como botões com o estilo da sua marca.
*   A pasta domain contém os tipos de dados do aplicativo, porque eles são
    usados pelas camadas de dados e ui.
*   O aplicativo contém três arquivos "main", que atuam como diferentes pontos de entrada para
    o aplicativo para desenvolvimento, teste e produção.
*   Existem dois diretórios relacionados a testes no mesmo nível que `lib`: `test/` possui
    o código de teste e sua própria estrutura corresponde a `lib/`. `testing/` é um
    subpacote que contém mocks e outros utilitários de teste que podem ser usados
    no código de teste de outros pacotes. A pasta `testing/` poderia ser descrita como uma
    versão do seu aplicativo que você não envia. É o conteúdo que é testado.

Há código adicional no aplicativo compass que não pertence à arquitetura.
Para a estrutura completa do pacote, [veja no GitHub][].

## Outras opções de arquitetura

O exemplo neste estudo de caso demonstra como um aplicativo segue nossas
regras arquitetônicas recomendadas, mas existem muitos outros aplicativos de exemplo que
poderiam ter sido escritos. A UI deste aplicativo depende muito de view models
e `ChangeNotifier`, mas poderia facilmente ter sido escrito
com streams ou com outras bibliotecas como as fornecidas pelos pacotes [`riverpod`][],
[`flutter_bloc`][] e [`signals`][].
A comunicação entre as camadas deste aplicativo tratou
tudo com chamadas de método, incluindo a busca por novos dados.
Poderia ter usado streams para expor dados de um repositório para
um view model e ainda seguir as regras abordadas neste guia.

Mesmo se você seguir este guia exatamente,
e optar por não introduzir bibliotecas adicionais, você tem decisões a tomar:
Você terá uma camada de domínio?
Se sim, como você gerenciará o acesso aos dados?
A resposta depende tanto das necessidades de uma equipe individual que
não existe uma única resposta certa.
Independentemente de como você responder a essas perguntas,
os princípios neste guia ajudarão você a escrever aplicativos Flutter escaláveis.

E se você observar bem, todas as arquiteturas não são MVVM de qualquer maneira?

[aplicativo de exemplo Compass]: https://github.com/flutter/samples/tree/main/compass_app
[padrão de projeto MVVM]: https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel
[diretrizes de arquitetura de aplicativos]: /app-architecture/guide
[camada de dados]: /app-architecture/case-study/data-layer
[camada de UI]: /app-architecture/case-study/ui-layer
[padrão Command]: /app-architecture/case-study/ui-layer#objetos-de-comando
[`ChangeNotifier`]: {{site.api}}/flutter/foundation/ChangeNotifier-class.html
[`Listenable`]: {{site.api}}/flutter/foundation/Listenable-class.html
[Injeção de Dependência]: /app-architecture/case-study/dependency-injection
[configurar testes]: /app-architecture/case-study/testing
[veja no GitHub]: https://github.com/flutter/samples/tree/main/compass_app
[GitHub]: https://github.com/flutter/samples/tree/main/compass_app
[`riverpod`]: {{site.pub-pkg}}/riverpod
[`flutter_bloc`]: {{site.pub-pkg}}/flutter_bloc
[`signals`]: {{site.pub-pkg}}/signals
[Estrutura de pacotes eficaz]: /app-architecture/case-study#estrutura-do-pacote

## Feedback

Como esta seção do site está evoluindo,
nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="case-study/index"
