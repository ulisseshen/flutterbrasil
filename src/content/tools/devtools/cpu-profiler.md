---
ia-translate: true
title: Use a view do profiler de CPU
description: Aprenda como usar a view de profiler de CPU do DevTools.
---

:::note
A view do profiler de CPU funciona apenas com apps CLI Dart e apps mobile.
Use Chrome DevTools para [analisar o desempenho][analyze performance]
de um app web.
:::

A view do profiler de CPU permite que você grave e faça o profiling de uma
sessão do seu aplicativo Dart ou Flutter.
O profiler pode ajudá-lo a resolver problemas de desempenho
ou geralmente entender a atividade de CPU do seu app.
A Dart VM coleta amostras de CPU
(um snapshot da pilha de chamadas de CPU em um único ponto no tempo)
e envia os dados para DevTools para visualização.
Ao agregar muitas amostras de CPU juntas,
o profiler pode ajudá-lo a entender onde a CPU
gasta a maior parte do seu tempo.

:::note
**Se você estiver executando uma aplicação Flutter,
use um build de profile para analisar o desempenho.**
Profiles de CPU não são indicativos de desempenho de release
a menos que sua aplicação Flutter seja executada em modo profile.
:::

## Profiler de CPU

Comece a gravar um profile de CPU clicando em **Record**.
Quando você terminar de gravar, clique em **Stop**. Neste ponto,
os dados de profiling de CPU são obtidos da VM e exibidos
nas views do profiler (Call tree, Bottom up, Method table,
e Flame chart).

Para carregar todas as amostras de CPU disponíveis sem gravar
e parar manualmente, você pode clicar em **Load all CPU samples**,
que obtém todas as amostras de CPU que a VM gravou e
armazenou em seu buffer circular, e então exibe essas
amostras de CPU nas views do profiler.

### Bottom up

Esta tabela fornece uma representação bottom-up
de um profile de CPU. Isso significa que cada método de nível superior,
ou raiz, na tabela bottom up é, na verdade, o
método superior na pilha de chamadas para uma ou mais amostras de CPU.
Em outras palavras, cada método de nível superior em uma tabela
bottom up é um nó folha da tabela top down
(a árvore de chamadas).
Nesta tabela, um método pode ser expandido para mostrar seus _chamadores_.

Esta view é útil para identificar _métodos_ caros
em um profile de CPU. Quando um nó raiz nesta tabela
tem um _self_ time alto, isso significa que muitas amostras de CPU
neste profile terminaram com aquele método no topo da pilha de chamadas.

![Screenshot of the Bottom up view](/assets/images/docs/tools/devtools/bottom-up-view.png)
Veja a seção [Guidelines](#guidelines) abaixo para aprender como
habilitar as linhas verticais azuis e verdes vistas nesta imagem.

Tooltips podem ajudá-lo a entender os valores em cada coluna:

**Total time**
: Para métodos de nível superior na árvore bottom-up
(stack frames que estavam no topo de pelo menos uma
amostra de CPU), este é o tempo que o método gastou executando
seu próprio código, bem como o código de quaisquer métodos que
ele chamou.

**Self time**
: Para métodos de nível superior na árvore bottom-up
(stack frames que estavam no topo de pelo menos uma amostra
de CPU), este é o tempo que o método gastou executando apenas
seu próprio código.<br><br>
Para métodos filhos na árvore bottom-up (os chamadores),
este é o self time do método de nível superior (o chamado)
quando chamado através do método filho (o chamador).

**Table element** (self time)
![Screenshot of a bottom up table](/assets/images/docs/tools/devtools/table-element.png)

### Call tree

Esta tabela fornece uma representação top-down de um profile de CPU.
Isso significa que cada método de nível superior na call tree é uma raiz
de uma ou mais amostras de CPU. Nesta tabela,
um método pode ser expandido para mostrar seus _chamados_.

Esta view é útil para identificar _caminhos_ caros em um profile de CPU.
Quando um nó raiz nesta tabela tem um _total_ time alto,
isso significa que muitas amostras de CPU neste profile começaram
com aquele método na base da pilha de chamadas.

![Screenshot of a call tree table](/assets/images/docs/tools/devtools/call-tree.png)
Veja a seção [Guidelines](#guidelines) abaixo para aprender como
habilitar as linhas verticais azuis e verdes vistas nesta imagem.

Tooltips podem ajudá-lo a entender os valores em cada coluna:

**Total time**
: Tempo que um método gastou executando seu próprio código, bem como
o código de quaisquer métodos que ele chamou.

**Self time**
: Tempo que o método gastou executando apenas seu próprio código.

### Method table

A method table fornece estatísticas de CPU para cada método
contido em um profile de CPU. Na tabela à esquerda,
todos os métodos disponíveis são listados com seu tempo **total** e
**self**.

O tempo **Total** é o tempo combinado que um método gastou
**em qualquer lugar** na pilha de chamadas, ou em outras palavras,
o tempo que um método gastou executando seu próprio código e
qualquer código de métodos que ele chamou.

O tempo **Self** é o tempo combinado que um método gastou
no topo da pilha de chamadas, ou em outras palavras,
o tempo que um método gastou executando apenas seu próprio código.

![Screenshot of a call tree table](/assets/images/docs/tools/devtools/method-table.png)

Selecionar um método da tabela à esquerda mostra
o grafo de chamadas para aquele método. O grafo de chamadas mostra
os chamadores e chamados de um método e suas respectivas
porcentagens de chamador / chamado.

### Flame chart

A view flame chart é uma representação gráfica da
[Call tree](#call-tree). Esta é uma view top-down
de um profile de CPU, então neste gráfico,
o método mais acima chama aquele abaixo dele.
A largura de cada elemento do flame chart representa a
quantidade de tempo que um método gastou na pilha de chamadas.

Como a Call tree, esta view é útil para identificar
caminhos caros em um profile de CPU.

![Screenshot of a flame chart](/assets/images/docs/tools/devtools/cpu-flame-chart.png)

O menu de ajuda, que pode ser aberto clicando no ícone `?`
ao lado da barra de pesquisa, fornece informações sobre como
navegar e dar zoom dentro do gráfico e uma legenda codificada por cores.
![Screenshot of flame chart help](/assets/images/docs/tools/devtools/flame-chart-help.png){:width="70%"}


### Taxa de amostragem de CPU

DevTools define uma taxa na qual a VM coleta amostras de CPU:
1 amostra / 250 μs (microssegundos).
Esta é selecionada por padrão na
página do profiler de CPU como "Cpu sampling rate: medium".
Esta taxa pode ser modificada usando o seletor no topo
da página.

![Screenshot of cpu sampling rate menu](/assets/images/docs/tools/devtools/cpu-sampling-rate-menu.png){:width="70%"}

As taxas de amostragem **low**, **medium** e **high** são
1.000 Hz, 4.000 Hz e 20.000 Hz, respectivamente.
É importante conhecer os trade-offs
de modificar esta configuração.

Um profile que foi gravado com uma taxa de amostragem **higher**
produz um profile de CPU mais refinado com mais amostras.
Isso pode afetar o desempenho do seu app, pois a VM
está sendo interrompida com mais frequência para coletar amostras.
Isso também faz com que o buffer de amostras de CPU da VM transborde mais rapidamente.
A VM tem espaço limitado onde pode armazenar informações de amostras de CPU.
Com uma taxa de amostragem mais alta, o espaço se enche e começa
a transbordar mais cedo do que teria se uma taxa de amostragem
mais baixa fosse usada.
Isso significa que você pode não ter acesso a amostras de CPU
desde o início do profile gravado, dependendo
de se o buffer transborda durante o tempo de gravação.

Um profile que foi gravado com uma taxa de amostragem mais baixa
produz um profile de CPU mais grosseiro com menos amostras.
Isso afeta menos o desempenho do seu app,
mas você pode ter acesso a menos informações sobre o que
a CPU estava fazendo durante o tempo do profile.
O buffer de amostras da VM também se enche mais lentamente, então você pode ver
amostras de CPU por um período mais longo de tempo de execução do app.
Isso significa que você tem uma chance melhor de visualizar amostras
de CPU desde o início do profile gravado.

### Filtragem

Ao visualizar um profile de CPU, você pode filtrar os dados por
biblioteca, nome de método ou [`UserTag`][`UserTag`].

![Screenshot of filter by tag menu](/assets/images/docs/tools/devtools/filter-by-tag.png)

[`UserTag`]: {{site.api}}/flutter/dart-developer/UserTag-class.html

## Guidelines

Ao olhar para uma call tree ou view bottom up,
às vezes as árvores podem ser muito profundas.
Para ajudar na visualização de relações pai-filho em uma árvore profunda,
habilite a opção **Display guidelines**.
Isso adiciona linhas-guia verticais entre pai e filho na árvore.

![Screenshot of display options](/assets/images/docs/tools/devtools/display-options.png)

[analyze performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/

## Outros recursos

Para aprender como usar DevTools para analisar
o uso de CPU de um app Mandelbrot computacionalmente intensivo,
confira um [tutorial guiado da View do CPU Profiler][profiler-tutorial].
Além disso, aprenda como analisar o uso de CPU quando o app
usa isolates para computação paralela.

[profiler-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-cpu-profiler-view-part-6-of-8-31e24eae6bf8
