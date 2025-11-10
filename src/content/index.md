---
ia-translate: true
title: Documentação Flutter
shortTitle: Docs
description: >-
  Comece com Flutter. Widgets, exemplos, atualizações e documentação de APIs para
  ajudá-lo a escrever seu primeiro app Flutter.
---

<div class="card-grid">
{% for card in docsCards -%}
  <Card title="{{card.name}}" link="{{card.url}}" outlined="true">
    {{card.description}}
  </Card>
{% endfor -%}
</div>

**Para ver as mudanças no site desde nosso último release,
veja [What's new][What's new].**

[What's new]: /release/whats-new

## Novo no Flutter?

Pronto para construir apps bonitos e multiplataforma a partir de uma única base de código?
Este vídeo apresenta os fundamentos do Flutter e mostra como começar.

Depois de [configurar o Flutter][Set up Flutter],
você deve seguir o
codelab [Write your first Flutter app][Write your first Flutter app]
e ler [Flutter fundamentals][Flutter fundamentals].
Esses recursos são documentação opinativa
que guia você pelas partes mais importantes
da construção de um app Flutter.

[Write your first Flutter app]: /get-started/codelab
[Flutter fundamentals]: /get-started/fundamentals

### Docs

Vindo de outra plataforma? Confira Flutter para desenvolvedores:
[Android][Android], [SwiftUI][SwiftUI], [UIKit][UIKit], [React Native][React Native] e
[Xamarin.Forms][Xamarin.Forms].

[Construindo layouts][Building layouts]
: Aprenda como criar layouts no Flutter,
  onde tudo é um [widget](/resources/glossary#widget).

[Entendendo restrições][Understanding constraints]
: Uma vez que você entenda que "Constraints
  flow down. Sizes flow up. Parents set
  positions", então você está no caminho certo
  para entender o modelo de layout do Flutter.

[Adicionando interatividade ao seu app Flutter][interactivity]
: Aprenda como adicionar um stateful widget ao seu app.

[FAQ][FAQ]
: Obtenha respostas para perguntas frequentes.

[Android]: /get-started/flutter-for/android-devs
[Building layouts]: /ui/layout
[FAQ]: /resources/faq
[Set up Flutter]: /get-started
[interactivity]: /ui/interactivity
[SwiftUI]: /get-started/flutter-for/swiftui-devs
[UIKit]: /get-started/flutter-for/uikit-devs
[React Native]: /get-started/flutter-for/react-native-devs
[Understanding constraints]: /ui/layout/constraints
[Xamarin.Forms]: /get-started/flutter-for/xamarin-forms-devs

### Videos

<div class="video-wrapper">
  <span class="video-intro">Confira as novidades do Flutter no Google I/O 2025!</span>
  <YouTubeEmbed id="v6Rzo5khNE8" title="What's new in Flutter" fullWidth></YouTubeEmbed>
</div>
<br>

Para mais Flutter no Google I/O 2025, confira
[How to build agentic apps with Flutter and Firebase AI Logic][How to build agentic apps with Flutter and Firebase AI Logic]
e [How Flutter makes the most of your platforms][How Flutter makes the most of your platforms].

<div class="card-grid">
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="xo271p-Fl_4" title="How to build agentic apps with Flutter and Firebase AI Logic"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="flwULzNYRac" title="How Flutter makes the most of your platforms"></YouTubeEmbed>
    </div>
  </div>
</div>

[How to build agentic apps with Flutter and Firebase AI Logic]: {{site.yt.watch}}?v=xo271p-Fl_4
[How Flutter makes the most of your platforms]: {{site.yt.watch}}?v=flwULzNYRac

Para saber sobre todas as séries de vídeos do Flutter, veja nossa página de [videos][videos].

Lançamos novos vídeos quase toda semana!

<a class="filled-button" target="_blank" href="https://www.youtube.com/@flutterdev">Confira o canal do Flutter no YouTube</a>

[videos]: /resources/videos
