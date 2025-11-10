---
ia-translate: true
title: Substitua com o título da mudança incompatível
description: >-
  Breve descrição similar à seção "contexto" abaixo.
  O texto deve quebrar em 80 caracteres ou menos.
---

{% render "docs/breaking-changes.md" %}

{% comment %}
  POR FAVOR, LEIA ESTAS INSTRUÇÕES GERAIS:
  * Todas as linhas de texto devem ter 80 caracteres OU MENOS.
    Os escritores preferem fortemente quebras de linha semânticas:
    https://github.com/dart-lang/site-shared/blob/main/doc/writing-for-dart-and-flutter-websites.md#semantic-line-breaks
  * NÃO ENVIE um PR semanas e semanas antes.
    Fazer isso faz com que ele fique obsoleto no repositório
    do site e geralmente desenvolve conflitos no arquivo de índice.
    Idealmente, envie um PR assim que você tiver confirmado
    informações sobre o número da versão onde a mudança
    incompatível foi implementada.
  * Uma das coisas mais importantes a preencher
    neste template é a seção *Timeline*.
    Por exemplo: `Landed in version: 1.21.0-5.0.pre<br>`.
    NÃO liste o PR nesta seção. Além disso, não
    preencha as informações da versão "stable" a menos que já
    esteja em uma versão stable publicada.
    Após uma versão stable, confirmamos
    que as atualizações chegaram à stable e então
    atualizamos a mudança incompatível e o arquivo de índice.
  * O texto nesta página deve estar olhando para trás,
    então escreva sobre o comportamento anterior no passado,
    não no futuro. As pessoas estão lendo isso meses
    depois, quando a mudança provavelmente está na versão
    stable, não hoje. Não diga "em um mês" ou
    fale sobre seu plano de fazer algo na próxima semana.
    Assuma que você já fez isso, e que elas estão olhando
    para trás para descobrir como migrar seu código.
  * Use maiúsculas apenas no início da frase para títulos.
    (`## Migration guide`, NÃO `Migration Guide`)
  * NÃO use as abreviações `i.e.` ou `e.g.`.
    Use "por exemplo" ou "tal como", e similares.
  * Para links, use as macros quando possível.
    Veja os exemplos no final deste template,
    mas não use "github.com" ou "api.flutterbrasil.dev" ou
    "pub.dev" em suas URLs. Use as macros {{site.github}},
    {{site.api}}, ou {{site.pub}}.
  * EVITE "will" quando possível, em outras palavras,
    fique no presente. Por exemplo:
    Ruim: "When encountering an xxx value,
          the code will throw an exception."
    Bom: "When encountering an xxx value,
           the code throws an exception."
    Bom uso de "will": "In release 2.0, the xxx API
          will be deprecated."
  * Por fim, delete as tags de comentário e o texto do
    PR final.
{% endcomment %}

## Resumo

{% comment %}
  Um breve resumo (de uma a três linhas) que fornece
  contexto sobre o que mudou para que alguém possa
  encontrá-lo ao navegar por um índice de
  mudanças incompatíveis, idealmente usando palavras-chave dos
  sintomas que você veria se ainda não tivesse
  migrado (por exemplo, o texto de prováveis
  mensagens de erro).
{% endcomment %}

## Contexto

{% comment %}
  Descrição de alto nível sobre qual API mudou e por quê.
  Deve ser clara o suficiente para ser compreensível para alguém
  que não tem contexto sobre esta mudança incompatível,
  como alguém que não conhece a API subjacente.
  Esta seção também deve responder à pergunta
  "qual é o problema que levou a considerar fazer
  uma mudança incompatível?"

  Inclua uma descrição técnica da mudança real,
  com exemplos de código mostrando como a API mudou.

  Inclua exemplos das mensagens de erro que são produzidas
  em código que não foi migrado. Isso ajuda o mecanismo de busca
  a encontrar o guia de migração quando as pessoas pesquisam por essas
  mensagens de erro. ISSO É MUITO IMPORTANTE PARA DESCOBERTA!
{% endcomment %}

## Guia de migração

{% comment %}
  Uma descrição de como fazer a mudança.
  Se uma ferramenta de migração estiver disponível,
  discuta-a aqui. Mesmo se houver uma ferramenta,
  uma descrição de como fazer a mudança manualmente
  deve ser fornecida. Esta seção precisa de exemplos
  de código antes e depois que sejam relevantes para o
  desenvolvedor.
{% endcomment %}

Código antes da migração:

```dart
// Example of code before the change.
```

Código após a migração:

```dart
// Example of code after the change.
```

{% comment %}
  Certifique-se de ter procurado por tutoriais antigos online que
  usam a API antiga. Contate seus autores e aponte como
  eles devem ser atualizados. Deixe um comentário apontando que
  a API mudou e fazendo link para este guia.
{% endcomment %}

## Linha do tempo

{% comment %}
  O número da versão do SDK onde esta mudança foi
  introduzida. Se houver uma janela de descontinuação,
  o número da versão até a qual garantimos manter
  a API antiga. Use o seguinte template:

  Se uma mudança incompatível foi revertida em uma
  versão subsequente, mova esse item para a
  seção "Reverted" do arquivo index.md.
  Também adicione a linha "Reverted in version",
  mostrada como opcional abaixo. Caso contrário, delete
  essa linha.
{% endcomment %}

Landed in version: xxx<br>
In stable release: Not yet
Reverted in version: xxx  (OPTIONAL, delete if not used)

## Referências

{% comment %}
  Esses links estão comentados porque
  fazem com que o linkcheck do GitHubActions (GHA) falhe.
  Remova as tags de comentário assim que preencher isso com
  links reais. Apenas use o include "main-api" se
  você fizer link para "main-api.flutterbrasil.dev"; prefira nossa
  documentação stable se possível.

{% render "docs/main-api.md", site: site %}

API documentation:

* [`ClassName`][]

Relevant issues:

* [Issue xxxx][]
* [Issue yyyy][]

Relevant PRs:

* [PR title #1][]
* [PR title #2][]
{% endcomment %}

{% comment %}
  Adicione os links ao final do arquivo em ordem alfabética.
  Os links a seguir estão comentados porque fazem
  o verificador de links do GitHubActions (GHA) acreditar que são links quebrados,
  mas por favor remova as tags de comentário antes de fazer commit!

  Se você está compartilhando nova API que ainda não chegou ao
  canal stable, use o link do canal main.
  Para fazer link para docs no canal main,
  inclua a seguinte nota e certifique-se de que
  a URL inclui o link main (conforme mostrado abaixo).

  Aqui está um exemplo de definição de um link stable (site.api)
  e um link do canal main (main-api).

<!-- Stable channel link: -->
[`ClassName`]: {{site.api}}/flutter/[link_to_relevant_page].html

<!-- Master channel link: -->
{% render "docs/main-api.md", site: site %}

[`ClassName`]: {{site.main-api}}/flutter/[link_to_relevant_page].html

[Issue xxxx]: {{site.repo.flutter}}/issues/[link_to_actual_issue]
[Issue yyyy]: {{site.repo.flutter}}/issues/[link_to_actual_issue]
[PR title #1]: {{site.repo.flutter}}/pull/[link_to_actual_pr]
[PR title #2]: {{site.repo.flutter}}/pull/[link_to_actual_pr]
{% endcomment %}
