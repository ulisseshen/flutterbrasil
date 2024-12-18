---
ia-translate: true
title: Use a visualização de memória
description: Aprenda como usar a visualização de memória do DevTools.
---

A visualização de memória fornece insights sobre detalhes da alocação de memória do aplicativo e ferramentas para detectar e depurar problemas específicos.

:::note
Esta página está atualizada para o DevTools 2.23.0.
:::

Para obter informações sobre como localizar as telas do DevTools em diferentes IDEs, consulte a [visão geral do DevTools](/tools/devtools).

Para entender melhor os insights encontrados nesta página, a primeira seção explica como o Dart gerencia a memória. Se você já entende o gerenciamento de memória do Dart, pode pular para o [guia de visualização de memória](#memory-view-guide).

## Razões para usar a visualização de memória

Use a visualização de memória para otimização preventiva de memória ou quando seu aplicativo apresentar uma das seguintes condições:

* Falhas ao ficar sem memória
* Lentidão
* Faz com que o dispositivo fique lento ou não responsivo
* Desligamento porque excedeu o limite de memória, imposto pelo sistema operacional
* Excede o limite de uso de memória
  * Este limite pode variar dependendo do tipo de dispositivos que seu aplicativo visa.
* Suspeita de um vazamento de memória

## Conceitos básicos de memória

Objetos Dart criados usando um construtor de classe (por exemplo, usando `MyClass()`) vivem em uma porção de memória chamada _heap_. A memória no heap é gerenciada pela VM (máquina virtual) do Dart. A VM do Dart aloca memória para o objeto no momento da criação do objeto e libera (ou desaloca) a memória quando o objeto não é mais usado (consulte [Coleta de lixo do Dart][]).

[Coleta de lixo do Dart]: {{site.medium}}/flutter/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30

### Tipos de objeto

#### Objeto descartável

Um objeto descartável é qualquer objeto Dart que define um método `dispose()`. Para evitar vazamentos de memória, invoque `dispose` quando o objeto não for mais necessário.

#### Objeto de risco de memória

Um objeto de risco de memória é um objeto que _pode_ causar um vazamento de memória, se não for descartado corretamente ou descartado, mas não coletado pelo GC.

### Objeto raiz, caminho de retenção e alcance

#### Objeto raiz

Todo aplicativo Dart cria um _objeto raiz_ que referencia, direta ou indiretamente, todos os outros objetos que o aplicativo aloca.

#### Alcance

Se, em algum momento da execução do aplicativo, o objeto raiz parar de referenciar um objeto alocado, o objeto se tornará _inalcançável_, o que é um sinal para o coletor de lixo (GC) desalocar a memória do objeto.

#### Caminho de retenção

A sequência de referências da raiz a um objeto é chamada de caminho de _retenção_ do objeto, pois retém a memória do objeto da coleta de lixo. Um objeto pode ter muitos caminhos de retenção. Objetos com pelo menos um caminho de retenção são chamados de objetos _alcançáveis_.

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

  // O objeto `child` foi alocado na memória.
  // Ele agora é retido da coleta de lixo
  // por um caminho de retenção (raiz ...-> myFunction -> child).

  Parent? parent2 = Parent()..child = child;
  parent1.child = child;

  // Neste ponto, o objeto `child` tem três caminhos de retenção:
  // root ...-> myFunction -> child
  // root ...-> myFunction -> parent2 -> child
  // root -> parent1 -> child

  child = null;
  parent1.child = null;
  parent2 = null;

  // Neste ponto, a instância `child` é inalcançável
  // e acabará sendo coletada pelo lixo.

  …
}
```

### Tamanho raso vs. tamanho retido

O **tamanho raso** inclui apenas o tamanho do objeto e suas referências, enquanto o **tamanho retido** também inclui o tamanho dos objetos retidos.

O **tamanho retido** do objeto raiz inclui todos os objetos Dart alcançáveis.

No exemplo a seguir, o tamanho de `myHugeInstance` não faz parte dos tamanhos rasos do pai ou do filho, mas faz parte de seus tamanhos retidos:

```dart
class Child{
  /// A instância faz parte dos tamanhos retidos de [parent] e [parent.child].
  /// tamanhos retidos.
  final myHugeInstance = MyHugeInstance();
}

class Parent {
  Child? child;
}

Parent parent = Parent()..child = Child();
```

Nos cálculos do DevTools, se um objeto tiver mais de um caminho de retenção, seu tamanho será atribuído como retido apenas aos membros do caminho de retenção mais curto.

Neste exemplo, o objeto `x` tem dois caminhos de retenção:

```console
raiz -> a -> b -> c -> x
raiz -> d -> e -> x (caminho de retenção mais curto para `x`)
```

Apenas os membros do caminho mais curto (`d` e `e`) incluirão `x` em seu tamanho retido.

### Vazamentos de memória acontecem no Dart?

O coletor de lixo não pode impedir todos os tipos de vazamentos de memória, e os desenvolvedores ainda precisam observar os objetos para ter um ciclo de vida livre de vazamentos.

#### Por que o coletor de lixo não pode impedir todos os vazamentos?

Embora o coletor de lixo cuide de todos os objetos inalcançáveis, é responsabilidade do aplicativo garantir que objetos desnecessários não sejam mais alcançáveis (referenciados da raiz).

Assim, se objetos não necessários forem deixados referenciados (em uma variável global ou estática, ou como um campo de um objeto de longa duração), o coletor de lixo não poderá reconhecê-los, a alocação de memória cresce progressivamente e o aplicativo acaba falhando com um erro `out-of-memory`.

#### Por que os closures exigem atenção extra

Um padrão de vazamento difícil de detectar está relacionado ao uso de closures. No código a seguir, uma referência ao `myHugeObject` de curta duração é armazenada implicitamente no contexto do closure e passada para `setHandler`. Como resultado, `myHugeObject` não será coletado pelo lixo enquanto `handler` for alcançável.

```dart
  final handler = () => print(myHugeObject.name);
  setHandler(handler);
```
#### Por que `BuildContext` exige atenção extra

Um exemplo de um objeto grande e de curta duração que pode se espremer em uma área de longa duração e, assim, causar vazamentos, é o parâmetro `context` passado para o método `build` do Flutter.

O código a seguir é propenso a vazamentos, pois `useHandler` pode armazenar o handler em uma área de longa duração:

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

O código a seguir não é propenso a vazamentos, porque:

1. O closure não usa o objeto `context` grande e de curta duração.
2. O objeto `theme` (usado em vez disso) é de longa duração. Ele é criado uma vez e compartilhado entre as instâncias `BuildContext`.

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

Em geral, use a seguinte regra para um `BuildContext`: se o closure não sobreviver ao widget, não há problema em passar o contexto para o closure.

Widgets com estado exigem atenção extra. Eles consistem em duas classes: o [widget e o estado do widget][interactive], onde o widget é de curta duração e o estado é de longa duração. O contexto de construção, pertencente ao widget, nunca deve ser referenciado nos campos do estado, pois o estado não será coletado pelo lixo junto com o widget e pode sobreviver significativamente a ele.

[interactive]: /ui/interactivity#creating-a-stateful-widget

### Vazamento de memória vs. inchaço de memória

Em um vazamento de memória, um aplicativo usa progressivamente a memória, por exemplo, criando repetidamente um listener, mas não descartando-o.

O inchaço de memória usa mais memória do que o necessário para o desempenho ideal, por exemplo, usando imagens excessivamente grandes ou mantendo streams abertos durante toda a sua vida útil.

Tanto vazamentos quanto inchaços, quando grandes, fazem com que um aplicativo falhe com um erro `out-of-memory`. No entanto, é mais provável que os vazamentos causem problemas de memória, porque mesmo um pequeno vazamento, se repetido várias vezes, leva a uma falha.

## Guia da visualização de memória

A visualização de memória do DevTools ajuda você a investigar alocações de memória (tanto no heap quanto externas), vazamentos de memória, inchaço de memória e muito mais. A visualização tem os seguintes recursos:

[**Gráfico expansível**](#expandable-chart)
: Obtenha um rastreamento de alto nível da alocação de memória e visualize eventos padrão (como coleta de lixo) e eventos personalizados (como alocação de imagem).

[**Guia Profile Memory**](#profile-memory-tab)
: Veja a alocação de memória atual listada por classe e tipo de memória.

[**Guia Diff Snapshots**](#diff-snapshots-tab)
: Detecte e investigue problemas de gerenciamento de memória de um recurso.

[**Guia Trace Instances**](#trace-instances-tab)
: Investigue o gerenciamento de memória de um recurso para um conjunto especificado de classes.

### Gráfico expansível

O gráfico expansível fornece os seguintes recursos:

#### Anatomia da memória

Um gráfico de série temporal visualiza o estado da memória Flutter em intervalos sucessivos de tempo. Cada ponto de dados no gráfico corresponde ao timestamp (eixo x) das quantidades medidas (eixo y) do heap. Por exemplo, uso, capacidade, externo, coleta de lixo e tamanho do conjunto residente são capturados.

![Screenshot de uma página de anatomia de memória](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

#### Gráfico de visão geral da memória

O gráfico de visão geral da memória é um gráfico de série temporal de estatísticas de memória coletadas. Ele apresenta visualmente o estado do heap Dart ou Flutter e da memória nativa do Dart ou Flutter ao longo do tempo.

O eixo x do gráfico é uma linha do tempo de eventos (série temporal). Os dados plotados no eixo y têm um timestamp de quando os dados foram coletados. Em outras palavras, ele mostra o estado pesquisado (capacidade, usado, externo, RSS (tamanho do conjunto residente) e GC (coleta de lixo)) da memória a cada 500 ms. Isso ajuda a fornecer uma aparência ao vivo do estado da memória enquanto o aplicativo está em execução.

Clicar no botão **Legenda** exibe as medições coletadas, símbolos e cores usados para exibir os dados.

![Screenshot de uma página de anatomia de memória](/assets/images/docs/tools/devtools/memory_chart_anatomy.png){:width="100%"}

O eixo y da **Escala de Tamanho da Memória** se ajusta automaticamente à variedade de dados coletados no intervalo do gráfico visível atual.

As quantidades plotadas no eixo y são as seguintes:

**Heap Dart/Flutter**
: Objetos (objetos Dart e Flutter) no heap.

**Nativo Dart/Flutter**
: Memória que não está no heap Dart/Flutter, mas ainda faz parte da pegada total de memória. Objetos nesta memória seriam objetos nativos (por exemplo, de leitura de um arquivo na memória ou de uma imagem decodificada). Os objetos nativos são expostos à VM Dart do SO nativo (como Android, Linux, Windows, iOS) usando um embedder Dart. O embedder cria um wrapper Dart com um finalizador, permitindo que o código Dart se comunique com esses recursos nativos. O Flutter tem um embedder para Android e iOS. Para obter mais informações, consulte [Aplicativos de linha de comando e servidor][], [Dart no servidor com Dart Frog][frog], [Embedders personalizados do Flutter Engine][], [Implantação do servidor web Dart com Heroku][heroku].

**Linha do Tempo**
: Os timestamps de todas as estatísticas e eventos de memória coletados em um determinado ponto no tempo (timestamp).

**Cache Raster**
: O tamanho da camada(s) ou imagem(s) do cache raster do mecanismo Flutter, durante a realização da renderização final após a composição. Para obter mais informações, consulte a [visão geral arquitetônica do Flutter][] e [Visualização de desempenho do DevTools][].

**Alocado**
: A capacidade atual do heap é normalmente um pouco maior do que o tamanho total de todos os objetos do heap.

**RSS - Tamanho do Conjunto Residente**
: O tamanho do conjunto residente exibe a quantidade de memória para um processo. Não inclui memória que é trocada. Inclui memória de bibliotecas compartilhadas que são carregadas, bem como toda a memória de pilha e heap. Para obter mais informações, consulte [VM Dart internamente][].

[Aplicativos de linha de comando e servidor]: {{site.dart-site}}/server
[Embedders personalizados do Flutter Engine]: {{site.repo.engine}}/blob/main/docs/Custom-Flutter-Engine-Embedders.md
[VM Dart internamente]: https://mrale.ph/dartvm/
[DevTools Performance view]: /tools/devtools/performance
[visão geral arquitetônica do Flutter]: /resources/architectural-overview
[frog]: https://dartfrog.vgv.dev/
[heroku]: {{site.yt.watch}}?v=nkTUMVNelXA

<a id="profile-tab" aria-hidden="true"></a>

### Guia Profile Memory

Use a guia **Profile Memory** para ver a alocação de memória atual por classe e tipo de memória. Para uma análise mais profunda no Google Sheets ou outras ferramentas, baixe os dados em formato CSV. Alterne **Atualizar no GC**, para ver a alocação em tempo real.

![Screenshot da página da guia profile](/assets/images/docs/tools/devtools/profile-tab-2.png){:width="100%"}

### Guia Diff Snapshots

Use a guia **Diff Snapshots** para investigar o gerenciamento de memória de um recurso. Siga as orientações na guia para tirar snapshots antes e depois da interação com o aplicativo e comparar os snapshots:

![Screenshot da página da guia diff](/assets/images/docs/tools/devtools/diff-tab.png){:width="100%"}

Toque no botão **Filtrar classes e pacotes**, para restringir os dados:

![Screenshot da ui de opções de filtro](/assets/images/docs/tools/devtools/filter-ui.png)

Para uma análise mais profunda no Google Sheets ou outras ferramentas, baixe os dados em formato CSV.

<a id="trace-tab" aria-hidden="true"></a>

### Guia Trace Instances

Use a guia **Trace Instances** para investigar quais métodos alocam memória para um conjunto de classes durante a execução do recurso:

1. Selecione as classes para rastrear
2. Interaja com seu aplicativo para acionar o código em que você está interessado
3. Toque em **Atualizar**
4. Selecione uma classe rastreada
5. Revise os dados coletados

![Screenshot de uma guia de rastreamento](/assets/images/docs/tools/devtools/trace-instances-tab.png){:width="100%"}

#### Visualização de baixo para cima vs. árvore de chamadas

Alterne entre as visualizações de baixo para cima e árvore de chamadas, dependendo das especificidades de suas tarefas.

![Screenshot de um rastreamento de alocações](/assets/images/docs/tools/devtools/trace-view.png)

A visualização da árvore de chamadas mostra as alocações de método para cada instância. A visualização é uma representação de cima para baixo da pilha de chamadas, o que significa que um método pode ser expandido para mostrar seus chamados.

A visualização de baixo para cima mostra a lista de diferentes pilhas de chamadas que alocaram as instâncias.

## Outros recursos

Para obter mais informações, consulte os seguintes recursos:

* Para aprender como monitorar o uso de memória de um aplicativo e detectar vazamentos de memória usando o DevTools, consulte um [tutorial guiado de visualização de memória][memory-tutorial].
* Para entender a estrutura de memória do Android, consulte [Android: Alocação de memória entre processos][].

[memory-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-memory-view-part-7-of-8-e7f5aaf07e15
[Android: Alocação de memória entre processos]: {{site.android-dev}}/topic/performance/memory-management

