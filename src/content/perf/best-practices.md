---
ia-translate: true
title: Melhores práticas de desempenho
short-title: Melhores práticas
description: Como garantir que seu app Flutter seja performante.
---

{% render docs/performance.md %}

Geralmente, aplicações Flutter são performantes por padrão,
então você só precisa evitar armadilhas comuns para obter excelente
desempenho. Essas recomendações de melhores práticas ajudarão você a
escrever o app Flutter mais performante possível.

:::note
Se você está escrevendo apps web em Flutter, você pode estar interessado
em uma série de artigos, escritos pela equipe Flutter Material,
depois que eles modificaram o app [Flutter Gallery][] para torná-lo mais
performante na web:

* [Optimizing performance in Flutter web apps with tree
  shaking and deferred loading][web-perf-1]
* [Improving perceived performance with image placeholders,
  precaching, and disabled navigation transitions][web-perf-2]
* [Building performant Flutter widgets][web-perf-3]
:::

[Flutter Gallery]: {{site.gallery-archive}}
[web-perf-1]: {{site.flutter-medium}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[web-perf-2]: {{site.flutter-medium}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[web-perf-3]: {{site.flutter-medium}}/building-performant-flutter-widgets-3b2558aa08fa

Como você projeta um app Flutter para renderizar suas cenas
da forma mais eficiente? Em particular, como você garante
que o código de pintura gerado pelo
framework seja o mais eficiente possível?
Algumas operações de renderização e layout são conhecidas
por serem lentas, mas nem sempre podem ser evitadas.
Elas devem ser usadas com atenção,
seguindo as orientações abaixo.

## Minimize operações caras

Algumas operações são mais caras que outras,
o que significa que elas consomem mais recursos.
Obviamente, você quer usar essas operações
apenas quando necessário. Como você projeta e implementa a
UI do seu app pode ter um grande impacto em quão eficientemente ele executa.

### Controle o custo do build()

Aqui estão algumas coisas para ter em mente ao projetar sua UI:

* Evite trabalho repetitivo e caro em métodos `build()`
  já que `build()` pode ser invocado frequentemente quando
  widgets ancestrais são reconstruídos.
* Evite widgets únicos excessivamente grandes com uma função `build()` grande.
  Divida-os em diferentes widgets com base em encapsulamento
  mas também em como eles mudam:
  * Quando `setState()` é chamado em um objeto `State`,
    todos os widgets descendentes são reconstruídos. Portanto,
    localize a chamada `setState()` na parte da
    subárvore cuja UI realmente precisa mudar.
    Evite chamar `setState()` no topo da árvore
    se a mudança está contida em uma pequena parte da árvore.
  * A travessia para reconstruir todos os descendentes para quando a
    mesma instância do widget filho do frame anterior
    é re-encontrada. Esta técnica é muito
    usada dentro do framework para otimizar
    animações onde a animação não afeta a subárvore filha.
    Veja o padrão [`TransitionBuilder`][] e
    o [código-fonte para `SlideTransition`][source code for `SlideTransition`],
    que usa este princípio para evitar reconstruir seus
    descendentes ao animar.
    ("Mesma instância" é avaliado usando `operator ==`,
    mas veja a seção de armadilhas no final desta página
    para conselhos sobre quando evitar sobrescrever `operator ==`.)
  * Use construtores `const` em widgets o máximo possível,
    já que eles permitem ao Flutter ignorar a maior parte
    do trabalho de reconstrução. Para ser lembrado automaticamente
    de usar `const` quando possível, habilite os
    lints recomendados do pacote [`flutter_lints`][].
    Para mais informações, confira o
    [guia de migração do `flutter_lints`][`flutter_lints` migration guide].
  * Para criar peças reutilizáveis de UIs,
    prefira usar um [`StatelessWidget`][]
    em vez de uma função.

Para mais informações, confira:

* [Performance considerations][],
  parte da documentação da API [`StatefulWidget`][]
* [Widgets vs helper methods][],
  um vídeo do canal oficial Flutter no YouTube
  que explica por que widgets
  (especialmente widgets com construtores `const`)
  são mais performantes que funções.

[`flutter_lints`]: {{site.pub-pkg}}/flutter_lints
[`flutter_lints` migration guide]: /release/breaking-changes/flutter-lints-package#migration-guide
[Performance considerations]: {{site.api}}/flutter/widgets/StatefulWidget-class.html#performance-considerations
[source code for `SlideTransition`]: {{site.repo.flutter}}/blob/main/packages/flutter/lib/src/widgets/transitions.dart#L168
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`TransitionBuilder`]: {{site.api}}/flutter/widgets/TransitionBuilder.html
[Widgets vs helper methods]: {{site.yt.watch}}?v=IOyq-eTRhvo

---

### Use saveLayer() com atenção

Algum código Flutter usa `saveLayer()`, uma operação cara,
para implementar vários efeitos visuais na UI.
Mesmo se seu código não chama explicitamente `saveLayer()`,
outros widgets ou pacotes que você usa podem chamá-lo nos bastidores.
Talvez seu app esteja chamando `saveLayer()` mais do que o necessário;
chamadas excessivas a `saveLayer()` podem causar jank.

#### Por que saveLayer é caro?

Chamar `saveLayer()` aloca um buffer offscreen
e desenhar conteúdo no buffer offscreen pode
disparar uma troca de render target.
A GPU quer executar como uma mangueira de incêndio,
e uma troca de render target força a GPU
a redirecionar esse fluxo temporariamente e então
direcioná-lo de volta novamente. Em GPUs móveis isso é
particularmente perturbador para o throughput de renderização.

#### Quando saveLayer é necessário?

Em tempo de execução, se você precisa exibir dinamicamente várias formas
vindas de um servidor (por exemplo), cada uma com alguma transparência,
que podem (ou não) se sobrepor,
então você praticamente tem que usar `saveLayer()`.

#### Depurando chamadas a saveLayer

Como você pode saber com que frequência seu app chama `saveLayer()`,
diretamente ou indiretamente?
O método `saveLayer()` dispara
um evento na [timeline do DevTools][DevTools timeline]; saiba quando
sua cena usa `saveLayer` verificando o
switch `PerformanceOverlayLayer.checkerboardOffscreenLayers`
na [visualização Performance do DevTools][DevTools Performance view].

[DevTools timeline]: /tools/devtools/performance#timeline-events-tab

#### Minimizando chamadas a saveLayer

Você pode evitar chamadas a `saveLayer`?
Pode exigir repensar como você
cria seus efeitos visuais:

* Se as chamadas vêm do _seu_ código, você pode
  reduzi-las ou eliminá-las?
  Por exemplo, talvez sua UI sobreponha duas formas,
  cada uma tendo transparência não zero:
  * Se elas sempre se sobrepõem na mesma quantidade,
    da mesma maneira, com a mesma transparência,
    você pode pré-calcular como este objeto sobreposto,
    semitransparente se parece, armazená-lo em cache,
    e usar isso em vez de chamar `saveLayer()`.
    Isso funciona com qualquer forma estática que você possa pré-calcular.
  * Você pode refatorar sua lógica de pintura para evitar
    sobreposições completamente?
{% comment %}
TBD: It would be nice if we could link to an example.
  Kenzie suggested to John and Tao that we add an
  example to perf_diagnosis_demo. Michael indicated
  that he doesn't have a saveLayer demo.
{% endcomment %}

* Se as chamadas vêm de um pacote que você não possui,
  contate o proprietário do pacote e pergunte por que
  essas chamadas são necessárias. Elas podem ser reduzidas ou
  eliminadas? Se não, você pode precisar encontrar outro
  pacote, ou escrever o seu próprio.

:::note Nota para proprietários de pacotes
Como melhor prática, considere fornecer documentação
sobre quando `saveLayer` pode ser necessário para seu pacote,
como pode ser evitado, e quando não pode ser evitado.
:::

Outros widgets que podem disparar `saveLayer()`
e são potencialmente caros:

* [`ShaderMask`][]
* [`ColorFilter`][]
* [`Chip`][]&mdash;pode disparar uma chamada a `saveLayer()` se
  `disabledColorAlpha != 0xff`
* [`Text`][]&mdash;pode disparar uma chamada a `saveLayer()`
  se houver um `overflowShader`

[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`ColorFilter`]: {{site.api}}/flutter/dart-ui/ColorFilter-class.html
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[`ShaderMask`]: {{site.api}}/flutter/widgets/ShaderMask-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[Transparent image]: {{site.api}}/flutter/widgets/Opacity-class.html#transparent-image

---

### Minimize o uso de opacity e clipping

Opacity é outra operação cara, assim como clipping.
Aqui estão algumas dicas que você pode achar úteis:

* Use o widget [`Opacity`][] apenas quando necessário.
  Veja a seção [Transparent image][] na página da
  API `Opacity` para um exemplo de aplicar opacity diretamente
  a uma imagem, que é mais rápido do que usar o widget `Opacity`.
* Em vez de envolver formas simples ou texto
  em um widget `Opacity`, geralmente é mais rápido
  apenas desenhá-los com uma cor semitransparente.
  (Embora isso só funcione se não houver partes sobrepostas
  na forma a ser desenhada.)
* Para implementar fade in em uma imagem, considere usar o
  widget [`FadeInImage`][], que aplica opacity gradual
  usando o fragment shader da GPU.
  Para mais informações, confira a documentação do [`Opacity`][].
* **Clipping** não chama `saveLayer()` (a menos que
  explicitamente solicitado com `Clip.antiAliasWithSaveLayer`),
  então essas operações não são tão caras quanto `Opacity`,
  mas clipping ainda é caro, então use com cautela.
  Por padrão, clipping está desabilitado (`Clip.none`),
  então você deve explicitamente habilitá-lo quando necessário.
* Para criar um retângulo com cantos arredondados,
  em vez de aplicar um retângulo de clipping,
  considere usar a propriedade `borderRadius` oferecida
  por muitas das classes de widget.

---

### Implemente grids e listas com atenção

Como suas grids e listas são implementadas
pode estar causando problemas de desempenho para seu app.
Esta seção descreve uma importante melhor
prática ao criar grids e listas,
e como determinar se seu app usa
passes de layout excessivos.

#### Seja preguiçoso!

Ao construir uma grid ou lista grande,
use os métodos lazy builder, com callbacks.
Isso garante que apenas a porção visível da
tela seja construída no momento da inicialização.

Para mais informações e exemplos, confira:

* [Working with long lists][] no [Cookbook][]
* [Creating a `ListView` that loads one page at a time][]
  um artigo da comunidade por AbdulRahman AlHamali
* API [`Listview.builder`][]

[Cookbook]: /cookbook
[Creating a `ListView` that loads one page at a time]: {{site.medium}}/saugo360/flutter-creating-a-listview-that-loads-one-page-at-a-time-c5c91b6fabd3
[`Listview.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[Working with long lists]: /cookbook/lists/long-lists

#### Evite intrinsics

Para informações sobre como passes intrínsecos podem estar causando
problemas com suas grids e listas, veja a próxima seção.

---

### Minimize passes de layout causados por operações intrínsecas

Se você já programou muito em Flutter, você provavelmente
está familiarizado com [como layout e constraints funcionam][how layout and constraints work]
ao criar sua UI. Você pode até ter memorizado a
regra básica de layout do Flutter: **Constraints vão para baixo. Tamanhos vão para cima.
Parent define posição.**

Para alguns widgets, particularmente grids e listas,
o processo de layout pode ser caro.
Flutter se esforça para realizar apenas um passe de layout
sobre os widgets mas, às vezes,
um segundo passe (chamado de _passe intrínseco_) é necessário,
e isso pode diminuir o desempenho.

#### O que é um passe intrínseco?

Um passe intrínseco acontece quando, por exemplo,
você quer que todas as células tenham o tamanho
da maior ou menor célula (ou algum
cálculo similar que requer consultar todas as células).

Por exemplo, considere uma grande grid de `Card`s.
Uma grid deve ter células de tamanho uniforme,
então o código de layout realiza um passe,
começando da raiz da grid (na árvore de widgets),
perguntando a **cada** card na grid (não apenas os
cards visíveis) para retornar
seu tamanho _intrínseco_&mdash;o tamanho
que o widget prefere, assumindo nenhuma constraint.
Com esta informação,
o framework determina um tamanho de célula uniforme,
e re-visita todas as células da grid uma segunda vez,
dizendo a cada card qual tamanho usar.

#### Depurando passes intrínsecos

Para determinar se você tem passes intrínsecos excessivos,
habilite a opção **[Track layouts][Track layouts option]**
no DevTools (desabilitada por padrão),
e olhe o [stack trace][] do app
para saber quantos passes de layout foram realizados.
Uma vez que você habilite o rastreamento, eventos intrínsecos na timeline
são rotulados como '$runtimeType intrinsics'.

#### Evitando passes intrínsecos

Você tem algumas opções para evitar o passe intrínseco:

* Defina as células com um tamanho fixo antecipadamente.
* Escolha uma célula particular para ser a
  célula "âncora"&mdash;todas as células serão
  dimensionadas em relação a esta célula.
  Escreva um [`RenderObject`][] customizado que
  posicione o filho âncora primeiro e então posicione
  os outros filhos ao redor dele.

Para mergulhar ainda mais fundo em como o layout funciona,
confira a seção [layout and rendering][]
na [visão geral da arquitetura do Flutter][Flutter architectural overview].


[Flutter architectural overview]: /resources/architectural-overview
[how layout and constraints work]: /ui/layout/constraints
[layout and rendering]: /resources/architectural-overview#layout-and-rendering
[stack trace]: /tools/devtools/cpu-profiler#flame-chart
[Track layouts option]: /tools/devtools/performance#track-layouts

---

### Construa e exiba frames em 16ms

Como há dois threads separados para construção
e renderização, você tem 16ms para construção,
e 16ms para renderização em um display de 60Hz.
Se latência é uma preocupação,
construa e exiba um frame em 16ms _ou menos_.
Note que isso significa construído em 8ms ou menos,
e renderizado em 8ms ou menos,
para um total de 16ms ou menos.

Se seus frames estão renderizando em bem menos de
16ms no total no [modo profile][profile mode],
você provavelmente não precisa se preocupar com desempenho
mesmo se algumas armadilhas de desempenho se aplicam,
mas você ainda deve buscar construir e
renderizar um frame o mais rápido possível. Por quê?

* Reduzir o tempo de renderização de frame abaixo de 16ms pode não fazer uma diferença visual,
  mas **melhora a vida útil da bateria** e problemas térmicos.
* Pode executar bem no seu dispositivo, mas considere o desempenho para o
  dispositivo mais básico que você está visando.
* À medida que dispositivos de 120fps se tornam mais amplamente disponíveis,
  você vai querer renderizar frames em menos de 8ms (total)
  para fornecer a experiência mais suave.

Se você está se perguntando por que 60fps leva a uma experiência visual suave,
confira o vídeo [Why 60fps?][]

[profile mode]: /testing/build-modes#profile
[Why 60fps?]: {{site.yt.watch}}?v=CaMTIgxCSqU

## Armadilhas

Se você precisa ajustar o desempenho do seu app,
ou talvez a UI não esteja tão suave quanto você espera,
a [visualização Performance do DevTools][DevTools Performance view] pode ajudar!

Além disso, o plugin Flutter para sua IDE pode
ser útil. Na janela Flutter Performance,
habilite a checkbox **Show widget rebuild information**.
Este recurso ajuda você a detectar quando frames estão
sendo renderizados e exibidos em mais de 16ms.
Quando possível,
o plugin fornece um link para uma dica relevante.

Os seguintes comportamentos podem impactar negativamente
o desempenho do seu app.

* Evite usar o widget `Opacity`,
  e particularmente evite-o em uma animação.
  Use `AnimatedOpacity` ou `FadeInImage` em vez disso.
  Para mais informações, confira
  [Performance considerations for opacity animation][].

* Ao usar um `AnimatedBuilder`,
  evite colocar uma subárvore na função builder
  que constrói widgets que não
  dependem da animação. Esta subárvore é
  reconstruída a cada tick da animação.
  Em vez disso, construa essa parte da subárvore
  uma vez e passe-a como um filho para
  o `AnimatedBuilder`. Para mais informações,
  confira [Performance optimizations][].

* Evite clipping em uma animação.
  Se possível, pré-corte a imagem antes de animá-la.

* Evite usar construtores com uma `List` concreta
  de filhos (como `Column()` ou `ListView()`)
  se a maioria dos filhos não estiver visível
  na tela para evitar o custo de build.

* Evite sobrescrever `operator ==` em objetos `Widget`.
  Embora possa parecer que ajudaria ao evitar reconstruções desnecessárias,
  na prática isso prejudica o desempenho porque resulta em comportamento O(N²).
  A única exceção a esta regra são widgets folha (widgets sem filhos),
  no caso específico onde comparar as propriedades do widget
  provavelmente será significativamente mais eficiente do que reconstruir o widget
  e onde o widget raramente mudará de configuração.
  Mesmo em tais casos,
  geralmente é preferível confiar no cache dos widgets,
  porque mesmo uma sobrescrita de `operator ==`
  pode resultar em degradação de desempenho geral
  já que o compilador não pode mais assumir que a chamada é sempre estática.


## Recursos

Para mais informações sobre desempenho, confira os seguintes recursos:

* [Performance optimizations][] na página da API AnimatedBuilder
* [Performance considerations for opacity animation][]
  na página da API Opacity
* [Child elements' lifecycle][] e como carregá-los eficientemente,
  na página da API ListView
* [Performance considerations][] de um `StatefulWidget`
* [Best practices for optimizing Flutter web loading speed][best-practices-medium]

[Child elements' lifecycle]: {{site.api}}/flutter/widgets/ListView-class.html#child-elements-lifecycle
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[DevTools Performance view]: /tools/devtools/performance
[Performance optimizations]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html#performance-optimizations
[Performance considerations for opacity animation]: {{site.api}}/flutter/widgets/Opacity-class.html#performance-considerations-for-opacity-animation
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[best-practices-medium]: https://medium.com/flutter/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
