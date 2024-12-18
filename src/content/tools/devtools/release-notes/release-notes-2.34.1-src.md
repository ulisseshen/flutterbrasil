# Notas da versão do DevTools 2.34.1

A versão 2.34.1 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre o
DevTools, confira a [visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Corrigido um problema que impedia o DevTools de se conectar a aplicativos
  Flutter que não são iniciados a partir do Flutter Tools. -
  [#6848](https://github.com/flutter/devtools/issues/6848)
* Melhor desempenho do FlatTable. -
  [#7391](https://github.com/flutter/devtools/pull/7391)

## Atualizações do Inspetor

- Corrigido um caso limite em que widgets de outros pacotes podiam aparecer
  na árvore do inspetor. - [#7353](https://github.com/flutter/devtools/pull/7353)

## Atualizações de desempenho

* Adicionada uma configuração para incluir amostras de CPU na Timeline. -
  [#7333](https://github.com/flutter/devtools/pull/7333),
  [#7369](https://github.com/flutter/devtools/pull/7369)

    ![Configurações da Timeline](/tools/devtools/release-notes/images-2.34.1/7369-timeline-settings.png "Configurações da Timeline")

* Removido o visualizador de rastreamento legado. O visualizador de
  rastreamento legado foi substituído pelo visualizador de rastreamento
  Perfetto incorporado na versão 2.21.1 do DevTools, mas estava disponível
  por trás de uma configuração para garantir uma implementação tranquila.
  Esta versão do DevTools remove o visualizador de rastreamento legado
  completamente. - [#7316](https://github.com/flutter/devtools/pull/7316)
* Atualizada a compilação do visualizador de rastreamento Perfetto. -
  [#7445](https://github.com/flutter/devtools/pull/7445),
  [#7456](https://github.com/flutter/devtools/pull/7456),
  [#7480](https://github.com/flutter/devtools/pull/7480)
* Adicionada uma mensagem de carregamento para mostrar ao atualizar a
  timeline. - [#7463](https://github.com/flutter/devtools/pull/7463)

    ![Mensagem de carregamento](/tools/devtools/release-notes/images-2.34.1/7463-overlay.png "Mensagem de carregamento")

## Atualizações de memória

* Habilitada a exportação de snapshots e melhorado o desempenho de
  criação de snapshots. -
  [#7197](https://github.com/flutter/devtools/pull/7197),
  [#7439](https://github.com/flutter/devtools/pull/7439),
  [#7449](https://github.com/flutter/devtools/pull/7449)

    ![Exportar snapshot](/tools/devtools/release-notes/images-2.34.1/7197-export.png "Exportar snapshot")

* Corrigidas falhas durante a desconexão no rastreamento. -
  [#7440](https://github.com/flutter/devtools/pull/7440)

* Feito o filtro de classe ser compartilhado entre os painéis
  `Profile Memory` e `Diff Snapshots`. -
  [#7462](https://github.com/flutter/devtools/pull/7462)

## Atualizações do Network profiler

* Melhor desempenho do Network profiler. -
  [#7266](https://github.com/flutter/devtools/pull/7266)
* Corrigido um bug em que as solicitações pendentes selecionadas não
  atualizavam a guia após a atualização. -
  [#7266](https://github.com/flutter/devtools/pull/7266)
* Corrigido o visualizador JSON para que strings multilinhas sejam
  visíveis em sua linha e por meio de uma dica de ferramenta. -
  [#7389](https://github.com/flutter/devtools/pull/7389)
* Corrigido o JsonViewer onde todas as seções expandidas fechavam
  repentinamente. [#7367](https://github.com/flutter/devtools/pull/7367)

## Atualizações da ferramenta Deep Links

* Preenchimento automático de uma lista de projetos Flutter a partir do
  IDE conectado. - [#7415](https://github.com/flutter/devtools/pull/7415),
  [#7431](https://github.com/flutter/devtools/pull/7431)

## Histórico completo de commits

Para encontrar uma lista completa das alterações nesta versão, consulte o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.34.1).
