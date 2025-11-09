---
ia-translate: true
title: Conceitos comuns de arquitetura
shortTitle: Conceitos de arquitetura
description: >
  Aprenda sobre conceitos comuns de arquitetura no design de aplicações,
  e como eles se aplicam ao Flutter.
prev:
    title: Arquitetura de apps Flutter
    path: /app-architecture
next:
    title: Guia de arquitetura de aplicações
    path: /app-architecture/guide
---

Nesta seção, você encontrará princípios testados e comprovados que guiam decisões arquiteturais
no mundo mais amplo do desenvolvimento de aplicações,
bem como informações sobre como eles se encaixam especificamente no Flutter.
É uma introdução gentil ao vocabulário e conceitos relacionados à
arquitetura recomendada e melhores práticas,
para que possam ser explorados em mais detalhes ao longo deste guia.

## Separação de responsabilidades

[Separação de responsabilidades][Separation-of-concerns] é um princípio fundamental no desenvolvimento de aplicações que
promove modularidade e manutenibilidade ao dividir a funcionalidade de uma aplicação
em unidades distintas e autocontidas. De um nível alto,
isso significa separar sua lógica de UI da sua lógica de negócio.
Isso é frequentemente descrito como arquitetura em *camadas*.
Dentro de cada camada, você deve separar ainda mais sua aplicação por
funcionalidade ou recurso. Por exemplo, a lógica de autenticação da sua aplicação
deve estar em uma classe diferente da lógica de busca.

No Flutter, isso se aplica a [widgets](/resources/glossary#widget) na camada de UI também. Você deve escrever
widgets reutilizáveis e enxutos que contenham o mínimo de lógica possível.

## Arquitetura em camadas

Aplicações Flutter devem ser escritas em *camadas*. Arquitetura em camadas é um
padrão de design de software que organiza uma aplicação em camadas distintas, cada
uma com papéis e responsabilidades específicas. Tipicamente, aplicações são separadas
em 2 a 3 camadas, dependendo da complexidade.

<img src='/assets/images/docs/app-architecture/common-architecture-concepts/horizontal-layers-with-icons.png' alt="As três camadas comuns de arquitetura de aplicações, a camada de UI, camada de lógica e camada de dados.">

* **Camada de UI** - Exibe dados ao usuário que são expostos pela camada de lógica
  de negócio, e lida com interação do usuário. Isso também é comumente referido como
  'camada de apresentação'.
* **Camada de lógica** - Implementa a lógica de negócio central, e facilita a interação
  entre a camada de dados e a camada de UI. Comumente conhecida como 'camada de domínio'.
  A camada de lógica é opcional, e só precisa ser implementada se sua aplicação
  tem lógica de negócio complexa que acontece no cliente.
  Muitas aplicações estão apenas preocupadas em apresentar dados a um usuário e
  permitir que o usuário altere esses dados (coloquialmente conhecidas como apps CRUD).
  Essas aplicações podem não precisar desta camada opcional.
* **Camada de dados** - Gerencia interações com fontes de dados, como bancos de dados ou
  plugins de plataforma. Expõe dados e métodos para a camada de lógica de negócio.

Essas são chamadas de 'camadas' porque cada camada pode apenas se comunicar com as
camadas diretamente abaixo ou acima dela. A camada de UI não deve saber que a camada
de dados existe, e vice-versa.

## Fonte única de verdade

Cada tipo de dado na sua aplicação deve ter uma [fonte única de verdade][single source of truth] (SSOT).
A fonte de verdade é responsável por representar o estado local ou remoto.
Se os dados podem ser modificados no app,
a classe SSOT deve ser a única classe que pode fazer isso.

Isso pode reduzir drasticamente o número de bugs na sua aplicação,
e pode simplificar o código porque você terá apenas uma cópia dos mesmos dados.

Geralmente, a fonte de verdade para qualquer tipo de dado na sua aplicação é
mantida em uma classe chamada **Repository**, que é parte da camada de dados.
Tipicamente há uma classe repository para cada tipo de dado no seu app.

Este princípio pode ser aplicado através de camadas e componentes na sua aplicação
assim como dentro de classes individuais. Por exemplo,
uma classe Dart pode usar [getters][getters] para derivar valores de um campo SSOT
(ao invés de ter múltiplos campos que precisam ser atualizados independentemente)
ou uma lista de [records][records] para agrupar valores relacionados
(ao invés de listas paralelas cujos índices podem ficar dessincronizados).

## Fluxo de dados unidirecional

[Fluxo de dados unidirecional][Unidirectional data flow] (UDF) se refere a um padrão de design que ajuda
a desacoplar o estado da UI que exibe esse estado. Nos termos mais simples,
o estado flui da camada de dados através da camada de lógica e eventualmente para os
widgets na camada de UI.
Eventos da interação do usuário fluem na direção oposta,
da camada de apresentação de volta através da camada de lógica e para a camada de dados.

<img src='/assets/images/docs/app-architecture/common-architecture-concepts/horizontal-layers-with-UDF.png' alt="As três camadas comuns de arquitetura de aplicações, a camada de UI, camada de lógica e camada de dados, e o fluxo de estado da camada de dados para a camada de UI.">

No UDF, o loop de atualização da interação do usuário até a re-renderização da UI se parece com
isso:

1. [Camada de UI] Um evento ocorre devido à interação do usuário, como um botão sendo
   clicado. O callback do manipulador de evento do widget invoca um método exposto por uma
   classe na camada de lógica.
2. [Camada de lógica] A classe de lógica chama métodos expostos por um repository que
   sabe como mutar os dados.
3. [Camada de dados] O repository atualiza dados (se necessário) e então fornece os
   novos dados para a classe de lógica.
4. [Camada de lógica] A classe de lógica salva seu novo estado, que ela envia para a UI.
5. [Camada de UI] A UI exibe o novo estado do view model.

Novos dados também podem começar na camada de dados.
Por exemplo, um repository pode consultar um servidor HTTP por novos dados.
Neste caso, o fluxo de dados faz apenas a segunda metade da jornada.
A ideia mais importante é que mudanças de dados sempre acontecem
no [SSOT][SSOT], que é a camada de dados.
Isso torna seu código mais fácil de entender, menos propenso a erros, e
previne que dados malformados ou inesperados sejam criados.


## UI é uma função de estado (imutável)

Flutter é declarativo,
significando que ele constrói sua UI para refletir o estado atual do seu app.
Quando o estado muda,
seu app deve acionar uma reconstrução da UI que depende desse estado.
No Flutter, você frequentemente ouvirá isso descrito como "UI é uma função de estado".

<img src='/assets/images/docs/app-architecture/common-architecture-concepts/ui-f-state.png' style="width:50%; margin:auto; display:block" alt="UI é uma função de estado.">

É crucial que seus dados dirijam sua UI, e não o contrário.
Os dados devem ser imutáveis e persistentes,
e as views devem conter o mínimo de lógica possível.
Isso minimiza a possibilidade de dados serem perdidos quando um app é fechado,
e torna seu app mais testável e resiliente a bugs.

## Extensibilidade

Cada peça da arquitetura deve ter uma lista bem definida de entradas e saídas.
Por exemplo, um view model na camada de lógica deve apenas
receber fontes de dados como entradas, como repositories,
e deve apenas expor comandos e dados formatados para views.

Usar interfaces limpas desta maneira permite que você troque
implementações concretas de suas classes sem precisar
alterar nenhum código que consome a interface.

## Testabilidade

Os princípios que tornam o software extensível também tornam o software mais fácil de testar.
Por exemplo, você pode testar a lógica autocontida de um view model simulando um
repository.
Os testes do view model não exigem que você simule outras partes da sua aplicação,
e você pode testar sua lógica de UI separadamente dos widgets Flutter em si.

Seu app também será mais flexível.
Será direto e de baixo risco adicionar nova lógica e nova UI.
Por exemplo, adicionar um novo view model não pode quebrar nenhuma lógica
das camadas de dados ou lógica de negócio.

A próxima seção explica a ideia de entradas e saídas para qualquer componente
na arquitetura da sua aplicação.

[Separation-of-concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[single source of truth]: https://en.wikipedia.org/wiki/Single_source_of_truth
[SSOT]: https://en.wikipedia.org/wiki/Single_source_of_truth
[getters]: {{site.dart-site}}/effective-dart/design#do-use-getters-for-operations-that-conceptually-access-properties
[records]: {{site.dart-site}}/language/records
[Unidirectional data flow]: https://en.wikipedia.org/wiki/Unidirectional_Data_Flow_(computer_science)

## Feedback

À medida que esta seção do site está evoluindo,
[recebemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="concepts"
