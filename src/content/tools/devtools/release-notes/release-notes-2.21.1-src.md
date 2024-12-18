# Notas de lançamento do DevTools 2.21.1

A versão 2.21.1 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações de desempenho

* Substituir o visualizador de rastreamento da linha do tempo do DevTools pelo visualizador de rastreamento [Perfetto](https://perfetto.dev/) - [#5142](https://github.com/flutter/devtools/pull/5142)

  ![visualizador de rastreamento perfetto](/tools/devtools/release-notes/images-2.21.1/image1.png "perfetto_trace_viewer")

* Corrigir vários problemas ao carregar um snapshot de desempenho no DevTools - [#5048](https://github.com/flutter/devtools/pull/5048), [#4929](https://github.com/flutter/devtools/pull/4929)
* Polimento e limpeza da IU - [#4889](https://github.com/flutter/devtools/pull/4889)

## Atualizações de memória

* Melhorar a usabilidade da diferenciação de snapshots - [#5015](https://github.com/flutter/devtools/pull/5015)
* Polimento e limpeza da IU - [#4855](https://github.com/flutter/devtools/pull/4855)
* Classes de código de cores com base em onde são definidas (SDK, seu pacote, dependências, etc.) - [#5030](https://github.com/flutter/devtools/pull/5030)
* Corrigir problema de gerenciamento de estado para rastreamento - [#5062](https://github.com/flutter/devtools/pull/5062)
* Melhorar o desempenho da captura de um heap snapshot - [#5134](https://github.com/flutter/devtools/pull/5134)
* Desativar o recurso de importação/exportação quebrado - [#5135](https://github.com/flutter/devtools/pull/5135)

## Atualizações do depurador

* Adicionado suporte para visualização de hits do profiler no visualizador de scripts do depurador - [#4831](https://github.com/flutter/devtools/pull/4831)
* Adicionado suporte para inspeção de registros - [#5084](https://github.com/flutter/devtools/pull/5084)

## Atualizações gerais

* Corrigir vários problemas na coloração de sintaxe que coloririam incorretamente nomes de variáveis que contêm palavras reservadas e deixariam as cláusulas `extends`/`implements` sem cor para algumas classes - [#4948](https://github.com/flutter/devtools/pull/4948)
* Corrigir um problema no Safari e em outros navegadores que não oferecem suporte a lookbehind negativo RegExp, que impedia o carregamento do DevTools - [#4938](https://github.com/flutter/devtools/pull/4938)
* Corrigir um problema que impedia o DevTools de se conectar ao servidor de back-end que desabilitava algumas funcionalidades - [#5016](https://github.com/flutter/devtools/pull/5016)
* Adicionar um link para o [guia de contribuição](https://github.com/flutter/devtools/blob/master/CONTRIBUTING.md) do DevTools ao menu Sobre e corrigir o link do Discord - [#4926](https://github.com/flutter/devtools/pull/4926)
* Corrigir cores conflitantes no tema claro - [#5067](https://github.com/flutter/devtools/pull/5067)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, consulte [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.20.0...v2.21.1).
