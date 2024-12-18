# Notas de lançamento do DevTools 2.30.0

A versão 2.30.0 do Dart e Flutter DevTools
inclui as seguintes alterações, entre outras melhorias gerais.
Para saber mais sobre o DevTools, confira a
[visão geral do DevTools](https://docs.flutter.dev/tools/devtools).

## Atualizações de desempenho

* Adiciona um indicador do motor de renderização ao gráfico de Frames do Flutter. -
  [#6771](https://github.com/flutter/devtools/pull/6771)

  ![Texto do motor de renderização do Flutter](/tools/devtools/release-notes/images-2.30.0/flutter_frames_engine_text.png "Texto descrevendo o motor de renderização atual do flutter")

* Melhora as mensagens quando não temos dados de análise disponíveis para um
  frame do Flutter. - [#6768](https://github.com/flutter/devtools/pull/6768)

## Atualizações da barra lateral do VS Code

* A barra lateral do Flutter fornecida ao VS Code agora tem a capacidade de habilitar novas
  plataformas se um dispositivo estiver disponível para uma plataforma que não está habilitada para
  o projeto atual. Isso também requer uma extensão Dart correspondente para
  a atualização do VS Code para aparecer. - [#6688](https://github.com/flutter/devtools/pull/6688)

* O menu do DevTools na barra lateral agora tem uma entrada "Abrir no Navegador"
  que abre o DevTools em uma janela de navegador externo, mesmo quando as configurações do VS Code
  são definidas para usar normalmente o DevTools incorporado. - [#6736](https://github.com/flutter/devtools/pull/6736)

## Histórico completo de commits

Para encontrar uma lista completa de alterações nesta versão, confira o
[log do git do DevTools](https://github.com/flutter/devtools/tree/v2.30.0).
