---
ia-translate: true
title: Design adaptativo e responsivo no Flutter
description: >-
  É importante criar um app,
  seja para mobile ou web,
  que responda a mudanças de tamanho e orientação
  e maximize o uso de cada plataforma.
short-title: Design adaptativo
---

![List of supported platforms](/assets/images/docs/ui/adaptive-responsive/platforms.png)

Um dos principais objetivos do Flutter é criar um framework
que permita desenvolver apps a partir de uma única base de código
que tenham ótima aparência e funcionamento em qualquer plataforma.

Isso significa que seu app pode aparecer em telas de
vários tamanhos diferentes, desde um relógio até um telefone
dobrável com duas telas, até um monitor de alta definição.
E seu dispositivo de entrada pode ser um teclado físico ou
virtual, um mouse, uma tela sensível ao toque ou
qualquer número de outros dispositivos.

Dois termos que descrevem esses conceitos de design
são _adaptativo_ e _responsivo_. Idealmente,
você gostaria que seu app fosse _ambos_, mas o que
exatamente isso significa?

## O que é responsivo vs adaptativo?

Uma maneira fácil de pensar sobre isso é que o design responsivo
se trata de encaixar a UI _no_ espaço e
o design adaptativo se trata da UI ser _usável_ no
espaço.

Então, um app responsivo ajusta a posição dos elementos de design
para _se encaixar_ no espaço disponível. E um
app adaptativo seleciona o layout apropriado e
dispositivos de entrada para ser usável _no_ espaço disponível.
Por exemplo, uma UI de tablet deve usar navegação inferior ou
navegação por painel lateral?

:::note
Frequentemente os conceitos adaptativos e responsivos são
agrupados em um único termo. Na maioria das vezes,
_design adaptativo_ é usado para se referir tanto a
design adaptativo quanto responsivo.
:::

Esta seção cobre vários aspectos de design adaptativo e
responsivo:

* [Abordagem geral][General approach]
* [SafeArea & MediaQuery][]
* [Telas grandes e dobráveis][Large screens & foldables]
* [Entrada do usuário e acessibilidade][User input & accessibility]
* [Capacidades e políticas][Capabilities & policies]
* [Melhores práticas para apps adaptativos][Best practices for adaptive apps]
* [Recursos adicionais][Additional resources]

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

{% ytEmbed 'LeKLGzpsz9I', 'How to build adaptive UI with Flutter' %}
:::
