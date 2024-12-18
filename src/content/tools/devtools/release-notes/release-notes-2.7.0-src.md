# Notas de lançamento do DevTools 2.7.0

A versão 2.7.0 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, confira a [visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Melhorias no tempo de carregamento inicial da página - [#3309](https://github.com/flutter/devtools/pull/3309)
* Correção de alguns problemas relacionados à barra de rolagem - [#3393](https://github.com/flutter/devtools/pull/3393), [#3401](https://github.com/flutter/devtools/pull/3401)

## Atualizações do Depurador

* Adicionado um diálogo para abrir arquivos (ctrl / cmd + p) - [#3342](https://github.com/flutter/devtools/pull/3342), [#3354](https://github.com/flutter/devtools/pull/3354), [#3371](https://github.com/flutter/devtools/pull/3371), [#3384](https://github.com/flutter/devtools/pull/3384)

  ![Diálogo para abrir arquivos](/tools/devtools/release-notes/images-2.7.0/image1.gif "Diálogo para abrir arquivos")

* Adicionado um botão de copiar na visualização da call stack - [#3334](https://github.com/flutter/devtools/pull/3334)

  ![Visualização da call stack](/tools/devtools/release-notes/images-2.7.0/image2.png "Visualização da call stack")

## Atualizações do CPU profiler

* Adicionada funcionalidade para carregar um profile de inicialização de aplicativo para aplicativos Flutter. Este profile conterá amostras de CPU desde a inicialização da VM Dart até o primeiro frame do Flutter ser renderizado - [#3357](https://github.com/flutter/devtools/pull/3357)

  ![Botão de profile](/tools/devtools/release-notes/images-2.7.0/image3.png "Botão de profile")

  Quando o profile de inicialização do aplicativo for carregado, você verá que a tag de usuário "AppStartUp" está selecionada para o profile. Você também pode carregar o profile de inicialização do aplicativo selecionando este filtro de tag de usuário, quando presente, na lista de tags de usuário disponíveis.

  ![Exemplo de tag de usuário](/tools/devtools/release-notes/images-2.7.0/image4.png "Exemplo de tag de usuário")

* Adicionado suporte multi-isolate. Selecione qual isolate você deseja criar o profile no seletor de isolate na parte inferior da página - [#3362](https://github.com/flutter/devtools/pull/3362)

  ![Seletor de isolate](/tools/devtools/release-notes/images-2.7.0/image5.png "Seletor de isolate")

* Adicione nomes de classe aos stack frames da CPU no profiler - [#3385](https://github.com/flutter/devtools/pull/3385)

  ![Nomes de classe](/tools/devtools/release-notes/images-2.7.0/image6.png "Nomes de classe")

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.6.0...v2.7.0).
