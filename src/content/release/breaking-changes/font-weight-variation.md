---
title: FontWeight também controla o atributo weight de fontes variáveis
description: >
  Valores FontWeight aplicados a estilos de texto agora definirão o atributo weight de fontes variáveis.
ia-translate: true
---

{% render "docs/breaking-changes.md" %}

## Resumo

Um `FontWeight` em um estilo de texto também definirá o atributo weight de fontes
variáveis. Não é mais necessário usar separadamente `FontVariation` para controlar
o weight dessas fontes.

## Contexto

Estilos de texto podem especificar um valor `FontWeight` que configura a espessura dos
traços usados para pintar o texto. `FontWeight` selecionará o weight mais próximo
entre um conjunto de arquivos de fonte pertencentes à mesma família.

No entanto, algumas fontes são distribuídas como [fontes variáveis](https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts)
onde um único arquivo de fonte permite o ajuste de atributos como weight. Para
fontes variáveis, aplicativos também tinham que usar a API `FontVariation` para definir
o valor do eixo de variação de weight dentro do arquivo de fonte selecionado.

O Flutter agora mudou o comportamento de `FontWeight` para que ele tanto
selecione o arquivo de fonte correspondente mais próximo quanto defina o atributo weight de fontes
variáveis.

## Descrição da mudança

Definir a propriedade `fontWeight` de objetos como `TextStyle` agora também
definirá o valor do eixo de variação `wght` de fontes que o suportam. O Flutter
aplicará internamente o equivalente a adicionar um atributo `FontVariation('wght')`
ao estilo cujo valor é o mesmo do `FontWeight`.

Instâncias de `FontWeight` agora podem ser construídas usando valores inteiros arbitrários
variando de 1 a 1000. Isso permite o uso de weights além da faixa
`FontWeight.w100` até `FontWeight.w900` com valores que não são
múltiplos de 100. Isso também significa que interpolação linear de fontes usando
`FontWeight.lerp` pode produzir valores diferentes de `FontWeight.w100` até `w900`.

A propriedade `FontWeight.index` agora está descontinuada porque ela apenas identifica
os weights `FontWeight.w100` até `w900`. Aplicativos devem usar
`FontWeight.value` para obter o nível de espessura de uma fonte.

## Guia de migração

Aplicativos podem ver mudanças na renderização de texto se usaram fontes variáveis e
estavam especificando `FontWeight` em estilos de texto sem um valor
`FontVariation('wght')` correspondente.

Se essas mudanças forem indesejáveis, então o aplicativo deve alterar o
`FontWeight` para um valor que alcance a renderização pretendida. Por exemplo,
para restaurar o weight padrão da fonte, defina `fontWeight` como `FontWeight.normal`.

## Cronograma

Adicionado na versão: 3.39.0-0.0.pre<br>
Na versão estável: Ainda não

## Referências

Documentação da API:

* [`FontWeight`][`FontWeight`]

Issue relevante:

* [Issue 148026][Issue 148026]

PR relevante:

* [PR 175771][PR 175771]

[`FontWeight`]: {{site.api}}/flutter/dart-ui/FontWeight-class.html
[Issue 148026]: {{site.repo.flutter}}/issues/148026
[PR 175771]: {{site.repo.flutter}}/pull/175771
