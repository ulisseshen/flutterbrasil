# Notas de lançamento do DevTools 2.24.0

A versão 2.24.0 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre
o DevTools, confira a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Melhora o desempenho geral das tabelas do DevTools -
  [#5664](https://github.com/flutter/devtools/pull/5664),
  [#5696](https://github.com/flutter/devtools/pull/5696)

## Atualizações do profiler de CPU

* Corrige bug com a seleção do flame chart da CPU e dicas de ferramenta -
  [#5676](https://github.com/flutter/devtools/pull/5676)

## Atualizações do depurador

* Melhora o suporte para inspecionar instâncias `UserTag` e
  `MirrorReferent` -
  [#5490](https://github.com/flutter/devtools/pull/5490)
* Corrige bug de avaliação de expressão onde selecionar um resultado de
  preenchimento automático para um campo apagaria a entrada atual -
  [#5717](https://github.com/flutter/devtools/pull/5717)
* Faz a seleção de um stack frame rolar para o local do frame no código-fonte -
  [#5722](https://github.com/flutter/devtools/pull/5722)
* Melhora o desempenho da pesquisa por um arquivo e da pesquisa em um arquivo -
  [#5733](https://github.com/flutter/devtools/pull/5733)
* Desabilita o realce de sintaxe para arquivos com mais de 100.000
  caracteres devido a restrições de desempenho -
  [#5743](https://github.com/flutter/devtools/pull/5743)
* Corrige bug onde o código-fonte não estava visível se o realce de
  sintaxe para um arquivo estivesse desabilitado -
  [#5743](https://github.com/flutter/devtools/pull/5743)
* Impede que os nomes de arquivos e o código-fonte fiquem dessincronizados -
  [#5827](https://github.com/flutter/devtools/pull/5827)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão
anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.23.1...v2.24.0).
