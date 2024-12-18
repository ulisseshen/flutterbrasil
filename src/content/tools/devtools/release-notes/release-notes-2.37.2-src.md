# Notas da versão do DevTools 2.37.2

A versão 2.37.2 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Mensagens aprimoradas quando uma tela não está disponível para a
  plataforma do aplicativo conectado. - [#7958](https://github.com/flutter/devtools/pull/7958)
* Corrigido um bug em que um spinner infinito era exibido ao
  desconectar o aplicativo. - [#7992](https://github.com/flutter/devtools/pull/7992)
* Corrigido um bug em que tentar reutilizar uma instância desconectada do DevTools
  falhava. - [#8009](https://github.com/flutter/devtools/pull/8009)

## Atualizações de desempenho

* Removeu o recurso "Raster Stats".
  Essa ferramenta não funcionava para o mecanismo de renderização Impeller e
  as informações que fornecia para o mecanismo de renderização SKIA eram
  muitas vezes enganosas e inviáveis. Os usuários devem seguir as
  orientações oficiais do Flutter para [Performance e otimização](/perf) ao
  depurar o desempenho de renderização de seus aplicativos Flutter. - [#7981](https://github.com/flutter/devtools/pull/7981).

## Atualizações do Network profiler

* Corrigido um problema em que as estatísticas de socket estavam sendo relatadas como web sockets. - [#8061](https://github.com/flutter/devtools/pull/8061)

    ![Network profiler exibindo corretamente as estatísticas de socket](/tools/devtools/release-notes/images-2.37.2/socket-profiling.png "Network profiler exibindo corretamente as estatísticas de socket")

* Adicionados parâmetros de consulta à visualização de detalhes da solicitação. - [#7825](https://github.com/flutter/devtools/pull/7825)

## Atualizações da barra lateral do VS Code

* Adicionados botões para todas as ferramentas do DevTools na barra lateral por padrão, mesmo quando
  não há sessões de depuração disponíveis. - [#7947](https://github.com/flutter/devtools/pull/7947)

    ![Ferramentas do DevTools na barra lateral](/tools/devtools/release-notes/images-2.37.2/devtools_in_sidebar.png)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, consulte o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.37.0).
