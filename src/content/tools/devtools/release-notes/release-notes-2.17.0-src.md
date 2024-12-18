# Notas de lançamento do DevTools 2.17.0

A versão 2.17.0 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do Inspetor

* Adicionado suporte para definir manualmente os diretórios de pacotes para seu aplicativo. Se você já carregou o Inspetor e notou que alguns de seus widgets não estão presentes na árvore de widgets, isso pode indicar que os diretórios de pacotes para seu aplicativo não foram definidos ou detectados corretamente. Seus diretórios de pacotes determinam quais widgets o Inspetor considera como sendo de _seu_ aplicativo. Se você vir uma árvore de widgets do Inspetor vazia, ou se você desenvolver widgets em vários pacotes e quiser que os widgets de todos esses locais apareçam em sua árvore, verifique a caixa de diálogo **Configurações do Inspetor** para garantir que seus diretórios de pacotes estejam configurados corretamente - [#4306](https://github.com/flutter/devtools/pull/4306)

  ![frame_analysis](/tools/devtools/release-notes/images-2.17.0/package_directories.png "diretórios de pacotes")

## Atualizações de desempenho

* Adicionada uma aba **Análise de Frame** na página de Performance. Ao analisar um frame do Flutter instável, esta visualização fornece dicas sobre como diagnosticar a instabilidade e detecta operações dispendiosas que podem ter contribuído para o tempo de frame lento. Esta visualização também mostra um detalhamento do seu tempo de frame do Flutter por fase (**Build**, **Layout**, **Paint** e **Raster**) para tentar guiá-lo na direção certa - [#4339](https://github.com/flutter/devtools/pull/4339)

  ![frame_analysis](/tools/devtools/release-notes/images-2.17.0/frame_analysis.png "análise de frame")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.16.0...v2.17.0).
