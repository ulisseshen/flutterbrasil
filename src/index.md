---
title: Documentação do Flutter
short-title: Documentação
description: Comece a usar o Flutter. Widgets, exemplos, atualizações e documentação de API para ajudá-lo a escrever seu primeiro aplicativo Flutter.
show_translate: true
---

{% for card in site.data.docs_cards -%}
  {% capture index0Modulo3 -%}{{ forloop.index0 | modulo:3 }}{% endcapture -%}
  {% capture indexModulo3 -%}{{ forloop.index | modulo:3 }}{% endcapture -%}
  {% if index0Modulo3 == '0' -%}
  <div class="card-deck mb-4">
  {% endif -%}
    <a class="card" href="{{card.url}}">
      <div class="card-body">
        <header class="card-title">{{card.name}}</header>
        <p class="card-text">{{card.description}}</p>
      </div>
    </a>
  {% if indexModulo3 == '0' -%}
  </div>
  {% endif -%}
{% endfor %}

**Para ver as alterações no site desde nosso último lançamento,
confira [O que há de novo][].**

[O que há de novo]: {{site.url}}/release/whats-new

## Novo no Flutter?

Depois de passar por [Começando][],
incluindo [Escrevendo seu primeiro app Flutter][],
aqui estão alguns próximos passos.

[Escrevendo seu primeiro app Flutter]: {{site.url}}/get-started/codelab

### Documentação

Vindo de outra plataforma? Confira o Flutter para desenvolvedores de:
[Android][], [SwiftUI][], [UIKit][], [React Native][], e
[Xamarin.Forms][].

[Construindo layouts][]
: Aprenda como criar layouts no Flutter,
  onde tudo é um widget.

[Compreendendo as restrições][]
: Uma vez que você compreende que "As restrições
  fluem de cima para baixo. Tamanhos fluem de baixo para cima. Os pais definem
  as posições", então você está bem encaminhado para entender o modelo de layout do Flutter.

[Adicionando interatividade ao seu app Flutter][interatividade]
: Aprenda como adicionar um widget com estado ao seu aplicativo.


[Um tour pelo framework de widgets do Flutter][]
: Aprenda mais sobre o framework de estilo React do Flutter.

[FAQ][]
: Obtenha as respostas para perguntas frequentes.

[Um tour pelo framework de widgets do Flutter]: {{site.url}}/ui/widgets-intro
[Android]: {{site.url}}/get-started/flutter-for/android-devs
[Construindo layouts]: {{site.url}}/ui/layout
[FAQ]: {{site.url}}/resources/faq
[Começando]: {{site.url}}/get-started/install
[interatividade]: {{site.url}}/ui/interactive
[SwiftUI]: {{site.url}}/get-started/flutter-for/swiftui-devs
[UIKit]: {{site.url}}/get-started/flutter-for/uikit-devs
[React Native]: {{site.url}}/get-started/flutter-for/react-native-devs
[Compreendendo as restrições]: {{site.url}}/ui/layout/constraints
[web]: {{site.url}}/get-started/flutter-for/web-devs
[Xamarin.Forms]: {{site.url}}/get-started/flutter-for/xamarin-forms-devs

### Vídeos

Confira a série Introdução ao Flutter.
Aprenda conceitos básicos do Flutter como
[como fazer meu primeiro aplicativo Flutter?][primeiro-app]
No Flutter, "tudo é um widget"!
Saiba mais sobre os widgets `Stateless` e `Stateful`
em [O que é Estado?][]

<div class="card-deck card-deck--responsive">
    <div class="video-card">
        <div class="card-body">
            <iframe style="max-width: 100%; width: 100%; height: 230px;" src="{{site.youtube-site}}/embed/xWV71C2kp38" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> 
        </div>
    </div>
    <div class="video-card">
        <div class="card-body">
            <iframe style="max-width: 100%; width: 100%; height: 230px;" src="{{site.youtube-site}}/embed/QlwiL_yLh6E" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> 
        </div>
    </div>
</div>

[primeiro-app]: {{site.youtube-site}}/watch?v=xWV71C2kp38
[O que é Estado?]: {{site.youtube-site}}/watch?v=QlwiL_yLh6E

{:.text-center}
<b>Só tem 60 segundos? Aprenda a criar e implantar um app Flutter!</b>

<div style="display: flex; align-items: center; justify-content: center; flex-direction: column;">
  <iframe style="max-width: 100%" width="560" height="315" src="{{site.youtube-site}}/embed/ZnufaryH43s" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

## Quer melhorar suas habilidades?

Aprofunde-se no funcionamento interno do Flutter!
Descubra [por que você escreve widgets autônomos em vez de
usar métodos auxiliares][standalone-widgets] ou
[o que é "BuildContext" e como é usado][buildcontext]?

<div class="card-deck card-deck--responsive">
    <div class="video-card">
        <div class="card-body">
            <iframe style="max-width: 100%; width: 100%; height: 230px;" src="{{site.youtube-site}}/embed/IOyq-eTRhvo" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> 
        </div>
    </div>
    <div class="video-card">
        <div class="card-body">
            <iframe style="max-width: 100%; width: 100%; height: 230px;" src="{{site.youtube-site}}/embed/rIaaH87z1-g" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe> 
        </div>
    </div>
</div>

[standalone-widgets]: {{site.youtube-site}}/watch?v=IOyq-eTRhvo   
[buildcontext]: {{site.youtube-site}}/watch?v=rIaaH87z1-g

Para saber mais sobre todas as séries de vídeos do Flutter,
confira nossa página de [vídeos][].

Lançamos novos vídeos quase todas as semanas no canal do Flutter no YouTube:

<a class="btn btn-primary" target="_blank" href="https://www.youtube.com/@flutterdev">Explore mais vídeos do Flutter</a>

**A documentação deste site reflete a versão estável mais recente do Flutter.**

[vdeos]: {{site.url}}/resources/videos
