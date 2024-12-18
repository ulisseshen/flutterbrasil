# Notas de lançamento do DevTools 2.35.0

A versão 2.35.0 do Dart e Flutter DevTools inclui as seguintes alterações, entre outras melhorias gerais. Para saber mais sobre o DevTools, consulte a [visão geral do DevTools](/tools/devtools).

## Atualizações gerais

* Mudança para um único botão para iniciar e parar a gravação na tela Rede e na tela do analisador de CPU. - [#7573](https://github.com/flutter/devtools/pull/7573)
  
  ![Uma captura de tela da aba do analisador de CPU, com o novo botão de gravação.](/tools/devtools/release-notes/images-2.35.0/profiler_recording.png)
  ![Uma captura de tela da aba de rede, com o novo botão de gravação.](/tools/devtools/release-notes/images-2.35.0/network_recording.png)

## Atualizações do Inspetor

* Adicionada uma preferência para a visualização padrão do inspetor - [#6949](https://github.com/flutter/devtools/pull/6949)

## Atualizações de Memória

* Substituído o tamanho total pelo tamanho alcançável na lista de snapshots. - [#7493](https://github.com/flutter/devtools/pull/7493)

## Atualizações do Depurador

* Durante um hot-restart, `pause_isolates_on_start` e somente `resume` o app depois que os breakpoints são definidos. - [#7234](https://github.com/flutter/devtools/pull/7234)

## Atualizações do analisador de Rede

* Adicionada seleção de texto no visualizador de texto para requisições e respostas. - [#7596](https://github.com/flutter/devtools/pull/7596)
* Adicionada uma experiência de cópia JSON ao visualizador JSON. - [#7596](https://github.com/flutter/devtools/pull/7596)
  
  ![A nova experiência de cópia JSON no visualizador JSON](/tools/devtools/release-notes/images-2.35.0/json_viewer_copy.png)
  
* Corrigido um bug onde parar e iniciar a gravação de rede listava as requisições que aconteceram enquanto não gravava. - [#7626](https://github.com/flutter/devtools/pull/7626)

## Atualizações da ferramenta Deep links

* Melhoria no layout para telas estreitas. - [#7524](https://github.com/flutter/devtools/pull/7524)
* Adicionado tratamento de erros para esquemas e domínios ausentes - [#7559](https://github.com/flutter/devtools/pull/7559)

## Atualizações da Barra Lateral do VS Code

* Adicionada uma seção DevTools com uma lista de ferramentas e extensões que estão disponíveis sem uma sessão de depuração. - [#7598](https://github.com/flutter/devtools/pull/7598), [#7604](https://github.com/flutter/devtools/pull/7604)

## Atualizações da Extensão DevTools

* Suporte a extensões DevTools que não exigem um aplicativo em execução e detecção delas no workspace IDE do usuário. - [#7612](https://github.com/flutter/devtools/pull/7612)
* Obsoleto o campo `DevToolsExtension.requiresRunningApplication` em favor do novo campo opcional `requiresConnection` que pode ser adicionado ao arquivo `config.yaml` de uma extensão. - [#7611](https://github.com/flutter/devtools/pull/7611), [#7602](https://github.com/flutter/devtools/pull/7602)
* Detecção de extensões para todos os tipos de run targets em um pacote. - [#7533](https://github.com/flutter/devtools/pull/7533), [#7535](https://github.com/flutter/devtools/pull/7535)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, consulte o [log do git do DevTools](https://github.com/flutter/devtools/tree/v2.35.0).
