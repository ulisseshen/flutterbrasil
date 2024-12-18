# Notas de lançamento do DevTools 2.22.2

A versão 2.22.2 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações Gerais

- Impedir falhas se não houver isolate principal - [#5232](https://github.com/flutter/devtools/pull/5232)

## Atualizações do profiler de CPU

- Exibir o URI do frame da pilha em linha com o nome do método para garantir que o URI esteja sempre visível em árvores profundamente aninhadas - [#5181](https://github.com/flutter/devtools/pull/5181)

  ![uri inline](/tools/devtools/release-notes/images-2.22.2/5181.png "uri inline")

- Adicionar a capacidade de filtrar por nome do método ou URI de origem - [#5204](https://github.com/flutter/devtools/pull/5204)

## Atualizações de memória

- Alterar o filtro padrão para mostrar apenas o projeto e dependências de terceiros - [#5201](https://github.com/flutter/devtools/pull/5201).

  ![filtro padrão](/tools/devtools/release-notes/images-2.22.2/5201.png "filtro padrão")

- Suportar avaliação de expressão no console para aplicação em execução - [#5248](https://github.com/flutter/devtools/pull/5248).

  ![avaliação](/tools/devtools/release-notes/images-2.22.2/5248.png "avaliação")

- Adicionar coluna `Persistido` para diferenciação de memória - [#5290](https://github.com/flutter/devtools/pull/5290)

  ![persistido](/tools/devtools/release-notes/images-2.22.2/5290.png "persistido")

## Atualizações do depurador

- Adicionar suporte para histórico de navegação do navegador ao navegar usando o File Explorer - [#4906](https://github.com/flutter/devtools/pull/4906)
- Designar campos posicionais para tipos `Record` com a sintaxe getter começando em `$1` - [#5272](https://github.com/flutter/devtools/pull/5272)
- Corrigir a inspeção de variáveis para instâncias `Map` e `List` - [#5320](https://github.com/flutter/devtools/pull/5320)

  ![mapa e lista](/tools/devtools/release-notes/images-2.22.2/5320.png "mapa e lista")

- Corrigir a inspeção de variáveis para instâncias `Set` - [#5323](https://github.com/flutter/devtools/pull/5323)

  ![set](/tools/devtools/release-notes/images-2.22.2/5323.png "set")

## Atualizações do profiler de rede

- Melhorar a confiabilidade e o desempenho da aba Rede - [#5056](https://github.com/flutter/devtools/pull/5056)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.21.1...v2.22.2).
