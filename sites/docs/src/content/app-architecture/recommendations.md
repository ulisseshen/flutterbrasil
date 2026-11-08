---
ia-translate: true
title: Recomendações e recursos de arquitetura
shortTitle: Recomendações de arquitetura
description: >
  Recomendações para construir aplicações Flutter escaláveis.
prev:
  title: Estudo de caso de arquitetura
  path: /app-architecture/case-study
next:
  title: Padrões de design
  path: /app-architecture/design-patterns
---

Esta página apresenta melhores práticas de arquitetura, por que elas importam, e
se as recomendamos para sua aplicação Flutter.
Você deve tratar essas recomendações como recomendações,
e não regras rígidas, e você deve
adaptá-las aos requisitos únicos do seu app.

As melhores práticas nesta página têm uma prioridade,
que reflete quão fortemente a equipe Flutter as recomenda.

* **Fortemente recomendado:** Você deve sempre implementar esta recomendação se
  estiver começando a construir uma nova aplicação. Você deve fortemente considerar
  refatorar um app existente para implementar esta prática, a menos que fazer isso
  conflite fundamentalmente com sua abordagem atual.
* **Recomendado**: Esta prática provavelmente melhorará seu app.
* **Condicional**: Esta prática pode melhorar seu app em certas circunstâncias.

## Separação de responsabilidades

Você deve separar seu app em uma camada de UI e uma camada de dados. Dentro dessas camadas,
você deve separar ainda mais a lógica em classes por responsabilidade.

<ArchitectureRecommendations category="separation-of-concerns" />

## Manipulação de dados

Manipular dados com cuidado torna seu código mais fácil de entender, menos propenso a erros e
impede que dados malformados ou inesperados sejam criados.

<ArchitectureRecommendations category="handling-data" />

## Estrutura do app

Código bem organizado beneficia tanto a saúde do próprio app quanto a equipe que trabalha no código.

<ArchitectureRecommendations category="app-structure" />

## Testes

Boas práticas de teste tornam seu app flexível.
Elas também tornam simples e de baixo risco adicionar nova lógica e nova UI.

<ArchitectureRecommendations category="testing" />

<a id="recommended-resources" aria-hidden="true"></a>

## Recursos recomendados {:#resources}

* Código e templates
  * [Código fonte do app Compass][Compass app source code] -
    Código fonte de uma aplicação Flutter completa e robusta que
    implementa muitas dessas recomendações.
  * [very_good_cli][very_good_cli] -
    Um template de aplicação Flutter feito pelos
    especialistas em Flutter Very Good Ventures.
    Este template gera uma estrutura de app similar.
* Documentação
  * [Documentação de arquitetura Very Good Engineering][Very Good Engineering architecture documentation] -
    Very Good Engineering é um site de documentação da VGV que tem
    artigos técnicos, demos e projetos open-source.
    Inclui documentação sobre arquitetura de aplicações Flutter.
* Ferramentas
  * [Ferramentas de desenvolvedor Flutter][Flutter developer tools] -
    DevTools é um conjunto de ferramentas de performance e debugging para Dart e Flutter.
  * [flutter_lints][flutter_lints] -
    Um pacote que contém os lints para
    apps Flutter recomendados pela equipe Flutter.
    Use este pacote para encorajar boas práticas de codificação em uma equipe.


[Compass app source code]: https://github.com/flutter/samples/tree/main/compass_app
[very_good_cli]: https://cli.vgv.dev/
[Very Good Engineering architecture documentation]: https://engineering.verygood.ventures/architecture/architecture/
[Flutter developer tools]: /tools/devtools
[flutter_lints]: https://pub.dev/packages/flutter_lints

## Feedback

À medida que esta seção do site está evoluindo,
[recebemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="recommendations"
