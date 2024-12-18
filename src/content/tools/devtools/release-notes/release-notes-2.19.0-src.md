# Notas de lançamento do DevTools 2.19.0

A versão 2.19.0 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre
o DevTools, confira a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações de desempenho

* Adicionado um botão para alternar a visibilidade do gráfico de
  Frames do Flutter - [#4577](https://github.com/flutter/devtools/pull/4577)

  ![diff](/tools/devtools/release-notes/images-2.19.0/4577.png "Frames do Flutter")

* Aperfeiçoar o aviso do modo de depuração para descrever melhor
  quais dados são precisos no modo de depuração e quais dados
  podem ser enganosos - [#3537](https://github.com/flutter/devtools/pull/3537)
* Reordenar as abas da ferramenta de desempenho e mostrar apenas
  o CPU profiler para a aba "Timeline Events" -
  [#4629](https://github.com/flutter/devtools/pull/4629)

## Atualizações de memória

* Melhorias na aba de Perfil de memória -
  [#4583](https://github.com/flutter/devtools/pull/4583)

## Atualizações do depurador

* Corrigido um problema com os cards de foco onde eles apareciam,
  mas nunca desapareciam -
  [#4627](https://github.com/flutter/devtools/pull/4627)
* Corrigido um bug com a caixa de diálogo de autocompletar na
  pesquisa de arquivos -
  [#4409](https://github.com/flutter/devtools/pull/4409)

## Atualizações do profiler de rede

* Adicionado um botão "Copiar" na visualização de Requisição de
  Rede (obrigado a @netos23) -
  [#4509](https://github.com/flutter/devtools/pull/4509)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão
anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.18.0...v2.19.0).
