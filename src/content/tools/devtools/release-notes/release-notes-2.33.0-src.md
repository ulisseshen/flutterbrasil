# Notas de lançamento do DevTools 2.33.0

A versão 2.33.0 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre o
DevTools, confira a [visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Melhoria da usabilidade geral, tornando a UI do DevTools mais densa. Isso
  melhora significativamente a experiência do usuário ao usar o DevTools
  incorporado em um IDE. - [#7030](https://github.com/flutter/devtools/pull/7030)
* Remoção da configuração "Modo denso". - [#7086](https://github.com/flutter/devtools/pull/7086)
* Adição de suporte para filtragem com expressões regulares nas
  páginas de Logging, Network e CPU profiler. - [#7027](https://github.com/flutter/devtools/pull/7027)
* Adição de uma interação com o servidor DevTools para obter o URI do DTD. -
  [#7054](https://github.com/flutter/devtools/pull/7054),
  [#7164](https://github.com/flutter/devtools/pull/7164)
* Habilitação da avaliação de expressões com escopo para a web,
  permitindo a avaliação de widgets inspecionados. -
  [#7144](https://github.com/flutter/devtools/pull/7144)
* Atualização da restrição `package:vm_service` para `^14.0.0`. -
  [#6953](https://github.com/flutter/devtools/pull/6953)
* Integração do DevTools ao [`package:unified_analytics`](https://pub.dev/packages/unified_analytics)
  para registro de telemetria unificado em todas as ferramentas Flutter e Dart.
  - [#7084](https://github.com/flutter/devtools/pull/7084)

## Atualizações do Debugger

* Correção de um erro de deslocamento por um que fazia com que os hits do
  profiler fossem renderizados nas linhas erradas. -
  [#7178](https://github.com/flutter/devtools/pull/7178)
* Melhoria do contraste dos números de linha ao exibir hits de cobertura
  de código no modo escuro. - [#7178](https://github.com/flutter/devtools/pull/7178)
* Melhoria do contraste dos detalhes de profiling ao exibir hits do profiler no
  modo escuro. - [#7178](https://github.com/flutter/devtools/pull/7178)
* Correção do realce de sintaxe para comentários quando o arquivo
  de origem usa finais de linha `\r\n` [#7190](https://github.com/flutter/devtools/pull/7190)
* Restabelecimento dos breakpoints após um hot-restart. -
  [#7205](https://github.com/flutter/devtools/pull/7205)

## Atualizações da barra lateral do VS Code

* Não exibir as notas de lançamento do DevTools na barra lateral do Flutter. -
  [#7166](https://github.com/flutter/devtools/pull/7166)

## Atualizações da extensão DevTools

* Adição de suporte para conexão com o Dart Tooling Daemon a partir do
  ambiente DevTools simulado. - [#7133](https://github.com/flutter/devtools/pull/7133)
* Adição de botões de ajuda aos campos de texto de conexão do VM Service e DTD
  no ambiente DevTools simulado. - [#7133](https://github.com/flutter/devtools/pull/7133)
* Correção de um problema com a não detecção de extensões para arquivos
  de teste em subdiretórios. - [#7174](https://github.com/flutter/devtools/pull/7174)
* Adição de um exemplo de criação de uma extensão para um pacote Dart puro.
  - [#7196](https://github.com/flutter/devtools/pull/7196)
* Atualização do `README.md` e `example/README.md` com
  documentação mais completa. - [#7237](https://github.com/flutter/devtools/pull/7237),
  [#7261](https://github.com/flutter/devtools/pull/7261)
* Adição de um comando `devtools_extensions validate` para
  validar os requisitos da extensão durante o desenvolvimento. -
  [#7257](https://github.com/flutter/devtools/pull/7257)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.33.0).
