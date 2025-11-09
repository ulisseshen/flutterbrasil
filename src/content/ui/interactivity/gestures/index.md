---
ia-translate: true
title: Toques, arrastos e outros gestos
shortTitle: Gestos
description: Como gestos, como toques e arrastos, funcionam no Flutter.
---

Este documento explica como ouvir e responder a
_gestos_ no Flutter.
Exemplos de gestos incluem toques, arrastos e dimensionamento.

O sistema de gestos no Flutter tem duas camadas separadas.
A primeira camada tem eventos de ponteiro brutos que descrevem
a localização e movimento de ponteiros (por exemplo,
toques, mouses e canetas stylus) pela tela.
A segunda camada tem _gestos_ que descrevem ações semânticas
que consistem em um ou mais movimentos de ponteiro.

## Ponteiros

Ponteiros representam dados brutos sobre a interação do usuário
com a tela do dispositivo.
Existem quatro tipos de eventos de ponteiro:

[`PointerDownEvent`][`PointerDownEvent`]
: O ponteiro fez contato com a tela em uma localização específica.

[`PointerMoveEvent`][`PointerMoveEvent`]
: O ponteiro se moveu de uma localização na tela para outra.

[`PointerUpEvent`][`PointerUpEvent`]
: O ponteiro parou de fazer contato com a tela.

[`PointerCancelEvent`][`PointerCancelEvent`]
: A entrada deste ponteiro não está mais direcionada para este app.

No pointer down, o framework faz um _hit test_ no seu app
para determinar qual widget existe na localização onde o
ponteiro fez contato com a tela. O evento pointer down
(e eventos subsequentes para esse ponteiro) são então despachados
para o widget mais interno encontrado pelo hit test.
De lá, os eventos sobem pela árvore e são despachados
para todos os widgets no caminho do widget mais interno
para a raiz da árvore. Não há mecanismo para
cancelar ou parar os eventos de ponteiro de serem despachados mais.

Para ouvir eventos de ponteiro diretamente da camada de widgets, use um
widget [`Listener`][`Listener`]. No entanto, geralmente,
considere usar gestos (conforme discutido abaixo) em vez disso.

[`Listener`]: {{site.api}}/flutter/widgets/Listener-class.html
[`PointerCancelEvent`]: {{site.api}}/flutter/gestures/PointerCancelEvent-class.html
[`PointerDownEvent`]: {{site.api}}/flutter/gestures/PointerDownEvent-class.html
[`PointerMoveEvent`]: {{site.api}}/flutter/gestures/PointerMoveEvent-class.html
[`PointerUpEvent`]: {{site.api}}/flutter/gestures/PointerUpEvent-class.html

## Gestos

Gestos representam ações semânticas (por exemplo, tap, drag,
e scale) que são reconhecidas de múltiplos eventos de ponteiro individuais,
potencialmente até múltiplos ponteiros individuais.
Gestos podem despachar múltiplos eventos, correspondendo ao
ciclo de vida do gesto (por exemplo, drag start,
drag update, e drag end):

**Tap**

`onTapDown`
: Um ponteiro que pode causar um tap fez contato
  com a tela em uma localização específica.

`onTapUp`
: Um ponteiro que dispara um tap parou de fazer contato
  com a tela em uma localização específica.

`onTap`
: O ponteiro que anteriormente disparou o `onTapDown`
  também disparou `onTapUp` o que acaba causando um tap.

`onTapCancel`
: O ponteiro que anteriormente disparou o `onTapDown`
  não acabará causando um tap.

**Double tap**

`onDoubleTap`
: O usuário tocou a tela na mesma localização duas vezes em
  rápida sucessão.

**Long press**

`onLongPress`
: Um ponteiro permaneceu em contato com a
  tela no mesmo local por um longo período de tempo.

**Vertical drag**

`onVerticalDragStart`
: Um ponteiro fez contato com a tela e pode começar a
  se mover verticalmente.

`onVerticalDragUpdate`
: Um ponteiro que está em contato com a tela e
    se movendo verticalmente se moveu na direção vertical.

`onVerticalDragEnd`
: Um ponteiro que estava anteriormente em contato com a tela
    e se movendo verticalmente não está mais em contato com a
    tela e estava se movendo a uma velocidade específica quando
    parou de fazer contato com a tela.

**Horizontal drag**

`onHorizontalDragStart`
: Um ponteiro fez contato com a tela e pode começar a
  se mover horizontalmente.

`onHorizontalDragUpdate`
: Um ponteiro que está em contato com a tela e
  se movendo horizontalmente se moveu na direção horizontal.

`onHorizontalDragEnd`
: Um ponteiro que estava anteriormente em contato com a
  tela e se movendo horizontalmente não está mais em contato
  com a tela e estava se movendo a uma velocidade específica
  quando parou de fazer contato com a tela.

**Pan**

`onPanStart`
: Um ponteiro fez contato com a tela e pode começar a se mover
  horizontalmente ou verticalmente. Este callback trava se
  `onHorizontalDragStart` ou `onVerticalDragStart` estiver definido.

`onPanUpdate`
: Um ponteiro que está em contato com a tela e está se movendo
  na direção vertical ou horizontal. Este callback
  trava se `onHorizontalDragUpdate` ou `onVerticalDragUpdate`
  estiver definido.

`onPanEnd`
: Um ponteiro que estava anteriormente em contato com a tela
  não está mais em contato com a tela e está se movendo
  a uma velocidade específica quando parou de fazer contato com a tela.
  Este callback trava se `onHorizontalDragEnd` ou
  `onVerticalDragEnd` estiver definido.

### Adicionando detecção de gestos a widgets

Para ouvir gestos da camada de widgets,
use um [`GestureDetector`][`GestureDetector`].

:::note
Para saber mais, assista este curto
vídeo Widget of the Week sobre o widget `GestureDetector`:

<YouTubeEmbed id="WhVXkCFPmK4" title="GestureDetector - Flutter widget of the week"></YouTubeEmbed>
:::

Se você está usando Material Components,
muitos desses widgets já respondem a toques ou gestos.
Por exemplo, [`IconButton`][`IconButton`] e [`TextButton`][`TextButton`]
respondem a pressionamentos (taps), e [`ListView`][`ListView`]
responde a deslizes para disparar rolagem.
Se você não está usando esses widgets, mas quer o
efeito "ink splash" em um tap, você pode usar [`InkWell`][`InkWell`].

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html

### Desambiguação de gestos

Em uma determinada localização na tela,
pode haver múltiplos detectores de gestos.
Por exemplo:

* Um `ListTile` tem um reconhecedor de tap que responde
  ao `ListTile` inteiro, e um aninhado em torno
  de um botão de ícone trailing. A área de tela do
  ícone trailing agora é coberta por dois reconhecedores de
  gestos que precisam negociar para quem manipula
  o gesto se ele acabar sendo um tap.
* Um único `GestureDetector` cobre uma área de tela
  configurado para manipular múltiplos gestos,
  como um long press e um tap.
  O reconhecedor de `tap` deve agora negociar
  com o reconhecedor de `long press` quando
  o usuário toca naquela parte da tela.
  Dependendo do que acontece a seguir com esse ponteiro,
  um dos dois reconhecedores recebe o gesto,
  ou nenhum recebe o gesto se o usuário
  realizar algo que não seja nem um tap nem um long press.

Todos esses detectores de gestos ouvem o stream
de eventos de ponteiro à medida que fluem e tentam reconhecer
gestos específicos. O widget [`GestureDetector`][`GestureDetector`] decide
quais gestos tentar reconhecer com base em quais de seus
callbacks são não-nulos.

Quando há mais de um reconhecedor de gestos para um dado
ponteiro na tela, o framework desambigua qual
gesto o usuário pretende fazendo com que cada reconhecedor entre na
_gesture arena_. A gesture arena determina qual
gesto vence usando as seguintes regras:

* A qualquer momento, um reconhecedor pode se eliminar e sair da
  arena. Se houver apenas um reconhecedor restante na arena,
  esse reconhecedor vence.

* A qualquer momento, um reconhecedor pode se declarar o vencedor,
  fazendo com que todos os reconhecedores restantes percam.

Por exemplo, ao desambiguar arrastos horizontais e verticais,
ambos os reconhecedores entram na arena quando recebem o evento
pointer down. Os reconhecedores observam os eventos pointer move.
Se o usuário mover o ponteiro mais de um certo número de
pixels lógicos horizontalmente, o reconhecedor horizontal declara
a vitória e o gesto é interpretado como um arrasto horizontal.
Similarmente, se o usuário mover mais de um certo número de pixels
lógicos verticalmente, o reconhecedor vertical se declara o vencedor.

A gesture arena é benéfica quando há apenas um reconhecedor de arrasto horizontal
(ou vertical). Nesse caso, há apenas um
reconhecedor na arena e o arrasto horizontal é reconhecido
imediatamente, o que significa que o primeiro pixel de movimento horizontal
pode ser tratado como um arrasto e o usuário não precisará esperar por
uma desambiguação adicional de gestos.
