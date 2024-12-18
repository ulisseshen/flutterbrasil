---
ia-translate: true
title: Use o depurador
description: Como usar o depurador de nível de código-fonte do DevTools.
---

:::note
O DevTools oculta a aba do Depurador se o aplicativo foi inicializado
a partir do VS Code porque o VS Code tem um depurador integrado.
:::

## Primeiros passos

O DevTools inclui um depurador completo em nível de código-fonte,
suportando breakpoints, stepping e inspeção de variáveis.

:::note
O depurador funciona com todos os aplicativos Flutter e Dart.
Se você está procurando uma forma de usar o GDB para depurar remotamente o
motor Flutter rodando dentro de um processo de aplicativo Android,
confira [`flutter_gdb`][].
:::

[`flutter_gdb`]: {{site.repo.engine}}/blob/main/sky/tools/flutter_gdb

Quando você abre a aba do depurador, você deve ver o código-fonte do ponto
de entrada principal para o seu aplicativo carregado no depurador.

Para navegar por mais fontes do seu aplicativo, clique em **Libraries**
(canto superior direito) ou pressione <kbd>Ctrl</kbd> / <kbd>Cmd</kbd> + <kbd>P</kbd>.
Isso abre a janela de bibliotecas e permite que você
pesquise por outros arquivos de código-fonte.

![Captura de tela da aba do depurador](/assets/images/docs/tools/devtools/debugger_screenshot.png){:width="100%"}

## Definindo breakpoints

Para definir um breakpoint, clique na margem esquerda (a régua do número da linha)
na área de código-fonte. Clicar uma vez define um breakpoint, que também deve
aparecer na área de **Breakpoints** à esquerda. Clicar novamente remove o breakpoint.

## A pilha de chamadas e áreas de variáveis

Quando seu aplicativo encontra um breakpoint, ele pausa ali,
e o depurador do DevTools mostra a localização da execução pausada
na área do código-fonte. Além disso, as áreas `Call stack` e `Variables`
são preenchidas com a pilha de chamadas atual para o isolate pausado,
e as variáveis locais para o frame selecionado. Selecionar outros
frames na área `Call stack` altera o conteúdo das variáveis.

Dentro da área `Variables`, você pode inspecionar objetos individuais
abrindo-os para ver seus campos. Passar o mouse sobre um objeto
na área `Variables` chama `toString()` para aquele objeto e
exibe o resultado.

## Avançando pelo código-fonte

Quando pausado, os três botões de stepping ficam ativos.

* Use **Step in** para entrar em uma invocação de método, parando na
  primeira linha executável naquele método invocado.
* Use **Step over** para passar por cima de uma invocação de método;
  isso avança pelas linhas do código-fonte no método atual.
* Use **Step out** para sair do método atual,
  sem parar em nenhuma linha intermediária.

Além disso, o botão **Resume** continua a execução regular
do aplicativo.

## Saída do console

A saída do console para o aplicativo em execução (stdout e stderr) é
exibida no console, abaixo da área do código-fonte.
Você também pode ver a saída na [visualização de Logging][].

## Interrompendo em exceções

Para ajustar o comportamento de parar em exceções, alterne o
dropdown **Ignore** no topo da visualização do depurador.

Interromper em exceções não tratadas só pausa a execução se o
breakpoint for considerado não capturado pelo código do aplicativo.
Interromper em todas as exceções faz com que o depurador pause
se o breakpoint foi ou não capturado pelo código do aplicativo.

## Problemas conhecidos

Ao realizar um hot restart para um aplicativo Flutter,
os breakpoints do usuário são limpos.

[Logging view]: /tools/devtools/logging

## Outros recursos

Para mais informações sobre depuração e profiling, veja a página
[Debugging][].

[Debugging]: /testing/debugging
