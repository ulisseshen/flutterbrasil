---
ia-translate: true
title: Notas de versão do DevTools 2.11.2
shortTitle: Notas de versão 2.11.2
breadcrumb: 2.11.2
description: Notas de versão para o Dart e Flutter DevTools versão 2.11.2.
showToc: false
---

A versão 2.11.2 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações gerais

* Esta versão incluiu muita limpeza e redução de débito técnico.

## Atualizações do CPU profiler

* Adicionado o número da linha de origem aos uris de arquivo nos perfis de CPU -
  [#3718](https://github.com/flutter/devtools/pull/3718)

  ![cpu stack frame line numbers](/assets/images/docs/tools/devtools/release-notes/images-2.11.2/image1.png "cpu stack frame line numbers")

## Atualizações do Debugger

* Melhorias de UX no abridor de arquivos, incluindo suporte para clicar
  no nome do arquivo de origem para abrir a janela de busca de arquivo -
  [#3612](https://github.com/flutter/devtools/pull/3612),
  [#3758](https://github.com/flutter/devtools/pull/3758)
* Adicionado suporte para rolagem automática do File Explorer para o arquivo selecionado -
  [#3786](https://github.com/flutter/devtools/pull/3786),
  [#3794](https://github.com/flutter/devtools/pull/3794)

  ![debugger file explorer scrolling](/assets/images/docs/tools/devtools/release-notes/images-2.11.2/image2.gif "debugger file explorer scrolling")

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.10.0...v2.11.2).
