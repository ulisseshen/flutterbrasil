---
ia-translate: true
title: Notas de lançamento do DevTools 2.62.0
shortTitle: Notas de lançamento 2.62.0
breadcrumb: 2.62.0
showToc: false
---

A versão 2.62.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais {:#general-updates}

* Removida a tela legada do Provider, que era um placeholder para direcionar os usuários
para a extensão de DevTools do `package:provider`. [#10046](https://github.com/flutter/devtools/pull/10046)
* Adicionadas notificações de erro para o usuário ao importar arquivos de dados que estão
  sem campos obrigatórios ou sem dados para a tela.
  [#10005](https://github.com/flutter/devtools/pull/10005)

## Atualizações de desempenho {:#performance-updates}

* Reduzida a memória usada ao salvar dados de Performance para visualização offline, e
  os arquivos salvos ficaram menores. Arquivos salvos com esta versão não podem ser
  abertos em versões antigas do DevTools. Arquivos salvos com versões antigas ainda
  podem ser abertos.
  [#10034](https://github.com/flutter/devtools/pull/10034),
  [#10010](https://github.com/flutter/devtools/issues/10010)
* Corrigido um problema em que a importação de dados de performance com frames do Flutter,
  mas sem trace de timeline, tratava os dados como vazios.
  [#10005](https://github.com/flutter/devtools/pull/10005)

## Atualizações do debugger {:#debugger-updates}

* Melhorado o realce de sintaxe de blocos de código cercados que usam mais de três
  crases.
  [#10021](https://github.com/flutter/devtools/pull/10021)

## Histórico completo de commits {:#full-commit-history}

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.62.0).
