# Notas de lançamento do DevTools 2.41.0

O lançamento 2.41.0 do Dart e Flutter DevTools inclui as seguintes mudanças, entre outras melhorias gerais. Para saber mais sobre o DevTools, confira a [visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Persistir as configurações de filtro entre as sessões. - [#8447](https://github.com/flutter/devtools/pull/8447),
[#8456](https://github.com/flutter/devtools/pull/8456)
[#8470](https://github.com/flutter/devtools/pull/8470)

## Atualizações do Inspetor

* Adicionada uma opção às configurações do [novo Inspetor](https://docs.flutter.dev/tools/devtools/release-notes/release-notes-2.40.2#inspector-updates) para permitir a atualização automática da árvore de widgets após um hot-reload. - [#8483](https://github.com/flutter/devtools/pull/8483)

## Atualizações do profiler de Rede

* Adicionado um campo de texto de filtro aos controles de nível superior do profiler de Rede. -
[#8469](https://github.com/flutter/devtools/pull/8469)
    ![Campo de filtro de rede](/tools/devtools/release-notes/images-2.41.0/network_filter.png "Campo de filtro de rede")

## Atualizações de Logging

* Buscar detalhes do log imediatamente após o recebimento dos logs para que os dados do log não sejam perdidos devido ao carregamento lento. - [#8421](https://github.com/flutter/devtools/pull/8421)
* Reduzir o tempo de carregamento inicial da página. - [#8500](https://github.com/flutter/devtools/pull/8500)
* Adicionado suporte para exibição de metadados, como gravidade do log, categoria, zona e isolate -
[#8419](https://github.com/flutter/devtools/pull/8419),
[#8439](https://github.com/flutter/devtools/pull/8439),
[#8441](https://github.com/flutter/devtools/pull/8441). Agora também é possível pesquisar e filtrar por esses valores de metadados. - [#8473](https://github.com/flutter/devtools/pull/8473)
    ![Exibição de metadados de logging](/tools/devtools/release-notes/images-2.41.0/log_metadata.png "Exibição de metadados de logging")
* Adicione um campo de texto de filtro aos controles de Logging de nível superior. -
[#8427](https://github.com/flutter/devtools/pull/8427)
    ![Filtro de Logging](/tools/devtools/release-notes/images-2.41.0/log_filter.png "Filtro de Logging")
* Adicionado suporte para filtragem por gravidade/níveis de log. -
[#8433](https://github.com/flutter/devtools/pull/8433)
    ![Filtro de nível de log](/tools/devtools/release-notes/images-2.41.0/log_level_filter.png "Filtro de nível de log")
* Adicionada uma configuração para definir o limite de retenção de logs. - [#8493](https://github.com/flutter/devtools/pull/8493)
* Adicionado um botão para alternar a exibição de detalhes do log entre texto bruto e JSON. -
[#8445](https://github.com/flutter/devtools/pull/8445)
* Corrigido um bug em que os logs ficavam fora de ordem após a meia-noite. -
[#8420](https://github.com/flutter/devtools/pull/8420)
* Role automaticamente a tabela de logs para a parte inferior no carregamento inicial. -
[#8437](https://github.com/flutter/devtools/pull/8437)

## Atualizações da barra lateral do VS Code

* A versão legada `postMessage` da barra lateral do VS Code foi removida em favor da versão com tecnologia DTD. Tentar acessar a barra lateral legada mostrará uma mensagem aconselhando a atualizar sua extensão Dart VS Code. A extensão Dart VS Code foi a única usuária da barra lateral legada e migrou para fora na v3.96.

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o [log do git do DevTools](https://github.com/flutter/devtools/tree/v2.41.0).
