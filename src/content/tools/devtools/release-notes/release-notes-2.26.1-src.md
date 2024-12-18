# Notas da versão do DevTools 2.26.1

A versão 2.26.1 do Dart e Flutter DevTools inclui as seguintes
alterações, entre outras melhorias gerais. Para saber mais sobre o
DevTools, confira a [visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações gerais

- Adicionada uma nova tela "Home" no DevTools que exibe a caixa de
  diálogo "Conectar" ou um resumo do seu aplicativo conectado,
  dependendo do status da conexão no DevTools. Fique de olho nesta tela
  para novas funcionalidades interessantes no futuro. Essa mudança
  também permite suporte para ferramentas estáticas (ferramentas que não
  exigem um aplicativo conectado) no DevTools -
  [#6010](https://github.com/flutter/devtools/pull/6010)

  ![tela inicial](/tools/devtools/release-notes/images-2.26.1/home_screen.png "Tela inicial do DevTools")

- Corrigidas as notificações de sobreposição para que elas cubram a área
  que seu plano de fundo bloqueia -
  [#5975](https://github.com/flutter/devtools/pull/5975)

## Atualizações de memória

- Adicionado um menu de contexto para renomear ou excluir um snapshot de
  heap da lista -
  [#5997](https://github.com/flutter/devtools/pull/5997)
- Avisar os usuários quando o registro HTTP puder estar afetando o
  consumo de memória do aplicativo -
  [#5998](https://github.com/flutter/devtools/pull/5998)

## Atualizações do debugger

- Melhorias na seleção de texto e no comportamento de cópia na visualização
  de código, console e janelas de variáveis -
  [#6020](https://github.com/flutter/devtools/pull/6020)

## Atualizações do Network profiler

- Adicionado um seletor para personalizar o tipo de exibição de texto e
  respostas json (graças a @hhacker1999!) -
  [#5816](https://github.com/flutter/devtools/pull/5816)

## Histórico completo de commits

Para encontrar uma lista completa de alterações desde a versão
anterior, confira [o diff no GitHub](https://github.com/flutter/devtools/compare/v2.25.0...v2.26.1).
