# Notas de lançamento do DevTools 2.8.0

A versão 2.8.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* Melhorias no tempo de carregamento inicial da página -
  [#3325](https://github.com/flutter/devtools/pull/3325)
* Melhorias de desempenho para conectar DevTools a um dispositivo,
  particularmente impactante para dispositivos com pouca memória -
  [#3468](https://github.com/flutter/devtools/pull/3468)
* Para usuários no Flutter 2.8.0 ou superior (ou Dart 2.15.0 ou superior),
  DevTools agora deve ser iniciado via comando `dart devtools`
  em vez de executar `pub global activate devtools`.
  DevTools 2.8.0 será a última versão do DevTools lançada no pub,
  e todas as versões futuras do DevTools serão lançadas como parte do Dart SDK.
  Se você ver este aviso,
  certifique-se de abrir DevTools via `dart devtools` em vez de do pub:

  ![dart devtools warning dialog](/tools/devtools/release-notes/images-2.8.0/image1.png "dart devtools warning dialog")

## Atualizações de Performance

* Adicionado um novo recurso "Enhance Tracing" para ajudar usuários a diagnosticar jank de UI
  decorrente de operações Build, Layout e Paint caras.

  ![Enhance tracing](/tools/devtools/release-notes/images-2.8.0/image2.png "Enhance tracing")

  O fluxo de trabalho esperado é o seguinte:

  1. Usuário está investigando jank de UI na página de performance
  2. Usuário nota um evento Build, Layout e/ou Paint longo
  3. Usuário ativa o respectivo toggle de rastreamento no recurso "Enhance Tracing"
  4. Usuário reproduz o jank de UI em seu app
  5. Usuário observa o novo conjunto de eventos Timeline, que agora devem ter
     eventos filho adicionais para widgets construídos, render objects com layout feito,
     e/ou render objects pintados

  ![Timeline events](/tools/devtools/release-notes/images-2.8.0/image3.png "Timeline events")

* Adicionado novo recurso "More debugging options" para permitir desabilitar
  rendering layers para Clip, Opacity e Physical Shapes.

  ![More debugging options](/tools/devtools/release-notes/images-2.8.0/image4.png "More debugging options")

  O fluxo de trabalho esperado é o seguinte:

  1. Usuário está investigando jank de UI na página de performance
  2. Usuário nota muitos frames com jank e suspeita que pode ser devido a
     uso excessivo de clipping, opacity ou physical shapes.
  3. Usuário desativa o respectivo toggle de render layer no recurso "More
     debugging options"
  4. Usuário reproduz o jank de UI em seu app
  5. Se o jank de UI for reduzido com uma rendering layer desativada,
     o usuário deve tentar otimizar seu app para usar
     menos efeitos de clipping/opacity/physical shape.
     Se o jank de UI não for reduzido,
     o usuário agora sabe que o problema de desempenho
     não é devido a esses efeitos de UI.

## Atualizações do Debugger

* Substituído o painel "Libraries" por um painel "File Explorer" -
  [#3448](https://github.com/flutter/devtools/pull/3448).
  O painel "File Explorer" tem dois componentes:

  1. Uma visualização em árvore das bibliotecas presentes em sua aplicação.
     Você pode usar o File Explorer para encontrar e abrir uma biblioteca,
     ou você pode usar o atalho de teclado existente <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
     <kbd>P</kbd> para pesquisar por um arquivo.
  1. Uma nova visualização "Outline" que mostra a estrutura da biblioteca selecionada.
     Esta visualização mostrará classes, membros, métodos, etc.,
     e quando um item é selecionado,
     a visualização de código-fonte pulará para a respectiva linha de código
     para o item selecionado.

  ![Outline view selected library](/tools/devtools/release-notes/images-2.8.0/image5.png "Outline view selected library")

* Melhorias de desempenho no auto completar de avaliação de expressão -
  [#3463](https://github.com/flutter/devtools/pull/3463)
* Corrigido um bug com atalhos de teclado -
  [#3458](https://github.com/flutter/devtools/pull/3458)
* Polimento de UI - [#3421](https://github.com/flutter/devtools/pull/3421),
  [#3449](https://github.com/flutter/devtools/pull/3449)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.7.0...v2.8.0).
