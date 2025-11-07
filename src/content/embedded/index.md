---
ia-translate: true
title: Suporte embarcado para Flutter
description: >
  Detalhes de como o Flutter suporta a criação de experiências embarcadas.
---

Se você gostaria de incorporar o engine Flutter em um carro,
uma geladeira, um termostato... você PODE! Por exemplo,
você pode incorporar Flutter nas seguintes situações:

* Usar Flutter em um "dispositivo embarcado",
  tipicamente um dispositivo de hardware de baixa potência
  como um display inteligente, um termostato ou similar.
* Incorporar Flutter em um novo sistema operacional ou
  ambiente, por exemplo uma nova plataforma móvel
  ou um novo sistema operacional.

A capacidade de incorporar Flutter, embora estável,
usa API de baixo nível e _não_ é para iniciantes.
Além dos recursos listados abaixo, você
pode considerar entrar no [Discord][], onde desenvolvedores
Flutter (incluindo engenheiros do Google) discutem
vários aspectos do Flutter. A página da
[comunidade][community] tem informações sobre mais recursos
da comunidade.

* [Custom Flutter Engine Embedders][], na wiki do Flutter.
* Os comentários de documentação no
  [arquivo `embedder.h` do engine Flutter][Flutter engine `embedder.h` file] no GitHub.
* A [visão geral arquitetural do Flutter][Flutter architectural overview] em docs.flutter.dev.
* Um pequeno exemplo autocontido de [Flutter Embedder Engine GLFW][Flutter Embedder Engine GLFW example]
  no repositório do GitHub do engine Flutter.
* Uma exploração sobre [incorporar Flutter em um terminal][embedding Flutter in a terminal]
  implementando a API de embedder personalizada do Flutter.
* [Issue 31043][]: _Questions for porting flutter engine to
  a new os_ também pode ser útil.


[community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/N7Yshp4
[Custom Flutter Engine Embedders]: {{site.repo.flutter}}/blob/main/engine/src/flutter/docs/Custom-Flutter-Engine-Embedders.md
[Flutter architectural overview]: /resources/architectural-overview
[Flutter engine `embedder.h` file]: {{site.repo.flutter}}/blob/main/engine/src/flutter/shell/platform/embedder/embedder.h
[Flutter Embedder Engine GLFW example]: {{site.repo.flutter}}/tree/main/engine/src/flutter/examples/glfw#flutter-embedder-engine-glfw-example
[embedding Flutter in a terminal]: https://github.com/jiahaog/flt
[Issue 31043]: {{site.repo.flutter}}/issues/31043


