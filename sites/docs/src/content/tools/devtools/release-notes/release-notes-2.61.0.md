---
ia-translate: true
title: Notas de lançamento do DevTools 2.61.0
shortTitle: Notas de lançamento 2.61.0
breadcrumb: 2.61.0
showToc: false
---

A versão 2.61.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais {:#general-updates}

* Corrigido texto ilegível no painel de notas de lançamento, em que os blockquotes eram
  desenhados com um fundo azul-claro fixo no tema escuro.
  [#9957](https://github.com/flutter/devtools/pull/9957)
* Adicionado suporte a proxy da conexão com o serviço da VM por meio de um `MessagePort`
  usando `?uri=messageport:<origin>`.
  [#9964](https://github.com/flutter/devtools/pull/9964)

## Atualizações do Inspector {:#inspector-updates}

* Adicionado o caminho do arquivo-fonte do widget ao painel de detalhes do Inspector
  (`filename.dart:line:column`), igualando o comportamento do Inspector legado.
  [#9972](https://github.com/flutter/devtools/pull/9972),
  [#9922](https://github.com/flutter/devtools/issues/9922)

## Atualizações de desempenho {:#performance-updates}

* Corrigido um bug em que o gráfico de frames do Flutter podia ficar travado após
  sair da tela de Performance e voltar para ela.
  [#9960](https://github.com/flutter/devtools/pull/9960)
* Adicionada uma mensagem no painel de Performance para indicar quando o rastreamento
  de rebuilds de widgets não está disponível porque o app está rodando em modo profile.
  [#9755](https://github.com/flutter/devtools/pull/9755)

## Atualizações do CPU profiler {:#cpu-profiler-updates}

* Corrigido um bug em que redimensionar o flame chart da CPU alterava os valores de
  tempo exibidos no topo do gráfico.
  [#9915](https://github.com/flutter/devtools/pull/9915)

## Atualizações de memória {:#memory-updates}

* Adicionada a possibilidade de fixar classes no topo da tabela do Profile Memory.
  [#8898](https://github.com/flutter/devtools/issues/8898)

## Atualizações do debugger {:#debugger-updates}

* Evitada a coleta de lixo de valores enquanto eles estavam sendo avaliados.
  [#9885](https://github.com/flutter/devtools/pull/9885)
* Atualizada a gramática de realce de sintaxe do Dart para a versão mais recente
  [#9920](https://github.com/flutter/devtools/pull/9920)
* Corrigido um bug no parser da gramática TextMate que podia fazer com que o código
  após comentários fosse classificado como comentário.
  [#9921](https://github.com/flutter/devtools/pull/9921)
* Corrigido um estouro nos controles de depuração quando a tela Debugger está estreita,
  como quando o DevTools está embutido em um painel lateral da IDE. Agora os controles
  rolam horizontalmente em vez de estourar.
  [#9949](https://github.com/flutter/devtools/pull/9949)

## Atualizações do Network profiler {:#network-profiler-updates}

* Corrigido o "Copy as cURL" que omitia cabeçalhos e corpo de requisições com falha
  ou com timeout. [#9963](https://github.com/flutter/devtools/pull/9963)
* Adicionado suporte a WebSocket no Network profiler, incluindo detalhes da conexão
  WebSocket, eventos do ciclo de vida, inspeção em nível de frame e informações de
  tempo da conexão. [#9968](https://github.com/flutter/devtools/pull/9968)
* Corrigido um problema em que a aba Network deixava de capturar requisições HTTP
  após um hot restart.
  [#9856](https://github.com/flutter/devtools/pull/9856)
* Corrigido um problema em que a aba Network deixava de capturar novas requisições HTTP
  após pressionar Clear durante a gravação.
  [#9856](https://github.com/flutter/devtools/pull/9856)

## Atualizações de logging {:#logging-updates}

* Corrigidas as unidades de tempo e a natureza cumulativa dos eventos de GC.
  [#9890](https://github.com/flutter/devtools/pull/9890)
* Corrigido um bug em que mensagens longas de log do `dart:developer` perdiam a
  visualização estruturada de Details.
  [#10011](https://github.com/flutter/devtools/pull/10011)

## Atualizações da ferramenta de deep links {:#deep-links-tool-updates}

* Adicionado um link "Watch tutorial" na barra de status que aponta para o
  [vídeo tutorial de deep links](https://youtu.be/d7sZL6h1Elw).
  [#9925](https://github.com/flutter/devtools/pull/9925)
* Validados os parâmetros de opções de build e exibidos erros de configuração de
  universal links do iOS na ferramenta de Deep Links.
  [#10022](https://github.com/flutter/devtools/pull/10022)

## Atualizações da extensão do DevTools {:#devtools-extension-updates}

* Ocultado o botão do menu de extensões do DevTools no modo embutido de tela única
  (`EmbedMode.embedOne`) em telas padrão.
  [#8507](https://github.com/flutter/devtools/issues/8507)
* Adicionado sandboxing de iframe para as extensões do DevTools embutidas, para garantir
  o isolamento de origem. [#9967](https://github.com/flutter/devtools/pull/9967)
* Melhorado o isolamento das extensões do DevTools ao rastrear o nome do pacote que
  fornece a extensão para ativação, deduplicação e carregamento de assets.
  [#9981](https://github.com/flutter/devtools/pull/9981)

## Histórico completo de commits {:#full-commit-history}

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.61.0).
