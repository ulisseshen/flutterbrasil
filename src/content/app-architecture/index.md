---
ia-translate: true
title: Arquitetura de apps Flutter
shortTitle: Arquitetura
description: >
  Aprenda como estruturar apps Flutter.
showToc: false
next:
  title: Conceitos de arquitetura
  path: /app-architecture/concepts
---

<div class="side-by-side">
<div>

Arquitetura é uma parte importante da construção de um
app Flutter sustentável, resiliente e escalável.
Neste guia, você aprenderá princípios de arquitetura de aplicações e
melhores práticas para construir apps Flutter.

'Arquitetura' é uma palavra difícil de definir.
É um termo amplo e pode se referir a vários
tópicos dependendo do contexto. Neste guia,
'arquitetura' se refere a como estruturar, organizar e projetar
seu app Flutter para escalar à medida que os requisitos do projeto e a equipe crescem.

</div>
<div class="centered-rows">
<img src='/assets/images/docs/app-architecture/hero-image.png' style="max-height: 480px;" alt="Hero image">
</div>
</div>


## O que você aprenderá

* Benefícios de uma arquitetura intencional
* Princípios arquiteturais comuns
* A arquitetura de aplicações recomendada pela equipe Flutter
* MVVM e gerenciamento de estado
* Injeção de dependência
* Padrões de design comuns para escrever aplicações Flutter robustas

{% comment %}
TODO @ewindmill complete this list as pages land, add links.
{% endcomment %}

## Benefícios de uma arquitetura intencional

Uma boa arquitetura de aplicações oferece vários benefícios para
equipes de engenharia e seus usuários finais.

* Manutenibilidade - A arquitetura de aplicações torna mais fácil modificar, atualizar e corrigir
  problemas ao longo do tempo.
* Escalabilidade - Uma aplicação bem pensada permite que mais pessoas contribuam
  para a mesma base de código simultaneamente, com conflitos mínimos de código.
* Testabilidade - Aplicações com arquitetura intencional geralmente têm
  classes mais simples com entradas e saídas bem definidas, o que as torna mais fáceis
  de simular e testar.
* Menor carga cognitiva - Desenvolvedores novos no projeto serão mais
  produtivos em um período mais curto de tempo, e revisões de código geralmente consomem menos
  tempo quando o código é mais fácil de entender.
* Uma melhor experiência do usuário - Funcionalidades podem ser entregues mais rápido e com menos bugs.

## Como usar este guia

Este é um guia para construir aplicações Flutter escaláveis e foi escrito para
equipes que têm múltiplos desenvolvedores contribuindo para a mesma base de código,
que estão construindo uma aplicação rica em funcionalidades.
Se você está escrevendo um app Flutter que tem uma *equipe e base de código em crescimento*,
esta orientação é para você.

Além de conselhos arquiteturais gerais, este guia fornece exemplos concretos de
melhores práticas e inclui recomendações específicas.
Algumas bibliotecas podem ser trocadas, e equipes muito grandes com complexidade única
podem achar que algumas partes não se aplicam.
Em ambos os casos, as ideias permanecem sólidas.
Esta é a maneira recomendada de construir um app Flutter.

Na primeira parte deste guia, você aprenderá sobre princípios arquiteturais
comuns de um alto nível. Na segunda parte,
o guia apresenta recomendações específicas e
concretas de arquitetura de apps Flutter.
Finalmente, no final do guia, você encontrará uma lista de padrões de design e
código de exemplo que mostra as recomendações em ação.

[Common architectural principles]: /app-architecture/concepts
[recommended app architecture]: /app-architecture/guide
[MVVM]: /app-architecture/guide#mvvm


## Feedback

À medida que esta seção do site está evoluindo,
[recebemos seu feedback][welcome your feedback]!

[welcome your feedback]: https://google.qualtrics.com/jfe/form/SV_4T0XuR9Ts29acw6?page="index"
