---
ia-translate: true
title: Use a visualização do CPU profiler
description: Aprenda como usar a visualização do CPU profiler do DevTools.
---

:::note
A visualização do CPU profiler funciona apenas com apps Dart CLI e mobile.
Use o Chrome DevTools para [analisar o desempenho][]
de um app web.
:::

A visualização do CPU profiler permite que você grave e
profile uma sessão do seu aplicativo Dart ou Flutter.
O profiler pode te ajudar a resolver problemas de desempenho
ou geralmente entender a atividade da CPU do seu app.
A VM Dart coleta amostras da CPU
(um snapshot da call stack da CPU em um único ponto no tempo)
e envia os dados para o DevTools para visualização.
Ao agregar várias amostras da CPU,
o profiler pode te ajudar a entender onde a CPU
gasta a maior parte do seu tempo.

:::note
**Se você estiver executando um aplicativo Flutter,
use um build de profile para analisar o desempenho.**
Os profiles da CPU não são indicativos do desempenho de release
a menos que o seu aplicativo Flutter seja executado em modo profile.
:::

## CPU profiler

Comece a gravar um profile da CPU clicando em **Record**.
Quando você terminar a gravação, clique em **Stop**. Neste ponto,
os dados de profiling da CPU são puxados da VM e exibidos
nas visualizações do profiler (Call tree, Bottom up, Method table,
e Flame chart).

Para carregar todas as amostras da CPU disponíveis sem gravar e
parar manualmente, você pode clicar em **Load all CPU samples**,
que puxa todas as amostras da CPU que a VM gravou e
armazenou em seu buffer circular e, em seguida, exibe essas
amostras da CPU nas visualizações do profiler.

### Bottom up

Esta tabela fornece uma representação bottom-up
de um profile da CPU. Isso significa que cada método de nível superior,
ou root, na tabela bottom up é, na verdade, o
método superior na call stack para uma ou mais amostras da CPU.
Em outras palavras, cada método de nível superior em uma bottom up
table é um nó folha da tabela top down
(a call tree).
Nesta tabela, um método pode ser expandido para mostrar seus _callers_.

Esta visualização é útil para identificar _métodos_ caros
em um profile da CPU. Quando um nó root nesta tabela
tem um tempo _self_ alto, isso significa que muitas amostras da CPU
neste profile terminaram com esse método no topo da call stack.

![Screenshot da visualização Bottom up](/assets/images/docs/tools/devtools/bottom-up-view.png)
Veja a seção [Guidelines](#guidelines) abaixo para aprender como
habilitar as linhas verticais azuis e verdes vistas nesta imagem.

Tooltips podem te ajudar a entender os valores em cada coluna:

**Total time**
: Para métodos de nível superior na árvore bottom-up
(stack frames que estavam no topo de pelo menos uma
amostra da CPU), este é o tempo que o método gastou executando
seu próprio código, bem como o código para quaisquer métodos que
ele chamou.

**Self time**
: Para métodos de nível superior na árvore bottom-up
(stack frames que estavam no topo de pelo menos uma amostra da CPU),
este é o tempo que o método gastou executando apenas o seu
próprio código.<br><br>
Para métodos filhos na árvore bottom-up (os callers),
este é o tempo self do método de nível superior (o callee)
quando chamado através do método filho (o caller).

**Elemento da tabela** (tempo self)
![Screenshot de uma tabela bottom up](/assets/images/docs/tools/devtools/table-element.png)

### Call tree

Esta tabela fornece uma representação top-down de um profile da CPU.
Isso significa que cada método de nível superior na call tree é um root
de uma ou mais amostras da CPU. Nesta tabela,
um método pode ser expandido para mostrar seus _callees_.

Esta visualização é útil para identificar _paths_ caros em um profile da CPU.
Quando um nó root nesta tabela tem um tempo _total_ alto,
isso significa que muitas amostras da CPU neste profile começaram
com esse método na parte inferior da call stack.

![Screenshot de uma tabela call tree](/assets/images/docs/tools/devtools/call-tree.png)
Veja a seção [Guidelines](#guidelines) abaixo para aprender como
habilitar as linhas verticais azuis e verdes vistas nesta imagem.

Tooltips podem te ajudar a entender os valores em cada coluna:

**Total time**
: Tempo que um método gastou executando seu próprio código, bem como
o código para quaisquer métodos que ele chamou.

**Self time**
: Tempo que o método gastou executando apenas o seu próprio código.

### Method table

A method table fornece estatísticas da CPU para cada método
contido em um profile da CPU. Na tabela à esquerda,
todos os métodos disponíveis são listados com seus tempos
**total** e **self**.

O tempo **Total** é o tempo combinado que um método gastou
**em qualquer lugar** na call stack, ou, em outras palavras,
o tempo que um método gastou executando seu próprio código e
qualquer código para métodos que ele chamou.

O tempo **Self** é o tempo combinado que um método gastou
no topo da call stack, ou, em outras palavras,
o tempo que um método gastou executando apenas seu próprio código.

![Screenshot de uma tabela call tree](/assets/images/docs/tools/devtools/method-table.png)

Selecionar um método da tabela à esquerda mostra
o call graph para esse método. O call graph mostra
os callers e callees de um método e suas respectivas
porcentagens de caller/callee.

### Flame chart

A visualização flame chart é uma representação gráfica da
[Call tree](#call-tree). Esta é uma visualização top-down
de um profile da CPU, então, neste gráfico,
o método mais alto chama o que está abaixo dele.
A largura de cada elemento do flame chart representa a
quantidade de tempo que um método gastou na call stack.

Como a Call tree, esta visualização é útil para identificar
paths caros em um profile da CPU.

![Screenshot de um flame chart](/assets/images/docs/tools/devtools/cpu-flame-chart.png)

O menu de ajuda, que pode ser aberto clicando no ícone `?`
ao lado da barra de pesquisa, fornece informações sobre como
navegar e aplicar zoom dentro do gráfico e uma legenda com código de cores.
![Screenshot da ajuda do flame chart](/assets/images/docs/tools/devtools/flame-chart-help.png){:width="70%"}

### Taxa de amostragem da CPU

O DevTools define uma taxa na qual a VM coleta amostras da CPU:
1 amostra / 250 μs (microssegundos).
Isso é selecionado por padrão
na página do CPU profiler como "Taxa de amostragem da CPU: média".
Essa taxa pode ser modificada usando o seletor na parte superior
da página.

![Screenshot do menu da taxa de amostragem da CPU](/assets/images/docs/tools/devtools/cpu-sampling-rate-menu.png){:width="70%"}

As taxas de amostragem **baixa**, **média** e **alta** são
1.000 Hz, 4.000 Hz e 20.000 Hz, respectivamente.
É importante conhecer as compensações
de modificar esta configuração.

Um profile que foi gravado com uma taxa de amostragem **mais alta**
produz um profile da CPU mais refinado com mais amostras.
Isso pode afetar o desempenho do seu app, pois a VM
está sendo interrompida com mais frequência para coletar amostras.
Isso também faz com que o buffer de amostra da CPU da VM transborde mais rapidamente.
A VM tem espaço limitado onde pode armazenar informações da amostra da CPU.
Em uma taxa de amostragem mais alta, o espaço se enche e começa
a transbordar mais cedo do que aconteceria se uma amostragem mais baixa
a taxa foi usada.
Isso significa que você pode não ter acesso às amostras da CPU
do início do profile gravado, dependendo
se o buffer transborda durante o tempo de gravação.

Um profile que foi gravado com uma taxa de amostragem mais baixa
produz um profile da CPU mais grosseiro com menos amostras.
Isso afeta menos o desempenho do seu app,
mas você pode ter acesso a menos informações sobre o que
a CPU estava fazendo durante o tempo do profile.
O buffer de amostra da VM também enche mais lentamente, então você pode ver
amostras da CPU por um período mais longo de tempo de execução do app.
Isso significa que você tem uma chance melhor de visualizar a CPU
amostras do início do profile gravado.

### Filtragem

Ao visualizar um profile da CPU, você pode filtrar os dados por
biblioteca, nome do método ou [`UserTag`][].

![Screenshot do menu de filtro por tag](/assets/images/docs/tools/devtools/filter-by-tag.png)

[`UserTag`]: {{site.api}}/flutter/dart-developer/UserTag-class.html

## Guidelines

Ao olhar para uma call tree ou visualização bottom up,
às vezes as árvores podem ser muito profundas.
Para ajudar na visualização de relacionamentos pai-filho em uma árvore profunda,
habilite a opção **Display guidelines**.
Isso adiciona guidelines verticais entre pai e filho na árvore.

![Screenshot das opções de exibição](/assets/images/docs/tools/devtools/display-options.png)

[analyze performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/

## Outros recursos

Para aprender como usar o DevTools para analisar
o uso da CPU de um app Mandelbrot com uso intensivo de computação,
confira um [tutorial guiado sobre a visualização do CPU Profiler][profiler-tutorial].
Além disso, aprenda como analisar o uso da CPU quando o app
usa isolados para computação paralela.

[profiler-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-cpu-profiler-view-part-6-of-8-31e24eae6bf8

