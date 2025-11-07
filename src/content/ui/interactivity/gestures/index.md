---
title: Toques, arrastos e outros gestos
short-title: Gestos
description: Como gestos, como toques e arrastos, funcionam no Flutter.
ia-translate: true
---

Este documento explica como escutar e responder a
_gestos_ no Flutter.
Exemplos de gestos incluem toques, arrastos e escala.

O sistema de gestos no Flutter tem duas camadas separadas.
A primeira camada tem eventos de ponteiro brutos que descrevem
a localização e movimento de ponteiros (por exemplo,
toques, mouses e canetas stylus) pela tela.
A segunda camada tem _gestos_ que descrevem ações semânticas
que consistem de um ou mais movimentos de ponteiro.

## Ponteiros

Ponteiros representam dados brutos sobre a interação do usuário
com a tela do dispositivo.
Existem quatro tipos de eventos de ponteiro:

[`PointerDownEvent`][]
: O ponteiro entrou em contato com a tela em uma localização particular.

[`PointerMoveEvent`][]
: O ponteiro se moveu de uma localização na tela para outra.

[`PointerUpEvent`][]
: O ponteiro parou de entrar em contato com a tela.

[`PointerCancelEvent`][]
: A entrada deste ponteiro não é mais direcionada para este app.

Ao tocar para baixo, o framework faz um _teste de acerto_ no seu app
para determinar qual widget existe na localização onde o
ponteiro entrou em contato com a tela. O evento de toque para baixo
(e eventos subsequentes para esse ponteiro) são então despachados
para o widget mais interno encontrado pelo teste de acerto.
De lá, os eventos sobem pela árvore e são despachados
para todos os widgets no caminho do widget mais interno
até a raiz da árvore. Não há mecanismo para
cancelar ou parar eventos de ponteiro de serem despachados adiante.

Para escutar eventos de ponteiro diretamente da camada de widgets, use um
widget [`Listener`][]. No entanto, geralmente,
considere usar gestos (como discutido abaixo) em vez disso.

[`Listener`]: {{site.api}}/flutter/widgets/Listener-class.html
[`PointerCancelEvent`]: {{site.api}}/flutter/gestures/PointerCancelEvent-class.html
[`PointerDownEvent`]: {{site.api}}/flutter/gestures/PointerDownEvent-class.html
[`PointerMoveEvent`]: {{site.api}}/flutter/gestures/PointerMoveEvent-class.html
[`PointerUpEvent`]: {{site.api}}/flutter/gestures/PointerUpEvent-class.html

## Gestos

Gestos representam ações semânticas (por exemplo, toque, arrasto,
e escala) que são reconhecidas de múltiplos eventos de ponteiro individuais,
potencialmente até múltiplos ponteiros individuais.
Gestos podem despachar múltiplos eventos, correspondendo ao
ciclo de vida do gesto (por exemplo, início de arrasto,
atualização de arrasto e fim de arrasto):

**Toque (Tap)**

`onTapDown`
: Um ponteiro que pode causar um toque entrou em contato
  com a tela em uma localização particular.

`onTapUp`
: Um ponteiro que dispara um toque parou de entrar em contato
  com a tela em uma localização particular.

`onTap`
: O ponteiro que previamente disparou o `onTapDown`
  também disparou `onTapUp` o que acaba causando um toque.

`onTapCancel`
: O ponteiro que previamente disparou o `onTapDown`
  não acabará causando um toque.

**Toque duplo (Double tap)**

`onDoubleTap`
: O usuário tocou a tela no mesmo local duas vezes em
  rápida sucessão.

**Toque longo (Long press)**

`onLongPress`
: Um ponteiro permaneceu em contato com a
  tela no mesmo local por um longo período de tempo.

**Arrasto vertical (Vertical drag)**

`onVerticalDragStart`
: Um ponteiro entrou em contato com a tela e pode começar a
  se mover verticalmente.

`onVerticalDragUpdate`
: Um ponteiro que está em contato com a tela e
    se movendo verticalmente se moveu na direção vertical.

`onVerticalDragEnd`
: Um ponteiro que estava previamente em contato com a tela
    e se movendo verticalmente não está mais em contato com a
    tela e estava se movendo a uma velocidade específica quando
    parou de entrar em contato com a tela.

**Arrasto horizontal (Horizontal drag)**

`onHorizontalDragStart`
: Um ponteiro entrou em contato com a tela e pode começar a
  se mover horizontalmente.

`onHorizontalDragUpdate`
: Um ponteiro que está em contato com a tela e
  se movendo horizontalmente se moveu na direção horizontal.

`onHorizontalDragEnd`
: Um ponteiro que estava previamente em contato com a
  tela e se movendo horizontalmente não está mais em contato
  com a tela e estava se movendo a uma velocidade específica
  quando parou de entrar em contato com a tela.

**Pan**

`onPanStart`
: Um ponteiro entrou em contato com a tela e pode começar a se mover
  horizontalmente ou verticalmente. Este callback falha se
  `onHorizontalDragStart` ou `onVerticalDragStart` estiver definido.

`onPanUpdate`
: Um ponteiro que está em contato com a tela e está se movendo
  na direção vertical ou horizontal. Este callback
  falha se `onHorizontalDragUpdate` ou `onVerticalDragUpdate`
  estiver definido.

`onPanEnd`
: Um ponteiro que estava previamente em contato com a tela
  não está mais em contato com a tela e está se movendo
  a uma velocidade específica quando parou de entrar em contato com a tela.
  Este callback falha se `onHorizontalDragEnd` ou
  `onVerticalDragEnd` estiver definido.

### Adicionando detecção de gestos aos widgets

Para escutar gestos da camada de widgets,
use um [`GestureDetector`][].

:::note
Para saber mais, assista este curto
vídeo Widget da Semana sobre o widget `GestureDetector`:

{% ytEmbed 'WhVXkCFPmK4', 'GestureDetector - Flutter widget of the week' %}
:::

Se você estiver usando Material Components,
muitos desses widgets já respondem a toques ou gestos.
Por exemplo, [`IconButton`][] e [`TextButton`][]
respondem a pressionamentos (toques), e [`ListView`][]
responde a deslizes para disparar rolagem.
Se você não estiver usando esses widgets, mas quiser o
efeito de "respingo de tinta" em um toque, você pode usar [`InkWell`][].

[`GestureDetector`]: {{site.api}}/flutter/widgets/GestureDetector-class.html
[`IconButton`]: {{site.api}}/flutter/material/IconButton-class.html
[`InkWell`]: {{site.api}}/flutter/material/InkWell-class.html
[`ListView`]: {{site.api}}/flutter/widgets/ListView-class.html
[`TextButton`]: {{site.api}}/flutter/material/TextButton-class.html

### Desambiguação de gestos

Em um determinado local na tela,
pode haver múltiplos detectores de gestos.
Por exemplo:

* Um `ListTile` tem um reconhecedor de toque que responde
  ao `ListTile` inteiro, e um aninhado ao redor
  de um botão de ícone à direita. O retângulo de tela do
  ícone à direita agora está coberto por dois reconhecedores de gestos
  que precisam negociar sobre quem manipula
  o gesto se ele acabar sendo um toque.
* Um único `GestureDetector` cobre uma área da tela
  configurado para manipular múltiplos gestos,
  como um toque longo e um toque.
  O reconhecedor de `tap` agora deve negociar
  com o reconhecedor de `long press` quando
  o usuário toca naquela parte da tela.
  Dependendo do que acontece em seguida com esse ponteiro,
  um dos dois reconhecedores recebe o gesto,
  ou nenhum recebe o gesto se o usuário
  realizar algo que não é nem um toque nem um toque longo.

Todos esses detectores de gestos escutam o fluxo
de eventos de ponteiro conforme eles fluem e tentam reconhecer
gestos específicos. O widget [`GestureDetector`] decide
quais gestos tentar reconhecer baseado em quais de seus
callbacks não são nulos.

Quando há mais de um reconhecedor de gestos para um determinado
ponteiro na tela, o framework desambigua qual
gesto o usuário pretende fazendo com que cada reconhecedor entre na
_arena de gestos_. A arena de gestos determina qual
gesto vence usando as seguintes regras:

* A qualquer momento, um reconhecedor pode se eliminar e sair da
  arena. Se houver apenas um reconhecedor restante na arena,
  esse reconhecedor vence.

* A qualquer momento, um reconhecedor pode se declarar o vencedor,
  fazendo com que todos os reconhecedores restantes percam.

Por exemplo, ao desambiguar arrastos horizontais e verticais,
ambos os reconhecedores entram na arena quando recebem o evento de
toque para baixo. Os reconhecedores observam os eventos de movimento do ponteiro.
Se o usuário mover o ponteiro mais de um certo número de
pixels lógicos horizontalmente, o reconhecedor horizontal declara
a vitória e o gesto é interpretado como um arrasto horizontal.
Da mesma forma, se o usuário mover mais de um certo número de pixels
lógicos verticalmente, o reconhecedor vertical se declara o vencedor.

A arena de gestos é benéfica quando há apenas um reconhecedor de arrasto horizontal
(ou vertical). Nesse caso, há apenas um
reconhecedor na arena e o arrasto horizontal é reconhecido
imediatamente, o que significa que o primeiro pixel de movimento horizontal
pode ser tratado como um arrasto e o usuário não precisará esperar por
mais desambiguação de gestos.
