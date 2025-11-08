---
ia-translate: true
title: Criação de perfil de desempenho do Flutter
subtitle: Onde procurar quando seu app Flutter perde frames na UI.
description: Diagnosticando problemas de desempenho de UI no Flutter.
---

{% render docs/performance.md %}

:::secondary O que você aprenderá
* Flutter visa fornecer desempenho de 60 frames por segundo (fps),
  ou desempenho de 120 fps em dispositivos capazes de atualizações de 120Hz.
* Para 60fps, frames precisam renderizar aproximadamente a cada 16ms.
* Jank ocorre quando a UI não renderiza suavemente. Por exemplo,
  de vez em quando, um frame leva 10 vezes mais tempo para renderizar,
  então ele é descartado, e a animação visivelmente trava.
:::

Foi dito que "um app _rápido_ é ótimo,
mas um app _suave_ é ainda melhor."
Se seu app não está renderizando suavemente,
como você conserta isso? Por onde você começa?
Este guia mostra onde começar,
passos a seguir, e ferramentas que podem ajudar.

:::note
* O desempenho de um app é determinado por mais de uma medida.
  Desempenho às vezes se refere à velocidade bruta, mas também à
  suavidade da UI e falta de gagueira. Outros exemplos de desempenho
  incluem velocidade de I/O ou rede. Esta página foca principalmente no
  segundo tipo de desempenho (suavidade da UI), mas você pode usar a maioria
  das mesmas ferramentas para diagnosticar outros problemas de desempenho.
* Para realizar rastreamento dentro do seu código Dart, veja [Tracing Dart code][]
  na página [Debugging][].
:::

[Debugging]: /testing/debugging
[Tracing Dart code]: /testing/code-debugging#trace-dart-code-performance

## Diagnosticando problemas de desempenho

Para diagnosticar um app com problemas de desempenho, você habilitará
o overlay de desempenho para olhar as threads de UI e raster.
Antes de começar, certifique-se de que está executando em
[modo profile][profile mode], e que não está usando um emulador.
Para melhores resultados, você pode escolher o dispositivo mais lento que
seus usuários possam usar.

[profile mode]: /testing/build-modes#profile

### Conecte a um dispositivo físico

Quase toda depuração de desempenho para aplicações Flutter
deve ser conduzida em um dispositivo físico Android ou iOS,
com sua aplicação Flutter executando em [modo profile][profile mode].
Usar modo debug, ou executar apps em simuladores
ou emuladores, geralmente não é indicativo do
comportamento final de builds de release mode.
_Você deve considerar verificar o desempenho
no dispositivo mais lento que seus usuários possam razoavelmente usar._

:::secondary Por que você deve executar em um dispositivo real
* Simuladores e emuladores não usam o mesmo hardware, então suas
  características de desempenho são diferentes&mdash;algumas operações são
  mais rápidas em simuladores do que em dispositivos reais, e algumas são mais lentas.
* O modo debug habilita verificações adicionais (como asserts) que não executam
  em builds profile ou release, e essas verificações podem ser caras.
* O modo debug também executa código de forma diferente do modo release.
  O build de debug compila o código Dart "just in time" (JIT) enquanto o
  app executa, mas builds profile e release são pré-compilados para instruções
  nativas (também chamadas de "ahead of time", ou AOT) antes do app ser
  carregado no dispositivo. JIT pode fazer o app pausar para compilação JIT,
  o que por si só pode causar jank.
:::

### Execute em modo profile

O modo profile do Flutter compila e inicia sua aplicação
quase identicamente ao modo release, mas com apenas funcionalidade adicional
suficiente para permitir depuração de problemas de desempenho.
Por exemplo, modo profile fornece informações de rastreamento para as
ferramentas de profiling.

:::note
Dart/Flutter DevTools não pode se conectar a um
app Flutter web executando em modo profile.
Use Chrome DevTools para
[gerar eventos de timeline][generate timeline events] para um app web.
:::

[generate timeline events]: {{site.developers}}/web/tools/chrome-devtools/evaluate-performance/performance-reference


Inicie o app em modo profile da seguinte forma:

* No VS Code, abra seu arquivo `launch.json`, e defina a
  propriedade `flutterMode` para `profile`
  (quando terminar o profiling, mude de volta para `release` ou `debug`):

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
* No Android Studio e IntelliJ, use o
  item de menu **Run > Flutter Run main.dart in Profile Mode**.
* A partir da linha de comando, use a flag `--profile`:

  ```console
  $ flutter run --profile
  ```

Para mais informações sobre os diferentes modos,
veja [modos de build do Flutter][Flutter's build modes].

Você começará abrindo DevTools e visualizando
o overlay de desempenho, conforme discutido na próxima seção.

[Flutter's build modes]: /testing/build-modes

## Lance DevTools

DevTools fornece recursos como profiling, exame do heap,
exibição de cobertura de código, habilitação do overlay de desempenho,
e um debugger passo a passo.
A [visualização Timeline][Timeline view] do DevTools permite que você investigue o
desempenho da UI da sua aplicação frame a frame.

Uma vez que seu app esteja executando em modo profile,
[lance DevTools][launch DevTools].

[launch DevTools]: /tools/devtools
[Timeline view]: /tools/devtools/performance

<a id="the-performance-overlay" aria-hidden="true"></a>

## O overlay de desempenho {:#performance-overlay}

O overlay de desempenho exibe estatísticas em dois gráficos
que mostram onde o tempo está sendo gasto no seu app. Se a UI
está travando (pulando frames), esses gráficos ajudam você a descobrir por quê.
Os gráficos são exibidos em cima do seu app em execução, mas não são
desenhados como um widget normal&mdash;o próprio motor Flutter
pinta o overlay e impacta minimamente o desempenho.
Cada gráfico representa os últimos 300 frames para aquela thread.

Esta seção descreve como habilitar o overlay de desempenho
e usá-lo para diagnosticar a causa do jank na sua aplicação.
A seguinte captura de tela mostra o overlay de desempenho executando
no exemplo Flutter Gallery:

![Screenshot of overlay showing zero jank](/assets/images/docs/tools/devtools/performance-overlay-green.png)
<br>Overlay de desempenho mostrando a thread raster (topo),
e thread UI (embaixo).<br>As barras verdes verticais
representam o frame atual.

## Interpretando os gráficos

O gráfico superior (marcado "GPU") mostra o tempo gasto pela
thread raster, o gráfico inferior mostra o tempo
gasto pela thread UI.
As linhas brancas através dos gráficos mostram incrementos de 16ms
ao longo do eixo vertical; se o gráfico alguma vez passar de uma
dessas linhas, então você está executando a menos de 60Hz.
O eixo horizontal representa frames. O gráfico é
atualizado apenas quando sua aplicação pinta,
então se estiver ocioso o gráfico para de se mover.

O overlay sempre deve ser visualizado em [modo profile][profile mode],
já que o desempenho do [modo debug][debug mode] é intencionalmente sacrificado
em troca de asserts caros que são destinados a auxiliar
o desenvolvimento, e portanto os resultados são enganosos.

Cada frame deve ser criado e exibido dentro de 1/60 de
segundo (aproximadamente 16ms). Um frame excedendo este limite
(em qualquer gráfico) falha em exibir, resultando em jank,
e uma barra vermelha vertical aparece em um ou ambos os gráficos.
Se uma barra vermelha aparece no gráfico UI, o código Dart é muito
caro. Se uma barra vermelha vertical aparece no gráfico GPU,
a cena é muito complicada para renderizar rapidamente.

![Screenshot of performance overlay showing jank with red bars](/assets/images/docs/tools/devtools/performance-overlay-jank.png)
<br>As barras vermelhas verticais indicam que o frame atual é
caro tanto para renderizar quanto para pintar.<br>Quando ambos os gráficos
exibem vermelho, comece diagnosticando a thread UI.

[debug mode]: /testing/build-modes#debug

## Threads do Flutter

Flutter usa várias threads para fazer seu trabalho, embora
apenas duas das threads sejam mostradas no overlay.
Todo seu código Dart executa na thread UI.
Embora você não tenha acesso direto a nenhuma outra thread,
suas ações na thread UI têm consequências de desempenho
em outras threads.

**Thread de plataforma**
: A thread principal da plataforma. Código de plugin executa aqui.
  Para mais informações, veja a documentação [UIKit][] para iOS,
  ou a documentação [MainThread][] para Android.
  Esta thread não é mostrada no overlay de desempenho.

**Thread UI**
: A thread UI executa código Dart na Dart VM.
  Esta thread inclui código que você escreveu, e código executado pelo
  framework Flutter em nome do seu app.
  Quando seu app cria e exibe uma cena, a thread UI cria
  uma _layer tree_, um objeto leve contendo comandos de
  pintura independentes de dispositivo, e envia a layer tree para a thread raster para
  ser renderizada no dispositivo. _Não bloqueie esta thread!_
  Mostrada na linha inferior do overlay de desempenho.

**Thread raster**
: A thread raster pega a layer tree e exibe
  ela conversando com a GPU (unidade de processamento gráfico).
  Você não pode acessar diretamente a thread raster ou seus dados mas,
  se esta thread está lenta, é resultado de algo que você fez
  no código Dart. Skia e Impeller, as bibliotecas gráficas,
  executam nesta thread.
  Mostrada na linha superior do overlay de desempenho.
  Note que enquanto a thread raster rasteriza para a GPU,
  a thread em si executa na CPU.

**Thread I/O**
: Realiza tarefas caras (principalmente I/O) que de outra forma
  bloqueariam a thread UI ou raster.
  Esta thread não é mostrada no overlay de desempenho.

Para links para mais informações e vídeos,
veja [The Framework architecture][] no
[wiki do Flutter][Flutter wiki], e o artigo da comunidade,
[The Layer Cake][].

[Flutter wiki]: {{site.repo.flutter}}/tree/main/docs
[MainThread]: {{site.android-dev}}/reference/android/support/annotation/MainThread
[The Framework architecture]: {{site.repo.flutter}}/blob/main/docs/about/The-Framework-architecture.md
[The Layer Cake]: {{site.medium}}/flutter-community/the-layer-cake-widgets-elements-renderobjects-7644c3142401
[UIKit]: {{site.apple-dev}}/documentation/uikit

### Exibindo o overlay de desempenho

Você pode alternar a exibição do overlay de desempenho da seguinte forma:

* Usando o Flutter inspector
* A partir da linha de comando
* Programaticamente

#### Usando o Flutter inspector

A maneira mais fácil de habilitar o widget PerformanceOverlay é
a partir do Flutter inspector, que está disponível na
[visualização Inspector][Inspector view] no [DevTools][]. Simplesmente clique no
botão **Performance Overlay** para alternar o overlay
no seu app em execução.

[Inspector view]: /tools/devtools/inspector

#### A partir da linha de comando

Alterne o overlay de desempenho usando a tecla **P** a partir
da linha de comando.

#### Programaticamente

Para habilitar o overlay programaticamente, veja
[Performance overlay][], uma seção na
página [Debugging Flutter apps programmatically][].

[Debugging Flutter apps programmatically]: /testing/code-debugging
[Performance overlay]: /testing/code-debugging#add-performance-overlay

## Identificando problemas no gráfico UI

Se o overlay de desempenho mostra vermelho no gráfico UI,
comece criando um perfil da Dart VM, mesmo se o gráfico GPU
também mostra vermelho.

<a id="identifying-problems-in-the-gpu-graph"></a>
## Identificando problemas no gráfico GPU

Às vezes uma cena resulta em uma layer tree que é fácil de construir,
mas cara para renderizar na thread raster. Quando isso acontece,
o gráfico UI não tem vermelho, mas o gráfico GPU mostra vermelho.
Neste caso, você precisará descobrir o que seu código está fazendo
que está causando o código de renderização a ser lento. Tipos específicos de cargas de trabalho
são mais difíceis para a GPU. Eles podem envolver chamadas desnecessárias
a [`saveLayer`][], opacidades se intersectando com múltiplos objetos,
e clips ou sombras em situações específicas.

Se você suspeita que a fonte da lentidão é durante uma animação,
clique no botão **Slow Animations** no Flutter inspector
para diminuir as animações em 5x.
Se você quer mais controle sobre a velocidade, você também pode fazer isso
[programaticamente][programmatically].

A lentidão está no primeiro frame, ou em toda a animação?
Se é toda a animação, clipping está causando a desaceleração?
Talvez haja uma forma alternativa de desenhar a cena que não
use clipping. Por exemplo, sobreponha cantos opacos em um quadrado
em vez de aplicar clipping a um retângulo arredondado.
Se é uma cena estática que está sendo esmaecida, rotacionada, ou de outra forma
manipulada, um [`RepaintBoundary`][] pode ajudar.

[programmatically]: /testing/code-debugging#debug-animation-issues
[`RepaintBoundary`]: {{site.api}}/flutter/widgets/RepaintBoundary-class.html
[`saveLayer`]: {{site.api}}/flutter/dart-ui/Canvas/saveLayer.html

#### Verificando por layers offscreen

O método [`saveLayer`][] é um dos métodos mais caros no
framework Flutter. É útil ao aplicar pós-processamento
à cena, mas pode deixar seu app lento e deve ser evitado se
você não precisar dele. Mesmo se você não chamar `saveLayer` explicitamente,
chamadas implícitas podem acontecer em seu nome, por exemplo ao especificar
[`Clip.antiAliasWithSaveLayer`][] (tipicamente como um `clipBehavior`).

Por exemplo,
talvez você tenha um grupo de objetos com opacidades que são renderizados
usando `saveLayer`. Neste caso, provavelmente é mais performante
aplicar opacidade a cada widget individual, em vez de um widget
pai mais alto na árvore de widgets. O mesmo vale para
outras operações potencialmente caras, como clipping ou sombras.

:::note
Opacity, clipping e sombras não são, em si mesmas,
uma má ideia. No entanto, aplicá-las ao topo da
árvore de widgets pode causar chamadas extras a `saveLayer`,
e processamento desnecessário.
:::

Quando você encontrar chamadas a `saveLayer`,
pergunte a si mesmo essas questões:

* O app precisa deste efeito?
* Alguma dessas chamadas pode ser eliminada?
* Posso aplicar o mesmo efeito a um elemento individual em vez de um grupo?

[`Clip.antiAliasWithSaveLayer`]: {{site.api}}/flutter/dart-ui/Clip.html

#### Verificando por imagens não cacheadas

Fazer cache de uma imagem com [`RepaintBoundary`][] é bom,
_quando faz sentido_.

Uma das operações mais caras,
de uma perspectiva de recursos,
é renderizar uma textura usando um arquivo de imagem.
Primeiro, a imagem comprimida
é buscada do armazenamento persistente.
A imagem é descomprimida em memória do host (memória GPU),
e transferida para memória do dispositivo (RAM).

Em outras palavras, I/O de imagem pode ser caro.
O cache fornece snapshots de hierarquias complexas para que
sejam mais fáceis de renderizar em frames subsequentes.
_Como entradas de cache raster são caras para
construir e ocupam muita memória GPU,
faça cache de imagens apenas onde absolutamente necessário._

### Visualizando o profiler de reconstrução de widgets

O framework Flutter é projetado para tornar difícil criar
aplicações que não sejam 60fps e suaves. Frequentemente, se você tem jank,
é porque há um bug simples causando mais da UI a ser
reconstruída a cada frame do que o necessário. O profiler de reconstrução de widgets
ajuda você a depurar e corrigir problemas de desempenho devido a esses tipos
de bugs.

Você pode visualizar as contagens de reconstrução de widgets para a tela e
frame atuais no plugin Flutter para Android Studio e IntelliJ.
Para detalhes sobre como fazer isso, veja [Show performance data][]

[Show performance data]: /tools/android-studio#show-performance-data

## Benchmarking

Você pode medir e rastrear o desempenho do seu app escrevendo
testes de benchmark. A biblioteca Flutter Driver fornece suporte
para benchmarking. Usando este framework de teste de integração,
você pode gerar métricas para rastrear o seguinte:

* Jank
* Tamanho de download
* Eficiência de bateria
* Tempo de inicialização

Rastrear esses benchmarks permite que você seja informado quando uma
regressão é introduzida que afeta adversamente o desempenho.

Para mais informações, confira [Integration testing][].

[Integration testing]: /testing/integration-tests

## Outros recursos

Os seguintes recursos fornecem mais informações sobre usar
as ferramentas do Flutter e depuração no Flutter:

* [Debugging][]
* [Flutter inspector][]
* [Flutter inspector talk][], apresentado no DartConf 2018
* [Why Flutter Uses Dart][], um artigo no Hackernoon
* [Why Flutter uses Dart][video], um vídeo no canal Flutter
* [DevTools][devtools]: ferramentas de desempenho para apps Dart e Flutter
* Documentação da [Flutter API][], particularmente a classe [`PerformanceOverlay`][],
  e o pacote [dart:developer][]

[dart:developer]: {{site.api}}/flutter/dart-developer/dart-developer-library.html
[devtools]: /tools/devtools
[Flutter API]: {{site.api}}
[Flutter inspector]: /tools/devtools/inspector
[Flutter inspector talk]: {{site.yt.watch}}?v=JIcmJNT9DNI
[`PerformanceOverlay`]: {{site.api}}/flutter/widgets/PerformanceOverlay-class.html
[video]: {{site.yt.watch}}?v=5F-6n_2XWR8
[Why Flutter Uses Dart]: https://hackernoon.com/why-flutter-uses-dart-dd635a054ebf
