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

{% for section in architectureRecommendations %}
## {{section.category}}

{{section.description}}

{% if section.recommendations.size > 0 %}

<table class="table table-striped" style="border-bottom:1px #DADCE0 solid;">
<thead>
  <tr>
    <th style="width: 30%;">Recomendação</th>
    <th style="width: 70%;">Descrição</th>
  </tr>
</thead>
<tbody>
{% for rec in section.recommendations %}
<tr>
<td>

  {{rec.recommendation}}

{% if rec.confidence == "strong" %}
  <div class="rrec-pill success">Fortemente recomendado</div>
{% elsif rec.confidence == "recommend" %}
  <div class="rrec-pill info">Recomendado</div>
{% else %}
  <div class="rrec-pill">Condicional</div>
{% endif %}

</td>
<td>

  {{rec.description}}
  {{rec.confidence-description}}

</td>
</tr>
{% endfor %}
</tbody>
</table>

{% endif %}
{% endfor %}

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
  * [Passo a passo de gerenciamento de estado com ChangeNotifier][State Management with ChangeNotifier walkthrough] -
    Uma introdução gentil ao uso das primitivas no
    Flutter SDK para seu gerenciamento de estado.
* Ferramentas
  * [Ferramentas de desenvolvedor Flutter][Flutter developer tools] -
    DevTools é um conjunto de ferramentas de performance e debugging para Dart e Flutter.
  * [flutter_lints][flutter_lints] -
    Um pacote que contém os lints para
    apps Flutter recomendados pela equipe Flutter.
    Use este pacote para encorajar boas práticas de codificação em uma equipe.


[Separation-of-concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[architecture case study]: /app-architecture/guide
[our ChangeNotifier recommendation]: /get-started/fwe/state-management
[other popular options]: https://docs.flutter.dev/data-and-backend/state-mgmt/options
[freezed]: https://pub.dev/packages/freezed
[built_value]: https://pub.dev/packages/built_value
[Flutter Navigator API]: https://docs.flutter.dev/ui/navigation
[pub.dev]: https://pub.dev
[Compass app source code]: https://github.com/flutter/samples/tree/main/compass_app
[very_good_cli]: https://cli.vgv.dev/
[Very Good Engineering architecture documentation]: https://engineering.verygood.ventures/architecture/
[State Management with ChangeNotifier walkthrough]: /get-started/fwe/state-management
[Flutter developer tools]: /tools/devtools
[flutter_lints]: https://pub.dev/packages/flutter_lints

## Feedback

À medida que esta seção do site está evoluindo,
[recebemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="recommendations"
