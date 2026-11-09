---
title: Design Cupertino para Flutter
description: Aprenda sobre o design Cupertino para Flutter.
ia-translate: true
---

O pacote Cupertino do Flutter é uma coleção
de widgets que implementam a linguagem de design iOS da Apple
para apps Flutter. Os widgets têm uma aparência
e comportamento similares ao iOS, incluindo cantos arredondados, gradientes,
e design minimalista.
Eles também incluem interações e animações do iOS.

Anteriormente, o Cupertino fazia parte do Flutter SDK principal,
mas foi desacoplado do framework.
Você pode acessar o Cupertino pelo pacote [`cupertino_ui`][] no pub.dev.

[`cupertino_ui`]: {{site.pub}}/packages/cupertino_ui

O vídeo de 15 minutos a seguir fornece uma visão geral
do pacote Cupertino:

<YouTubeEmbed id="3PdUaidHc-E" title="Flutter's Cupertino Package"></YouTubeEmbed>

Para ver alguns widgets Cupertino em ação, os vídeos a seguir da
série Widget of the Week cobrem alguns deles.

<div class="card-grid">
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="D0xwcz2IqAY" title="CupertinoRadio (Widget of the Week)"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="5H-WvH5O29I" title="CupertinoSheetRoute (Widget of the Week)"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="esnBf6V4C34" title="CupertinoSlidingSegmentedControl (Widget of the Week)"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="ua54JU7k1Us" title="CupertinoCheckbox (Widget of the Week)"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="24tg_N4sdMQ" title="CupertinoSwitch (Widget of the Week)"></YouTubeEmbed>
    </div>
  </div>
</div>

## Mais informações {:.no_toc #more-information}

Para aprender mais sobre o uso do pacote Cupertino
com Flutter,
confira os seguintes recursos:

* O (principalmente visual) [catálogo de widgets Cupertino][Cupertino widget catalog]
* A página da [biblioteca Cupertino][Cupertino library] no pub.dev
* Os [exemplos da API Cupertino][Cupertino API examples] no repositório flutter/flutter.
  ([Instruções][Instructions]) Por exemplo,
  para executar `CupertinoSwitch`:

```console
cd path/to/flutter
cd examples/api
flutter run lib/cupertino/switch/cupertino_switch.0.dart
```

[Cupertino API examples]: {{site.repo.flutter}}/tree/main/examples/api/lib/cupertino
[Cupertino library]: {{site.pub}}/packages/cupertino_ui
[Cupertino widget catalog]: /ui/widgets/cupertino
[Instructions]: {{site.repo.flutter}}/tree/main/examples/api#api-example-code
