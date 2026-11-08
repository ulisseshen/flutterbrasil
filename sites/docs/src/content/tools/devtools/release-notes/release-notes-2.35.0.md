---
ia-translate: true
title: Notas de versão do DevTools 2.35.0
shortTitle: Notas de versão 2.35.0
breadcrumb: 2.35.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.35.0.
showToc: false
---

A versão 2.35.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Alterado para um único botão para iniciar e parar
  gravação na tela Network e tela CPU profiler. - [#7573](https://github.com/flutter/devtools/pull/7573)

  ![A screen shot of the CPU profiler tab, with the new recording button.](/assets/images/docs/tools/devtools/release-notes/images-2.35.0/profiler_recording.png)
  ![A screen shot of the network tab, with the new recording button.](/assets/images/docs/tools/devtools/release-notes/images-2.35.0/network_recording.png)

## Atualizações do Inspector

* Adicionada uma preferência para a visualização padrão do inspector - [#6949](https://github.com/flutter/devtools/pull/6949)

## Atualizações de Memory

* Substituído tamanho total por tamanho alcançável na lista de snapshots. - [#7493](https://github.com/flutter/devtools/pull/7493)

## Atualizações do Debugger

* Durante um hot-restart, `pause_isolates_on_start` e apenas
  `resume` o app uma vez que breakpoints estejam definidos. - [#7234](https://github.com/flutter/devtools/pull/7234)

## Atualizações do Network profiler

* Adicionada seleção de texto no visualizador de texto para requisições e respostas. - [#7596](https://github.com/flutter/devtools/pull/7596)
* Adicionada uma experiência de cópia JSON ao visualizador JSON. - [#7596](https://github.com/flutter/devtools/pull/7596)

  ![The new JSON copy experience in the JSON viewer](/assets/images/docs/tools/devtools/release-notes/images-2.35.0/json_viewer_copy.png)

* Corrigido um bug onde parar e iniciar gravação de rede listava requisições que
  aconteceram enquanto não estava gravando. - [#7626](https://github.com/flutter/devtools/pull/7626)

## Atualizações da ferramenta Deep links

* Melhorado layout para telas estreitas. - [#7524](https://github.com/flutter/devtools/pull/7524)
* Adicionado tratamento de erro para schemes e domínios ausentes - [#7559](https://github.com/flutter/devtools/pull/7559)

## Atualizações do VS Code Sidebar

* Adicionada uma seção DevTools com uma lista de ferramentas e extensões que
  estão disponíveis sem uma sessão de debug. -
  [#7598](https://github.com/flutter/devtools/pull/7598), [#7604](https://github.com/flutter/devtools/pull/7604)

## Atualizações de DevTools Extension

* Suporte para extensões DevTools que não requerem um app em execução, e
  detectá-las do workspace IDE do usuário. - [#7612](https://github.com/flutter/devtools/pull/7612)
* Descontinuar o campo `DevToolsExtension.requiresRunningApplication` em
  favor do novo campo opcional `requiresConnection` que
  pode ser adicionado ao arquivo `config.yaml` de uma extensão. -
  [#7611](https://github.com/flutter/devtools/pull/7611), [#7602](https://github.com/flutter/devtools/pull/7602)
* Detectar extensões para todos os tipos de alvos de execução em um pacote. -
  [#7533](https://github.com/flutter/devtools/pull/7533), [#7535](https://github.com/flutter/devtools/pull/7535)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.35.0).
