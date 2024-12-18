# Notas de lançamento do DevTools 2.31.0

A versão 2.31.0 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre o
DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Adicionada uma nova funcionalidade para validação de deep link,
  com suporte a verificações de deep link na web no Android. -
  [#6935](https://github.com/flutter/devtools/pull/6935)
* Adicionada a estrutura básica para permitir conexões com um Dart
  Tooling Daemon. - [#7009](https://github.com/flutter/devtools/pull/7009)
* Tornou o texto da tabela selecionável
  [#6919](https://github.com/flutter/devtools/pull/6919)

## Atualizações do Inspetor

* Ao terminar de digitar no campo de pesquisa, a próxima seleção
  agora é selecionada automaticamente -
  [#6677](https://github.com/flutter/devtools/pull/6677)
* Adicionado link para a documentação do diretório do pacote, a partir
  da caixa de diálogo de configurações de inspeção -
  [#6825](https://github.com/flutter/devtools/pull/6825)

  ![Link para a documentação](/tools/devtools/release-notes/images-2.31.0/link-to-doc.png "Link para a documentação")

* Corrigido o bug em que os widgets pertencentes à estrutura do Flutter
  apareciam na visualização da árvore de widgets -
  [#6857](https://github.com/flutter/devtools/pull/6857)
* Apenas armazena em cache os diretórios raiz pub adicionados pelo
  usuário - [#6897](https://github.com/flutter/devtools/pull/6897)
* Remove a raiz pub do Flutter se ela foi armazenada em cache
  acidentalmente - [#6911](https://github.com/flutter/devtools/pull/6911)

## Atualizações de desempenho

* Alterado o fundo da pré-visualização da camada raster para um
  tabuleiro de damas. - [#6827](https://github.com/flutter/devtools/pull/6827)

## Atualizações do criador de perfil de CPU

* Adicionados cartões de foco (hover cards) para mostrar a taxa de
  amostragem do item na lista suspensa. -
  [#7010](https://github.com/flutter/devtools/pull/7010)

  ![Taxa de amostragem para lista suspensa](/tools/devtools/release-notes/images-2.31.0/hover-for-dropdown.png "Taxa de amostragem para lista suspensa")

## Atualizações do depurador

* Destaca `extension type` como uma palavra-chave de declaração, destaca
  o `$` na interpolação de identificadores como parte da interpolação e
  destaca corretamente os comentários dentro dos argumentos de tipo. -
   [6837](https://github.com/flutter/devtools/pull/6837)

## Atualizações de registro (Logging)

* Adicionada barra de rolagem ao painel de detalhes. -
  [#6917](https://github.com/flutter/devtools/pull/6917)

## Atualizações da barra lateral do VS Code

* Corrigido um problema que impedia o carregamento da barra lateral
  do VS code em compilações beta/master recentes. -
  [#6984](https://github.com/flutter/devtools/pull/6984)

## Atualizações da extensão DevTools

* Corrigidos alguns bugs que impediam que aplicativos de servidor
  Dart se conectassem às extensões do DevTools. -
  [#6982](https://github.com/flutter/devtools/pull/6982),
  [#6993](https://github.com/flutter/devtools/pull/6993)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, consulte
o [log do git do DevTools](https://github.com/flutter/devtools/tree/v2.31.0).
