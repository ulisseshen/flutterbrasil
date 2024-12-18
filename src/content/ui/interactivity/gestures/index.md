---
ia-translate: true
title: Toques, arrastos e outros gestos
short-title: Gestos
description: Como gestos, como toques e arrastos, funcionam no Flutter.
---

Este documento explica como ouvir e responder a _gestos_ no
Flutter. Exemplos de gestos incluem toques, arrastos e
escalonamento.

O sistema de gestos no Flutter tem duas camadas separadas. A
primeira camada tem eventos de ponteiro brutos que descrevem a
localização e o movimento de ponteiros (por exemplo, toques,
mouses e canetas) na tela. A segunda camada tem _gestos_ que
descrevem ações semânticas que consistem em um ou mais
movimentos de ponteiro.

## Ponteiros

Ponteiros representam dados brutos sobre a interação do usuário
com a tela do dispositivo. Existem quatro tipos de eventos de
ponteiro:

[`PointerDownEvent`][]
: O ponteiro fez contato com a tela em um local específico.

[`PointerMoveEvent`][]
: O ponteiro se moveu de um local na tela para outro.

[`PointerUpEvent`][]
: O ponteiro parou de fazer contato com a tela.

[`PointerCancelEvent`][]
: A entrada deste ponteiro não é mais direcionada para este
aplicativo.

Ao pressionar o ponteiro, o framework faz um _teste de
acerto_ em seu aplicativo para determinar qual widget existe no
local onde o ponteiro fez contato com a tela. O evento de
ponteiro pressionado (e eventos subsequentes para esse ponteiro)
são então enviados para o widget mais interno encontrado pelo
teste de acerto. A partir daí, os eventos sobem na árvore e são
enviados para todos os widgets no caminho do widget mais
interno até a raiz da árvore. Não há mecanismo para cancelar ou
impedir que eventos de ponteiro sejam enviados mais adiante.

Para ouvir eventos de ponteiro diretamente da camada de
widgets, use um widget [`Listener`][]. No entanto, em geral,
considere usar gestos (conforme discutido abaixo) em vez
disso.

[`Listener`]: {{site.api}}/flutter/widgets/Listener-class.html
[`PointerCancelEvent`]: {{site.api}}/flutter/gestures/PointerCancelEvent-class.html
[`PointerDownEvent`]: {{site.api}}/flutter/gestures/PointerDownEvent-class.html
[`PointerMoveEvent`]: {{site.api}}/flutter/gestures/PointerMoveEvent-class.html
[`PointerUpEvent`]: {{site.api}}/flutter/gestures/PointerUpEvent-class.html

## Gestos

Gestos representam ações semânticas (por exemplo, toque,
arrastar e dimensionar) que são reconhecidas a partir de vários
eventos de ponteiro individuais, potencialmente até mesmo
vários ponteiros individuais. Gestos podem enviar vários
eventos, correspondendo ao ciclo de vida do gesto (por exemplo,
início do arrasto, atualização do arrasto e fim do arrasto):

**Toque**

`onTapDown`
: Um ponteiro que pode causar um toque fez contato com a tela
  em um local específico.

`onTapUp`
: Um ponteiro que aciona um toque parou de fazer contato com
  a tela em um local específico.

`onTap`
: O ponteiro que acionou anteriormente o `onTapDown` também
  acionou o `onTapUp` que acaba causando um toque.

`onTapCancel`
: O ponteiro que acionou anteriormente o `onTapDown` não
  acabará causando um toque.

**Toque duplo**

`onDoubleTap`
: O usuário tocou na tela no mesmo local duas vezes em rápida
  sucessão.

**Pressão longa**

`onLongPress`
: Um ponteiro permaneceu em contato com a tela no mesmo local
  por um longo período de tempo.

**Arrasto vertical**

`onVerticalDragStart`
: Um ponteiro fez contato com a tela e pode começar a se
  mover verticalmente.

`onVerticalDragUpdate`
: Um ponteiro que está em contato com a tela e se movendo
  verticalmente se moveu na direção vertical.

`onVerticalDragEnd`
: Um ponteiro que estava anteriormente em contato com a tela
  e se movendo verticalmente não está mais em contato com a
  tela e estava se movendo a uma velocidade específica quando
  parou de fazer contato com a tela.

**Arrasto horizontal**

`onHorizontalDragStart`
: Um ponteiro fez contato com a tela e pode começar a se
  mover horizontalmente.

`onHorizontalDragUpdate`
: Um ponteiro que está em contato com a tela e se movendo
  horizontalmente se moveu na direção horizontal.

`onHorizontalDragEnd`
: Um ponteiro que estava anteriormente em contato com a tela
  e se movendo horizontalmente não está mais em contato com a
  tela e estava se movendo a uma velocidade específica quando
  parou de fazer contato com a tela.

**Pan**

`onPanStart`
: Um ponteiro fez contato com a tela e pode começar a se
  mover horizontal ou verticalmente. Esse callback trava se
  `onHorizontalDragStart` ou `onVerticalDragStart` estiver
  definido.

`onPanUpdate`
: Um ponteiro que está em contato com a tela e está se
  movendo na direção vertical ou horizontal. Esse callback
  trava se `onHorizontalDragUpdate` ou `onVerticalDragUpdate`
  estiver definido.

`onPanEnd`
: Um ponteiro que estava anteriormente em contato com a tela
  não está mais em contato com a tela e está se movendo a uma
  velocidade específica quando parou de fazer contato com a
  tela. Esse callback trava se `onHorizontalDragEnd` ou
  `onVerticalDragEnd` estiver definido.

### Adicionando detecção de gestos a widgets

Para ouvir gestos da camada de widgets, use um
[`GestureDetector`][].

:::note
Para saber mais, assista a este vídeo curto Widget of the Week
sobre o widget `GestureDetector`:

{% ytEmbed 'WhVXkCFPmK4', 'GestureDetector - Flutter widget of the week' %}
:::

Se você estiver usando Componentes Material, muitos desses
widgets já respondem a toques ou gestos. Por exemplo,
[`IconButton`][] e [`TextButton`][] respondem a pressões
(toques), e [`ListView`][] responde a deslizes para acionar a
rolagem. Se você não estiver usando esses widgets, mas quiser o
efeito "respingo de tinta" em um toque, você pode usar
[`InkWell`][].

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html

### Desambiguação de gestos

Em um determinado local na tela, pode haver vários
detectores de gestos. Por exemplo:

* Um `ListTile` tem um reconhecedor de toque que responde a
  todo o `ListTile`, e um aninhado em torno de um botão de
  ícone à direita. O retângulo de tela do ícone à direita
  agora está coberto por dois reconhecedores de gestos que
  precisam negociar quem lida com o gesto se ele acabar sendo
  um toque.
* Um único `GestureDetector` cobre uma área de tela
  configurada para lidar com vários gestos, como uma pressão
  longa e um toque. O reconhecedor de `toque` agora deve
  negociar com o reconhecedor de `pressão longa` quando o
  usuário toca nessa parte da tela. Dependendo do que
  acontece em seguida com esse ponteiro, um dos dois
  reconhecedores recebe o gesto, ou nenhum recebe o gesto se o
  usuário realizar algo que não seja um toque nem uma pressão
  longa.

Todos esses detectores de gestos ouvem o fluxo de eventos de
ponteiro à medida que eles passam e tentam reconhecer gestos
específicos. O widget [`GestureDetector`] decide quais gestos
tentar reconhecer com base em quais de seus callbacks não são
nulos.

Quando há mais de um reconhecedor de gestos para um
determinado ponteiro na tela, o framework desambigua qual
gesto o usuário pretende, fazendo com que cada reconhecedor
entre na _arena de gestos_. A arena de gestos determina qual
gesto vence usando as seguintes regras:

* A qualquer momento, um reconhecedor pode se eliminar e sair
  da arena. Se houver apenas um reconhecedor na arena, esse
  reconhecedor vence.

* A qualquer momento, um reconhecedor pode se declarar o
  vencedor, fazendo com que todos os reconhecedores restantes
  percam.

Por exemplo, ao desambiguar arrastos horizontais e verticais,
ambos os reconhecedores entram na arena quando recebem o evento
de pressionar o ponteiro. Os reconhecedores observam os eventos
de movimento do ponteiro. Se o usuário mover o ponteiro mais
do que um determinado número de pixels lógicos horizontalmente,
o reconhecedor horizontal declara a vitória e o gesto é
interpretado como um arrasto horizontal. Da mesma forma, se o
usuário mover mais do que um determinado número de pixels
lógicos verticalmente, o reconhecedor vertical se declara o
vencedor.

A arena de gestos é benéfica quando há apenas um reconhecedor
de arrasto horizontal (ou vertical). Nesse caso, há apenas um
reconhecedor na arena e o arrasto horizontal é reconhecido
imediatamente, o que significa que o primeiro pixel de
movimento horizontal pode ser tratado como um arrasto e o
usuário não precisará esperar por mais desambiguação de
gestos.
