# Notas de lançamento do DevTools 2.20.0

A versão 2.20.0 do Dart e Flutter DevTools inclui as seguintes mudanças, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações do profiler de CPU

* Adicionado suporte para agrupar amostras por tag - [#4693](https://github.com/flutter/devtools/pull/4693)

  ![amostras por tag](/tools/devtools/release-notes/images-2.20.0/4693.png "amostras por tag")

* Ativar diretrizes para visualização em árvore - [#4722](https://github.com/flutter/devtools/pull/4722)

  ![diretrizes](/tools/devtools/release-notes/images-2.20.0/4722.png "diretrizes")

* Renomear "Granularidade do perfil" para "Taxa de amostragem da CPU" e mover para a área relacionada - [#4803](https://github.com/flutter/devtools/pull/4722)

  ![taxa de amostragem](/tools/devtools/release-notes/images-2.20.0/4803.png "taxa de amostragem")

## Atualizações de memória

* Retirar a aba **Análise** - [#4714](https://github.com/flutter/devtools/pull/4714)

* Adicionar uma nova aba, **Diff**, para habilitar a detecção de vazamento de memória e solução de problemas comparando snapshots de heap, fornecendo insights sobre o número de instâncias, tamanho raso, tamanho retido e caminhos de retenção - [#4714](https://github.com/flutter/devtools/pull/4714)

  ![diff](/tools/devtools/release-notes/images-2.20.0/4714.png "Diff na aba Memória")

## Atualizações do depurador

* Suporte para inspecionar mais tipos de instâncias no visualizador de variáveis (Expandos, Types, TypeArguments, Parameters, Closures + contextos de closure, WeakProperty, Function, FunctionType, ReceivePort, Closure, RegExp) - [#4760](https://github.com/flutter/devtools/pull/4760)

* Adicionado suporte para exibir cobertura no CodeView - [#4700](https://github.com/flutter/devtools/pull/4700)

  ![cobertura](/tools/devtools/release-notes/images-2.20.0/4700.png "cobertura em CodeView")

## Atualizações de rede

* Exibir dados da solicitação se o tipo de conteúdo não for json (obrigado a @leungpuikuen!) - [#4602](https://github.com/flutter/devtools/pull/4602)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.19.0...v2.20.0).
