# Notas de lançamento do DevTools 2.14.0

A versão 2.14.0 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionado um link para o novo canal do DevTools no [Discord](https://discord.com/channels/608014603317936148/958862085297672282) na caixa de diálogo Sobre o DevTools - [#4102](https://github.com/flutter/devtools/pull/4102)

  ![about-devtools](/tools/devtools/release-notes/images-2.14.0/image1.png "sobre o devtools")

## Atualizações de Rede

* Adicionadas as ações "Copiar como URL" e "Copiar como cURL" para solicitações selecionadas no profiler de rede (agradecimentos especiais a [@jankuss](https://github.com/jankuss)!) - [#4113](https://github.com/flutter/devtools/pull/4113)

  ![network-request-copy-actions](/tools/devtools/release-notes/images-2.14.0/image2.png "ações de copiar solicitação de rede")

## Atualizações do inspetor do Flutter

* Adicionada uma configuração para controlar se passar o mouse sobre um widget no inspetor exibe suas propriedades e valores em um card de sobreposição - [#4090](https://github.com/flutter/devtools/pull/4090)

## Atualizações do depurador

* Adicionadas sugestões de auto completar no console (agradecimentos especiais a [@jankuss](https://github.com/jankuss)!) - [#4062](https://github.com/flutter/devtools/pull/4062)

  ![auto-complete-suggestions](/tools/devtools/release-notes/images-2.14.0/image3.png "sugestões de auto completar")

* Adicionada a opção de copiar o caminho completo do arquivo para uma biblioteca selecionada - [#4147](https://github.com/flutter/devtools/pull/4147)
* Corrigida a formatação no menu de exceção do depurador - [#4066](https://github.com/flutter/devtools/pull/4066)

## Atualizações de memória

* Corrigida a formatação para valores de memória na visualização da árvore de heap - [#4153](https://github.com/flutter/devtools/pull/4153)
* Corrigido um bug que impedia que eventos de GC aparecessem no gráfico de memória - [#4131](https://github.com/flutter/devtools/pull/4131)

## Atualizações de performance

* Avisar os usuários que os toggles da camada de renderização no menu "Mais Opções de Depuração" não estão disponíveis para apps no modo profile - [#4075](https://github.com/flutter/devtools/pull/4075)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, consulte [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.13.1...v2.14.0).
