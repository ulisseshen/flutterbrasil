# Notas de lançamento do DevTools 2.36.0

O lançamento 2.36.0 do Dart e Flutter DevTools inclui as seguintes
mudanças, entre outras melhorias gerais. Para saber mais sobre o
DevTools, confira a [visão geral do DevTools](/tools/devtools).

## Atualizações de desempenho

* Adicionada uma funcionalidade para mostrar a contagem de builds de
  widgets. Habilite esta configuração para ver a contagem de builds de
  widgets para cada frame do Flutter na ferramenta "Análise de Frame",
  ou para ver um resumo agregado destas contagens na nova ferramenta
  "Estatísticas de Reconstrução". -
  [#7838](https://github.com/flutter/devtools/pull/7838),
  [#7847](https://github.com/flutter/devtools/pull/7847)

    ![Configuração de rastreamento de contagem de builds de widgets]
    (/tools/devtools/release-notes/images-2.36.0/track_build_counts_setting.png
     "Configuração de rastreamento de contagem de builds de widgets")

    ![Contagem de reconstruções de widgets na visualização de Análise de
    Frame]
    (/tools/devtools/release-notes/images-2.36.0/rebuild_counts_frame_analysis.png
     "Contagens de reconstruções de widgets para um frame do flutter")

    ![Contagem de reconstruções de widgets na visualização de Estatísticas
    de Reconstrução]
    (/tools/devtools/release-notes/images-2.36.0/rebuild_stats.png
     "Estatísticas agregadas de contagens de reconstruções de widgets")

## Atualizações do Network Profiler

* Adicionado melhor suporte para janelas de visualização estreitas,
  como quando esta tela é incorporada em um IDE. -
  [#7726](https://github.com/flutter/devtools/pull/7726)

## Atualizações da ferramenta Deep Links

* Adicionada uma página de erro para explicar o problema quando a
  ferramenta não consegue analisar o projeto. -
  [#7767](https://github.com/flutter/devtools/pull/7767)

## Atualizações da Extensão do DevTools

* Corrigido um problema na detecção de extensões para testes Dart ou
  Flutter. - [#7717](https://github.com/flutter/devtools/pull/7717)
* Corrigido um problema na detecção de extensões para projetos Dart ou
  Flutter aninhados. - [#7742](https://github.com/flutter/devtools/pull/7742)
* Adicionado um exemplo ao `package:devtools_extensions` que mostra
  como interagir com o Dart Tooling Daemon a partir de uma extensão do
  DevTools. - [#7752](https://github.com/flutter/devtools/pull/7752)
* Corrigido um bug de roteamento do DevTools relacionado a desabilitar
  uma extensão. - [#7791](https://github.com/flutter/devtools/pull/7791)
* Corrigido um bug que causava um erro "Página Não Encontrada" ao
  atualizar o DevTools a partir de uma tela de extensão. -
  [#7822](https://github.com/flutter/devtools/pull/7822)
* Corrigido um problema de tema quando as extensões são incorporadas
  em um IDE - [#7824](https://github.com/flutter/devtools/pull/7824)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.36.0).
