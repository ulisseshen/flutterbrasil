---
ia-translate: true
title: Substitua pelo título da mudança Breaking Change
description: >-
  Breve descrição similar à seção "contexto" abaixo.
  O texto deve quebrar em 80 caracteres ou menos.
---

{% comment %}
  POR FAVOR, LEIA ESTAS INSTRUÇÕES GERAIS:
  * Todas as linhas de texto devem ter 80 caracteres OU MENOS.
    Os escritores preferem quebras de linha semânticas:
    https://github.com/dart-lang/site-shared/blob/main/doc/writing-for-dart-and-flutter-websites.md#semantic-line-breaks
  * NÃO ENVIE um PR semanas e semanas antes.
    Fazer isso faz com que ele fique estagnado no
    repositório do site e geralmente desenvolva
    conflitos no arquivo de índice. Idealmente, envie
    um PR assim que tiver informações confirmadas
    sobre o número da versão em que a mudança
    interruptiva foi implementada.
  * Uma das coisas mais importantes a serem preenchidas
    neste modelo é a seção *Linha do Tempo*.
    Não aprovarei/mesclarei o PR até que as informações
    de lançamento "implementado em" sejam fornecidas.
    Por exemplo: `Implementado na versão: 1.21.0-5.0.pre<br>`.
    NÃO liste o PR nesta seção. Além disso, não
    preencha as informações de lançamento "estável", a
    menos que já esteja em um lançamento estável publicado.
    Após um lançamento estável, eu reviso e confirmo
    se as atualizações chegaram ao estável e então
    atualizo a mudança interruptiva e o arquivo de índice.
  * O texto nesta página deve ser retrospectivo,
    portanto, escreva sobre o comportamento anterior no
    tempo passado, não no futuro. As pessoas estão
    lendo isso meses depois, quando a mudança
    provavelmente estará no lançamento estável, não hoje.
    Não diga "em um mês" ou fale sobre seu plano de
    fazer algo na próxima semana. Suponha que você já
    fez isso e que eles estão olhando para trás para
    descobrir como migrar seu código.
  * Use letras minúsculas para cabeçalhos e títulos.
    (`## Guia de migração`, NÃO `Guia de Migração`)
  * NÃO use a abreviação `i.e.` ou `e.g.`.
    Use "por exemplo" ou "como", e similares.
  * Para links, use os macros sempre que possível.
    Veja os exemplos no final deste modelo,
    mas não use "github.com" ou "api.flutter.dev" ou
    "pub.dev" em seus URLs. Use as macros {{site.github}},
    {{site.api}} ou {{site.pub}}.
  * EVITE "irá" quando possível, em outras palavras,
    permaneça no tempo presente. Por exemplo:
    Ruim: "Ao encontrar um valor xxx,
          o código irá lançar uma exceção."
    Bom: "Ao encontrar um valor xxx,
           o código lança uma exceção."
    Bom uso de "irá": "Na versão 2.0, a API xxx
          será descontinuada."
  * Finalmente, exclua as tags de comentário e o texto
    do PR final.
{% endcomment %}

## Sumário

{% comment %}
  Um breve sumário (de uma a três linhas) que forneça
  contexto sobre o que mudou para que alguém possa
  encontrá-lo ao navegar por um índice de
  mudanças interruptivas, idealmente usando palavras-
  chave dos sintomas que você veria se ainda não
  tivesse migrado (por exemplo, o texto de mensagens
  de erro prováveis).
{% endcomment %}

## Contexto

{% comment %}
  Descrição de alto nível de qual API mudou e por quê.
  Deve ser claro o suficiente para ser compreensível
  para alguém que não tem contexto sobre essa mudança
  interruptiva, como alguém que não conhece a API
  subjacente. Esta seção também deve responder à
  pergunta "qual é o problema que levou a considerar
  fazer uma mudança interruptiva?"

  Inclua uma descrição técnica da mudança real, com
  exemplos de código mostrando como a API mudou.

  Inclua exemplos das mensagens de erro produzidas
  em código que não foi migrado. Isso ajuda o mecanismo
  de busca a encontrar o guia de migração quando as
  pessoas procuram por essas mensagens de erro.
  ISTO É MUITO IMPORTANTE PARA A DESCOBERTA!
{% endcomment %}

## Guia de migração

{% comment %}
  Uma descrição de como fazer a mudança.
  Se uma ferramenta de migração estiver disponível,
  discuta isso aqui. Mesmo que exista uma ferramenta,
  uma descrição de como fazer a alteração manualmente
  deve ser fornecida. Esta seção precisa de exemplos
  de código antes e depois que sejam relevantes para
  o desenvolvedor.
{% endcomment %}

Código antes da migração:

```dart
// Exemplo de código antes da mudança.
```

Código após a migração:

```dart
// Exemplo de código após a mudança.
```

{% comment %}
  Certifique-se de que você procurou por tutoriais
  antigos online que usam a API antiga. Entre em contato
  com seus autores e aponte como eles devem ser
  atualizados. Deixe um comentário apontando que a
  API mudou e vinculando a este guia.
{% endcomment %}

## Linha do tempo

{% comment %}
  O número da versão do SDK onde esta mudança foi
  introduzida. Se houver uma janela de depreciação,
  o número da versão para o qual garantimos manter
  a API antiga. Use o seguinte modelo:

  Se uma mudança interruptiva foi revertida em um
  lançamento subsequente, mova esse item para a seção
  "Revertido" do arquivo index.md. Adicione também a
  linha "Revertido na versão", mostrada como opcional
  abaixo. Caso contrário, exclua essa linha.
{% endcomment %}

Implementado na versão: xxx<br>
Em lançamento estável: Ainda não
Revertido na versão: xxx (OPCIONAL, exclua se não usado)

## Referências

{% comment %}
  Esses links estão comentados porque causam a falha
  do linkcheck do GitHubActions (GHA). Remova as tags de
  comentário assim que você preencher isso com links
  reais. Use apenas o include "main-api" se você
  vincular a "main-api.flutter.dev"; prefira nossa
  documentação estável, se possível.

{% include docs/main-api.md %}

Documentação da API:

* [`ClassName`][]

Problemas relevantes:

* [Issue xxxx][]
* [Issue yyyy][]

PRs relevantes:

* [PR title #1][]
* [PR title #2][]
{% endcomment %}

{% comment %}
  Adicione os links ao final do arquivo em ordem
  alfabética. Os links a seguir estão comentados porque
  fazem com que o verificador de links do GitHubActions
  (GHA) acredite que eles são links quebrados, mas
  remova as tags de comentário antes de fazer o commit!

  Se você estiver compartilhando uma nova API que ainda
  não foi lançada no canal estável, use o link do canal
  principal. Para vincular à documentação no canal
  principal, inclua a seguinte observação e certifique-
  se de que o URL inclua o link principal (conforme
  mostrado abaixo).

  Aqui está um exemplo de definição de um link estável
  (site.api) e um link de canal principal (main-api).

<!-- Link do canal estável: -->
[`ClassName`]: {{site.api}}/flutter/[link_to_relevant_page].html

<!-- Link do canal master: -->
{% include docs/main-api.md %}

[`ClassName`]: {{site.main-api}}/flutter/[link_to_relevant_page].html

[Issue xxxx]: {{site.repo.flutter}}/issues/[link_to_actual_issue]
[Issue yyyy]: {{site.repo.flutter}}/issues/[link_to_actual_issue]
[PR title #1]: {{site.repo.flutter}}/pull/[link_to_actual_pr]
[PR title #2]: {{site.repo.flutter}}/pull/[link_to_actual_pr]
{% endcomment %}
