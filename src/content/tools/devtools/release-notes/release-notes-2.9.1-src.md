# Notas de lançamento do DevTools 2.9.1

A versão 2.9.1 do Dart e Flutter DevTools
inclui as seguintes alterações, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do Depurador

* Melhor suporte para inspecionar listas e mapas grandes no
  painel de variáveis do Depurador - [#3497](https://github.com/flutter/devtools/pull/3497)

  ![Inspeção antes](/tools/devtools/release-notes/images-2.9.1/image1.png "Inspeção antes")

  ![Inspeção depois](/tools/devtools/release-notes/images-2.9.1/image2.png "Inspeção depois")

* Adicionado suporte para selecionar objetos na visualização de estrutura do explorador
  de programa. Selecionar um objeto irá rolar automaticamente o código-fonte
  no depurador para o objeto selecionado -
  [#3480](https://github.com/flutter/devtools/pull/3480)

## Atualizações de desempenho

* Correção de bugs com a pesquisa na página de desempenho e melhoria de
  desempenho - [#3515](https://github.com/flutter/devtools/pull/3515)
* Adicionado um tooltip aprimorado para frames do flutter -
  [#3493](https://github.com/flutter/devtools/pull/3493)

  ![Tooltips de frames Flutter](/tools/devtools/release-notes/images-2.9.1/image3.png "Tooltips de frames Flutter")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.8.0...v2.9.1).
