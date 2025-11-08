# Notas de lançamento do DevTools 2.7.0

A versão 2.7.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Melhorias no tempo de carregamento inicial da página -
  [#3309](https://github.com/flutter/devtools/pull/3309)
* Correção de alguns problemas relacionados à barra de rolagem -
  [#3393](https://github.com/flutter/devtools/pull/3393),
  [#3401](https://github.com/flutter/devtools/pull/3401)

## Atualizações do Debugger

* Adicionado diálogo de abrir arquivo (ctrl / cmd + p) -
  [#3342](https://github.com/flutter/devtools/pull/3342),
  [#3354](https://github.com/flutter/devtools/pull/3354),
  [#3371](https://github.com/flutter/devtools/pull/3371),
  [#3384](https://github.com/flutter/devtools/pull/3384)

  ![Open file dialog](/tools/devtools/release-notes/images-2.7.0/image1.gif "Open file dialog")

* Adicionado botão de copiar na visualização da pilha de chamadas -
  [#3334](https://github.com/flutter/devtools/pull/3334)

  ![Call stack view](/tools/devtools/release-notes/images-2.7.0/image2.png "Call stack view")

## Atualizações do CPU profiler

* Adicionada funcionalidade para carregar um perfil de inicialização do app para apps Flutter.
  Este perfil conterá amostras de CPU desde a inicialização
  da Dart VM até a renderização do primeiro frame do Flutter -
  [#3357](https://github.com/flutter/devtools/pull/3357)

  ![Profile button](/tools/devtools/release-notes/images-2.7.0/image3.png "Profile button")

  Quando o perfil de inicialização do app for carregado,
  você verá que a user tag "AppStartUp" está selecionada para o perfil.
  Você também pode carregar o perfil de inicialização do app
  selecionando este filtro de user tag, quando presente,
  na lista de user tags disponíveis.

  ![User tag example](/tools/devtools/release-notes/images-2.7.0/image4.png "User tag example")

* Adicionado suporte a múltiplos isolates.
  Selecione qual isolate você deseja perfilar
  no seletor de isolate na parte inferior da página -
  [#3362](https://github.com/flutter/devtools/pull/3362)

  ![isolate selector](/tools/devtools/release-notes/images-2.7.0/image5.png "isolate selector")

* Adicionados nomes de classe aos stack frames de CPU no profiler -
  [#3385](https://github.com/flutter/devtools/pull/3385)

  ![Class names](/tools/devtools/release-notes/images-2.7.0/image6.png "Class names")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.6.0...v2.7.0).
