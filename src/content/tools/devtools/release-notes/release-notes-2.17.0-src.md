# Notas de lançamento do DevTools 2.17.0

A versão 2.17.0 do Dart e Flutter DevTools
inclui as seguintes alterações entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do Inspector

* Adicionado suporte para configurar manualmente os diretórios de package para seu app.
  Se você já carregou o Inspector e notou que
  alguns de seus widgets não estão presentes na árvore de widgets, isso pode
  indicar que os diretórios de package para seu app
  não foram definidos ou detectados adequadamente.
  Seus diretórios de package determinam quais widgets
  o Inspector considera serem da _sua_ aplicação.
  Se você vê uma árvore de widgets vazia no Inspector,
  ou se você desenvolve widgets em múltiplos packages,
  e quer que widgets de todos esses locais apareçam em sua árvore,
  verifique o diálogo **Inspector Settings** para garantir que seus diretórios
  de package estejam configurados corretamente -
  [#4306](https://github.com/flutter/devtools/pull/4306)

  ![frame_analysis](/tools/devtools/release-notes/images-2.17.0/package_directories.png "package directories")

## Atualizações do Performance

* Adicionada aba **Frame Analysis** à página Performance.
  Ao analisar um frame com jank do Flutter,
  esta visualização fornece dicas de como diagnosticar o jank e
  detecta operações caras que podem ter
  contribuído para o tempo lento do frame.
  Esta visualização também mostra um detalhamento do tempo do frame Flutter
  por fase (**Build**, **Layout**, **Paint** e **Raster**)
  para tentar guiá-lo na direção correta -
  [#4339](https://github.com/flutter/devtools/pull/4339)

  ![frame_analysis](/tools/devtools/release-notes/images-2.17.0/frame_analysis.png "frame analysis")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.16.0...v2.17.0).
