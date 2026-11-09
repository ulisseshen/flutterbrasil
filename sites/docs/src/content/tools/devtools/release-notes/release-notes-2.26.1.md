---
ia-translate: true
title: Notas de versão do DevTools 2.26.1
shortTitle: Notas de versão 2.26.1
breadcrumb: 2.26.1
description: Notas de versão para o Dart e Flutter DevTools versão 2.26.1.
showToc: false
---

A versão 2.26.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

- Adicionada uma nova tela "Home" no DevTools que mostra o diálogo "Connect"
  ou um resumo do seu app conectado, dependendo do
  status de conexão no DevTools.
  Fique de olho nesta tela para novos recursos interessantes no futuro.
  Esta mudança também habilita suporte para ferramentas estáticas
  (ferramentas que não requerem um app conectado) no DevTools -
  [#6010](https://github.com/flutter/devtools/pull/6010)

  ![home screen](/assets/images/docs/tools/devtools/release-notes/images-2.26.1/home_screen.png "DevTools home screen")

- Corrigidas notificações de overlay para que
  cubram a área que seu fundo bloqueia -
  [#5975](https://github.com/flutter/devtools/pull/5975)

## Atualizações de Memory

- Adicionado um menu de contexto para renomear ou deletar um heap snapshot da lista -
  [#5997](https://github.com/flutter/devtools/pull/5997)
- Avisados usuários quando logging HTTP pode estar afetando o consumo de memória de seu app -
  [#5998](https://github.com/flutter/devtools/pull/5998)

## Atualizações do Debugger

- Melhorias na seleção de texto e comportamento de cópia na
  visualização de código, console e janelas de variáveis -
  [#6020](https://github.com/flutter/devtools/pull/6020)

## Atualizações do Network profiler

- Adicionado um seletor para customizar o tipo de exibição
  de respostas text e json (obrigado a @hhacker1999!) -
  [#5816](https://github.com/flutter/devtools/pull/5816)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.25.0...v2.26.1).
