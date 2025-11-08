# Notas de lançamento do DevTools 2.19.0

A versão 2.19.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do Performance

* Adicionado botão para alternar a visibilidade do gráfico Flutter Frames -
  [#4577](https://github.com/flutter/devtools/pull/4577)

  ![diff](/tools/devtools/release-notes/images-2.19.0/4577.png "Flutter Frames")

* Polimento do aviso de debug mode para descrever melhor quais dados são
  precisos em debug mode e quais dados podem ser enganosos -
  [#3537](https://github.com/flutter/devtools/pull/3537)
* Reordenadas abas da ferramenta de performance e exibição do CPU profiler
  apenas para a aba "Timeline Events" -
  [#4629](https://github.com/flutter/devtools/pull/4629)

## Atualizações do Memory

* Melhorias na aba Profile de memória -
  [#4583](https://github.com/flutter/devtools/pull/4583)

## Atualizações do Debugger

* Corrigido problema com cartões de hover onde eles apareciam
  mas nunca desapareciam -
  [#4627](https://github.com/flutter/devtools/pull/4627)
* Corrigido bug com o diálogo de auto completar de busca de arquivo -
  [#4409](https://github.com/flutter/devtools/pull/4409)

## Atualizações do Network profiler

* Adicionado botão "Copy" na visualização de Network Request
  (agradecimento a @netos23) -
  [#4509](https://github.com/flutter/devtools/pull/4509)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.18.0...v2.19.0).
