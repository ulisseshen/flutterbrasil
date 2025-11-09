---
ia-translate: true
title: Notas de versão do DevTools 2.44.0
shortTitle: Notas de versão 2.44.0
breadcrumb: 2.44.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.44.0.
showToc: false
---

A versão 2.44.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Corrigidos vários vazamentos de memória e problemas de ciclo de vida. -
  [#8901](https://github.com/flutter/devtools/pull/8901),
  [#8902](https://github.com/flutter/devtools/pull/8902),
  [#8907](https://github.com/flutter/devtools/pull/8907),
  [#8917](https://github.com/flutter/devtools/pull/8917),
  [#8932](https://github.com/flutter/devtools/pull/8932),
  [#8933](https://github.com/flutter/devtools/pull/8933),
  [#8934](https://github.com/flutter/devtools/pull/8934),
  [#8935](https://github.com/flutter/devtools/pull/8935),
  [#8937](https://github.com/flutter/devtools/pull/8937),
  [#8953](https://github.com/flutter/devtools/pull/8953),
  [#8969](https://github.com/flutter/devtools/pull/8969),
  [#8970](https://github.com/flutter/devtools/pull/8970),
  [#8975](https://github.com/flutter/devtools/pull/8975)

## Atualizações do CPU profiler

* Melhorado o tempo de carregamento e uso de memória de perfis de CPU.
  * [#8892](https://github.com/flutter/devtools/pull/8892)
  * [#8878](https://github.com/flutter/devtools/pull/8878)
  * [#8839](https://github.com/flutter/devtools/pull/8839)
* Corrigidos cálculos de duração incorretos quando há tempo durante o qual nenhuma
  amostra foi coletada - [#8941](https://github.com/flutter/devtools/pull/8941).

## Atualizações de Memory

* Alterada a ferramenta de snapshot de heap de memória para que referências sejam
  incluídas em snapshots por padrão. -
  [#8899](https://github.com/flutter/devtools/pull/8899)

## Atualizações do Debugger

* Adicionado um tooltip para descrever o dropdown de modo de exceção. -
  [#8849](https://github.com/flutter/devtools/pull/8849)
* Atualizado syntax highlighting com suporte para separadores de dígito
  e melhorado tratamento de comentários e interpolação de string. -
  [#8861](https://github.com/flutter/devtools/pull/8861)
* Atualizada dependência `string_scanner` para evitar alguns problemas de syntax highlighting
  quando o código-fonte contém `\r\n` em certas posições no Windows. -
  [#8904](https://github.com/flutter/devtools/pull/8904)
* Adicionada quebra de linha suave no console do debugger.
  [#8855](https://github.com/flutter/devtools/pull/8855).

## Atualizações do Network profiler

* Adicionado suporte offline para a tela de network (obrigado a @hrajwade96!) -
  [#8332](https://github.com/flutter/devtools/pull/8332)

  ![Network profiler controls](/assets/images/docs/tools/devtools/release-notes/images-2.44.0/network_controls.png "Network profiler controls")

  ![Network profiler open / save button](/assets/images/docs/tools/devtools/release-notes/images-2.44.0/network_open_save_button.png "Network profiler open / save button")

* Alterado o estilo do menu de contexto para ser consistente com outras telas
  [#8859](https://github.com/flutter/devtools/pull/8859).

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.44.0).
