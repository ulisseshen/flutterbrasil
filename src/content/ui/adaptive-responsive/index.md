---
ia-translate: true
title: Design adaptável e responsivo no Flutter
description: >-
  É importante criar um aplicativo,
  seja para celular ou web,
  que responda a mudanças de tamanho e orientação
  e maximize o uso de cada plataforma.
short-title: Design adaptável
---

![Lista de plataformas suportadas](/assets/images/docs/ui/adaptive-responsive/platforms.png)

Um dos principais objetivos do Flutter é criar um framework
que permita desenvolver aplicativos a partir de uma única base de código
que tenham uma ótima aparência e funcionamento em qualquer plataforma.

Isso significa que seu aplicativo pode aparecer em telas de
vários tamanhos diferentes, desde um relógio, até um celular dobrável
com duas telas, até um monitor de alta definição.
E seu dispositivo de entrada pode ser um teclado físico ou
virtual, um mouse, uma tela sensível ao toque ou
qualquer número de outros dispositivos.

Dois termos que descrevem esses conceitos de design
são _adaptável_ e _responsivo_. Idealmente,
você gostaria que seu aplicativo fosse _ambos_, mas o que,
exatamente, isso significa?

## O que é responsivo vs. adaptável?

Uma maneira fácil de pensar sobre isso é que o design responsivo
é sobre ajustar a interface do usuário _no_ espaço e
o design adaptável é sobre a interface do usuário ser _utilizável_ no
espaço.

Portanto, um aplicativo responsivo ajusta o posicionamento de elementos de design
para _caber_ no espaço disponível. E um
aplicativo adaptável seleciona o layout e
dispositivos de entrada apropriados para serem utilizáveis _no_ espaço disponível.
Por exemplo, uma interface de usuário de tablet deve usar navegação inferior ou
navegação por painel lateral?

:::note
Muitas vezes, os conceitos adaptativos e responsivos são
colapsados em um único termo. Na maioria das vezes,
_design adaptável_ é usado para se referir a ambos
adaptativo e responsivo.
:::

Esta seção abrange vários aspectos do design adaptativo e
responsivo:

*   [Abordagem geral][]
*   [SafeArea & MediaQuery][]
*   [Telas grandes e dobráveis][]
*   [Entrada do usuário e acessibilidade][]
*   [Capacidades e políticas][]
*   [Melhores práticas para aplicativos adaptativos][]
*   [Recursos adicionais][]

[Recursos adicionais]: /ui/adaptive-responsive/more-info
[Melhores práticas para aplicativos adaptativos]: /ui/adaptive-responsive/best-practices
[Capacidades e políticas]: /ui/adaptive-responsive/capabilities
[Abordagem geral]: /ui/adaptive-responsive/general
[Telas grandes e dobráveis]: /ui/adaptive-responsive/large-screens
[SafeArea & MediaQuery]: /ui/adaptive-responsive/safearea-mediaquery
[Entrada do usuário e acessibilidade]: /ui/adaptive-responsive/input

:::note
Você também pode conferir a palestra do Google I/O 2024 sobre
este assunto.

{% ytEmbed 'LeKLGzpsz9I', 'Como construir uma UI adaptativa com Flutter' %}
:::
