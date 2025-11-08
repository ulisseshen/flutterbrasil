# Notas de lançamento do DevTools 2.9.1

A versão 2.9.1 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutterbrasil.dev/tools/devtools).

## Atualizações do Debugger

* Melhoria no suporte para inspecionar grandes listas e maps no
  painel de variáveis do Debugger - [#3497](https://github.com/flutter/devtools/pull/3497)

  ![Inspection before](/tools/devtools/release-notes/images-2.9.1/image1.png "Inspection before")

  ![Inspection after](/tools/devtools/release-notes/images-2.9.1/image2.png "Inspection after")

* Adicionado suporte para selecionar objetos na visualização de outline do explorador de programas.
  Selecionar um objeto irá automaticamente rolar o código-fonte
  no debugger para o objeto selecionado -
  [#3480](https://github.com/flutter/devtools/pull/3480)

## Atualizações de Performance

* Correção de bugs na busca da página de performance e melhoria de desempenho -
  [#3515](https://github.com/flutter/devtools/pull/3515)
* Adicionado um tooltip aprimorado para frames do Flutter -
  [#3493](https://github.com/flutter/devtools/pull/3493)

  ![Flutter frame tooltips](/tools/devtools/release-notes/images-2.9.1/image3.png "Flutter frame tooltips")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.8.0...v2.9.1).
