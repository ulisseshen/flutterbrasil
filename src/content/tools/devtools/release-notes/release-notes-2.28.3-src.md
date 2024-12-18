# Notas de lançamento do DevTools 2.28.3

A versão 2.28.3 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

Esta foi uma versão *cherry-pick* em cima do DevTools 2.28.2.
Para saber mais sobre as melhorias incluídas no DevTools 2.28.2, por favor, leia as
[notas de lançamento](/tools/devtools/release-notes/release-notes-2.28.2).

## Atualizações Gerais

* Adicionado um link para o novo vídeo do YouTube "Dive in to DevTools"
  [vídeo](https://www.youtube.com/watch?v=_EYk-E29edo) na barra de status inferior.
  Este vídeo fornece um breve tutorial para cada tela do DevTools.
  [#6554](https://github.com/flutter/devtools/pull/6554)

  ![Link para assistir a um vídeo tutorial do DevTools](/tools/devtools/release-notes/images-2.28.3/watch_tutorial_link.png "Link para assistir a um vídeo tutorial do DevTools")

* Adicionada uma solução alternativa para corrigir a funcionalidade do botão de copiar no VSCode. - [#6598](https://github.com/flutter/devtools/pull/6598)

## Atualizações de desempenho

* Desabilite a ferramenta Raster Stats para o backend Impeller,
  já que não é suportado. - [#6616](https://github.com/flutter/devtools/pull/6616)

## Atualizações da Barra Lateral do VS Code

* Ao usar o VS Code com um tema claro, a barra lateral incorporada fornecida pelo
  DevTools agora também será exibida no tema claro. - [#6581](https://github.com/flutter/devtools/pull/6581)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.28.3).
