---
ia-translate: true
title: Adicionando uma tela de inicialização ao seu aplicativo iOS
short-title: Tela de inicialização
description: Aprenda como adicionar uma tela de inicialização ao seu aplicativo iOS.
toc: false
---

{% comment %}
Considere introduzir uma imagem aqui semelhante à da tela inicial do Android:
https://github.com/flutter/website/issues/8357
{% endcomment -%}

[Telas de inicialização][] fornecem uma experiência inicial simples enquanto seu aplicativo iOS carrega. Elas preparam o cenário para seu aplicativo, enquanto dão tempo para o motor do aplicativo carregar e seu aplicativo inicializar.

[Telas de inicialização]: {{site.apple-dev}}/design/human-interface-guidelines/launching#Launch-screens

Todos os aplicativos enviados para a Apple App Store
[devem fornecer uma tela de inicialização][apple-requirement]
com um storyboard do Xcode.

## Personalize a tela de inicialização

O modelo padrão do Flutter inclui um storyboard do Xcode
chamado `LaunchScreen.storyboard`
que pode ser personalizado com seus próprios recursos.
Por padrão, o storyboard exibe uma imagem em branco,
mas você pode alterar isso. Para fazer isso,
abra o projeto Xcode do aplicativo Flutter
digitando `open ios/Runner.xcworkspace`
a partir da raiz do diretório do seu aplicativo.
Em seguida, selecione `Runner/Assets.xcassets`
no Project Navigator e
solte as imagens desejadas no conjunto de imagens `LaunchImage`.

A Apple fornece orientação detalhada para telas de inicialização como
parte das [Diretrizes de Interface Humana][].

[apple-requirement]: {{site.apple-dev}}/documentation/xcode/specifying-your-apps-launch-screen
[Diretrizes de Interface Humana]: {{site.apple-dev}}/design/human-interface-guidelines/patterns/launching#launch-screens
