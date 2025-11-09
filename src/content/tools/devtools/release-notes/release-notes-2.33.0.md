---
ia-translate: true
title: Notas de versão do DevTools 2.33.0
shortTitle: Notas de versão 2.33.0
breadcrumb: 2.33.0
description: Notas de versão para o Dart e Flutter DevTools versão 2.33.0.
showToc: false
---

A versão 2.33.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Melhorada usabilidade geral tornando a UI do DevTools mais densa.
  Isso melhora significativamente a experiência do usuário ao usar
  DevTools incorporado em uma IDE. - [#7030](https://github.com/flutter/devtools/pull/7030)
* Removida a configuração "Dense mode". - [#7086](https://github.com/flutter/devtools/pull/7086)
* Adicionado suporte para filtragem com expressões regulares nas
  páginas Logging, Network e CPU profiler. - [#7027](https://github.com/flutter/devtools/pull/7027)
* Adicionada uma interação de servidor DevTools para obter a URI DTD. - [#7054](https://github.com/flutter/devtools/pull/7054), [#7164](https://github.com/flutter/devtools/pull/7164)
* Habilitada avaliação de expressão com escopo para a web,
  permitindo avaliação de widgets inspecionados. - [#7144](https://github.com/flutter/devtools/pull/7144)
* Atualizada restrição de `package:vm_service` para `^14.0.0`. - [#6953](https://github.com/flutter/devtools/pull/6953)
* Integração do DevTools ao [`package:unified_analytics`](https://pub.dev/packages/unified_analytics) para
  logging de telemetria unificado entre ferramentas Flutter e Dart. - [#7084](https://github.com/flutter/devtools/pull/7084)

## Atualizações do Debugger

* Corrigido erro de off by one causando hits do profiler serem
  renderizados nas linhas erradas. - [#7178](https://github.com/flutter/devtools/pull/7178)
* Melhorado contraste de números de linha ao
  exibir hits de cobertura de código no modo escuro. - [#7178](https://github.com/flutter/devtools/pull/7178)
* Melhorado contraste de detalhes de profiling ao
  exibir hits do profiler no modo escuro. - [#7178](https://github.com/flutter/devtools/pull/7178)
* Corrigido syntax highlighting para comentários quando
  o arquivo fonte usa finais de linha `\r\n` [#7190](https://github.com/flutter/devtools/pull/7190)
* Reestabelecer breakpoints após um hot-restart. - [#7205](https://github.com/flutter/devtools/pull/7205)

## Atualizações do VS Code Sidebar

* Não mostrar notas de versão do DevTools na sidebar do Flutter. - [#7166](https://github.com/flutter/devtools/pull/7166)

## Atualizações de DevTools Extension

* Adicionado suporte para conectar ao Dart Tooling Daemon do
  ambiente DevTools simulado. - [#7133](https://github.com/flutter/devtools/pull/7133)
* Adicionados botões de ajuda aos campos de texto de conexão VM Service e DTD no
  ambiente DevTools simulado. - [#7133](https://github.com/flutter/devtools/pull/7133)
* Corrigido um problema com não detectar extensões para
  arquivos de teste em subdiretórios. - [#7174](https://github.com/flutter/devtools/pull/7174)
* Adicionado um exemplo de criação de uma extensão para um pacote Dart puro. - [#7196](https://github.com/flutter/devtools/pull/7196)
* Atualizados `README.md` e `example/README.md` com
  documentação mais completa. - [#7237](https://github.com/flutter/devtools/pull/7237), [#7261](https://github.com/flutter/devtools/pull/7261)
* Adicionado um comando `devtools_extensions validate` para
  validar requisitos de extensão durante o desenvolvimento. - [#7257](https://github.com/flutter/devtools/pull/7257)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.33.0).
