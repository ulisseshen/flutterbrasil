---
ia-translate: true
title: Usar o Debug console
description: Aprenda como usar o console DevTools.
---

O Debug console DevTools permite que você observe a
saída padrão de uma aplicação (`stdout`),
avalie expressões para um app pausado ou em execução
em modo debug e analise referências de entrada e saída
para objetos.

:::note
Esta página está atualizada para DevTools 2.23.0.
:::

O Debug console está disponível nas visualizações [Inspector][],
[Debugger][] e [Memory][].

[Inspector]: /tools/devtools/inspector
[Debugger]:  /tools/devtools/debugger
[Memory]:    /tools/devtools/memory

## Observar saída da aplicação

O console mostra a saída padrão da aplicação (`stdout`):

![Screenshot of stdout in Console view](/assets/images/docs/tools/devtools/console-stdout.png)

## Explorar widgets inspecionados

Se você clicar em um widget na tela **Inspector**,
a variável para este widget é exibida no **Console**:

![Screenshot of inspected widget in Console view](/assets/images/docs/tools/devtools/console-inspect-widget.png){:width="100%"}

## Avaliar expressões

No console, você pode avaliar expressões para uma aplicação
pausada ou em execução, assumindo que você está executando
seu app em modo debug:

![Screenshot showing evaluating an expression in the console](/assets/images/docs/tools/devtools/console-evaluate-expressions.png)

Para atribuir um objeto avaliado a uma variável,
use `$0`, `$1` (até `$5`) na forma de `var x = $0`:

![Screenshot showing how to evaluate variables](/assets/images/docs/tools/devtools/console-evaluate-variables.png){:width="100%"}

## Navegar heap snapshot

Para soltar uma variável no console de um heap snapshot,
faça o seguinte:

1. Navegue para **Devtools > Memory > Diff Snapshots**.
1. Registre um heap snapshot de memória.
1. Clique no menu de contexto `[⋮]` para visualizar o número de
   **Instances** para a **Class** desejada.
1. Selecione se você deseja armazenar uma única instância como
   uma variável de console, ou se deseja armazenar _todas_ as
   instâncias atualmente vivas no app.

![Screenshot showing how to browse the heap snapshots](/assets/images/docs/tools/devtools/browse-heap-snapshot.png){:width="100%"}

A tela Console exibe tanto referências de entrada e saída
vivas quanto estáticas, bem como valores de campos:

![Screenshot showing inbound and outbound references in Console](/assets/images/docs/tools/devtools/console-references.png){:width="100%"}
