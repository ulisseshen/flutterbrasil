---
ia-translate: true
title: Notas de lançamento do DevTools 2.60.0
shortTitle: Notas de lançamento 2.60.0
breadcrumb: 2.60.0
description: Notas de lançamento do Dart e Flutter DevTools versão 2.60.0.
showToc: false
---

A versão 2.60.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

- Corrigido um problema em que o DevTools podia ficar preso em um estado desconectado
  (por exemplo, depois que um Mac entra em suspensão) ao adicionar um botão manual
  "Reconnect" na tela de desconexão. -
  [#9838](https://github.com/flutter/devtools/issues/9838)
- Corrigidos vários vazamentos de memória. -
  [#9857](https://github.com/flutter/devtools/pull/9857)
- Corrigido um bug em que os resultados de busca destacados nas tabelas ficavam ilegíveis
  no modo escuro porque a cor de destaque tinha se tornado totalmente opaca. -
  [#9863](https://github.com/flutter/devtools/pull/9863)
- Rejeitados caminhos absolutos nas leituras de arquivos do servidor do DevTools, para que
  permaneçam dentro do diretório `~/.flutter-devtools/` e não possam resolver para
  arquivos arbitrários no disco. -
  [#9844](https://github.com/flutter/devtools/pull/9844)
- Validado o parâmetro `devtoolsOptionsUri` no handler de estado de ativação das extensões,
  que agora precisa ser um URI `file:` chamado `devtools_options.yaml`, impedindo que o
  servidor do DevTools grave em caminhos arbitrários. -
  [#9834](https://github.com/flutter/devtools/pull/9834)

## Atualizações do Inspector

- Corrigido um problema em que o contador do badge de erros do Inspector aumentava
  indevidamente ou desaparecia durante a navegação. -
  [#9524](https://github.com/flutter/devtools/issues/9524)

## Atualizações de desempenho

- Corrigido um bug em que a aba de funcionalidade selecionada não era restaurada
  ao carregar dados de Performance exportados. -
  [#9861](https://github.com/flutter/devtools/pull/9861)

## Atualizações do Network profiler

- Corrigido o campo de busca aba Network que ficava desabilitado após limpar todas
  as requisições, de modo que a consulta de busca agora pode ser editada a qualquer momento. -
  [#9855](https://github.com/flutter/devtools/pull/9855)

## Atualizações da ferramenta de deep links

- Validar deep links apenas quando conectado a um app Flutter. -
  [#8081](https://github.com/flutter/devtools/issues/8081)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.60.0).
