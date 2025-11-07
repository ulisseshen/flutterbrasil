---
ia-translate: true
title: Usar a visualização CPU profiler
description: Aprenda como usar a visualização de CPU profiler do DevTools.
---

:::note
A visualização de CPU profiler funciona apenas com apps Dart CLI e mobile.
Use Chrome DevTools para [analisar performance][analyze performance]
de um app web.
:::

A visualização de CPU profiler permite que você grave e faça profiling de uma
sessão da sua aplicação Dart ou Flutter.
O profiler pode ajudá-lo a resolver problemas de performance
ou geralmente entender a atividade de CPU do seu app.
A Dart VM coleta amostras de CPU
(um snapshot da call stack da CPU em um único ponto no tempo)
e envia os dados para DevTools para visualização.
Ao agregar muitas amostras de CPU juntas,
o profiler pode ajudá-lo a entender onde a CPU
gasta a maior parte do seu tempo.

:::note
**Se você está executando uma aplicação Flutter,
use uma compilação profile para analisar performance.**
Perfis de CPU não são indicativos de performance de release
a menos que sua aplicação Flutter seja executada em modo profile.
:::

## CPU profiler

Comece a gravar um perfil de CPU clicando em **Record**.
Quando terminar de gravar, clique em **Stop**. Neste ponto,
dados de profiling de CPU são extraídos da VM e exibidos
nas visualizações do profiler (Call tree, Bottom up, Method table
e Flame chart).

Para carregar todas as amostras de CPU disponíveis sem gravar
e parar manualmente, você pode clicar em **Load all CPU samples**,
que extrai todas as amostras de CPU que a VM gravou e
armazenou em seu ring buffer, e então exibe essas
amostras de CPU nas visualizações do profiler.

### Bottom up

Esta tabela fornece uma representação bottom-up
de um perfil de CPU. Isso significa que cada método de nível superior,
ou raiz, na tabela bottom up é na verdade o
método superior na call stack para uma ou mais amostras de CPU.
Em outras palavras, cada método de nível superior em uma tabela
bottom up é um nó folha da tabela top down
(a call tree).
Nesta tabela, um método pode ser expandido para mostrar seus _chamadores_.

Esta visualização é útil para identificar _métodos_ caros
em um perfil de CPU. Quando um nó raiz nesta tabela
tem um _self_ time alto, isso significa que muitas amostras de CPU
neste perfil terminaram com aquele método no topo da call stack.

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

Esta tabela fornece uma representação top-down de um perfil de CPU.
Isso significa que cada método de nível superior na call tree é uma raiz
de uma ou mais amostras de CPU. Nesta tabela,
um método pode ser expandido para mostrar seus _chamados_.

Esta visualização é útil para identificar _caminhos_ caros em um perfil de CPU.
Quando um nó raiz nesta tabela tem um _total_ time alto,
isso significa que muitas amostras de CPU neste perfil começaram
com aquele método na base da call stack.

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

A tabela de métodos fornece estatísticas de CPU para cada método
contido em um perfil de CPU. Na tabela à esquerda,
todos os métodos disponíveis são listados com seu tempo **total** e
**self**.

Tempo **Total** é o tempo combinado que um método gastou
**em qualquer lugar** na call stack, ou em outras palavras,
o tempo que um método gastou executando seu próprio código e
qualquer código para métodos que ele chamou.

Tempo **Self** é o tempo combinado que um método gastou
no topo da call stack, ou em outras palavras,
o tempo que um método gastou executando apenas seu próprio código.

![Screenshot of a call tree table](/assets/images/docs/tools/devtools/method-table.png)

Selecionar um método da tabela à esquerda mostra
o gráfico de chamada para aquele método. O gráfico de chamada mostra
os chamadores e chamados de um método e suas respectivas
porcentagens de chamador / chamado.

### Flame chart

A visualização de flame chart é uma representação gráfica da
[Call tree](#call-tree). Esta é uma visualização top-down
de um perfil de CPU, então neste gráfico,
o método mais acima chama o que está abaixo dele.
A largura de cada elemento do flame chart representa a
quantidade de tempo que um método gastou na call stack.

Como a Call tree, esta visualização é útil para identificar
caminhos caros em um perfil de CPU.

![Screenshot of a flame chart](/assets/images/docs/tools/devtools/cpu-flame-chart.png)

O menu de ajuda, que pode ser aberto clicando no ícone `?`
próximo à barra de pesquisa, fornece informações sobre como
navegar e dar zoom dentro do gráfico e uma legenda codificada por cores.
![Screenshot of flame chart help](/assets/images/docs/tools/devtools/flame-chart-help.png){:width="70%"}


### Taxa de amostragem de CPU

DevTools define uma taxa na qual a VM coleta amostras de CPU:
1 amostra / 250 μs (microssegundos).
Isso é selecionado por padrão na
página do CPU profiler como "Cpu sampling rate: medium".
Esta taxa pode ser modificada usando o seletor no topo
da página.

![Screenshot of cpu sampling rate menu](/assets/images/docs/tools/devtools/cpu-sampling-rate-menu.png){:width="70%"}

As taxas de amostragem **low**, **medium** e **high** são
1.000 Hz, 4.000 Hz e 20.000 Hz, respectivamente.
É importante conhecer as compensações
de modificar esta configuração.

Um perfil que foi gravado com uma taxa de amostragem **maior**
produz um perfil de CPU mais granular com mais amostras.
Isso pode afetar a performance do seu app, pois a VM
está sendo interrompida com mais frequência para coletar amostras.
Isso também faz com que o buffer de amostras de CPU da VM transborde mais rapidamente.
A VM tem espaço limitado onde pode armazenar informações de amostra de CPU.
Com uma taxa de amostragem maior, o espaço enche e começa
a transbordar mais cedo do que teria se uma taxa de amostragem
menor fosse usada.
Isso significa que você pode não ter acesso a amostras de CPU
do início do perfil gravado, dependendo
de se o buffer transborda durante o tempo de gravação.

Um perfil que foi gravado com uma taxa de amostragem menor
produz um perfil de CPU mais grosseiro com menos amostras.
Isso afeta menos a performance do seu app,
mas você pode ter acesso a menos informações sobre o que
a CPU estava fazendo durante o tempo do perfil.
O buffer de amostras da VM também enche mais lentamente, então você pode ver
amostras de CPU por um período mais longo de tempo de execução do app.
Isso significa que você tem uma chance melhor de visualizar amostras
de CPU do início do perfil gravado.

### Filtragem

Ao visualizar um perfil de CPU, você pode filtrar os dados por
biblioteca, nome de método ou [`UserTag`][].

![Screenshot of filter by tag menu](/assets/images/docs/tools/devtools/filter-by-tag.png)

[`UserTag`]: {{site.api}}/flutter/dart-developer/UserTag-class.html

## Guidelines

Ao olhar para uma visualização de call tree ou bottom up,
às vezes as árvores podem ser muito profundas.
Para ajudar com a visualização de relacionamentos pai-filho em uma árvore profunda,
habilite a opção **Display guidelines**.
Isso adiciona diretrizes verticais entre pai e filho na árvore.

![Screenshot of display options](/assets/images/docs/tools/devtools/display-options.png)

[analyze performance]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/

## Outros recursos

Para aprender como usar DevTools para analisar
o uso de CPU de um app Mandelbrot de computação intensiva,
confira um [tutorial guiado da CPU Profiler View][profiler-tutorial].
Além disso, aprenda como analisar o uso de CPU quando o app
usa isolates para computação paralela.

[profiler-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-cpu-profiler-view-part-6-of-8-31e24eae6bf8
