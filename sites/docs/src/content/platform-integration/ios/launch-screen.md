---
ia-translate: true
title: Adicionando uma tela de lançamento ao seu app iOS
shortTitle: Tela de lançamento
description: Aprenda como adicionar uma tela de lançamento ao seu app iOS.
showToc: false
---

{% comment %}
Consider introducing an image here similar to the android splash-screen one:
https://github.com/flutter/website/issues/8357
{% endcomment -%}

[Telas de lançamento][Launch screens] fornecem uma experiência inicial simples enquanto seu app iOS carrega.
Elas preparam o cenário para sua aplicação, permitindo tempo para que o app engine
carregue e seu app seja inicializado.

[Launch screens]: {{site.apple-dev}}/design/human-interface-guidelines/launching#Launch-screens

Todos os apps enviados para a Apple App Store
[devem fornecer uma tela de lançamento][apple-requirement]
com um storyboard do Xcode.

## Customize the launch screen

O template Flutter padrão inclui um
storyboard do Xcode chamado `LaunchScreen.storyboard`
que pode ser personalizado com seus próprios assets.
Por padrão, o storyboard exibe uma imagem em branco,
mas você pode alterar isso. Para fazer isso,
abra o projeto Xcode do app Flutter
digitando `open ios/Runner.xcworkspace`
a partir da raiz do diretório do seu app.
Em seguida, selecione `Runner/Assets.xcassets`
no Project Navigator e
arraste as imagens desejadas para o conjunto de imagens `LaunchImage`.

A Apple fornece orientações detalhadas para telas de lançamento como
parte das [Diretrizes de Interface Humana][Human Interface Guidelines].

[apple-requirement]: {{site.apple-dev}}/documentation/xcode/specifying-your-apps-launch-screen
[Human Interface Guidelines]: {{site.apple-dev}}/design/human-interface-guidelines/patterns/launching#launch-screens
