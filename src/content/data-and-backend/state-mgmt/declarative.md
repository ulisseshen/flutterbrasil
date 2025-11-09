---
ia-translate: true
title: Comece a pensar declarativamente
description: Como pensar sobre programação declarativa.
prev:
  title: Intro
  path: /data-and-backend/state-mgmt
next:
  title: Ephemeral versus app state
  path: /data-and-backend/state-mgmt/ephemeral-vs-app
---

Se você está vindo para o Flutter de um framework imperativo
(como Android SDK ou iOS UIKit), você precisa começar a
pensar sobre desenvolvimento de apps de uma nova perspectiva.

Muitas suposições que você pode ter não se aplicam ao Flutter. Por exemplo, no
Flutter é normal reconstruir partes da sua UI do zero ao invés de modificá-la.
O Flutter é rápido o suficiente para fazer isso, até mesmo em cada frame se necessário.

Flutter é _declarativo_. Isso significa que o Flutter constrói sua interface de usuário para
refletir o estado atual do seu app:

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/ui-equals-function-of-state.png' width="100%" class="diagram-wrap" alt="A mathematical formula of UI = f(state). 'UI' is the layout on the screen. 'f' is your build methods. 'state' is the application state.">

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1RDcR5LyFtzhpmiT5-UupXBeos2Ban5cUTU0-JujS3Os/edit?usp=sharing
{% endcomment %}

Quando o estado do seu app muda
(por exemplo, o usuário alterna um switch na tela de configurações),
você muda o estado, e isso dispara um redesenho da interface de usuário.
Não há mudança imperativa da UI em si
(como `widget.setText`)&mdash;você muda o estado,
e a UI é reconstruída do zero.

Leia mais sobre a abordagem declarativa para programação de UI
no [guia de introdução][get started guide].

O estilo declarativo de programação de UI tem muitos benefícios.
Notavelmente, há apenas um caminho de código para qualquer estado da UI.
Você descreve como a UI deve parecer
para qualquer estado dado, uma vez&mdash;e é isso.

No início,
este estilo de programação pode não parecer tão intuitivo quanto o
estilo imperativo. É por isso que esta seção está aqui. Continue lendo.


[get started guide]: /get-started/flutter-for/declarative
