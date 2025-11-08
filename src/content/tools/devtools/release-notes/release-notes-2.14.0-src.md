# Notas de lançamento do DevTools 2.14.0

A versão 2.14.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionado link para o novo
  [canal do Discord](https://discord.com/channels/608014603317936148/958862085297672282) do DevTools
  no diálogo About DevTools -
  [#4102](https://github.com/flutter/devtools/pull/4102)

  ![about-devtools](/tools/devtools/release-notes/images-2.14.0/image1.png "about devtools")

## Atualizações do Network

* Adicionadas ações "Copy as URL" e "Copy as cURL" para
  requisições selecionadas no network profiler
  (agradecimento especial a [@jankuss](https://github.com/jankuss)!) -
  [#4113](https://github.com/flutter/devtools/pull/4113)

  ![network-request-copy-actions](/tools/devtools/release-notes/images-2.14.0/image2.png "network request copy actions")

## Atualizações do Flutter inspector

* Adicionada configuração para controlar se passar o mouse sobre um widget
  no inspector exibe suas propriedades e valores em um cartão de hover -
  [#4090](https://github.com/flutter/devtools/pull/4090)

## Atualizações do Debugger

* Adicionadas sugestões de auto completar no console
  (agradecimento especial a [@jankuss](https://github.com/jankuss)!) -
  [#4062](https://github.com/flutter/devtools/pull/4062)

  ![auto-complete-suggestions](/tools/devtools/release-notes/images-2.14.0/image3.png "auto complete suggestions")

* Adicionada opção para copiar o caminho completo do arquivo para uma biblioteca selecionada -
  [#4147](https://github.com/flutter/devtools/pull/4147)
* Corrigida formatação no menu de exceções do debugger -
  [#4066](https://github.com/flutter/devtools/pull/4066)

## Atualizações do Memory

* Corrigida formatação para valores de memória na visualização em árvore do heap -
  [#4153](https://github.com/flutter/devtools/pull/4153)
* Corrigido um bug que estava impedindo eventos de GC de
  aparecer no gráfico de memória -
  [#4131](https://github.com/flutter/devtools/pull/4131)

## Atualizações do Performance

* Aviso aos usuários de que os toggles de camada de renderização no
  menu "More Debugging Options" não estão disponíveis para apps em profile mode -
  [#4075](https://github.com/flutter/devtools/pull/4075)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.13.1...v2.14.0).
