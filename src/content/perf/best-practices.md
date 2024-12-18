---
ia-translate: true
title: Melhores práticas de performance
short-title: Melhores práticas
description: Como garantir que seu aplicativo Flutter tenha um bom desempenho.
---

{% render docs/performance.md %}

Geralmente, os aplicativos Flutter têm bom desempenho por padrão,
então você só precisa evitar armadilhas comuns para obter um excelente
desempenho. Estas recomendações de melhores práticas irão ajudá-lo
a escrever o aplicativo Flutter com o melhor desempenho possível.

:::note
Se você estiver escrevendo aplicativos web em Flutter, pode se interessar
por uma série de artigos, escritos pela equipe do Flutter Material,
após eles terem modificado o aplicativo [Flutter Gallery][] para torná-lo mais
desempenhoso na web:

* [Otimizando o desempenho em aplicativos web Flutter com tree
  shaking e carregamento diferido][web-perf-1]
* [Melhorando o desempenho percebido com placeholders de imagem,
  pré-carregamento e transições de navegação desabilitadas][web-perf-2]
* [Construindo widgets Flutter de alto desempenho][web-perf-3]
:::

[Flutter Gallery]: {{site.gallery-archive}}
[web-perf-1]: {{site.flutter-medium}}/optimizing-performance-in-flutter-web-apps-with-tree-shaking-and-deferred-loading-535fbe3cd674
[web-perf-2]: {{site.flutter-medium}}/improving-perceived-performance-with-image-placeholders-precaching-and-disabled-navigation-6b3601087a2b
[web-perf-3]: {{site.flutter-medium}}/building-performant-flutter-widgets-3b2558aa08fa

Como você projeta um aplicativo Flutter para renderizar suas cenas da forma mais eficiente? Em particular, como você garante
que o código de pintura gerado pelo framework seja o mais eficiente possível? Algumas operações de renderização e layout são conhecidas por serem lentas, mas nem sempre podem ser evitadas. Elas devem ser usadas cuidadosamente, seguindo as orientações abaixo.

## Minimize operações custosas

Algumas operações são mais caras do que outras, o que significa que consomem mais recursos. Obviamente, você só deve usar essas operações quando necessário. Como você projeta e implementa a UI do seu aplicativo pode ter um grande impacto na eficiência com que ele é executado.

### Controle o custo do `build()`

Aqui estão algumas coisas a ter em mente ao projetar sua UI:

* Evite trabalho repetitivo e custoso em métodos `build()`, já que `build()` pode ser invocado com frequência quando widgets ancestrais são reconstruídos.
* Evite widgets únicos excessivamente grandes com uma grande função `build()`. Divida-os em widgets diferentes com base no encapsulamento, mas também em como eles mudam:
  * Quando `setState()` é chamado em um objeto `State`, todos os widgets descendentes são reconstruídos. Portanto, localize a chamada `setState()` para a parte da subárvore cuja UI realmente precisa mudar. Evite chamar `setState()` no alto da árvore se a mudança estiver contida em uma pequena parte da árvore.
  * O percurso para reconstruir todos os descendentes para quando a mesma instância do widget filho do quadro anterior é reencontrada. Esta técnica é muito usada dentro do framework para otimizar animações onde a animação não afeta a subárvore filha. Veja o padrão [`TransitionBuilder`][] e o [código fonte para `SlideTransition`][], que usa este princípio para evitar reconstruir seus descendentes durante a animação. ("Mesma instância" é avaliada usando `operator ==`, mas veja a seção de armadilhas no final desta página para obter conselhos sobre quando evitar substituir `operator ==`.)
  * Use construtores `const` em widgets o máximo possível, pois eles permitem que o Flutter evite a maior parte do trabalho de reconstrução. Para ser lembrado automaticamente de usar `const` quando possível, habilite os lints recomendados do pacote [`flutter_lints`][]. Para obter mais informações, consulte o [guia de migração `flutter_lints`][].
  * Para criar partes reutilizáveis de UIs, prefira usar um [`StatelessWidget`][] em vez de uma função.

Para mais informações, confira:

* [Considerações de desempenho][], parte da documentação da API [`StatefulWidget`][]
* [Widgets vs helper methods][], um vídeo do canal oficial do Flutter no YouTube que explica por que widgets (especialmente widgets com construtores `const`) têm melhor desempenho do que funções.

[`flutter_lints`]: {{site.pub-pkg}}/flutter_lints
[guia de migração `flutter_lints`]: /release/breaking-changes/flutter-lints-package#migration-guide
[Considerações de desempenho]: {{site.api}}/flutter/widgets/StatefulWidget-class.html#performance-considerations
[código fonte para `SlideTransition`]: {{site.repo.flutter}}/blob/master/packages/flutter/lib/src/widgets/transitions.dart#L168
[`StatefulWidget`]: {{site.api}}/flutter/widgets/StatefulWidget-class.html
[`StatelessWidget`]: {{site.api}}/flutter/widgets/StatelessWidget-class.html
[`TransitionBuilder`]: {{site.api}}/flutter/widgets/TransitionBuilder.html
[Widgets vs helper methods]: {{site.yt.watch}}?v=IOyq-eTRhvo

---

### Use saveLayer() com cuidado

Alguns códigos Flutter usam `saveLayer()`, uma operação cara, para implementar vários efeitos visuais na UI. Mesmo que seu código não chame explicitamente `saveLayer()`, outros widgets ou pacotes que você usa podem chamá-lo nos bastidores. Talvez seu aplicativo esteja chamando `saveLayer()` mais do que o necessário; chamadas excessivas para `saveLayer()` podem causar lentidão.

#### Por que saveLayer é caro?

Chamar `saveLayer()` aloca um buffer offscreen e desenhar conteúdo no buffer offscreen pode acionar uma mudança de destino de renderização. A GPU quer funcionar como uma mangueira de incêndio, e uma mudança de destino de renderização força a GPU a redirecionar esse fluxo temporariamente e, em seguida, direcioná-lo de volta. Em GPUs móveis, isso é particularmente prejudicial ao rendimento da renderização.

#### Quando saveLayer é necessário?

Em tempo de execução, se você precisar exibir dinamicamente várias formas vindas de um servidor (por exemplo), cada uma com alguma transparência, que podem (ou não) se sobrepor, então você praticamente tem que usar `saveLayer()`.

#### Depurando chamadas para saveLayer

Como você pode saber com que frequência seu aplicativo chama `saveLayer()`, direta ou indiretamente? O método `saveLayer()` aciona um evento na [linha do tempo DevTools][]; aprenda quando sua cena usa `saveLayer` verificando o switch `PerformanceOverlayLayer.checkerboardOffscreenLayers` na [visualização de desempenho do DevTools][].

[linha do tempo DevTools]: /tools/devtools/performance#timeline-events-tab

#### Minimizando chamadas para saveLayer

Você pode evitar chamadas para `saveLayer`? Pode exigir que você repense como você cria seus efeitos visuais:

* Se as chamadas estão vindo do _seu_ código, você pode reduzi-las ou eliminá-las? Por exemplo, talvez sua UI sobreponha duas formas, cada uma com transparência diferente de zero:
  * Se elas sempre se sobrepõem na mesma quantidade, da mesma forma, com a mesma transparência, você pode pré-calcular como esse objeto sobreposto e semi-transparente se parece, armazená-lo em cache e usá-lo em vez de chamar `saveLayer()`. Isso funciona com qualquer forma estática que você pode pré-calcular.
  * Você pode refatorar sua lógica de pintura para evitar sobreposições?
{% comment %}
TBD: Seria bom se pudéssemos linkar para um exemplo.
  Kenzie sugeriu a John e Tao que adicionássemos um
  exemplo para perf_diagnosis_demo. Michael indicou
  que ele não tem um demo saveLayer.
{% endcomment %}

* Se as chamadas estão vindo de um pacote que você não possui, entre em contato com o proprietário do pacote e pergunte por que essas chamadas são necessárias. Elas podem ser reduzidas ou eliminadas? Caso contrário, você pode precisar encontrar outro pacote ou escrever o seu próprio.

:::note Nota para proprietários de pacotes
Como prática recomendada, considere fornecer documentação sobre quando `saveLayer` pode ser necessário para seu pacote, como ele pode ser evitado e quando não pode ser evitado.
:::

Outros widgets que podem acionar `saveLayer()` e são potencialmente caros:

* [`ShaderMask`][]
* [`ColorFilter`][]
* [`Chip`][]&mdash;pode acionar uma chamada para `saveLayer()` se `disabledColorAlpha != 0xff`
* [`Text`][]&mdash;pode acionar uma chamada para `saveLayer()` se houver um `overflowShader`

[`Chip`]: {{site.api}}/flutter/material/Chip-class.html
[`ColorFilter`]: {{site.api}}/flutter/dart-ui/ColorFilter-class.html
[`FadeInImage`]: {{site.api}}/flutter/widgets/FadeInImage-class.html
[`Opacity`]: {{site.api}}/flutter/widgets/Opacity-class.html
[`ShaderMask`]: {{site.api}}/flutter/widgets/ShaderMask-class.html
[`Text`]: {{site.api}}/flutter/widgets/Text-class.html
[Imagem transparente]: {{site.api}}/flutter/widgets/Opacity-class.html#transparent-image

---

### Minimize o uso de opacidade e clipping

Opacidade é outra operação cara, assim como clipping. Aqui estão algumas dicas que você pode achar úteis:

* Use o widget [`Opacity`][] apenas quando necessário. Veja a seção [Imagem transparente][] na página da API `Opacity` para um exemplo de como aplicar opacidade diretamente a uma imagem, o que é mais rápido do que usar o widget `Opacity`.
* Em vez de envolver formas simples ou texto em um widget `Opacity`, geralmente é mais rápido desenhá-los com uma cor semitransparente. (No entanto, isso só funciona se não houver partes sobrepostas na forma a ser desenhada.)
* Para implementar o fade in em uma imagem, considere usar o widget [`FadeInImage`][], que aplica uma opacidade gradual usando o fragment shader da GPU. Para mais informações, consulte os documentos [`Opacity`][].
* **Clipping** não chama `saveLayer()` (a menos que explicitamente solicitado com `Clip.antiAliasWithSaveLayer`), então essas operações não são tão caras quanto `Opacity`, mas clipping ainda é custoso, então use com cautela. Por padrão, o clipping está desabilitado (`Clip.none`), então você deve habilitá-lo explicitamente quando necessário.
* Para criar um retângulo com cantos arredondados, em vez de aplicar um retângulo de clipping, considere usar a propriedade `borderRadius` oferecida por muitas das classes de widget.

---

### Implemente grids e listas cuidadosamente

Como suas grids e listas são implementadas pode estar causando problemas de desempenho para seu aplicativo. Esta seção descreve uma prática recomendada importante ao criar grids e listas e como determinar se seu aplicativo usa passagens de layout excessivas.

#### Seja preguiçoso!

Ao construir um grid ou lista grande, use os métodos de construtor preguiçosos, com callbacks. Isso garante que apenas a parte visível da tela seja construída no momento da inicialização.

Para mais informações e exemplos, confira:

* [Trabalhando com listas longas][] no [Cookbook][]
* [Criando uma `ListView` que carrega uma página por vez][] um artigo da comunidade de AbdulRahman AlHamali
* API [`Listview.builder`][]

[Cookbook]: /cookbook
[Criando uma `ListView` que carrega uma página por vez]: {{site.medium}}/saugo360/flutter-creating-a-listview-that-loads-one-page-at-a-time-c5c91b6fabd3
[`Listview.builder`]: {{site.api}}/flutter/widgets/ListView/ListView.builder.html
[Trabalhando com listas longas]: /cookbook/lists/long-lists

#### Evite intrínsecos

Para obter informações sobre como as passagens intrínsecas podem estar causando problemas com seus grids e listas, consulte a próxima seção.

---

### Minimize as passagens de layout causadas por operações intrínsecas

Se você já fez muita programação Flutter, provavelmente está familiarizado com [como layout e restrições funcionam][] ao criar sua UI. Você pode até ter memorizado a regra básica de layout do Flutter: **Restrições descem. Tamanhos sobem. O pai define a posição.**

Para alguns widgets, particularmente grids e listas, o processo de layout pode ser caro. O Flutter se esforça para executar apenas uma passagem de layout sobre os widgets, mas, às vezes, uma segunda passagem (chamada de _passagem intrínseca_) é necessária, e isso pode diminuir o desempenho.

#### O que é uma passagem intrínseca?

Uma passagem intrínseca acontece quando, por exemplo, você quer que todas as células tenham o tamanho da célula maior ou menor (ou algum cálculo similar que exija sondar todas as células).

Por exemplo, considere um grid grande de `Card`s. Um grid deve ter células de tamanho uniforme, então o código de layout executa uma passagem, começando da raiz do grid (na árvore de widgets), pedindo para **cada** card no grid (não apenas os cards visíveis) retornar seu tamanho _intrínseco_&mdash;o tamanho que o widget prefere, assumindo que não haja restrições. Com esta informação, o framework determina um tamanho de célula uniforme e revisita todas as células do grid uma segunda vez, dizendo a cada card qual tamanho usar.

#### Depurando passagens intrínsecas

Para determinar se você tem passagens intrínsecas excessivas, habilite a **[opção Rastrear layouts][]** no DevTools (desabilitada por padrão) e observe o [stack trace][] do aplicativo para saber quantas passagens de layout foram executadas. Depois de habilitar o rastreamento, os eventos intrínsecos da linha do tempo são rotulados como '$runtimeType intrinsics'.

#### Evitando passagens intrínsecas

Você tem algumas opções para evitar a passagem intrínseca:

* Defina as células para um tamanho fixo antecipadamente.
* Escolha uma célula específica para ser a célula "âncora"&mdash;todas as células terão tamanho relativo a esta célula. Escreva um [`RenderObject`][] personalizado que posicione o filho âncora primeiro e, em seguida, distribua os outros filhos ao redor dele.

Para se aprofundar ainda mais em como o layout funciona, confira a seção [layout e renderização][] no [overview arquitetural do Flutter][].

[overview arquitetural do Flutter]: /resources/architectural-overview
[como layout e restrições funcionam]: /ui/layout/constraints
[layout e renderização]: /resources/architectural-overview#layout-and-rendering
[stack trace]: /tools/devtools/cpu-profiler#flame-chart
[opção Rastrear layouts]: /tools/devtools/performance#track-layouts

---

### Construa e exiba frames em 16ms

Como existem dois threads separados para construção e renderização, você tem 16ms para construir e 16ms para renderizar em uma tela de 60Hz. Se a latência for uma preocupação, construa e exiba um frame em 16ms _ou menos_. Observe que isso significa construir em 8ms ou menos e renderizar em 8ms ou menos, para um total de 16ms ou menos.

Se seus frames estão sendo renderizados bem abaixo de 16ms totais no [modo profile][], você provavelmente não precisa se preocupar com o desempenho, mesmo que algumas armadilhas de desempenho se apliquem, mas você ainda deve tentar construir e renderizar um frame o mais rápido possível. Por quê?

* Diminuir o tempo de renderização do frame abaixo de 16ms pode não fazer uma diferença visual, mas **melhora a vida útil da bateria** e problemas térmicos.
* Pode funcionar bem no seu dispositivo, mas considere o desempenho para o dispositivo mais baixo que você está segmentando.
* À medida que os dispositivos de 120fps se tornam mais amplamente disponíveis, você vai querer renderizar frames em menos de 8ms (total) para fornecer a experiência mais suave.

Se você está se perguntando por que 60fps leva a uma experiência visual suave, confira o vídeo [Por que 60fps?][]

[modo profile]: /testing/build-modes#profile
[Why 60fps?]: {{site.yt.watch}}?v=CaMTIgxCSqU

## Armadilhas

Se você precisa ajustar o desempenho do seu aplicativo, ou talvez a UI não esteja tão suave quanto você espera, a [visualização de desempenho do DevTools][] pode ajudar!

Além disso, o plugin Flutter para seu IDE pode ser útil. Na janela Flutter Performance, marque a caixa de seleção **Mostrar informações de reconstrução de widget**. Esse recurso ajuda você a detectar quando os frames estão sendo renderizados e exibidos em mais de 16ms. Sempre que possível, o plugin fornece um link para uma dica relevante.

Os seguintes comportamentos podem impactar negativamente o desempenho do seu aplicativo.

* Evite usar o widget `Opacity`, e principalmente evite-o em uma animação. Use `AnimatedOpacity` ou `FadeInImage` em vez disso. Para mais informações, confira [Considerações de desempenho para animação de opacidade][].

* Ao usar um `AnimatedBuilder`, evite colocar uma subárvore na função construtora que constrói widgets que não dependem da animação. Essa subárvore é reconstruída para cada tick da animação. Em vez disso, construa essa parte da subárvore uma vez e passe-a como filho para o `AnimatedBuilder`. Para mais informações, confira [Otimizações de desempenho][].

* Evite clipping em uma animação. Se possível, pré-corte a imagem antes de animá-la.

* Evite usar construtores com uma `List` concreta de filhos (como `Column()` ou `ListView()`) se a maioria dos filhos não estiver visível na tela para evitar o custo de construção.

* Evite substituir `operator ==` em objetos `Widget`. Embora possa parecer que ajudaria a evitar reconstruções desnecessárias, na prática prejudica o desempenho porque resulta em comportamento O(N²). A única exceção a esta regra são os widgets folha (widgets sem filhos), no caso específico em que comparar as propriedades do widget provavelmente será significativamente mais eficiente do que reconstruir o widget e onde o widget raramente mudará a configuração. Mesmo nesses casos, geralmente é preferível confiar no armazenamento em cache dos widgets, porque mesmo uma substituição de `operator ==` pode resultar em degradação de desempenho geral, pois o compilador não pode mais assumir que a chamada é sempre estática.

## Recursos

Para mais informações sobre desempenho, consulte os seguintes recursos:

* [Otimizações de desempenho][] na página da API AnimatedBuilder
* [Considerações de desempenho para animação de opacidade][] na página da API Opacity
* [Ciclo de vida dos elementos filhos][] e como carregá-los de forma eficiente, na página da API ListView
* [Considerações de desempenho][] de um `StatefulWidget`
* [Melhores práticas para otimizar a velocidade de carregamento do Flutter na web][best-practices-medium]

[Ciclo de vida dos elementos filhos]: {{site.api}}/flutter/widgets/ListView-class.html#child-elements-lifecycle
[`CustomPainter`]: {{site.api}}/flutter/rendering/CustomPainter-class.html
[visualização de desempenho do DevTools]: /tools/devtools/performance
[Otimizações de desempenho]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html#performance-optimizations
[Considerações de desempenho para animação de opacidade]: {{site.api}}/flutter/widgets/Opacity-class.html#performance-considerations-for-opacity-animation
[`RenderObject`]: {{site.api}}/flutter/rendering/RenderObject-class.html
[best-practices-medium]: https://medium.com/flutter/best-practices-for-optimizing-flutter-web-loading-speed-7cc0df14ce5c
