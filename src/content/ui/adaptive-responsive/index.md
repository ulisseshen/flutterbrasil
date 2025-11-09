---
ia-translate: true
title: Design adaptativo e responsivo no Flutter
description: >-
  É importante criar um app,
  seja para mobile ou web,
  que responda a mudanças de tamanho e orientação
  e maximize o uso de cada plataforma.
shortTitle: Design adaptativo
---

![List of supported platforms](/assets/images/docs/ui/adaptive-responsive/platforms.png)

Um dos objetivos principais do Flutter é criar um framework
que permite desenvolver apps a partir de uma única base de código
que tenham ótima aparência e sensação em qualquer plataforma.

Isso significa que seu app pode aparecer em telas de
muitos tamanhos diferentes, de um relógio, a um telefone
dobrável com duas telas, a um monitor de alta definição.
E seu dispositivo de entrada pode ser um teclado físico ou
virtual, um mouse, uma tela touch, ou
qualquer número de outros dispositivos.

Dois termos que descrevem esses conceitos de design
são _adaptativo_ e _responsivo_. Idealmente,
você gostaria que seu app fosse _ambos_, mas o que,
exatamente, isso significa?

## O que é responsivo vs adaptativo?

Uma maneira fácil de pensar sobre isso é que design responsivo
é sobre encaixar a UI _no_ espaço e
design adaptativo é sobre a UI ser _utilizável_ no
espaço.

Então, um app responsivo ajusta o posicionamento de elementos de design
para _encaixar_ no espaço disponível. E um
app adaptativo seleciona o layout apropriado e
dispositivos de entrada para ser utilizável _no_ espaço disponível.
Por exemplo, uma UI de tablet deve usar navegação inferior ou
navegação por painel lateral?

:::note
Frequentemente conceitos adaptativos e responsivos são
colapsados em um único termo. Na maioria das vezes,
_design adaptativo_ é usado para se referir a ambos
adaptativo e responsivo.
:::

Esta seção cobre vários aspectos de design adaptativo e
responsivo:

* [General approach][General approach]
* [SafeArea & MediaQuery][SafeArea & MediaQuery]
* [Large screens & foldables][Large screens & foldables]
* [User input & accessibility][User input & accessibility]
* [Capabilities & policies][Capabilities & policies]
* [Best practices for adaptive apps][Best practices for adaptive apps]
* [Additional resources][Additional resources]

[Additional resources]: /ui/adaptive-responsive/more-info
[Best practices for adaptive apps]: /ui/adaptive-responsive/best-practices
[Capabilities & policies]: /ui/adaptive-responsive/capabilities
[General approach]: /ui/adaptive-responsive/general
[Large screens & foldables]: /ui/adaptive-responsive/large-screens
[SafeArea & MediaQuery]: /ui/adaptive-responsive/safearea-mediaquery
[User input & accessibility]: /ui/adaptive-responsive/input

:::note
Você também pode conferir a palestra do Google I/O 2024 sobre
este assunto.

<YouTubeEmbed id="LeKLGzpsz9I" title="How to build adaptive UI with Flutter"></YouTubeEmbed>
:::
