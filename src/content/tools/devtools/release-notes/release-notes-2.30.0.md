---
ia-translate: true
title: Notas de versão do DevTools 2.30.0
shortTitle: Notas de versão 2.30.0
breadcrumb: 2.30.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.30.0.
showToc: false
---

A versão 2.30.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações de Performance

* Adicionado um indicador do motor de renderização ao gráfico Flutter Frames. -
  [#6771](https://github.com/flutter/devtools/pull/6771)

  ![Flutter rendering engine text](/assets/images/docs/tools/devtools/release-notes/images-2.30.0/flutter_frames_engine_text.png "Text describing the current flutter rendering engine")

* Melhoradas mensagens quando não temos dados de análise disponíveis para um
  frame Flutter. - [#6768](https://github.com/flutter/devtools/pull/6768)

## Atualizações do VS Code Sidebar

* A Flutter Sidebar fornecida ao VS Code agora tem a capacidade de habilitar novas
  plataformas se um dispositivo está disponível para uma plataforma que não está habilitada para
  o projeto atual. Isso também requer uma atualização correspondente da extensão Dart para
  VS Code aparecer. - [#6688](https://github.com/flutter/devtools/pull/6688)

* O menu DevTools na sidebar agora tem uma entrada "Open in Browser"
  que abre DevTools em uma janela externa do navegador mesmo quando as configurações do VS Code
  estão definidas para normalmente usar DevTools incorporado. - [#6736](https://github.com/flutter/devtools/pull/6736)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.30.0).
