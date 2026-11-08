---
ia-translate: true
title: Notas de versão do DevTools 2.38.0
shortTitle: Notas de versão 2.38.0
breadcrumb: 2.38.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.38.0.
showToc: false
---

A versão 2.38.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações de Performance

* Renomeadas as configurações "Track" builds, paints e layouts para "Trace"
  builds, paints e layouts. - [#8084](https://github.com/flutter/devtools/pull/8084)
* Renomeada a configuração "Track widget build counts" para "Count widget builds". - [#8084](https://github.com/flutter/devtools/pull/8084)

## Atualizações do Debugger

* Adicionada recomendação para debugar código de uma IDE, com links para instruções da IDE. - [#8085](https://github.com/flutter/devtools/pull/8085)

## Atualizações do Network profiler

* Adicionado suporte para exportar requisições de rede como um arquivo HAR (obrigado a @hrajwade96!). - [#7970](https://github.com/flutter/devtools/pull/7970)

## Atualizações de DevTools Extension

* Corrigido um problema onde extensões não carregavam com o tema apropriado quando
  incorporadas em uma IDE. - [#8034](https://github.com/flutter/devtools/pull/8034)
* Adicionada uma API para copiar texto para a área de transferência por proxy do app web DevTools pai, que tem
  workarounds para problemas de cópia quando incorporado dentro de uma IDE. - [#8130](https://github.com/flutter/devtools/pull/8130)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.38.0).
