---
ia-translate: true
title: Use a visualização de Performance
description: Aprenda a usar a visualização de performance do DevTools.
---

:::note
A visualização de performance do DevTools funciona para aplicativos Flutter móveis e de desktop.
Para aplicativos web, o Flutter adiciona eventos de timeline ao painel de
performance do Chrome DevTools. Para saber mais sobre como fazer o
profiling de aplicativos web, consulte [Depurando performance web][].
:::

[Depurando performance web]: /perf/web-performance

A página de performance pode te ajudar a diagnosticar problemas de
performance e jank de UI no seu aplicativo. Esta página oferece informações
de tempo e performance para a atividade no seu aplicativo. Ela consiste
em diversas ferramentas para te ajudar a identificar a causa de performance
ruim no seu app:

* Gráfico de frames do Flutter (somente aplicativos Flutter)
* Aba de análise de frames (somente aplicativos Flutter)
* Visualizador de rastreamento de eventos de timeline (todos os aplicativos nativos Dart)
* Ferramentas avançadas de debug (somente aplicativos Flutter)

:::secondary
**Use um [build de profile][] do seu aplicativo para analisar a performance.**
Tempos de renderização de frame não são indicativos da performance de
release quando rodando em modo debug. Rode seu app em modo profile, o qual
ainda preserva informações úteis de debug.
:::

[build de profile]: /testing/build-modes#profile

A visualização de performance também suporta a importação e exportação de
snapshots de dados. Para mais informações, consulte a seção [Importar e exportar][].

## O que é um frame no Flutter?

O Flutter é projetado para renderizar sua UI a 60 frames por segundo
(fps), ou 120 fps em dispositivos capazes de atualizações de 120Hz. Cada
renderização é chamada de _frame_. Isso significa que, aproximadamente
a cada 16ms, a UI é atualizada para refletir animações ou outras
mudanças na UI. Um frame que leva mais de 16ms para renderizar causa
jank (movimento instável) no dispositivo de exibição.

## Gráfico de frames do Flutter

Este gráfico contém informações de frames do Flutter para seu aplicativo.
Cada conjunto de barras no gráfico representa um único frame do Flutter.
As barras são codificadas por cores para destacar as diferentes porções de
trabalho que ocorrem ao renderizar um frame do Flutter: trabalho da thread
da UI e trabalho da thread raster.

Este gráfico contém informações de tempo de frames do Flutter para seu
aplicativo. Cada par de barras no gráfico representa um único frame do
Flutter. Selecionar um frame neste gráfico atualiza os dados exibidos
abaixo na aba [Análise de frames](#aba-de-análise-de-frames) ou na aba
[Eventos de timeline](#aba-de-eventos-de-timeline).

[DevTools 2.23.1]: /tools/devtools/release-notes/release-notes-2.23.1

O gráfico de frames do Flutter é atualizado quando novos frames são
desenhados no seu app. Para pausar as atualizações neste gráfico, clique
no botão de pausa à direita do gráfico. Este gráfico pode ser recolhido
para fornecer mais espaço de visualização para os dados abaixo clicando no
botão **Flutter frames** acima do gráfico.

![Screenshot de um gráfico de frames do Flutter](/assets/images/docs/tools/devtools/flutter-frames-chart.png)

O par de barras representando cada frame do Flutter é codificado por cores
para destacar as diferentes porções de trabalho que ocorrem ao renderizar
um frame do Flutter: trabalho da thread da UI e trabalho da thread raster.

### UI

A thread da UI executa código Dart na VM Dart. Isso inclui código do seu
aplicativo, bem como do framework Flutter. Quando seu aplicativo cria e
exibe uma cena, a thread da UI cria uma árvore de camadas, um objeto leve
contendo comandos de desenho independentes do dispositivo, e envia a árvore
de camadas para a thread raster para ser renderizada no dispositivo.
**Não** bloqueie esta thread.

### Raster

A thread raster executa o código gráfico do Flutter Engine. Esta thread
pega a árvore de camadas e a exibe comunicando-se com a GPU (unidade de
processamento gráfico). Você não pode acessar diretamente a thread raster
ou seus dados, mas se esta thread estiver lenta, é resultado de algo que
você fez no código Dart. Skia, a biblioteca gráfica, é executada nesta
thread. [Impeller][] também usa esta thread.

[Impeller]: /perf/impeller

Às vezes, uma cena resulta em uma árvore de camadas que é fácil de
construir, mas cara para renderizar na thread raster. Neste caso, você
precisa descobrir o que seu código está fazendo que está causando a lentidão
do código de renderização. Tipos específicos de cargas de trabalho são mais
difíceis para a GPU. Elas podem envolver chamadas desnecessárias para
`saveLayer()`, interseção de opacidades com vários objetos, e recortes ou
sombras em situações específicas.

Para mais informações sobre profiling, consulte
[Identificando problemas no gráfico da GPU][gráfico da GPU].

### Jank (frame lento)

O gráfico de renderização de frames mostra jank com uma sobreposição
vermelha. Um frame é considerado janky se levar mais de ~16 ms para ser
concluído (para dispositivos de 60 FPS). Para atingir uma taxa de
renderização de frame de 60 FPS (frames por segundo), cada frame deve ser
renderizado em ~16 ms ou menos. Quando esta meta é perdida, você pode
experimentar jank de UI ou frames perdidos.

Para mais informações sobre como analisar a performance do seu app,
consulte [Profiling de performance do Flutter][].

### Compilação de shader

A compilação de shader ocorre quando um shader é usado pela primeira vez
no seu app Flutter. Frames que executam a compilação de shader são
marcados em vermelho escuro:

![Screenshot da compilação de shader para um frame](/assets/images/docs/tools/devtools/shader-compilation-frames-chart.png)

Para mais informações sobre como reduzir o jank de compilação de shader,
consulte [Reduzir o jank de compilação de shader no mobile][].

## Aba de análise de frames

Selecionar um frame janky (lento, colorido em vermelho) do gráfico de
frames do Flutter acima mostra dicas de debug na aba Análise de frames.
Essas dicas ajudam você a diagnosticar jank no seu app e notificam você
de quaisquer operações caras que detectamos que podem ter contribuído para
o tempo lento do frame.

![Screenshot da aba de análise de frames](/assets/images/docs/tools/devtools/frame-analysis-tab.png)

## Aba de eventos de timeline

O gráfico de eventos de timeline mostra todo o rastreamento de eventos do
seu aplicativo. O framework Flutter emite eventos de timeline enquanto
trabalha para construir frames, desenhar cenas e rastrear outras
atividades, como tempos de requisição HTTP e coleta de lixo. Esses eventos
aparecem aqui na Timeline. Você também pode enviar seus próprios eventos
de Timeline usando as APIs `Timeline`][] e [`TimelineTask`][] do
dart:developer.

[`Timeline`]: {{site.api}}/flutter/dart-developer/Timeline-class.html
[`TimelineTask`]: {{site.api}}/flutter/dart-developer/TimelineTask-class.html

![Screenshot da aba de eventos de timeline](/assets/images/docs/tools/devtools/timeline-events-tab.png)
Para ajuda com a navegação e o uso do visualizador de rastreamento,
clique no botão **?** no canto superior direito da barra da aba de
eventos de timeline. Para atualizar a timeline com novos eventos do seu
aplicativo, clique no botão de atualização (também no canto superior
direito dos controles da aba).

## Ferramentas avançadas de debug

### Aprimorar rastreamento

Para visualizar rastreamentos mais detalhados no gráfico de eventos de
timeline, use as opções no dropdown de aprimorar rastreamento:

:::note
Os tempos de frame podem ser afetados negativamente quando essas opções são habilitadas.
:::

![Screenshot das opções de rastreamento aprimorado](/assets/images/docs/tools/devtools/enhanced-tracing.png)

Para ver os novos eventos de timeline, reproduza a atividade no seu app
que você está interessado em rastrear e, em seguida, selecione um frame
para inspecionar a timeline.

### Rastrear construções de widget

Para ver os eventos do método `build()` na timeline, habilite a opção
**Rastrear construções de Widget**. O nome do widget é exibido no evento
da timeline.

![Screenshot de rastrear construções de widget](/assets/images/docs/tools/devtools/track-widget-builds.png)

[Assista a este vídeo para um exemplo de rastreamento de construções de widgets][rastrear-widgets]

### Rastrear layouts

Para ver os eventos de layout de objetos de renderização na timeline,
habilite a opção **Rastrear layouts**:

![Screenshot de rastrear layouts](/assets/images/docs/tools/devtools/track-layouts.png)

[Assista a este vídeo para um exemplo de rastreamento de layouts][rastrear-layouts]

### Rastrear pinturas

Para ver os eventos de pintura de objetos de renderização na timeline,
habilite a opção **Rastrear pinturas**:

![Screenshot de rastrear pinturas](/assets/images/docs/tools/devtools/track-paints.png)

[Assista a este vídeo para um exemplo de rastreamento de pinturas][rastrear-paints]

## Mais opções de debug

Para diagnosticar problemas de performance relacionados a camadas de
renderização, desative uma camada de renderização. Essas opções são
habilitadas por padrão.

Para ver os efeitos na performance do seu app, reproduza a atividade no
seu app. Em seguida, selecione os novos frames no gráfico de frames para
inspecionar os eventos de timeline com as camadas desabilitadas. Se o
tempo raster diminuiu significativamente, o uso excessivo dos efeitos que
você desabilitou pode estar contribuindo para o jank que você viu no seu
app.

**Renderizar camadas de Clip**
: Desabilite esta opção para verificar se o uso excessivo de clipping
  está afetando a performance. Se a performance melhorar com esta
  opção desabilitada, tente reduzir o uso de efeitos de clipping no
  seu app.

**Renderizar camadas de Opacidade**
: Desabilite esta opção para verificar se o uso excessivo de efeitos de
  opacidade está afetando a performance. Se a performance melhorar com
  esta opção desabilitada, tente reduzir o uso de efeitos de opacidade no
  seu app.

**Renderizar camadas de Formato Físico**
: Desabilite esta opção para verificar se o uso excessivo de efeitos de
  modelagem física está afetando a performance, como sombras ou elevação.
  Se a performance melhorar com esta opção desabilitada, tente reduzir o
  uso de efeitos de modelagem física no seu app.

![Screenshot de mais opções de debug](/assets/images/docs/tools/devtools/more-debugging-options.png)

## Importar e exportar

O DevTools suporta a importação e exportação de snapshots de performance.
Clicar no botão de exportação (canto superior direito acima do gráfico
de renderização de frames) baixa um snapshot dos dados atuais na página de
performance. Para importar um snapshot de performance, você pode arrastar
e soltar o snapshot no DevTools de qualquer página. **Observe que o
DevTools só suporta a importação de arquivos que foram originalmente
exportados do DevTools.**

## Outros recursos

Para aprender como monitorar a performance de um app e detectar jank usando
o DevTools, confira um [tutorial guiado da visualização de performance][tutorial-de-performance].

[gráfico da GPU]: /perf/ui-performance#identifying-problems-in-the-gpu-graph
[Profiling de performance do Flutter]: /perf/ui-performance
[Reduzir o jank de compilação de shader no mobile]: /perf/shader
[Importar e exportar]: #importar-e-exportar
[tutorial-de-performance]: {{site.medium}}/@fluttergems/mastering-dart-flutter-devtools-performance-view-part-8-of-8-4ae762f91230
[rastrear-widgets]: {{site.yt.watch}}/_EYk-E29edo?t=623
[rastrear-layouts]: {{site.yt.watch}}/_EYk-E29edo?t=676
[rastrear-paints]: {{site.yt.watch}}/_EYk-E29edo?t=748
