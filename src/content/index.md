---
title: Documentação do Flutter
short-title: Docs
description: Comece com Flutter. Widgets, exemplos, atualizações e API docs para ajudar a criar seu primeiro app Flutter.
---

<div class="card-grid">
{% for card in docs_cards -%}
    <a class="card" href="{{card.url}}">
      <div class="card-body">
        <header class="card-title">{{card.name}}</header>
        <p class="card-text">{{card.description}}</p>
      </div>
    </a>
{% endfor %}
</div>

**Para ver mudanças no site desde nosso último lançamento, 
veja [O que há de novo][].**

[O que há de novo]: /release/whats-new

## Novo no Flutter?

Depois de [Configurar o Flutter][],
siga o codelab 
[Escreva seu primeiro app Flutter][]
e leia [Fundamentos do Flutter][].
Esses recursos são documentações opinativas 
que guiam você pelos
aspectos mais importantes de construir um app Flutter.

[Escreva seu primeiro app Flutter]: /get-started/codelab
[Fundamentos do Flutter]: /get-started/fundamentals

### Documentação

Vindo de outra plataforma? Veja Flutter para:
[Android][], [SwiftUI][], [UIKit][], [React Native][] e
[Xamarin.Forms][] developers.

[Construindo layouts][]
: Aprenda como criar layouts no Flutter,
  onde tudo é um widget.

[Entendendo constraints][]
: Assim que você entender que "Constraints
  descem. Tamanhos sobem. Pais definem posições",
  estará no caminho para entender o modelo
  de layout do Flutter.

[Adicionando interatividade ao seu app Flutter][interactivity]
: Aprenda como adicionar um widget stateful ao seu app.

[FAQ][]
: Obtenha respostas para perguntas frequentes.

[Android]: /get-started/flutter-for/android-devs
[Construindo layouts]: /ui/layout
[FAQ]: /resources/faq
[Configurar o Flutter]: /get-started/install
[interactivity]: /ui/interactivity
[SwiftUI]: /get-started/flutter-for/swiftui-devs
[UIKit]: /get-started/flutter-for/uikit-devs
[React Native]: /get-started/flutter-for/react-native-devs
[Entendendo constraints]: /ui/layout/constraints
[Xamarin.Forms]: /get-started/flutter-for/xamarin-forms-devs

### Vídeos

Confira a série "Introducing Flutter".
Aprenda conceitos básicos como
[como criar meu primeiro app Flutter?][first-app].
No Flutter, "tudo é um widget"!
Descubra mais sobre `Stateless` e `Stateful`
widgets em [What is State?][].

<div class="card-grid">
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'xWV71C2kp38', 'Create your first Flutter app', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'QlwiL_yLh6E', 'What is state?', true, true %}
        </div>
    </div>
</div>

[first-app]: {{site.yt.watch}}?v=xWV71C2kp38
[What is State?]: {{site.yt.watch}}?v=QlwiL_yLh6E

{% videoWrapper 'Só tem 60 segundos? Aprenda como criar e publicar um app Flutter!' %}
{% ytEmbed 'ZnufaryH43s', 'Como criar e publicar um app Flutter em 60 segundos!', true %}
{% endvideoWrapper %}

## Quer melhorar suas habilidades?

Aprofunde-se no funcionamento interno do Flutter!
Descubra [por que criar widgets standalone ao
invés de usar métodos helpers][standalone-widgets] ou
[o que é "BuildContext" e como é usado][buildcontext].

<div class="card-grid">
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'IOyq-eTRhvo', 'Widgets vs helper methods | Decoding Flutter', true, true %}
        </div>
    </div>
    <div class="card">
        <div class="card-body">
            {% ytEmbed 'rIaaH87z1-g', 'BuildContext?! | Decoding Flutter', true, true %}
        </div>
    </div>
</div>

[standalone-widgets]: {{site.yt.watch}}?v=IOyq-eTRhvo
[buildcontext]: {{site.yt.watch}}?v=rIaaH87z1-g

Para saber sobre todas as séries de vídeos do Flutter,
veja nossa página de [vídeos][].

Lançamos novos vídeos quase toda semana no canal
Flutter no YouTube:

<a class="btn btn-primary" target="_blank" href="https://www.youtube.com/@flutterdev">Explore mais vídeos do Flutter</a>

[vídeos]: /resources/videos
