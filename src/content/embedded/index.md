---
ia-translate: true
title: Suporte embedded para Flutter
description: >
  Detalhes de como Flutter suporta a criação de experiências embedded.
---

Se você gostaria de incorporar o Flutter engine em um carro,
uma geladeira, um termostato... você PODE! Por exemplo,
você pode incorporar Flutter nas seguintes situações:

* Usando Flutter em um "dispositivo embedded",
  tipicamente um dispositivo de hardware de baixa potência
  como um smart-display, um termostato, ou similar.
* Incorporando Flutter em um novo sistema operacional ou
  ambiente, por exemplo uma nova plataforma mobile
  ou um novo sistema operacional.

A capacidade de incorporar Flutter, embora estável,
usa API de baixo nível e _não é_ para iniciantes.
Além dos recursos listados abaixo, você
pode considerar entrar no [Discord][Discord], onde desenvolvedores Flutter
(incluindo engenheiros do Google) discutem
vários aspectos do Flutter. A página de
[community][community] do Flutter tem informações sobre mais recursos
da comunidade.

* [Custom Flutter Engine Embedders][Custom Flutter Engine Embedders], na wiki do Flutter.
* Os comentários de documentação no
  [arquivo `embedder.h` do Flutter engine][Flutter engine `embedder.h` file] no GitHub.
* A [visão geral arquitetural do Flutter][Flutter architectural overview] em docs.flutter.dev.
* Um pequeno e independente [exemplo Flutter Embedder Engine GLFW][Flutter Embedder Engine GLFW example]
  no repositório GitHub do Flutter engine.
* Uma exploração sobre [incorporar Flutter em um terminal][embedding Flutter in a terminal] ao
  implementar a API de embedder customizado do Flutter.
* [Issue 31043][Issue 31043]: _Questions for porting flutter engine to
  a new os_ pode também ser útil.


[community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/N7Yshp4
[Custom Flutter Engine Embedders]: {{site.repo.flutter}}/blob/main/docs/engine/Custom-Flutter-Engine-Embedders.md
[Flutter architectural overview]: /resources/architectural-overview
[Flutter engine `embedder.h` file]: {{site.repo.flutter}}/blob/main/engine/src/flutter/shell/platform/embedder/embedder.h
[Flutter Embedder Engine GLFW example]: {{site.repo.flutter}}/tree/main/engine/src/flutter/examples/glfw#flutter-embedder-engine-glfw-example
[embedding Flutter in a terminal]: https://github.com/jiahaog/flt
[Issue 31043]: {{site.repo.flutter}}/issues/31043
