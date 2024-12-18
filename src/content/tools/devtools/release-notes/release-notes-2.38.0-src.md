# Notas de lançamento do DevTools 2.38.0

A versão 2.38.0 do Dart e Flutter DevTools inclui as seguintes
mudanças, entre outras melhorias gerais. Para saber mais sobre o
DevTools, consulte a [visão geral do DevTools](/tools/devtools/overview).

## Atualizações de Performance

* Renomeou as configurações "Track" builds, paints e layouts para
"Trace" builds, paints e layouts. - [#8084](https://github.com/flutter/devtools/pull/8084)
* Renomeou a configuração "Track widget build counts" para "Count
widget builds". - [#8084](https://github.com/flutter/devtools/pull/8084)

## Atualizações do Debugger

* Adicionada recomendação para depurar o código a partir de uma IDE,
com links para as instruções da IDE. - [#8085](https://github.com/flutter/devtools/pull/8085)

## Atualizações do Network profiler

* Adicionado suporte para exportar requisições de rede como um arquivo
HAR (obrigado @hrajwade96!). - [#7970](https://github.com/flutter/devtools/pull/7970)

## Atualizações da Extensão DevTools

* Corrigido um problema em que as extensões não carregavam com o tema
adequado quando incorporadas em uma IDE. - [#8034](https://github.com/flutter/devtools/pull/8034)
* Adicionada uma API para copiar texto para a área de transferência
por meio do proxy do aplicativo web pai DevTools, que tem soluções
alternativas para problemas de cópia quando incorporado em uma IDE. -
[#8130](https://github.com/flutter/devtools/pull/8130)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão,
consulte o [log do git do DevTools](https://github.com/flutter/devtools/tree/v2.38.0).
