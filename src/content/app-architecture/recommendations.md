---
title: Recomendações e recursos de arquitetura
short-title: Recomendações de arquitetura
description: >
  Recomendações para construir aplicações Flutter escaláveis.
prev:
  title: Estudo de caso de arquitetura
  path: /app-architecture/case-study
next:
  title: Padrões de projeto
  path: /app-architecture/design-patterns
ia-translate: true
---

Esta página apresenta as melhores práticas de arquitetura, por que elas são importantes e
se nós as recomendamos para a sua aplicação Flutter.
Você deve tratar estas recomendações como recomendações,
e não como regras inflexíveis, e você deve
adaptá-las aos requisitos únicos do seu app.

As melhores práticas nesta página têm uma prioridade,
que reflete o quão fortemente o time Flutter a recomenda.

*   **Fortemente recomendado:** Você deve sempre implementar esta recomendação se
    você está começando a construir um novo aplicativo. Você deve considerar fortemente
    refatorar um aplicativo existente para implementar esta prática a menos que isso
    entre em conflito fundamentalmente com sua abordagem atual.
*   **Recomendado**: Esta prática provavelmente irá melhorar o seu aplicativo.
*   **Condicional**: Esta prática pode melhorar seu aplicativo em certas circunstâncias.
<br /><br />

{% for section in architecture_recommendations %}
<h2>{{section.category}}</h2>
<p>{{section.description}}</p>
<table class="table table-striped" style="border-bottom:1px #DADCE0 solid">
    <tr class="tr-main-head">
      <th style="width: 30%">Recomendação</th>
      <th style="width: 70%">Descrição</th>
    </tr>
    {% for rec in section.recommendations %}
    <tr>
      <td>
        <p>{{rec.recommendation}}</p>
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
        <br />
        {{rec.confidence-description}}</td>
    </tr>    {% endfor %}
</table>
<br />
{% endfor %}

## Recursos recomendados

* Código e templates
  * [Código fonte do aplicativo Compass][] -
    Código fonte de um aplicativo Flutter robusto e completo que
    implementa muitas dessas recomendações.
  * [Flutter skeleton][] -
    Um template de aplicativo Flutter que inclui muitas dessas recomendações.
  * [very_good_cli][] -
    Um template de aplicativo Flutter feito por
    especialistas Flutter da Very Good Ventures.
    Este template gera uma estrutura de aplicativo similar.
* Documentação
  * [Documentação de arquitetura da Very Good Engineering][] -
    Very Good Engineering é um site de documentação da VGV que possui
    artigos técnicos, demos e projetos de código aberto.
    Inclui documentação sobre arquitetura de aplicativos Flutter.
  * [Passo a passo de gerenciamento de estado com ChangeNotifier][] -
    Uma introdução suave ao uso dos primitivos no
    SDK Flutter para seu gerenciamento de estado.
* Ferramentas
  * [Ferramentas de desenvolvedor Flutter][] -
    DevTools é um conjunto de ferramentas de desempenho e depuração para Dart e Flutter.
  * [flutter_lints][] -
    Um pacote que contém os lints para
    aplicativos Flutter recomendados pelo time Flutter.
    Use este pacote para incentivar boas práticas de codificação em uma equipe.

[Separation-of-concerns]: https://en.wikipedia.org/wiki/Separation_of_concerns
[architecture case study]: /app-architecture/guide
[our ChangeNotifier recommendation]: /get-started/fwe/state-management
[other popular options]: https://docs.flutter.dev/data-and-backend/state-mgmt/options
[freezed]: https://pub.dev/packages/freezed
[built_value]: https://pub.dev/packages/built_value
[Flutter Navigator API]: https://docs.flutter.dev/ui/navigation
[pub.dev]: https://pub.dev
[Código fonte do aplicativo Compass]: https://github.com/flutter/samples/tree/main/compass_app
[Flutter skeleton]: https://github.com/flutter/flutter/blob/master/packages/flutter_tools/templates/skeleton/README.md.tmpl
[very_good_cli]: https://cli.vgv.dev/
[Documentação de arquitetura da Very Good Engineering]: https://engineering.verygood.ventures/architecture/
[Passo a passo de gerenciamento de estado com ChangeNotifier]: /get-started/fwe/state-management
[Ferramentas de desenvolvedor Flutter]: /tools/devtools
[flutter_lints]: https://pub.dev/packages/flutter_lints

## Feedback

Como esta seção do site está evoluindo,
nós [agradecemos seu feedback][]!

[agradecemos seu feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="recommendations"
