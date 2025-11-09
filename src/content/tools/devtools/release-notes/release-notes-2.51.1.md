---
ia-translate: true
title: Notas de lançamento do DevTools 2.51.1
shortTitle: Notas de lançamento 2.51.1
breadcrumb: 2.51.1
showToc: false
---

A versão 2.51.1 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

- Usuários do canal beta do Flutter foram incluídos no experimento DevTools-on-Wasm.
  Todos os outros usuários ainda podem habilitar o DevTools compilado em Wasm no diálogo
  de configurações. - [#9455](https://github.com/flutter/devtools/pull/9455)
- Adicionada uma barra de rolagem horizontal às tabelas de dados para auxiliar na navegação. -
  [#9482](https://github.com/flutter/devtools/pull/9482)
- Tornado possível redimensionar colunas de tabelas de dados arrastando os separadores de cabeçalho. -
  [#9485](https://github.com/flutter/devtools/pull/9485)

## Atualizações do Inspector

- Corrigido um problema onde selecionar um widget com o Inspector abriria o
  arquivo de definição do widget em vez do arquivo de projeto do usuário. -
  [#176530](https://github.com/flutter/flutter/pull/176530)

## Atualizações do Network profiler

- Corrigida a disposição do badge "error count" no nome da aba. -
  [#9470](https://github.com/flutter/devtools/pull/9470)
- Corrigida a exibição de "Response Headers" e "Request Headers" quando não há
  headers. - [#9492](https://github.com/flutter/devtools/pull/9492)
- Adicionado um banner para indicar claramente quando o DevTools não está registrando requisições
  de rede. - [#9495](https://github.com/flutter/devtools/pull/9495)

## Atualizações do VS Code

- Corrigido problema que impedia que atalhos como `Cmd`+`C` e `Cmd`+`V` funcionassem quando o DevTools estava
  embutido dentro do VS Code no macOS. -
  [#9472](https://github.com/flutter/devtools/pull/9472)

## Histórico completo de commits

Para encontrar uma lista completa de mudanças neste lançamento, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.51.1).
