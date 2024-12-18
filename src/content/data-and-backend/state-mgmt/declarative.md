---
ia-translate: true
title: Comece a pensar de forma declarativa
description: Como pensar sobre programação declarativa.
prev:
  title: Introdução
  path: /development/data-and-backend/state-mgmt
next:
  title: Estado efêmero versus estado do aplicativo
  path: /development/data-and-backend/state-mgmt/ephemeral-vs-app
---

Se você está vindo para o Flutter de um framework imperativo
(como Android SDK ou iOS UIKit), você precisa começar
a pensar sobre o desenvolvimento de aplicativos sob uma nova perspectiva.

Muitas suposições que você possa ter não se aplicam ao Flutter. Por exemplo, no
Flutter, é aceitável reconstruir partes da sua UI do zero em vez de modificá-la.
O Flutter é rápido o suficiente para fazer isso, mesmo em todos os frames, se necessário.

Flutter é _declarativo_. Isso significa que o Flutter constrói sua interface de usuário para
refletir o estado atual do seu aplicativo:

<img src='/assets/images/docs/development/data-and-backend/state-mgmt/ui-equals-function-of-state.png' width="100%" alt="Uma fórmula matemática de UI = f(state). 'UI' é o layout na tela. 'f' são seus métodos de construção. 'state' é o estado do aplicativo.">

{% comment %}
Source drawing for the png above: : https://docs.google.com/drawings/d/1RDcR5LyFtzhpmiT5-UupXBeos2Ban5cUTU0-JujS3Os/edit?usp=sharing
{% endcomment %}

Quando o estado do seu aplicativo muda
(por exemplo, o usuário vira um interruptor na tela de configurações),
você muda o estado e isso aciona um redesenho da interface do usuário.
Não há alteração imperativa da própria UI
(como `widget.setText`)&mdash;você muda o estado
e a UI é reconstruída do zero.

Leia mais sobre a abordagem declarativa para programação de UI
no [guia de primeiros passos][].

O estilo declarativo de programação de UI tem muitos benefícios.
Notavelmente, existe apenas um caminho de código para qualquer estado da UI.
Você descreve como a UI deve ser
para qualquer estado dado, uma vez&mdash;e isso é tudo.

A princípio,
este estilo de programação pode não parecer tão intuitivo quanto o
estilo imperativo. É por isso que esta seção está aqui. Continue lendo.

[guia de primeiros passos]: /get-started/flutter-for/declarative
