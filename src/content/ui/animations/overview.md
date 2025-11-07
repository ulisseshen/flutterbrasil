---
title: Visão geral da API de animações
short-title: Visão geral da API
description: Uma visão geral dos conceitos de animação.
ia-translate: true
---

O sistema de animação no Flutter é baseado em objetos
[`Animation`][] tipados. Widgets podem incorporar
essas animações em suas funções build diretamente,
lendo seu valor atual e ouvindo suas
mudanças de estado, ou podem usar as animações como base de
animações mais elaboradas que eles passam para
outros widgets.

## Animation

O bloco de construção principal do sistema de animação é a
classe [`Animation`][]. Uma Animation representa um valor
de um tipo específico que pode mudar ao longo da vida útil
da animação. A maioria dos widgets que realizam uma animação
recebem um objeto `Animation` como parâmetro,
do qual eles leem o valor atual da animação
e ao qual eles ouvem mudanças nesse valor.

### `addListener`

Sempre que o valor da animação muda,
a animação notifica todos os listeners adicionados com
[`addListener`][]. Normalmente, um objeto [`State`][]
que ouve uma animação chama
[`setState`][] em si mesmo em seu callback de listener
para notificar o sistema de widgets que ele precisa
reconstruir com o novo valor da animação.

Esse padrão é tão comum que existem dois widgets
que ajudam os widgets a reconstruir quando as animações mudam de valor:
[`AnimatedWidget`][] e [`AnimatedBuilder`][].
O primeiro, `AnimatedWidget`, é mais útil para
widgets animados stateless. Para usar `AnimatedWidget`,
simplesmente crie uma subclasse dele e implemente a função [`build`][].
O segundo, `AnimatedBuilder`, é útil para widgets mais complexos
que desejam incluir uma animação como parte de uma função build maior.
Para usar `AnimatedBuilder`, simplesmente construa o widget
e passe a ele uma função `builder`.

### `addStatusListener`

As animações também fornecem um [`AnimationStatus`][],
que indica como a animação evoluirá ao longo do tempo.
Sempre que o status da animação muda,
a animação notifica todos os listeners adicionados com
[`addStatusListener`][]. Normalmente, as animações começam
no status `dismissed`, o que significa que estão
no início de seu intervalo. Por exemplo,
animações que progridem de 0.0 a 1.0
estarão `dismissed` quando seu valor for 0.0.
Uma animação pode então executar `forward` (de 0.0 a 1.0)
ou talvez em `reverse` (de 1.0 a 0.0).
Eventualmente, se a animação atingir o final de seu intervalo
(1.0), a animação atinge o status `completed`.

## Animation&shy;Controller

Para criar uma animação, primeiro crie um [`AnimationController`][].
Além de ser uma animação em si, um `AnimationController`
permite que você controle a animação. Por exemplo,
você pode dizer ao controller para reproduzir a animação
[`forward`][] ou [`stop`][] a animação.
Você também pode [`fling`][] animações,
que usam uma simulação física, como uma mola,
para conduzir a animação.

Uma vez que você criou um animation controller,
você pode começar a construir outras animações com base nele.
Por exemplo, você pode criar uma [`ReverseAnimation`][]
que espelha a animação original mas roda na
direção oposta (de 1.0 a 0.0).
Da mesma forma, você pode criar uma [`CurvedAnimation`][]
cujo valor é ajustado por uma [`Curve`][].

## Tweens

Para animar além do intervalo de 0.0 a 1.0, você pode usar um
[`Tween<T>`][], que interpola entre seus
valores [`begin`][] e [`end`][]. Muitos tipos têm
subclasses `Tween` específicas que fornecem interpolação específica do tipo.
Por exemplo, [`ColorTween`][] interpola entre cores e
[`RectTween`][] interpola entre retângulos.
Você pode definir suas próprias interpolações criando
sua própria subclasse de `Tween` e substituindo sua
função [`lerp`][].

Por si só, um tween apenas define como interpolar
entre dois valores. Para obter um valor concreto para o
quadro atual de uma animação, você também precisa de uma
animação para determinar o estado atual.
Existem duas maneiras de combinar um tween
com uma animação para obter um valor concreto:

1. Você pode [`evaluate`][] o tween no valor atual
   de uma animação. Esta abordagem é mais útil
   para widgets que já estão ouvindo a animação e, portanto,
   reconstruindo sempre que a animação muda de valor.

2. Você pode [`animate`][] o tween com base na animação.
   Em vez de retornar um único valor, a função animate
   retorna uma nova `Animation` que incorpora o tween.
   Esta abordagem é mais útil quando você deseja dar a
   animação recém-criada a outro widget,
   que pode então ler o valor atual que incorpora
   o tween, bem como ouvir mudanças no valor.

## Arquitetura

As animações são, na verdade, construídas a partir de vários blocos de construção principais.

### Scheduler

O [`SchedulerBinding`][] é uma classe singleton
que expõe as primitivas de agendamento do Flutter.

Para esta discussão, a primitiva chave são os callbacks de quadro.
Cada vez que um quadro precisa ser mostrado na tela,
o mecanismo do Flutter aciona um callback "begin frame" que
o scheduler multiplexa para todos os listeners registrados usando
[`scheduleFrameCallback()`][]. Todos esses callbacks recebem
o carimbo de data/hora oficial do quadro, na
forma de uma `Duration` de alguma época arbitrária. Como todos os
callbacks têm o mesmo carimbo de data/hora, quaisquer animações acionadas desses
callbacks parecerão estar exatamente sincronizadas, mesmo
que levem alguns milissegundos para serem executadas.

### Tickers

A classe [`Ticker`][] se conecta ao
mecanismo [`scheduleFrameCallback()`][]
do scheduler para invocar um callback a cada tick.

Um `Ticker` pode ser iniciado e parado. Quando iniciado,
ele retorna um `Future` que será resolvido quando for parado.

A cada tick, o `Ticker` fornece ao callback a
duração desde o primeiro tick após ele ter sido iniciado.

Como os tickers sempre dão seu tempo decorrido relativo ao primeiro
tick após terem sido iniciados; os tickers estão todos sincronizados. Se você
iniciar três tickers em momentos diferentes entre dois ticks, eles
ainda assim estarão sincronizados com o mesmo tempo de início, e
subsequentemente darão ticks em sincronia. Como pessoas em um ponto de ônibus,
todos os tickers esperam por um evento que ocorre regularmente
(o tick) para começar a se mover (contar tempo).

### Simulations

A classe abstrata [`Simulation`][] mapeia um
valor de tempo relativo (um tempo decorrido) para um
valor double, e tem uma noção de conclusão.

Em princípio, as simulações são stateless, mas na prática
algumas simulações (por exemplo,
[`BouncingScrollSimulation`][] e
[`ClampingScrollSimulation`][])
mudam de estado de forma irreversível quando consultadas.

Existem [várias implementações concretas][]
da classe `Simulation` para diferentes efeitos.

### Animatables

A classe abstrata [`Animatable`][] mapeia um
double para um valor de um tipo específico.

As classes `Animatable` são stateless e imutáveis.

#### Tweens

A classe abstrata [`Tween<T>`][] mapeia um valor
double nominalmente no intervalo 0.0-1.0 para um valor tipado
(por exemplo, uma `Color`, ou outro double).
É um `Animatable`.

Ela tem uma noção de um tipo de saída (`T`),
um valor `begin` e um valor `end` desse tipo,
e uma maneira de interpolar (`lerp`) entre os valores begin
e end para um determinado valor de entrada (o double nominalmente no
intervalo 0.0-1.0).

As classes `Tween` são stateless e imutáveis.

#### Composing animatables

Passar um `Animatable<double>` (o pai) para o método
`chain()` de um `Animatable` cria uma nova subclasse `Animatable` que aplica o
mapeamento do pai e depois o mapeamento do filho.

### Curves

A classe abstrata [`Curve`][] mapeia doubles
nominalmente no intervalo 0.0-1.0 para doubles
nominalmente no intervalo 0.0-1.0.

As classes `Curve` são stateless e imutáveis.

### Animations

A classe abstrata [`Animation`][] fornece um
valor de um determinado tipo, um conceito de direção de animação
e status de animação, e uma interface de listener para
registrar callbacks que são invocados quando o valor ou status mudam.

Algumas subclasses de `Animation` têm valores que nunca mudam
([`kAlwaysCompleteAnimation`][], [`kAlwaysDismissedAnimation`][],
[`AlwaysStoppedAnimation`][]); registrar callbacks nelas
não tem efeito, pois os callbacks nunca são chamados.

A variante `Animation<double>` é especial porque pode ser usada para
representar um double nominalmente no intervalo 0.0-1.0, que é a entrada
esperada pelas classes `Curve` e `Tween`, bem como algumas subclasses
adicionais de `Animation`.

Algumas subclasses de `Animation` são stateless,
meramente encaminhando listeners para seus pais.
Algumas são muito stateful.

#### Composable animations

A maioria das subclasses de `Animation` recebe um
`Animation<double>` "pai" explícito. Elas são conduzidas por esse pai.

A subclasse `CurvedAnimation` recebe uma classe `Animation<double>` (o
pai) e algumas classes `Curve` (as curvas forward e reverse)
como entrada, e usa o valor do pai como entrada para as
curvas para determinar sua saída. `CurvedAnimation` é imutável e
stateless.

A subclasse `ReverseAnimation` recebe uma
classe `Animation<double>` como seu pai e inverte
todos os valores da animação. Ela assume que o pai
está usando um valor nominalmente no intervalo 0.0-1.0 e retorna
um valor no intervalo 1.0-0.0. O status e a direção da animação
pai também são invertidos. `ReverseAnimation` é imutável e
stateless.

A subclasse `ProxyAnimation` recebe uma classe `Animation<double>` como
seu pai e meramente encaminha o estado atual desse pai.
No entanto, o pai é mutável.

A subclasse `TrainHoppingAnimation` recebe dois pais,
e alterna entre eles quando seus valores se cruzam.

#### Animation controllers

O [`AnimationController`][] é uma
`Animation<double>` stateful que usa um `Ticker` para se dar vida.
Ele pode ser iniciado e parado. A cada tick, ele pega o tempo
decorrido desde que foi iniciado e o passa para uma `Simulation` para obter
um valor. Esse é então o valor que ele relata. Se a `Simulation`
relatar que naquele momento ela terminou, então o controller para
a si mesmo.

O animation controller pode receber um limite inferior e superior para
animar entre, e uma duração.

No caso simples (usando `forward()` ou `reverse()`), o animation controller simplesmente faz uma
interpolação linear do limite inferior para o limite superior (ou vice-versa,
para a direção reversa) durante a duração determinada.

Ao usar `repeat()`, o animation controller usa uma
interpolação linear entre os limites dados durante a duração dada, mas
não para.

Ao usar `animateTo()`, o animation controller faz uma
interpolação linear durante a duração dada do valor atual para o
alvo dado. Se nenhuma duração for dada ao método, a duração padrão
do controller e o intervalo descrito pelo limite
inferior e limite superior do controller é usado para determinar a velocidade da
animação.

Ao usar `fling()`, uma `Force` é usada para criar uma
simulação específica que é então usada para conduzir o controller.

Ao usar `animateWith()`, a simulação dada é usada para conduzir o
controller.

Esses métodos todos retornam o future que o `Ticker` fornece e
que será resolvido quando o controller parar ou mudar de
simulação.

#### Attaching animatables to animations

Passar uma `Animation<double>` (o novo pai) para o método
`animate()` de um `Animatable` cria uma nova subclasse `Animation` que age como
o `Animatable`, mas é conduzida pelo pai dado.


[`addListener`]: {{site.api}}/flutter/animation/Animation/addListener.html
[`addStatusListener`]: {{site.api}}/flutter/animation/Animation/addStatusListener.html
[`AlwaysStoppedAnimation`]: {{site.api}}/flutter/animation/AlwaysStoppedAnimation-class.html
[`Animatable`]: {{site.api}}/flutter/animation/Animatable-class.html
[`animate`]: {{site.api}}/flutter/animation/Animatable/animate.html
[`AnimatedBuilder`]: {{site.api}}/flutter/widgets/AnimatedBuilder-class.html
[`AnimationController`]: {{site.api}}/flutter/animation/AnimationController-class.html
[`AnimatedWidget`]: {{site.api}}/flutter/widgets/AnimatedWidget-class.html
[`Animation`]: {{site.api}}/flutter/animation/Animation-class.html
[`AnimationStatus`]: {{site.api}}/flutter/animation/AnimationStatus.html
[`begin`]: {{site.api}}/flutter/animation/Tween/begin.html
[`BouncingScrollSimulation`]: {{site.api}}/flutter/widgets/BouncingScrollSimulation-class.html
[`build`]: {{site.api}}/flutter/widgets/AnimatedWidget/build.html
[`ClampingScrollSimulation`]: {{site.api}}/flutter/widgets/ClampingScrollSimulation-class.html
[`ColorTween`]: {{site.api}}/flutter/animation/ColorTween-class.html
[`Curve`]: {{site.api}}/flutter/animation/Curves-class.html
[`CurvedAnimation`]: {{site.api}}/flutter/animation/CurvedAnimation-class.html
[`end`]: {{site.api}}/flutter/animation/Tween/end.html
[`evaluate`]: {{site.api}}/flutter/animation/Animatable/evaluate.html
[`fling`]: {{site.api}}/flutter/animation/AnimationController/fling.html
[`forward`]: {{site.api}}/flutter/animation/AnimationController/forward.html
[`kAlwaysCompleteAnimation`]: {{site.api}}/flutter/animation/kAlwaysCompleteAnimation-constant.html
[`kAlwaysDismissedAnimation`]: {{site.api}}/flutter/animation/kAlwaysDismissedAnimation-constant.html
[`lerp`]: {{site.api}}/flutter/animation/Tween/lerp.html
[`RectTween`]: {{site.api}}/flutter/animation/RectTween-class.html
[`ReverseAnimation`]: {{site.api}}/flutter/animation/ReverseAnimation-class.html
[`scheduleFrameCallback()`]: {{site.api}}/flutter/scheduler/SchedulerBinding/scheduleFrameCallback.html
[`SchedulerBinding`]: {{site.api}}/flutter/scheduler/SchedulerBinding-mixin.html
[`setState`]: {{site.api}}/flutter/widgets/State/setState.html
[`Simulation`]: {{site.api}}/flutter/physics/Simulation-class.html
[`State`]: {{site.api}}/flutter/widgets/State-class.html
[`stop`]: {{site.api}}/flutter/animation/AnimationController/stop.html
[`Ticker`]: {{site.api}}/flutter/scheduler/Ticker-class.html
[`Tween<T>`]: {{site.api}}/flutter/animation/Tween-class.html
[várias implementações concretas]: {{site.api}}/flutter/physics/physics-library.html
