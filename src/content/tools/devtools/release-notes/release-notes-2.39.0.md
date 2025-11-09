---
ia-translate: true
title: Notas de versão do DevTools 2.39.0
shortTitle: Notas de versão 2.39.0
breadcrumb: 2.39.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.39.0.
showToc: false
---

A versão 2.39.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Alteradas colunas de tabela para serem ordenáveis por padrão. - [#8175](https://github.com/flutter/devtools/pull/8175)
* Atualizados ícones de tela do DevTools para corresponder ao usado nas IDEs suportadas pelo Flutter. - [#8181](https://github.com/flutter/devtools/pull/8181)

## Atualizações de Memory

* Habilitada análise offline de snapshots de memória, além de suporte para visualizar dados de memória
  quando um app desconecta. Por exemplo, isso pode acontecer quando um app inesperadamente
  trava ou atinge um problema de falta de memória. - [#7843](https://github.com/flutter/devtools/pull/7843),
  [#8093](https://github.com/flutter/devtools/pull/8093),
  [#8096](https://github.com/flutter/devtools/pull/8096)

* Corrigido problema onde o gráfico de memória poderia causar ao aplicativo conectado atingir uma
  exceção de falta de memória ao alocar objetos grandes e de curta duração repetidamente. - [#8209](https://github.com/flutter/devtools/pull/8209)

## Atualizações da ferramenta App size

* Adicionado refinamento de UI às visualizações de importação de arquivo. [#8232](https://github.com/flutter/devtools/pull/8232)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.39.0).
