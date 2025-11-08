# Notas de lançamento do DevTools 2.9.2

A versão 2.9.2 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Faça nossa pesquisa do DevTools 2022! Forneça seu feedback e nos ajude a melhorar
  sua experiência de desenvolvimento. Este prompt de pesquisa aparecerá diretamente no
  DevTools em meados de fevereiro.

  ![survey prompt](/tools/devtools/release-notes/images-2.9.2/image1.png "survey_prompt")

  *Nota*: Se você está tendo problemas ao iniciar a pesquisa, por favor
  certifique-se de ter atualizado para a branch stable mais recente do Flutter 2.10.
  Havia um bug no DevTools (corrigido em
  [#3574](https://github.com/flutter/devtools/pull/3574)) que
  impedia a pesquisa de ser aberta, e a menos que você
  esteja no Flutter 2.10, este bug ainda estará presente._

* Correções de bugs gerais e melhorias -
  [#3528](https://github.com/flutter/devtools/pull/3528),
  [#3531](https://github.com/flutter/devtools/pull/3531),
  [#3532](https://github.com/flutter/devtools/pull/3532),
  [#3539](https://github.com/flutter/devtools/pull/3539)

## Atualizações do Performance

* Adicionados números de frame ao eixo x do gráfico de frames do Flutter -
  [#3526](https://github.com/flutter/devtools/pull/3526)

  ![frame numbers](/tools/devtools/release-notes/images-2.9.2/image2.png "frame_numbers")

## Atualizações do Debugger

* Corrigido um bug onde o File Explorer no Debugger não mostrava o conteúdo
  após um hot restart -
  [#3527](https://github.com/flutter/devtools/pull/3527)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.9.1...v2.9.2).
