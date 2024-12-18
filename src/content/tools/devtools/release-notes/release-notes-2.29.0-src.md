# Notas da versão 2.29.0 do DevTools

A versão 2.29.0 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre o
DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Corrigido um bug em que os estados da extensão de serviço não
  eram limpos na desconexão do aplicativo. - [#6547](https://github.com/flutter/devtools/pull/6547)

* Estilo aprimorado da barra de status inferior quando conectado a um
  aplicativo. - [#6525](https://github.com/flutter/devtools/pull/6525)

* Adicionada uma solução alternativa para corrigir a funcionalidade do
  botão de cópia no VSCode. - [#6598](https://github.com/flutter/devtools/pull/6598)

## Atualizações de desempenho

* Adicionada uma opção no menu "Aprimorar Rastreamento" para rastrear a
  atividade do canal da plataforma. Isso é útil para aplicativos com
  plugins. - [#6515](https://github.com/flutter/devtools/pull/6515)

  ![Configuração de rastreamento de canais de plataforma](/tools/devtools/release-notes/images-2.29.0/track_platform_channels.png "Configuração de rastreamento de canais de plataforma")

* Tornada a tela de Performance disponível quando não há nenhum
  aplicativo conectado. Os dados de Performance que foram salvos
  anteriormente do DevTools podem ser recarregados para visualização
  nesta tela. - [#6567](https://github.com/flutter/devtools/pull/6567)

* Adicionado um botão "Abrir" aos controles de Performance para carregar
  dados que foram salvos anteriormente do DevTools. - [#6567](https://github.com/flutter/devtools/pull/6567)

  ![Botão Abrir arquivo na tela de performance](/tools/devtools/release-notes/images-2.29.0/open_file_performance_screen.png "Botão Abrir arquivo na tela de performance")

## Atualizações do profiler de CPU

* As linhas guia de árvore agora estão sempre habilitadas para as guias
  "Bottom Up" e "Call Tree". - [#6534](https://github.com/flutter/devtools/pull/6534)

* Tornada a tela do profiler de CPU disponível quando não há nenhum
  aplicativo conectado. Os perfis de CPU que foram salvos
  anteriormente do DevTools podem ser recarregados para visualização
  nesta tela. - [#6567](https://github.com/flutter/devtools/pull/6567)

* Adicionado um botão "Abrir" aos controles do profiler de CPU para
  carregar dados que foram salvos anteriormente do DevTools. - [#6567](https://github.com/flutter/devtools/pull/6567)

## Atualizações do profiler de rede

* Os status de rede agora são exibidos com uma cor de erro quando a
  solicitação falha. - [#6527](https://github.com/flutter/devtools/pull/6527)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, consulte o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.29.0).
