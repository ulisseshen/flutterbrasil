---
ia-translate: true
title: Profiling de performance do Flutter
subtitle: Onde procurar quando sua aplicação Flutter perde frames na UI.
description: Diagnosticando problemas de performance de UI no Flutter.
---

## Visão geral

Performance de aplicação engloba vários aspectos, desde velocidade bruta e throughput de I/O
até a suavidade da interface do usuário. Embora esta página se concentre principalmente na suavidade
da UI (falta de stuttering ou jank), as ferramentas descritas aqui podem frequentemente ser usadas
para diagnosticar outros problemas de performance também.

Flutter oferece várias ferramentas para análise de performance. Aqui estão algumas delas:

* **The Performance Overlay**: Exibe um conjunto simplificado de métricas diretamente
  dentro da sua aplicação em execução. Para saber mais, veja as seções neste tópico.

* **The Performance View**: Uma interface baseada na web que se conecta à sua aplicação e
  exibe métricas de performance detalhadas. Parte do utilitário DevTools. Para saber
  mais, veja [Use the Performance View][Use the Performance View].

* **Performance tracing dentro do Dart**: Adicione tracing diretamente ao código Dart da sua aplicação,
  usando o `dart:developer package`, e então rastreie a performance da sua aplicação
  no utilitário DevTools. Para saber mais, veja [Tracing Dart code][Tracing Dart code].

* **Benchmarking**: Você pode medir e rastrear a performance da sua aplicação escrevendo
  testes de benchmark. A biblioteca Flutter Driver fornece suporte
  para benchmarking. Usando este framework de teste de integração,
  você pode gerar métricas que rastreiam jank, tamanho de download, eficiência de bateria,
  e tempo de inicialização. Para mais informações, confira [Integration testing][Integration testing].

* **Widget rebuild profiler (IntelliJ para Android Studio)**: Jank frequentemente surge
  de rebuilds de UI desnecessários. Se você está usando IntelliJ para Android Studio,
  o Widget Rebuild Profiler ajuda a identificar e corrigir esses problemas mostrando
  contagens de rebuild de widget para a tela e frame atuais. Para mais informações,
  veja [Show performance data][Show performance data].

Flutter visa fornecer 60 frames por segundo (fps) de performance,
ou 120 fps em dispositivos que suportam isso. Para atingir 60fps, cada frame deve
renderizar aproximadamente a cada 16ms para evitar jank. Jank ocorre quando frames levam
significativamente mais tempo para renderizar e são descartados, resultando em um stuttering visível
nas animações. Por exemplo, se um frame ocasionalmente leva 10 vezes mais tempo do que
o usual para renderizar, ele provavelmente será descartado, fazendo a animação parecer
irregular.

[Use the Performance View]: /tools/devtools/performance
[Tracing Dart code]: /testing/code-debugging#trace-dart-code-performance
[Show performance data]: /tools/android-studio#show-performance-data
[Integration testing]: /testing/integration-tests

## Conectar a um dispositivo físico

Quase toda depuração de performance para aplicações Flutter
deve ser conduzida em um dispositivo Android ou iOS físico,
com sua aplicação Flutter executando em [profile mode][profile mode].
Usar debug mode, ou executar aplicações em simuladores
ou emuladores, geralmente não é indicativo do comportamento final
de builds de release mode.
_Você deve considerar verificar a performance
no dispositivo mais lento que seus usuários possam razoavelmente usar._

:::secondary Por que você deve executar em um dispositivo real
* Simuladores e emuladores não usam o mesmo hardware, então suas
  características de performance são diferentes&mdash;algumas operações são
  mais rápidas em simuladores do que em dispositivos reais, e algumas são mais lentas.
* Debug mode habilita verificações adicionais (como asserts) que não executam
  em builds de profile ou release, e essas verificações podem ser caras.
* Debug mode também executa código de uma maneira diferente do release mode.
  O build de debug compila o código Dart "just in time" (JIT) enquanto a
  aplicação executa, mas builds de profile e release são pré-compilados para instruções nativas
  (também chamado de "ahead of time", ou AOT) antes da aplicação ser
  carregada no dispositivo. JIT pode fazer a aplicação pausar para compilação JIT,
  o que pode causar jank.
:::

## Executar em profile mode

O profile mode do Flutter compila e executa sua aplicação
quase identicamente ao release mode, mas com funcionalidade adicional suficiente
para permitir depuração de problemas de performance.
Por exemplo, profile mode fornece informações de tracing para as
ferramentas de profiling.

:::note
Dart/Flutter DevTools não pode se conectar a uma
aplicação Flutter web executando em profile mode.
Use Chrome DevTools para
[gerar eventos de timeline][generate timeline events] para uma aplicação web.
:::

Execute a aplicação em profile mode da seguinte forma:

* No VS Code, abra seu arquivo `launch.json`, e defina a
  propriedade `flutterMode` para `profile`
  (quando terminar o profiling, altere de volta para `release` ou `debug`):

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
* No Android Studio e IntelliJ, use o item de menu
  **Run > Flutter Run main.dart in Profile Mode**.
* Da linha de comando, use a flag `--profile`:

  ```console
  $ flutter run --profile
  ```

Para mais informações sobre os diferentes modos,
veja [Flutter's build modes][Flutter's build modes].

Você começará abrindo DevTools e visualizando
o performance overlay, como discutido na próxima seção.

[Flutter's build modes]: /testing/build-modes
[generate timeline events]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference

## Executar DevTools

DevTools fornece recursos como profiling, examinando o heap,
exibindo cobertura de código, habilitando o performance overlay,
e um debugger passo a passo.
A [Timeline view][Timeline view] do DevTools permite que você investigue a
performance de UI da sua aplicação em uma base frame a frame.

Uma vez que sua aplicação esteja executando em profile mode,
[execute DevTools][launch DevTools].

[Timeline view]: /tools/devtools/performance
[launch DevTools]: /tools/devtools

## Exibir o performance overlay {:#displaying-the-performance-overlay}

Você pode alternar a exibição do performance overlay da
seguinte forma:

* **DevTools Performance view**: A maneira mais fácil de habilitar o
  widget PerformanceOverlay é a partir da [Performance view][Performance view] no [DevTools][DevTools].
  Simplesmente clique no botão **Performance Overlay** para alternar o overlay na sua
  aplicação em execução.

* **linha de comando**: Alterne o performance overlay usando a tecla **P** da
  linha de comando.

* **programaticamente**: Para habilitar o overlay programaticamente, veja
  [Performance overlay][Performance overlay], uma seção na
  página [Debugging Flutter apps programmatically][Debugging Flutter apps programmatically].

[Performance overlay]: /testing/code-debugging#add-performance-overlay
[Debugging Flutter apps programmatically]: /testing/code-debugging

<a id="the-performance-overlay" aria-hidden="true"></a>

## Observar o performance overlay {:#performance-overlay}

O performance overlay exibe estatísticas em dois gráficos
que mostram onde o tempo está sendo gasto na sua aplicação. Se a UI
está com jank (pulando frames), esses gráficos ajudam você a descobrir o porquê.
Os gráficos exibem no topo da sua aplicação em execução, mas eles não são
desenhados como um widget normal&mdash;o próprio engine do Flutter
pinta o overlay e impacta minimamente a performance.
Cada gráfico representa os últimos 300 frames para aquela thread.

Esta seção descreve como habilitar o performance overlay
e usá-lo para diagnosticar a causa de jank na sua aplicação.
A seguinte captura de tela mostra o performance overlay executando
no exemplo Flutter Gallery:

![Screenshot of overlay showing zero jank](/assets/images/docs/tools/devtools/performance-overlay-green.png)
<br>Performance overlay mostrando a raster thread (topo),
e UI thread (inferior).<br>As barras verdes verticais
representam o frame atual.

### Revisar os gráficos {:#interpreting-the-graphs}

O gráfico superior (marcado "GPU") mostra o tempo gasto pela
raster thread, o gráfico inferior mostra o tempo
gasto pela UI thread.
As linhas brancas nos gráficos mostram incrementos de 16ms
ao longo do eixo vertical; se o gráfico alguma vez passar por uma
dessas linhas, então você está executando a menos de 60Hz.
O eixo horizontal representa frames. O gráfico é
atualizado apenas quando sua aplicação pinta,
então se estiver ociosa, o gráfico para de se mover.

O overlay deve sempre ser visualizado em [profile mode][profile mode],
já que a performance do [debug mode][debug mode] é intencionalmente sacrificada
em troca de asserts caros que são destinados a auxiliar
o desenvolvimento, e portanto os resultados são enganosos.

Cada frame deve ser criado e exibido dentro de 1/60 de
segundo (aproximadamente 16ms). Um frame que excede este limite
(em qualquer gráfico) falha em exibir, resultando em jank,
e uma barra vermelha vertical aparece em um ou ambos os gráficos.
Se uma barra vermelha aparece no gráfico de UI, o código Dart é muito
caro. Se uma barra vermelha vertical aparece no gráfico de GPU,
a cena é muito complicada para renderizar rapidamente.

![Screenshot of performance overlay showing jank with red bars](/assets/images/docs/tools/devtools/performance-overlay-jank.png)
<br>As barras vermelhas verticais indicam que o frame atual é
caro tanto para renderizar quanto para pintar.<br>Quando ambos os gráficos
exibem vermelho, comece diagnosticando a UI thread.

### Revisar as threads {:#flutters-threads}

Flutter usa várias threads para fazer seu trabalho, embora
apenas duas das threads sejam mostradas no overlay.
Todo seu código Dart é executado na UI thread.
Embora você não tenha acesso direto a nenhuma outra thread,
suas ações na UI thread têm consequências de performance
em outras threads.

**Platform thread**
: A thread principal da plataforma. Código de plugin é executado aqui.
  Para mais informações, veja a documentação [UIKit][UIKit] para iOS,
  ou a documentação [MainThread][MainThread] para Android.
  _Esta thread não é mostrada no performance overlay._

**UI thread**
: A UI thread executa código Dart na Dart VM.
  Esta thread inclui código que você escreveu, e código executado pelo
  framework do Flutter em nome da sua aplicação.
  Quando sua aplicação cria e exibe uma cena, a UI thread cria
  uma _layer tree_, um objeto leve contendo comandos de
  pintura independentes de dispositivo, e envia a layer tree para a raster thread para
  ser renderizada no dispositivo. _Não bloqueie esta thread!_
  Mostrada na linha inferior do performance overlay.

**Raster thread**
: A raster thread pega a layer tree e a exibe
  conversando com a GPU (unidade de processamento gráfico).
  Você não pode acessar diretamente a raster thread ou seus dados mas,
  se esta thread está lenta, é resultado de algo que você fez
  no código Dart. Skia e Impeller, as bibliotecas gráficas,
  executam nesta thread.
  Mostrada na linha superior do performance overlay.
  Note que enquanto a raster thread rasteriza para a GPU,
  a própria thread executa na CPU.

**I/O thread**
: Executa tarefas caras (principalmente I/O) que
  de outra forma bloqueariam a UI ou raster threads.
  _Esta thread não é mostrada no performance overlay._

Para links para mais informações e vídeos,
veja [The Framework architecture][The Framework architecture] no
[Flutter wiki][Flutter wiki], e o artigo da comunidade,
[The Layer Cake][The Layer Cake].

[debug mode]: /testing/build-modes#debug
[Flutter wiki]: {{site.repo.flutter}}/tree/main/docs
[UIKit]: {{site.apple-dev}}/documentation/uikit
[The Layer Cake]: {{site.medium}}/flutter-community/the-layer-cake-widgets-elements-renderobjects-7644c3142401
[The Framework architecture]: {{site.repo.flutter}}/blob/main/docs/about/The-Framework-architecture.md
[MainThread]: {{site.android-dev}}/reference/android/support/annotation/MainThread

## Identificar problemas

### Revisar o gráfico de UI {:#identifying-problems-in-the-ui-graph}

Se o performance overlay mostra vermelho no gráfico de UI,
comece fazendo profiling da Dart VM, mesmo se o gráfico de GPU
também mostrar vermelho.

### Revisar o gráfico de GPU {:#identifying-problems-in-the-gpu-graph}

Às vezes uma cena resulta em uma layer tree que é fácil de construir,
mas cara para renderizar na raster thread. Quando isso acontece,
o gráfico de UI não tem vermelho, mas o gráfico de GPU mostra vermelho.
Neste caso, você precisará descobrir o que seu código está fazendo
que está fazendo o código de renderização ser lento. Tipos específicos de cargas de trabalho
são mais difíceis para a GPU. Eles podem envolver chamadas desnecessárias
a [`saveLayer`][saveLayer], opacidades que se intersectam com múltiplos objetos,
e clips ou sombras em situações específicas.

Se você suspeita que a fonte da lentidão está durante uma animação,
clique no botão **Slow Animations** no Flutter inspector
para tornar as animações mais lentas em 5x.
Se você quiser mais controle sobre a velocidade, você também pode fazer isso
[programaticamente][programmatically].

A lentidão está no primeiro frame, ou em toda a animação?
Se for toda a animação, o clipping está causando a lentidão?
Talvez haja uma maneira alternativa de desenhar a cena que não
use clipping. Por exemplo, sobreponha cantos opacos em um quadrado
em vez de fazer clipping para um retângulo arredondado.
Se é uma cena estática que está sendo esmaecida, rotacionada, ou de outra forma
manipulada, um [`RepaintBoundary`][RepaintBoundary] pode ajudar.

[programmatically]: /testing/code-debugging#debug-animation-issues

#### Verificando offscreen layers

O método [`saveLayer`][saveLayer] é um dos métodos mais caros no
framework Flutter. É útil ao aplicar pós-processamento
à cena, mas pode tornar sua aplicação lenta e deve ser evitado se
você não precisar dele. Mesmo que você não chame `saveLayer` explicitamente,
chamadas implícitas podem acontecer em seu nome, por exemplo ao especificar
[`Clip.antiAliasWithSaveLayer`][Clip.antiAliasWithSaveLayer] (tipicamente como um `clipBehavior`).

Por exemplo,
talvez você tenha um grupo de objetos com opacidades que são renderizados
usando `saveLayer`. Neste caso, é provavelmente mais performático
aplicar uma opacidade a cada widget individual, em vez de um widget
pai mais acima na árvore de widgets. O mesmo vale para
outras operações potencialmente caras, como clipping ou sombras.

:::note
Opacidade, clipping e sombras não são, em si,
uma má ideia. No entanto, aplicá-los ao topo da
árvore de widgets pode causar chamadas extras a `saveLayer`,
e processamento desnecessário.
:::

Quando você encontrar chamadas a `saveLayer`,
faça a si mesmo estas perguntas:

* A aplicação precisa deste efeito?
* Alguma dessas chamadas pode ser eliminada?
* Posso aplicar o mesmo efeito a um elemento individual em vez de um grupo?

[Clip.antiAliasWithSaveLayer]: {{site.api}}/flutter/dart-ui/Clip.html

#### Verificando imagens não cacheadas

Cachear uma imagem com [`RepaintBoundary`][RepaintBoundary] é bom,
_quando faz sentido_.

Uma das operações mais caras,
de uma perspectiva de recursos,
é renderizar uma textura usando um arquivo de imagem.
Primeiro, a imagem comprimida
é buscada do armazenamento persistente.
A imagem é descomprimida na memória host (memória GPU),
e transferida para a memória do dispositivo (RAM).

Em outras palavras, I/O de imagem pode ser caro.
O cache fornece snapshots de hierarquias complexas para
que sejam mais fáceis de renderizar em frames subsequentes.
_Como entradas de cache raster são caras para
construir e ocupam muita memória GPU,
cache imagens apenas onde absolutamente necessário._

## Outros recursos

Os seguintes recursos fornecem mais informações sobre usar
as ferramentas do Flutter e depuração no Flutter:

* [Debugging][Debugging]
* [Performance view][Performance view]
* [Flutter inspector][Flutter inspector]
* [Flutter inspector talk][Flutter inspector talk], apresentado na DartConf 2018
* [Why Flutter Uses Dart][Why Flutter Uses Dart], um artigo no Hackernoon
* [Why Flutter uses Dart][video], um vídeo no canal Flutter
* [DevTools][devtools]: ferramentas de performance para aplicações Dart e Flutter
* [Flutter API][Flutter API] docs, particularmente a classe [`PerformanceOverlay`][PerformanceOverlay],
  e o package [dart:developer][dart:developer]

[PerformanceOverlay]: {{site.api}}/flutter/widgets/PerformanceOverlay-class.html
[RepaintBoundary]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[saveLayer]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html
[dart:developer]: {{site.api}}/flutter/dart-developer/dart-developer-library.html
[Debugging]: /testing/debugging
[devtools]: /tools/devtools
[Flutter API]: {{site.api}}
[Flutter inspector talk]: {{site.yt.watch}}?v=JIcmJNT9DNI
[Flutter inspector]: /tools/devtools/inspector
[Performance view]: /tools/devtools/performance
[DevTools]: /tools/devtools
[profile mode]: /testing/build-modes#profile
[video]: {{site.yt.watch}}?v=5F-6n_2XWR8
[Why Flutter Uses Dart]: https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf
