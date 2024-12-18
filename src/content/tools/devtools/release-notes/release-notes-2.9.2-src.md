# Notas da versão do DevTools 2.9.2

A versão 2.9.2 do Dart e Flutter DevTools inclui as seguintes alterações,
entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

* Participe da nossa pesquisa do DevTools de 2022! Forneça seu feedback e
  ajude-nos a melhorar sua experiência de desenvolvimento. Este aviso de
  pesquisa aparecerá diretamente no DevTools em meados de fevereiro.

  ![aviso de pesquisa](/tools/devtools/release-notes/images-2.9.2/image1.png
  "aviso_de_pesquisa")

  *Observação*: Se você estiver tendo problemas para iniciar a pesquisa,
  certifique-se de ter atualizado para a versão estável mais recente do
  Flutter, a 2.10. Havia um bug no DevTools (corrigido em
  [#3574](https://github.com/flutter/devtools/pull/3574)) que impedia
  que a pesquisa fosse aberta e, a menos que você esteja no Flutter 2.10,
  esse bug ainda estará presente.

* Correções gerais de bugs e melhorias -
  [#3528](https://github.com/flutter/devtools/pull/3528),
  [#3531](https://github.com/flutter/devtools/pull/3531),
  [#3532](https://github.com/flutter/devtools/pull/3532),
  [#3539](https://github.com/flutter/devtools/pull/3539)

## Atualizações de desempenho

* Adicionados números de frame ao eixo x do gráfico de frames do Flutter -
  [#3526](https://github.com/flutter/devtools/pull/3526)

  ![números de frame](/tools/devtools/release-notes/images-2.9.2/image2.png
  "números_de_frame")

## Atualizações do depurador

* Corrigido um bug em que o File Explorer no Debugger não mostrava o
  conteúdo após um hot restart -
  [#3527](https://github.com/flutter/devtools/pull/3527)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior,
confira
[o diff no GitHub](https://github.com/flutter/devtools/compare/v2.9.1...v2.9.2).
