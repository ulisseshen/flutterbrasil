---
ia-translate: true
title: Perfil de desempenho do Flutter
subtitle: Onde procurar quando seu aplicativo Flutter perde frames na UI.
description: Diagnóstico de problemas de desempenho da UI no Flutter.
---

{% render docs/performance.md %}

:::secondary O que você aprenderá
* O Flutter visa fornecer um desempenho de 60 frames por segundo (fps), ou 120 fps em dispositivos capazes de atualizações de 120 Hz.
* Para 60 fps, os frames precisam ser renderizados aproximadamente a cada 16 ms.
* O "jank" ocorre quando a UI não renderiza suavemente. Por exemplo, de vez em quando, um frame leva 10 vezes mais tempo para renderizar, então ele é perdido e a animação visivelmente sacode.
:::

Já foi dito que "um aplicativo _rápido_ é ótimo, mas um aplicativo _suave_ é ainda melhor". Se o seu aplicativo não está renderizando suavemente, como você corrige isso? Por onde você começa? Este guia mostra por onde começar, os passos a seguir e as ferramentas que podem ajudar.

:::note
* O desempenho de um aplicativo é determinado por mais de uma medida. O desempenho às vezes se refere à velocidade bruta, mas também à suavidade da UI e à falta de stutter. Outros exemplos de desempenho incluem velocidade de I/O ou de rede. Esta página se concentra principalmente no segundo tipo de desempenho (suavidade da UI), mas você pode usar a maioria das mesmas ferramentas para diagnosticar outros problemas de desempenho.
* Para realizar tracing dentro do seu código Dart, consulte [Rastreando código Dart][] na página [Depuração][].
:::

[Depuração]: /testing/debugging
[Rastreando código Dart]: /testing/code-debugging#trace-dart-code-performance

## Diagnóstico de problemas de desempenho

Para diagnosticar um aplicativo com problemas de desempenho, você habilitará a sobreposição de desempenho para analisar as threads da UI e rasterização. Antes de começar, certifique-se de que você está executando no [modo profile][], e que você não está usando um emulador. Para melhores resultados, você pode escolher o dispositivo mais lento que seus usuários possam usar.

[modo profile]: /testing/build-modes#profile

### Conecte-se a um dispositivo físico

Quase toda a depuração de desempenho para aplicativos Flutter deve ser realizada em um dispositivo físico Android ou iOS, com seu aplicativo Flutter sendo executado no [modo profile][]. O uso do modo debug, ou a execução de aplicativos em simuladores ou emuladores, geralmente não é indicativo do comportamento final das builds em modo release. _Você deve considerar verificar o desempenho no dispositivo mais lento que seus usuários possam razoavelmente usar._

:::secondary Por que você deve executar em um dispositivo real
* Simuladores e emuladores não usam o mesmo hardware, então suas características de desempenho são diferentes—algumas operações são mais rápidas em simuladores do que em dispositivos reais, e algumas são mais lentas.
* O modo debug habilita verificações adicionais (como asserts) que não são executadas em builds de profile ou release, e essas verificações podem ser custosas.
* O modo debug também executa código de uma maneira diferente do modo release. A build de debug compila o código Dart "just in time" (JIT) conforme o aplicativo é executado, mas as builds de profile e release são pré-compiladas para instruções nativas (também chamadas de "ahead of time", ou AOT) antes que o aplicativo seja carregado no dispositivo. JIT pode fazer com que o aplicativo pause para a compilação JIT, o que em si pode causar jank.
:::

### Executar no modo profile

O modo profile do Flutter compila e inicia seu aplicativo quase identicamente ao modo release, mas com funcionalidade adicional suficiente para permitir a depuração de problemas de desempenho. Por exemplo, o modo profile fornece informações de tracing para as ferramentas de perfil.

:::note
O Dart/Flutter DevTools não pode se conectar a um aplicativo web Flutter executando no modo profile. Use o Chrome DevTools para [gerar eventos de linha do tempo][] para um aplicativo web.
:::

[gerar eventos de linha do tempo]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference


Inicie o aplicativo no modo profile da seguinte forma:

* No VS Code, abra seu arquivo `launch.json` e defina a propriedade `flutterMode` como `profile` (quando terminar de fazer o perfil, altere-o de volta para `release` ou `debug`):

  ```json
  "configurations": [
    {
      "name": "Flutter",
      "request": "launch",
      "type": "dart",
      "flutterMode": "profile"
    }
  ]
  ```
* No Android Studio e IntelliJ, use o item de menu **Run > Flutter Run main.dart in Profile Mode**.
* Na linha de comando, use o flag `--profile`:

  ```console
  $ flutter run --profile
  ```

Para obter mais informações sobre os diferentes modos, consulte [modos de build do Flutter][].

Você começará abrindo o DevTools e visualizando a sobreposição de desempenho, conforme discutido na próxima seção.

[modos de build do Flutter]: /testing/build-modes

## Iniciar o DevTools

O DevTools fornece recursos como profiling, exame do heap, exibição de cobertura de código, habilitação da sobreposição de desempenho e um depurador passo a passo. A [visão Timeline][] do DevTools permite que você investigue o desempenho da UI do seu aplicativo frame a frame.

Depois que seu aplicativo estiver em execução no modo profile, [inicie o DevTools][].

[inicie o DevTools]: /tools/devtools
[visão Timeline]: /tools/devtools/performance

<a id="the-performance-overlay" aria-hidden="true"></a>

## A sobreposição de desempenho {:#performance-overlay}

A sobreposição de desempenho exibe estatísticas em dois gráficos que mostram onde o tempo está sendo gasto em seu aplicativo. Se a UI estiver com jank (pulando frames), esses gráficos ajudam você a descobrir o porquê. Os gráficos são exibidos em cima do seu aplicativo em execução, mas eles não são desenhados como um widget normal—o próprio mecanismo do Flutter pinta a sobreposição e impacta minimamente o desempenho. Cada gráfico representa os últimos 300 frames para essa thread.

Esta seção descreve como habilitar a sobreposição de desempenho e usá-la para diagnosticar a causa do jank em seu aplicativo. A seguinte captura de tela mostra a sobreposição de desempenho em execução no exemplo do Flutter Gallery:

![Captura de tela da sobreposição mostrando zero jank](/assets/images/docs/tools/devtools/performance-overlay-green.png)
<br>Sobreposição de desempenho mostrando a thread raster (superior) e a thread da UI (inferior).<br>As barras verticais verdes representam o frame atual.

## Interpretando os gráficos

O gráfico superior (marcado como "GPU") mostra o tempo gasto pela thread raster, o gráfico inferior mostra o tempo gasto pela thread da UI. As linhas brancas nos gráficos mostram incrementos de 16 ms ao longo do eixo vertical; se o gráfico passar por cima de uma dessas linhas, então você está executando a menos de 60 Hz. O eixo horizontal representa os frames. O gráfico só é atualizado quando seu aplicativo pinta, então se estiver ocioso, o gráfico para de se mover.

A sobreposição deve ser sempre visualizada no [modo profile][], já que o desempenho do [modo debug][] é intencionalmente sacrificado em troca de asserts custosos que se destinam a auxiliar no desenvolvimento e, portanto, os resultados são enganosos.

Cada frame deve ser criado e exibido dentro de 1/60 de segundo (aproximadamente 16ms). Um frame que exceda este limite (em qualquer um dos gráficos) não é exibido, resultando em jank, e uma barra vermelha vertical aparece em um ou ambos os gráficos. Se uma barra vermelha aparecer no gráfico da UI, o código Dart é muito caro. Se uma barra vertical vermelha aparecer no gráfico da GPU, a cena é muito complicada para renderizar rapidamente.

![Captura de tela da sobreposição de desempenho mostrando jank com barras vermelhas](/assets/images/docs/tools/devtools/performance-overlay-jank.png)
<br>As barras verticais vermelhas indicam que o frame atual é caro para renderizar e pintar.<br>Quando ambos os gráficos exibem vermelho, comece diagnosticando a thread da UI.

[modo debug]: /testing/build-modes#debug

## Threads do Flutter

O Flutter usa várias threads para fazer seu trabalho, embora apenas duas das threads sejam mostradas na sobreposição. Todo o seu código Dart é executado na thread da UI. Embora você não tenha acesso direto a nenhuma outra thread, suas ações na thread da UI têm consequências de desempenho em outras threads.

**Thread da Plataforma**
: A thread principal da plataforma. O código do plugin é executado aqui. Para mais informações, veja a documentação do [UIKit][] para iOS, ou a documentação do [MainThread][] para Android. Essa thread não é mostrada na sobreposição de desempenho.

**Thread da UI**
: A thread da UI executa código Dart na Dart VM. Essa thread inclui código que você escreveu e código executado pelo framework do Flutter em nome do seu aplicativo. Quando seu aplicativo cria e exibe uma cena, a thread da UI cria uma _árvore de camadas_, um objeto leve que contém comandos de pintura independentes do dispositivo, e envia a árvore de camadas para a thread raster para ser renderizada no dispositivo. _Não bloqueie esta thread!_ Mostrado na linha inferior da sobreposição de desempenho.

**Thread Raster**
: A thread raster pega a árvore de camadas e a exibe se comunicando com a GPU (unidade de processamento gráfico). Você não pode acessar diretamente a thread raster ou seus dados, mas, se essa thread estiver lenta, é resultado de algo que você fez no código Dart. Skia e Impeller, as bibliotecas gráficas, são executadas nesta thread. Mostrado na linha superior da sobreposição de desempenho. Observe que enquanto a thread raster rasteriza para a GPU, a própria thread é executada na CPU.

**Thread de I/O**
: Realiza tarefas caras (principalmente I/O) que, de outra forma, bloqueariam as threads da UI ou raster. Essa thread não é mostrada na sobreposição de desempenho.
    
Para links para mais informações e vídeos, veja [A arquitetura do Framework][] no [wiki do Flutter][], e o artigo da comunidade, [O Bolo de Camadas][].

[wiki do Flutter]: {{site.repo.flutter}}/tree/master/docs
[MainThread]: {{site.android-dev}}/reference/android/support/annotation/MainThread
[A arquitetura do Framework]: {{site.repo.flutter}}/blob/master/docs/about/The-Framework-architecture.md
[O Bolo de Camadas]: {{site.medium}}/flutter-community/the-layer-cake-widgets-elements-renderobjects-7644c3142401
[UIKit]: {{site.apple-dev}}/documentation/uikit

### Exibindo a sobreposição de desempenho

Você pode alternar a exibição da sobreposição de desempenho da seguinte forma:

* Usando o inspetor Flutter
* Da linha de comando
* Programaticamente

#### Usando o inspetor Flutter

A maneira mais fácil de habilitar o widget PerformanceOverlay é no inspetor Flutter, que está disponível na [visão Inspector][] no [DevTools][]. Basta clicar no botão **Performance Overlay** para alternar a sobreposição em seu aplicativo em execução.

[visão Inspector]: /tools/devtools/inspector

#### Da linha de comando

Alterne a sobreposição de desempenho usando a tecla **P** na linha de comando.

#### Programaticamente

Para habilitar a sobreposição programaticamente, veja [Sobreposição de desempenho][], uma seção na página [Depurando aplicativos Flutter programaticamente][].

[Depurando aplicativos Flutter programaticamente]: /testing/code-debugging
[Sobreposição de desempenho]: /testing/code-debugging#add-performance-overlay

## Identificando problemas no gráfico da UI

Se a sobreposição de desempenho mostrar vermelho no gráfico da UI, comece fazendo o perfil da Dart VM, mesmo que o gráfico da GPU também mostre vermelho.

## Identificando problemas no gráfico da GPU

Às vezes, uma cena resulta em uma árvore de camadas que é fácil de construir, mas cara para renderizar na thread raster. Quando isso acontece, o gráfico da UI não tem vermelho, mas o gráfico da GPU mostra vermelho. Nesse caso, você precisará descobrir o que seu código está fazendo que está causando lentidão no código de renderização. Tipos específicos de cargas de trabalho são mais difíceis para a GPU. Elas podem envolver chamadas desnecessárias para [`saveLayer`][], interseções de opacidades com vários objetos e clips ou sombras em situações específicas.

Se você suspeitar que a fonte da lentidão é durante uma animação, clique no botão **Slow Animations** no inspetor do Flutter para desacelerar as animações em 5x. Se você quiser mais controle sobre a velocidade, você também pode fazer isso [programaticamente][].

A lentidão está no primeiro frame ou em toda a animação? Se for em toda a animação, o clipping está causando a lentidão? Talvez haja uma maneira alternativa de desenhar a cena que não use clipping. Por exemplo, sobreponha cantos opacos em um quadrado em vez de fazer clipping para um retângulo arredondado. Se for uma cena estática que está sendo desvanecida, girada ou manipulada de outra forma, um [`RepaintBoundary`][] pode ajudar.

[programaticamente]: /testing/code-debugging#debug-animation-issues
[`RepaintBoundary`]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[`saveLayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

#### Verificando camadas fora da tela

O método [`saveLayer`][] é um dos métodos mais caros do framework do Flutter. É útil ao aplicar pós-processamento à cena, mas pode deixar seu aplicativo mais lento e deve ser evitado se você não precisar dele. Mesmo que você não chame `saveLayer` explicitamente, chamadas implícitas podem acontecer em seu nome, por exemplo, ao especificar [`Clip.antiAliasWithSaveLayer`][] (normalmente como um `clipBehavior`).

Por exemplo, talvez você tenha um grupo de objetos com opacidades que são renderizados usando `saveLayer`. Nesse caso, provavelmente é mais eficiente aplicar uma opacidade a cada widget individual, em vez de um widget pai mais acima na árvore de widgets. O mesmo vale para outras operações potencialmente caras, como clipping ou sombras.

:::note
Opacidade, clipping e sombras não são, em si, uma má ideia. No entanto, aplicá-los ao topo da árvore de widgets pode causar chamadas extras para `saveLayer` e processamento desnecessário.
:::

Quando você encontrar chamadas para `saveLayer`, faça a si mesmo estas perguntas:

* O aplicativo precisa desse efeito?
* Alguma dessas chamadas pode ser eliminada?
* Posso aplicar o mesmo efeito a um elemento individual em vez de um grupo?

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html

#### Verificando imagens não armazenadas em cache

Armazenar em cache uma imagem com [`RepaintBoundary`][] é bom, _quando faz sentido_.

Uma das operações mais caras, do ponto de vista dos recursos, é renderizar uma textura usando um arquivo de imagem. Primeiro, a imagem compactada é buscada do armazenamento persistente. A imagem é descompactada na memória do host (memória da GPU) e transferida para a memória do dispositivo (RAM).

Em outras palavras, I/O de imagem pode ser caro. O cache fornece snapshots de hierarquias complexas para que sejam mais fáceis de renderizar em frames subsequentes. _Como as entradas de cache raster são caras para construir e consomem muita memória da GPU, armazene imagens em cache apenas onde for absolutamente necessário._

### Visualizando o profiler de reconstrução de widgets

O framework do Flutter foi projetado para dificultar a criação de aplicativos que não sejam suaves e 60fps. Muitas vezes, se você tem jank, é porque há um bug simples fazendo com que mais da UI seja reconstruída a cada frame do que o necessário. O profiler de reconstrução de widgets ajuda você a depurar e corrigir problemas de desempenho devido a esses tipos de bugs.

Você pode visualizar as contagens de widgets reconstruídos para a tela atual e o frame no plugin Flutter para Android Studio e IntelliJ. Para detalhes sobre como fazer isso, veja [Mostrar dados de desempenho][]

[Mostrar dados de desempenho]: /tools/android-studio#show-performance-data

## Benchmarking

Você pode medir e acompanhar o desempenho do seu aplicativo escrevendo testes de benchmark. A biblioteca Flutter Driver fornece suporte para benchmarking. Usando este framework de teste de integração, você pode gerar métricas para acompanhar o seguinte:

* Jank
* Tamanho do download
* Eficiência da bateria
* Tempo de inicialização

O acompanhamento desses benchmarks permite que você seja informado quando uma regressão é introduzida que afeta adversamente o desempenho.

Para mais informações, confira [Teste de integração][].

[Teste de integração]: /testing/integration-tests

## Outros recursos

Os seguintes recursos fornecem mais informações sobre como usar as ferramentas do Flutter e depurar no Flutter:

* [Depuração][]
* [Inspetor do Flutter][]
* [Palestra sobre o inspetor do Flutter][], apresentada na DartConf 2018
* [Por que o Flutter usa Dart][], um artigo no Hackernoon
* [Por que o Flutter usa Dart][video], um vídeo no canal do Flutter
* [DevTools][devtools]: ferramentas de desempenho para aplicativos Dart e Flutter
* Documentos da [API do Flutter][], particularmente a classe [`PerformanceOverlay`][] e o pacote [dart:developer][]

[dart:developer]: {{site.api}}/flutter/dart-developer/dart-developer-library.html
[devtools]: /tools/devtools
[API do Flutter]: {{site.api}}
[Inspetor do Flutter]: /tools/devtools/inspector
[Palestra sobre o inspetor do Flutter]: {{site.yt.watch}}?v=JIcmJNT9DNI
[`PerformanceOverlay`]: {{site.api}}/flutter/widgets/PerformanceOverlay-class.html
[video]: {{site.yt.watch}}?v=5F-6n_2XWR8
[Por que o Flutter usa Dart]: https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf
