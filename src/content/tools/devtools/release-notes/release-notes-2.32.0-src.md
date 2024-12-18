# Notas de lançamento do DevTools 2.32.0

A versão 2.32.0 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre o
DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Melhoria da usabilidade geral tornando a UI do DevTools mais densa. Isso
  melhora significativamente a experiência do usuário ao usar o DevTools
  incorporado em um IDE. - [#7030](https://github.com/flutter/devtools/pull/7030)
* Remoção da configuração "Modo Denso". - [#7086](https://github.com/flutter/devtools/pull/7086)
* Adição de suporte para filtragem com expressões regulares nas páginas de
  Logging, Rede e Profiler de CPU - [#7027](https://github.com/flutter/devtools/pull/7027)
* Adição de uma interação com o servidor DevTools para obter o URI DTD. - [#7054](https://github.com/flutter/devtools/pull/7054)

## Atualizações de memória

* Suporte ao rastreamento de alocação para builds de perfil do Flutter e
  aplicativos compilados Dart AOT. - [#7058](https://github.com/flutter/devtools/pull/7058)
* Suporte à importação de snapshots de memória. - [#6974](https://github.com/flutter/devtools/pull/6974)

## Atualizações do Depurador

* Destaque de `extension type` como uma palavra-chave de declaração,
  destaque do `$` na interpolação de identificador como parte da interpolação
  e destaque adequado de comentários dentro de argumentos de tipo. -
  [#6837](https://github.com/flutter/devtools/pull/6837)

## Atualizações de Logging

* Adição de filtros de alternância para filtrar logs ruidosos do Flutter e
  Dart - [#7026](https://github.com/flutter/devtools/pull/7026)

    ![Filtros de visualização de registro](/tools/devtools/release-notes/images-2.32.0/logging_toggle_filters.png "Alternar filtros para tela de logging")

* Adição de uma barra de rolagem ao painel de detalhes. - [#6917](https://github.com/flutter/devtools/pull/6917)

## Atualizações da extensão DevTools

* Adição de uma descrição e link de documentação ao arquivo
  `devtools_options.yaml` que é criado no projeto de um usuário. -
  [#7052](https://github.com/flutter/devtools/pull/7052)
* Atualização do Painel do Ambiente DevTools Simulado para ser recolhível
  (obrigado a @victoreronmosele!) - [#7062](https://github.com/flutter/devtools/pull/7062)
* Integração das extensões do DevTools com o novo Dart Tooling Daemon.
  Isso permitirá que as extensões do DevTools acessem métodos públicos
  registrados por outros clientes DTD, como um IDE, bem como acessem uma
  API de sistema de arquivos mínima para interagir com o projeto de
  desenvolvimento. - [#7108](https://github.com/flutter/devtools/pull/7108)

## Atualizações da barra lateral do VS Code

* Correção de um problema que impedia o carregamento da barra lateral do VS
  Code em builds `beta` e `main` recentes. -
  [#6984](https://github.com/flutter/devtools/pull/6984)
* Exibição das extensões do DevTools como uma opção no menu suspenso do
  DevTools das sessões de depuração, quando disponíveis.
  [#6709](https://github.com/flutter/devtools/pull/6709)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, consulte
o [log do git do DevTools](https://github.com/flutter/devtools/tree/v2.32.0).
