---
ia-translate: true
title: Use a visualização Memory
description: Aprenda a usar a visualização memory do DevTools.
---

A visualização memory fornece insights sobre detalhes
da alocação de memória da aplicação e
ferramentas para detectar e depurar problemas específicos.

:::note
Esta página está atualizada para o DevTools 2.23.0.
:::

Para informações sobre como localizar as telas do DevTools em diferentes IDEs,
consulte a [visão geral do DevTools][DevTools overview].

Para entender melhor os insights encontrados nesta página,
a primeira seção explica como o Dart gerencia memória.
Se você já entende o gerenciamento de memória do Dart,
você pode pular para o [guia da visualização Memory](#memory-view-guide).

## Razões para usar a visualização memory

Use a visualização memory para otimização de memória preventiva ou quando
sua aplicação experimenta uma das seguintes condições:

* Trava quando fica sem memória
* Torna-se lenta
* Faz com que o dispositivo fique lento ou não responsivo
* É encerrada porque excedeu o limite de memória, imposto pelo sistema operacional
* Excede o limite de uso de memória
  * Este limite pode variar dependendo do tipo de dispositivos que seu app visa.
* Suspeita de vazamento de memória

## Conceitos básicos de memória

Objetos Dart criados usando um construtor de classe
(por exemplo, usando `MyClass()`) vivem em uma
porção de memória chamada _heap_. A memória
no heap é gerenciada pela Dart VM (máquina virtual).
A Dart VM aloca memória para o objeto no momento da criação do objeto,
e libera (ou desaloca) a memória quando o objeto
não é mais usado (veja [Dart garbage collection]).

[Dart garbage collection]: {{site.medium}}/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30

### Tipos de objetos

#### Objeto descartável

Um objeto descartável é qualquer objeto Dart que define um método `dispose()`.
Para evitar vazamentos de memória, invoque `dispose` quando o objeto não for mais necessário.

#### Objeto com risco de memória

Um objeto com risco de memória é um objeto que _pode_ causar um vazamento de memória,
se não for descartado corretamente ou descartado mas não coletado pelo GC.

### Objeto raiz, caminho de retenção e alcançabilidade

#### Objeto raiz

Toda aplicação Dart cria um _objeto raiz_ que referencia,
direta ou indiretamente, todos os outros objetos que a aplicação aloca.

#### Alcançabilidade

Se, em algum momento da execução da aplicação,
o objeto raiz parar de referenciar um objeto alocado,
o objeto torna-se _inalcançável_,
o que é um sinal para o coletor de lixo (GC)
desalocar a memória do objeto.

#### Caminho de retenção

A sequência de referências da raiz para um objeto
é chamada de _caminho de retenção_ do objeto,
pois retém a memória do objeto da coleta de lixo.
Um objeto pode ter muitos caminhos de retenção.
Objetos com pelo menos um caminho de retenção são
chamados de objetos _alcançáveis_.

#### Exemplo

O exemplo a seguir ilustra os conceitos:

```dart
class Child{}

class Parent {
  Child? child;
}

Parent parent1 = Parent();

void myFunction() {

  Child? child = Child();

  // The `child` object was allocated in memory.
  // It's now retained from garbage collection
  // by one retaining path (root …-> myFunction -> child).

  Parent? parent2 = Parent()..child = child;
  parent1.child = child;

  // At this point the `child` object has three retaining paths:
  // root …-> myFunction -> child
  // root …-> myFunction -> parent2 -> child
  // root -> parent1 -> child

  child = null;
  parent1.child = null;
  parent2 = null;

  // At this point, the `child` instance is unreachable
  // and will eventually be garbage collected.

  …
}
```

### Tamanho superficial vs tamanho retido

**Tamanho superficial** inclui apenas o tamanho do objeto
e suas referências, enquanto **tamanho retido** também inclui
o tamanho dos objetos retidos.

O **tamanho retido** do objeto raiz inclui
todos os objetos Dart alcançáveis.

No exemplo a seguir, o tamanho de `myHugeInstance`
não faz parte dos tamanhos superficiais do pai ou do filho,
mas faz parte de seus tamanhos retidos:

```dart
class Child{
  /// The instance is part of both [parent] and [parent.child]
  /// retained sizes.
  final myHugeInstance = MyHugeInstance();
}

class Parent {
  Child? child;
}

Parent parent = Parent()..child = Child();
```

Nos cálculos do DevTools, se um objeto tem mais
de um caminho de retenção, seu tamanho é atribuído como
retido apenas aos membros do caminho de retenção mais curto.

Neste exemplo, o objeto `x` tem dois caminhos de retenção:

```console
root -> a -> b -> c -> x
root -> d -> e -> x (shortest retaining path to `x`)
```

Apenas membros do caminho mais curto (`d` e `e`) incluirão
`x` em seu tamanho retido.

### Vazamentos de memória acontecem no Dart?

O coletor de lixo não pode prevenir todos os tipos de vazamentos de memória, e desenvolvedores
ainda precisam observar objetos para ter um ciclo de vida livre de vazamentos.

#### Por que o coletor de lixo não pode prevenir todos os vazamentos?

Embora o coletor de lixo cuide de todos os
objetos inalcançáveis, é responsabilidade
da aplicação garantir que objetos desnecessários
não sejam mais alcançáveis (referenciados da raiz).

Então, se objetos não necessários são deixados referenciados
(em uma variável global ou estática,
ou como um campo de um objeto de longa vida),
o coletor de lixo não pode reconhecê-los,
a alocação de memória cresce progressivamente,
e o app eventualmente trava com um erro `out-of-memory`.

#### Por que closures requerem atenção extra

Um padrão de vazamento difícil de detectar está relacionado ao uso de closures.
No código a seguir, uma referência ao
`myHugeObject` projetado para ser de curta duração é implicitamente
armazenada no contexto do closure e passada para `setHandler`.
Como resultado, `myHugeObject` não será coletado pelo garbage collector
enquanto `handler` for alcançável.

```dart
  final handler = () => print(myHugeObject.name);
  setHandler(handler);
```
#### Por que `BuildContext` requer atenção extra

Um exemplo de um objeto grande e de curta duração que
pode se infiltrar em uma área de longa duração e assim causar vazamentos,
é o parâmetro `context` passado para o método
`build` do Flutter.

O código a seguir é propenso a vazamentos,
pois `useHandler` pode armazenar o handler
em uma área de longa duração:

```dart
// BAD: DO NOT DO THIS
// This code is leak prone:
@override
Widget build(BuildContext context) {
  final handler = () => apply(Theme.of(context));
  useHandler(handler);
…
```

#### Como corrigir código propenso a vazamentos?

O código a seguir não é propenso a vazamentos,
porque:

1. O closure não usa o objeto `context` grande e de curta duração.
2. O objeto `theme` (usado no lugar) é de longa duração. Ele é criado uma vez e
compartilhado entre instâncias de `BuildContext`.


```dart
// GOOD
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
ao widget, não há problema em passar o contexto para o closure.

Widgets stateful requerem atenção extra.
Eles consistem de duas classes: o [widget e o
estado do widget][interactive],
onde o widget é de curta duração,
e o estado é de longa duração. O contexto de build,
pertencente ao widget, nunca deve ser referenciado
dos campos do estado, pois o estado não será coletado pelo garbage collector
junto com o widget, e pode sobreviver a ele significativamente.

[interactive]: /ui/interactivity#creating-a-stateful-widget

### Vazamento de memória vs inchaço de memória

Em um vazamento de memória, uma aplicação usa memória progressivamente,
por exemplo, criando repetidamente um listener,
mas não descartando-o.

Inchaço de memória usa mais memória do que o necessário para
desempenho ideal, por exemplo, usando imagens excessivamente grandes
ou mantendo streams abertos durante todo o seu tempo de vida.

Tanto vazamentos quanto inchaços, quando grandes,
fazem com que uma aplicação trave com um erro `out-of-memory`.
No entanto, vazamentos são mais propensos a causar problemas de memória,
porque mesmo um pequeno vazamento,
se repetido muitas vezes, leva a uma travamento.

## Guia da visualização Memory

A visualização memory do DevTools ajuda você a investigar
alocações de memória (tanto no heap quanto externas),
vazamentos de memória, inchaço de memória e muito mais. A visualização
tem os seguintes recursos:

[**Gráfico expansível**](#expandable-chart)
: Obtenha um rastreamento de alto nível da alocação de memória,
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

Um gráfico de séries temporais visualiza o estado da
memória Flutter em intervalos sucessivos de tempo.
Cada ponto de dados no gráfico corresponde ao
timestamp (eixo x) de quantidades medidas (eixo y)
do heap. Por exemplo, uso, capacidade, externo,
coleta de lixo e tamanho do conjunto residente são capturados.

![Screenshot of a memory anatomy page](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

#### Gráfico de visão geral da memória

O gráfico de visão geral da memória é um gráfico de séries temporais
de estatísticas de memória coletadas. Ele apresenta visualmente
o estado do heap do Dart ou Flutter e da memória nativa
do Dart ou Flutter ao longo do tempo.

O eixo x do gráfico é uma linha do tempo de eventos (séries temporais).
Os dados plotados no eixo y todos têm um timestamp de
quando os dados foram coletados. Em outras palavras,
ele mostra o estado pesquisado (capacidade, usado, externo,
RSS (tamanho do conjunto residente) e GC (coleta de lixo))
da memória a cada 500 ms. Isso ajuda a fornecer uma aparência
ao vivo do estado da memória enquanto a aplicação está em execução.

Clicar no botão **Legend** exibe as
medições coletadas, símbolos e cores
usados para exibir os dados.

![Screenshot of a memory anatomy page](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

A **Escala de Tamanho de Memória** do eixo y automaticamente
se ajusta ao intervalo de dados coletados no
intervalo do gráfico visível atual.

As quantidades plotadas no eixo y são as seguintes:

**Dart/Flutter Heap**
: Objetos (objetos Dart e Flutter) no heap.

**Dart/Flutter Native**
: Memória que não está no heap Dart/Flutter
  mas ainda faz parte do total de memória.
  Objetos nesta memória seriam objetos nativos
  (por exemplo, de ler um arquivo para a memória,
  ou uma imagem decodificada). Os objetos nativos são expostos
  à Dart VM a partir do sistema operacional nativo (como Android,
  Linux, Windows, iOS) usando um embedder Dart.
  O embedder cria um wrapper Dart com um finalizador,
  permitindo que código Dart se comunique com esses recursos nativos.
  Flutter tem um embedder para Android e iOS.
  Para mais informações, veja [Command-line and server apps],
  [Dart on the server with Dart Frog][frog],
  [Custom Flutter Engine Embedders],
  [Dart web server deployment with Heroku][heroku].

**Timeline**
: Os timestamps de todas as estatísticas de memória coletadas
  e eventos em um determinado momento (timestamp).

**Raster Cache**
: O tamanho das camadas ou imagens do cache raster
  do motor Flutter, ao realizar a
  renderização final após composição.
  Para mais informações, veja a
  [visão geral da arquitetura Flutter][Flutter architectural overview]
  e [visualização Performance do DevTools][DevTools Performance view].

**Allocated**
: A capacidade total atual de todos os heaps Dart. Isso é tipicamente
  um pouco maior que o tamanho total de todos os objetos do heap.

**RSS - Resident Set Size**
: O tamanho do conjunto residente exibe a quantidade de memória
  para um processo.
  Não inclui memória que está em swap.
  Inclui memória de bibliotecas compartilhadas que estão
  carregadas, assim como toda memória de pilha e heap.
  Para mais informações, veja [Dart VM internals].

[Command-line and server apps]: {{site.dart-site}}/server
[Custom Flutter engine embedders]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/Custom-Flutter-Engine-Embedders.md
[Dart VM internals]: https://mrale.ph/dartvm/
[DevTools Performance view]: /tools/devtools/performance
[Flutter architectural overview]: /resources/architectural-overview
[frog]: https://dartfrog.vgv.dev/
[heroku]: {{site.yt.watch}}?v=nkTUMVNelXA

<a id="profile-tab" aria-hidden="true"></a>

### Aba Profile Memory

Use a aba **Profile Memory** para ver a alocação de memória atual
por classe e tipo de memória. Para uma
análise mais profunda no Google Sheets ou outras ferramentas,
baixe os dados no formato CSV.
Alterne **Refresh on GC**, para ver a alocação em tempo real.

![Screenshot of the profile tab page](/assets/images/docs/tools/devtools/profile-tab.png){:width="100%"}

### Aba Diff Snapshots

Use a aba **Diff Snapshots** para investigar o gerenciamento
de memória de um recurso. Siga a orientação na aba
para tirar snapshots antes e depois da interação
com a aplicação, e comparar os snapshots:

![Screenshot of the diff tab page](/assets/images/docs/tools/devtools/diff-tab.png){:width="100%"}

Toque no botão **Filter classes and packages**,
para restringir os dados:

![Screenshot of the filter options ui](/assets/images/docs/tools/devtools/filter-ui.png)

Para uma análise mais profunda no Google Sheets
ou outras ferramentas, baixe os dados no formato CSV.

<a id="trace-tab" aria-hidden="true"></a>

### Aba Trace Instances

Use a aba **Trace Instances** para investigar quais métodos
alocam memória para um conjunto de classes durante a execução do recurso:

1. Selecione classes para rastrear
1. Interaja com seu app para acionar o código
   no qual você está interessado
1. Toque em **Refresh**
1. Selecione uma classe rastreada
1. Revise os dados coletados

![Screenshot of a trace tab](/assets/images/docs/tools/devtools/trace-instances-tab.png){:width="100%"}

#### Visualização bottom up vs call tree

Alterne entre visualizações bottom-up e call tree
dependendo das especificidades de suas tarefas.

![Screenshot of a trace allocations](/assets/images/docs/tools/devtools/trace-view.png)

A visualização call tree mostra as alocações de método
para cada instância. A visualização é uma representação top-down
da pilha de chamadas, o que significa que um método pode ser expandido
para mostrar suas chamadas.

A visualização bottom-up mostra a lista de diferentes
pilhas de chamadas que alocaram as instâncias.

## Outros recursos

Para mais informações, confira os seguintes recursos:

* Para aprender como monitorar o uso de memória de um app
  e detectar vazamentos de memória usando DevTools,
  confira um tutorial guiado da [visualização Memory][memory-tutorial].
* Para entender a estrutura de memória do Android,
  confira [Android: Memory allocation among processes].

[DevTools overview]: /tools/devtools
[memory-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-memory-view-part-7-of-8-e7f5aaf07e15
[Android: Memory allocation among processes]: {{site.android-dev}}/topic/performance/memory-management
