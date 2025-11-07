---
ia-translate: true
title: Usar o debugger
description: Como usar o debugger em nível de código-fonte do DevTools.
---

:::note
DevTools oculta a aba Debugger se o app foi executado
do VS Code porque o VS Code tem um debugger integrado.
:::

## Começando

DevTools inclui um debugger completo em nível de código-fonte,
suportando breakpoints, stepping e inspeção de variáveis.

:::note
O debugger funciona com todas as aplicações Flutter e Dart.
Se você está procurando uma maneira de usar GDB para depurar remotamente a
engine Flutter executando dentro de um processo de app Android,
confira [`flutter_gdb`][].
:::

[`flutter_gdb`]: {{site.repo.flutter}}/blob/main/engine/src/flutter/sky/tools/flutter_gdb

Quando você abre a aba debugger, você deve ver o código-fonte do
ponto de entrada principal do seu app carregado no debugger.

Para navegar por mais fontes da sua aplicação, clique em **Libraries**
(canto superior direito) ou pressione <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>P</kbd>.
Isso abre a janela de bibliotecas e permite que você
pesquise por outros arquivos fonte.

![Screenshot of the debugger tab](/assets/images/docs/tools/devtools/debugger_screenshot.png){:width="100%"}

## Definindo breakpoints

Para definir um breakpoint, clique na margem esquerda (a régua de números de linha)
na área de código-fonte. Clicar uma vez define um breakpoint, que também deve
aparecer na área **Breakpoints** à esquerda. Clicar
novamente remove o breakpoint.

## As áreas de call stack e variáveis

Quando sua aplicação encontra um breakpoint, ela pausa ali,
e o debugger DevTools mostra a localização de execução pausada
na área de código-fonte. Além disso, as áreas `Call stack` e `Variables`
são preenchidas com a call stack atual para o isolate pausado,
e as variáveis locais para o frame selecionado. Selecionar outros
frames na área `Call stack` altera o conteúdo das variáveis.

Dentro da área `Variables`, você pode inspecionar objetos individuais
alternando-os para abrir e ver seus campos. Passar o mouse sobre um objeto
na área `Variables` chama `toString()` para aquele objeto e
exibe o resultado.

## Percorrendo o código-fonte

Quando pausado, os três botões de stepping ficam ativos.

* Use **Step in** para entrar em uma invocação de método, parando na
  primeira linha executável naquele método invocado.
* Use **Step over** para passar por cima de uma invocação de método;
  isso percorre linhas de código no método atual.
* Use **Step out** para sair do método atual,
  sem parar em nenhuma linha intermediária.

Além disso, o botão **Resume** continua a
execução regular da aplicação.

## Saída do console

A saída do console para o app em execução (stdout e stderr) é
exibida no console, abaixo da área de código-fonte.
Você também pode ver a saída na [visualização Logging][Logging view].

## Breaking em exceções

Para ajustar o comportamento de parar em exceções, alterne o
dropdown **Ignore** no topo da visualização do debugger.

Breaking em exceções não tratadas apenas pausa a execução se o
breakpoint for considerado não capturado pelo código da aplicação.
Breaking em todas as exceções faz com que o debugger pause
independentemente de o breakpoint ter sido capturado pelo código da aplicação ou não.

## Problemas conhecidos

Ao realizar um hot restart para uma aplicação Flutter,
breakpoints de usuário são limpos.

[Logging view]: /tools/devtools/logging

## Outros recursos

Para mais informações sobre depuração e profiling, veja a
página [Debugging][].

[Debugging]: /testing/debugging
