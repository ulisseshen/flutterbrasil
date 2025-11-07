---
ia-translate: true
title: Adicionando uma launch screen ao seu app iOS
short-title: Launch screen
description: Aprenda como adicionar uma launch screen ao seu app iOS.
toc: false
---

{% comment %}
Consider introducing an image here similar to the android splash-screen one:
https://github.com/flutter/website/issues/8357
{% endcomment -%}

[Launch screens][] fornecem uma experiência inicial simples enquanto seu app iOS carrega.
Elas preparam o cenário para sua aplicação, enquanto permitem tempo para que o mecanismo do app
carregue e seu app inicialize.

[Launch screens]: {{site.apple-dev}}/design/human-interface-guidelines/launching#Launch-screens

Todos os apps submetidos à Apple App Store
[devem fornecer uma launch screen][apple-requirement]
com um storyboard do Xcode.

## Personalizar a launch screen

O template padrão do Flutter inclui um
storyboard do Xcode chamado `LaunchScreen.storyboard`
que pode ser personalizado com seus próprios assets.
Por padrão, o storyboard exibe uma imagem em branco,
mas você pode mudar isso. Para fazer isso,
abra o projeto Xcode do app Flutter
digitando `open ios/Runner.xcworkspace`
a partir da raiz do diretório do seu app.
Em seguida, selecione `Runner/Assets.xcassets`
no Project Navigator e
solte as imagens desejadas no conjunto de imagens `LaunchImage`.

A Apple fornece orientação detalhada para launch screens como
parte das [Human Interface Guidelines][].

[apple-requirement]: {{site.apple-dev}}/documentation/xcode/specifying-your-apps-launch-screen
[Human Interface Guidelines]: {{site.apple-dev}}/design/human-interface-guidelines/patterns/launching#launch-screens
