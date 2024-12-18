---
ia-translate: true
title: Usar o console de Debug
description: Aprenda a usar o console do DevTools.
---

O console de Debug do DevTools permite observar a saída
padrão de um aplicativo (`stdout`), avaliar expressões
para um aplicativo em pausa ou em execução no modo de
depuração e analisar referências de entrada e saída para
objetos.

:::note
Esta página está atualizada para o DevTools 2.23.0.
:::

O console de Debug está disponível nas visualizações
[Inspector][], [Debugger][] e [Memory][].

[Inspector]: /tools/devtools/inspector
[Debugger]:  /tools/devtools/debugger
[Memory]:    /tools/devtools/memory

## Observar a saída do aplicativo

O console mostra a saída padrão do aplicativo (`stdout`):

![Captura de tela de stdout na visualização do Console](/assets/images/docs/tools/devtools/console-stdout.png)

## Explorar widgets inspecionados

Se você clicar em um widget na tela **Inspector**, a
variável para este widget será exibida no **Console**:

![Captura de tela do widget inspecionado na visualização do Console](/assets/images/docs/tools/devtools/console-inspect-widget.png){:width="100%"}

## Avaliar expressões

No console, você pode avaliar expressões para um
aplicativo em pausa ou em execução, supondo que você
esteja executando seu aplicativo no modo de depuração:

![Captura de tela mostrando a avaliação de uma expressão no console](/assets/images/docs/tools/devtools/console-evaluate-expressions.png)

Para atribuir um objeto avaliado a uma variável, use `$0`,
`$1` (até `$5`) na forma de `var x = $0`:

![Captura de tela mostrando como avaliar variáveis](/assets/images/docs/tools/devtools/console-evaluate-variables.png){:width="100%"}

## Navegar pelo snapshot de heap

Para soltar uma variável no console a partir de um snapshot de heap, faça o seguinte:

1.  Navegue até **Devtools > Memory > Diff Snapshots**.
2.  Grave um snapshot de heap de memória.
3.  Clique no menu de contexto `[⋮]` para visualizar o número
    de **Instances** para a **Class** desejada.
4.  Selecione se deseja armazenar uma única instância como
    uma variável do console ou se deseja armazenar _todas_
    as instâncias vivas no aplicativo.

![Captura de tela mostrando como navegar pelos snapshots de heap](/assets/images/docs/tools/devtools/browse-heap-snapshot.png){:width="100%"}

A tela do Console exibe referências de entrada e saída
estáticas e dinâmicas, bem como valores de campos:

![Captura de tela mostrando referências de entrada e saída no Console](/assets/images/docs/tools/devtools/console-references.png){:width="100%"}
