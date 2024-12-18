# Notas de lançamento do DevTools 2.8.0

O lançamento 2.8.0 do Dart e Flutter DevTools
inclui as seguintes alterações, entre outras melhorias gerais.
Para saber mais sobre o DevTools, consulte a
[Visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações Gerais

* Melhorias para o tempo de carregamento inicial da página -
  [#3325](https://github.com/flutter/devtools/pull/3325)
* Melhorias de desempenho para conectar o DevTools a um dispositivo,
  particularmente impactante para dispositivos com pouca memória -
  [#3468](https://github.com/flutter/devtools/pull/3468)
* Para usuários no Flutter 2.8.0 ou superior (ou Dart 2.15.0 ou superior),
  o DevTools agora deve ser iniciado por meio do comando `dart devtools`
  em vez de executar `pub global activate devtools`.
  O DevTools 2.8.0 será a última versão do DevTools enviada no pub,
  e todas as versões futuras do DevTools serão enviadas como parte do SDK Dart.
  Se você vir este aviso,
  certifique-se de abrir o DevTools via `dart devtools` em vez de pub:

  ![dialogo de aviso dart devtools](/tools/devtools/release-notes/images-2.8.0/image1.png "dialogo de aviso dart devtools")

## Atualizações de Performance

* Adicionada uma nova funcionalidade "Aprimorar Rastreamento" para ajudar os usuários a diagnosticar jank na interface do usuário
  decorrente de operações caras de Build, Layout e Paint.

  ![Aprimorar rastreamento](/tools/devtools/release-notes/images-2.8.0/image2.png "Aprimorar rastreamento")

  O fluxo de trabalho esperado é o seguinte:

  1.  O usuário está investigando o jank da interface do usuário na página de performance
  2.  O usuário percebe um evento longo de Build, Layout e/ou Paint
  3.  O usuário ativa a alternância de rastreamento respectiva no recurso "Aprimorar Rastreamento"
  4.  O usuário reproduz o jank da interface do usuário em seu aplicativo
  5.  O usuário analisa o novo conjunto de eventos do Timeline, que agora deve ter
      eventos filhos adicionais para widgets construídos, objetos de renderização dispostos,
      e/ou objetos de renderização pintados

  ![Eventos do Timeline](/tools/devtools/release-notes/images-2.8.0/image3.png "Eventos do Timeline")

* Adicionado um novo recurso "Mais opções de depuração" para permitir a desativação
  de camadas de renderização para Clip, Opacity e Physical Shapes.

  ![Mais opções de depuração](/tools/devtools/release-notes/images-2.8.0/image4.png "Mais opções de depuração")

  O fluxo de trabalho esperado é o seguinte:

  1.  O usuário está investigando o jank da interface do usuário na página de performance
  2.  O usuário percebe muitos frames com jank e suspeita que pode ser devido ao
      uso excessivo de recorte, opacidade ou formas físicas.
  3.  O usuário desativa a alternância da camada de renderização respectiva no recurso "Mais
      opções de depuração"
  4.  O usuário reproduz o jank da interface do usuário em seu aplicativo
  5.  Se o jank da interface do usuário for reduzido com uma camada de renderização desativada,
      o usuário deve tentar otimizar seu aplicativo para usar
      menos efeitos de recorte/opacidade/forma física.
      Se o jank da interface do usuário não for reduzido,
      o usuário agora sabe que o problema de performance
      não é devido a esses efeitos de interface do usuário.

## Atualizações do Depurador

* Substituiu o painel "Bibliotecas" por um painel "Explorador de Arquivos" -
  [#3448](https://github.com/flutter/devtools/pull/3448).
  O painel "Explorador de Arquivos" tem dois componentes:

  1. Uma visualização em árvore das bibliotecas presentes em seu aplicativo.
     Você pode usar o Explorador de Arquivos para encontrar e abrir uma biblioteca,
     ou você pode usar o atalho de teclado existente <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> +
     <kbd>P</kbd> para pesquisar um arquivo.
  2. Uma nova visualização "Outline" que mostra a estrutura da biblioteca selecionada.
     Esta visualização mostrará classes, membros, métodos, etc.,
     e quando um item é selecionado,
     a visualização do código-fonte irá saltar para a respectiva linha de código
     para o item selecionado.

  ![Visualização Outline da biblioteca selecionada](/tools/devtools/release-notes/images-2.8.0/image5.png "Visualização Outline da biblioteca selecionada")

* Melhorias de desempenho para o preenchimento automático da avaliação de expressões -
  [#3463](https://github.com/flutter/devtools/pull/3463)
* Corrigido um bug com atalhos de teclado -
  [#3458](https://github.com/flutter/devtools/pull/3458)
* Refinamento da interface do usuário - [#3421](https://github.com/flutter/devtools/pull/3421),
  [#3449](https://github.com/flutter/devtools/pull/3449)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.7.0...v2.8.0).
