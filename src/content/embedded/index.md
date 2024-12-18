---
ia-translate: true
title: Suporte Embarcado para Flutter
description: >
  Detalhes de como o Flutter suporta a criação de experiências embarcadas.
---

Se você gostaria de embutir o motor do Flutter em um carro,
uma geladeira, um termostato... você PODE! Por exemplo,
você pode embutir o Flutter nas seguintes situações:

* Usar Flutter em um "dispositivo embarcado",
  tipicamente um dispositivo de hardware de baixa potência
  como um smart-display, um termostato ou similar.
* Embutir Flutter em um novo sistema operacional ou
  ambiente, por exemplo, uma nova plataforma móvel
  ou um novo sistema operacional.

A capacidade de embutir o Flutter, embora estável,
usa API de baixo nível e _não_ é para iniciantes.
Além dos recursos listados abaixo, você
pode considerar participar do [Discord][], onde desenvolvedores
Flutter (incluindo engenheiros do Google) discutem
vários aspectos do Flutter. A página da [comunidade][] do Flutter
tem informações sobre mais recursos da comunidade.

* [Custom Flutter Engine Embedders][], na wiki do Flutter.
* Os comentários da documentação no
  [arquivo `embedder.h` do motor do Flutter][] no GitHub.
* A [visão geral da arquitetura do Flutter][] em docs.flutter.dev.
* Um pequeno e autocontido [exemplo de Flutter Embedder Engine GLFW][]
  no repositório do motor Flutter no GitHub.
* Uma exploração sobre [embutir Flutter em um terminal][] através da
  implementação da API custom embedder do Flutter.
* [Issue 31043][]: _Perguntas para portar o motor do flutter para
  um novo sistema operacional_ também pode ser útil.


[community]: {{site.main-url}}/community
[Discord]: https://discord.com/invite/N7Yshp4
[Custom Flutter Engine Embedders]: {{site.repo.engine}}/blob/main/docs/Custom-Flutter-Engine-Embedders.md
[visão geral da arquitetura do Flutter]: /resources/architectural-overview
[arquivo `embedder.h` do motor do Flutter]: {{site.repo.engine}}/blob/main/shell/platform/embedder/embedder.h
[exemplo de Flutter Embedder Engine GLFW]: {{site.repo.engine}}/tree/main/examples/glfw#flutter-embedder-engine-glfw-example
[embutir Flutter em um terminal]: https://github.com/jiahaog/flt
[Issue 31043]: {{site.repo.flutter}}/issues/31043