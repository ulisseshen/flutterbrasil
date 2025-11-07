---
ia-translate: true
title: Usar a visualização Memory
description: Aprenda como usar a visualização de memória do DevTools.
---

A visualização de memória fornece insights sobre detalhes
da alocação de memória da aplicação e
ferramentas para detectar e depurar problemas específicos.

:::note
Esta página está atualizada para DevTools 2.23.0.
:::

Para informações sobre como localizar telas DevTools em diferentes IDEs,
confira a [visão geral do DevTools](/tools/devtools).

Para entender melhor os insights encontrados nesta página,
a primeira seção explica como Dart gerencia memória.
Se você já entende o gerenciamento de memória do Dart,
você pode pular para o [guia da visualização Memory](#memory-view-guide).

## Razões para usar a visualização de memória

Use a visualização de memória para otimização preventiva de memória ou quando
sua aplicação experimenta uma das seguintes condições:

* Trava quando fica sem memória
* Fica lenta
* Faz o dispositivo ficar lento ou não responsivo
* Desliga porque excedeu o limite de memória, imposto pelo sistema operacional
* Excede o limite de uso de memória
  * Este limite pode variar dependendo do tipo de dispositivos que seu app segmenta.
* Suspeita de vazamento de memória

## Conceitos básicos de memória

Objetos Dart criados usando um construtor de classe
(por exemplo, usando `MyClass()`) vivem em uma
porção de memória chamada _heap_. A memória
no heap é gerenciada pela Dart VM (máquina virtual).
A Dart VM aloca memória para o objeto no momento da criação do objeto,
e libera (ou desaloca) a memória quando o objeto
não é mais usado (veja [coleta de lixo Dart][Dart garbage collection]).

[Dart garbage collection]: {{site.medium}}/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30

### Tipos de objetos

#### Objeto descartável

Um objeto descartável é qualquer objeto Dart que define um método `dispose()`.
Para evitar vazamentos de memória, invoque `dispose` quando o objeto não for mais necessário.

#### Objeto de risco de memória

Um objeto de risco de memória é um objeto que _pode_ causar um vazamento de memória,
se não for descartado adequadamente ou descartado mas não coletado pelo GC.

### Objeto raiz, caminho de retenção e alcançabilidade

#### Objeto raiz

Toda aplicação Dart cria um _objeto raiz_ que referencia,
direta ou indiretamente, todos os outros objetos que a aplicação aloca.

#### Alcançabilidade

Se, em algum momento da execução da aplicação,
o objeto raiz para de referenciar um objeto alocado,
o objeto torna-se _inalcançável_,
que é um sinal para o coletor de lixo (GC)
desalocar a memória do objeto.

#### Caminho de retenção

A sequência de referências da raiz para um objeto
é chamada de _caminho de retenção_ do objeto,
pois retém a memória do objeto da coleta de lixo.
Um objeto pode ter muitos caminhos de retenção.
Objetos com pelo menos um caminho de retenção são
chamados de objetos _alcançáveis_.

#### Exemplo

O seguinte exemplo ilustra os conceitos:

```dart
class Child{}

class Parent {
  Child? child;
}

Parent parent1 = Parent();

void myFunction() {

  Child? child = Child();

  // O objeto `child` foi alocado na memória.
  // Ele agora está retido da coleta de lixo
  // por um caminho de retenção (root …-> myFunction -> child).

  Parent? parent2 = Parent()..child = child;
  parent1.child = child;

  // Neste ponto o objeto `child` tem três caminhos de retenção:
  // root …-> myFunction -> child
  // root …-> myFunction -> parent2 -> child
  // root -> parent1 -> child

  child = null;
  parent1.child = null;
  parent2 = null;

  // Neste ponto, a instância `child` está inalcançável
  // e eventualmente será coletada pelo garbage collector.

  …
}
```

### Tamanho raso vs tamanho retido

**Tamanho raso** inclui apenas o tamanho do objeto
e suas referências, enquanto **tamanho retido** também inclui
o tamanho dos objetos retidos.

O **tamanho retido** do objeto raiz inclui
todos os objetos Dart alcançáveis.

No seguinte exemplo, o tamanho de `myHugeInstance`
não faz parte dos tamanhos rasos do pai ou do filho,
mas faz parte de seus tamanhos retidos:

```dart
class Child{
  /// A instância faz parte dos tamanhos retidos de
  /// tanto [parent] quanto [parent.child].
  final myHugeInstance = MyHugeInstance();
}

class Parent {
  Child? child;
}

Parent parent = Parent()..child = Child();
```

Nos cálculos DevTools, se um objeto tem mais
de um caminho de retenção, seu tamanho é atribuído como
retido apenas aos membros do caminho de retenção mais curto.

Neste exemplo o objeto `x` tem dois caminhos de retenção:

```console
root -> a -> b -> c -> x
root -> d -> e -> x (caminho de retenção mais curto para `x`)
```

Apenas membros do caminho mais curto (`d` e `e`) incluirão
`x` em seu tamanho retido.

### Vazamentos de memória acontecem em Dart?

O coletor de lixo não pode prevenir todos os tipos de vazamentos de memória, e desenvolvedores
ainda precisam observar objetos para ter um ciclo de vida livre de vazamentos.

#### Por que o coletor de lixo não pode prevenir todos os vazamentos?

Enquanto o coletor de lixo cuida de todos os
objetos inalcançáveis, é responsabilidade
da aplicação garantir que objetos desnecessários
não sejam mais alcançáveis (referenciados pela raiz).

Então, se objetos não necessários são deixados referenciados
(em uma variável global ou estática,
ou como um campo de um objeto de longa duração),
o coletor de lixo não pode reconhecê-los,
a alocação de memória cresce progressivamente,
e o app eventualmente trava com um erro `out-of-memory`.

#### Por que closures requerem atenção extra

Um padrão de vazamento difícil de capturar relaciona-se ao uso de closures.
No seguinte código, uma referência ao
projetado-para-ser-de-curta-duração `myHugeObject` é implicitamente
armazenada no contexto do closure e passada para `setHandler`.
Como resultado, `myHugeObject` não será coletado pelo garbage collector
enquanto `handler` for alcançável.

```dart
  final handler = () => print(myHugeObject.name);
  setHandler(handler);
```

#### Por que `BuildContext` requer atenção extra

Um exemplo de um objeto grande e de curta duração que
pode se espremer em uma área de longa duração e assim causar vazamentos,
é o parâmetro `context` passado para o método `build`
do Flutter.

O seguinte código é propenso a vazamentos,
pois `useHandler` pode armazenar o handler
em uma área de longa duração:

```dart
// RUIM: NÃO FAÇA ISSO
// Este código é propenso a vazamentos:
@override
Widget build(BuildContext context) {
  final handler = () => apply(Theme.of(context));
  useHandler(handler);
…
```

#### Como corrigir código propenso a vazamentos?

O seguinte código não é propenso a vazamentos,
porque:

1. O closure não usa o objeto `context` grande e de curta duração.
2. O objeto `theme` (usado no lugar) é de longa duração. Ele é criado uma vez e
compartilhado entre instâncias de `BuildContext`.


```dart
// BOM
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  final handler = () => apply(theme);
  useHandler(handler);
…
```

#### Regra geral para `BuildContext`

Em geral, use a seguinte regra para um
`BuildContext`: se o closure não sobrevive
ao widget, está ok passar o context para o closure.

Widgets stateful requerem atenção extra.
Eles consistem de duas classes: o [widget e o
estado do widget][interactive],
onde o widget é de curta duração,
e o estado é de longa duração. O build context,
pertencente ao widget, nunca deve ser referenciado
dos campos do estado, pois o estado não será coletado
pelo garbage collector junto com o widget, e pode sobrevivê-lo significativamente.

[interactive]: /ui/interactivity#creating-a-stateful-widget

### Vazamento de memória vs inchaço de memória

Em um vazamento de memória, uma aplicação progressivamente usa memória,
por exemplo, criando repetidamente um listener,
mas não descartando-o.

Inchaço de memória usa mais memória do que é necessário para
performance ideal, por exemplo, usando imagens excessivamente grandes
ou mantendo streams abertos durante sua vida útil.

Tanto vazamentos quanto inchaços, quando grandes,
fazem uma aplicação travar com um erro `out-of-memory`.
No entanto, vazamentos são mais propensos a causar problemas de memória,
porque mesmo um pequeno vazamento,
se repetido muitas vezes, leva a uma falha.

## Guia da visualização Memory

A visualização de memória DevTools ajuda você a investigar
alocações de memória (tanto no heap quanto externa),
vazamentos de memória, inchaço de memória e muito mais. A visualização
tem os seguintes recursos:

[**Gráfico expansível**](#expandable-chart)
: Obtenha um rastreamento de alto nível de alocação de memória,
  e visualize tanto eventos padrão (como coleta de lixo)
  quanto eventos personalizados (como alocação de imagem).

[**Aba Profile Memory**](#profile-memory-tab)
: Veja a alocação de memória atual listada por classe e
  tipo de memória.

[**Aba Diff Snapshots**](#diff-snapshots-tab)
: Detecte e investigue problemas de gerenciamento de memória de um recurso.

[**Aba Trace Instances**](#trace-instances-tab)
: Investigue o gerenciamento de memória de um recurso para
  um conjunto especificado de classes.

### Gráfico expansível

O gráfico expansível fornece os seguintes recursos:

#### Anatomia da memória

Um gráfico de série temporal visualiza o estado da
memória Flutter em intervalos sucessivos de tempo.
Cada ponto de dados no gráfico corresponde ao
timestamp (eixo x) de quantidades medidas (eixo y)
do heap. Por exemplo, uso, capacidade, externa,
coleta de lixo e resident set size são capturados.

![Screenshot of a memory anatomy page](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

#### Gráfico de visão geral da memória

O gráfico de visão geral da memória é um gráfico de série temporal
de estatísticas de memória coletadas. Ele apresenta visualmente
o estado do heap Dart ou Flutter e da memória nativa
do Dart ou Flutter ao longo do tempo.

O eixo x do gráfico é uma linha do tempo de eventos (série temporal).
Os dados plotados no eixo y todos têm um timestamp de
quando os dados foram coletados. Em outras palavras,
mostra o estado pesquisado (capacidade, usado, externo,
RSS (resident set size) e GC (garbage collection))
da memória a cada 500 ms. Isso ajuda a fornecer uma aparência
ao vivo sobre o estado da memória conforme a aplicação está executando.

Clicar no botão **Legend** exibe as
medições coletadas, símbolos e cores
usados para exibir os dados.

![Screenshot of a memory anatomy page](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

A **Memory Size Scale** do eixo y ajusta automaticamente
para o intervalo de dados coletados no
intervalo do gráfico visível atual.

As quantidades plotadas no eixo y são as seguintes:

**Dart/Flutter Heap**
: Objetos (objetos Dart e Flutter) no heap.

**Dart/Flutter Native**
: Memória que não está no heap Dart/Flutter
  mas ainda faz parte do espaço de memória total.
  Objetos nesta memória seriam objetos nativos
  (por exemplo, de ler um arquivo na memória,
  ou uma imagem decodificada). Os objetos nativos são expostos
  à Dart VM do SO nativo (como Android,
  Linux, Windows, iOS) usando um embedder Dart.
  O embedder cria um wrapper Dart com um finalizador,
  permitindo que código Dart se comunique com esses recursos nativos.
  Flutter tem um embedder para Android e iOS.
  Para mais informações, veja [Aplicativos de linha de comando e servidor][Command-line and server apps],
  [Dart no servidor com Dart Frog][frog],
  [Custom Flutter Engine Embedders][],
  [Implantação de servidor web Dart com Heroku][heroku].

**Timeline**
: Os timestamps de todas as estatísticas e eventos de memória
  coletados em um determinado ponto no tempo (timestamp).

**Raster Cache**
: O tamanho das camadas de raster cache da engine Flutter
  ou imagens, ao realizar a
  renderização final após composição.
  Para mais informações, veja a
  [visão geral arquitetônica do Flutter][Flutter architectural overview]
  e [visualização Performance do DevTools][DevTools Performance view].

**Allocated**
: A capacidade atual do heap é tipicamente
  ligeiramente maior do que o tamanho total de todos os objetos do heap.

**RSS - Resident Set Size**
: O resident set size exibe a quantidade de memória
  para um processo.
  Não inclui memória que é trocada para fora.
  Inclui memória de bibliotecas compartilhadas que são
  carregadas, bem como toda memória de stack e heap.
  Para mais informações, veja [internos da Dart VM][Dart VM internals].

[Command-line and server apps]: {{site.dart-site}}/server
[Custom Flutter engine embedders]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/Custom-Flutter-Engine-Embedders.md
[Dart VM internals]: https://mrale.ph/dartvm/
[DevTools Performance view]: /tools/devtools/performance
[Flutter architectural overview]: /resources/architectural-overview
[frog]: https://dartfrog.vgv.dev/
[heroku]: {{site.yt.watch}}?v=nkTUMVNelXA

<a id="profile-tab" aria-hidden="true"></a>

### Aba Profile Memory

Use a aba **Profile Memory** para ver a alocação de memória
atual por classe e tipo de memória. Para uma
análise mais profunda no Google Sheets ou outras ferramentas,
baixe os dados em formato CSV.
Alterne **Refresh on GC**, para ver alocação em tempo real.

![Screenshot of the profile tab page](/assets/images/docs/tools/devtools/profile-tab-2.png){:width="100%"}

### Aba Diff Snapshots

Use a aba **Diff Snapshots** para investigar o gerenciamento
de memória de um recurso. Siga a orientação na aba
para tirar snapshots antes e depois da interação
com a aplicação, e fazer diff dos snapshots:

![Screenshot of the diff tab page](/assets/images/docs/tools/devtools/diff-tab.png){:width="100%"}

Toque no botão **Filter classes and packages**,
para restringir os dados:

![Screenshot of the filter options ui](/assets/images/docs/tools/devtools/filter-ui.png)

Para uma análise mais profunda no Google Sheets
ou outras ferramentas, baixe os dados em formato CSV.

<a id="trace-tab" aria-hidden="true"></a>

### Aba Trace Instances

Use a aba **Trace Instances** para investigar quais métodos
alocam memória para um conjunto de classes durante a execução de recursos:

1. Selecione classes para rastrear
1. Interaja com seu app para acionar o código
   que você está interessado
1. Toque em **Refresh**
1. Selecione uma classe rastreada
1. Revise os dados coletados

![Screenshot of a trace tab](/assets/images/docs/tools/devtools/trace-instances-tab.png){:width="100%"}

#### Visualização bottom up vs call tree

Alterne entre visualizações bottom-up e call tree
dependendo das especificidades das suas tarefas.

![Screenshot of a trace allocations](/assets/images/docs/tools/devtools/trace-view.png)

A visualização call tree mostra as alocações de método
para cada instância. A visualização é uma representação top-down
da call stack, significando que um método pode ser expandido
para mostrar seus chamados.

A visualização bottom-up mostra a lista de diferentes
call stacks que alocaram as instâncias.

## Outros recursos

Para mais informações, confira os seguintes recursos:

* Para aprender como monitorar o uso de memória de um app
  e detectar vazamentos de memória usando DevTools,
  confira um [tutorial guiado da Memory View][memory-tutorial].
* Para entender a estrutura de memória do Android,
  confira [Android: Memory allocation among processes][].

[memory-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-memory-view-part-7-of-8-e7f5aaf07e15
[Android: Memory allocation among processes]: {{site.android-dev}}/topic/performance/memory-management
