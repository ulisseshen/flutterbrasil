---
ia-translate: true
title: Notas de lançamento do DevTools 2.58.0
shortTitle: Notas de lançamento 2.58.0
breadcrumb: 2.58.0
showToc: false
---

A versão 2.58.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações do Inspector {:#inspector-updates}

- Removida a opção de usar o inspector legado.
  [#9782](https://github.com/flutter/devtools/pull/9782)
- Corrigido um problema em que navegar pela árvore de widgets do Inspector com as teclas de seta não atualizava o widget selecionado no app Flutter conectado. [#9810](https://github.com/flutter/devtools/pull/9810)
- Corrigido um problema em que clicar em uma linha de widget após recolher uma subárvore com a seta para a esquerda fazia a subárvore ser expandida novamente de forma inesperada. [#9810](https://github.com/flutter/devtools/pull/9810)
- Corrigido um problema em que recolher a árvore de widgets do Inspector em uma única linha com a seta para a esquerda fazia um indicador de carregamento aparecer em vez de mostrar o nó raiz. [#9810](https://github.com/flutter/devtools/pull/9810)

## Atualizações de performance {:#performance-updates}

- Corrigido um problema em que "More Debug Options" mostrava opções como não selecionadas no modo profile, mesmo quando selecionadas. [#9813](https://github.com/flutter/devtools/issues/9813)

## Atualizações do Debugger {:#debugger-updates}

- Corrigido um problema em que valores de string longos na visualização de console/variáveis transbordavam e se sobrepunham a outros elementos. [#7112](https://github.com/flutter/devtools/issues/7112)

## Atualizações do Network profiler {:#network-profiler-updates}

- Adicionada uma coluna de tamanho de resposta na aba Network e exibido o tamanho da resposta na visão geral do inspetor de requisições.
  [#9744](https://github.com/flutter/devtools/pull/9744)

- Melhorada a classificação de status das requisições HTTP na aba Network, para distinguir melhor requisições canceladas, concluídas e em andamento (por exemplo, evitando casos em que requisições canceladas apareciam como pendentes). [#9683](https://github.com/flutter/devtools/pull/9683)

- Adicionada uma configuração de filtro para ocultar os dados de socket do HTTP profiler.
  [#9698](https://github.com/flutter/devtools/pull/9698)

## Atualizações de logging {:#logging-updates}

- Corrigido um problema em que mensagens de log contendo caracteres de nova linha eram divididas incorretamente em várias entradas separadas na tela de Logging. [#9757](https://github.com/flutter/devtools/pull/9757)

## Atualizações da ferramenta Deep links {:#deep-links-tool-updates}

- Pluralizados "domain" e "path" nos títulos das notificações de resumo de validação quando há vários erros. [#9790](https://github.com/flutter/devtools/pull/9790)

## Histórico completo de commits {:#full-commit-history}

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.58.0).
