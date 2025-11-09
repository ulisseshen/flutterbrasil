---
ia-translate: true
title: Notas de lançamento do DevTools 2.48.0
shortTitle: Notas de lançamento 2.48.0
breadcrumb: 2.48.0
description: Notas de lançamento da versão 2.48.0 do Dart e Flutter DevTools.
showToc: false
---

A versão 2.48.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações do Network profiler

* Corrigido o log de rede após um hot restart. -
  [#9271](https://github.com/flutter/devtools/pull/9271).

## Atualizações de Logging

* Iniciada a exibição de eventos relacionados a timers na visualização de Logging. -
  [#9238](https://github.com/flutter/devtools/pull/9238).

## Atualizações do modo de desenvolvedor avançado

* Adicionada uma aba Queued Microtasks à tela VM Tools, que permite ao usuário
  ver detalhes sobre as microtasks agendadas na fila de microtasks de um isolate.
  Esta aba atualmente só aparece quando o DevTools está conectado a um app Flutter ou
  Dart iniciado com `--profile-microtasks`. -
  [#9239](https://github.com/flutter/devtools/pull/9239).

## Histórico completo de commits

Para encontrar uma lista completa de mudanças neste lançamento, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.48.0).
