---
ia-translate: true
title: Use a view de Performance
description: Aprenda como usar a view de performance do DevTools.
---

:::note
A view de performance do DevTools funciona para apps Flutter mobile e desktop.
Para apps web, Flutter adiciona eventos de timeline ao
painel de performance do Chrome DevTools em vez disso.
Para aprender sobre profiling de apps web,
confira [Debugging web performance][Debugging web performance].
:::

[Debugging web performance]: /perf/web-performance

A página de performance pode ajudá-lo a diagnosticar problemas
de desempenho e jank da UI em sua aplicação.
Esta página oferece informações de tempo e desempenho
para atividade em sua aplicação.
Ela consiste em várias ferramentas para ajudá-lo a identificar
a causa de mau desempenho no seu app:

* Gráfico de frames Flutter (apenas apps Flutter)
* Aba de análise de frame (apenas apps Flutter)
* Visualizador de trace de eventos de timeline (todas as aplicações nativas Dart)
* Ferramentas avançadas de debugging (apenas apps Flutter)

:::secondary
**Use um [build de profile][profile build] da sua aplicação para analisar o desempenho.**
Tempos de renderização de frame não são indicativos de desempenho de release
quando executando em modo debug. Execute seu app em modo profile,
que ainda preserva informações úteis de debugging.
:::

[profile build]: /testing/build-modes#profile

A view de performance também suporta importação e exportação de
snapshots de dados. Para mais informações,
confira a seção [Import and export][Import and export].

## O que é um frame no Flutter?

Flutter é projetado para renderizar sua UI a 60 frames por segundo
(fps), ou 120 fps em dispositivos capazes de atualizações de 120Hz.
Cada renderização é chamada de _frame_.
Isso significa que, aproximadamente a cada 16ms, a UI atualiza
para refletir animações ou outras mudanças na UI. Um frame
que leva mais de 16ms para renderizar causa jank
(movimento irregular) no dispositivo de exibição.

## Gráfico de frames Flutter

Este gráfico contém informações de frame Flutter para sua aplicação.
Cada conjunto de barras no gráfico representa um único frame Flutter.
As barras são codificadas por cores para destacar as diferentes porções
de trabalho que ocorrem ao renderizar um frame Flutter: trabalho do
thread UI e trabalho do thread raster.

Este gráfico contém informações de tempo de frame Flutter para sua
aplicação. Cada par de barras no gráfico representa um único
frame Flutter. Selecionar um frame deste gráfico atualiza os dados
que são exibidos abaixo na aba [Frame analysis](#frame-analysis-tab)
ou na aba [Timeline events](#timeline-events-tab).

[DevTools 2.23.1]: /tools/devtools/release-notes/release-notes-2.23.1

O gráfico de frames flutter atualiza quando novos frames
são desenhados no seu app. Para pausar atualizações neste gráfico,
clique no botão pausar à direita do gráfico.
Este gráfico pode ser recolhido para fornecer mais espaço de visualização
para dados abaixo clicando no botão **Flutter frames** acima do gráfico.

![Screenshot of a Flutter frames chart](/assets/images/docs/tools/devtools/flutter-frames-chart.png)

O par de barras representando cada frame Flutter são codificadas por cores
para destacar as diferentes porções de trabalho que ocorrem ao renderizar
um frame Flutter: trabalho do thread UI e trabalho do thread raster.

### UI

O thread UI executa código Dart na Dart VM. Isso inclui
código da sua aplicação, bem como do framework Flutter.
Quando seu app cria e exibe uma cena, o thread UI cria
uma layer tree, um objeto leve contendo comandos de
pintura agnósticos de dispositivo, e envia a layer tree para o thread raster
para ser renderizada no dispositivo. **Não** bloqueie este thread.

### Raster

O thread raster executa código gráfico do Flutter Engine.
Este thread pega a layer tree e a exibe conversando com
a GPU (unidade de processamento gráfico). Você não pode acessar diretamente
o thread raster ou seus dados, mas se este thread estiver lento,
é resultado de algo que você fez no código Dart.
Skia, a biblioteca gráfica, executa neste thread.
[Impeller][Impeller] também usa este thread.

[Impeller]: /perf/impeller

Às vezes uma cena resulta em uma layer tree que é fácil de construir,
mas cara para renderizar no thread raster. Neste caso, você
precisa descobrir o que seu código está fazendo que está causando
o código de renderização a ser lento. Tipos específicos de cargas de trabalho são mais
difíceis para a GPU. Eles podem envolver chamadas desnecessárias para
`saveLayer()`, opacidades intersectando com múltiplos objetos,
e clips ou sombras em situações específicas.

Para mais informações sobre profiling, confira
[Identifying problems in the GPU graph][GPU graph].

### Jank (frame lento)

O gráfico de renderização de frames mostra jank com uma sobreposição vermelha.
Um frame é considerado janky se leva mais de
~16 ms para completar (para dispositivos de 60 FPS). Para alcançar uma taxa de renderização de frame de
60 FPS (frames por segundo), cada frame deve renderizar em
~16 ms ou menos. Quando este alvo é perdido, você pode
experimentar jank da UI ou frames perdidos.

Para mais informações sobre como analisar o desempenho do seu app,
confira [Flutter performance profiling][Flutter performance profiling].

### Compilação de shader

Compilação de shader ocorre quando um shader é usado pela primeira vez no seu app
Flutter. Frames que realizam compilação de shader são marcados em vermelho
escuro:

![Screenshot of shader compilation for a frame](/assets/images/docs/tools/devtools/shader-compilation-frames-chart.png)

Para mais informações sobre como reduzir jank de compilação de shader,
confira [Reduce shader compilation jank on mobile][Reduce shader compilation jank on mobile].

## Aba Frame analysis

Selecionar um frame janky (lento, colorido em vermelho)
do gráfico de frames Flutter acima mostra dicas de debugging
na aba Frame analysis. Essas dicas ajudam você a diagnosticar
jank no seu app, e notificam você de quaisquer operações caras
que detectamos que podem ter contribuído para o tempo lento do frame.

![Screenshot of the frame analysis tab](/assets/images/docs/tools/devtools/frame-analysis-tab.png)

## Aba Timeline events {:#timeline-events-tab}

O gráfico de eventos de timeline mostra todo o rastreamento de eventos da sua aplicação.
O framework Flutter emite eventos de timeline enquanto trabalha para construir frames,
desenhar cenas e rastrear outra atividade como tempos de requisição HTTP
e garbage collection. Esses eventos aparecem aqui na Timeline.
Você também pode enviar seus próprios eventos de Timeline usando as APIs dart:developer
[`Timeline`][`Timeline`] e [`TimelineTask`][`TimelineTask`].

[`Timeline`]: {{site.api}}/flutter/dart-developer/Timeline-class.html
[`TimelineTask`]: {{site.api}}/flutter/dart-developer/TimelineTask-class.html

![Screenshot of a timeline events tab](/assets/images/docs/tools/devtools/timeline-events-tab.png)
Para ajuda com navegação e uso do visualizador de trace,
clique no botão **?** no canto superior direito da barra de
abas de eventos de timeline. Para atualizar a timeline com novos eventos da
sua aplicação, clique no botão de atualização
(também no canto superior direito dos controles da aba).

## Ferramentas avançadas de debugging

### Enhance tracing

Para visualizar rastreamento mais detalhado no gráfico de eventos de timeline,
use as opções no dropdown enhance tracing:

:::note
Tempos de frame podem ser negativamente afetados quando essas opções estão habilitadas.
:::

![Screenshot of enhanced tracing options](/assets/images/docs/tools/devtools/enhanced-tracing.png)

Para ver os novos eventos de timeline, reproduza a atividade
no seu app que você está interessado em rastrear,
e então selecione um frame para inspecionar a timeline.

### Track widget builds

Para ver os eventos do método `build()` na timeline,
habilite a opção **Track Widget Builds**.
O nome do widget é mostrado no evento de timeline.

![Screenshot of track widget builds](/assets/images/docs/tools/devtools/track-widget-builds.png)

[Assista este vídeo para um exemplo de rastreamento de builds de widget][track-widgets]

### Track layouts

Para ver eventos de layout de render object na timeline,
habilite a opção **Track Layouts**:

![Screenshot of track layouts](/assets/images/docs/tools/devtools/track-layouts.png)

[Assista este vídeo para um exemplo de rastreamento de layouts][track-layouts]

### Track paints

Para ver eventos de pintura de render object na timeline,
habilite a opção **Track Paints**:

![Screenshot of track paints](/assets/images/docs/tools/devtools/track-paints.png)

[Assista este vídeo para um exemplo de rastreamento de pinturas][track-paints]

## Mais opções de debugging

Para diagnosticar problemas de desempenho relacionados a layers de renderização,
desative uma layer de renderização.
Essas opções estão habilitadas por padrão.

Para ver os efeitos no desempenho do seu app,
reproduza a atividade no seu app.
Então selecione os novos frames no gráfico de frames
para inspecionar os eventos de timeline
com as layers desabilitadas.
Se o tempo raster diminuiu significativamente,
uso excessivo dos efeitos que você desabilitou pode estar contribuindo
para o jank que você viu no seu app.

**Render Clip layers**
: Desabilite esta opção para verificar se uso excessivo de clipping
  está afetando o desempenho.
  Se o desempenho melhorar com esta opção desabilitada,
  tente reduzir o uso de efeitos de clipping no seu app.

**Render Opacity layers**
:  Desabilite esta opção para verificar se
   uso excessivo de efeitos de opacidade está afetando o desempenho.
   Se o desempenho melhorar com esta opção desabilitada,
   tente reduzir o uso de efeitos de opacidade no seu app.

**Render Physical Shape layers**
: Desabilite esta opção para verificar se uso
  excessivo de efeitos de modelagem física está afetando o desempenho,
  como sombras ou elevação.
  Se o desempenho melhorar com esta opção desabilitada,
  tente reduzir o uso de efeitos de modelagem física no seu app.

![Screenshot of more debugging options](/assets/images/docs/tools/devtools/more-debugging-options.png)

## Import and export

DevTools suporta importação e exportação de snapshots de performance.
Clicar no botão de exportação (canto superior direito acima do
gráfico de renderização de frames) baixa um snapshot dos dados atuais na
página de performance. Para importar um snapshot de performance, você pode arrastar e soltar o
snapshot no DevTools de qualquer página. **Note que DevTools apenas
suporta importar arquivos que foram originalmente exportados do DevTools.**

## Outros recursos

Para aprender como monitorar o desempenho de um app e
detectar jank usando DevTools, confira um
[tutorial guiado da View de Performance][performance-tutorial].

[GPU graph]: /perf/ui-performance#identifying-problems-in-the-gpu-graph
[Flutter performance profiling]: /perf/ui-performance
[Reduce shader compilation jank on mobile]: /perf/rendering-performance
[Import and export]: #import-and-export
[performance-tutorial]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-performance-view-part-8-of-8-4ae762f91230
[track-widgets]: {{site.yt.watch}}/_EYk-E29edo?t=623
[track-layouts]: {{site.yt.watch}}/_EYk-E29edo?t=676
[track-paints]: {{site.yt.watch}}/_EYk-E29edo?t=748
