---
ia-translate: true
title: Notas de lançamento do DevTools 2.54.0
shortTitle: Notas de lançamento 2.54.0
breadcrumb: 2.54.0
showToc: false
---

A versão 2.54.0 do Dart e Flutter DevTools
inclui as seguintes mudanças, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](/tools/devtools/overview).

## Atualizações gerais {:#general-updates}

- As conexões perdidas com o DTD agora são tentadas novamente automaticamente, para melhorar a
  experiência quando a sua máquina é retomada do modo de suspensão. -
  [#9587](https://github.com/flutter/devtools/pull/9587)

## Atualizações do Inspector {:#inspector-updates}

- Adicionado um banner de aviso informando que o inspector legado
  será removido em uma versão futura. -
  [#9572](https://github.com/flutter/devtools/pull/9572)

## Atualizações de memória {:#memory-updates}

- Corrigido um erro que impedia os usuários de alterar a duração do zoom. -
  [#9573](https://github.com/flutter/devtools/pull/9573)

## Atualizações da ferramenta Deep links {:#deep-links-tool-updates}

- Adicionado um diálogo mais informativo caso a ferramenta Deep Links não consiga encontrar
  as opções de build do app iOS ou Android. -
  [#9571](https://github.com/flutter/devtools/pull/9571)
- Corrigido erro de null ao analisar as configurações de universal links. -
  [#9581](https://github.com/flutter/devtools/pull/9581)

## Histórico completo de commits {:#full-commit-history}

Para encontrar uma lista completa de mudanças nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.54.0).
