# Notas de lançamento do DevTools 2.40.2

A versão 2.40.2 do Dart e Flutter DevTools
inclui as seguintes alterações, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais

* Adicionada uma configuração que permite aos usuários optar por carregar o
  DevTools com WebAssembly. - [#8270](https://github.com/flutter/devtools/pull/8270)

  ![Configuração de adesão ao Wasm](/tools/devtools/release-notes/images-2.40.2/wasm_setting.png "Configuração do DevTools para aderir ao wasm.")

* Removida a tela legada do Provider do DevTools.
  A ferramenta `package:provider` agora é distribuída como uma
  extensão do DevTools do `package:provider`.
  Atualize sua dependência `package:provider` para
  usar a extensão. - [#8364](https://github.com/flutter/devtools/pull/8364)

* Corrigido um bug que estava fazendo com que as notas de lançamento do
  DevTools sempre fossem exibidas. - [#8277](https://github.com/flutter/devtools/pull/8277)

* Adicionado suporte para carregar extensões em workspaces pub
  [8347](https://github.com/flutter/devtools/pull/8347).

* Mapeadas as stack traces de erro para usar os locais do código-fonte Dart
  para que sejam legíveis. - [#8385](https://github.com/flutter/devtools/pull/8385)

* Adicionado tratamento para eventos de mudança de tema do IDE para
  atualizar a interface do usuário do DevTools incorporada. -
  [#8336](https://github.com/flutter/devtools/pull/8336)

* Corrigido um bug que estava fazendo com que os filtros de dados fossem
  limpos ao limpar os dados nas telas de Rede e Log. -
  [#8407](https://github.com/flutter/devtools/pull/8407)

* Corrigido um bug que estava fazendo com que o navegador perdesse o
  estado ao abrir a caixa de diálogo VM Flags. -
  [#8413](https://github.com/flutter/devtools/pull/8413)

* Tabelas correspondem ao tema do IDE quando incorporadas em um IDE. -
  [#8498](https://github.com/flutter/devtools/pull/8498)

## Atualizações do inspetor

- Adicionada uma configuração aos controles do Flutter Inspector que
  permite aos usuários optar pelo Flutter Inspector recém-reprojetado. -
  [#8342](https://github.com/flutter/devtools/pull/8342)

  ![Nova configuração de adesão ao inspetor](/tools/devtools/release-notes/images-2.40.2/new_inspector.png "Configuração do DevTools para aderir ao novo Flutter Inspector.")

## Atualizações de desempenho

* Corrigido um problema com a sobreposição "Atualizando timeline" que
  estava sendo exibida quando não deveria. -
  [#8318](https://github.com/flutter/devtools/pull/8318)

## Atualizações do Network profiler

* Resolvido um problema na exportação `.har` onde o
  conteúdo da resposta às vezes estava faltando nos dados. -
  [#8333](https://github.com/flutter/devtools/pull/8333)

## Atualizações da ferramenta de Deep links

- Adicionado suporte para validar as configurações de deep link do iOS. -
  [#8394](https://github.com/flutter/devtools/pull/8394)

  ![Validador de deep link para iOS](/tools/devtools/release-notes/images-2.40.2/deep_link_ios.png "Página do validador de deep link do DevTools")

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log git do DevTools](https://github.com/flutter/devtools/tree/v2.40.2).
