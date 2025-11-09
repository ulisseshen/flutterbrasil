---
ia-translate: true
title: Notas de versão do DevTools 2.21.1
shortTitle: Notas de versão 2.21.1
breadcrumb: 2.22.1
description: Notas de versão para o Dart e Flutter DevTools versão 2.21.1.
showToc: false
---

A versão 2.21.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações de Performance

* Substituído o visualizador de trace da timeline do DevTools pelo
  visualizador de trace [Perfetto](https://perfetto.dev/) -
  [#5142](https://github.com/flutter/devtools/pull/5142)

  ![perfetto trace viewer](/assets/images/docs/tools/devtools/release-notes/images-2.21.1/image1.png "perfetto_trace_viewer")

* Corrigidos vários problemas ao carregar um snapshot de Performance no DevTools -
  [#5048](https://github.com/flutter/devtools/pull/5048),
  [#4929](https://github.com/flutter/devtools/pull/4929)
* Refinamento e limpeza da UI - [#4889](https://github.com/flutter/devtools/pull/4889)

## Atualizações de Memory

* Melhorada a usabilidade da comparação de snapshots -
  [#5015](https://github.com/flutter/devtools/pull/5015)
* Refinamento e limpeza da UI -
  [#4855](https://github.com/flutter/devtools/pull/4855)
* Classes codificadas por cores com base em onde são definidas
  (SDK, seu pacote, dependências, etc.) -
  [#5030](https://github.com/flutter/devtools/pull/5030)
* Corrigido problema de gerenciamento de estado para tracing -
  [#5062](https://github.com/flutter/devtools/pull/5062)
* Melhorada a performance ao tirar um snapshot de heap -
  [#5134](https://github.com/flutter/devtools/pull/5134)
* Desativada funcionalidade quebrada de import/export -
  [#5135](https://github.com/flutter/devtools/pull/5135)

## Atualizações do Debugger

* Adicionado suporte para visualizar hits do profiler no
  visualizador de script do debugger -
  [#4831](https://github.com/flutter/devtools/pull/4831)
* Adicionado suporte para inspecionar records -
  [#5084](https://github.com/flutter/devtools/pull/5084)

## Atualizações gerais

* Corrigidos vários problemas no syntax highlighting que
  coloriam incorretamente nomes de variáveis contendo palavras reservadas e
  deixavam cláusulas `extends`/`implements` sem cor para algumas classes -
  [#4948](https://github.com/flutter/devtools/pull/4948)
* Corrigido um problema no Safari, e
  outros navegadores que não suportam RegExp negative lookbehind,
  que impedia o DevTools de carregar -
  [#4938](https://github.com/flutter/devtools/pull/4938)
* Corrigido um problema que impediria o DevTools de se conectar ao
  servidor backend que desabilitaria algumas funcionalidades -
  [#5016](https://github.com/flutter/devtools/pull/5016)
* Adicionado um link para o
  [guia de contribuição](https://github.com/flutter/devtools/blob/master/CONTRIBUTING.md)
  do DevTools ao menu About, e corrigido o link do Discord -
  [#4926](https://github.com/flutter/devtools/pull/4926)
* Corrigidas cores conflitantes no tema claro -
  [#5067](https://github.com/flutter/devtools/pull/5067)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.20.0...v2.21.1).
