---
ia-translate: true
title: Catálogo de widgets
description: Um catálogo de alguns dos ricos widgets do Flutter.
shortTitle: Widgets
showToc: false
---

Crie apps bonitos mais rapidamente com a coleção de widgets visuais, estruturais,
de plataforma e interativos do Flutter. Além de navegar pelos widgets por categoria,
você também pode ver todos os widgets no [índice de widgets][widget index].

## Design systems

A biblioteca [`widgets`][], de estilo neutro, é distribuída com o Flutter SDK.
Dois pacotes de design de UI ([`material_ui`][] e [`cupertino_ui`][]) são
construídos sobre `widgets` e estão disponíveis no [pub.dev]({{site.pub}}),
o repositório de pacotes para Dart e Flutter.

[`cupertino_ui`]: {{site.pub}}/packages/cupertino_ui
[`material_ui`]: {{site.pub}}/packages/material_ui
[`widgets`]: {{site.api}}/flutter/widgets/

<div class="card-grid">
  <Card title="Cupertino" link="/ui/widgets/cupertino" outlined="true" filled="false">
    Widgets bonitos e de alta fidelidade que seguem as
    Human Interface Guidelines da Apple para iOS e macOS.
  </Card>
  <Card title="Material design" link="/ui/widgets/material" outlined="true" filled="false">
    Widgets visuais, comportamentais e ricos em movimento que implementam
    a especificação de design Material 3.
  </Card>
</div>

Você pode encontrar mais design systems criados pela comunidade Flutter no pub.dev.
Por exemplo, o [fluent_ui][] inspirado no Windows,
o [macos_ui][] inspirado no macOS,
e os widgets [yaru][] inspirados no Ubuntu.

[fluent_ui]: {{site.pub-pkg}}/fluent_ui
[macos_ui]: {{site.pub-pkg}}/macos_ui
[yaru]: {{site.pub-pkg}}/yaru

## Base widgets

Os widgets base suportam uma variedade de opções comuns de renderização
como input, layout e texto.

<WidgetCatalogCategories />

## Widget of the Week

Mais de 100 vídeos explicativos curtos de 1 minuto para
ajudá-lo a começar rapidamente com os widgets do Flutter.

<div class="card-grid wide">
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="D0xwcz2IqAY" title="CupertinoRadio - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="5H-WvH5O29I" title="CupertinoSheetRoute - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="esnBf6V4C34" title="CupertinoSlidingSegmentedControl - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="ua54JU7k1Us" title="CupertinoCheckbox - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="24tg_N4sdMQ" title="CupertinoSwitch - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
  <div class="card wrapped-card outlined-card">
    <div class="card-content">
      <YouTubeEmbed id="GQ8ajYVF0bo" title="CarouselView - Flutter widget of the week"></YouTubeEmbed>
    </div>
  </div>
</div>

<a class="filled-button" target="_blank" href="{{site.yt.playlist}}PLjxrf2q8roU23XGwz3Km7sQZFTdB996iG">Assista mais vídeos do widget of the week</a>

[widget index]: /reference/widgets
