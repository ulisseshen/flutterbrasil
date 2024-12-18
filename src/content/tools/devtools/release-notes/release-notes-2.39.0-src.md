# Notas de lançamento do DevTools 2.39.0

A versão 2.39.0 do Dart e Flutter DevTools
inclui as seguintes alterações, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Alteradas as colunas da tabela para serem classificáveis por padrão. - [#8175](https://github.com/flutter/devtools/pull/8175)
* Atualizados os ícones da tela do DevTools para corresponder ao que é usado nos IDEs suportados pelo Flutter. - [#8181](https://github.com/flutter/devtools/pull/8181)

## Atualizações de memória

* Habilitada a análise offline de snapshots de memória, bem como suporte para visualização de memória
dados quando um aplicativo se desconecta. Por exemplo, isso pode acontecer quando um aplicativo inesperadamente
falha ou atinge um problema de falta de memória. - [#7843](https://github.com/flutter/devtools/pull/7843),
[#8093](https://github.com/flutter/devtools/pull/8093),
[#8096](https://github.com/flutter/devtools/pull/8096)

* Corrigido o problema em que o gráfico de memória poderia fazer com que o aplicativo conectado atingisse uma
exceção de falta de memória ao alocar objetos grandes e de curta duração repetidamente. - [#8209](https://github.com/flutter/devtools/pull/8209)

## Atualizações da ferramenta de tamanho de aplicativo

* Adicionado polimento da interface do usuário às visualizações de importação de arquivos. [#8232](https://github.com/flutter/devtools/pull/8232)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.39.0).
