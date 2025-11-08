# Notas de lançamento do DevTools 2.8.0

A versão 2.8.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Melhorias no tempo de carregamento inicial da página -
  [#3325](https://github.com/flutter/devtools/pull/3325)
* Melhorias de desempenho ao conectar o DevTools a um dispositivo,
  particularmente impactante para dispositivos com pouca memória -
  [#3468](https://github.com/flutter/devtools/pull/3468)
* Para usuários no Flutter 2.8.0 ou superior (ou Dart 2.15.0 ou superior),
  o DevTools agora deve ser iniciado através do comando `dart devtools`
  em vez de executar `pub global activate devtools`.
  O DevTools 2.8.0 será a última versão do DevTools enviada no pub,
  e todas as versões futuras do DevTools serão enviadas como parte do Dart SDK.
  Se você vir este aviso,
  certifique-se de abrir o DevTools via `dart devtools` em vez de pelo pub:

  ![dart devtools warning dialog](/tools/devtools/release-notes/images-2.8.0/image1.png "dart devtools warning dialog")

## Atualizações do Performance

* Adicionada nova funcionalidade "Enhance Tracing" para ajudar usuários a diagnosticar jank na UI
  originado de operações de Build, Layout e Paint caras.

  ![Enhance tracing](/tools/devtools/release-notes/images-2.8.0/image2.png "Enhance tracing")

  O fluxo de trabalho esperado é o seguinte:

  1. Usuário está investigando jank na UI na página de performance
  2. Usuário nota um evento de Build, Layout e/ou Paint longo
  3. Usuário ativa o respectivo toggle de rastreamento na funcionalidade "Enhance Tracing"
  4. Usuário reproduz o jank na UI em seu app
  5. Usuário olha o novo conjunto de eventos do Timeline, que agora deve ter
     eventos filhos adicionais para widgets construídos, render objects organizados,
     e/ou render objects pintados

  ![Timeline events](/tools/devtools/release-notes/images-2.8.0/image3.png "Timeline events")

* Adicionada nova funcionalidade "More debugging options" para permitir desabilitar
  camadas de renderização para Clip, Opacity e Physical Shapes.

  ![More debugging options](/tools/devtools/release-notes/images-2.8.0/image4.png "More debugging options")

  O fluxo de trabalho esperado é o seguinte:

  1. Usuário está investigando jank na UI na página de performance
  2. Usuário nota muitos frames com jank e suspeita que pode ser devido ao
     uso excessivo de clipping, opacity ou physical shapes.
  3. Usuário desativa o respectivo toggle de camada de renderização na funcionalidade "More
     debugging options"
  4. Usuário reproduz o jank na UI em seu app
  5. Se o jank na UI for reduzido com uma camada de renderização desativada,
     o usuário deve tentar otimizar seu app para usar
     menos efeitos de clipping/opacity/physical shape.
     Se o jank na UI não for reduzido,
     o usuário agora sabe que o problema de desempenho
     não é devido a esses efeitos de UI.

## Atualizações do Debugger

* Substituído o painel "Libraries" por um painel "File Explorer" -
  [#3448](https://github.com/flutter/devtools/pull/3448).
  O painel "File Explorer" tem dois componentes:

  1. Uma visualização em árvore das bibliotecas presentes em sua aplicação.
     Você pode usar o File Explorer para encontrar e abrir uma biblioteca,
     ou pode usar o atalho de teclado existente <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
     <kbd>P</kbd> para procurar um arquivo.
  1. Uma nova visualização "Outline" que mostra a estrutura da biblioteca selecionada.
     Esta visualização mostrará classes, membros, métodos, etc.,
     e quando um item é selecionado,
     a visualização do código irá pular para a respectiva linha de código
     do item selecionado.

  ![Outline view selected library](/tools/devtools/release-notes/images-2.8.0/image5.png "Outline view selected library")

* Melhorias de desempenho no auto completar de avaliação de expressões -
  [#3463](https://github.com/flutter/devtools/pull/3463)
* Corrigido um bug com atalhos de teclado -
  [#3458](https://github.com/flutter/devtools/pull/3458)
* Polimento de UI - [#3421](https://github.com/flutter/devtools/pull/3421),
  [#3449](https://github.com/flutter/devtools/pull/3449)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.7.0...v2.8.0).
