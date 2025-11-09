---
ia-translate: true
title: Notas de lançamento do DevTools 2.9.1
shortTitle: Notas de lançamento 2.9.1
breadcrumb: 2.9.1
description: Notas de lançamento da versão 2.9.1 do Dart e Flutter DevTools.
showToc: false
---

A versão 2.9.1 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações do Debugger

* Melhorado o suporte para inspecionar listas e mapas grandes no
  painel de variáveis do Debugger - [#3497](https://github.com/flutter/devtools/pull/3497)

  ![Inspection before](/assets/images/docs/tools/devtools/release-notes/images-2.9.1/image1.png "Inspection before")

  ![Inspection after](/assets/images/docs/tools/devtools/release-notes/images-2.9.1/image2.png "Inspection after")

* Adicionado suporte para selecionar objetos na visualização de outline do explorador de programa.
  Selecionar um objeto irá automaticamente rolar o código-fonte
  no debugger para o objeto selecionado -
  [#3480](https://github.com/flutter/devtools/pull/3480)

## Atualizações de Performance

* Corrigidos bugs com a busca na página de performance e melhorada a performance -
  [#3515](https://github.com/flutter/devtools/pull/3515)
* Adicionado um tooltip aprimorado para frames flutter -
  [#3493](https://github.com/flutter/devtools/pull/3493)

  ![Flutter frame tooltips](/assets/images/docs/tools/devtools/release-notes/images-2.9.1/image3.png "Flutter frame tooltips")

## Histórico completo de commits

Para encontrar uma lista completa de mudanças desde o lançamento anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.8.0...v2.9.1).
