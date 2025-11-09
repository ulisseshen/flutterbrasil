---
ia-translate: true
title: Guia de arquitetura de aplicações
shortTitle: Guia de arquitetura
description: >
  A maneira recomendada de arquitetar um app Flutter.
prev:
    title: Conceitos comuns de arquitetura
    path: /app-architecture/concepts
next:
  title: Estudo de caso de arquitetura
  path: /app-architecture/case-study
---

As páginas a seguir demonstram como construir um app usando melhores práticas.
As recomendações neste guia podem ser aplicadas à maioria dos apps,
tornando-os mais fáceis de escalar, testar e manter.
No entanto, são diretrizes, não regras rígidas,
e você deve adaptá-las aos seus requisitos únicos.

Esta seção fornece uma visão geral de alto nível de como aplicações Flutter podem ser
arquitetadas. Ela explica as camadas de uma aplicação,
juntamente com as classes que existem dentro de cada camada.
A seção após esta fornece exemplos de código concretos e
percorre uma aplicação Flutter que implementou essas recomendações.

## Visão geral da estrutura do projeto

[Separação de responsabilidades][Separation-of-concerns] é o princípio mais importante a seguir ao
projetar seu app Flutter.
Sua aplicação Flutter deve se dividir em duas camadas amplas,
a camada de UI e a camada de dados.

Cada camada é dividida ainda mais em diferentes componentes,
cada um dos quais tem responsabilidades distintas, uma interface bem definida,
limites e dependências.
Este guia recomenda que você divida sua aplicação nos seguintes componentes:

* Views
* View models
* Repositories
* Services

### MVVM

Se você encontrou o [padrão arquitetural Model-View-ViewModel][Model-View-ViewModel architectural pattern] (MVVM),
isso será familiar.
MVVM é um padrão arquitetural que separa uma
funcionalidade de uma aplicação em três partes:
o `Model`, o `ViewModel` e a `View`.
Views e view models compõem a camada de UI de uma aplicação.
Repositories e services representam os dados de uma aplicação,
ou a camada de modelo do MVVM.
Cada um desses componentes é definido na próxima seção.

<img src='/assets/images/docs/app-architecture/guide/mvvm-intro-with-layers.png' alt="Padrão arquitetural MVVM">

Cada funcionalidade em uma aplicação conterá uma view para descrever a UI e
um view model para lidar com a lógica,
um ou mais repositories como as fontes de verdade para os dados da sua aplicação,
e zero ou mais services que interagem com APIs externas,
como servidores cliente e plugins de plataforma.

Uma única funcionalidade de uma aplicação pode requerer todos os seguintes objetos:

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-example.png' alt="Um exemplo dos objetos Dart que podem existir em uma funcionalidade usando a arquitetura descrita na página.">

Cada um desses objetos e as setas que os conectam serão explicados
minuciosamente até o final desta página. Ao longo deste guia,
a seguinte versão simplificada desse diagrama será usada como âncora.

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified.png' alt="Um diagrama simplificado da arquitetura descrita nesta página.">

:::note
Apps com lógica complexa também podem ter uma camada de lógica que fica entre a
camada de UI e a camada de dados. Esta camada de lógica é comumente chamada de *camada de domínio.*
A camada de domínio contém componentes adicionais frequentemente chamados de *interactors* ou
*use-cases*. A camada de domínio é coberta mais adiante neste guia.
:::

[Model-View-ViewModel architectural pattern]: https://en.wikipedia.org/wiki/Model–view–viewmodel

## Camada de UI {:#ui-layer}

A camada de UI de uma aplicação é responsável por interagir com o usuário.
Ela exibe os dados de uma aplicação ao usuário e recebe entrada do usuário,
como eventos de toque e entradas de formulário.

A UI reage a mudanças de dados ou entrada do usuário.
Quando a UI recebe novos dados de um Repository,
ela deve re-renderizar para exibir esses novos dados.
Quando o usuário interage com a UI,
ela deve mudar para refletir essa interação.

A camada de UI é composta por dois componentes arquiteturais,
baseados no padrão de design MVVM:

* **Views** descrevem como apresentar dados da aplicação ao usuário.
  Especificamente, elas se referem a *composições de widgets* que compõem uma funcionalidade.
  Por exemplo, uma view é frequentemente (mas nem sempre) uma tela que
  tem um widget `Scaffold`, juntamente com
  todos os widgets abaixo dela na árvore de widgets.
  Views também são responsáveis por passar eventos para
  o view model em resposta a interações do usuário.
* **View models** contêm a lógica que converte dados do app em *UI State*,
  porque os dados de repositories são frequentemente formatados de forma diferente dos
  dados que precisam ser exibidos.
  Por exemplo, você pode precisar combinar dados de múltiplos repositories,
  ou pode querer filtrar uma lista de registros de dados.

Views e view models devem ter um relacionamento um-para-um.

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-UI-highlighted.png' alt="Um diagrama simplificado da arquitetura descrita nesta página com os objetos view e view model destacados.">

Nos termos mais simples,
um view model gerencia o estado da UI e a view exibe esse estado.
Usando views e view models, sua camada de UI pode manter estado durante
mudanças de configuração (como rotações de tela),
e você pode testar a lógica da sua UI independentemente dos widgets Flutter.

:::note
'View' é um termo abstrato, e uma view não é igual a um widget.
Widgets são combináveis, e vários podem ser combinados para criar uma view.
Portanto, view models não têm um relacionamento um-para-um com widgets,
mas sim um relacionamento um-para-um com uma *coleção* de widgets.
:::

Uma funcionalidade de uma aplicação é centrada no usuário,
e, portanto, definida pela camada de UI.
Cada instância de uma *view* e *view model* pareados define uma funcionalidade no seu app.
Isso é frequentemente uma tela no seu app, mas não precisa ser.
Por exemplo, considere fazer login e logout.
Fazer login é geralmente feito em uma tela específica cuja
única finalidade é fornecer ao usuário uma maneira de fazer login.
No código da aplicação, a tela de login seria
composta por uma classe `LoginViewModel` e uma classe `LoginView`.

Por outro lado,
fazer logout de um app geralmente não é feito em uma tela dedicada.
A capacidade de fazer logout é geralmente apresentada ao usuário como um botão em
um menu, uma tela de conta de usuário, ou qualquer número de localizações diferentes.
Frequentemente é apresentada em múltiplas localizações.
Em tais cenários, você pode ter um `LogoutViewModel` e uma `LogoutView` que
contém apenas um único botão que pode ser inserido em outros widgets.

### Views

No Flutter, views são as classes de widget da sua aplicação.
Views são o método principal de renderização de UI,
e não devem conter nenhuma lógica de negócio.
Elas devem receber todos os dados de que precisam para renderizar do view model.

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-View-highlighted.png' alt="Um diagrama simplificado da arquitetura descrita nesta página com o objeto view destacado.">

A única lógica que uma view deve conter é:

* Declarações if simples para mostrar e ocultar widgets com base em um flag ou campo
  nullable no view model
* Lógica de animação
* Lógica de layout baseada em informações do dispositivo, como tamanho ou orientação da tela.
* Lógica de roteamento simples

Toda a lógica relacionada a dados deve ser tratada no view model.

### View models

Um view model expõe os dados da aplicação necessários para renderizar uma view.
No design de arquitetura descrito nesta página,
a maior parte da lógica na sua aplicação Flutter vive nos view models.

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-ViewModel-highlighted.png' alt="Um diagrama simplificado da arquitetura descrita nesta página com o objeto view model destacado.">

As principais responsabilidades de um view model incluem:

* Recuperar dados da aplicação de repositories e transformá-los em um
  formato adequado para apresentação na view.
  Por exemplo, pode filtrar, ordenar ou agregar dados.
* Manter o estado atual necessário na view,
  para que a view possa reconstruir sem perder dados.
  Por exemplo, pode conter flags booleanos para
  renderizar condicionalmente widgets na view, ou um campo que
  rastreia qual seção de um carrossel está ativa na tela.
* Expõe callbacks (chamados **commands**) para a view que podem ser
  anexados a um manipulador de evento, como um pressionamento de botão ou envio de formulário.

Commands são nomeados pelo [padrão command][command pattern],
e são funções Dart que permitem views
executar lógica complexa sem conhecimento de sua implementação.
Commands são escritos como membros da classe view model para
serem chamados pelos manipuladores de gestos na classe view.

Você pode encontrar exemplos de views, view models e commands na
porção [camada de UI][UI layer] do [Estudo de caso de arquitetura de app][App architecture case study].

Para uma introdução gentil ao MVVM no Flutter,
confira os [fundamentos de gerenciamento de estado][state management fundamentals].

[UI layer]: /app-architecture/case-study/ui-layer
[App architecture case study]: /app-architecture/case-study
[state management fundamentals]: /get-started/fundamentals/state-management

## Camada de dados

A camada de dados de um app lida com seus dados e lógica de negócio.
Duas peças de arquitetura compõem a camada de dados: services e repositories.
Essas peças devem ter entradas e saídas bem definidas
para simplificar sua reutilização e testabilidade.

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-Data-highlighted.png' alt="Um diagrama simplificado da arquitetura descrita nesta página com a camada de dados destacada.">

Usando a linguagem MVVM, services e repositories compõem sua *camada de modelo*.

### Repositories

Classes [Repository][Repository] são a fonte de verdade para os dados do seu modelo.
Elas são responsáveis por consultar dados de services,
e transformar esses dados brutos em **domain models**.
Domain models representam os dados que a aplicação precisa,
formatados de uma maneira que suas classes view model possam consumir.
Deve haver uma classe repository para
cada tipo diferente de dado tratado no seu app.

Repositories lidam com a lógica de negócio associada aos services, como:

* Caching
* Tratamento de erros
* Lógica de retry
* Atualização de dados
* Consulta de services por novos dados
* Atualização de dados baseada em ações do usuário

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-Repository-highlighted.png' alt="Um diagrama simplificado da arquitetura descrita nesta página com o objeto Repository destacado.">

Repositories geram dados da aplicação como domain models.
Por exemplo, um app de mídia social pode ter uma
classe `UserProfileRepository` que expõe um `Stream<UserProfile?>`,
que emite um novo valor sempre que o usuário faz login ou logout.

Os modelos gerados pelos repositories são consumidos pelos view models.
Repositories e view models têm um relacionamento muitos-para-muitos.
Um view model pode usar muitos repositories para obter os dados de que precisa,
e um repository pode ser usado por muitos view models.

Repositories nunca devem estar cientes uns dos outros.
Se sua aplicação tem lógica de negócio que precisa de dados de dois repositories,
você deve combinar os dados no view model ou na camada de domínio,
especialmente se o relacionamento repository-para-view-model for complexo.

### Services

Services estão na camada mais baixa da sua aplicação.
Eles encapsulam endpoints de API e expõem objetos de resposta assíncronos,
como objetos `Future` e `Stream`.
Eles são usados apenas para isolar o carregamento de dados, e não mantêm estado.
Seu app deve ter uma classe service por fonte de dados.
Exemplos de endpoints que services podem encapsular incluem:

* A plataforma subjacente, como APIs iOS e Android
* Endpoints REST
* Arquivos locais

Como regra geral, services são mais úteis quando
os dados necessários vivem fora do código Dart da sua aplicação -
o que é verdade para cada um dos exemplos anteriores.

Services e repositories têm um relacionamento muitos-para-muitos.
Um único Repository pode usar vários services,
e um service pode ser usado por múltiplos repositories.

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-Service-highlighted.png' alt="Um diagrama simplificado da arquitetura descrita nesta página com o objeto Service destacado.">

## Opcional: Camada de domínio {:#optional-domain-layer}

À medida que seu app cresce e adiciona funcionalidades, você pode precisar abstrair lógica que
adiciona muita complexidade aos seus view models.
Essas classes são frequentemente chamadas de interactors ou **use-cases**.

Use-cases são responsáveis por tornar as interações entre
as camadas de UI e dados mais simples e reutilizáveis.
Eles pegam dados de repositories e os tornam adequados para a camada de UI.

<img src='/assets/images/docs/app-architecture/guide/mvvm-intro-with-domain-layer.png' alt="Padrão de design MVVM com um objeto de camada de domínio adicionado">

Use-cases são usados principalmente para encapsular lógica de negócio que de outra forma
viveria no view model e atende a uma ou mais das seguintes condições:

1. Requer mesclar dados de múltiplos repositories
2. É excessivamente complexo
3. A lógica será reutilizada por diferentes view models

Esta camada é opcional porque nem todas as aplicações ou funcionalidades dentro de uma
aplicação têm esses requisitos.
Se você suspeita que sua aplicação se
beneficiaria desta camada adicional, considere os prós e contras:


| Prós                                                                     | Contras                                                                                       |
|--------------------------------------------------------------------------|--------------------------------------------------------------------------------------------|
| ✅ Evitar duplicação de código em view models                                  | ❌ Aumenta a complexidade da sua arquitetura, adicionando mais classes e maior carga cognitiva |
| ✅ Melhorar a testabilidade separando lógica de negócio complexa da lógica de UI | ❌ Testes requerem mocks adicionais                                                        |
| ✅ Melhorar a legibilidade do código em view models                                | ❌ Adiciona boilerplate adicional ao seu código                                                 |

{:.table .table-striped}

### Acesso a dados com use-cases

Outra consideração ao adicionar uma camada de domínio é se os view models continuarão
a ter acesso aos dados do repository diretamente, ou se você forçará
view models a passar por use-cases para obter seus dados. Dito de outra forma,
você adicionará use-cases conforme precisar deles?
Talvez quando notar lógica repetida em seus view models?
Ou, você criará um use-case cada vez que um view model precisar de dados,
mesmo que a lógica no use-case seja simples?

Se você escolher fazer o último,
isso intensifica os prós e contras descritos anteriormente.
O código da sua aplicação será extremamente modular e testável,
mas também adiciona uma quantidade significativa de overhead desnecessário.

Uma boa abordagem é adicionar use-cases apenas quando necessário.
Se você descobrir que seus view models estão
acessando dados através de use-cases na maior parte do tempo,
você sempre pode refatorar seu código para utilizar use-cases exclusivamente.
O app de exemplo usado mais adiante neste guia tem use-cases para algumas funcionalidades,
mas também tem view models que interagem com repositories diretamente.
Uma funcionalidade complexa pode acabar parecendo assim:

<img src='/assets/images/docs/app-architecture/guide/feature-architecture-simplified-with-logic-layer.png'
alt="Um diagrama simplificado da arquitetura descrita nesta página com um objeto use case.">

Este método de adicionar use-cases é definido pelas seguintes regras:

* Use-cases dependem de repositories
* Use-cases e repositories têm um relacionamento muitos-para-muitos
* View models dependem de um ou mais use-cases *e* um ou mais repositories

Este método de usar use-cases acaba parecendo
menos como uma lasanha em camadas, e mais como um jantar servido com
dois pratos principais (camadas de UI e dados) e um acompanhamento (camada de domínio).
Use-cases são apenas classes utilitárias que têm entradas e saídas bem definidas.
Esta abordagem é flexível e extensível,
mas requer maior diligência para manter a ordem.

[Separation-of-concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[command pattern]: https://en.wikipedia.org/wiki/Command_pattern
[Repository]: https://martinfowler.com/eaaCatalog/repository.html

## Feedback

À medida que esta seção do site está evoluindo,
[recebemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="guide"
